1 pragma solidity 0.4.11;
2 
3   contract SafeMath {
4 
5     function safeMul(uint a, uint b) internal returns (uint) {
6       uint c = a * b;
7       assert(a == 0 || c / a == b);
8       return c;
9     }
10     function safeSub(uint a, uint b) internal returns (uint) {
11       assert(b <= a);
12       return a - b;
13     }
14     function safeAdd(uint a, uint b) internal returns (uint) {
15       uint c = a + b;
16       assert(c>=a && c>=b);
17       return c;
18     }
19 
20     // mitigate short address attack
21     // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
22     // TODO: doublecheck implication of >= compared to ==
23     modifier onlyPayloadSize(uint numWords) {
24        assert(msg.data.length >= numWords * 32 + 4);
25        _;
26     }
27 
28   }
29 
30   contract Token { // ERC20 standard
31 
32       function balanceOf(address _owner) constant returns (uint256 balance);
33       function transfer(address _to, uint256 _value) returns (bool success);
34       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35       function approve(address _spender, uint256 _value) returns (bool success);
36       function allowance(address _owner, address _spender) constant returns (uint256 remaining);
37       event Transfer(address indexed _from, address indexed _to, uint256 _value);
38       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40   }
41 
42    contract C20Vesting is SafeMath {
43 
44       address public beneficiary;
45       uint256 public fundingEndBlock;
46 
47       bool private initClaim = false; // state tracking variables
48 
49       uint256 public firstRelease; // vesting times
50       bool private firstDone = false;
51       uint256 public secondRelease;
52       bool private secondDone = false;
53       uint256 public thirdRelease;
54       bool private thirdDone = false;
55       uint256 public fourthRelease;
56 
57       Token public ERC20Token; // ERC20 basic token contract to hold
58 
59       enum Stages {
60           initClaim,
61           firstRelease,
62           secondRelease,
63           thirdRelease,
64           fourthRelease
65       }
66 
67       Stages public stage = Stages.initClaim;
68 
69       modifier atStage(Stages _stage) {
70           if(stage == _stage) _;
71       }
72 
73       function C20Vesting(address _token, uint256 fundingEndBlockInput) {
74           require(_token != address(0));
75           beneficiary = msg.sender;
76           fundingEndBlock = fundingEndBlockInput;
77           ERC20Token = Token(_token);
78       }
79 
80       function changeBeneficiary(address newBeneficiary) external {
81           require(newBeneficiary != address(0));
82           require(msg.sender == beneficiary);
83           beneficiary = newBeneficiary;
84       }
85 
86       function updateFundingEndBlock(uint256 newFundingEndBlock) {
87           require(msg.sender == beneficiary);
88           require(block.number < fundingEndBlock);
89           require(block.number < newFundingEndBlock);
90           fundingEndBlock = newFundingEndBlock;
91       }
92 
93       function checkBalance() constant returns (uint256 tokenBalance) {
94           return ERC20Token.balanceOf(this);
95       }
96 
97       // in total 13% of C20 tokens will be sent to this contract
98       // EXPENSE ALLOCATION: 5.5%       | TEAM ALLOCATION: 7.5% (vest over 2 years)
99       //   2.5% - Marketing             | initalPayment: 1.5%
100       //   1% - Security                | firstRelease: 1.5%
101       //   1% - legal                   | secondRelease: 1.5%
102       //   0.5% - Advisors              | thirdRelease: 1.5%
103       //   0.5% - Boutnty               | fourthRelease: 1.5%
104       // initial claim is tot expenses + initial team payment
105       // initial claim is thus (5.5 + 1.5)/13 = 53.846153846% of C20 tokens sent here
106       // each other release (for team) is 11.538461538% of tokens sent here
107 
108       function claim() external {
109           require(msg.sender == beneficiary);
110           require(block.number > fundingEndBlock);
111           uint256 balance = ERC20Token.balanceOf(this);
112           // in reverse order so stages changes don't carry within one claim
113           fourth_release(balance);
114           third_release(balance);
115           second_release(balance);
116           first_release(balance);
117           init_claim(balance);
118       }
119 
120       function nextStage() private {
121           stage = Stages(uint256(stage) + 1);
122       }
123 
124       function init_claim(uint256 balance) private atStage(Stages.initClaim) {
125           firstRelease = now + 26 weeks; // assign 4 claiming times
126           secondRelease = firstRelease + 26 weeks;
127           thirdRelease = secondRelease + 26 weeks;
128           fourthRelease = thirdRelease + 26 weeks;
129           uint256 amountToTransfer = safeMul(balance, 53846153846) / 100000000000;
130           ERC20Token.transfer(beneficiary, amountToTransfer); // now 46.153846154% tokens left
131           nextStage();
132       }
133       function first_release(uint256 balance) private atStage(Stages.firstRelease) {
134           require(now > firstRelease);
135           uint256 amountToTransfer = balance / 4;
136           ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases
137           nextStage();
138       }
139       function second_release(uint256 balance) private atStage(Stages.secondRelease) {
140           require(now > secondRelease);
141           uint256 amountToTransfer = balance / 3;
142           ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases
143           nextStage();
144       }
145       function third_release(uint256 balance) private atStage(Stages.thirdRelease) {
146           require(now > thirdRelease);
147           uint256 amountToTransfer = balance / 2;
148           ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases
149           nextStage();
150       }
151       function fourth_release(uint256 balance) private atStage(Stages.fourthRelease) {
152           require(now > fourthRelease);
153           ERC20Token.transfer(beneficiary, balance); // send remaining 25 % of team releases
154       }
155 
156       function claimOtherTokens(address _token) external {
157           require(msg.sender == beneficiary);
158           require(_token != address(0));
159           Token token = Token(_token);
160           require(token != ERC20Token);
161           uint256 balance = token.balanceOf(this);
162           token.transfer(beneficiary, balance);
163        }
164 
165    }