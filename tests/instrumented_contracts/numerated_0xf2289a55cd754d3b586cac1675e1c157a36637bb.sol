1 contract SimpleStorage {
2     uint storedData;
3     function set(uint x) {
4         storedData = x;
5     }
6     function get() constant returns (uint retVal) {
7         return storedData;
8     }
9 }