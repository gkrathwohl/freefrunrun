require 'date'

class ResultsController < ApplicationController
  before_action :set_result, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => [:submit_times]

  def claim_result

    hashids = Hashids.new("secret race finish numbers", 4)
    @race_id = hashids.decode(params['race_hash']).first
    @place = hashids.decode(params['place_hash']).first

    @existing_result = Result.find_by(race_id: @race_id, place: @place)
    @already_claimed = @existing_result && @existing_result.athlete_id != nil

    @race_id_hash = params['race_hash']
    @place_hash = params['place_hash']

  end

  def submit_times
    times = params[:times]
    race_id = params[:raceId]
    times.each_with_index do |time, i|
      place = i + 1
      # todo, check if Result already exists (if someone claimed it before end of race)
      result = Result.find_or_initialize_by(race_id: race_id, place: place)
      result.time = time
      success = result.save!

    end

    render :json => {"result" => true}
  end

  def submit_claim

    hashids = Hashids.new("secret race finish numbers", 4)

    athlete = Athlete.new
    athlete.first_name = params['first_name']
    athlete.last_name = params['last_name']
    athlete.city = params['city']
    athlete.male = params['gender'] == "male" ? true : false
    athlete.birthdate = Date.new(params['year'].to_i, params['month'].to_i, 1)
    athlete.save

    race_id = hashids.decode(params['race_id_hash']).first
    place = hashids.decode(params['place_hash']).first

    result = Result.find_or_initialize_by(race_id: race_id, place: place)
    result.athlete_id = athlete.id
    success = result.save

    @race_id = result.race_id

    render 'submit_success'
  end


  # GET /results
  # GET /results.json
  def index
    @results = Result.all
  end

  # GET /results/1
  # GET /results/1.json
  def show
  end

  # GET /results/new
  def new
    @result = Result.new
  end

  # GET /results/1/edit
  def edit
  end

  # POST /results
  # POST /results.json
  def create
    @result = Result.new(result_params)

    respond_to do |format|
      if @result.save
        format.html { redirect_to @result, notice: 'Result was successfully created.' }
        format.json { render :show, status: :created, location: @result }
      else
        format.html { render :new }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /results/1
  # PATCH/PUT /results/1.json
  def update
    respond_to do |format|
      if @result.update(result_params)
        format.html { redirect_to @result, notice: 'Result was successfully updated.' }
        format.json { render :show, status: :ok, location: @result }
      else
        format.html { render :edit }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @result.destroy
    respond_to do |format|
      format.html { redirect_to results_url, notice: 'Result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_result
      @result = Result.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def result_params
      params.require(:result).permit(:race_id, :athlete_id, :place, :time)
    end
end
