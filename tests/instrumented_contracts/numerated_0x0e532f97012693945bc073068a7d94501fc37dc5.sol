1 contract GetsBurned {
2 
3     function () payable {
4     }
5 
6     function BurnMe () {
7         // Selfdestruct and send eth to self, 
8         selfdestruct(address(this));
9     }
10 }