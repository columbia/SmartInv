1 pragma solidity ^0.5.0;
2 
3 contract Adoption {
4   address[16] public adopters;
5   uint[16] public prices;
6   address public owner;
7 
8   constructor() public {
9     owner = msg.sender;
10     for (uint i=0;i<16;++i) {
11       prices[i] = 0.001 ether;  
12     }
13   }
14 
15   // Adopting a pet
16   function adopt(uint petId) public payable returns (uint) {
17     require(petId >= 0 && petId <= 15);
18     require(msg.value >= prices[petId]);
19 
20     prices[petId] *= 120;
21     prices[petId] /= 100;
22 
23     adopters[petId] = msg.sender;
24     return petId;
25   }
26 
27   // Retrieving the adopters
28   function getAdopters() public view returns (address[16] memory, uint[16] memory) {
29     return (adopters,  prices);
30   }
31   
32   modifier onlyOwner() {
33         require (msg.sender == owner);
34         _;
35       }
36   function withdraw() public onlyOwner{
37     msg.sender.transfer(address(this).balance);
38   }
39 }