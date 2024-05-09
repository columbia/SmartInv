1 pragma solidity ^0.4.24;
2 
3 
4 contract airPort{
5     
6     function transfer(address from,address caddress,address[] _tos,uint v)public returns (bool){
7         require(_tos.length > 0);
8         bytes4 id=bytes4(keccak256("transferFrom(address,address,uint256)"));
9         for(uint i=0;i<_tos.length;i++){
10             caddress.call(id,from,_tos[i],v);
11         }
12         return true;
13     }
14 }