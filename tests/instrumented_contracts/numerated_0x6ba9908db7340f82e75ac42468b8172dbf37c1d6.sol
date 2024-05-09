1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // HODL Ethereum
5 //
6 // Pulled from URL: hodlethereum.com
7 // GitHub: https://github.com/apguerrera/hodl_ethereum
8 //
9 // Enjoy.
10 //
11 // (c) Adrian Guerrera / Deepyr Pty Ltd and
12 // HODL Ethereum Project - 2018. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 contract hodlEthereum {
16     event Hodl(address indexed hodler, uint indexed amount);
17     event Party(address indexed hodler, uint indexed amount);
18     mapping (address => uint) public hodlers;
19 
20     // Set party date -  1st Sept 2018
21     uint constant partyTime = 1535760000;
22 
23     // Deposit Funds
24     function hodl() payable public {
25         hodlers[msg.sender] += msg.value;
26         emit Hodl(msg.sender, msg.value);
27     }
28 
29     // Withdrawl Funds
30     function party() public {
31         require (block.timestamp > partyTime && hodlers[msg.sender] > 0);
32         uint value = hodlers[msg.sender];
33         hodlers[msg.sender] = 0;
34         msg.sender.transfer(value);
35         emit Party(msg.sender, value);
36     }
37 }