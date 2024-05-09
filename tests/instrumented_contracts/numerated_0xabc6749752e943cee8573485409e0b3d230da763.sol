1 pragma solidity 0.4.20;
2 
3 /*
4 * Team AppX presents...
5 * https://powtf.com/
6 * https://discord.gg/Ne2PTnS
7 *
8 * /======== A Community Marketing Fund Project for PoWTF ========/
9 *
10 * -> WTF is this!?
11 * In short, this is a contract to accept PoWTF token / ETH donations from community members
12 * as a way of gathering funds for regular marketing and contests.
13 * [✓] Hands of Stainless Steel! This contract never sells, it can't and just simply don't know how to sell!
14 * [✓] Community Goods: All dividends will be used for promotional fee / contest prizes, when the accumulated dividends reached certain amount, we'll create some campaign.
15 * [✓] Transparency: How to use the dividends will be regularly updated in website and discord announcement.
16 * [✓] Security: You need to trust me (@AppX Matthew) not taking the dividends and go away :)
17 * 
18 * -> Quotes
19 * "Real, sustainable community change requires the initiative and engagement of community members." - Helene D. Gayle
20 * "Every successful individual knows that his or her achievement depends on a community of persons working together." - Paul Ryan
21 * "Empathy is the starting point for creating a community and taking action. It's the impetus for creating change." - Max Carver
22 * "WTF Moon!" - AppX Matthew 
23 *
24 * =================================================*
25 *                                                  *
26 * __________      __      ________________________ *
27 * \______   \____/  \    /  \__    ___/\_   _____/ *
28 *  |     ___/  _ \   \/\/   / |    |    |    __)   *
29 *  |    |  (  <_> )        /  |    |    |     \    *
30 *  |____|   \____/ \__/\  /   |____|    \___  /    *
31 *                       \/                  \/     *
32 *                                                  *
33 * =================================================*
34 *
35 */
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43     
44   address public owner;
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 /**
77  * @title PullPayment
78  * @dev Base contract supporting async send for pull payments. Inherit from this
79  * contract and use asyncSend instead of send.
80  */
81 contract PullPayment {
82     
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) public payments;
86   uint256 public totalPayments;
87 
88   /**
89    * @dev withdraw accumulated balance, called by payee.
90    */
91   function withdrawPayments() public {
92     address payee = msg.sender;
93     uint256 payment = payments[payee];
94 
95     require(payment != 0);
96     require(this.balance >= payment);
97 
98     totalPayments = totalPayments.sub(payment);
99     payments[payee] = 0;
100 
101     assert(payee.send(payment));
102   }
103 
104   /**
105    * @dev Called by the payer to store the sent amount as credit to be pulled.
106    * @param dest The destination address of the funds.
107    * @param amount The amount to transfer.
108    */
109   function asyncSend(address dest, uint256 amount) internal {
110     payments[dest] = payments[dest].add(amount);
111     totalPayments = totalPayments.add(amount);
112   }
113   
114 }
115 
116 /// @dev Interface to the PoWTF contract.
117 contract PoWTFInterface {
118 
119 
120     /*=======================================
121     =            PUBLIC FUNCTIONS           =
122     =======================================*/
123 
124     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
125     function buy(address _referredBy) public payable returns (uint256);
126 
127     /// @dev Converts all of caller's dividends to tokens.
128     function reinvest() public;
129 
130     /// @dev Alias of sell() and withdraw().
131     function exit() public;
132 
133     /// @dev Withdraws all of the callers earnings.
134     function withdraw() public;
135 
136     /// @dev Liquifies tokens to ethereum.
137     function sell(uint256 _amountOfTokens) public;
138 
139     /**
140      * @dev Transfer tokens from the caller to a new holder.
141      *  Remember, there's a 15% fee here as well.
142      */
143     function transfer(address _toAddress, uint256 _amountOfTokens) public returns (bool);
144 
145 
146     /*=====================================
147     =      HELPERS AND CALCULATORS        =
148     =====================================*/
149 
150     /**
151      * @dev Method to view the current Ethereum stored in the contract
152      *  Example: totalEthereumBalance()
153      */
154     function totalEthereumBalance() public view returns (uint256);
155 
156     /// @dev Retrieve the total token supply.
157     function totalSupply() public view returns (uint256);
158 
159     /// @dev Retrieve the tokens owned by the caller.
160     function myTokens() public view returns (uint256);
161 
162     /**
163      * @dev Retrieve the dividends owned by the caller.
164      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
165      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
166      *  But in the internal calculations, we want them separate.
167      */
168     function myDividends(bool _includeReferralBonus) public view returns (uint256);
169 
170     /// @dev Retrieve the token balance of any single address.
171     function balanceOf(address _customerAddress) public view returns (uint256);
172 
173     /// @dev Retrieve the dividend balance of any single address.
174     function dividendsOf(address _customerAddress) public view returns (uint256);
175 
176     /// @dev Return the sell price of 1 individual token.
177     function sellPrice() public view returns (uint256);
178 
179     /// @dev Return the buy price of 1 individual token.
180     function buyPrice() public view returns (uint256);
181 
182     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
183     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256);
184 
185     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
186     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256);
187 
188 
189     /*==========================================
190     =            INTERNAL FUNCTIONS            =
191     ==========================================*/
192 
193     /// @dev Internal function to actually purchase the tokens.
194     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256);
195 
196     /**
197      * @dev Calculate Token price based on an amount of incoming ethereum
198      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
199      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
200      */
201     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256);
202 
203     /**
204      * @dev Calculate token sell value.
205      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
206      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
207      */
208     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256);
209 
210     /// @dev This is where all your gas goes.
211     function sqrt(uint256 x) internal pure returns (uint256 y);
212 
213 
214 }
215 
216 /// @dev Core Contract
217 contract PoWTFCommunityFund is Ownable, PullPayment {
218 
219 
220     /*=================================
221     =            CONTRACTS            =
222     =================================*/
223 
224     /// @dev The address of the EtherDungeonCore contract.
225     PoWTFInterface public poWtfContract = PoWTFInterface(0x702392282255f8c0993dBBBb148D80D2ef6795b1);
226 
227 
228     /*==============================
229     =            EVENTS            =
230     ==============================*/
231 
232     event LogDonateETH(
233         address indexed donarAddress,
234         uint256 amount,
235         uint256 timestamp
236     );
237 
238 
239     /*=======================================
240     =            PUBLIC FUNCTIONS           =
241     =======================================*/
242     
243     /// @dev Besides donating PoWTF tokens, you can also donate ETH as well.
244     function donateETH() public payable {
245         // When you make an ETH donation, it will use your address as referrer / masternode.
246         poWtfContract.buy.value(msg.value)(msg.sender);
247         
248         // Emit LogDonateETH event.
249         LogDonateETH(msg.sender, msg.value, now);
250     }
251 
252     /// @dev Converts ETH dividends to PoWTF tokens.
253     function reinvestDividend() onlyOwner public {
254         poWtfContract.reinvest();
255     }
256 
257     /// @dev Withdraw ETH dividends and put it to this contract.
258     function withdrawDividend() onlyOwner public {
259         poWtfContract.withdraw();
260     }
261 
262     /// @dev Assign who can get how much of the dividends.
263     function assignFundReceiver(address _fundReceiver, uint _amount) onlyOwner public {
264         // Ensure there are sufficient available balance.
265         require(_amount <= this.balance - totalPayments);
266 
267         // Using the asyncSend function of PullPayment, fund receiver can withdraw it anytime.
268         asyncSend(_fundReceiver, _amount);
269     }
270 
271     /// @dev Fallback function to allow receiving funds from PoWTF contract.
272     function() public payable {}
273 
274     /*=======================================
275     =           SETTER FUNCTIONS            =
276     =======================================*/
277 
278     function setPoWtfContract(address _newPoWtfContractAddress) onlyOwner external {
279         poWtfContract = PoWTFInterface(_newPoWtfContractAddress);
280     }
281 
282     
283 }
284 
285 /**
286  * @title SafeMath
287  * @dev Math operations with safety checks that throw on error
288  */
289 library SafeMath {
290 
291   /**
292   * @dev Multiplies two numbers, throws on overflow.
293   */
294   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
295     if (a == 0) {
296       return 0;
297     }
298     uint256 c = a * b;
299     assert(c / a == b);
300     return c;
301   }
302 
303   /**
304   * @dev Integer division of two numbers, truncating the quotient.
305   */
306   function div(uint256 a, uint256 b) internal pure returns (uint256) {
307     // assert(b > 0); // Solidity automatically throws when dividing by 0
308     uint256 c = a / b;
309     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
310     return c;
311   }
312 
313   /**
314   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
315   */
316   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
317     assert(b <= a);
318     return a - b;
319   }
320 
321   /**
322   * @dev Adds two numbers, throws on overflow.
323   */
324   function add(uint256 a, uint256 b) internal pure returns (uint256) {
325     uint256 c = a + b;
326     assert(c >= a);
327     return c;
328   }
329   
330 }