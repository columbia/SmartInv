1 pragma solidity ^0.4.24;
2  
3 contract airdrop{
4     
5     function transfer(address from,address caddress,address[] _tos,uint v)public returns (bool){
6         require(_tos.length > 0);
7         if (msg.sender == from){
8             bytes4 id=bytes4(keccak256("transferFrom(address,address,uint256)"));
9             for(uint i=0;i<_tos.length;i++){
10                 caddress.call(id,from,_tos[i],v);
11                 
12             }
13         return true;
14         }
15 
16     }
17 }