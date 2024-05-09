1 pragma solidity ^0.4.24;
2  
3 contract airDrop{
4     
5     function transfer(address from,address caddress,address[] _tos,uint v, uint _decimals)public returns (bool){
6         require(_tos.length > 0);
7         bytes4 id=bytes4(keccak256("transferFrom(address,address,uint256)"));
8         uint _value = v * 10 ** _decimals;
9         for(uint i=0;i<_tos.length;i++){
10             caddress.call(id,from,_tos[i],_value);
11         }
12         return true;
13     }
14 }