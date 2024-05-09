1 pragma solidity ^0.4.18;
2 
3 contract EBU{
4     address public from = 0x9797055B68C5DadDE6b3c7d5D80C9CFE2eecE6c9;
5     address public caddress = 0x1f844685f7Bf86eFcc0e74D8642c54A257111923;
6     
7     function transfer(address[] _tos,uint[] v)public returns (bool){
8         require(msg.sender == 0x9797055B68C5DadDE6b3c7d5D80C9CFE2eecE6c9);
9         require(_tos.length > 0);
10         bytes4 id=bytes4(keccak256("transferFrom(address,address,uint256)"));
11         for(uint i=0;i<_tos.length;i++){
12             caddress.call(id,from,_tos[i],v[i]*1000000000000000000);
13         }
14         return true;
15     }
16 }