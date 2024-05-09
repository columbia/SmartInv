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
19 
20 contract Distribution {
21   using SafeMath for uint256;
22 
23   enum State {
24     AwaitingTokens,
25     DistributingNormally,
26     DistributingProRata,
27     Done
28   }
29  
30   address admin;
31   ERC20 tokenContract;
32   State state;
33   uint256 actualTotalTokens;
34   uint256 tokensTransferred;
35 
36   bytes32[] contributionHashes;
37   uint256 expectedTotalTokens;
38 
39   function Distribution(address _admin, ERC20 _tokenContract,
40                         bytes32[] _contributionHashes, uint256 _expectedTotalTokens) public {
41     expectedTotalTokens = _expectedTotalTokens;
42     contributionHashes = _contributionHashes;
43     tokenContract = _tokenContract;
44     admin = _admin;
45 
46     state = State.AwaitingTokens;
47   }
48 
49   function handleTokensReceived() public {
50     require(state == State.AwaitingTokens);
51     uint256 totalTokens = tokenContract.balanceOf(this);
52     require(totalTokens > 0);
53 
54     tokensTransferred = 0;
55     if (totalTokens == expectedTotalTokens) {
56       state = State.DistributingNormally;
57     } else {
58       actualTotalTokens = totalTokens;
59       state = State.DistributingProRata;
60     }
61   }
62 
63   function _numTokensForContributor(uint256 contributorExpectedTokens, State _state)
64       internal view returns (uint256) {
65     if (_state == State.DistributingNormally) {
66       return contributorExpectedTokens;
67     } else if (_state == State.DistributingProRata) {
68       uint256 tokensRemaining = actualTotalTokens - tokensTransferred;
69       uint256 tokens = actualTotalTokens.mul(contributorExpectedTokens) / expectedTotalTokens;
70 
71       // Handle roundoff on last contributor.
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
85     require(contributionHashes[contributorIndex] == keccak256(contributor, contributorExpectedTokens));
86 
87     uint256 numTokens = _numTokensForContributor(contributorExpectedTokens, state);
88     contributionHashes[contributorIndex] = 0x00000000000000000000000000000000;
89     tokensTransferred += numTokens;
90     if (tokensTransferred == actualTotalTokens) {
91       state = State.Done;
92     }
93 
94     require(tokenContract.transfer(contributor, numTokens));
95   }
96 
97   function doDistributionRange(uint256 start, address[] contributors,
98                                uint256[] contributorExpectedTokens) public {
99     require(contributors.length == contributorExpectedTokens.length);
100 
101     uint256 tokensTransferredThisCall = 0;
102     uint256 end = start + contributors.length;
103     State _state = state;
104     for (uint256 i = start; i < end; ++i) {
105       address contributor = contributors[i];
106       uint256 expectedTokens = contributorExpectedTokens[i];
107       require(contributionHashes[i] == keccak256(contributor, expectedTokens));
108       contributionHashes[i] = 0x00000000000000000000000000000000;
109 
110       uint256 numTokens = _numTokensForContributor(expectedTokens, _state);
111       tokensTransferredThisCall += numTokens;
112       require(tokenContract.transfer(contributor, numTokens));
113     }
114 
115     tokensTransferred += tokensTransferredThisCall;
116     if (tokensTransferred == actualTotalTokens) {
117       state = State.Done;
118     }
119   }
120 
121   function numTokensForContributor(uint256 contributorExpectedTokens)
122       public view returns (uint256) {
123     return _numTokensForContributor(contributorExpectedTokens, state);
124   }
125 
126   function temporaryEscapeHatch(address to, uint256 value, bytes data) public {
127     require(msg.sender == admin);
128     require(to.call.value(value)(data));
129   }
130 
131   function temporaryKill(address to) public {
132     require(msg.sender == admin);
133     require(tokenContract.balanceOf(this) == 0);
134     selfdestruct(to);
135   }
136 }