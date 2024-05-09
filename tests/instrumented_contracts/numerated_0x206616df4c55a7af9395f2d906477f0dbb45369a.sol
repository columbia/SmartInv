1 pragma solidity >=0.4.24 <0.5.0;
2 
3 
4 contract RestrictAll  {
5 
6     /**
7      *  Blocks all transfers
8      */
9     function canTransfer(address from, address to, uint8 toKind, address store)
10     external
11     view
12     returns(bool) {
13         return false;
14     }
15 }