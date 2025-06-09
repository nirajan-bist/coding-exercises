class MagicSquare
  # Implement a method that takes a 2D array, 
  # checks if it's a magic square and returns either true or false depending on the result.
  # sequence (https://en.wikipedia.org/wiki/Magic_square)
  def self.validate(square)
    # Check if the input is a valid array
    return false if !square.is_a?(Array) 

    # Check if all rows are of the same size
    order = square.size
    return false if order == 0 || order == 2
    return false if square.any? { |row| !row.is_a?(Array) || row.size != order }

    # Find magic constant for given size
    magic_sum = (order * (order * order + 1)) / 2

    # Check rows and columns
    (0...order).each do |i|
      return false if square[i].sum != magic_sum # Check each row sum
      return false if square.transpose[i].sum != magic_sum # Check each column sum
    end

    # Find sums of both diagonals
    primary_diag_sum = (0...order).sum { |i| square[i][i] } #primary diagonal
    secondary_diag_sum = (0...order).sum { |i| square[i][order - i - 1] } #secondary diagonal

    # Check if both diagonals sum to the magic sum
    return [primary_diag_sum, secondary_diag_sum].all? { |sum| sum == magic_sum }
  end
end
