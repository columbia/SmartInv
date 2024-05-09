1 pragma solidity 0.4.20;
2 
3 /*
4 * ===========================
5 * Welcome To Ramen Coin! The FIRST and ONLY Proof of Ramen Cryptocurrency!
6 * Our cryptocurrency not only provides an opportunity to earn from playing our dApp but we will use funds in the long run 
7 * to help those who suffer from hunger and starvation in the world. By taking part in our dApp you are doing your part to help!
8 * |
9 *         |  /           
10 *         | /
11 *   .~^(,&|/o.   
12 *  |`-------^|
13 *  \         /
14 *   `======='  
15 * 
16 * https://ramencoin.me
17 *
18 * 
19 * /======== A Community Marketing Fund Project for RAMEN ========/
20 *
21 * -> Another Contract????
22 * In short, this is a contract to accept RAMEN token / ETH donations from community members
23 * as a way of gathering funds for regular marketing, contest and helping to fight hunger.
24 * [✓] Hands of Titanium! This contract never sells, it can't and just simply don't know how to sell!
25 * [✓] Community Goods: All rewards will be used for promotional costs / contest prizes and our initiative to fight hunger, when the accumulated rewards reaches a certain amount, we'll begin some campaigns.
26 * [✓] Transparency: How rewards will be used will be regularly updated and sometimes voted on by the community in website and/or discord announcement.
27 * [✓] Security: This is an honor system and the dev asks that you trust in the efforts as this is a serious and long term project.
28 * 
29 *
30 *
31 */
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     
40   address public owner;
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() public {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner public {
65     require(newOwner != address(0));
66     OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 
70 }
71 
72 /**
73  * @title PullPayment
74  * @dev Base contract supporting async send for pull payments. Inherit from this
75  * contract and use asyncSend instead of send.
76  */
77 contract PullPayment {
78     
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) public payments;
82   uint256 public totalPayments;
83 
84   /**
85    * @dev withdraw accumulated balance, called by payee.
86    */
87   function withdrawPayments() public {
88     address payee = msg.sender;
89     uint256 payment = payments[payee];
90 
91     require(payment != 0);
92     require(this.balance >= payment);
93 
94     totalPayments = totalPayments.sub(payment);
95     payments[payee] = 0;
96 
97     assert(payee.send(payment));
98   }
99 
100   /**
101    * @dev Called by the payer to store the sent amount as credit to be pulled.
102    * @param dest The destination address of the funds.
103    * @param amount The amount to transfer.
104    */
105   function asyncSend(address dest, uint256 amount) internal {
106     payments[dest] = payments[dest].add(amount);
107     totalPayments = totalPayments.add(amount);
108   }
109   
110 }
111 
112 /// @dev Interface to the RAMEN contract.
113 contract RAMENInterface {
114 
115 
116     /*=======================================
117     =            PUBLIC FUNCTIONS           =
118     =======================================*/
119 
120     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
121     function buy(address _referredBy) public payable returns (uint256);
122 
123     /// @dev Converts all of caller's dividends to tokens.
124     function reinvest() public;
125 
126     /// @dev Alias of sell() and withdraw().
127     function exit() public;
128 
129     /// @dev Withdraws all of the callers earnings.
130     function withdraw() public;
131 
132     /// @dev Liquifies tokens to ethereum.
133     function sell(uint256 _amountOfTokens) public;
134 
135     /**
136      * @dev Transfer tokens from the caller to a new holder.
137      *  Remember, there's a 15% fee here as well.
138      */
139     function transfer(address _toAddress, uint256 _amountOfTokens) public returns (bool);
140 
141 
142     /*=====================================
143     =      HELPERS AND CALCULATORS        =
144     =====================================*/
145 
146     /**
147      * @dev Method to view the current Ethereum stored in the contract
148      *  Example: totalEthereumBalance()
149      */
150     function totalEthereumBalance() public view returns (uint256);
151 
152     /// @dev Retrieve the total token supply.
153     function totalSupply() public view returns (uint256);
154 
155     /// @dev Retrieve the tokens owned by the caller.
156     function myTokens() public view returns (uint256);
157 
158     /**
159      * @dev Retrieve the dividends owned by the caller.
160      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
161      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
162      *  But in the internal calculations, we want them separate.
163      */
164     function myDividends(bool _includeReferralBonus) public view returns (uint256);
165 
166     /// @dev Retrieve the token balance of any single address.
167     function balanceOf(address _customerAddress) public view returns (uint256);
168 
169     /// @dev Retrieve the dividend balance of any single address.
170     function dividendsOf(address _customerAddress) public view returns (uint256);
171 
172     /// @dev Return the sell price of 1 individual token.
173     function sellPrice() public view returns (uint256);
174 
175     /// @dev Return the buy price of 1 individual token.
176     function buyPrice() public view returns (uint256);
177 
178     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
179     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256);
180 
181     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
182     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256);
183 
184 
185     /*==========================================
186     =            INTERNAL FUNCTIONS            =
187     ==========================================*/
188 
189     /// @dev Internal function to actually purchase the tokens.
190     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256);
191 
192     /**
193      * @dev Calculate Token price based on an amount of incoming ethereum
194      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
195      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
196      */
197     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256);
198 
199     /**
200      * @dev Calculate token sell value.
201      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
202      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
203      */
204     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256);
205 
206     /// @dev This is where all your gas goes.
207     function sqrt(uint256 x) internal pure returns (uint256 y);
208 
209 
210 }
211 
212 /// @dev Core Contract
213 contract RAMENCommunityFund is Ownable, PullPayment {
214 
215 
216     /*=================================
217     =            CONTRACTS            =
218     =================================*/
219 
220     /// @dev The address of the EtherDungeonCore contract.
221     RAMENInterface public RamenContract = RAMENInterface(0xc463aa806958f3BdD20081Cc5caB89FBB35B650D);
222 
223 
224     /*==============================
225     =            EVENTS            =
226     ==============================*/
227 
228     event LogDonateETH(
229         address indexed donarAddress,
230         uint256 amount,
231         uint256 timestamp
232     );
233 
234 
235     /*=======================================
236     =            PUBLIC FUNCTIONS           =
237     =======================================*/
238     
239     /// @dev Besides donating RAMEN tokens, you can also donate ETH as well.
240     function donateETH() public payable {
241         // When you make an ETH donation, it will use your address as referrer / masternode.
242         RamenContract.buy.value(msg.value)(msg.sender);
243         
244         // Emit LogDonateETH event.
245         LogDonateETH(msg.sender, msg.value, now);
246     }
247 
248     /// @dev Converts ETH dividends to RAMEN tokens.
249     function reinvestDividend() onlyOwner public {
250        RamenContract.reinvest();
251     }
252 
253     /// @dev Withdraw ETH dividends and put it to this contract.
254     function withdrawDividend() onlyOwner public {
255         RamenContract.withdraw();
256     }
257 
258     /// @dev Assign who can get how much of the dividends.
259     function assignFundReceiver(address _fundReceiver, uint _amount) onlyOwner public {
260         // Ensure there are sufficient available balance.
261         require(_amount <= this.balance - totalPayments);
262 
263         // Using the asyncSend function of PullPayment, fund receiver can withdraw it anytime.
264         asyncSend(_fundReceiver, _amount);
265     }
266 
267     /// @dev Fallback function to allow receiving funds from RAMEN contract.
268     function() public payable {}
269 
270     /*=======================================
271     =           SETTER FUNCTIONS            =
272     =======================================*/
273 
274     function setRamenContract(address _newRamenContractAddress) onlyOwner external {
275         RamenContract = RAMENInterface(_newRamenContractAddress);
276     }
277 
278     
279 }
280 
281 /**
282  * @title SafeMath
283  * @dev Math operations with safety checks that throw on error
284  */
285 library SafeMath {
286 
287   /**
288   * @dev Multiplies two numbers, throws on overflow.
289   */
290   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
291     if (a == 0) {
292       return 0;
293     }
294     uint256 c = a * b;
295     assert(c / a == b);
296     return c;
297   }
298 
299   /**
300   * @dev Integer division of two numbers, truncating the quotient.
301   */
302   function div(uint256 a, uint256 b) internal pure returns (uint256) {
303     // assert(b > 0); // Solidity automatically throws when dividing by 0
304     uint256 c = a / b;
305     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
306     return c;
307   }
308 
309   /**
310   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
311   */
312   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
313     assert(b <= a);
314     return a - b;
315   }
316 
317   /**
318   * @dev Adds two numbers, throws on overflow.
319   */
320   function add(uint256 a, uint256 b) internal pure returns (uint256) {
321     uint256 c = a + b;
322     assert(c >= a);
323     return c;
324   }
325   
326 }