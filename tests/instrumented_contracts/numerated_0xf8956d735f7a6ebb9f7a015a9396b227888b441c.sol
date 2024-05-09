1 pragma solidity ^0.5.0;
2 
3 contract Adoption {
4   address[16] public adopters;
5   uint[16] public prices;
6 
7   constructor() public {
8     for (uint i=0;i<16;++i) {
9       prices[i] = 0.001 ether;  
10     }
11   }
12 
13   // Adopting a pet
14   function adopt(uint petId) public payable returns (uint) {
15     require(petId >= 0 && petId <= 15);
16     require(msg.value >= prices[petId]);
17 
18     prices[petId] *= 120;
19     prices[petId] /= 100;
20 
21     adopters[petId] = msg.sender;
22     return petId;
23   }
24 
25   // Retrieving the adopters
26   function getAdopters() public view returns (address[16] memory, uint[16] memory) {
27     return (adopters,  prices);
28   }
29   address public owner;
30   modifier onlyOwner() {
31         require (msg.sender != owner);
32         _;
33       }
34   function withdraw() public onlyOwner() {
35     msg.sender.transfer(address(this).balance);
36   }
37 }