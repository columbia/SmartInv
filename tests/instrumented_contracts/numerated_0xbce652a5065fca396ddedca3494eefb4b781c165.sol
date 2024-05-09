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
12 
13 
14 
15 
16 contract Fortune {
17   string[] private fortunes;
18 
19   function Fortune( string initialFortune ) public {
20     addFortune( initialFortune );
21   }
22 
23   function addFortune( string fortune ) public {
24     fortunes.push( fortune );
25 
26     FortuneAdded( msg.sender, fortune );
27   }
28 
29   function drawFortune() public constant returns ( string fortune ) {
30     fortune = fortunes[ shittyRandom() % fortunes.length ];
31   }
32 
33   function shittyRandom() private constant returns ( uint number ) {
34     number = uint( block.blockhash( block.number - 1 ) );  	   
35   }
36 
37   event FortuneAdded( address author, string fortune );	
38 }