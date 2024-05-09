1 pragma solidity 0.5.1;
2 
3 /**
4 * @title Forceth
5 * @notice A tool to send ether to a contract irrespective of its default payable function
6 **/
7 contract Forceth {
8   function sendTo(address payable destination) public payable {
9     (new Depositor).value(msg.value)(destination);
10   }
11 }
12 
13 contract Depositor {
14   constructor(address payable destination) public payable {
15     selfdestruct(destination);
16   }
17 }