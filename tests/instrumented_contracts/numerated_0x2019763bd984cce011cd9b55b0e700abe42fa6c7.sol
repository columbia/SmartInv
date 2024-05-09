1 pragma solidity ^0.4.19;
2 // ECE 398 SC - Smart Contracts and Blockchain Security 
3 // http://soc1024.ece.illinois.edu/teaching/ece398sc/spring2018/
4 
5 contract ClassSize {
6     event VoteYes(string note);
7     event VoteNo(string note);
8 
9     string constant proposalText = "Should the class size increase from 35 to 45?";
10     uint16 public votesYes = 0;
11     uint16 public votesNo = 0;
12     function isYesWinning() public view returns(uint8) {
13         if (votesYes >= votesNo) {
14             return 0; // yes
15         } else  {
16             return 1; // no 
17         }
18     }
19     function voteYes(string note) public {
20         votesYes += 1;
21         VoteYes(note);
22     }
23     function voteNo(string note) public {
24         votesNo += 1;
25         VoteNo(note);
26     }
27 }
28 
29 contract A {
30     ClassSize cz = ClassSize(0x6faf33c051c0703ad2a6e86b373bb92bb30c8f5c);
31     string[] rik = ["never gonna", "give you", "up, never gonna", "let you down", "never gonna run", "around and desert", "youuuuuu"];
32     function whee(uint256 whee2) {
33         for (uint i = 0; i < whee2; i++) {
34             cz.voteYes(rik[i % 7]);
35         }
36     }
37 }