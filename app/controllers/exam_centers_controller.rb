class ExamCentersController < ApplicationController
  before_action :load_resource, :only => [:show, :edit, :update, :destroy, :machine_availability, :today_exams]
  before_action :set_gon_data, :except => [:index, :new, :create, :today_exams]
  authorize_resource

  def index
    if params[:search].present?
      @exam_centers = ExamCenter.search(params[:search]).paginate(:page => 1)
    else
      page = params[:exam_center_page].present? ? params[:exam_center_page] : 1
      @exam_centers = ExamCenter.paginate(:page => page)
    end

    @map_data = GoogleMapProcessor.build_map_data(@exam_centers)
    gon.gmap_data = @map_data.to_json
    gon.width = "750px"
    gon.height = "350px"
    #@centers= ExamCentersDecorator.decorate_collection(@centers)
  end

  def new
    @exam_center = ExamCenter.new
  end

  def create
    @exam_center = ExamCenter.create(exam_center_params)
    if @exam_center.errors.present?
      @exam_center.errors.each do |key, message|
        if key.to_s == 'latitude' or key.to_s == 'longitude'
          flash.now[:error] = I18n.t :gmap_error, :scope => [:exam_center, :error]
        end
      end
      flash.now[:fail] = I18n.t :fail, :scope => [:exam_center, :create]
      render "new"
    else
      # @map_data = GoogleMapProcessor.build_map_data(@exam_center)
      # gon.gmap_data = @map_data.to_json
      flash.now[:success] = I18n.t :success, :scope => [:exam_center, :create]
      render "show"
    end
  end

  def destroy
    if @exam_center.destroy
      flash.now[:success] = I18n.t :success, :scope => [:exam_center, :destroy]
      redirect_to exam_centers_path
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:exam_center, :destroy]
    end
  end

  def edit
  end

  def update
    if @exam_center.update(exam_center_params)
      flash.now[:success] = I18n.t :success, :scope => [:exam_center, :update]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:exam_center, :update]
      render "edit"
    end
  end

  def machine_availability
    @date = session[:system_date]
    @date = Date.strptime(params[:date], '%d/%m/%Y') if params[:date].present?
    reg_processor = RegistrationProcessor.new(@date, @exam_center)
    reg_processor.prepare_grid
    @machine_slots = reg_processor.get_slots
  end

  def today_exams
    if params[:search].present?
      @registrations = @exam_center.registrations.search(params[:search]).dated_on(session[:system_date])
    else
      @registrations = @exam_center.registrations.dated_on(session[:system_date]).limit(50)
    end
    @registrations = RegistrationsDecorator.decorate_collection(@registrations)
  end

  private

  def exam_center_params
    params.require(:exam_center).permit(:center_name, :address_line1, :address_line2, :city, :state, :country, :pin, :center_email, :phone, :assigned_user_id)
  end

  def load_resource
    if params[:id].present?
      @exam_center = ExamCenter.find(params[:id])
    end
  end

  def set_gon_data
    @map_data = GoogleMapProcessor.build_map_data([@exam_center])
    gon.width = "450px"
    gon.height = "250px"
    gon.gmap_data = @map_data.to_json
  end


end
