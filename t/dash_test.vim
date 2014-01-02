call vspec#hint({'sid': 'investigate#dash#sid()', 'scope': 'investigate#dash#scope()'})

describe 'investigate#dash#DashString'
  it 'should return the correctly formatted string based on the variable'
    let g:investigate_dash_format = 'abc^fdef^s'
    Expect Call('investigate#dash#DashString', 'ruby') == 'abcrubydef^s'
    unlet g:investigate_dash_format
  end

  it 'should set the global variable'
    if exists("g:investigate_dash_format")
      unlet g:investigate_dash_format
    endif

    Expect Call('investigate#dash#DashString', 'ruby') =~ '\Mdash\.\*ruby'
    Expect eval('g:investigate_dash_format') =~ '\Mdash\.\*^f'
  end
end

describe 's:SyntaxString'
  it 'should return the substituted string'
    Expect Call('s:SyntaxString', 'a^f', 'ruby') ==# 'aruby'
    Expect Call('s:SyntaxString', '^f', 'ruby') ==# 'ruby'
    Expect Call('s:SyntaxString', 'dash://^f', 'ruby') ==# 'dash://ruby'
  end

  it 'should return the same string otherwise'
    Expect Call('s:SyntaxString', 'abc', 'ruby') ==# 'abc'
    Expect Call('s:SyntaxString', 'abc:^s', 'ruby') ==# 'abc:^s'
  end
end

describe 's:DashFormat'
  it 'should return the default format for no lsregister'
    Expect Call('s:DashFormat', '') =~ '\M^dash://'
  end
end

describe 's:HasDashPlugin'
  it 'should return true if the passed text has the correct string'
    Expect Call('s:HasDashPlugin', 'foodash-plugin:bar\nbaz') == 1
  end

  it 'should return false otherwise'
    Expect Call('s:HasDashPlugin', 'foodash:') == 0
    Expect Call('s:HasDashPlugin', 'foodash-appcode:\nbaz') == 0
  end
end

describe 's:LSRegisterCommand'
  it 'should return the concatentated command'
    Expect Call('s:LSRegisterCommand', 'foobar') =~ 'foobar -dump | grep'
  end
end

