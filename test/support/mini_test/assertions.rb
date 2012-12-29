module MiniTest::Assertions

  def assert_contents_equal(expected, actual, message = nil)
    e_ary = expected.to_a
    a_ary = actual.to_a
    error_msgs = []

    missing_from_expected = e_ary - a_ary
    unless missing_from_expected.empty?
      error_msgs << "Missing expected elements:\n  #{missing_from_expected}"
    end

    extraneous_from_actual = a_ary - e_ary
    unless extraneous_from_actual.empty?
      error_msgs << "Extraneous actual elements:\n  #{extraneous_from_actual}"
    end
    unless error_msgs.empty?
      message ||= "Expected:\n  #{expected}\nto equal:\n  #{actual}."
      flunk("#{message}\n#{error_msgs.join("\n")}")
    end
  end

  def assert_contains_all(expected, actual, message = nil)
    missing_from_expected = expected.to_a - actual.to_a
    unless missing_from_expected.empty?
      message ||= "Expected:\n  #{expected}\nto contain every element in:\n  #{actual}."
      flunk("#{message}\nMissing expected elements:\n  #{missing_from_expected}")
    end
  end

end