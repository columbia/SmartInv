1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender)
12     public view returns (uint256);
13 
14   function transferFrom(address from, address to, uint256 value)
15     public returns (bool);
16 
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(
19     address indexed owner,
20     address indexed spender,
21     uint256 value
22   );
23 }
24 
25 contract BasicToken is ERC20Basic {
26   using SafeMath for uint256;
27 
28   mapping(address => uint256) balances;
29 
30   uint256 totalSupply_;
31 
32   /**
33   * @dev Total number of tokens in existence
34   */
35   function totalSupply() public view returns (uint256) {
36     return totalSupply_;
37   }
38 
39   /**
40   * @dev Transfer token for a specified address
41   * @param _to The address to transfer to.
42   * @param _value The amount to be transferred.
43   */
44   function transfer(address _to, uint256 _value) public returns (bool) {
45     require(_to != address(0));
46     require(_value <= balances[msg.sender]);
47 
48     balances[msg.sender] = balances[msg.sender].sub(_value);
49     balances[_to] = balances[_to].add(_value);
50     emit Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   /**
55   * @dev Gets the balance of the specified address.
56   * @param _owner The address to query the the balance of.
57   * @return An uint256 representing the amount owned by the passed address.
58   */
59   function balanceOf(address _owner) public view returns (uint256) {
60     return balances[_owner];
61   }
62 
63 }
64 
65 contract StandardToken is ERC20, BasicToken {
66 
67   mapping (address => mapping (address => uint256)) internal allowed;
68 
69 
70   /**
71    * @dev Transfer tokens from one address to another
72    * @param _from address The address which you want to send tokens from
73    * @param _to address The address which you want to transfer to
74    * @param _value uint256 the amount of tokens to be transferred
75    */
76   function transferFrom(
77     address _from,
78     address _to,
79     uint256 _value
80   )
81     public
82     returns (bool)
83   {
84     require(_to != address(0));
85     require(_value <= balances[_from]);
86     require(_value <= allowed[_from][msg.sender]);
87 
88     balances[_from] = balances[_from].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91     emit Transfer(_from, _to, _value);
92     return true;
93   }
94 
95   /**
96    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
97    * Beware that changing an allowance with this method brings the risk that someone may use both the old
98    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
99    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
100    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101    * @param _spender The address which will spend the funds.
102    * @param _value The amount of tokens to be spent.
103    */
104   function approve(address _spender, uint256 _value) public returns (bool) {
105     allowed[msg.sender][_spender] = _value;
106     emit Approval(msg.sender, _spender, _value);
107     return true;
108   }
109 
110   /**
111    * @dev Function to check the amount of tokens that an owner allowed to a spender.
112    * @param _owner address The address which owns the funds.
113    * @param _spender address The address which will spend the funds.
114    * @return A uint256 specifying the amount of tokens still available for the spender.
115    */
116   function allowance(
117     address _owner,
118     address _spender
119    )
120     public
121     view
122     returns (uint256)
123   {
124     return allowed[_owner][_spender];
125   }
126 
127   /**
128    * @dev Increase the amount of tokens that an owner allowed to a spender.
129    * approve should be called when allowed[_spender] == 0. To increment
130    * allowed value is better to use this function to avoid 2 calls (and wait until
131    * the first transaction is mined)
132    * From MonolithDAO Token.sol
133    * @param _spender The address which will spend the funds.
134    * @param _addedValue The amount of tokens to increase the allowance by.
135    */
136   function increaseApproval(
137     address _spender,
138     uint256 _addedValue
139   )
140     public
141     returns (bool)
142   {
143     allowed[msg.sender][_spender] = (
144       allowed[msg.sender][_spender].add(_addedValue));
145     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146     return true;
147   }
148 
149   /**
150    * @dev Decrease the amount of tokens that an owner allowed to a spender.
151    * approve should be called when allowed[_spender] == 0. To decrement
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    * @param _spender The address which will spend the funds.
156    * @param _subtractedValue The amount of tokens to decrease the allowance by.
157    */
158   function decreaseApproval(
159     address _spender,
160     uint256 _subtractedValue
161   )
162     public
163     returns (bool)
164   {
165     uint256 oldValue = allowed[msg.sender][_spender];
166     if (_subtractedValue > oldValue) {
167       allowed[msg.sender][_spender] = 0;
168     } else {
169       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
170     }
171     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175 }
176 
177 contract Ownable {
178   address public owner;
179 
180 
181   event OwnershipRenounced(address indexed previousOwner);
182   event OwnershipTransferred(
183     address indexed previousOwner,
184     address indexed newOwner
185   );
186 
187 
188   /**
189    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
190    * account.
191    */
192   constructor() public {
193     owner = msg.sender;
194   }
195 
196   /**
197    * @dev Throws if called by any account other than the owner.
198    */
199   modifier onlyOwner() {
200     require(msg.sender == owner);
201     _;
202   }
203 
204   /**
205    * @dev Allows the current owner to relinquish control of the contract.
206    * @notice Renouncing to ownership will leave the contract without an owner.
207    * It will not be possible to call the functions with the `onlyOwner`
208    * modifier anymore.
209    */
210   function renounceOwnership() public onlyOwner {
211     emit OwnershipRenounced(owner);
212     owner = address(0);
213   }
214 
215   /**
216    * @dev Allows the current owner to transfer control of the contract to a newOwner.
217    * @param _newOwner The address to transfer ownership to.
218    */
219   function transferOwnership(address _newOwner) public onlyOwner {
220     _transferOwnership(_newOwner);
221   }
222 
223   /**
224    * @dev Transfers control of the contract to a newOwner.
225    * @param _newOwner The address to transfer ownership to.
226    */
227   function _transferOwnership(address _newOwner) internal {
228     require(_newOwner != address(0));
229     emit OwnershipTransferred(owner, _newOwner);
230     owner = _newOwner;
231   }
232 }
233 
234 
235 /**
236  * @title SafeMath
237  * @dev Math operations with safety checks that throw on error
238  */
239 library SafeMath {
240 
241   /**
242   * @dev Multiplies two numbers, throws on overflow.
243   */
244   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
245     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
246     // benefit is lost if 'b' is also tested.
247     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
248     if (a == 0) {
249       return 0;
250     }
251 
252     c = a * b;
253     assert(c / a == b);
254     return c;
255   }
256 
257   /**
258   * @dev Integer division of two numbers, truncating the quotient.
259   */
260   function div(uint256 a, uint256 b) internal pure returns (uint256) {
261     // assert(b > 0); // Solidity automatically throws when dividing by 0
262     // uint256 c = a / b;
263     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
264     return a / b;
265   }
266 
267   /**
268   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
269   */
270   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
271     assert(b <= a);
272     return a - b;
273   }
274 
275   /**
276   * @dev Adds two numbers, throws on overflow.
277   */
278   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
279     c = a + b;
280     assert(c >= a);
281     return c;
282   }
283 }
284 
285 
286 contract CouponTokenConfig {
287     string public constant name = "Coupon Chain Token"; 
288     string public constant symbol = "CCT";
289     uint8 public constant decimals = 18;
290 
291     uint256 internal constant DECIMALS_FACTOR = 10 ** uint(decimals);
292     uint256 internal constant TOTAL_COUPON_SUPPLY = 1000000000 * DECIMALS_FACTOR;
293 
294     uint8 constant USER_NONE = 0;
295     uint8 constant USER_FOUNDER = 1;
296     uint8 constant USER_BUYER = 2;
297     uint8 constant USER_BONUS = 3;
298 
299 }
300 
301 //contract CouponToken is MintableToken {
302 contract CouponToken is StandardToken, Ownable, CouponTokenConfig {
303     using SafeMath for uint256;
304 
305     // Start time of the Sale-lot 4
306     uint256 public startTimeOfSaleLot4;
307 
308     // End time of Sale
309     uint256 public endSaleTime;
310 
311     // Address of CouponTokenSale contract
312     address public couponTokenSaleAddr;
313 
314     // Address of CouponTokenBounty contract
315     address public couponTokenBountyAddr;
316 
317     // Address of CouponTokenCampaign contract
318     address public couponTokenCampaignAddr;
319 
320 
321     // List of User for Vesting Period 
322     mapping(address => uint8) vestingUsers;
323 
324     /*
325      *
326      * E v e n t s
327      *
328      */
329     event Mint(address indexed to, uint256 tokens);
330 
331     /*
332      *
333      * M o d i f i e r s
334      *
335      */
336 
337     modifier canMint() {
338         require(
339             couponTokenSaleAddr == msg.sender ||
340             couponTokenBountyAddr == msg.sender ||
341             couponTokenCampaignAddr == msg.sender);
342         _;
343     }
344 
345     modifier onlyCallFromCouponTokenSale() {
346         require(msg.sender == couponTokenSaleAddr);
347         _;
348     }
349 
350     modifier onlyIfValidTransfer(address sender) {
351         require(isTransferAllowed(sender) == true);
352         _;
353     }
354 
355     modifier onlyCallFromTokenSaleOrBountyOrCampaign() {
356         require(
357             msg.sender == couponTokenSaleAddr ||
358             msg.sender == couponTokenBountyAddr ||
359             msg.sender == couponTokenCampaignAddr);
360         _;
361     }
362 
363 
364     /*
365      *
366      * C o n s t r u c t o r
367      *
368      */
369     constructor() public {
370         balances[msg.sender] = 0;
371     }
372 
373 
374     /*
375      *
376      * F u n c t i o n s
377      *
378      */
379     /**
380    * @dev Function to mint tokens
381    * @param _to The address that will receive the minted tokens.
382    * @param _amount The amount of tokens to mint.
383    * @return A boolean that indicates if the operation was successful.
384    */
385     function mint(address _to, uint256 _amount) canMint public {
386         
387         require(totalSupply_.add(_amount) <= TOTAL_COUPON_SUPPLY);
388 
389         totalSupply_ = totalSupply_.add(_amount);
390         balances[_to] = balances[_to].add(_amount);
391         emit Mint(_to, _amount);
392         emit Transfer(address(0), _to, _amount);
393     }
394 
395     /*
396      * Transfer token from message sender to another
397      *
398      * @param to: Destination address
399      * @param value: Amount of Coupon token to transfer
400      */
401     function transfer(address to, uint256 value)
402         public
403         onlyIfValidTransfer(msg.sender)
404         returns (bool) {
405         return super.transfer(to, value);
406     }
407 
408     /*
409      * Transfer token from 'from' address to 'to' addreess
410      *
411      * @param from: Origin address
412      * @param to: Destination address
413      * @param value: Amount of Coupon Token to transfer
414      */
415     function transferFrom(address from, address to, uint256 value)
416         public
417         onlyIfValidTransfer(from)
418         returns (bool){
419 
420         return super.transferFrom(from, to, value);
421     }
422 
423     function setContractAddresses(
424         address _couponTokenSaleAddr,
425         address _couponTokenBountyAddr,
426         address _couponTokenCampaignAddr)
427         external
428         onlyOwner
429     {
430         couponTokenSaleAddr = _couponTokenSaleAddr;
431         couponTokenBountyAddr = _couponTokenBountyAddr;
432         couponTokenCampaignAddr = _couponTokenCampaignAddr;
433     }
434 
435 
436     function setSalesEndTime(uint256 _endSaleTime) 
437         external
438         onlyCallFromCouponTokenSale  {
439         endSaleTime = _endSaleTime;
440     }
441 
442     function setSaleLot4StartTime(uint256 _startTime)
443         external
444         onlyCallFromCouponTokenSale {
445         startTimeOfSaleLot4 = _startTime;
446     }
447 
448 
449     function setFounderUser(address _user)
450         public
451         onlyCallFromCouponTokenSale {
452         // Add vesting user as Founder
453         vestingUsers[_user] = USER_FOUNDER;
454     }
455 
456     function setSalesUser(address _user)
457         public
458         onlyCallFromCouponTokenSale {
459         // Add vesting user under sales purchase
460         vestingUsers[_user] = USER_BUYER;
461     }
462 
463     function setBonusUser(address _user) 
464         public
465         onlyCallFromTokenSaleOrBountyOrCampaign {
466         // Set this user as who got bonus
467         vestingUsers[_user] = USER_BONUS;
468     }
469 
470     function isTransferAllowed(address _user)
471         internal view
472         returns (bool) {
473         bool retVal = true;
474         if(vestingUsers[_user] == USER_FOUNDER) {
475             if(endSaleTime == 0 ||                // See whether sale is over?
476                 (now < (endSaleTime + 730 days))) // 2 years
477                 retVal = false;
478         }
479         else if(vestingUsers[_user] == USER_BUYER || vestingUsers[_user] == USER_BONUS) {
480             if(startTimeOfSaleLot4 == 0 ||              // See if the SaleLot4 started?
481                 (now < (startTimeOfSaleLot4 + 90 days)))
482                 retVal = false;
483         }
484         return retVal;
485     }
486 }