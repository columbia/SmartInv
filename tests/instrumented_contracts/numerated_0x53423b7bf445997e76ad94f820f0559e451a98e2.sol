1 pragma solidity 0.8.17;
2 
3 library SafeMath {
4   /**
5    * @dev Returns the addition of two unsigned integers, reverting on
6    * overflow.
7    *
8    * Counterpart to Solidity's `+` operator.
9    *
10    * Requirements:
11    * - Addition cannot overflow.
12    */
13   function add(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a + b;
15     require(c >= a, "SafeMath: addition overflow");
16 
17     return c;
18   }
19 
20   /**
21    * @dev Returns the subtraction of two unsigned integers, reverting on
22    * overflow (when the result is negative).
23    *
24    * Counterpart to Solidity's `-` operator.
25    *
26    * Requirements:
27    * - Subtraction cannot overflow.
28    */
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     return sub(a, b, "SafeMath: subtraction overflow");
31   }
32 
33   /**
34    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
35    * overflow (when the result is negative).
36    *
37    * Counterpart to Solidity's `-` operator.
38    *
39    * Requirements:
40    * - Subtraction cannot overflow.
41    */
42   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43     require(b <= a, errorMessage);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50    * @dev Returns the multiplication of two unsigned integers, reverting on
51    * overflow.
52    *
53    * Counterpart to Solidity's `*` operator.
54    *
55    * Requirements:
56    * - Multiplication cannot overflow.
57    */
58   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60     // benefit is lost if 'b' is also tested.
61     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
62     if (a == 0) {
63       return 0;
64     }
65 
66     uint256 c = a * b;
67     require(c / a == b, "SafeMath: multiplication overflow");
68 
69     return c;
70   }
71 
72   /**
73    * @dev Returns the integer division of two unsigned integers. Reverts on
74    * division by zero. The result is rounded towards zero.
75    *
76    * Counterpart to Solidity's `/` operator. Note: this function uses a
77    * `revert` opcode (which leaves remaining gas untouched) while Solidity
78    * uses an invalid opcode to revert (consuming all remaining gas).
79    *
80    * Requirements:
81    * - The divisor cannot be zero.
82    */
83   function div(uint256 a, uint256 b) internal pure returns (uint256) {
84     return div(a, b, "SafeMath: division by zero");
85   }
86 
87   /**
88    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
89    * division by zero. The result is rounded towards zero.
90    *
91    * Counterpart to Solidity's `/` operator. Note: this function uses a
92    * `revert` opcode (which leaves remaining gas untouched) while Solidity
93    * uses an invalid opcode to revert (consuming all remaining gas).
94    *
95    * Requirements:
96    * - The divisor cannot be zero.
97    */
98   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99     // Solidity only automatically asserts when dividing by 0
100     require(b > 0, errorMessage);
101     uint256 c = a / b;
102     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103 
104     return c;
105   }
106 
107   /**
108    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
109    * Reverts when dividing by zero.
110    *
111    * Counterpart to Solidity's `%` operator. This function uses a `revert`
112    * opcode (which leaves remaining gas untouched) while Solidity uses an
113    * invalid opcode to revert (consuming all remaining gas).
114    *
115    * Requirements:
116    * - The divisor cannot be zero.
117    */
118   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
119     return mod(a, b, "SafeMath: modulo by zero");
120   }
121 
122   /**
123    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124    * Reverts with custom message when dividing by zero.
125    *
126    * Counterpart to Solidity's `%` operator. This function uses a `revert`
127    * opcode (which leaves remaining gas untouched) while Solidity uses an
128    * invalid opcode to revert (consuming all remaining gas).
129    *
130    * Requirements:
131    * - The divisor cannot be zero.
132    */
133   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134     require(b != 0, errorMessage);
135     return a % b;
136   }
137 }
138 abstract contract ReentrancyGuard {
139     // Booleans are more expensive than uint256 or any type that takes up a full
140     // word because each write operation emits an extra SLOAD to first read the
141     // slot's contents, replace the bits taken up by the boolean, and then write
142     // back. This is the compiler's defense against contract upgrades and
143     // pointer aliasing, and it cannot be disabled.
144 
145     // The values being non-zero value makes deployment a bit more expensive,
146     // but in exchange the refund on every call to nonReentrant will be lower in
147     // amount. Since refunds are capped to a percentage of the total
148     // transaction's gas, it is best to keep them low in cases like this one, to
149     // increase the likelihood of the full refund coming into effect.
150     uint256 private constant _NOT_ENTERED = 1;
151     uint256 private constant _ENTERED = 2;
152 
153     uint256 private _status;
154 
155     constructor() {
156         _status = _NOT_ENTERED;
157     }
158 
159     /**
160      * @dev Prevents a contract from calling itself, directly or indirectly.
161      * Calling a `nonReentrant` function from another `nonReentrant`
162      * function is not supported. It is possible to prevent this from happening
163      * by making the `nonReentrant` function external, and making it call a
164      * `private` function that does the actual work.
165      */
166     modifier nonReentrant() {
167         _nonReentrantBefore();
168         _;
169         _nonReentrantAfter();
170     }
171 
172     function _nonReentrantBefore() private {
173         // On the first call to nonReentrant, _notEntered will be true
174         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
175 
176         // Any calls to nonReentrant after this point will fail
177         _status = _ENTERED;
178     }
179 
180     function _nonReentrantAfter() private {
181         // By storing the original value once again, a refund is triggered (see
182         // https://eips.ethereum.org/EIPS/eip-2200)
183         _status = _NOT_ENTERED;
184     }
185 }
186 
187 interface IBEP20 {
188     /**
189      * @dev Returns the amount of tokens in existence.
190      */
191     function totalSupply() external view returns (uint256);
192 
193     /**
194      * @dev Returns the token decimals.
195      */
196     function decimals() external view returns (uint8);
197 
198     /**
199      * @dev Returns the token symbol.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the token name.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the bep token owner.
210      */
211     function getOwner() external view returns (address);
212 
213     /**
214      * @dev Returns the amount of tokens owned by `account`.
215      */
216     function balanceOf(address account) external view returns (uint256);
217 
218     /**
219      * @dev Moves `amount` tokens from the caller's account to `recipient`.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * Emits a {Transfer} event.
224      */
225     function transfer(address recipient, uint256 amount)
226         external
227         returns (bool);
228 
229     /**
230      * @dev Returns the remaining number of tokens that `spender` will be
231      * allowed to spend on behalf of `owner` through {transferFrom}. This is
232      * zero by default.
233      *
234      * This value changes when {approve} or {transferFrom} are called.
235      */
236     function allowance(address _owner, address spender)
237         external
238         view
239         returns (uint256);
240 
241     /**
242      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * IMPORTANT: Beware that changing an allowance with this method brings the risk
247      * that someone may use both the old and the new allowance by unfortunate
248      * transaction ordering. One possible solution to mitigate this race
249      * condition is to first reduce the spender's allowance to 0 and set the
250      * desired value afterwards:
251      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252      *
253      * Emits an {Approval} event.
254      */
255     function approve(address spender, uint256 amount) external returns (bool);
256 
257     /**
258      * @dev Moves `amount` tokens from `sender` to `recipient` using the
259      * allowance mechanism. `amount` is then deducted from the caller's
260      * allowance.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * Emits a {Transfer} event.
265      */
266     function transferFrom(
267         address sender,
268         address recipient,
269         uint256 amount
270     ) external returns (bool);
271 
272     /**
273      * @dev Emitted when `value` tokens are moved from one account (`from`) to
274      * another (`to`).
275      *
276      * Note that `value` may be zero.
277      */
278     event Transfer(address indexed from, address indexed to, uint256 value);
279 
280     /**
281      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
282      * a call to {approve}. `value` is the new allowance.
283      */
284     event Approval(
285         address indexed owner,
286         address indexed spender,
287         uint256 value
288     );
289 }
290 contract KEKBridgeV4 is ReentrancyGuard {
291       using SafeMath for uint256;
292 
293     struct BridgeTx { 
294         address receiver;
295         uint256 amount;
296         uint256 timestamp;
297     }
298 
299     mapping(uint256=>BridgeTx) transactions;
300     mapping(uint256=>bool) confirmedBridgesFromDC;
301     mapping(address=>BridgeTx[]) BSCtoDCHistory;
302 
303 
304 
305     address public BEP20Doge=0x67954768E721FAD0f0f21E33e874497C73ED6a82;
306     IBEP20 public Doge = IBEP20(BEP20Doge);
307 
308     address public owner=0x7650F39bA8D036b1f7C7b974a6b02aAd4B7F71F7;
309     address public oracle=0x3e697f3373F1a2795996C090eFc2Cef08BcCbcb9;
310 
311     address public beneficiary1=address(0);
312     address public beneficiary2=address(0);
313     address public beneficiary3=address(0);
314 
315     uint256 bridgeId=0;
316 
317     uint256 lockFee=1;
318     uint256 minFee=1500000000000000000000; //Ether unit
319     bool public bridge=false;
320 
321     function readHistoryBSCtoDC() public view returns (BridgeTx[] memory){
322         return BSCtoDCHistory[msg.sender];
323     }
324 
325     function readTransaction(uint256 id) public view returns(BridgeTx memory){
326         return transactions[id];
327     }
328 
329     function enableBridge() public{
330         require(msg.sender==owner);
331         bridge=false;
332     }
333     function disableBridge() public{
334         require(msg.sender==owner);
335         bridge=true;
336     }
337 
338     function setBeneficiary1(address wallet) public{
339       require(msg.sender==owner);
340       beneficiary1=wallet;
341     }
342     function setBeneficiary2(address wallet) public{
343       require(msg.sender==owner);
344       beneficiary2=wallet;
345     }
346     function setBeneficiary3(address wallet) public{
347       require(msg.sender==owner);
348       beneficiary3=wallet;
349     }        
350     function currentBridgeId() public view returns(uint256){
351         return bridgeId;
352     }
353 
354     function modifyMinFee(uint256 amt) public{
355         require(msg.sender==owner);
356         require(minFee>0,"Min fee cannot be 0");
357         minFee=amt;
358     }
359 
360     function modifyOwner(address newowner) public{
361         require(msg.sender==owner);
362         owner=newowner;
363     }
364 
365     function modifyOracle(address neworacle) public {
366         require(msg.sender==owner);
367         oracle=neworacle;
368     }
369 
370     function withdrawDoge(uint256 amount) public nonReentrant {
371         require(msg.sender==owner);
372         Doge.transfer(owner, (amount));
373     }
374 
375     function modifyBSCToDCFee(uint256 newFee) public{
376         require(msg.sender==owner);
377         lockFee=newFee;
378     }
379 
380     event BridgeComplete(address indexed receiver, uint256 indexed id, uint256 amount);
381 
382     function KEKtoETH(uint256 amount,address requestor,uint256 id) public nonReentrant{
383         require(msg.sender==oracle);
384         require(!confirmedBridgesFromDC[id]);    
385         confirmedBridgesFromDC[id]=true;    
386         Doge.transfer(requestor, (amount));
387         emit BridgeComplete(requestor, id, amount);
388 
389     }
390 
391     function addWhitelist(address who,uint256 newWhitelistFee) public {
392       require(msg.sender==owner);
393       require(newWhitelistFee>=10);
394       whitelist[who]=true;
395       whitelistFee[who]=newWhitelistFee;
396     }
397     function removeWhitelist(address who) public {
398       require(msg.sender==owner);
399       whitelist[who]=false;
400       delete whitelistFee[who];
401     }    
402 
403     mapping(address=>bool) whitelist;
404     mapping(address=>uint256) whitelistFee;
405 
406     mapping (address=>uint256) addedLiquidity;
407 
408     function addLiquidity(uint256 amount) public nonReentrant {
409       require(amount>0,"Added liquidity cannot be 0");
410         Doge.transferFrom(msg.sender,address(this),amount);
411         addedLiquidity[msg.sender]=addedLiquidity[msg.sender].add(amount);      
412     }
413 
414     function removeLiquidity(uint256 amount) public nonReentrant {
415       require(amount<addedLiquidity[msg.sender],"You don't have enough liquidity.");
416       addedLiquidity[msg.sender]=addedLiquidity[msg.sender].sub(amount);
417       Doge.transfer(msg.sender,amount);
418     }
419 
420 
421     function ETHToKEK (address receiver,uint256 amount) public nonReentrant
422     {   
423         require(bridge==false,"Bridge disabled.");
424         require(amount>0,"Invalid amount");
425 
426         uint256 thisBridgeFee=0;
427 
428         if(whitelist[msg.sender]==true){
429           thisBridgeFee=whitelistFee[msg.sender];
430         } else {
431           thisBridgeFee=lockFee;
432         }
433 
434         uint256 bridgeFee=SafeMath.mul(SafeMath.div(amount,1000),thisBridgeFee);
435         if(bridgeFee<minFee){
436           bridgeFee=minFee;
437         }
438         uint256 teamFee=SafeMath.div(bridgeFee,3);
439 
440         Doge.transferFrom(msg.sender,address(this),amount);
441         
442         Doge.transfer(beneficiary1,teamFee);                
443         Doge.transfer(beneficiary2,teamFee);                
444         Doge.transfer(beneficiary3,teamFee);                
445 
446         uint256 amountMinusFees=SafeMath.sub(amount,bridgeFee);
447         transactions[bridgeId].receiver=receiver;
448         transactions[bridgeId].amount=amountMinusFees;
449         transactions[bridgeId].timestamp=block.timestamp;
450         BSCtoDCHistory[msg.sender].push(transactions[bridgeId]);
451         bridgeId++;
452         
453     }
454     
455 
456 }