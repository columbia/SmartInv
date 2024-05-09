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
31   State public state;
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
48   function _handleTokensReceived(uint256 totalTokens) internal {
49     require(state == State.AwaitingTokens);
50     require(totalTokens > 0);
51 
52     tokensTransferred = 0;
53     if (totalTokens == expectedTotalTokens) {
54       state = State.DistributingNormally;
55     } else {
56       actualTotalTokens = totalTokens;
57       state = State.DistributingProRata;
58     }
59   }
60 
61   function handleTokensReceived() public {
62     _handleTokensReceived(tokenContract.balanceOf(this));
63   }
64 
65   function tokenFallback(address /*_from*/, uint _value, bytes /*_data*/) public {
66     require(msg.sender == address(tokenContract));
67     _handleTokensReceived(_value);
68   }
69 
70   function _numTokensForContributor(uint256 contributorExpectedTokens,
71                                     uint256 _tokensTransferred, State _state)
72       internal view returns (uint256) {
73     if (_state == State.DistributingNormally) {
74       return contributorExpectedTokens;
75     } else if (_state == State.DistributingProRata) {
76       uint256 tokens = actualTotalTokens.mul(contributorExpectedTokens) / expectedTotalTokens;
77 
78       uint256 tokensRemaining = actualTotalTokens - _tokensTransferred;
79       if (tokens < tokensRemaining) {
80         return tokens;
81       } else {
82         return tokensRemaining;
83       }
84     } else {
85       revert();
86     }
87   }
88 
89   function doDistributionRange(uint256 start, address[] contributors,
90                                uint256[] contributorExpectedTokens) public {
91     require(contributors.length == contributorExpectedTokens.length);
92 
93     uint256 tokensTransferredSoFar = tokensTransferred;
94     uint256 end = start + contributors.length;
95     State _state = state;
96     for (uint256 i = start; i < end; ++i) {
97       address contributor = contributors[i];
98       uint256 expectedTokens = contributorExpectedTokens[i];
99       require(contributionHashes[i] == keccak256(contributor, expectedTokens));
100       contributionHashes[i] = 0x00000000000000000000000000000000;
101 
102       uint256 numTokens = _numTokensForContributor(expectedTokens, tokensTransferredSoFar, _state);
103       tokensTransferredSoFar += numTokens;
104       require(tokenContract.transfer(contributor, numTokens));
105     }
106 
107     tokensTransferred = tokensTransferredSoFar;
108     if (tokensTransferred == actualTotalTokens) {
109       state = State.Done;
110     }
111   }
112 
113   function numTokensForContributor(uint256 contributorExpectedTokens)
114       public view returns (uint256) {
115     return _numTokensForContributor(contributorExpectedTokens, tokensTransferred, state);
116   }
117 
118   function temporaryEscapeHatch(address to, uint256 value, bytes data) public {
119     require(msg.sender == admin);
120     require(to.call.value(value)(data));
121   }
122 }