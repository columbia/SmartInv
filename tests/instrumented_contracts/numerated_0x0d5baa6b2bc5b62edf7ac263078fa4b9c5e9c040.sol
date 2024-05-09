1 pragma solidity 0.4.24;
2 
3 contract ERC20TokenInterface {
4 
5     function totalSupply () external constant returns (uint);
6     function balanceOf (address tokenOwner) external constant returns (uint balance);
7     function transfer (address to, uint tokens) external returns (bool success);
8     function transferFrom (address from, address to, uint tokens) external returns (bool success);
9 
10 }
11 
12 /**
13  * Math operations with safety checks that throw on overflows.
14  */
15 library SafeMath {
16 
17     function mul (uint256 a, uint256 b) internal pure returns (uint256 c) {
18         if (a == 0) {
19             return 0;
20         }
21         c = a * b;
22         require(c / a == b);
23         return c;
24     }
25 
26     function div (uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         // uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return a / b;
31     }
32 
33     function sub (uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b <= a);
35         return a - b;
36     }
37 
38     function add (uint256 a, uint256 b) internal pure returns (uint256 c) {
39         c = a + b;
40         require(c >= a);
41         return c;
42     }
43 
44 }
45 
46 /**
47  * DreamTeam tokens vesting smart contract. 
48  * This vesting smart contracts unlocks 50% of the tokens for `withdrawalAddress` on December 25, 2018.
49  * Other 50% are unlocked on 30 June, 2019.
50  * The withdrawal address is set during the initialization (initializeVestingFor function).
51  * To withdraw tokens, send an empty transaction to this smart contract address (just like you send Ether, but set
52  * amount to transfer to 0 instead).
53  * Once vesting period (1 year) ends and after all DREAM tokens are withdrawn, this smart contract self-destructs.
54  */
55 contract OneYearDreamTokensVestingAdvisors {
56 
57     using SafeMath for uint256;
58 
59     /**
60      * Address of DREAM token.
61      */
62     ERC20TokenInterface public dreamToken;
63 
64     /**
65      * Address which will receive tokens. This address is set during initialization.
66      */
67     address public withdrawalAddress = 0x0;
68 
69     /**
70      * Tokens vesting stage structure with vesting date and tokens allowed to unlock.
71      */
72     struct VestingStage {
73         uint256 date;
74         uint256 tokensUnlockedPercentage;
75     }
76 
77     /**
78      * Array for storing all vesting stages with structure defined above.
79      */
80     VestingStage[2] public stages;
81 
82     /**
83      * Total amount of tokens to send.
84      */
85     uint256 public initialTokensBalance;
86 
87     /**
88      * Amount of tokens already sent.
89      */
90     uint256 public tokensSent;
91 
92     /**
93      * Account that deployed this smart contract, which is authorized to initialize vesting.
94      */
95     address public deployer;
96 
97     modifier deployerOnly { require(msg.sender == deployer); _; }
98     modifier whenInitialized { require(withdrawalAddress != 0x0); _; }
99     modifier whenNotInitialized { require(withdrawalAddress == 0x0); _; }
100 
101     /**
102      * Event raised on each successful withdraw.
103      */
104     event Withdraw(uint256 amount, uint256 timestamp);
105 
106     /**
107      * Dedicate vesting smart contract for a particular token during deployment.
108      * @param token Address of DreamToken that will be locked on contract.
109      */
110     constructor (ERC20TokenInterface token) public {
111         dreamToken = token;
112         deployer = msg.sender;
113     }
114 
115     /**
116      * Fallback: function that releases locked tokens within schedule. Send an empty transaction to this
117      * smart contract for withdrawalAddress to receive tokens.
118      */
119     function () external {
120         withdrawTokens();
121     }
122 
123     /**
124      * Vesting initialization function. Contract deployer has to trigger this function after vesting amount
125      * was sent to this smart contract.
126      * @param account Account to initialize vesting for.
127      */
128     function initializeVestingFor (address account) external deployerOnly whenNotInitialized {
129         initialTokensBalance = dreamToken.balanceOf(this);
130         require(initialTokensBalance != 0);
131         withdrawalAddress = account;
132         vestingRules();
133     }
134 
135     /**
136      * Calculate tokens amount that is sent to withdrawalAddress.
137      * @return Amount of tokens that can be sent.
138      */
139     function getAvailableTokensToWithdraw () public view returns (uint256) {
140         uint256 tokensUnlockedPercentage = getTokensUnlockedPercentage();
141         // withdrawalAddress will only be able to get all additional tokens sent to this smart contract
142         // at the end of the vesting period
143         if (tokensUnlockedPercentage >= 100) {
144             return dreamToken.balanceOf(this);
145         } else {
146             return getTokensAmountAllowedToWithdraw(tokensUnlockedPercentage);
147         }
148     }
149 
150     /**
151      * Setup array with vesting stages dates and percentages.
152      */
153     function vestingRules () internal {
154 
155         stages[0].date = 1545696000; // December 25, 2018
156         stages[1].date = 1561852800; // June 30, 2018
157 
158         stages[0].tokensUnlockedPercentage = 50;
159         stages[1].tokensUnlockedPercentage = 100;
160 
161     }
162 
163     /**
164      * Function for tokens withdrawal from the vesting smart contract. Triggered from the fallback function.
165      */
166     function withdrawTokens () private whenInitialized {
167         uint256 tokensToSend = getAvailableTokensToWithdraw();
168         sendTokens(tokensToSend);
169         if (dreamToken.balanceOf(this) == 0) { // When all tokens were sent, destroy this smart contract
170             selfdestruct(withdrawalAddress);
171         }
172     }
173 
174     /**
175      * Send tokens to withdrawalAddress.
176      * @param tokensToSend Amount of tokens will be sent.
177      */
178     function sendTokens (uint256 tokensToSend) private {
179         if (tokensToSend == 0) {
180             return;
181         }
182         tokensSent = tokensSent.add(tokensToSend); // Update tokensSent variable to send correct amount later
183         dreamToken.transfer(withdrawalAddress, tokensToSend); // Send allowed number of tokens
184         emit Withdraw(tokensToSend, now); // Emitting a notification that tokens were withdrawn
185     }
186 
187     /**
188      * Calculate tokens available for withdrawal.
189      * @param tokensUnlockedPercentage Percent of tokens that are allowed to be sent.
190      * @return Amount of tokens that can be sent according to provided percentage.
191      */
192     function getTokensAmountAllowedToWithdraw (uint256 tokensUnlockedPercentage) private view returns (uint256) {
193         uint256 totalTokensAllowedToWithdraw = initialTokensBalance.mul(tokensUnlockedPercentage).div(100);
194         uint256 unsentTokensAmount = totalTokensAllowedToWithdraw.sub(tokensSent);
195         return unsentTokensAmount;
196     }
197 
198     /**
199      * Get tokens unlocked percentage on current stage.
200      * @return Percent of tokens allowed to be sent.
201      */
202     function getTokensUnlockedPercentage () private view returns (uint256) {
203 
204         uint256 allowedPercent;
205 
206         for (uint8 i = 0; i < stages.length; i++) {
207             if (now >= stages[i].date) {
208                 allowedPercent = stages[i].tokensUnlockedPercentage;
209             }
210         }
211 
212         return allowedPercent;
213 
214     }
215 
216 }