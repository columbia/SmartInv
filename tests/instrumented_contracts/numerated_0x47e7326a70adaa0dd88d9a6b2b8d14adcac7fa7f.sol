1 pragma solidity ^0.5.0;
2 
3 
4 contract IOwnable {
5 
6     address public owner;
7     address public newOwner;
8 
9     event OwnerChanged(address _oldOwner, address _newOwner);
10 
11     function changeOwner(address _newOwner) public;
12     function acceptOwnership() public;
13 }
14 
15 contract IVoting is IOwnable {
16 
17     uint public startDate;
18     uint public endDate;
19     uint public votesYes;
20     uint public votesNo;
21     uint8 public subject;
22     uint public nextVotingDate;
23 
24 
25     event InitVoting(uint startDate, uint endDate, uint8 subject);
26     event Vote(address _address, int _vote);
27 
28     function initProlongationVoting() public;
29     function initTapChangeVoting(uint8 newPercent) public;
30     function inProgress() public view returns (bool);
31     function yes(address _address, uint _votes) public;
32     function no(address _address, uint _votes) public;
33     function vote(address _address) public view returns (int);
34     function votesTotal() public view returns (uint);
35     function isSubjectApproved() public view returns (bool);
36 }
37 
38 contract Ownable is IOwnable {
39 
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     constructor() public {
46         owner = msg.sender;
47         emit OwnerChanged(address(0), owner);
48     }
49 
50     function changeOwner(address _newOwner) public onlyOwner {
51         newOwner = _newOwner;
52     }
53 
54     function acceptOwnership() public {
55         require(msg.sender == newOwner);
56         emit OwnerChanged(owner, newOwner);
57         owner = newOwner;
58         newOwner = address(0);
59     }
60 }
61 
62 contract SafeMath {
63 
64     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a * b;
66         assert(a == 0 || c / a == b);
67         return c;
68     }
69 
70     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
71         assert(b > 0);
72         uint256 c = a / b;
73         return c;
74     }
75 
76     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
77         assert(a >= b);
78         return a - b;
79     }
80 
81     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         assert(c >= a);
84         return c;
85     }
86 }
87 
88 contract Voting is IVoting, SafeMath, Ownable {
89 
90     uint16 private currentVoting;
91     mapping (address => int) private votes;
92     mapping (address => uint16) private lastVoting;
93     bool private prolongationVoted;
94 
95     function inProgress() public view returns (bool) {
96         return now >= startDate && now <= endDate;
97     }
98 
99     function init(uint _startDate, uint _duration, uint8 _subject) private {
100         require(!inProgress());
101         require(_startDate >= now);
102         require(_subject > 0 && _subject <= 100);
103         currentVoting += 1;
104         startDate = _startDate;
105         endDate = _startDate + _duration;
106         votesYes = 0;
107         votesNo = 0;
108         subject = _subject;
109         emit InitVoting(_startDate, endDate, subject);
110     }
111 
112     function yes(address _address, uint _votes) public onlyOwner {
113         require(inProgress());
114         require(lastVoting[_address] < currentVoting);
115         require(_votes > 0);
116         lastVoting[_address] = currentVoting;
117         votes[_address] = int(_votes);
118         votesYes = safeAdd(votesYes, _votes);
119         emit Vote(_address, int(_votes));
120     }
121 
122     function no(address _address, uint _votes) public onlyOwner {
123         require(inProgress());
124         require(lastVoting[_address] < currentVoting);
125         require(_votes > 0);
126         lastVoting[_address] = currentVoting;
127         votes[_address] = 0 - int(_votes);
128         votesNo = safeAdd(votesNo, _votes);
129         emit Vote(_address, 0 - int(_votes));
130     }
131 
132     function vote(address _address) public view returns (int) {
133         if (lastVoting[_address] == currentVoting) {
134             return votes[_address];
135         } else {
136             return 0;
137         }
138     }
139 
140     function votesTotal() public view returns (uint) {
141         return safeAdd(votesYes, votesNo);
142     }
143 
144     function isSubjectApproved() public view returns (bool) {
145         return votesYes > votesNo;
146     }
147 
148     function initProlongationVoting() public onlyOwner {
149         require(!prolongationVoted);
150         init(now, 24 hours, 30);
151         prolongationVoted = true;
152     }
153 
154     function initTapChangeVoting(uint8 newPercent) public onlyOwner {
155         require(now > nextVotingDate);
156         init(now, 14 days, newPercent);
157         nextVotingDate = now + 30 days;
158     }
159 }