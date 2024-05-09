1 pragma solidity 0.4.18;
2 
3 contract Token { // ERC20 standard
4 
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 /**
15  * Overflow aware uint math functions.
16  *
17  * Inspired by https://github.com/makerdao/maker-otc/blob/master/src/simple_market.sol
18  */
19 
20 contract SafeMath {
21 
22   function safeMul(uint a, uint b) pure internal returns (uint) {
23     uint c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27   function safeSub(uint a, uint b) pure internal returns (uint) {
28     assert(b <= a);
29     return a - b;
30   }
31   function safeAdd(uint a, uint b) pure internal returns (uint) {
32     uint c = a + b;
33     assert(c>=a && c>=b);
34     return c;
35   }
36   function safeNumDigits(uint number) pure internal returns (uint8) {
37     uint8 digits = 0;
38     while (number != 0) {
39         number /= 10;
40         digits++;
41     }
42     return digits;
43 }
44 
45   // mitigate short address attack
46   // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
47   // TODO: doublecheck implication of >= compared to ==
48   modifier onlyPayloadSize(uint numWords) {
49      assert(msg.data.length >= numWords * 32 + 4);
50      _;
51   }
52 
53 }
54 /**
55  * @title GROVesting
56  * @dev GROVesting is a token holder contract that allows the specified beneficiary
57  * to claim stored tokens after 6 & 12 month intervals
58  */
59 
60 contract GROVesting is SafeMath {
61 
62   address public beneficiary;
63   uint256 public fundingEndBlock;
64 
65   bool private initClaim = false; // state tracking variables
66 
67   uint256 public firstRelease; // vesting times
68   bool private firstDone = false;
69   uint256 public secondRelease;
70   bool private secondDone = false;
71   uint256 public thirdRelease;
72 
73   Token public ERC20Token; // ERC20 basic token contract to hold
74 
75   enum Stages {
76     initClaim,
77     firstRelease,
78     secondRelease,
79     thirdRelease
80   }
81 
82   Stages public stage = Stages.initClaim;
83 
84   modifier atStage(Stages _stage){
85     if (stage == _stage) _;
86   }
87 
88   modifier onlyBeneficiary {
89     require(msg.sender == beneficiary);
90     _;
91   }
92 
93   function GROVesting() public {
94     beneficiary = msg.sender;
95   }
96 
97   // Not all deployment clients support constructor arguments.
98   // This function is provided for maximum compatibility. 
99   function initialiseContract(address _token, uint256 fundingEndBlockInput) external onlyBeneficiary {
100     require(_token != address(0));
101     fundingEndBlock = fundingEndBlockInput;
102     ERC20Token = Token(_token);
103   }
104     
105   function changeBeneficiary(address newBeneficiary) external {
106     require(newBeneficiary != address(0));
107     require(msg.sender == beneficiary);
108     beneficiary = newBeneficiary;
109   }
110 
111   function updateFundingEndBlock(uint256 newFundingEndBlock) public {
112     require(msg.sender == beneficiary);
113     require(currentBlock() < fundingEndBlock);
114     require(currentBlock() < newFundingEndBlock);
115     fundingEndBlock = newFundingEndBlock;
116   }
117 
118   function checkBalance() public constant returns (uint256 tokenBalance) {
119     return ERC20Token.balanceOf(this);
120   }
121 
122   // in total 40% of GRO tokens will be sent to this contract
123   // EXPENSE ALLOCATION: 28%          | TEAM ALLOCATION: 12% (vest over 2 years)
124   //   12% - Incentives and bonuses
125   //   16% - Bankroll                 
126   //                                  
127   //   Expenses Breakdown:
128   //   50% - Software Development
129   //   15% - Operations
130   //   15% - Advisors
131   //   10% - Marketing
132   //   5% - Legal Framework & Finance
133   //   5% - Contingencies
134   //
135   // initial claim is bankroll - 16% = 152000000
136   // first release after 6 months - Incentives and bonuses - 12%
137   // second release after 12 months - Founders - 6%
138   // third release after 24 months - Founders - 6%
139 
140   function claim() external {
141     require(msg.sender == beneficiary);
142     require(currentBlock() > fundingEndBlock);
143     uint256 balance = ERC20Token.balanceOf(this);
144     // in reverse order so stages changes don't carry within one claim
145     third_release(balance);
146     second_release(balance);
147     first_release(balance);
148     init_claim(balance);
149   }
150 
151   function nextStage() private {
152     stage = Stages(uint256(stage) + 1);
153   }
154 
155   function init_claim(uint256 balance) private atStage(Stages.initClaim) {
156     firstRelease = currentTime() + 26 weeks;                          // Incentives and bonuses
157     secondRelease = currentTime() + 52 weeks;                         // Founders
158     thirdRelease = secondRelease + 52 weeks;                // Founders
159     uint256 amountToTransfer = safeMul(balance, 40) / 100;  // send 100% of Bankroll - 40% of Expense Allocation
160     ERC20Token.transfer(beneficiary, amountToTransfer);     // now 60% tokens left
161     nextStage();
162   }
163   function first_release(uint256 balance) private atStage(Stages.firstRelease) {
164     require(currentTime() > firstRelease);
165     uint256 amountToTransfer = safeMul(balance, 30) / 100;  // send 100% of incentives and bonuses - 30% of Expense Allocation
166     ERC20Token.transfer(beneficiary, amountToTransfer);     // now 30% tokens left
167     nextStage();
168   }
169   function second_release(uint256 balance) private atStage(Stages.secondRelease) {
170     require(currentTime() > secondRelease);
171     uint256 amountToTransfer = balance / 2;             // send 50% of founders release - 15% of Expense Allocation
172     ERC20Token.transfer(beneficiary, amountToTransfer); // now 15% tokens left
173     nextStage();
174   }
175   function third_release(uint256 balance) private atStage(Stages.thirdRelease) {
176     require(currentTime() > thirdRelease);
177     uint256 amountToTransfer = balance;                 // send 50% of founders release - 15% of Expense Allocation
178     ERC20Token.transfer(beneficiary, amountToTransfer);
179     nextStage();
180   }
181 
182   function claimOtherTokens(address _token) external {
183     require(msg.sender == beneficiary);
184     require(_token != address(0));
185     Token token = Token(_token);
186     require(token != ERC20Token);
187     uint256 balance = token.balanceOf(this);
188     token.transfer(beneficiary, balance);
189   }
190 
191   function currentBlock() private constant returns(uint256 _currentBlock) {
192     return block.number;
193   }
194 
195   function currentTime() private constant returns(uint256 _currentTime) {
196     return now;
197   } 
198 }