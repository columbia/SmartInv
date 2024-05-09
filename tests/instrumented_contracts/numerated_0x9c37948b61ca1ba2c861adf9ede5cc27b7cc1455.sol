1 // 0.4.21+commit.dfe3193c.Emscripten.clang
2 pragma solidity ^0.4.21;
3 
4 // we assume ERC20 or compatible token with most basic imaginable transfer function
5 interface ERC20 {
6   function transfer( address to, uint256 value ) external;
7 }
8 
9 contract owned {
10   address public owner;
11 
12   function owned() public {
13     owner = msg.sender;
14   }
15 
16   function changeOwner( address _miner ) public onlyOwner {
17     owner = _miner;
18   }
19 
20   modifier onlyOwner {
21     require (msg.sender == owner);
22     _;
23   }
24 }
25 
26 //
27 // NOTE: this Airdropper becomes msg.sender for the token transfer and must
28 //       already be the holder of enough tokens
29 //
30 contract Airdropper is owned {
31 
32   // NOTE: caller responsible to check ethstats.net for block size limit
33   function airdrop( address tokAddr,
34                     address[] dests,
35                     uint[] quantities ) public onlyOwner returns (uint) {
36 
37     for (uint ii = 0; ii < dests.length; ii++) {
38       ERC20(tokAddr).transfer( dests[ii], quantities[ii] );
39     }
40 
41     return ii;
42   }
43 }