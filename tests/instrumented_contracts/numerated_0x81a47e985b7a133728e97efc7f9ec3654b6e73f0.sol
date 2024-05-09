1 pragma solidity ^0.4.8;
2 
3 contract Omnipurse {
4 
5   struct Contribution {
6     address sender;
7     uint value;
8     bool refunded;
9     uint256 timestamp;
10   }
11 
12   struct Purse {
13     address creator;
14     uint256 timestamp;
15     string title;
16     uint8 status;
17     uint numContributions;
18     uint totalContributed;
19     mapping (uint => Contribution) contributions;
20   }
21 
22   uint public numPurse;
23   mapping (uint => Purse) purses;
24   mapping (address => uint[]) pursesByCreator;
25   mapping (address => string) nicknames;
26 
27   function searchPursesByAddress(address creator) constant returns (uint[] ids) {
28     ids = pursesByCreator[creator];
29   }
30 
31   function getPurseDetails(uint purseId) constant returns (
32     address creator,
33     uint256 timestamp,
34     string title,
35     uint8 status,
36     uint numContributions,
37     uint totalContributed
38   ) {
39     Purse p = purses[purseId];
40     creator = p.creator;
41     timestamp = p.timestamp;
42     title = p.title;
43     status = p.status;
44     numContributions = p.numContributions;
45     totalContributed = p.totalContributed;
46   }
47 
48   function getPurseContributions(uint purseId, uint contributionId) constant returns (
49     address sender,
50     uint value,
51     bool refunded,
52     string nickname,
53     uint timestamp
54   ) {
55     Purse p = purses[purseId];
56     Contribution c = p.contributions[contributionId];
57     sender = c.sender;
58     value = c.value;
59     refunded = c.refunded;
60     nickname = nicknames[c.sender];
61     timestamp = c.timestamp;
62   }
63 
64   function createPurse(string title) returns (uint purseId) {
65     purseId = numPurse++;
66     purses[purseId] = Purse(msg.sender, block.timestamp, title, 1, 0, 0);
67     pursesByCreator[msg.sender].push(purseId);
68   }
69 
70   function contributeToPurse(uint purseId) payable {
71     Purse p = purses[purseId];
72     if (p.status != 1) { throw; }
73     p.totalContributed += msg.value;
74     p.contributions[p.numContributions++] = Contribution(msg.sender, msg.value,
75                                                         false, block.timestamp);
76   }
77 
78   function dissmisPurse(uint purseId) {
79     Purse p = purses[purseId];
80     if (p.creator != msg.sender || (p.status != 1 && p.status != 4)) { throw; }
81     bool success = true;
82     for (uint i=0; i<p.numContributions; i++) {
83       Contribution c = p.contributions[i];
84       if(!c.refunded) {
85         c.refunded = c.sender.send(c.value);
86       }
87       success = success && c.refunded;
88     }
89     p.status = success ? 3 : 4;
90   }
91 
92   function finishPurse(uint purseId) {
93     Purse p = purses[purseId];
94     if (p.creator != msg.sender || p.status != 1) { throw; }
95     if (p.creator.send(p.totalContributed)) { p.status = 2; }
96   }
97 
98   function registerNickname(string nickname) {
99     nicknames[msg.sender] = nickname;
100   }
101 
102 }