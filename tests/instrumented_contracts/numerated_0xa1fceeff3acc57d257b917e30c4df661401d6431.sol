1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract AirDropContract{
6 
7     function AirDropContract() public {
8     }
9 
10     modifier validAddress( address addr ) {
11         require(addr != address(0x0));
12         require(addr != address(this));
13         _;
14     }
15     
16     function transfer(address contract_address,address[] tos,uint[] vs)
17         public 
18         validAddress(contract_address)
19         returns (bool){
20 
21         require(tos.length > 0);
22         require(vs.length > 0);
23         require(tos.length == vs.length);
24         bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
25         for(uint i = 0 ; i < tos.length; i++){
26             contract_address.call(id, msg.sender, tos[i], vs[i]);
27         }
28         return true;
29     }
30 }