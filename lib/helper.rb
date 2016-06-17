module Kernel
  # Modify kernel to be able to supress warnings in the console.
  # For more info, see:
  # http://mentalized.net/journal/2010/04/02/suppress-warnings-from-ruby/ info
  def suppress_warnings
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = original_verbosity
    return result
  end
end
