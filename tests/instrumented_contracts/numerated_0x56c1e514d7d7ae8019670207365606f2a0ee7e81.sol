1 pragma solidity ^0.4.18;
2 
3 library Search {
4   function indexOf(uint32[] storage self, uint32 value) public view returns (uint32) {
5     for (uint32 i = 0; i < self.length; i++) {
6       if (self[i] == value) return i;
7     }
8     return uint32(- 1);
9   }
10 }
11 
12 library SafeMath {
13 
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a / b;
22     return c;
23   }
24 }
25 
26 contract PresidentElections {
27   address owner;
28 
29   using SafeMath for uint;
30 
31   struct Candidate {
32     uint32 id;
33     address owner;
34     uint256 votes;
35   }
36   uint end = 1521406800;
37   mapping(address => uint) votes;
38   mapping(uint32 => Candidate) candidates;
39   using Search for uint32[];
40   uint32[] candidate_ids;
41   uint constant price = 0.01 ether;
42   uint public create_price = 0.1 ether;
43   uint constant percent = 10;
44 
45   enum Candidates {
46     NULL,
47     Baburin,
48     Grudinin,
49     Zhirinovsky,
50     Putin,
51     Sobchak,
52     Suraykin,
53     Titov,
54     Yavlinsky
55   }
56 
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62   modifier isCandidate(uint32 candidate) {
63     require(candidates[candidate].id > 0);
64     _;
65   }
66 
67   modifier isNotVoted() {
68     require(votes[msg.sender] == 0);
69     _;
70   }
71 
72   modifier voteIsOn() {
73     require(now < end);
74     _;
75   }
76 
77   function PresidentElections() public {
78     owner = msg.sender;
79     _add(uint32(Candidates.Baburin), owner);
80     _add(uint32(Candidates.Grudinin), owner);
81     _add(uint32(Candidates.Zhirinovsky), owner);
82     _add(uint32(Candidates.Putin), owner);
83     _add(uint32(Candidates.Sobchak), owner);
84     _add(uint32(Candidates.Suraykin), owner);
85     _add(uint32(Candidates.Titov), owner);
86     _add(uint32(Candidates.Yavlinsky), owner);
87   }
88 
89   function _add(uint32 candidate, address sender) private {
90     require(candidates[candidate].id == 0);
91 
92     candidates[candidate] = Candidate(candidate, sender, 0);
93     candidate_ids.push(candidate);
94   }
95 
96   function isFinished() constant public returns (bool) {
97     return now > end;
98   }
99 
100   function isVoted() constant public returns (bool) {
101     return votes[msg.sender] > 0;
102   }
103 
104   function vote(uint32 candidate) public payable isCandidate(candidate) voteIsOn isNotVoted returns (bool) {
105     require(msg.value == price);
106 
107     votes[msg.sender] = candidate;
108     candidates[candidate].votes += 1;
109 
110     if( candidates[candidate].owner != owner ) {
111       owner.transfer(msg.value.mul(100 - percent).div(100));
112       candidates[candidate].owner.transfer(msg.value.mul(percent).div(100));
113     } else {
114       owner.transfer(msg.value);
115     }
116 
117     return true;
118   }
119 
120   function add(uint32 candidate) public payable voteIsOn returns (bool) {
121     require(msg.value == create_price);
122 
123     _add(candidate, msg.sender);
124 
125     owner.transfer(msg.value);
126 
127     return true;
128   }
129 
130   function getCandidates() public view returns (uint32[]) {
131     return candidate_ids;
132   }
133 
134   function getVotes() public view returns (uint256[]) {
135     uint256[] memory v = new uint256[](candidate_ids.length);
136     for(uint i = 0; i < candidate_ids.length; i++ ) {
137       v[i] = candidates[candidate_ids[i]].votes;
138     }
139     return v;
140   }
141 
142   function setCreatePrice(uint _price) public onlyOwner {
143     create_price = _price;
144   }
145 }