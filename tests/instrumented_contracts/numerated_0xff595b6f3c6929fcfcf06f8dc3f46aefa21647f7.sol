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
47  * DreamTeam tokens vesting contract. 
48  *
49  * According to the DreamTeam token distribution structure, there are two parties that should
50  * be provided with corresponding token amounts during the 2 years after TGE:
51  *      Teams and Tournament Organizers: 15%
52  *      Team and Early Investors: 10%
53  *
54  * The DreamTeam "Vesting" smart contract should be in place to ensure meeting the token sale commitments.
55  *
56  * Two instances of the contract will be deployed for holding tokens. 
57  * First instance for "Teams and Tournament Organizers" tokens and second for "Team and Early Investors".
58  */
59 contract DreamTokensVesting {
60 
61     using SafeMath for uint256;
62 
63     /**
64      * Address of DreamToken.
65      */
66     ERC20TokenInterface public dreamToken;
67 
68     /**
69      * Address for receiving tokens.
70      */
71     address public withdrawAddress;
72 
73     /**
74      * Tokens vesting stage structure with vesting date and tokens allowed to unlock.
75      */
76     struct VestingStage {
77         uint256 date;
78         uint256 tokensUnlockedPercentage;
79     }
80 
81     /**
82      * Array for storing all vesting stages with structure defined above.
83      */
84     VestingStage[5] public stages;
85 
86     /**
87      * Starting timestamp of the first stage of vesting (Tuesday, 19 June 2018, 09:00:00 GMT).
88      * Will be used as a starting point for all dates calculations.
89      */
90     uint256 public vestingStartTimestamp = 1529398800;
91 
92     /**
93      * Total amount of tokens sent.
94      */
95     uint256 public initialTokensBalance;
96 
97     /**
98      * Amount of tokens already sent.
99      */
100     uint256 public tokensSent;
101 
102     /**
103      * Event raised on each successful withdraw.
104      */
105     event Withdraw(uint256 amount, uint256 timestamp);
106 
107     /**
108      * Could be called only from withdraw address.
109      */
110     modifier onlyWithdrawAddress () {
111         require(msg.sender == withdrawAddress);
112         _;
113     }
114 
115     /**
116      * We are filling vesting stages array right when the contract is deployed.
117      *
118      * @param token Address of DreamToken that will be locked on contract.
119      * @param withdraw Address of tokens receiver when it is unlocked.
120      */
121     constructor (ERC20TokenInterface token, address withdraw) public {
122         dreamToken = token;
123         withdrawAddress = withdraw;
124         initVestingStages();
125     }
126     
127     /**
128      * Fallback 
129      */
130     function () external {
131         withdrawTokens();
132     }
133 
134     /**
135      * Calculate tokens amount that is sent to withdrawAddress.
136      * 
137      * @return Amount of tokens that can be sent.
138      */
139     function getAvailableTokensToWithdraw () public view returns (uint256 tokensToSend) {
140         uint256 tokensUnlockedPercentage = getTokensUnlockedPercentage();
141         // In the case of stuck tokens we allow the withdrawal of them all after vesting period ends.
142         if (tokensUnlockedPercentage >= 100) {
143             tokensToSend = dreamToken.balanceOf(this);
144         } else {
145             tokensToSend = getTokensAmountAllowedToWithdraw(tokensUnlockedPercentage);
146         }
147     }
148 
149     /**
150      * Get detailed info about stage. 
151      * Provides ability to get attributes of every stage from external callers, ie Web3, truffle tests, etc.
152      *
153      * @param index Vesting stage number. Ordered by ascending date and starting from zero.
154      *
155      * @return {
156      *    "date": "Date of stage in unix timestamp format.",
157      *    "tokensUnlockedPercentage": "Percent of tokens allowed to be withdrawn."
158      * }
159      */
160     function getStageAttributes (uint8 index) public view returns (uint256 date, uint256 tokensUnlockedPercentage) {
161         return (stages[index].date, stages[index].tokensUnlockedPercentage);
162     }
163 
164     /**
165      * Setup array with vesting stages dates and percents.
166      */
167     function initVestingStages () internal {
168         uint256 halfOfYear = 183 days;
169         uint256 year = halfOfYear * 2;
170         stages[0].date = vestingStartTimestamp;
171         stages[1].date = vestingStartTimestamp + halfOfYear;
172         stages[2].date = vestingStartTimestamp + year;
173         stages[3].date = vestingStartTimestamp + year + halfOfYear;
174         stages[4].date = vestingStartTimestamp + year * 2;
175 
176         stages[0].tokensUnlockedPercentage = 25;
177         stages[1].tokensUnlockedPercentage = 50;
178         stages[2].tokensUnlockedPercentage = 75;
179         stages[3].tokensUnlockedPercentage = 88;
180         stages[4].tokensUnlockedPercentage = 100;
181     }
182 
183     /**
184      * Main method for withdraw tokens from vesting.
185      */
186     function withdrawTokens () onlyWithdrawAddress private {
187         // Setting initial tokens balance on a first withdraw.
188         if (initialTokensBalance == 0) {
189             setInitialTokensBalance();
190         }
191         uint256 tokensToSend = getAvailableTokensToWithdraw();
192         sendTokens(tokensToSend);
193     }
194 
195     /**
196      * Set initial tokens balance when making the first withdrawal.
197      */
198     function setInitialTokensBalance () private {
199         initialTokensBalance = dreamToken.balanceOf(this);
200     }
201 
202     /**
203      * Send tokens to withdrawAddress.
204      * 
205      * @param tokensToSend Amount of tokens will be sent.
206      */
207     function sendTokens (uint256 tokensToSend) private {
208         if (tokensToSend > 0) {
209             // Updating tokens sent counter
210             tokensSent = tokensSent.add(tokensToSend);
211             // Sending allowed tokens amount
212             dreamToken.transfer(withdrawAddress, tokensToSend);
213             // Raising event
214             emit Withdraw(tokensToSend, now);
215         }
216     }
217 
218     /**
219      * Calculate tokens available for withdrawal.
220      *
221      * @param tokensUnlockedPercentage Percent of tokens that are allowed to be sent.
222      *
223      * @return Amount of tokens that can be sent according to provided percentage.
224      */
225     function getTokensAmountAllowedToWithdraw (uint256 tokensUnlockedPercentage) private view returns (uint256) {
226         uint256 totalTokensAllowedToWithdraw = initialTokensBalance.mul(tokensUnlockedPercentage).div(100);
227         uint256 unsentTokensAmount = totalTokensAllowedToWithdraw.sub(tokensSent);
228         return unsentTokensAmount;
229     }
230 
231     /**
232      * Get tokens unlocked percentage on current stage.
233      * 
234      * @return Percent of tokens allowed to be sent.
235      */
236     function getTokensUnlockedPercentage () private view returns (uint256) {
237         uint256 allowedPercent;
238         
239         for (uint8 i = 0; i < stages.length; i++) {
240             if (now >= stages[i].date) {
241                 allowedPercent = stages[i].tokensUnlockedPercentage;
242             }
243         }
244         
245         return allowedPercent;
246     }
247 }
248 
249 contract TeamAndEarlyInvestorsVesting is DreamTokensVesting {
250     constructor(ERC20TokenInterface token, address withdraw) DreamTokensVesting(token, withdraw) public {}
251 }