require 'rubygems' # only necessary in Ruby 1.8
require 'gosu'
require './z_order.rb'
require './star.rb'
require './player'

class GameWindow < Gosu::Window
  #attr_reader :player

  def initialize
    super(640, 480, false)
    self.caption = "Gosu Tutorial Game"

    @background_image = Gosu::Image.new(self, "spacefield-light.png", true)

    @player = Player.new(self)
    @player.warp(320, 240)
    
    @star_anim = Gosu::Image::load_tiles(self, "star-small.png", 25, 25, false)
    @stars = Array.new

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    @warp_active = false
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
    elsif button_down? Gosu::KbDown or button_down? Gosu::GpButton1 then
      @player.reverse_accelerate
    end

    if !@warp_active and button_down? Gosu::KbW
        @player.warp(rand(50..590), rand(50..430))
        @warp_active = true
    end

    @player.move
    @player.collect_stars(@stars)

    if rand(100) < 4 and @stars.size < 25 then
      @stars.push(Star.new(@star_anim))
    end
  end

  def button_up(id)
    if id == Gosu::KbW
      if(@warp_active)
        @warp_active = false
      end
    end
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @stars.each { |star| star.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show
