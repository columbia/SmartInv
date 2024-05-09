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
49  * According to DreamTeam token distribution structure, there are two parties that should
50  * be provided with corresponding token amounts during 2 years after TGE:
51  *      Teams and Tournament Organizers: 15%
52  *      Team and Early Investors: 10%
53  *
54  * The DreamTeam "Vesting" smart contract should be in place to ensure meeting the token sale commitments.
55  *
56  * Two instances of contract will be deployed for holding tokens. 
57  * First instance for "Teams and Tournament Organizers" tokens and second for "Team and Early Investors"
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
87      * Starting timestamp of the first stage of vesting (19 June 2018).
88      * Will be used as starting point for all dates calculations.
89      */
90     uint256 public vestingStartTimestamp = 1529429400;
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
116      * We are filling vesting stages array right when contract will be deployed.
117      *
118      * @param token Address of DreamToken that will be locked on contract.
119      * @param withdraw Address of tokens receiver when it will be unlocked.
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
135      * Calculate tokens amount that will be send to withdrawAddress
136      * 
137      * @return Amount of tokens that could be sent.
138      */
139     function getAvailableTokensToWithdraw () public view returns (uint256 tokensToSend) {
140         uint256 tokensUnlockedPercentage = getTokensUnlockedPercentage();
141         // In case of stuck tokens we allowing to widthraw them all after vesting period ends.
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
168         stages[0].date = vestingStartTimestamp;
169         stages[1].date = vestingStartTimestamp + 1 hours;
170         stages[2].date = vestingStartTimestamp + 13 hours + 30 minutes;
171         stages[3].date = vestingStartTimestamp + 14 hours + 30 minutes;
172         stages[4].date = vestingStartTimestamp + 15 hours + 30 minutes;
173 
174         stages[0].tokensUnlockedPercentage = 25;
175         stages[1].tokensUnlockedPercentage = 50;
176         stages[2].tokensUnlockedPercentage = 75;
177         stages[3].tokensUnlockedPercentage = 88;
178         stages[4].tokensUnlockedPercentage = 100;
179     }
180 
181     /**
182      * Main method for withdraw tokens from vesting.
183      */
184     function withdrawTokens () onlyWithdrawAddress private {
185         // Setting initial tokens balance on a first withdraw.
186         if (initialTokensBalance == 0) {
187             setInitialTokensBalance();
188         }
189         uint256 tokensToSend = getAvailableTokensToWithdraw();
190         sendTokens(tokensToSend);
191     }
192 
193     /**
194      * Set initial tokens balance when making a first withdraw.
195      */
196     function setInitialTokensBalance () private {
197         initialTokensBalance = dreamToken.balanceOf(this);
198     }
199 
200     /**
201      * Send tokens to withdrawAddress
202      * 
203      * @param tokensToSend Amount of tokens will be sent.
204      */
205     function sendTokens (uint256 tokensToSend) private {
206         if (tokensToSend > 0) {
207             // Updating tokens sent counter
208             tokensSent = tokensSent.add(tokensToSend);
209             // Sending allowed tokens amount
210             dreamToken.transfer(withdrawAddress, tokensToSend);
211             // Raising event
212             emit Withdraw(tokensToSend, now);
213         }
214     }
215 
216     /**
217      * Calculate tokens available for withdraw.
218      *
219      * @param tokensUnlockedPercentage Percent of tokens that allowed to be sent.
220      *
221      * @return Amount of tokens that could be sent according to provided percentage.
222      */
223     function getTokensAmountAllowedToWithdraw (uint256 tokensUnlockedPercentage) private view returns (uint256) {
224         uint256 totalTokensAllowedToWithdraw = initialTokensBalance.mul(tokensUnlockedPercentage).div(100);
225         uint256 unsentTokensAmount = totalTokensAllowedToWithdraw.sub(tokensSent);
226         return unsentTokensAmount;
227     }
228 
229     /**
230      * Get tokens unlocked percentage on current stage.
231      * 
232      * @return Percent of tokens allowed to be sent.
233      */
234     function getTokensUnlockedPercentage () private view returns (uint256) {
235         uint256 allowedPercent;
236         
237         for (uint8 i = 0; i < stages.length; i++) {
238             if (now >= stages[i].date) {
239                 allowedPercent = stages[i].tokensUnlockedPercentage;
240             }
241         }
242         
243         return allowedPercent;
244     }
245 }
246 
247 contract TeamsAndTournamentOrganizersVesting is DreamTokensVesting {
248     constructor(ERC20TokenInterface token, address withdraw) DreamTokensVesting(token, withdraw) public {} 
249 }