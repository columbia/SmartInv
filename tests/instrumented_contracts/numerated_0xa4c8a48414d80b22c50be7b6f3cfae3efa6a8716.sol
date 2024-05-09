1 pragma solidity ^0.4.18;
2 
3 contract PPNAirdrop {
4     /**
5     * @dev Air drop Public Variables
6     */
7     address                         public admin;
8     PolicyPalNetworkToken           public token;
9 
10     using SafeMath for uint256;
11 
12     /**
13     * @dev   Token Contract Modifier
14     * Check if only admin
15     *
16     */
17     modifier onlyAdmin() {
18         require(msg.sender == admin);
19         _;
20     }
21 
22     /**
23     * @dev   Token Contract Modifier
24     * Check if valid address
25     *
26     * @param _addr - The address to check
27     *
28     */
29     modifier validAddress(address _addr) {
30         require(_addr != address(0x0));
31         require(_addr != address(this));
32         _;
33     }
34 
35     /**
36     * @dev   Token Contract Modifier
37     * Check if the batch transfer amount is
38     * equal or more than balance
39     * (For single batch amount)
40     *
41     * @param _recipients - The recipients to send
42     * @param _amount - The amount to send
43     *
44     */
45     modifier validBalance(address[] _recipients, uint256 _amount) {
46         // Assert balance
47         uint256 balance = token.balanceOf(this);
48         require(balance > 0);
49         require(balance >= _recipients.length.mul(_amount));
50         _;
51     }
52 
53     /**
54     * @dev   Token Contract Modifier
55     * Check if the batch transfer amount is
56     * equal or more than balance
57     * (For multiple batch amounts)
58     *
59     * @param _recipients - The recipients to send
60     * @param _amounts - The amounts to send
61     *
62     */
63     modifier validBalanceMultiple(address[] _recipients, uint256[] _amounts) {
64         // Assert balance
65         uint256 balance = token.balanceOf(this);
66         require(balance > 0);
67 
68         uint256 totalAmount;
69         for (uint256 i = 0 ; i < _recipients.length ; i++) {
70             totalAmount = totalAmount.add(_amounts[i]);
71         }
72         require(balance >= totalAmount);
73         _;
74     }
75 
76     /**
77     * @dev Airdrop Contract Constructor
78     * @param _token - PPN Token address
79     * @param _adminAddr - Address of the Admin
80     */
81     function PPNAirdrop(
82         PolicyPalNetworkToken _token, 
83         address _adminAddr
84     )
85         public
86         validAddress(_adminAddr)
87         validAddress(_token)
88     {
89         // Assign addresses
90         admin = _adminAddr;
91         token = _token;
92     }
93     
94     /**
95      * @dev TokenDrop Event
96      */
97     event TokenDrop(address _receiver, uint _amount);
98 
99     /**
100      * @dev batch Air Drop by single amount
101      * @param _recipients - Address of the recipient
102      * @param _amount - Amount to transfer used in this batch
103      */
104     function batchSingleAmount(address[] _recipients, uint256 _amount) external
105         onlyAdmin
106         validBalance(_recipients, _amount)
107     {
108         // Loop through all recipients
109         for (uint256 i = 0 ; i < _recipients.length ; i++) {
110             address recipient = _recipients[i];
111 
112             // Transfer amount
113             assert(token.transfer(recipient, _amount));
114 
115             // TokenDrop event
116             TokenDrop(recipient, _amount);
117         }
118     }
119 
120     /**
121      * @dev batch Air Drop by multiple amount
122      * @param _recipients - Address of the recipient
123      * @param _amounts - Amount to transfer used in this batch
124      */
125     function batchMultipleAmount(address[] _recipients, uint256[] _amounts) external
126         onlyAdmin
127         validBalanceMultiple(_recipients, _amounts)
128     {
129         // Loop through all recipients
130         for (uint256 i = 0 ; i < _recipients.length ; i++) {
131             address recipient = _recipients[i];
132             uint256 amount = _amounts[i];
133 
134             // Transfer amount
135             assert(token.transfer(recipient, amount));
136 
137             // TokenDrop event
138             TokenDrop(recipient, amount);
139         }
140     }
141 
142     /**
143      * @dev Air drop single amount
144      * @param _recipient - Address of the recipient
145      * @param _amount - Amount to drain
146      */
147     function airdropSingleAmount(address _recipient, uint256 _amount) external
148       onlyAdmin
149     {
150         assert(_amount <= token.balanceOf(this));
151         assert(token.transfer(_recipient, _amount));
152     }
153 }
154 
155 library SafeMath {
156 
157   /**
158   * @dev Multiplies two numbers, throws on overflow.
159   */
160   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161     if (a == 0) {
162       return 0;
163     }
164     uint256 c = a * b;
165     assert(c / a == b);
166     return c;
167   }
168 
169   /**
170   * @dev Integer division of two numbers, truncating the quotient.
171   */
172   function div(uint256 a, uint256 b) internal pure returns (uint256) {
173     // assert(b > 0); // Solidity automatically throws when dividing by 0
174     uint256 c = a / b;
175     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
176     return c;
177   }
178 
179   /**
180   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
181   */
182   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183     assert(b <= a);
184     return a - b;
185   }
186 
187   /**
188   * @dev Adds two numbers, throws on overflow.
189   */
190   function add(uint256 a, uint256 b) internal pure returns (uint256) {
191     uint256 c = a + b;
192     assert(c >= a);
193     return c;
194   }
195 }
196 
197 contract Ownable {
198   address public owner;
199 
200 
201   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
202 
203 
204   /**
205    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
206    * account.
207    */
208   function Ownable() public {
209     owner = msg.sender;
210   }
211 
212   /**
213    * @dev Throws if called by any account other than the owner.
214    */
215   modifier onlyOwner() {
216     require(msg.sender == owner);
217     _;
218   }
219 
220   /**
221    * @dev Allows the current owner to transfer control of the contract to a newOwner.
222    * @param newOwner The address to transfer ownership to.
223    */
224   function transferOwnership(address newOwner) public onlyOwner {
225     require(newOwner != address(0));
226     OwnershipTransferred(owner, newOwner);
227     owner = newOwner;
228   }
229 
230 }
231 
232 contract ERC20Basic {
233   function totalSupply() public view returns (uint256);
234   function balanceOf(address who) public view returns (uint256);
235   function transfer(address to, uint256 value) public returns (bool);
236   event Transfer(address indexed from, address indexed to, uint256 value);
237 }
238 
239 contract BasicToken is ERC20Basic {
240   using SafeMath for uint256;
241 
242   mapping(address => uint256) balances;
243 
244   uint256 totalSupply_;
245 
246   /**
247   * @dev total number of tokens in existence
248   */
249   function totalSupply() public view returns (uint256) {
250     return totalSupply_;
251   }
252 
253   /**
254   * @dev transfer token for a specified address
255   * @param _to The address to transfer to.
256   * @param _value The amount to be transferred.
257   */
258   function transfer(address _to, uint256 _value) public returns (bool) {
259     require(_to != address(0));
260     require(_value <= balances[msg.sender]);
261 
262     // SafeMath.sub will throw if there is not enough balance.
263     balances[msg.sender] = balances[msg.sender].sub(_value);
264     balances[_to] = balances[_to].add(_value);
265     Transfer(msg.sender, _to, _value);
266     return true;
267   }
268 
269   /**
270   * @dev Gets the balance of the specified address.
271   * @param _owner The address to query the the balance of.
272   * @return An uint256 representing the amount owned by the passed address.
273   */
274   function balanceOf(address _owner) public view returns (uint256 balance) {
275     return balances[_owner];
276   }
277 
278 }
279 
280 contract BurnableToken is BasicToken {
281 
282   event Burn(address indexed burner, uint256 value);
283 
284   /**
285    * @dev Burns a specific amount of tokens.
286    * @param _value The amount of token to be burned.
287    */
288   function burn(uint256 _value) public {
289     require(_value <= balances[msg.sender]);
290     // no need to require value <= totalSupply, since that would imply the
291     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
292 
293     address burner = msg.sender;
294     balances[burner] = balances[burner].sub(_value);
295     totalSupply_ = totalSupply_.sub(_value);
296     Burn(burner, _value);
297   }
298 }
299 
300 contract ERC20 is ERC20Basic {
301   function allowance(address owner, address spender) public view returns (uint256);
302   function transferFrom(address from, address to, uint256 value) public returns (bool);
303   function approve(address spender, uint256 value) public returns (bool);
304   event Approval(address indexed owner, address indexed spender, uint256 value);
305 }
306 
307 contract StandardToken is ERC20, BasicToken {
308 
309   mapping (address => mapping (address => uint256)) internal allowed;
310 
311 
312   /**
313    * @dev Transfer tokens from one address to another
314    * @param _from address The address which you want to send tokens from
315    * @param _to address The address which you want to transfer to
316    * @param _value uint256 the amount of tokens to be transferred
317    */
318   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
319     require(_to != address(0));
320     require(_value <= balances[_from]);
321     require(_value <= allowed[_from][msg.sender]);
322 
323     balances[_from] = balances[_from].sub(_value);
324     balances[_to] = balances[_to].add(_value);
325     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
326     Transfer(_from, _to, _value);
327     return true;
328   }
329 
330   /**
331    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
332    *
333    * Beware that changing an allowance with this method brings the risk that someone may use both the old
334    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
335    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
336    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
337    * @param _spender The address which will spend the funds.
338    * @param _value The amount of tokens to be spent.
339    */
340   function approve(address _spender, uint256 _value) public returns (bool) {
341     allowed[msg.sender][_spender] = _value;
342     Approval(msg.sender, _spender, _value);
343     return true;
344   }
345 
346   /**
347    * @dev Function to check the amount of tokens that an owner allowed to a spender.
348    * @param _owner address The address which owns the funds.
349    * @param _spender address The address which will spend the funds.
350    * @return A uint256 specifying the amount of tokens still available for the spender.
351    */
352   function allowance(address _owner, address _spender) public view returns (uint256) {
353     return allowed[_owner][_spender];
354   }
355 
356   /**
357    * @dev Increase the amount of tokens that an owner allowed to a spender.
358    *
359    * approve should be called when allowed[_spender] == 0. To increment
360    * allowed value is better to use this function to avoid 2 calls (and wait until
361    * the first transaction is mined)
362    * From MonolithDAO Token.sol
363    * @param _spender The address which will spend the funds.
364    * @param _addedValue The amount of tokens to increase the allowance by.
365    */
366   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
367     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
368     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
369     return true;
370   }
371 
372   /**
373    * @dev Decrease the amount of tokens that an owner allowed to a spender.
374    *
375    * approve should be called when allowed[_spender] == 0. To decrement
376    * allowed value is better to use this function to avoid 2 calls (and wait until
377    * the first transaction is mined)
378    * From MonolithDAO Token.sol
379    * @param _spender The address which will spend the funds.
380    * @param _subtractedValue The amount of tokens to decrease the allowance by.
381    */
382   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
383     uint oldValue = allowed[msg.sender][_spender];
384     if (_subtractedValue > oldValue) {
385       allowed[msg.sender][_spender] = 0;
386     } else {
387       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
388     }
389     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
390     return true;
391   }
392 
393 }
394 
395 contract PolicyPalNetworkToken is StandardToken, BurnableToken, Ownable {
396     /**
397     * @dev Token Contract Constants
398     */
399     string    public constant name     = "PolicyPal Network Token";
400     string    public constant symbol   = "PAL";
401     uint8     public constant decimals = 18;
402 
403     /**
404     * @dev Token Contract Public Variables
405     */
406     address public  tokenSaleContract;
407     bool    public  isTokenTransferable = false;
408 
409 
410     /**
411     * @dev   Token Contract Modifier
412     *
413     * Check if a transfer is allowed
414     * Transfers are restricted to token creator & owner(admin) during token sale duration
415     * Transfers after token sale is limited by `isTokenTransferable` toggle
416     *
417     */
418     modifier onlyWhenTransferAllowed() {
419         require(isTokenTransferable || msg.sender == owner || msg.sender == tokenSaleContract);
420         _;
421     }
422 
423     /**
424      * @dev Token Contract Modifier
425      * @param _to - Address to check if valid
426      *
427      *  Check if an address is valid
428      *  A valid address is as follows,
429      *    1. Not zero address
430      *    2. Not token address
431      *
432      */
433     modifier isValidDestination(address _to) {
434         require(_to != address(0x0));
435         require(_to != address(this));
436         _;
437     }
438 
439     /**
440      * @dev Enable Transfers (Only Owner)
441      */
442     function toggleTransferable(bool _toggle) external
443         onlyOwner
444     {
445         isTokenTransferable = _toggle;
446     }
447     
448 
449     /**
450     * @dev Token Contract Constructor
451     * @param _adminAddr - Address of the Admin
452     */
453     function PolicyPalNetworkToken(
454         uint _tokenTotalAmount,
455         address _adminAddr
456     ) 
457         public
458         isValidDestination(_adminAddr)
459     {
460         require(_tokenTotalAmount > 0);
461 
462         totalSupply_ = _tokenTotalAmount;
463 
464         // Mint all token
465         balances[msg.sender] = _tokenTotalAmount;
466         Transfer(address(0x0), msg.sender, _tokenTotalAmount);
467 
468         // Assign token sale contract to creator
469         tokenSaleContract = msg.sender;
470 
471         // Transfer contract ownership to admin
472         transferOwnership(_adminAddr);
473     }
474 
475     /**
476     * @dev Token Contract transfer
477     * @param _to - Address to transfer to
478     * @param _value - Value to transfer
479     * @return bool - Result of transfer
480     * "Overloaded" Function of ERC20Basic's transfer
481     *
482     */
483     function transfer(address _to, uint256 _value) public
484         onlyWhenTransferAllowed
485         isValidDestination(_to)
486         returns (bool)
487     {
488         return super.transfer(_to, _value);
489     }
490 
491     /**
492     * @dev Token Contract transferFrom
493     * @param _from - Address to transfer from
494     * @param _to - Address to transfer to
495     * @param _value - Value to transfer
496     * @return bool - Result of transferFrom
497     *
498     * "Overloaded" Function of ERC20's transferFrom
499     * Added with modifiers,
500     *    1. onlyWhenTransferAllowed
501     *    2. isValidDestination
502     *
503     */
504     function transferFrom(address _from, address _to, uint256 _value) public
505         onlyWhenTransferAllowed
506         isValidDestination(_to)
507         returns (bool)
508     {
509         return super.transferFrom(_from, _to, _value);
510     }
511 
512     /**
513     * @dev Token Contract burn
514     * @param _value - Value to burn
515     * "Overloaded" Function of BurnableToken's burn
516     */
517     function burn(uint256 _value)
518         public
519     {
520         super.burn(_value);
521         Transfer(msg.sender, address(0x0), _value);
522     }
523 
524     /**
525     * @dev Token Contract Emergency Drain
526     * @param _token - Token to drain
527     * @param _amount - Amount to drain
528     */
529     function emergencyERC20Drain(ERC20 _token, uint256 _amount) public
530         onlyOwner
531     {
532         _token.transfer(owner, _amount);
533     }
534 }