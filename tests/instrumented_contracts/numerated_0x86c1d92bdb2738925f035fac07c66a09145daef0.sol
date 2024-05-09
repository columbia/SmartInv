1 pragma solidity 0.4.25;
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
28         // uint256 c = a / b; assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     function sub (uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b <= a);
34         return a - b;
35     }
36 
37     function add (uint256 a, uint256 b) internal pure returns (uint256 c) {
38         c = a + b;
39         require(c >= a);
40         return c;
41     }
42 
43 }
44 
45 /**
46  * DreamTeam tokens vesting smart contract. 
47  * This vesting smart contracts unlocks 50% of the tokens for `withdrawalAddress` on December 25, 2018.
48  * Other 50% are unlocked on 30 June, 2019.
49  * The withdrawal address is set during the initialization (initializeVestingFor function).
50  * To withdraw tokens, send an empty transaction to this smart contract address (just like you send Ether, but set
51  * amount to transfer to 0 instead).
52  * Once vesting period (1 year) ends and after all DREAM tokens are withdrawn, this smart contract self-destructs.
53  */
54 contract OneYearDreamTokensVestingAdvisors {
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
79     VestingStage[2] public stages;
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
92      * Account that deployed this smart contract, which is authorized to initialize vesting.
93      */
94     address public deployer;
95 
96     modifier deployerOnly { require(msg.sender == deployer); _; }
97     modifier whenInitialized { require(withdrawalAddress != 0x0); _; }
98     modifier whenNotInitialized { require(withdrawalAddress == 0x0); _; }
99 
100     /**
101      * Event raised on each successful withdraw.
102      */
103     event Withdraw(uint256 amount, uint256 timestamp);
104 
105     /**
106      * Dedicate vesting smart contract for a particular token during deployment.
107      * @param token Address of DreamToken that will be locked on contract.
108      */
109     constructor (ERC20TokenInterface token) public {
110         dreamToken = token;
111         deployer = msg.sender;
112     }
113 
114     /**
115      * Fallback: function that releases locked tokens within schedule. Send an empty transaction to this
116      * smart contract for withdrawalAddress to receive tokens.
117      */
118     function () external {
119         withdrawTokens();
120     }
121 
122     /**
123      * Vesting initialization function. Contract deployer has to trigger this function after vesting amount
124      * was sent to this smart contract.
125      * @param account Account to initialize vesting for.
126      */
127     function initializeVestingFor (address account) external deployerOnly whenNotInitialized {
128         initialTokensBalance = dreamToken.balanceOf(this);
129         require(initialTokensBalance != 0);
130         withdrawalAddress = account;
131         vestingRules();
132     }
133 
134     /**
135      * Calculate tokens amount that is sent to withdrawalAddress.
136      * @return Amount of tokens that can be sent.
137      */
138     function getAvailableTokensToWithdraw () public view returns (uint256) {
139         uint256 tokensUnlockedPercentage = getTokensUnlockedPercentage();
140         // withdrawalAddress will only be able to get all additional tokens sent to this smart contract
141         // at the end of the vesting period
142         if (tokensUnlockedPercentage >= 100) {
143             return dreamToken.balanceOf(this);
144         } else {
145             return getTokensAmountAllowedToWithdraw(tokensUnlockedPercentage);
146         }
147     }
148 
149     /**
150      * Setup array with vesting stages dates and percentages.
151      */
152     function vestingRules () internal {
153 
154         stages[0].date = 1545696000; // December 25, 2018
155         stages[1].date = 1561852800; // June 30, 2019
156 
157         stages[0].tokensUnlockedPercentage = 50;
158         stages[1].tokensUnlockedPercentage = 100;
159 
160     }
161 
162     /**
163      * Function for tokens withdrawal from the vesting smart contract. Triggered from the fallback function.
164      */
165     function withdrawTokens () private whenInitialized {
166         uint256 tokensToSend = getAvailableTokensToWithdraw();
167         sendTokens(tokensToSend);
168         if (dreamToken.balanceOf(this) == 0) { // When all tokens were sent, destroy this smart contract
169             selfdestruct(withdrawalAddress);
170         }
171     }
172 
173     /**
174      * Send tokens to withdrawalAddress.
175      * @param tokensToSend Amount of tokens will be sent.
176      */
177     function sendTokens (uint256 tokensToSend) private {
178         if (tokensToSend == 0) {
179             return;
180         }
181         tokensSent = tokensSent.add(tokensToSend); // Update tokensSent variable to send correct amount later
182         dreamToken.transfer(withdrawalAddress, tokensToSend); // Send allowed number of tokens
183         emit Withdraw(tokensToSend, now); // Emitting a notification that tokens were withdrawn
184     }
185 
186     /**
187      * Calculate tokens available for withdrawal.
188      * @param tokensUnlockedPercentage Percent of tokens that are allowed to be sent.
189      * @return Amount of tokens that can be sent according to provided percentage.
190      */
191     function getTokensAmountAllowedToWithdraw (uint256 tokensUnlockedPercentage) private view returns (uint256) {
192         uint256 totalTokensAllowedToWithdraw = initialTokensBalance.mul(tokensUnlockedPercentage).div(100);
193         uint256 unsentTokensAmount = totalTokensAllowedToWithdraw.sub(tokensSent);
194         return unsentTokensAmount;
195     }
196 
197     /**
198      * Get tokens unlocked percentage on current stage.
199      * @return Percent of tokens allowed to be sent.
200      */
201     function getTokensUnlockedPercentage () private view returns (uint256) {
202 
203         uint256 allowedPercent;
204 
205         for (uint8 i = 0; i < stages.length; i++) {
206             if (now >= stages[i].date) {
207                 allowedPercent = stages[i].tokensUnlockedPercentage;
208             }
209         }
210 
211         return allowedPercent;
212 
213     }
214 
215 }