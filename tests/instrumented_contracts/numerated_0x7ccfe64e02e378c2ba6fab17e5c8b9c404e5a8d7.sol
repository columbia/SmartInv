1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4      function safeMul(uint a, uint b) internal returns (uint) {
5           uint c = a * b;
6           assert(a == 0 || c / a == b);
7           return c;
8      }
9 
10      function safeSub(uint a, uint b) internal returns (uint) {
11           assert(b <= a);
12           return a - b;
13      }
14 
15      function safeAdd(uint a, uint b) internal returns (uint) {
16           uint c = a + b;
17           assert(c>=a && c>=b);
18           return c;
19      }
20 }
21 
22 // ERC20 standard
23 contract StdToken {
24      function transfer(address, uint256) returns(bool);
25      function transferFrom(address, address, uint256) returns(bool);
26      function balanceOf(address) constant returns (uint256);
27      function approve(address, uint256) returns (bool);
28      function allowance(address, address) constant returns (uint256);
29 }
30 
31 contract GoldmintVote1 {
32 // Fields:
33      address public creator = 0x0;
34      bool public stopped = false;
35      StdToken mntpToken; 
36 
37      mapping(address => bool) isVoted;
38      mapping(address => bool) votes;
39      uint public totalVotes = 0;
40      uint public votedYes = 0;
41 
42 // Functions:
43      function GoldmintVote1(address _mntpContractAddress) {
44           require(_mntpContractAddress!=0);
45 
46           creator = msg.sender;
47           mntpToken = StdToken(_mntpContractAddress);
48      }
49 
50      function vote(bool _answer) public {
51           require(!stopped);
52 
53           // 1 - should be Goldmint MNTP token holder 
54           // with >1 MNTP token balance
55           uint256 balance = mntpToken.balanceOf(msg.sender);
56           require(balance>=10 ether);
57 
58           // 2 - can vote only once 
59           require(isVoted[msg.sender]==false);
60 
61           // save vote
62           votes[msg.sender] = _answer;
63           isVoted[msg.sender] = true;
64 
65           ++totalVotes;
66           if(_answer){
67                ++votedYes;
68           }
69      }
70 
71      function getVoteBy(address _a) public constant returns(bool) {
72           require(isVoted[_a]==true);
73           return votes[_a];
74      }
75 
76      function stop() public {
77           require(msg.sender==creator);
78           stopped = true;
79      }
80 }