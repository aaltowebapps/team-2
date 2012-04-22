require 'digest/md5'

class PresentationsController < ApplicationController

  # user must be logged in
  before_filter :check_login
  after_filter :set_access_control_headers

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end

  def check_login
	  if not user_signed_in? # redirect to login
		  redirect_to "/users/sign_in" and return
	  end
  end

  # GET /presentations
  # GET /presentations.json
  def index
    @presentations = Presentation.where(:owner => current_user.id).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @presentations }
    end
  end

  # GET /presentations/1
  # GET /presentations/1.json
  def show
    @presentation = Presentation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @presentation }
    end
  end

  # GET /presentations/new
  # GET /presentations/new.json
  def new
    @presentation = Presentation.new


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @presentation }
    end
  end

  # get /presentations/1/edit
  def edit
    @presentation = Presentation.find(params[:id])
  end

  def upload

  end

  def file_upload
    # file handling
    name = params[:presentation][:slide_file].original_filename
    digestName = Digest::MD5.hexdigest(name + current_user.id.to_s + Time.now.to_s ) + ".html"# todo: improve

    file = params[:presentation][:slide_file]
    path = File.join("public/slides", digestName)
    File.open(path, "wb") { |f| f.write(file.read) }
    @notice_msg = "default"
    # js injection
    moco_injection = "<script src=\"/assets/moco.js\"></script>
      <script>
	      $(document).ready(function() { Moco.init("+ params[:id] +",1000); });
        </script></body>"

    content = File.read(path)
    if content =~ /<\/body>/
      injected = content.gsub(/<\/body>/,  moco_injection)
      File.open(path, "wb") { |f| f.puts injected }
      @notice_msg = "success"
    else # end of the body not found
      @notice_msg = "unable to set up presentation"
    end

    # save presentation url
    @presentation = Presentation.find(params[:id])
    @presentation.currentSlide = 0
    @presentation.url = "slides/" + digestName
    @presentation.save

    redirect_to :action => "index", :notice => @notice_msg
  end


  # POST /presentations
  # POST /presentations.json
  def create
    @presentation = Presentation.new(params[:presentation])
    @presentation.owner = current_user.id

    respond_to do |format|
      if @presentation.save
        format.html { render action: "upload" }
      else
        format.html { render action: "new" }
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # put /presentations/1
  # PUT /presentations/1.json
  def update
    @presentation = Presentation.find(params[:id])

    respond_to do |format|
      if @presentation.update_attributes(params[:presentation])
        format.html { redirect_to @presentation, notice: 'Presentation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /presentations/1
  # DELETE /presentations/1.json
  def destroy
    @presentation = Presentation.find(params[:id])
    @presentation.destroy

    respond_to do |format|
      format.html { redirect_to presentations_url }
      format.json { head :no_content }
    end
  end

  # GET /presentations/1/view
  def view
    @presentation = Presentation.find(params[:id])
    redirect_to @presentation.url
  end

  # GET /presentations/1/control
  def control
     @presentation = Presentation.find(params[:id])
  end

  # post /presentations/1/slideUpdate
  def slideUpdate

    @presentation = Presentation.find(params[:id])

    # check that user is owner of slides
    if current_user.id == @presentation.owner
      @presentation.currentSlide = params[:slide]
      @presentation.save
      @status = "succeeded"
    else
      @status = "failed"
    end

    render json: { :status => @status }
  end

  # get /presentations/1/status
  def status
    @presentation = Presentation.find(params[:id])
    render json: { :currentSlide => @presentation.currentSlide  }
  end

end
