class MeritController < ApplicationController
  def index
    @merits = Merit.all
  end
end
