1 /*
2  * DO NOT EDIT! DO NOT EDIT! DO NOT EDIT!
3  *
4  * This is an automatically generated file. It will be overwritten.
5  *
6  * For the original source see
7  *    '/Users/swaldman/Dropbox/BaseFolders/development-why/gitproj/eth-fortune/src/main/solidity/Fortune.sol'
8  */
9 
10 pragma solidity ^0.4.10;
11 
12 contract Fortune {
13   string[] public fortunes; // automatically generates an indexed getter (only)
14 
15   function Fortune( string initialFortune ) public {
16     addFortune( initialFortune );
17   }
18 
19   function addFortune( string fortune ) public {
20     fortunes.push( fortune );
21 
22     FortuneAdded( msg.sender, fortune );
23   }
24 
25   function drawFortune() public view returns ( string fortune ) {
26     fortune = fortunes[ shittyRandom() % fortunes.length ];
27   }
28 
29   function countFortunes() public view returns ( uint count ) {
30     count = fortunes.length;	   
31   }
32 
33   function shittyRandom() private view returns ( uint number ) {
34     number = uint( block.blockhash( block.number - 1 ) );  	   
35   }
36 
37   event FortuneAdded( address author, string fortune );	
38 }