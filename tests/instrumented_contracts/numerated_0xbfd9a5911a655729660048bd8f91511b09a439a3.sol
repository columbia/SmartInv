1 pragma solidity ^0.4.17;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45   address public owner;
46 
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   function Ownable() public {
56     owner = msg.sender;
57   }
58 
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) public onlyOwner {
74     require(newOwner != address(0));
75     OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }
80 
81 
82 
83 /**
84  * @title Pausable
85  * @dev Base contract which allows children to implement an emergency stop mechanism.
86  */
87 contract Pausable is Ownable {
88   event Pause();
89   event Unpause();
90 
91   bool public paused = false;
92 
93 
94   /**
95    * @dev Modifier to make a function callable only when the contract is not paused.
96    */
97   modifier whenNotPaused() {
98     require(!paused);
99     _;
100   }
101 
102   /**
103    * @dev Modifier to make a function callable only when the contract is paused.
104    */
105   modifier whenPaused() {
106     require(paused);
107     _;
108   }
109 
110   /**
111    * @dev called by the owner to pause, triggers stopped state
112    */
113   function pause() onlyOwner whenNotPaused public {
114     paused = true;
115     Pause();
116   }
117 
118   /**
119    * @dev called by the owner to unpause, returns to normal state
120    */
121   function unpause() onlyOwner whenPaused public {
122     paused = false;
123     Unpause();
124   }
125 }
126 
127 
128 /**
129  * @title ERC20Basic
130  * @dev Simpler version of ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/179
132  */
133 contract ERC20Basic {
134     uint256 public totalSupply;
135     mapping(address => uint256) balances;
136     function balanceOf(address _owner) public constant returns (uint256) { return balances[_owner]; }
137     // Transfer is disabled for users, as these are PreSale tokens
138     //function transfer(address to, uint256 value) public returns (bool);
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 /**
143 * @title Gimmer PreSale Smart Contract
144 * @author lucas@gimmer.net, jitendra@chittoda.com
145 */
146 contract GimmerPreSale is ERC20Basic, Pausable {
147     using SafeMath for uint256;
148 
149     /**
150     * @dev Supporter structure, which allows us to track
151     * how much the user has bought so far, and if he's flagged as known
152     */
153     struct Supporter {
154         uint256 weiSpent;   // the total amount of Wei this address has sent to this contract
155         bool hasKYC;        // if the user has KYC flagged
156     }
157 
158     mapping(address => Supporter) public supportersMap; // Mapping with all the campaign supporters
159     address public fundWallet;      // Address to forward all Ether to
160     address public kycManager;      // Address that manages approval of KYC
161     uint256 public tokensSold;      // How many tokens sold in PreSale
162     uint256 public weiRaised;       // amount of raised money in wei
163 
164     uint256 public constant ONE_MILLION = 1000000;
165     // Maximum amount that can be sold during the Pre Sale period
166     uint256 public constant PRE_SALE_GMRP_TOKEN_CAP = 15 * ONE_MILLION * 1 ether; //15 Million GMRP Tokens
167 
168     /* Allowed Contribution in Ether */
169     uint256 public constant PRE_SALE_30_ETH     = 30 ether;  // Minimum 30 Ether to get 25% Bonus Tokens
170     uint256 public constant PRE_SALE_300_ETH    = 300 ether; // Minimum 300 Ether to get 30% Bonus Tokens
171     uint256 public constant PRE_SALE_3000_ETH   = 3000 ether;// Minimum 3000 Ether to get 40% Bonus Tokens
172 
173     /* Bonus Tokens based on the ETH Contributed in single transaction */
174     uint256 public constant TOKEN_RATE_25_PERCENT_BONUS = 1250; // 25% Bonus Tokens, when >= 30 ETH & < 300 ETH
175     uint256 public constant TOKEN_RATE_30_PERCENT_BONUS = 1300; // 30% Bonus Tokens, when >= 300 ETH & < 3000 ETH
176     uint256 public constant TOKEN_RATE_40_PERCENT_BONUS = 1400; // 40% Bonus Tokens, when >= 3000 ETH
177 
178     /* start and end timestamps where investments are allowed (both inclusive) */
179     uint256 public constant START_TIME  = 1511524800;   //GMT: Friday, 24 November 2017 12:00:00
180     uint256 public constant END_TIME    = 1514894400;   //GMT: Tuesday, 2 January  2018 12:00:00
181 
182     /* Token metadata */
183     string public constant name = "GimmerPreSale Token";
184     string public constant symbol = "GMRP";
185     uint256 public constant decimals = 18;
186 
187     /**
188     * @dev Modifier to only allow KYCManager
189     */
190     modifier onlyKycManager() {
191         require(msg.sender == kycManager);
192         _;
193     }
194 
195     /**
196     * Event for token purchase logging
197     * @param purchaser  who bought the tokens
198     * @param value      weis paid for purchase
199     * @param amount     amount of tokens purchased
200     */
201     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
202 
203     /**
204     * Event for minting new tokens
205     * @param to         The person that received tokens
206     * @param amount     Amount of tokens received
207     */
208     event Mint(address indexed to, uint256 amount);
209 
210     /**
211      * Event to log a user is approved or disapproved
212      * @param user          User who has been approved/disapproved
213      * @param isApproved    true : User is approved, false : User is disapproved
214      */
215     event KYC(address indexed user, bool isApproved);
216 
217     /**
218      * Constructor
219      * @param _fundWallet           Address to forward all received Ethers to
220      * @param _kycManagerWallet     KYC Manager wallet to approve / disapprove user's KYC
221      */
222     function GimmerPreSale(address _fundWallet, address _kycManagerWallet) public {
223         require(_fundWallet != address(0));
224         require(_kycManagerWallet != address(0));
225 
226         fundWallet = _fundWallet;
227         kycManager = _kycManagerWallet;
228     }
229 
230     /* fallback function can be used to buy tokens */
231     function () whenNotPaused public payable {
232         buyTokens();
233     }
234 
235     /* @return true if the transaction can buy tokens, otherwise false */
236     function validPurchase() internal constant returns (bool) {
237         bool withinPeriod = now >= START_TIME && now <= END_TIME;
238         bool higherThanMin30ETH = msg.value >= PRE_SALE_30_ETH;
239         return withinPeriod && higherThanMin30ETH;
240     }
241 
242     /* low level token purchase function */
243     function buyTokens() whenNotPaused public payable {
244         address sender = msg.sender;
245 
246         // make sure the user buying tokens has KYC
247         require(userHasKYC(sender));
248         require(validPurchase());
249 
250         // calculate token amount to be created
251         uint256 weiAmountSent = msg.value;
252         uint256 rate = getRate(weiAmountSent);
253         uint256 newTokens = weiAmountSent.mul(rate);
254 
255         // look if we have not yet reached the cap
256         uint256 totalTokensSold = tokensSold.add(newTokens);
257         require(totalTokensSold <= PRE_SALE_GMRP_TOKEN_CAP);
258 
259         // update supporter state
260         Supporter storage sup = supportersMap[sender];
261         uint256 totalWei = sup.weiSpent.add(weiAmountSent);
262         sup.weiSpent = totalWei;
263 
264         // update contract state
265         weiRaised = weiRaised.add(weiAmountSent);
266         tokensSold = totalTokensSold;
267 
268         // finally mint the coins
269         mint(sender, newTokens);
270         TokenPurchase(sender, weiAmountSent, newTokens);
271 
272         // and forward the funds to the wallet
273         forwardFunds();
274     }
275 
276     /**
277      * returns the rate the user will be paying at,
278      * based on the amount of wei sent to the contract
279      */
280     function getRate(uint256 weiAmount) public pure returns (uint256) {
281         if (weiAmount >= PRE_SALE_3000_ETH) {
282             return TOKEN_RATE_40_PERCENT_BONUS;
283         } else if(weiAmount >= PRE_SALE_300_ETH) {
284             return TOKEN_RATE_30_PERCENT_BONUS;
285         } else if(weiAmount >= PRE_SALE_30_ETH) {
286             return TOKEN_RATE_25_PERCENT_BONUS;
287         } else {
288             return 0;
289         }
290     }
291 
292     /**
293      * send ether to the fund collection wallet
294      * override to create custom fund forwarding mechanisms
295      */
296     function forwardFunds() internal {
297         fundWallet.transfer(msg.value);
298     }
299 
300     // @return true if crowdsale event has ended
301     function hasEnded() public constant returns (bool) {
302         return now > END_TIME;
303     }
304 
305     /**
306     * @dev Approves an User's KYC
307     * @param _user The user to flag as known
308     */
309     function approveUserKYC(address _user) onlyKycManager public {
310         Supporter storage sup = supportersMap[_user];
311         sup.hasKYC = true;
312         KYC(_user, true);
313     }
314 
315     /**
316      * @dev Disapproves an User's KYC
317      * @param _user The user to flag as unknown / suspecious
318      */
319     function disapproveUserKYC(address _user) onlyKycManager public {
320         Supporter storage sup = supportersMap[_user];
321         sup.hasKYC = false;
322         KYC(_user, false);
323     }
324 
325     /**
326     * @dev Changes the KYC manager to a new address
327     * @param _newKYCManager The new address that will be managing KYC approval
328     */
329     function setKYCManager(address _newKYCManager) onlyOwner public {
330         require(_newKYCManager != address(0));
331         kycManager = _newKYCManager;
332     }
333 
334     /**
335     * @dev Returns if an users has KYC approval or not
336     * @return A boolean representing the user's KYC status
337     */
338     function userHasKYC(address _user) public constant returns (bool) {
339         return supportersMap[_user].hasKYC;
340     }
341 
342     /**
343      * @dev Returns the weiSpent of a user
344      */
345     function userWeiSpent(address _user) public constant returns (uint256) {
346         return supportersMap[_user].weiSpent;
347     }
348 
349     /**
350     * @dev Function to mint tokens
351     * @param _to The address that will receive the minted tokens.
352     * @param _amount The amount of tokens to mint.
353     * @return A boolean that indicates if the operation was successful.
354     */
355     function mint(address _to, uint256 _amount) internal returns (bool) {
356         totalSupply = totalSupply.add(_amount);
357         balances[_to] = balances[_to].add(_amount);
358         Mint(_to, _amount);
359         Transfer(0x0, _to, _amount);
360         return true;
361     }
362 }