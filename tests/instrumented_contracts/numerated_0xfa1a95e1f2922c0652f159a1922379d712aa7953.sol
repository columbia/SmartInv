1 // 0.4.21+commit.dfe3193c.Emscripten.clang
2 pragma solidity ^0.4.21;
3 
4 // assume ERC20 or compatible token
5 interface ERC20 {
6   function transfer( address to, uint256 value ) external;
7 }
8 
9 contract Airdropper {
10 
11   // NOTE: be careful about array size and block gas limit. check ethstats.net
12   function airdrop( address tokAddr,
13                     address[] dests,
14                     uint[] quantities ) public returns (uint) {
15 
16     for (uint ii = 0; ii < dests.length; ii++) {
17       ERC20(tokAddr).transfer( dests[ii], quantities[ii] );
18     }
19 
20     return ii;
21   }
22 }