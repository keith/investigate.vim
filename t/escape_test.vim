describe 'escape'
  it 'should return the correctly escaped string'
    Expect investigate#escape#EscapeString("!") == "%21"
    Expect investigate#escape#EscapeString("#!a") == "%23%21a"
  end
end
