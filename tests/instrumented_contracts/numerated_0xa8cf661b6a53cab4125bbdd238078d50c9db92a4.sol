1 pragma solidity ^0.4.18;
2 
3 interface ERC20 {
4     function balanceOf(address _owner) public constant returns (uint256 balance);
5     function transfer(address _to, uint256 _value) public returns (bool success);
6 }
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     require(c / a == b);
15     return c;
16   }
17 
18   //function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     //// require(b > 0); // Solidity automatically throws when dividing by 0
20     //uint256 c = a / b;
21     //// require(a == b * c + a % b); // There is no case in which this doesn't hold
22     //return c;
23   //}
24 
25   //function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     //require(b <= a);
27     //return a - b;
28   //}
29 
30   //function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     //uint256 c = a + b;
32     //require(c >= a);
33     //return c;
34   //}
35 }
36 
37 // A contract that distributes ERC20 tokens with predetermined terms.
38 // WARNING: This contract does not protect against malicious token contracts,
39 //          under the assumption that if the token sellers are malicious,
40 //          the tokens will be worthless anyway.
41 contract Distribution {
42   using SafeMath for uint256;
43 
44   enum State {
45     AwaitingTokens,
46     DistributingNormally,
47     DistributingProRata,
48     Done
49   }
50  
51   address admin;
52   ERC20 tokenContract;
53   State state;
54   uint256 actualTotalTokens;
55   uint256 tokensTransferred;
56 
57   bytes32[] contributionHashes;
58   uint256 expectedTotalTokens;
59 
60   function Distribution(address _admin, ERC20 _tokenContract,
61                         bytes32[] _contributionHashes, uint256 _expectedTotalTokens) public {
62     expectedTotalTokens = _expectedTotalTokens;
63     contributionHashes = _contributionHashes;
64     tokenContract = _tokenContract;
65     admin = _admin;
66 
67     state = State.AwaitingTokens;
68   }
69 
70   function handleTokensReceived() public {
71     require(state == State.AwaitingTokens);
72     uint256 totalTokens = tokenContract.balanceOf(this);
73     require(totalTokens > 0);
74 
75     tokensTransferred = 0;
76     if (totalTokens == expectedTotalTokens) {
77       state = State.DistributingNormally;
78     } else {
79       actualTotalTokens = totalTokens;
80       state = State.DistributingProRata;
81     }
82   }
83 
84   function _numTokensForContributor(uint256 contributorExpectedTokens, State _state)
85       internal view returns (uint256) {
86     if (_state == State.DistributingNormally) {
87       return contributorExpectedTokens;
88     } else if (_state == State.DistributingProRata) {
89       uint256 tokensRemaining = actualTotalTokens - tokensTransferred;
90       uint256 tokens = actualTotalTokens.mul(contributorExpectedTokens) / expectedTotalTokens;
91 
92       // Handle roundoff on last contributor.
93       if (tokens < tokensRemaining) {
94         return tokens;
95       } else {
96         return tokensRemaining;
97       }
98     } else {
99       revert();
100     }
101   }
102 
103   function doDistribution(uint256 contributorIndex, address contributor,
104                           uint256 contributorExpectedTokens)
105       public {
106     // Make sure the arguments match the compressed storage.
107     require(contributionHashes[contributorIndex] == keccak256(contributor, contributorExpectedTokens));
108 
109     uint256 numTokens = _numTokensForContributor(contributorExpectedTokens, state);
110     contributionHashes[contributorIndex] = 0x00000000000000000000000000000000;
111     tokensTransferred += numTokens;
112     if (tokensTransferred == actualTotalTokens) {
113       state = State.Done;
114     }
115 
116     require(tokenContract.transfer(contributor, numTokens));
117   }
118 
119   function doDistributionRange(uint256 start, address[] contributors,
120                                uint256[] contributorExpectedTokens) public {
121     require(contributors.length == contributorExpectedTokens.length);
122 
123     uint256 tokensTransferredThisCall = 0;
124     uint256 end = start + contributors.length;
125     State _state = state;
126     for (uint256 i = start; i < end; ++i) {
127       address contributor = contributors[i];
128       uint256 expectedTokens = contributorExpectedTokens[i];
129       require(contributionHashes[i] == keccak256(contributor, expectedTokens));
130       contributionHashes[i] = 0x00000000000000000000000000000000;
131 
132       uint256 numTokens = _numTokensForContributor(expectedTokens, _state);
133       tokensTransferredThisCall += numTokens;
134       require(tokenContract.transfer(contributor, numTokens));
135     }
136 
137     tokensTransferred += tokensTransferredThisCall;
138     if (tokensTransferred == actualTotalTokens) {
139       state = State.Done;
140     }
141   }
142 
143   function numTokensForContributor(uint256 contributorExpectedTokens)
144       public view returns (uint256) {
145     return _numTokensForContributor(contributorExpectedTokens, state);
146   }
147 
148   function temporaryEscapeHatch(address to, uint256 value, bytes data) public {
149     require(msg.sender == admin);
150     require(to.call.value(value)(data));
151   }
152 
153   function temporaryKill(address to) public {
154     require(msg.sender == admin);
155     require(state == State.Done);
156     require(tokenContract.balanceOf(this) == 0);
157     selfdestruct(to);
158   }
159 }