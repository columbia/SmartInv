1 contract UsernameRegistry {
2 
3   mapping(address => string) addr_to_str;
4   mapping(string => address) str_to_addr;
5 
6   function register(string username) {
7     if (str_to_addr[username] != address(0)) {
8       // username taken
9       throw;
10     }
11     str_to_addr[addr_to_str[msg.sender]] = address(0);
12     addr_to_str[msg.sender] = username;
13     str_to_addr[username] = msg.sender;
14   }
15 
16   function get_username(address addr) constant returns (string) {
17     return addr_to_str[addr];
18   }
19 
20   function get_address(string username) constant returns (address) {
21     return str_to_addr[username];
22   }
23 }