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
48  * This vesting smart contracts releases 25% of tokens 6 months after the smart contract was initialized,
49  * 50% of tokens after 1 year, 75% of tokens after 1 year 6 months and 100% tokens are available after 2 years.
50  * The withdrawal address is set during the initialization (initializeVestingFor function).
51  * To withdraw tokens, send an empty transaction to this smart contract address.
52  * Once vesting period (2 year) ends and after all tokens are withdrawn, this smart contract self-destructs.
53  */
54 contract TwoYearDreamTokensVesting {
55 
56     using SafeMath for uint256;
57 
58     /**
59      * Address of DREAM token.
60      */
61     ERC20TokenInterface public dreamToken;
62 
63     /**
64      * Address which will receive tokens. This address is set during initialization.
65      */
66     address public withdrawalAddress = 0x0;
67 
68     /**
69      * Tokens vesting stage structure with vesting date and tokens allowed to unlock.
70      */
71     struct VestingStage {
72         uint256 date;
73         uint256 tokensUnlockedPercentage;
74     }
75 
76     /**
77      * Array for storing all vesting stages with structure defined above.
78      */
79     VestingStage[4] public stages;
80 
81     /**
82      * Total amount of tokens to send.
83      */
84     uint256 public initialTokensBalance;
85 
86     /**
87      * Amount of tokens already sent.
88      */
89     uint256 public tokensSent;
90 
91     /**
92      * Unix timestamp at when the vesting has begun.
93      */
94     uint256 public vestingStartUnixTimestamp;
95 
96     /**
97      * Account that deployed this smart contract, which is authorized to initialize vesting.
98      */
99     address public deployer;
100 
101     modifier deployerOnly { require(msg.sender == deployer); _; }
102     modifier whenInitialized { require(withdrawalAddress != 0x0); _; }
103     modifier whenNotInitialized { require(withdrawalAddress == 0x0); _; }
104 
105     /**
106      * Event raised on each successful withdraw.
107      */
108     event Withdraw(uint256 amount, uint256 timestamp);
109 
110     /**
111      * Dedicate vesting smart contract for a particular token during deployment.
112      * @param token Address of DreamToken that will be locked on contract.
113      */
114     constructor (ERC20TokenInterface token) public {
115         dreamToken = token;
116         deployer = msg.sender;
117     }
118 
119     /**
120      * Fallback: function that releases locked tokens within schedule. Send an empty transaction to this
121      * smart contract for withdrawalAddress to receive tokens.
122      */
123     function () external {
124         withdrawTokens();
125     }
126 
127     /**
128      * Vesting initialization function. Contract deployer has to trigger this function after vesting amount
129      * was sent to this smart contract.
130      * @param account Account to initialize vesting for.
131      */
132     function initializeVestingFor (address account) external deployerOnly whenNotInitialized {
133         initialTokensBalance = dreamToken.balanceOf(this);
134         require(initialTokensBalance != 0);
135         withdrawalAddress = account;
136         vestingStartUnixTimestamp = block.timestamp;
137         vestingRules();
138     }
139 
140     /**
141      * Calculate tokens amount that is sent to withdrawalAddress.
142      * @return Amount of tokens that can be sent.
143      */
144     function getAvailableTokensToWithdraw () public view returns (uint256) {
145         uint256 tokensUnlockedPercentage = getTokensUnlockedPercentage();
146         // withdrawalAddress will only be able to get all additional tokens sent to this smart contract
147         // at the end of the vesting period
148         if (tokensUnlockedPercentage >= 100) {
149             return dreamToken.balanceOf(this);
150         } else {
151             return getTokensAmountAllowedToWithdraw(tokensUnlockedPercentage);
152         }
153     }
154 
155     /**
156      * Setup array with vesting stages dates and percentages.
157      */
158     function vestingRules () internal {
159 
160         uint256 halfOfYear = 183 days;
161         uint256 year = halfOfYear * 2;
162 
163         stages[0].date = vestingStartUnixTimestamp + halfOfYear;
164         stages[1].date = vestingStartUnixTimestamp + year;
165         stages[2].date = vestingStartUnixTimestamp + year + halfOfYear;
166         stages[3].date = vestingStartUnixTimestamp + (year * 2);
167 
168         stages[0].tokensUnlockedPercentage = 25;
169         stages[1].tokensUnlockedPercentage = 50;
170         stages[2].tokensUnlockedPercentage = 75;
171         stages[3].tokensUnlockedPercentage = 100;
172 
173     }
174 
175     /**
176      * Function for tokens withdrawal from the vesting smart contract. Triggered from the fallback function.
177      */
178     function withdrawTokens () private whenInitialized {
179         uint256 tokensToSend = getAvailableTokensToWithdraw();
180         sendTokens(tokensToSend);
181         if (dreamToken.balanceOf(this) == 0) { // When all tokens were sent, destroy this smart contract
182             selfdestruct(withdrawalAddress);
183         }
184     }
185 
186     /**
187      * Send tokens to withdrawalAddress.
188      * @param tokensToSend Amount of tokens will be sent.
189      */
190     function sendTokens (uint256 tokensToSend) private {
191         if (tokensToSend == 0) {
192             return;
193         }
194         tokensSent = tokensSent.add(tokensToSend); // Update tokensSent variable to send correct amount later
195         dreamToken.transfer(withdrawalAddress, tokensToSend); // Send allowed number of tokens
196         emit Withdraw(tokensToSend, now); // Emitting a notification that tokens were withdrawn
197     }
198 
199     /**
200      * Calculate tokens available for withdrawal.
201      * @param tokensUnlockedPercentage Percent of tokens that are allowed to be sent.
202      * @return Amount of tokens that can be sent according to provided percentage.
203      */
204     function getTokensAmountAllowedToWithdraw (uint256 tokensUnlockedPercentage) private view returns (uint256) {
205         uint256 totalTokensAllowedToWithdraw = initialTokensBalance.mul(tokensUnlockedPercentage).div(100);
206         uint256 unsentTokensAmount = totalTokensAllowedToWithdraw.sub(tokensSent);
207         return unsentTokensAmount;
208     }
209 
210     /**
211      * Get tokens unlocked percentage on current stage.
212      * @return Percent of tokens allowed to be sent.
213      */
214     function getTokensUnlockedPercentage () private view returns (uint256) {
215 
216         uint256 allowedPercent;
217 
218         for (uint8 i = 0; i < stages.length; i++) {
219             if (now >= stages[i].date) {
220                 allowedPercent = stages[i].tokensUnlockedPercentage;
221             }
222         }
223 
224         return allowedPercent;
225 
226     }
227 
228 }