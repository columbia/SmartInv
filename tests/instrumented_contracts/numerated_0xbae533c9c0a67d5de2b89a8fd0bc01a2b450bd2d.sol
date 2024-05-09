1 pragma solidity ^0.4.19;
2 contract Adoption {
3   address ceoAddress = 0x1AEA2d3709bB7CFf5326a4Abc44c45Aa2629C626;
4   struct Pepe {
5     address owner;
6     uint256 price;
7    
8   }
9 
10   Pepe[16] data;
11 
12   function Adoption() public {
13     for (uint i = 0; i < 16; i++) {
14      
15       data[i].price = 10000000000000000;
16       data[i].owner = msg.sender;
17     }
18   }
19 
20   function returnEth(address oldOwner, uint256 price) public payable {
21     oldOwner.transfer(price);
22   }
23 
24   function gimmeTendies(address, uint256 price) public payable {
25     ceoAddress.transfer(price);
26   }
27   // Adopting a pet
28   function adopt(uint pepeId) public payable returns (uint, uint) {
29     require(pepeId >= 0 && pepeId <= 15);
30     if ( data[pepeId].price == 10000000000000000 ) {
31       data[pepeId].price = 20000000000000000;
32     } else {
33       data[pepeId].price = data[pepeId].price * 2;
34     }
35     
36     require(msg.value >= data[pepeId].price * uint256(1));
37     returnEth(data[pepeId].owner,  (data[pepeId].price / 10) * (9)); 
38     gimmeTendies(ceoAddress, (data[pepeId].price / 10) * (1));
39     data[pepeId].owner = msg.sender;
40     return (pepeId, data[pepeId].price);
41     //return value;
42   }
43 
44   function getAdopters() external view returns (address[], uint256[]) {
45     address[] memory owners = new address[](16);
46     uint256[] memory prices =  new uint256[](16);
47     for (uint i=0; i<16; i++) {
48       owners[i] = (data[i].owner);
49       prices[i] = (data[i].price);
50     }
51     return (owners,prices);
52   }
53   
54 }