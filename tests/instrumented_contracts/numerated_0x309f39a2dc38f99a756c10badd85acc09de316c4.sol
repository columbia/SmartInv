1 contract calc { 
2     event ret(uint r);
3     function multiply(uint a, uint b) returns(uint d) { 
4         uint res = a * b;
5         ret (res);
6         return res; 
7     } 
8 }