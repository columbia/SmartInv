1 pragma solidity ^0.4.10;
2 
3 contract Fortune {
4   string[] private fortunes;
5 
6   function Fortune( string initialFortune ) {
7     addFortune( initialFortune );
8   }
9 
10   function addFortune( string fortune ) {
11     fortunes.push( fortune );
12   }
13 
14   function drawFortune() constant returns ( string fortune ) {
15     fortune = fortunes[ shittyRandom() % fortunes.length ];
16   }
17 
18   function shittyRandom() private constant returns ( uint number ) {
19     number = uint( block.blockhash( block.number - 1 ) );  	   
20   }
21 }