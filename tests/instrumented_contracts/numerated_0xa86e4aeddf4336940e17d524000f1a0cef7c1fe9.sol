1 contract TestRevert {
2     
3     function revertMe() {
4         require(false);
5     }
6     
7     function throwMe() {
8         throw;
9     }
10 }