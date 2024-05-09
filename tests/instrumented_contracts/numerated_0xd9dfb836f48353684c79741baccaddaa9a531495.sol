1 pragma solidity ^0.4.8;
2 
3 /// @title Oracle contract where m of n predetermined voters determine a value
4 contract FederatedOracleBytes8 {
5     struct Voter {
6         bool isVoter;
7         bool hasVoted;
8     }
9 
10     event VoterAdded(address account);
11     event VoteSubmitted(address account, bytes8 value);
12     event ValueFinalized(bytes8 value);
13 
14     mapping(address => Voter) public voters;
15     mapping(bytes8 => uint8) public votes;
16 
17     uint8 public m;
18     uint8 public n;
19     bytes8 public finalValue;
20 
21     uint8 private voterCount;
22     address private creator;
23 
24     function FederatedOracleBytes8(uint8 m_, uint8 n_) {
25         creator = msg.sender;
26         m = m_;
27         n = n_;
28     }
29 
30     function addVoter(address account) {
31         if (msg.sender != creator) {
32             throw;
33         }
34         if (voterCount == n) {
35             throw;
36         }
37 
38         var voter = voters[account];
39         if (voter.isVoter) {
40             throw;
41         }
42 
43         voter.isVoter = true;
44         voterCount++;
45         VoterAdded(account);
46     }
47 
48     function submitValue(bytes8 value) {
49         var voter = voters[msg.sender];
50         if (!voter.isVoter) {
51             throw;
52         }
53         if (voter.hasVoted) {
54             throw;
55         }
56 
57         voter.hasVoted = true;
58         votes[value]++;
59         VoteSubmitted(msg.sender, value);
60 
61         if (votes[value] == m) {
62             finalValue = value;
63             ValueFinalized(value);
64         }
65     }
66 }