1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
120 
121 /**
122  * @title Pausable
123  * @dev Base contract which allows children to implement an emergency stop mechanism.
124  */
125 contract Pausable is Ownable {
126   event Pause();
127   event Unpause();
128 
129   bool public paused = false;
130 
131 
132   /**
133    * @dev Modifier to make a function callable only when the contract is not paused.
134    */
135   modifier whenNotPaused() {
136     require(!paused);
137     _;
138   }
139 
140   /**
141    * @dev Modifier to make a function callable only when the contract is paused.
142    */
143   modifier whenPaused() {
144     require(paused);
145     _;
146   }
147 
148   /**
149    * @dev called by the owner to pause, triggers stopped state
150    */
151   function pause() public onlyOwner whenNotPaused {
152     paused = true;
153     emit Pause();
154   }
155 
156   /**
157    * @dev called by the owner to unpause, returns to normal state
158    */
159   function unpause() public onlyOwner whenPaused {
160     paused = false;
161     emit Unpause();
162   }
163 }
164 
165 // File: contracts/inx/INXCommitment.sol
166 
167 /**
168 * Minimal interface definition for an INX Crowdsale
169 */
170 interface ICrowdsale {
171     function kyc(address _address) external returns (bool);
172     function wallet() external returns (address);
173     function minContribution() external returns (uint256);
174     function getCurrentRate() external returns (uint256);
175 }
176 
177 /**
178 * Minimal interface definition for an INX Token
179 */
180 interface IToken {
181     function mint(address _to, uint256 _amount) external returns (bool);
182 }
183 
184 /**
185  * @title INXCommitment used to capture commitments to the INX token sale from an individual address.
186  * Once KYC approved can redeem to INX Tokens.
187  */
188 contract INXCommitment is Pausable {
189     using SafeMath for uint256;
190 
191     address internal sender;
192 
193     uint256 internal tokenBalance;
194 
195     bool internal refunding = false;
196 
197     ICrowdsale internal crowdsale;
198     IToken internal token;
199 
200     /**
201      * Event for token commitment logging
202      * @param sender who paid for the tokens
203      * @param value weis paid for purchase
204      * @param rate of INX to wei
205      * @param amount amount of tokens purchased
206      */
207     event Commit(
208         address indexed sender,
209         uint256 value,
210         uint256 rate,
211         uint256 amount
212     );
213 
214     /**
215      * Event for refund of a commitment
216      * @param sender who paid for the tokens
217      * @param value weis refunded
218      */
219     event Refund(
220         address indexed sender,
221         uint256 value
222     );
223 
224     /**
225      * Event for refund toggle
226      */
227     event RefundToggle(
228         bool newValue
229     );
230 
231     /**
232      * Event for successful redemption of a commitment
233      * @param sender who paid for the tokens
234      * @param value weis refunded
235      * @param amount amount of token balance removed
236      */
237     event Redeem(
238         address indexed sender,
239         uint256 value,
240         uint256 amount
241     );
242 
243     constructor(address _sender, ICrowdsale _crowdsale, IToken _token) public  {
244         sender = _sender;
245         crowdsale = _crowdsale;
246         token = _token;
247     }
248 
249     /**
250      * @dev fallback function
251      */
252     function() external payable {
253         commit();
254     }
255 
256     /**
257     * @dev Sends a full refund of wei and reset committed tokens to zero
258     */
259     function refund() external whenNotPaused returns (bool) {
260         require(refunding, "Must be in refunding state");
261 
262         require(tokenBalance > 0, "Token balance must be positive");
263 
264         tokenBalance = 0;
265 
266         uint256 refundWeiBalance = address(this).balance;
267         sender.transfer(refundWeiBalance);
268 
269         emit Refund(
270             sender,
271             refundWeiBalance
272         );
273 
274         return true;
275     }
276 
277     /**
278     * @dev if the _sender has a balance and has been KYC then credits the account with balance
279     */
280     function redeem() external whenNotPaused returns (bool) {
281         require(!refunding, "Must not be in refunding state");
282 
283         require(tokenBalance > 0, "Token balance must be positive");
284 
285         bool kyc = crowdsale.kyc(sender);
286         require(kyc, "Sender must have passed KYC");
287 
288         uint256 redeemTokenBalance = tokenBalance;
289         tokenBalance = 0;
290 
291         uint256 redeemWeiBalance = address(this).balance;
292 
293         address wallet = crowdsale.wallet();
294         wallet.transfer(redeemWeiBalance);
295 
296         require(token.mint(sender, redeemTokenBalance), "Unable to mint INX tokens");
297 
298         emit Redeem(
299             sender,
300             redeemWeiBalance,
301             redeemTokenBalance
302         );
303 
304         return true;
305     }
306 
307     /**
308      * @dev captures a commitment to buy tokens at the current rate.
309      */
310     function commit() public payable whenNotPaused returns (bool) {
311         require(!refunding, "Must not be in refunding state");
312         require(sender == msg.sender, "Can only commit from the predefined sender address");
313 
314         uint256 weiAmount = msg.value;
315         uint256 minContribution = crowdsale.minContribution();
316 
317         require(weiAmount >= minContribution, "Commitment value below minimum");
318 
319         // pull the current rate from the crowdsale
320         uint256 rate = crowdsale.getCurrentRate();
321 
322         // calculate token amount to be committed
323         uint256 tokens = weiAmount.mul(rate);
324         tokenBalance = tokenBalance.add(tokens);
325 
326         emit Commit(
327             sender,
328             weiAmount,
329             rate,
330             tokens
331         );
332 
333         return true;
334     }
335 
336     /**
337      * @dev token balance of the associated sender
338      */
339     function senderTokenBalance() public view returns (uint256) {
340         return tokenBalance;
341     }
342 
343     /**
344      * @dev wei balance of the associated sender
345      */
346     function senderWeiBalance() public view returns (uint256) {
347         return address(this).balance;
348     }
349 
350     /**
351      * @dev associated sender of this contract
352      */
353     function senderAddress() public view returns (address) {
354         return sender;
355     }
356 
357     /**
358      * @dev associated INXCrowdsale
359      */
360     function inxCrowdsale() public view returns (address) {
361         return crowdsale;
362     }
363 
364 
365     /**
366      * @dev associated INXToken
367      */
368     function inxToken() public view returns (address) {
369         return token;
370     }
371 
372 
373     /**
374      * @dev current state of refunding
375      */
376     function isRefunding() public view returns (bool) {
377         return refunding;
378     }
379 
380     /**
381      * @dev Owner can toggle refunding state. Once in refunding anyone can trigger a refund of wei.
382      */
383     function toggleRefunding() external onlyOwner {
384         refunding = !refunding;
385 
386         emit RefundToggle(refunding);
387     }
388 }