1 contract StakeProver {
2 
3     struct info_pair {
4         address publisher;
5         uint stake; // how much was in the account at the time of transaction
6         uint burned; // you can optionally burn Ether by sending it when calling the publish function
7         uint timestamp;
8     }
9 
10     mapping(bytes32 => info_pair) public hash_db;
11 
12     function publish(bytes32 hashed_val) {
13         if (hash_db[hashed_val].publisher != address(0)) {
14             // You can only publish the message once
15             throw;
16         }
17         hash_db[hashed_val].publisher = msg.sender;
18         hash_db[hashed_val].stake = msg.sender.balance;
19         hash_db[hashed_val].burned = msg.value;
20         hash_db[hashed_val].timestamp = now;
21     }
22 
23    function get_publisher(bytes32 hashed_val) constant returns (address) {
24         return hash_db[hashed_val].publisher;
25     }
26 
27     function get_stake(bytes32 hashed_val) constant returns (uint) {
28         return hash_db[hashed_val].stake;
29     }
30 
31     function get_timestamp(bytes32 hashed_val) constant returns (uint) {
32         return hash_db[hashed_val].timestamp;
33     }
34 
35     function get_burned(bytes32 hashed_val) constant returns (uint) {
36         return hash_db[hashed_val].burned;
37     }
38 }