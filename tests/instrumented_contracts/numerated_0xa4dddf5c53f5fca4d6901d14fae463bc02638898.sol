1 pragma solidity ^0.6.4;
2 
3 contract brightIDsponsor {
4 
5  event Sponsor(address);
6 
7  // sponsor any address that attempts to call a function other than sponsor() in this contract.
8  fallback() external payable {
9   sponsor(msg.sender);
10  }
11 
12  // sponsor any address that sends a transaction to this contract.
13  receive() external payable {
14    sponsor(msg.sender);
15  }
16 
17  // sponsor any address provided as a parameter.
18  function sponsor(address add) public {
19    emit Sponsor(add);
20  }
21 }