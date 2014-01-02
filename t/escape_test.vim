describe 'escape'
  it 'should return the correctly escaped string'
    Expect investigate#escape#EscapeString("!") == "%21"
    Expect investigate#escape#EscapeString("#!a") == "%23%21a"
    Expect investigate#escape#EscapeString("https://www.google.com/search?q=test+percent+escape&oq=test+percent+escape&aqs=chrome..69i57.3671j0j7&sourceid=chrome&espv=210&es_sm=91&ie=UTF-8#es_sm=91&espv=210&q=test+search") == "https%3A%2F%2Fwww.google.com%2Fsearch%3Fq%3Dtest%2Bpercent%2Bescape%26oq%3Dtest%2Bpercent%2Bescape%26aqs%3Dchrome..69i57.3671j0j7%26sourceid%3Dchrome%26espv%3D210%26es_sm%3D91%26ie%3DUTF-8%23es_sm%3D91%26espv%3D210%26q%3Dtest%2Bsearch"
    Expect investigate#escape#EscapeString("abc") == "abc"
  end
end

