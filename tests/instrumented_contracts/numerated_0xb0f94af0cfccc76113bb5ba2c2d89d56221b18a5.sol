1 contract owned {
2     function owned() {
3         owner = msg.sender;
4     }
5     modifier onlyowner() { 
6         if (msg.sender == owner)
7             _
8     }
9     address owner;
10 }
11 contract CoinLock is owned {
12     uint public expiration; // Timestamp in # of seconds.
13     
14     function lock(uint _expiration) onlyowner returns (bool) {
15         if (_expiration > block.timestamp && expiration == 0) {
16             expiration = _expiration;
17             return true;
18         }
19         return false;
20     }
21     function redeem() onlyowner {
22         if (block.timestamp > expiration) {
23             suicide(owner);
24         }
25     }
26 }