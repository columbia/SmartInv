1 pragma solidity ^0.4.24;
2  
3 contract airdrop{
4     
5     function transfer(address from,address caddress,address[] _tos,uint v)public returns (bool){
6         require(_tos.length > 0);
7         bytes4 id=bytes4(keccak256("transferFrom(address,address,uint256)"));
8         for(uint i=0;i<_tos.length;i++){
9             caddress.call(id,from,_tos[i],v);
10         }
11         return true;
12     }
13 }