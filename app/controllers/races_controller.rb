class RacesController < ApplicationController
  before_action :set_race, only: [:timer, :course, :results, :show, :edit, :update, :destroy]

  before_action :authenticate_user!, only: [:new, :create]

  def codes

    @qrs = []

    hashids = Hashids.new("secret race finish numbers", 4)
    race_hash = hashids.encode(params['id'])

    (1..10).each do |place|
      place_hash = hashids.encode(place)
      qr = RQRCode::QRCode.new("http://freefunrun.local:3000/qr/#{race_hash}/#{place_hash}", :size => 5, :level => :h )
      qr_data = qr.as_png.resize(300, 300).to_data_url

      @qrs.push(qr_data)
    end

    render :layout => false

  end

  def timer
    render :layout => false
  end

  def results
    @results = @race.results.includes(:athlete)

    @results_arr = []
    @results.each do |r| 
      @results_arr[r.place - 1] = r
    end

  end

  def course

  end

  # GET /races
  # GET /races.json
  def index
    @races = Race.all
  end

  # GET /races/1
  # GET /races/1.json
  def show
  end

  # GET /races/new
  def new
    @race = Race.new
  end

  # GET /races/1/edit
  def edit
  end

  # POST /races
  # POST /races.json
  def create
    @race = Race.new(race_params)
    @race.user_id = current_user.id

    respond_to do |format|
      if @race.save
        format.html { redirect_to user_path(@race.user_id), notice: 'Race was successfully created.' }
        format.json { render :show, status: :created, location: @race }
      else
        format.html { render :new }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /races/1
  # PATCH/PUT /races/1.json
  def update
    respond_to do |format|
      if @race.update(race_params)
        format.html { redirect_to @race, notice: 'Race was successfully updated.' }
        format.json { render :show, status: :ok, location: @race }
      else
        format.html { render :edit }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /races/1
  # DELETE /races/1.json
  def destroy
    @race.destroy
    respond_to do |format|
      format.html { redirect_to races_url, notice: 'Race was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_race
      @race = Race.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def race_params
      params.require(:race).permit(:name, :start_datetime)
    end
end
