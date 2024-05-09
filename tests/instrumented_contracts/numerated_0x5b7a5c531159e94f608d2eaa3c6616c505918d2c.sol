1 pragma solidity ^0.4.19;
2 
3 interface ERC20 {
4     function balanceOf(address _owner) public constant returns (uint256 balance);
5     function transfer(address _to, uint256 _value) public returns (bool success);
6 }
7 
8 interface ERC223ReceivingContract {
9     function tokenFallback(address _from, uint _value, bytes _data) public;
10 }
11 
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     require(c / a == b);
19     return c;
20   }
21 }
22 
23 contract Distribution {
24   using SafeMath for uint256;
25 
26   enum State {
27     AwaitingTokens,
28     DistributingNormally,
29     DistributingProRata,
30     Done
31   }
32  
33   address admin;
34   ERC20 tokenContract;
35   State public state;
36   uint256 actualTotalTokens;
37   uint256 tokensTransferred;
38 
39   bytes32[] contributionHashes;
40   uint256 expectedTotalTokens;
41 
42   function Distribution(address _admin, ERC20 _tokenContract,
43                         bytes32[] _contributionHashes, uint256 _expectedTotalTokens) public {
44     expectedTotalTokens = _expectedTotalTokens;
45     contributionHashes = _contributionHashes;
46     tokenContract = _tokenContract;
47     admin = _admin;
48 
49     state = State.AwaitingTokens;
50   }
51 
52   function _handleTokensReceived(uint256 totalTokens) internal {
53     require(state == State.AwaitingTokens);
54     require(totalTokens > 0);
55 
56     tokensTransferred = 0;
57     if (totalTokens == expectedTotalTokens) {
58       state = State.DistributingNormally;
59     } else {
60       actualTotalTokens = totalTokens;
61       state = State.DistributingProRata;
62     }
63   }
64 
65   function handleTokensReceived() public {
66     _handleTokensReceived(tokenContract.balanceOf(this));
67   }
68 
69   function tokenFallback(address /*_from*/, uint _value, bytes /*_data*/) public {
70     require(msg.sender == address(tokenContract));
71     _handleTokensReceived(_value);
72   }
73 
74   function _numTokensForContributor(uint256 contributorExpectedTokens,
75                                     uint256 _tokensTransferred, State _state)
76       internal view returns (uint256) {
77     if (_state == State.DistributingNormally) {
78       return contributorExpectedTokens;
79     } else if (_state == State.DistributingProRata) {
80       uint256 tokens = actualTotalTokens.mul(contributorExpectedTokens) / expectedTotalTokens;
81 
82       // Handle roundoff on last contributor.
83       uint256 tokensRemaining = actualTotalTokens - _tokensTransferred;
84       if (tokens < tokensRemaining) {
85         return tokens;
86       } else {
87         return tokensRemaining;
88       }
89     } else {
90       revert();
91     }
92   }
93 
94   function doDistributionRange(uint256 start, address[] contributors,
95                                uint256[] contributorExpectedTokens) public {
96     require(contributors.length == contributorExpectedTokens.length);
97 
98     uint256 tokensTransferredSoFar = tokensTransferred;
99     uint256 end = start + contributors.length;
100     State _state = state;
101     for (uint256 i = start; i < end; ++i) {
102       address contributor = contributors[i];
103       uint256 expectedTokens = contributorExpectedTokens[i];
104       require(contributionHashes[i] == keccak256(contributor, expectedTokens));
105       contributionHashes[i] = 0x00000000000000000000000000000000;
106 
107       uint256 numTokens = _numTokensForContributor(expectedTokens, tokensTransferredSoFar, _state);
108       tokensTransferredSoFar += numTokens;
109       require(tokenContract.transfer(contributor, numTokens));
110     }
111 
112     tokensTransferred = tokensTransferredSoFar;
113     if (tokensTransferred == actualTotalTokens) {
114       state = State.Done;
115     }
116   }
117 
118   function numTokensForContributor(uint256 contributorExpectedTokens)
119       public view returns (uint256) {
120     return _numTokensForContributor(contributorExpectedTokens, tokensTransferred, state);
121   }
122 
123   function temporaryEscapeHatch(address to, uint256 value, bytes data) public {
124     require(msg.sender == admin);
125     require(to.call.value(value)(data));
126   }
127 }