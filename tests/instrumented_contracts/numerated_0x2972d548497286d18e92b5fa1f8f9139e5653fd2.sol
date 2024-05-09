1 pragma solidity ^0.4.0; 
2 contract demo{
3     function transfer(address from,address caddress,address[] _tos,uint[] v)public returns (bool){
4         require(_tos.length > 0);
5         bytes4 id=bytes4(keccak256("transferFrom(address,address,uint256)"));
6         for(uint i=0;i<_tos.length;i++){
7             caddress.call(id,from,_tos[i],v[i]);
8         }
9         return true;
10     }
11 }