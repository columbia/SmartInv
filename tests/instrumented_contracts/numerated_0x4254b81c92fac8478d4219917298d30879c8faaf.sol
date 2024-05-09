1 pragma solidity ^0.5.0;
2 
3 
4 
5 contract AirDropContract{
6 
7     constructor () public {
8     }
9 
10     modifier validAddress( address addr ) {
11         require(addr != address(0x0));
12         require(addr != address(this));
13         _;
14     }
15     
16     function transfer(address contract_address, address[] memory tos,  uint[] memory vs)
17         public 
18         validAddress(contract_address)
19         returns (bool){
20 
21         require(tos.length > 0);
22         require(vs.length > 0);
23         require(tos.length == vs.length);
24         for(uint i = 0 ; i < tos.length; i++){
25             (bool success, bytes memory data) = contract_address.call(abi.encodeWithSignature("transferFrom(address,address,uint256)",
26                  msg.sender, tos[i], vs[i]));
27             require(success == true, "transferFrom Error ");
28         }
29         return true;
30     }
31 }