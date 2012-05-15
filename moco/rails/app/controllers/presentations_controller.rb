require 'digest/md5'
require 'pusher'

Pusher.app_id = '666'
Pusher.key = 'ea86e9b8c9fefebb4468'
Pusher.secret = 'On Her Majesty\'s Secret Service'

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
      format.mobile
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
    method = "pusher" # pusher default
    moco_injection = inject(params[:id], method)

    content = File.read(path)
    if content =~ /<\/body>/
      injected = content.gsub(/<\/body>/,  moco_injection)
      File.open(path, "wb") { |f| f.puts injected }
      @notice_msg = "success"
    else # end of the body not found
      @notice_msg = "unable to set up presentation"
    end

    # save presentation
    @presentation = Presentation.find(params[:id])
    @presentation.currentSlide = 0
    @presentation.url = "slides/" + digestName
    @presentation.method = method
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
    if current_user.id != @presentation.owner
      Rails.logger.info("FAILDED!")
      @status = "failed"
      render json: {:status => @status}
    end

      Rails.logger.info("SUCCESS!")
    if @presentation.method == "pusher" #pusher controlling
      if params[:cmd] == "next"
        Pusher[@presentation.id.to_s + 'p'].trigger('s-update', {:cmd => 'fwd'})
        @presentation.currentSlide += 1
      elsif params[:cmd] == "prev"
        Pusher[@presentation.id.to_s + 'p'].trigger('s-update', {:cmd => 'bck'})
        @presentation.currentSlide -= 1
      end
    end

    if @presentation.method == "polling" #ajax-polling controlling
      @presentation.currentSlide = params[:slide].to_i
    end
    @presentation.save

    @status = "succeeded"

    render json: { :status => @status }

  end

  # get /presentations/1/status
  def status
    @presentation = Presentation.find(params[:id])
    render json: { :currentSlide => @presentation.currentSlide  }
  end

  # returns js to inject
  def inject(id, method)
    injection = ""
    case method
      when "polling" # plain ajax-polling
        injection = "<script src=\"/assets/moco.js\"></script>
              <script>
                $(document).ready(function() { Moco.init("+ id +",1000); });
              </script></body>"
      when "pusher" # pusher
        injection = "<script src=\"http://js.pusher.com/1.11/pusher.min.js\"></script>
                <script>
                  var pusher = new Pusher('" + Pusher.key + "');
                  var channel = pusher.subscribe('" + id + "p');
                  channel.bind('s-update', function(data) {
                    switch(data.cmd) {
                      case 'fwd':
                        $(\"#jmpress\").jmpress('next');
                        break;
                      case 'bck':
                        $(\"#jmpress\").jmpress('prev');
                        break;
                    };
                  });
                </script>"
    end
    return injection
  end

end
