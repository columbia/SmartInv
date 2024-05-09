1 contract ClassicCheck {
2     
3     bool public classic;
4  
5     function ClassicCheck(){
6         if (address(0xbf4ed7b27f1d666546e30d74d50d173d20bca754).balance > 1000000 ether)
7             classic = false;
8         else
9             classic = true;
10     }   
11     
12     function isClassic() constant returns (bool isClassic) {
13         return classic;
14     }
15 }