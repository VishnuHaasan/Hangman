require './game'
require './savefiles'
def startGame
  flag = true
  while flag
    puts "Do you wanna\n1)Load a game\n2)Play a new one"
    n = gets.chomp.to_i
    if n==1
      if Dir.exist? 'saves'
        data = SAVEFILES.load_game
        puts "Welcome back, #{data['name']}"
        game = Game.new(data['name'],data['available_guesses'],data['word'],data['chosen_correct_characters'],data['chosen_wrong_characters'])
        game.start
      else
        puts "There are no savefiles to load"
      end
    elsif n==2
      puts "Enter your name: "
      name = gets.chomp.to_s
      game = Game.new(name)
      game.start
    else
      puts "Enter a valid choice."
    end
    puts "Do you want to play again?[y/n]"
    char = gets.chomp.to_s
    flag = false unless char == 'y'
  end
end
startGame