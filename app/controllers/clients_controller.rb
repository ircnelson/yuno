class ClientsController < ApplicationController

	before_filter :find_client, :except => [:index, :new, :create]

  def index
    @clients = Client.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clients }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @client }
    end
  end

  def new
    @client = Client.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @client }
    end
  end

  def edit
  end

  def create
    @client = Client.new(params[:client])
    respond_to do |format|
      if @client.save
        flash[:notice] = successfull
        format.html { redirect_to(@client) }
        format.xml  { render :xml => @client, :status => :created, :location => @client }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @client.update_attributes(params[:client])
        flash[:notice] = successfull(:updated)
        format.html { redirect_to(@client) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to(clients_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  	def find_client
	  	@client = Client.find(params[:id])
  	end
end
