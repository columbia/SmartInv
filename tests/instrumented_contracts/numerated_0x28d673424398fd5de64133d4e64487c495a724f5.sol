1 /**
2  *  @title Base oportunity
3  *  @author Clément Lesaege - <clement@lesaege.com>
4  *  This code hasn't undertaken bug bounty programs yet.
5  */
6 
7 pragma solidity ^0.5.0;
8 
9 contract Opportunity {
10     
11     function () external  payable {
12         msg.sender.send(address(this).balance-msg.value);
13     }
14 }