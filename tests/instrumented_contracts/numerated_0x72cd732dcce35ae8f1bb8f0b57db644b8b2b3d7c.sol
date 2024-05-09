1 pragma solidity ^0.4.0;
2 
3 contract Bounty {
4     struct Talk {
5         uint balance;
6         mapping(address => uint) witnessedPresenter;
7         mapping(address => bool) witnessedBy;
8     }
9     mapping(bytes32 => Talk) public talks;
10 
11     function add(bytes32 title) payable {
12         talks[title].balance += msg.value;
13     }
14 
15     function witness(bytes32 title, address presenter) onlywitness returns (uint) {
16         if (talks[title].witnessedBy[msg.sender]) {
17             revert();
18         }
19         talks[title].witnessedBy[msg.sender] = true;
20         talks[title].witnessedPresenter[presenter] += 1;
21         return talks[title].witnessedPresenter[presenter];
22     }
23 
24     modifier onlywitness {
25         require(msg.sender == 0xa4e15612af5434f05b22405c574d015e54a5e13e);
26         _;
27     }
28 
29     function claim(bytes32 title) {
30         if (talks[title].witnessedPresenter[msg.sender] < 2) {
31             revert();
32         }
33         uint amount = talks[title].balance;
34         talks[title].balance = 0;
35         msg.sender.transfer(amount);
36     }
37 }