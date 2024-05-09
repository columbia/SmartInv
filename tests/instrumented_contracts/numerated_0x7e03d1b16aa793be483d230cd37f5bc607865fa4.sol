1 pragma solidity 0.5.8;
2 
3 contract ERC20TokenInterface {
4 
5     function totalSupply () external view returns (uint);
6     function balanceOf (address tokenOwner) external view returns (uint balance);
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
50  * 0.1% of tokens are available right after vesting contract initialization.
51  * The withdrawal address is set during the initialization (initializeVestingFor function).
52  * To withdraw tokens, send an empty transaction to this smart contract address (send 0 ETH).
53  * Once vesting period (2 year) ends and after all tokens are withdrawn, this smart contract self-destructs.
54  */
55 contract TwoYearDreamTokensVesting {
56 
57     /**
58      * Sets up an array with vesting stages dates and percentages.
59      */
60     function vestingRules () internal {
61 
62         uint256 year = halfOfYear * 2;
63                                                                         // Token availability stages:
64         stages[0].date = vestingStartUnixTimestamp;                     // Right after initialization
65         stages[1].date = vestingStartUnixTimestamp + halfOfYear;        // 1/2 years after initialization
66         stages[2].date = vestingStartUnixTimestamp + year;              // 1 year after initialization
67         stages[3].date = vestingStartUnixTimestamp + year + halfOfYear; // 1 + 1/2 years after initialization
68         stages[4].date = vestingStartUnixTimestamp + (year * 2);        // 2 years after initialization
69                                                     // Token availability values:
70         stages[0].tokensUnlockedPercentage = 10;    // 0.1%
71         stages[1].tokensUnlockedPercentage = 2500;  // 25%
72         stages[2].tokensUnlockedPercentage = 5000;  // 50%
73         stages[3].tokensUnlockedPercentage = 7500;  // 75%
74         stages[4].tokensUnlockedPercentage = 10000; // 100%
75 
76     }
77 
78     using SafeMath for uint256;
79 
80     /**
81      * Address of DREAM token.
82      */
83     ERC20TokenInterface public dreamToken;
84 
85     /**
86      * Address which will receive tokens. This address is set during initialization.
87      */
88     address payable public withdrawalAddress = address(0x0);
89     
90     uint256 public constant halfOfYear = 182 days + 15 hours; // x2 = ~365.25 days in a year
91 
92     /**
93      * Tokens vesting stage structure with vesting date and tokens allowed to unlock.
94      */
95     struct VestingStage {
96         uint256 date;
97         uint256 tokensUnlockedPercentage;
98     }
99 
100     /**
101      * Array for storing all vesting stages with structure defined above.
102      */
103     VestingStage[5] public stages;
104 
105     /**
106      * Total amount of tokens to send.
107      */
108     uint256 public initialTokensBalance;
109 
110     /**
111      * Amount of tokens already sent.
112      */
113     uint256 public tokensSent;
114 
115     /**
116      * Unix timestamp at when the vesting has begun.
117      */
118     uint256 public vestingStartUnixTimestamp;
119 
120     /**
121      * Account that deployed this smart contract, which is authorized to initialize vesting.
122      */
123     address public deployer;
124 
125     modifier deployerOnly { require(msg.sender == deployer); _; }
126     modifier whenInitialized { require(withdrawalAddress != address(0x0)); _; }
127     modifier whenNotInitialized { require(withdrawalAddress == address(0x0)); _; }
128 
129     /**
130      * Event raised on each successful withdraw.
131      */
132     event Withdraw(uint256 amount, uint256 timestamp);
133 
134     /**
135      * Dedicate vesting smart contract for a particular token during deployment.
136      */
137     constructor (ERC20TokenInterface addr) public {
138         dreamToken = addr;
139         deployer = msg.sender;
140     }
141 
142     /**
143      * Fallback: function that releases locked tokens within schedule. Send an empty transaction to this
144      * smart contract for withdrawalAddress to receive tokens.
145      */
146     function () external {
147         withdrawTokens();
148     }
149 
150     /**
151      * Vesting initialization function. Contract deployer has to trigger this function after vesting amount
152      * was sent to this smart contract.
153      * @param account Account to initialize vesting for.
154      */
155     function initializeVestingFor (address payable account) external deployerOnly whenNotInitialized {
156         initialTokensBalance = dreamToken.balanceOf(address(this));
157         require(initialTokensBalance != 0);
158         withdrawalAddress = account;
159         vestingStartUnixTimestamp = block.timestamp;
160         vestingRules();
161     }
162 
163     /**
164      * Calculate tokens amount that is sent to withdrawalAddress.
165      * @return Amount of tokens that can be sent.
166      */
167     function getAvailableTokensToWithdraw () public view returns (uint256) {
168         uint256 tokensUnlockedPercentage = getTokensUnlockedPercentage();
169         // withdrawalAddress will only be able to get all additional tokens sent to this smart contract
170         // at the end of the vesting period
171         if (tokensUnlockedPercentage >= 10000) {
172             return dreamToken.balanceOf(address(this));
173         } else {
174             return getTokensAmountAllowedToWithdraw(tokensUnlockedPercentage);
175         }
176     }
177 
178     /**
179      * Function for tokens withdrawal from the vesting smart contract. Triggered from the fallback function.
180      */
181     function withdrawTokens () private whenInitialized {
182         uint256 tokensToSend = getAvailableTokensToWithdraw();
183         sendTokens(tokensToSend);
184         if (dreamToken.balanceOf(address(this)) == 0) { // When all tokens were sent, destroy this smart contract
185             selfdestruct(withdrawalAddress);
186         }
187     }
188 
189     /**
190      * Send tokens to withdrawalAddress.
191      * @param tokensToSend Amount of tokens will be sent.
192      */
193     function sendTokens (uint256 tokensToSend) private {
194         if (tokensToSend == 0) {
195             return;
196         }
197         tokensSent = tokensSent.add(tokensToSend); // Update tokensSent variable to send correct amount later
198         dreamToken.transfer(withdrawalAddress, tokensToSend); // Send allowed number of tokens
199         emit Withdraw(tokensToSend, now); // Emitting a notification that tokens were withdrawn
200     }
201 
202     /**
203      * Calculate tokens available for withdrawal.
204      * @param tokensUnlockedPercentage Percent of tokens that are allowed to be sent.
205      * @return Amount of tokens that can be sent according to provided percentage.
206      */
207     function getTokensAmountAllowedToWithdraw (uint256 tokensUnlockedPercentage) private view returns (uint256) {
208         uint256 totalTokensAllowedToWithdraw = initialTokensBalance.mul(tokensUnlockedPercentage).div(10000);
209         uint256 unsentTokensAmount = totalTokensAllowedToWithdraw.sub(tokensSent);
210         return unsentTokensAmount;
211     }
212 
213     /**
214      * Get tokens unlocked percentage on current stage.
215      * @return Percent of tokens allowed to be sent.
216      */
217     function getTokensUnlockedPercentage () private view returns (uint256) {
218 
219         uint256 allowedPercent;
220 
221         for (uint8 i = 0; i < stages.length; i++) {
222             if (now >= stages[i].date) {
223                 allowedPercent = stages[i].tokensUnlockedPercentage;
224             }
225         }
226 
227         return allowedPercent;
228 
229     }
230 
231 }