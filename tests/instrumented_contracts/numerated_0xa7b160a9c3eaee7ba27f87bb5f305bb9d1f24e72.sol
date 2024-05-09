1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     function totalSupply() public view returns (uint256);
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22     function allowance(address owner, address spender) public view returns (uint256);
23     function transferFrom(address from, address to, uint256 value) public returns (bool);
24     function approve(address spender, uint256 value) public returns (bool);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34 
35     /**
36     * @dev Multiplies two numbers, throws on overflow.
37     */
38     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         if (a == 0) {
40             return 0;
41         }
42         c = a * b;
43         assert(c / a == b);
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two numbers, truncating the quotient.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // assert(b > 0); // Solidity automatically throws when dividing by 0
52         // uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54         return a / b;
55     }
56 
57     /**
58     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59     */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         assert(b <= a);
62         return a - b;
63     }
64 
65     /**
66     * @dev Adds two numbers, throws on overflow.
67     */
68     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
69         c = a + b;
70         assert(c >= a);
71         return c;
72     }
73 }
74 
75 
76 /**
77  * @title Ownable
78  * @dev The Ownable contract has an owner address, and provides basic authorization control
79  * functions, this simplifies the implementation of "user permissions".
80  */
81 contract Ownable {
82     address public owner;
83 
84     /**
85      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86      * account.
87      */
88     constructor() public {
89         owner = msg.sender;
90     }
91 
92     /**
93      * @dev Throws if called by any account other than the owner.
94      */
95     modifier onlyOwner() {
96         require(msg.sender == owner);
97         _;
98     }
99 
100     /**
101      * @dev Allows the current owner to transfer control of the contract to a newOwner.
102      * @param newOwner The address to transfer ownership to.
103      */
104     function transferOwnership(address newOwner) public onlyOwner {
105         require(newOwner != address(0));
106         owner = newOwner;
107     }
108 }
109 
110 
111 contract GetAchieveICO is Ownable {
112     using SafeMath for uint;
113     
114     address public beneficiary;
115     uint256 public decimals;
116     uint256 public softCap;            // in Wei
117     uint256 public hardCap;            // in Wei
118     uint256 public amountRaised;       // in Wei
119     uint256 public amountSold;         // Amount of sold tokens with decimals
120     uint256 public maxAmountToSell;    // Amount of tokens to sell for current Round [Pre Sale - 192M GAT, Sale - 228M GAT]
121     
122     uint256 deadline1;  // Pre Sale deadline
123     uint256 deadline2;  // Sale deadline
124     uint256 oneWeek;    // 1 week timeline
125     
126     uint256 public price;       // Current price
127     uint256 price0;             // Sale period price (ICO)
128     uint256 price1;             // Pre Sale period price Round 1
129     uint256 price2;             // Pre Sale period price Round 2
130     uint256 price3;             // Pre Sale period price Round 3
131     uint256 price4;             // Pre Sale period price Round 4
132     uint256 price5;             // Pre Sale period price Round 5
133     uint256 price6;             // Pre Sale period price Round 6
134     uint256 price7;             // Pre Sale period price Round 7
135     
136     ERC20 public token;
137     mapping(address => uint256) balances;
138     bool public fundingGoalReached = false;
139     bool public crowdsaleClosed = true;     // Closed till manually start by the owner
140 
141     event GoalReached(address recipient, uint256 totalAmountRaised);
142     event FundTransfer(address backer, uint256 amount, bool isContribution);
143     
144 
145     /**
146      * Constructor function
147      *
148      * Initialization
149      */
150     constructor(
151         address wallet,
152         ERC20 addressOfToken
153     ) public {
154         beneficiary = wallet;
155         decimals = 18;
156         softCap = 4000 * 1 ether;
157         hardCap = 12000 * 1 ether;
158         maxAmountToSell = 192000000 * 10 ** decimals;    // Pre Sale 192M GAT. Then 228M GAT will be added in time of Sale period
159         // Price rates
160         price0 = 40;        // 0.000040 ETH (in Wei)
161         price1 = 20;        // 0.000020 ETH (in Wei)
162         price2 = 24;        // 0.000024 ETH (in Wei)
163         price3 = 24;        // 0.000024 ETH (in Wei)
164         price4 = 28;        // 0.000028 ETH (in Wei)
165         price5 = 28;        // 0.000028 ETH (in Wei)
166         price6 = 32;        // 0.000032 ETH (in Wei)
167         price7 = 32;        // 0.000032 ETH (in Wei)
168         price = price1;     // Set Pre Sale Round 1 token price as current
169         oneWeek = 7 * 1 days;
170         deadline2 = now + 50 * oneWeek; // Just for blocking checkGoalReached() function call till Crowdsale start
171         token = addressOfToken;
172     }
173     
174     /**
175     * @dev Gets the balance of the specified address.
176     * @param _owner The address to query the balance of.
177     * @return An uint256 representing the amount owned by the passed address.
178     */
179     function balanceOf(address _owner) public view returns (uint) {
180         return balances[_owner];
181     }
182 
183     /**
184      * Fallback function
185      *
186      * The function without name is the default function that is called whenever anyone sends funds to a contract
187      */
188     function () payable public {
189         require(!crowdsaleClosed);
190         require(_validateSaleDate());
191         require(msg.sender != address(0));
192         uint256 amount = msg.value;
193         require(amount != 0);
194         require(amount >= 10000000000000000);       // min 0.01 ETH
195         require(amount <= hardCap);                 // Hard cap
196         
197         uint256 tokens = amount.mul(10 ** 6);       // Add 6 zeros in the end of 'amount' to use correct price rate
198         tokens = tokens.div(price);                 // Amount of tokens to sell for the current price rate
199         require(amountSold.add(tokens) <= maxAmountToSell);     // Check token oversell for the current Round
200         balances[msg.sender] = balances[msg.sender].add(amount);
201         amountRaised = amountRaised.add(amount);
202         amountSold = amountSold.add(tokens);        // Update amount of sold tokens
203         
204         token.transfer(msg.sender, tokens);
205         emit FundTransfer(msg.sender, amount, true);
206     }
207     
208     /**
209      * @dev Validation of Pre Sale period
210      * @return bool
211      */
212     function _validateSaleDate() internal returns (bool) {
213         // Pre Sale
214         if(now <= deadline1) {
215             uint256 dateDif = deadline1.sub(now);
216             if (dateDif <= 2 * 1 days) {
217                 price = price7;     // Round 7
218                 return true;
219             } else if (dateDif <= 4 * 1 days) {
220                 price = price6;     // Round 6
221                 return true;
222             } else if (dateDif <= 6 * 1 days) {
223                 price = price5;     // Round 5
224                 return true;
225             } else if (dateDif <= 8 * 1 days) {
226                 price = price4;     // Round 4
227                 return true;
228             } else if (dateDif <= 10 * 1 days) {
229                 price = price3;     // Round 3
230                 return true;
231             } else if (dateDif <= 12 * 1 days) {
232                 price = price2;     // Round 2
233                 return true;
234             } else if (dateDif <= 14 * 1 days) {
235                 price = price1;     // Round 1
236                 return true;
237             } else {
238                 price = 25;         // Default average value
239                 return true;
240             }
241         }
242         // Sale
243         if (now >= (deadline1.add(oneWeek)) && now <= deadline2) {
244             maxAmountToSell = 420000000 * 10 ** decimals;    // Pre Sale + Sale = 192M GAT + 228M GAT
245             price = price0;             // Sale token price
246             return true;
247         }
248         // After Sale
249         if (now >= deadline2) {
250             crowdsaleClosed = true;     // Crowdsale period is finished
251             return false;
252         }
253         
254         return false;
255     }
256     
257     /**
258     * @dev Start Sale
259     */
260     function startCrowdsale() onlyOwner public returns (bool) {
261         deadline1 = now + 2 * oneWeek;                      // Set Pre Sale deadline 2 weeks
262         deadline2 = deadline1 + oneWeek + 8 * oneWeek;      // Set Sale deadline 8 weeks
263         crowdsaleClosed = false;    // Start Crowdsale period
264         return true;
265     }
266 
267     modifier afterDeadline() { if (now >= deadline2) _; }
268 
269     /**
270      * Check if goal was reached
271      * Checks if the goal or time limit has been reached and ends the campaign
272      */
273     function checkGoalReached() onlyOwner afterDeadline public {
274         if (amountRaised >= softCap) {
275             fundingGoalReached = true;
276             emit GoalReached(beneficiary, amountRaised);
277         }
278         crowdsaleClosed = true;     // Close Crowdsale
279     }
280 
281 
282     /**
283      * Withdraw the funds
284      *
285      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
286      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
287      * the amount they contributed.
288      */
289     function safeWithdrawal() afterDeadline public {
290         require(!fundingGoalReached);
291         require(crowdsaleClosed);
292         
293         uint256 amount = balances[msg.sender];
294         balances[msg.sender] = 0;
295         if (amount > 0) {
296             if (msg.sender.send(amount)) {
297                emit FundTransfer(msg.sender, amount, false);
298             } else {
299                 balances[msg.sender] = amount;
300             }
301         }
302     }
303     
304     /**
305      * Withdraw the funds
306      */
307     function safeWithdrawFunds(uint256 amount) onlyOwner public returns (bool) {
308         require(beneficiary == msg.sender);
309         
310         if (beneficiary.send(amount)) {
311             return true;
312         } else {
313             return false;
314         }
315     }
316     
317     
318     /**
319      * Withdraw rest of tokens from smart contract balance to the owner's wallet
320      * if funding goal is not reached and Crowdsale is already closed.
321      * 
322      * Can be used for Airdrop if funding goal is not reached.
323      */
324     function safeWithdrawTokens(uint256 amount) onlyOwner afterDeadline public returns (bool) {
325         require(!fundingGoalReached);
326         require(crowdsaleClosed);
327         
328         token.transfer(beneficiary, amount);
329         emit FundTransfer(beneficiary, amount, false);
330     }
331 }