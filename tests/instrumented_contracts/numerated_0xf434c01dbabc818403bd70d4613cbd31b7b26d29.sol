1 /*
2  * DO NOT EDIT! DO NOT EDIT! DO NOT EDIT!
3  *
4  * This is an automatically generated file. It will be overwritten.
5  *
6  * For the original source see
7  *    '/Users/testuser/eth-timelock/src/main/solidity/Timelock.sol'
8  */
9 
10 pragma solidity ^0.4.24;
11 
12 contract Timelock {
13   address public owner;
14   uint public releaseDate;
15 
16   constructor( uint _days, uint _seconds ) public payable {
17     require( msg.value > 0, "There's no point in creating an empty Timelock!" );
18     owner = msg.sender;
19     releaseDate = now + (_days * 1 days) + (_seconds * 1 seconds);
20   }
21 
22   function withdraw() public {
23     require( msg.sender == owner, "Only the owner can withdraw!" );
24     require( now > releaseDate, "Cannot withdraw prior to release date!" );
25     msg.sender.transfer( address(this).balance );
26   }
27 }