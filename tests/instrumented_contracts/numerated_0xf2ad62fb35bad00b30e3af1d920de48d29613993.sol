1 interface ERC20 {
2     function balanceOf(address _owner) public constant returns (uint256 balance);
3     function transfer(address _to, uint256 _value) public returns (bool success);
4 }
5 
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     require(c / a == b);
13     return c;
14   }
15 
16   //function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     //// require(b > 0); // Solidity automatically throws when dividing by 0
18     //uint256 c = a / b;
19     //// require(a == b * c + a % b); // There is no case in which this doesn't hold
20     //return c;
21   //}
22 
23   //function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     //require(b <= a);
25     //return a - b;
26   //}
27 
28   //function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     //uint256 c = a + b;
30     //require(c >= a);
31     //return c;
32   //}
33 }
34 
35 // A contract that distributes ERC20 tokens with predetermined terms.
36 // WARNING: This contract does not protect against malicious token contracts,
37 //          under the assumption that if the token sellers are malicious,
38 //          the tokens will be worthless anyway.
39 contract Distribution {
40   using SafeMath for uint256;
41 
42   enum State {
43     AwaitingTokens,
44     DistributingNormally,
45     DistributingProRata,
46     Done
47   }
48  
49   address admin;
50   ERC20 tokenContract;
51   State state;
52   uint256 actualTotalTokens;
53   uint256 tokensTransferred;
54 
55   bytes32[] contributionHashes;
56   uint256 expectedTotalTokens;
57 
58   function Distribution(address _admin, ERC20 _tokenContract,
59                         bytes32[] _contributionHashes, uint256 _expectedTotalTokens) public {
60     expectedTotalTokens = _expectedTotalTokens;
61     contributionHashes = _contributionHashes;
62     tokenContract = _tokenContract;
63     admin = _admin;
64 
65     state = State.AwaitingTokens;
66   }
67 
68   function handleTokensReceived() public {
69     require(state == State.AwaitingTokens);
70     uint256 totalTokens = tokenContract.balanceOf(this);
71     require(totalTokens > 0);
72 
73     tokensTransferred = 0;
74     if (totalTokens == expectedTotalTokens) {
75       state = State.DistributingNormally;
76     } else {
77       actualTotalTokens = totalTokens;
78       state = State.DistributingProRata;
79     }
80   }
81 
82   function _numTokensForContributor(uint256 contributorExpectedTokens,
83                                     uint256 _tokensTransferred, State _state)
84       internal view returns (uint256) {
85     if (_state == State.DistributingNormally) {
86       return contributorExpectedTokens;
87     } else if (_state == State.DistributingProRata) {
88       uint256 tokens = actualTotalTokens.mul(contributorExpectedTokens) / expectedTotalTokens;
89 
90       // Handle roundoff on last contributor.
91       uint256 tokensRemaining = actualTotalTokens - _tokensTransferred;
92       if (tokens < tokensRemaining) {
93         return tokens;
94       } else {
95         return tokensRemaining;
96       }
97     } else {
98       revert();
99     }
100   }
101 
102   function doDistribution(uint256 contributorIndex, address contributor,
103                           uint256 contributorExpectedTokens)
104       public {
105     // Make sure the arguments match the compressed storage.
106     require(contributionHashes[contributorIndex] == keccak256(contributor, contributorExpectedTokens));
107 
108     uint256 numTokens = _numTokensForContributor(contributorExpectedTokens,
109                                                  tokensTransferred, state);
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
123     uint256 tokensTransferredSoFar = tokensTransferred;
124     uint256 end = start + contributors.length;
125     State _state = state;
126     for (uint256 i = start; i < end; ++i) {
127       address contributor = contributors[i];
128       uint256 expectedTokens = contributorExpectedTokens[i];
129       require(contributionHashes[i] == keccak256(contributor, expectedTokens));
130       contributionHashes[i] = 0x00000000000000000000000000000000;
131 
132       uint256 numTokens = _numTokensForContributor(expectedTokens, tokensTransferredSoFar, _state);
133       tokensTransferredSoFar += numTokens;
134       require(tokenContract.transfer(contributor, numTokens));
135     }
136 
137     tokensTransferred = tokensTransferredSoFar;
138     if (tokensTransferred == actualTotalTokens) {
139       state = State.Done;
140     }
141   }
142 
143   function numTokensForContributor(uint256 contributorExpectedTokens)
144       public view returns (uint256) {
145     return _numTokensForContributor(contributorExpectedTokens, tokensTransferred, state);
146   }
147 
148   function temporaryEscapeHatch(address to, uint256 value, bytes data) public {
149     require(msg.sender == admin);
150     require(to.call.value(value)(data));
151   }
152 
153   function temporaryKill(address to) public {
154     require(msg.sender == admin);
155     require(tokenContract.balanceOf(this) == 0);
156     selfdestruct(to);
157   }
158 }
159 contract DistributionForTesting is Distribution {
160   function DistributionForTesting(address _admin, ERC20 _tokenContract,
161                                   bytes32[] _contributionHashes, uint256 _expectedTotalTokens)
162     Distribution(_admin, _tokenContract, _contributionHashes, _expectedTotalTokens) public { }
163 
164   function getContributionHash(address contributor, uint256 expectedTokens)
165       public pure returns (bytes32 result) {
166     result = keccak256(contributor, expectedTokens);
167   }
168 
169   function getNumTokensForContributorInternal(uint256 contributorExpectedTokens,
170                                               uint256 _tokensTransferred, State _state)
171       public view returns (uint256) {
172     return _numTokensForContributor(contributorExpectedTokens, _tokensTransferred, _state);
173   }
174 
175   function getAdmin() public pure returns (address) { return Distribution.admin; }
176   function getTokenContract() public pure returns (ERC20) { return Distribution.tokenContract; }
177   function getState() public pure returns (Distribution.State) { return Distribution.state; }
178   function getActualTotalTokens() public pure returns (uint256) { return Distribution.actualTotalTokens; }
179 
180   function getContributionHashes() public pure returns (bytes32[]) { return Distribution.contributionHashes; }
181   function getContributionHashByIndex(uint256 contributorIndex)
182       public view returns (bytes32) { return Distribution.contributionHashes[contributorIndex]; }
183   function getExpectedTotalTokens() public pure returns (uint256) { return Distribution.expectedTotalTokens; }
184 }