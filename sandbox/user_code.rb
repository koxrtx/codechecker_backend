def sum_of_evens(arr)
  arr.select(&:even?).sum
end