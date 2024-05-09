1 contract SimpleStorage {
2     uint storedData;
3     address storedAddress;
4     
5     event flag(uint val, address addr);
6 
7     function set(uint x, address y) {
8         storedData = x;
9         storedAddress = y;
10     }
11 
12     function get() constant returns (uint retVal, address retAddr) {
13         return (storedData, storedAddress);
14         flag(storedData, storedAddress);
15 
16     }
17 }