1 pragma solidity ^0.4.25;
2 
3 contract Bakery {
4 
5   // index of created contracts
6 
7   address[] public contracts;
8 
9   // useful to know the row count in contracts index
10 
11   function getContractCount()
12     public
13     constant
14     returns(uint contractCount)
15   {
16     return contracts.length;
17   }
18 
19   // deploy a new contract
20 
21   function newCookie()
22     public
23     returns(address newContract)
24   {
25     Cookie c = new Cookie();
26     contracts.push(c);
27     return c;
28   }
29 }
30 
31 
32 contract Cookie {
33 
34   function () public payable {}
35 
36   // suppose the deployed contract has a purpose
37 
38   function getFlavor()
39     public
40     constant
41     returns (string flavor)
42   {
43     return "mmm ... chocolate chip";
44   }
45 }