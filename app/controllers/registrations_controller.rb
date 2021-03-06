class RegistrationsController < ApplicationController

def render_404
   # format.html { render :file => "#{Rails.root}/public/404.html", :status => :not_found }
    render :file => "#{Rails.root}/public/404.html", :status => :not_found
end

  # GET /registrations
  # GET /registrations.xml
  def index
    if params[:secret_key].nil? || params[:secret_key] != "!abcd1234"
      render_404() and return
    end
    @registrations = Registration.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @registrations }
      format.csv  { render_as_csv @registrations, "all_registrations_#{file_name_date_string}.csv" }
    end
  end

  # GET /registrations/1
  # GET /registrations/1.xml
  def show
    @registration = Registration.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @registration }
    end
  end

  # GET /registrations/new
  # GET /registrations/new.xml
  def new
    @registration = Registration.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @registration }
    end
  end

  # GET /registrations/1/edit
  def edit
    @registration = Registration.find(params[:id])
  end

  # POST /registrations
  # POST /registrations.xml
  def create
    @registration = Registration.new(params[:registration])

    respond_to do |format|
      if @registration.save
        flash[:notice] = 'Registration was successfully created.'
        format.html { redirect_to(thank_you_path) }
        format.xml  { render :xml => @registration, :status => :created, :location => @registration }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /registrations/1
  # PUT /registrations/1.xml
  def update
    @registration = Registration.find(params[:id])

    respond_to do |format|
      if @registration.update_attributes(params[:registration])
        flash[:notice] = 'Registration was successfully updated.'
        format.html { redirect_to(@registration) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.xml
  def destroy
    @registration = Registration.find(params[:id])
    @registration.destroy

    respond_to do |format|
      format.html { redirect_to(registrations_url) }
      format.xml  { head :ok }
    end
  end

  private
  def file_name_date_string
    Time.now.strftime("%Y%m%d")
  end

  def render_as_csv results, filename
    export_generator = ExportGenerator.new results, filename
    csv_data = export_generator.to_csv
    send_data(csv_data.data, csv_data.options)
  end
end
