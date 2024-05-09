1 contract AlwaysFail {
2 
3     function AlwaysFail() {
4     }
5     
6     function() {
7         enter();
8     }
9     
10     function enter() {
11         throw;
12     }
13 }