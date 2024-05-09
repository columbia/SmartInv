1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() public {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) public onlyOwner {
72     require(newOwner != address(0));
73     OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 
80 
81 /**
82  * @title Pausable
83  * @dev Base contract which allows children to implement an emergency stop mechanism.
84  */
85 contract Pausable is Ownable {
86   event Pause();
87   event Unpause();
88 
89   bool public paused = false;
90 
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is not paused.
94    */
95   modifier whenNotPaused() {
96     require(!paused);
97     _;
98   }
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is paused.
102    */
103   modifier whenPaused() {
104     require(paused);
105     _;
106   }
107 
108   /**
109    * @dev called by the owner to pause, triggers stopped state
110    */
111   function pause() onlyOwner whenNotPaused public {
112     paused = true;
113     Pause();
114   }
115 
116   /**
117    * @dev called by the owner to unpause, returns to normal state
118    */
119   function unpause() onlyOwner whenPaused public {
120     paused = false;
121     Unpause();
122   }
123 }
124 
125 
126 /**
127  * @title ERC20Basic
128  * @dev Simpler version of ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/179
130  */
131 contract ERC20Basic {
132     uint256 public totalSupply;
133     mapping(address => uint256) balances;
134     function balanceOf(address _owner) public constant returns (uint256) { return balances[_owner]; }
135     // Transfer is disabled for users, as these are PreSale tokens
136     //function transfer(address to, uint256 value) public returns (bool);
137     event Transfer(address indexed from, address indexed to, uint256 value);
138 }
139 
140 /**
141 * @title Gimmer PreSale Smart Contract
142 * @author lucas@gimmer.net, jitendra@chittoda.com
143 */
144 contract GimmerPreSale is ERC20Basic, Pausable {
145     using SafeMath for uint256;
146 
147     /**
148     * @dev Supporter structure, which allows us to track
149     * how much the user has bought so far, and if he's flagged as known
150     */
151     struct Supporter {
152         uint256 weiSpent;   // the total amount of Wei this address has sent to this contract
153         bool hasKYC;        // if the user has KYC flagged
154     }
155 
156     mapping(address => Supporter) public supportersMap; // Mapping with all the campaign supporters
157     address public fundWallet;      // Address to forward all Ether to
158     address public kycManager;      // Address that manages approval of KYC
159     uint256 public tokensSold;      // How many tokens sold in PreSale
160     uint256 public weiRaised;       // amount of raised money in wei
161 
162     uint256 public constant ONE_MILLION = 1000000;
163     // Maximum amount that can be sold during the Pre Sale period
164     uint256 public constant PRE_SALE_GMRP_TOKEN_CAP = 15 * ONE_MILLION * 1 ether; //15 Million GMRP Tokens
165 
166     /* Allowed Contribution in Ether */
167     uint256 public constant PRE_SALE_30_ETH     = 30 ether;  // Minimum 30 Ether to get 25% Bonus Tokens
168     uint256 public constant PRE_SALE_300_ETH    = 300 ether; // Minimum 300 Ether to get 30% Bonus Tokens
169     uint256 public constant PRE_SALE_3000_ETH   = 3000 ether;// Minimum 3000 Ether to get 40% Bonus Tokens
170 
171     /* Bonus Tokens based on the ETH Contributed in single transaction */
172     uint256 public constant TOKEN_RATE_25_PERCENT_BONUS = 1250; // 25% Bonus Tokens, when >= 30 ETH & < 300 ETH
173     uint256 public constant TOKEN_RATE_30_PERCENT_BONUS = 1300; // 30% Bonus Tokens, when >= 300 ETH & < 3000 ETH
174     uint256 public constant TOKEN_RATE_40_PERCENT_BONUS = 1400; // 40% Bonus Tokens, when >= 3000 ETH
175 
176     /* start and end timestamps where investments are allowed (both inclusive) */
177     uint256 public constant START_TIME  = 1511524800;   //GMT: Friday, 24 November 2017 12:00:00
178     uint256 public constant END_TIME    = 1514894400;   //GMT: Tuesday, 2 January  2018 12:00:00
179 
180     /* Token metadata */
181     string public constant name = "GimmerPreSale Token";
182     string public constant symbol = "GMRP";
183     uint256 public constant decimals = 18;
184 
185     /**
186     * @dev Modifier to only allow KYCManager
187     */
188     modifier onlyKycManager() {
189         require(msg.sender == kycManager);
190         _;
191     }
192 
193     /**
194     * Event for token purchase logging
195     * @param purchaser  who bought the tokens
196     * @param value      weis paid for purchase
197     * @param amount     amount of tokens purchased
198     */
199     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
200 
201     /**
202     * Event for minting new tokens
203     * @param to         The person that received tokens
204     * @param amount     Amount of tokens received
205     */
206     event Mint(address indexed to, uint256 amount);
207 
208     /**
209      * Event to log a user is approved or disapproved
210      * @param user          User who has been approved/disapproved
211      * @param isApproved    true : User is approved, false : User is disapproved
212      */
213     event KYC(address indexed user, bool isApproved);
214 
215     /**
216      * Constructor
217      * @param _fundWallet           Address to forward all received Ethers to
218      * @param _kycManagerWallet     KYC Manager wallet to approve / disapprove user's KYC
219      */
220     function GimmerPreSale(address _fundWallet, address _kycManagerWallet) public {
221         require(_fundWallet != address(0));
222         require(_kycManagerWallet != address(0));
223 
224         fundWallet = _fundWallet;
225         kycManager = _kycManagerWallet;
226     }
227 
228     /* fallback function can be used to buy tokens */
229     function () whenNotPaused public payable {
230         buyTokens();
231     }
232 
233     /* @return true if the transaction can buy tokens, otherwise false */
234     function validPurchase() internal constant returns (bool) {
235         bool withinPeriod = now >= START_TIME && now <= END_TIME;
236         bool higherThanMin30ETH = msg.value >= PRE_SALE_30_ETH;
237         return withinPeriod && higherThanMin30ETH;
238     }
239 
240     /* low level token purchase function */
241     function buyTokens() whenNotPaused public payable {
242         address sender = msg.sender;
243 
244         // make sure the user buying tokens has KYC
245         require(userHasKYC(sender));
246         require(validPurchase());
247 
248         // calculate token amount to be created
249         uint256 weiAmountSent = msg.value;
250         uint256 rate = getRate(weiAmountSent);
251         uint256 newTokens = weiAmountSent.mul(rate);
252 
253         // look if we have not yet reached the cap
254         uint256 totalTokensSold = tokensSold.add(newTokens);
255         require(totalTokensSold <= PRE_SALE_GMRP_TOKEN_CAP);
256 
257         // update supporter state
258         Supporter storage sup = supportersMap[sender];
259         uint256 totalWei = sup.weiSpent.add(weiAmountSent);
260         sup.weiSpent = totalWei;
261 
262         // update contract state
263         weiRaised = weiRaised.add(weiAmountSent);
264         tokensSold = totalTokensSold;
265 
266         // finally mint the coins
267         mint(sender, newTokens);
268         TokenPurchase(sender, weiAmountSent, newTokens);
269 
270         // and forward the funds to the wallet
271         forwardFunds();
272     }
273 
274     /**
275      * returns the rate the user will be paying at,
276      * based on the amount of wei sent to the contract
277      */
278     function getRate(uint256 weiAmount) public pure returns (uint256) {
279         if (weiAmount >= PRE_SALE_3000_ETH) {
280             return TOKEN_RATE_40_PERCENT_BONUS;
281         } else if(weiAmount >= PRE_SALE_300_ETH) {
282             return TOKEN_RATE_30_PERCENT_BONUS;
283         } else if(weiAmount >= PRE_SALE_30_ETH) {
284             return TOKEN_RATE_25_PERCENT_BONUS;
285         } else {
286             return 0;
287         }
288     }
289 
290     /**
291      * send ether to the fund collection wallet
292      * override to create custom fund forwarding mechanisms
293      */
294     function forwardFunds() internal {
295         fundWallet.transfer(msg.value);
296     }
297 
298     // @return true if crowdsale event has ended
299     function hasEnded() public constant returns (bool) {
300         return now > END_TIME;
301     }
302 
303     /**
304     * @dev Approves an User's KYC
305     * @param _user The user to flag as known
306     */
307     function approveUserKYC(address _user) onlyKycManager public {
308         Supporter storage sup = supportersMap[_user];
309         sup.hasKYC = true;
310         KYC(_user, true);
311     }
312 
313     /**
314      * @dev Disapproves an User's KYC
315      * @param _user The user to flag as unknown / suspecious
316      */
317     function disapproveUserKYC(address _user) onlyKycManager public {
318         Supporter storage sup = supportersMap[_user];
319         sup.hasKYC = false;
320         KYC(_user, false);
321     }
322 
323     /**
324     * @dev Changes the KYC manager to a new address
325     * @param _newKYCManager The new address that will be managing KYC approval
326     */
327     function setKYCManager(address _newKYCManager) onlyOwner public {
328         require(_newKYCManager != address(0));
329         kycManager = _newKYCManager;
330     }
331 
332     /**
333     * @dev Returns if an users has KYC approval or not
334     * @return A boolean representing the user's KYC status
335     */
336     function userHasKYC(address _user) public constant returns (bool) {
337         return supportersMap[_user].hasKYC;
338     }
339 
340     /**
341      * @dev Returns the weiSpent of a user
342      */
343     function userWeiSpent(address _user) public constant returns (uint256) {
344         return supportersMap[_user].weiSpent;
345     }
346 
347     /**
348     * @dev Function to mint tokens
349     * @param _to The address that will receive the minted tokens.
350     * @param _amount The amount of tokens to mint.
351     * @return A boolean that indicates if the operation was successful.
352     */
353     function mint(address _to, uint256 _amount) internal returns (bool) {
354         totalSupply = totalSupply.add(_amount);
355         balances[_to] = balances[_to].add(_amount);
356         Mint(_to, _amount);
357         Transfer(0x0, _to, _amount);
358         return true;
359     }
360 }