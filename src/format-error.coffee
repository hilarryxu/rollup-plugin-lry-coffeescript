export default (source, filename, err) ->
  {first_line, last_line, first_column, last_column} = err.location

  # last_line no longer exists randomly
  unless last_line?
    last_line = first_line

  # get lines from source
  lines = source.split '\n'

  # insert start of highlighting
  l = lines[first_line]
  lines[first_line] = (l.substring 0, first_column) + '\x1B[91m' + l.substring first_column

  # insert end

  l = lines[last_line]

  if first_line == last_line
    # error only spans one line and overlaps with current cursor
    # skip a bit farther due to insertion of highlighting
    col = last_column + 6
  else
    col = last_column

  # end highlighting
  lines[last_line] = (l.substring 0, col) + '\x1B[39m' + (l.substring col)

  # get subset of lines with error to display
  lines = lines.slice first_line, last_line + 1

  # underline with carets
  carets = Array(first_column+1).join(' ')  + "\x1B[91m#{Array(last_column + 2 - first_column).join('^')}\x1B[39m"

  lines.push carets

  """
  #{filename}:#{first_line+1}:#{first_column+1}: #{err.name}: #{err.message}
  #{lines.join '\n'}\n
  """
