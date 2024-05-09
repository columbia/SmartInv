1 pragma solidity ^0.5.1;
2 
3 contract BasicVote {
4     
5     function vote(bool _option) public{
6         if (_option == true) {
7             emit VoteCast("missionStatementA");
8         } else {
9             emit VoteCast("missionStatementB");
10         }
11 
12     }
13     
14     event VoteCast(string mission);
15 }