1 contract SimpleStorage {
2   uint storedData;
3 
4   function set(uint x) {
5     storedData = x;
6   }
7 
8   function get() constant returns (uint retVal) {
9     return storedData;
10   }
11 }