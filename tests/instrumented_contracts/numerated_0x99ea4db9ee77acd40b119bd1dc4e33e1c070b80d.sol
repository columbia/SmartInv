1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) onlyOwner public {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 
78 
79 
80 /**
81  * @title Pausable
82  * @dev Base contract which allows children to implement an emergency stop mechanism.
83  */
84 contract Pausable is Ownable {
85   event Pause();
86   event Unpause();
87 
88   bool public paused = false;
89 
90 
91   /**
92    * @dev Modifier to make a function callable only when the contract is not paused.
93    */
94   modifier whenNotPaused() {
95     require(!paused);
96     _;
97   }
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is paused.
101    */
102   modifier whenPaused() {
103     require(paused);
104     _;
105   }
106 
107   /**
108    * @dev called by the owner to pause, triggers stopped state
109    */
110   function pause() onlyOwner whenNotPaused public {
111     paused = true;
112     Pause();
113   }
114 
115   /**
116    * @dev called by the owner to unpause, returns to normal state
117    */
118   function unpause() onlyOwner whenPaused public {
119     paused = false;
120     Unpause();
121   }
122 }
123 
124 
125 
126 /**
127  * @title ERC20Basic
128  * @dev Simpler version of ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/179
130  */
131 contract ERC20Basic {
132   uint256 public totalSupply;
133   function balanceOf(address who) public constant returns (uint256);
134   function transfer(address to, uint256 value) public returns (bool);
135   event Transfer(address indexed from, address indexed to, uint256 value);
136 }
137 
138 
139 
140 
141 
142 /**
143  * @title ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/20
145  */
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender) public constant returns (uint256);
148   function transferFrom(address from, address to, uint256 value) public returns (bool);
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 
154 
155 
156 
157 /**
158  * @title Basic token
159  * @dev Basic version of StandardToken, with no allowances.
160  */
161 contract BasicToken is ERC20Basic {
162   using SafeMath for uint256;
163 
164   mapping(address => uint256) balances;
165 
166 
167 
168   /**
169   * @dev transfer token for a specified address
170   * @param _to The address to transfer to.
171   * @param _value The amount to be transferred.
172   */
173   function transfer(address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175 
176     // SafeMath.sub will throw if there is not enough balance.
177     balances[msg.sender] = balances[msg.sender].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     Transfer(msg.sender, _to, _value);
180     return true;
181   }
182 
183   /**
184   * @dev Gets the balance of the specified address.
185   * @param _owner The address to query the the balance of.
186   * @return An uint256 representing the amount owned by the passed address.
187   */
188   function balanceOf(address _owner) public constant returns (uint256 balance) {
189     return balances[_owner];
190   }
191 
192 }
193 
194 
195 
196 
197 
198 /**
199  * @title Standard ERC20 token
200  *
201  * @dev Implementation of the basic standard token.
202  * @dev https://github.com/ethereum/EIPs/issues/20
203  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
204  */
205 contract StandardToken is ERC20, BasicToken {
206 
207   mapping (address => mapping (address => uint256)) allowed;
208 
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint256 the amount of tokens to be transferred
215    */
216   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
217     require(_to != address(0));
218 
219     uint256 _allowance = allowed[_from][msg.sender];
220 
221     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
222     // require (_value <= _allowance);
223 
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = _allowance.sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    *
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * approve should be called when allowed[_spender] == 0. To increment
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    */
263   function increaseApproval (address _spender, uint _addedValue)
264     returns (bool success) {
265     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
266     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267     return true;
268   }
269 
270   function decreaseApproval (address _spender, uint _subtractedValue)
271     returns (bool success) {
272     uint oldValue = allowed[msg.sender][_spender];
273     if (_subtractedValue > oldValue) {
274       allowed[msg.sender][_spender] = 0;
275     } else {
276       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
277     }
278     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282 }
283 
284 
285 
286 /**
287  * @title Burnable Token
288  * @dev Token that can be irreversibly burned (destroyed).
289  */
290 contract BurnableToken is StandardToken {
291 
292     event Burn(address indexed burner, uint256 value);
293 
294     /**
295      * @dev Burns a specific amount of tokens.
296      * @param _value The amount of token to be burned.
297      */
298     function burn(uint256 _value) public {
299         require(_value > 0);
300 
301         address burner = msg.sender;
302         balances[burner] = balances[burner].sub(_value);
303         totalSupply = totalSupply.sub(_value);
304         Burn(burner, _value);
305     }
306 }
307 
308 // Quantstamp Technologies Inc. (info@quantstamp.com)
309 
310 
311 
312 /**
313  * The Quantstamp token (QSP) has a fixed supply and restricts the ability
314  * to transfer tokens until the owner has called the enableTransfer()
315  * function.
316  *
317  * The owner can associate the token with a token sale contract. In that
318  * case, the token balance is moved to the token sale contract, which
319  * in turn can transfer its tokens to contributors to the sale.
320  */
321 contract QuantstampToken is StandardToken, BurnableToken, Ownable {
322 
323     // Constants
324     string  public constant name = "Quantstamp Token";
325     string  public constant symbol = "QSP";
326     uint8   public constant decimals = 18;
327     uint256 public constant INITIAL_SUPPLY      = 1000000000 * (10 ** uint256(decimals));
328     uint256 public constant CROWDSALE_ALLOWANCE =  650000000 * (10 ** uint256(decimals));
329     uint256 public constant ADMIN_ALLOWANCE     =  350000000 * (10 ** uint256(decimals));
330 
331     // Properties
332     uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
333     uint256 public adminAllowance;          // the number of tokens available for the administrator
334     address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
335     address public adminAddr;               // the address of the token admin account
336     bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
337 
338     // Modifiers
339     modifier onlyWhenTransferEnabled() {
340         if (!transferEnabled) {
341             require(msg.sender == adminAddr || msg.sender == crowdSaleAddr);
342         }
343         _;
344     }
345 
346     /**
347      * The listed addresses are not valid recipients of tokens.
348      *
349      * 0x0           - the zero address is not valid
350      * this          - the contract itself should not receive tokens
351      * owner         - the owner has all the initial tokens, but cannot receive any back
352      * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
353      * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
354      */
355     modifier validDestination(address _to) {
356         require(_to != address(0x0));
357         require(_to != address(this));
358         require(_to != owner);
359         require(_to != address(adminAddr));
360         require(_to != address(crowdSaleAddr));
361         _;
362     }
363 
364     /**
365      * Constructor - instantiates token supply and allocates balanace of
366      * to the owner (msg.sender).
367      */
368     function QuantstampToken(address _admin) {
369         // the owner is a custodian of tokens that can
370         // give an allowance of tokens for crowdsales
371         // or to the admin, but cannot itself transfer
372         // tokens; hence, this requirement
373         require(msg.sender != _admin);
374 
375         totalSupply = INITIAL_SUPPLY;
376         crowdSaleAllowance = CROWDSALE_ALLOWANCE;
377         adminAllowance = ADMIN_ALLOWANCE;
378 
379         // mint all tokens
380         balances[msg.sender] = totalSupply;
381         Transfer(address(0x0), msg.sender, totalSupply);
382 
383         adminAddr = _admin;
384         approve(adminAddr, adminAllowance);
385     }
386 
387     /**
388      * Associates this token with a current crowdsale, giving the crowdsale
389      * an allowance of tokens from the crowdsale supply. This gives the
390      * crowdsale the ability to call transferFrom to transfer tokens to
391      * whomever has purchased them.
392      *
393      * Note that if _amountForSale is 0, then it is assumed that the full
394      * remaining crowdsale supply is made available to the crowdsale.
395      *
396      * @param _crowdSaleAddr The address of a crowdsale contract that will sell this token
397      * @param _amountForSale The supply of tokens provided to the crowdsale
398      */
399     function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
400         require(!transferEnabled);
401         require(_amountForSale <= crowdSaleAllowance);
402 
403         // if 0, then full available crowdsale supply is assumed
404         uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;
405 
406         // Clear allowance of old, and set allowance of new
407         approve(crowdSaleAddr, 0);
408         approve(_crowdSaleAddr, amount);
409 
410         crowdSaleAddr = _crowdSaleAddr;
411     }
412 
413     /**
414      * Enables the ability of anyone to transfer their tokens. This can
415      * only be called by the token owner. Once enabled, it is not
416      * possible to disable transfers.
417      */
418     function enableTransfer() external onlyOwner {
419         transferEnabled = true;
420         approve(crowdSaleAddr, 0);
421         approve(adminAddr, 0);
422         crowdSaleAllowance = 0;
423         adminAllowance = 0;
424     }
425 
426     /**
427      * Overrides ERC20 transfer function with modifier that prevents the
428      * ability to transfer tokens until after transfers have been enabled.
429      */
430     function transfer(address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
431         return super.transfer(_to, _value);
432     }
433 
434     /**
435      * Overrides ERC20 transferFrom function with modifier that prevents the
436      * ability to transfer tokens until after transfers have been enabled.
437      */
438     function transferFrom(address _from, address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
439         bool result = super.transferFrom(_from, _to, _value);
440         if (result) {
441             if (msg.sender == crowdSaleAddr)
442                 crowdSaleAllowance = crowdSaleAllowance.sub(_value);
443             if (msg.sender == adminAddr)
444                 adminAllowance = adminAllowance.sub(_value);
445         }
446         return result;
447     }
448 
449     /**
450      * Overrides the burn function so that it cannot be called until after
451      * transfers have been enabled.
452      *
453      * @param _value    The amount of tokens to burn in mini-QSP
454      */
455     function burn(uint256 _value) public {
456         require(transferEnabled || msg.sender == owner);
457         require(balances[msg.sender] >= _value);
458         super.burn(_value);
459         Transfer(msg.sender, address(0x0), _value);
460     }
461 }