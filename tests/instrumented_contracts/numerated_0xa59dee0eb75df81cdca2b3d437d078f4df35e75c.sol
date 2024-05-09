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
17 }
18 
19 contract Distribution {
20   using SafeMath for uint256;
21 
22   enum State {
23     AwaitingTokens,
24     DistributingNormally,
25     DistributingProRata,
26     Done
27   }
28  
29   address admin;
30   ERC20 tokenContract;
31   State state;
32   uint256 actualTotalTokens;
33   uint256 tokensTransferred;
34 
35   bytes32[] contributionHashes;
36   uint256 expectedTotalTokens;
37 
38   function Distribution(address _admin, ERC20 _tokenContract,
39                         bytes32[] _contributionHashes, uint256 _expectedTotalTokens) public {
40     expectedTotalTokens = _expectedTotalTokens;
41     contributionHashes = _contributionHashes;
42     tokenContract = _tokenContract;
43     admin = _admin;
44 
45     state = State.AwaitingTokens;
46   }
47 
48   function handleTokensReceived() public {
49     require(state == State.AwaitingTokens);
50     uint256 totalTokens = tokenContract.balanceOf(this);
51     require(totalTokens > 0);
52 
53     tokensTransferred = 0;
54     if (totalTokens == expectedTotalTokens) {
55       state = State.DistributingNormally;
56     } else {
57       actualTotalTokens = totalTokens;
58       state = State.DistributingProRata;
59     }
60   }
61 
62   function _numTokensForContributor(uint256 contributorExpectedTokens,
63                                     uint256 _tokensTransferred, State _state)
64       internal view returns (uint256) {
65     if (_state == State.DistributingNormally) {
66       return contributorExpectedTokens;
67     } else if (_state == State.DistributingProRata) {
68       uint256 tokens = actualTotalTokens.mul(contributorExpectedTokens) / expectedTotalTokens;
69 
70       // Handle roundoff on last contributor.
71       uint256 tokensRemaining = actualTotalTokens - _tokensTransferred;
72       if (tokens < tokensRemaining) {
73         return tokens;
74       } else {
75         return tokensRemaining;
76       }
77     } else {
78       revert();
79     }
80   }
81 
82   function doDistribution(uint256 contributorIndex, address contributor,
83                           uint256 contributorExpectedTokens)
84       public {
85     // Make sure the arguments match the compressed storage.
86     require(contributionHashes[contributorIndex] == keccak256(contributor, contributorExpectedTokens));
87 
88     uint256 numTokens = _numTokensForContributor(contributorExpectedTokens,
89                                                  tokensTransferred, state);
90     contributionHashes[contributorIndex] = 0x00000000000000000000000000000000;
91     tokensTransferred += numTokens;
92     if (tokensTransferred == actualTotalTokens) {
93       state = State.Done;
94     }
95 
96     require(tokenContract.transfer(contributor, numTokens));
97   }
98 
99   function doDistributionRange(uint256 start, address[] contributors,
100                                uint256[] contributorExpectedTokens) public {
101     require(contributors.length == contributorExpectedTokens.length);
102 
103     uint256 tokensTransferredSoFar = tokensTransferred;
104     uint256 end = start + contributors.length;
105     State _state = state;
106     for (uint256 i = start; i < end; ++i) {
107       address contributor = contributors[i];
108       uint256 expectedTokens = contributorExpectedTokens[i];
109       require(contributionHashes[i] == keccak256(contributor, expectedTokens));
110       contributionHashes[i] = 0x00000000000000000000000000000000;
111 
112       uint256 numTokens = _numTokensForContributor(expectedTokens, tokensTransferredSoFar, _state);
113       tokensTransferredSoFar += numTokens;
114       require(tokenContract.transfer(contributor, numTokens));
115     }
116 
117     tokensTransferred = tokensTransferredSoFar;
118     if (tokensTransferred == actualTotalTokens) {
119       state = State.Done;
120     }
121   }
122 
123   function numTokensForContributor(uint256 contributorExpectedTokens)
124       public view returns (uint256) {
125     return _numTokensForContributor(contributorExpectedTokens, tokensTransferred, state);
126   }
127 
128   function temporaryEscapeHatch(address to, uint256 value, bytes data) public {
129     require(msg.sender == admin);
130     require(to.call.value(value)(data));
131   }
132 
133   function temporaryKill(address to) public {
134     require(msg.sender == admin);
135     require(tokenContract.balanceOf(this) == 0);
136     selfdestruct(to);
137   }
138 }