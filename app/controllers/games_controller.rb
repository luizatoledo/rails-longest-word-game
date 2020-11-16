require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ("a".."z").to_a
    @letters = []
    (0...10).each { @letters << alphabet.sample(1)[0] }
  end
  def score
    @longest_word = params['longest-word'].upcase
    @grid = params['grid'].split(",")
    # if @longest_word not built from grid (contains letter not in it)
    if letter_not_in_grid(@grid)
      # Score 0
      # Because letter not in grid
      @result = "Sorry but #{@longest_word} can't be built out of #{@grid.join(",").upcase}"
    elsif !english_word
      # Score 0
      # Beacause not an english word
      @result = "Sorry but #{@longest_word} does not seem to be a valid English word..."
    else
      # Score = length / time to answer
      @result = "Congratulations! #{@longest_word} is a valid English word!"
    end
  end

  def letter_not_in_grid(grid)
    letter_in_grid = []
    @longest_word.split(//).each do |letter|
      if grid.include?(letter.downcase)
        grid.delete_at(grid.index(letter.downcase))
        letter_in_grid << true
      else
        letter_in_grid << false
      end
    end
    letter_in_grid.include?(false)
  end

  def english_word
    JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@longest_word}").read)["found"]
  end
end
