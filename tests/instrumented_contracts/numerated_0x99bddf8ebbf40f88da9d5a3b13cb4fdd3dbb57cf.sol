1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 /**
47  * @title SafeERC20
48  * @dev Wrappers around ERC20 operations that throw on failure.
49  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
50  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
51  */
52 
53 library SafeERC20 {
54   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
55     assert(token.transfer(to, value));
56   }
57 
58   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
59     assert(token.transferFrom(from, to, value));
60   }
61 
62   function safeApprove(ERC20 token, address spender, uint256 value) internal {
63     assert(token.approve(spender, value));
64   }
65 }
66 
67 contract ERC20Basic {
68   function totalSupply() public view returns (uint256);
69   function balanceOf(address who) public view returns (uint256);
70   function transfer(address to, uint256 value) public returns (bool);
71   event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 contract ERC20 is ERC20Basic {
75   using SafeERC20 for ERC20;
76 
77   function allowance(address owner, address spender) public view returns (uint256);
78   function transferFrom(address from, address to, uint256 value) public returns (bool);
79   function approve(address spender, uint256 value) public returns (bool);
80   event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 contract DetailedERC20 is ERC20 {
84   string public name;
85   string public symbol;
86   uint8 public decimals;
87 
88   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
89     name = _name;
90     symbol = _symbol;
91     decimals = _decimals;
92   }
93 }
94 
95 
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   uint256 totalSupply_;
102 
103   /**
104   * @dev total number of tokens in existence
105   */
106   function totalSupply() public view returns (uint256) {
107     return totalSupply_;
108   }
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[msg.sender]);
118 
119     // SafeMath.sub will throw if there is not enough balance.
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 
138 contract BurnableToken is BasicToken {
139 
140   event Burn(address indexed burner, uint256 value);
141 
142   /**
143    * @dev Burns a specific amount of tokens.
144    * @param _value The amount of token to be burned.
145    */
146   function burn(uint256 _value) public {
147     require(_value <= balances[msg.sender]);
148     // no need to require value <= totalSupply, since that would imply the
149     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
150 
151     address burner = msg.sender;
152     balances[burner] = balances[burner].sub(_value);
153     totalSupply_ = totalSupply_.sub(_value);
154     Burn(burner, _value);
155     Transfer(burner, address(0), _value);
156   }
157 }
158 
159 
160 contract StandardToken is ERC20, BasicToken {
161 
162   mapping (address => mapping (address => uint256)) internal allowed;
163 
164 
165   /**
166    * @dev Transfer tokens from one address to another
167    * @param _from address The address which you want to send tokens from
168    * @param _to address The address which you want to transfer to
169    * @param _value uint256 the amount of tokens to be transferred
170    */
171   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[_from]);
174     require(_value <= allowed[_from][msg.sender]);
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179     Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    *
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(address _owner, address _spender) public view returns (uint256) {
206     return allowed[_owner][_spender];
207   }
208 
209   /**
210    * @dev Increase the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _addedValue The amount of tokens to increase the allowance by.
218    */
219   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
220     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
236     uint oldValue = allowed[msg.sender][_spender];
237     if (_subtractedValue > oldValue) {
238       allowed[msg.sender][_spender] = 0;
239     } else {
240       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241     }
242     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246 }
247 
248 
249 contract Ownable {
250   address public owner;
251 
252 
253   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
254 
255 
256   /**
257    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
258    * account.
259    */
260   function Ownable() public {
261     owner = msg.sender;
262   }
263 
264   /**
265    * @dev Throws if called by any account other than the owner.
266    */
267   modifier onlyOwner() {
268     require(msg.sender == owner);
269     _;
270   }
271 
272   /**
273    * @dev Allows the current owner to transfer control of the contract to a newOwner.
274    * @param newOwner The address to transfer ownership to.
275    */
276   function transferOwnership(address newOwner) public onlyOwner {
277     require(newOwner != address(0));
278     OwnershipTransferred(owner, newOwner);
279     owner = newOwner;
280   }
281 
282 }
283 
284 contract TokenVesting is Ownable {
285   using SafeMath for uint256;
286   using SafeERC20 for ERC20Basic;
287 
288   event Released(uint256 amount);
289   event Revoked();
290 
291   // beneficiary of tokens after they are released
292   address public beneficiary;
293 
294   uint256 public cliff;
295   uint256 public start;
296   uint256 public duration;
297 
298   bool public revocable;
299 
300   mapping (address => uint256) public released;
301   mapping (address => bool) public revoked;
302 
303   /**
304    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
305    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
306    * of the balance will have vested.
307    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
308    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
309    * @param _duration duration in seconds of the period in which the tokens will vest
310    * @param _revocable whether the vesting is revocable or not
311    */
312   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
313     require(_beneficiary != address(0));
314     require(_cliff <= _duration);
315 
316     beneficiary = _beneficiary;
317     revocable = _revocable;
318     duration = _duration;
319     cliff = _start.add(_cliff);
320     start = _start;
321   }
322 
323   /**
324    * @notice Transfers vested tokens to beneficiary.
325    * @param token ERC20 token which is being vested
326    */
327   function release(ERC20Basic token) public {
328     uint256 unreleased = releasableAmount(token);
329 
330     require(unreleased > 0);
331 
332     released[token] = released[token].add(unreleased);
333 
334     token.safeTransfer(beneficiary, unreleased);
335 
336     Released(unreleased);
337   }
338 
339   /**
340    * @notice Allows the owner to revoke the vesting. Tokens already vested
341    * remain in the contract, the rest are returned to the owner.
342    * @param token ERC20 token which is being vested
343    */
344   function revoke(ERC20Basic token) public onlyOwner {
345     require(revocable);
346     require(!revoked[token]);
347 
348     uint256 balance = token.balanceOf(this);
349 
350     uint256 unreleased = releasableAmount(token);
351     uint256 refund = balance.sub(unreleased);
352 
353     revoked[token] = true;
354 
355     token.safeTransfer(owner, refund);
356 
357     Revoked();
358   }
359 
360   /**
361    * @dev Calculates the amount that has already vested but hasn't been released yet.
362    * @param token ERC20 token which is being vested
363    */
364   function releasableAmount(ERC20Basic token) public view returns (uint256) {
365     return vestedAmount(token).sub(released[token]);
366   }
367 
368   /**
369    * @dev Calculates the amount that has already vested.
370    * @param token ERC20 token which is being vested
371    */
372   function vestedAmount(ERC20Basic token) public view returns (uint256) {
373     uint256 currentBalance = token.balanceOf(this);
374     uint256 totalBalance = currentBalance.add(released[token]);
375 
376     if (now < cliff) {
377       return 0;
378     } else if (now >= start.add(duration) || revoked[token]) {
379       return totalBalance;
380     } else {
381       return totalBalance.mul(now.sub(start)).div(duration);
382     }
383   }
384 }
385 
386 
387 contract Claimable is Ownable {
388   address public pendingOwner;
389 
390   /**
391    * @dev Modifier throws if called by any account other than the pendingOwner.
392    */
393   modifier onlyPendingOwner() {
394     require(msg.sender == pendingOwner);
395     _;
396   }
397 
398   /**
399    * @dev Allows the current owner to set the pendingOwner address.
400    * @param newOwner The address to transfer ownership to.
401    */
402   function transferOwnership(address newOwner) onlyOwner public {
403     pendingOwner = newOwner;
404   }
405 
406   /**
407    * @dev Allows the pendingOwner address to finalize the transfer.
408    */
409   function claimOwnership() onlyPendingOwner public {
410     OwnershipTransferred(owner, pendingOwner);
411     owner = pendingOwner;
412     pendingOwner = address(0);
413   }
414 }
415 
416 
417 contract Contactable is Ownable {
418 
419   string public contactInformation;
420 
421   /**
422     * @dev Allows the owner to set a string with their contact information.
423     * @param info The contact information to attach to the contract.
424     */
425   function setContactInformation(string info) onlyOwner public {
426     contactInformation = info;
427   }
428 }
429 
430 contract BetlyCoin is StandardToken, Ownable, BurnableToken {
431 
432   string public constant name = "BetlyCoin"; // solium-disable-line uppercase
433   string public constant symbol = "BETLY"; // solium-disable-line uppercase
434   uint8 public constant decimals = 18; // solium-disable-line uppercase
435 
436   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
437 
438   /**
439    * @dev Constructor that gives msg.sender all of existing tokens.
440    */
441   function BetlyCoin() public {
442     totalSupply_ = INITIAL_SUPPLY;
443     balances[msg.sender] = INITIAL_SUPPLY;
444     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
445   }
446 
447 }