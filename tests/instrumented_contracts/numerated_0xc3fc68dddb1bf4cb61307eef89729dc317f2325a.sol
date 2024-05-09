1 // SPDX-License-Identifier: --🦉--
2 
3 pragma solidity =0.7.0;
4 
5 contract RefundSponsor {
6 
7     address public refundSponsor;
8     address public sponsoredContract;
9     bool public isPaused;
10     uint256 public flushNonce;
11     uint256 public payoutPercent;
12 
13     mapping (bytes32 => uint256) public refundAmount;
14     mapping (address => uint256) public sponsoredAmount;
15 
16     event RefundIssued(
17         address refundedTo,
18         uint256 amount
19     );
20 
21     event SponsoredContribution(
22         address sponsor,
23         uint256 amount
24     );
25 
26     modifier onlySponsor() {
27         require(
28             msg.sender == refundSponsor,
29             'RefundSponsor: not a sponsor'
30         );
31         _;
32     }
33 
34     receive()
35         external
36         payable
37     {
38         sponsoredAmount[msg.sender] += msg.value;
39         emit SponsoredContribution(
40             msg.sender,
41             msg.value
42         );
43     }
44 
45     constructor() {
46         refundSponsor = msg.sender;
47         payoutPercent = 70;
48     }
49 
50     function changePayoutPercent(
51         uint256 _newPauoutPercent
52     )
53         external
54         onlySponsor
55     {
56         payoutPercent = _newPauoutPercent;
57     }
58 
59     function setSponsoredContract(address _s)
60         onlySponsor
61         external
62     {
63         sponsoredContract = _s;
64     }
65 
66     function addGasRefund(address _a, uint256 _g)
67         external
68     {
69         if (msg.sender == sponsoredContract && isPaused == false) {
70             refundAmount[getHash(_a)] += _g;
71         }
72     }
73 
74     function setGasRefund(address _a, uint256 _g)
75         external
76         onlySponsor
77     {
78         refundAmount[getHash(_a)] = _g;
79     }
80 
81     function requestGasRefund()
82         external
83     {
84         require(
85             isPaused == false,
86             'RefundSponsor: refunds paused'
87         );
88 
89         bytes32 sender = getHash(msg.sender);
90 
91         require(
92             refundAmount[sender] > 0,
93             'RefundSponsor: nothing to refund'
94         );
95 
96         uint256 amount = getRefundAmount(msg.sender);
97         refundAmount[sender] = 0;
98 
99         msg.sender.transfer(amount);
100 
101         emit RefundIssued(
102             msg.sender,
103             amount
104         );
105     }
106 
107     function myRefundAmount()
108         external
109         view
110         returns (uint256)
111     {
112         return getRefundAmount(msg.sender) * payoutPercent / 100;
113     }
114 
115     function getRefundAmount(address x)
116         public
117         view
118         returns (uint256)
119     {
120         return refundAmount[getHash(x)] * payoutPercent / 100;
121     }
122 
123     function getHash(address x)
124         public
125         view
126         returns (bytes32)
127     {
128         return keccak256(
129             abi.encodePacked(x, flushNonce)
130         );
131     }
132 
133     function pause()
134         external
135         onlySponsor
136     {
137         isPaused = true;
138     }
139 
140     function resume()
141         external
142         onlySponsor
143     {
144         isPaused = false;
145     }
146 
147     function flush()
148         external
149         onlySponsor
150     {
151         flushNonce += 1;
152     }
153 }