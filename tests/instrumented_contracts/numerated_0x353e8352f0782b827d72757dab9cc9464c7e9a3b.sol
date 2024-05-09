1 /*
2  * DO NOT EDIT! DO NOT EDIT! DO NOT EDIT!
3  *
4  * This is an automatically generated file. It will be overwritten.
5  *
6  * For the original source see
7  *    '/Users/swaldman/Dropbox/BaseFolders/development-why/gitproj/eth-ping-pong/src/main/solidity/PingPong.sol'
8  */
9 
10 pragma solidity ^0.4.18;
11 
12 
13 
14 
15 
16 contract PingPong {
17   string private last;
18   uint private pong_count;
19 
20   function PingPong() public {
21     last = "";
22     pong_count = 0;
23   }
24 
25   event Pinged( string payload );
26   event Ponged( uint indexed count, string payload );
27 
28   function ping( string payload ) public {
29     last = payload;
30 
31     Pinged( payload );
32   }
33 
34   function pong() public {
35     pong_count += 1;
36 
37     Ponged( pong_count, last );
38   }
39 
40   function count() public view returns (uint n) {
41     n = pong_count;
42   }
43 }