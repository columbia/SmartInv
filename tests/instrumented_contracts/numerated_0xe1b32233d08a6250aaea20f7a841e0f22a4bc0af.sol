1 pragma solidity ^0.4.21;
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
64 }
65 
66 
67 
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() onlyOwner whenNotPaused public {
100     paused = true;
101     Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() onlyOwner whenPaused public {
108     paused = false;
109     Unpause();
110   }
111 }
112 
113 
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   uint256 public totalSupply;
122   function balanceOf(address who) public constant returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 
128 
129 
130 
131 /**
132  * @title ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/20
134  */
135 contract ERC20 is ERC20Basic {
136   function allowance(address owner, address spender) public constant returns (uint256);
137   function transferFrom(address from, address to, uint256 value) public returns (bool);
138   function approve(address spender, uint256 value) public returns (bool);
139   event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 
143 
144 
145 
146 /**
147  * @title Basic token
148  * @dev Basic version of StandardToken, with no allowances.
149  */
150 contract BasicToken is ERC20Basic {
151   using SafeMath for uint256;
152 
153   mapping(address => uint256) balances;
154 
155 
156 
157   /**
158   * @dev transfer token for a specified address
159   * @param _to The address to transfer to.
160   * @param _value The amount to be transferred.
161   */
162   function transfer(address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164 
165     // SafeMath.sub will throw if there is not enough balance.
166     balances[msg.sender] = balances[msg.sender].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     Transfer(msg.sender, _to, _value);
169     return true;
170   }
171 
172   /**
173   * @dev Gets the balance of the specified address.
174   * @param _owner The address to query the the balance of.
175   * @return An uint256 representing the amount owned by the passed address.
176   */
177   function balanceOf(address _owner) public constant returns (uint256 balance) {
178     return balances[_owner];
179   }
180 
181 }
182 
183 
184 
185 
186 
187 /**
188  * @title Standard ERC20 token
189  *
190  * @dev Implementation of the basic standard token.
191  * @dev https://github.com/ethereum/EIPs/issues/20
192  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
193  */
194 contract StandardToken is ERC20, BasicToken {
195 
196   mapping (address => mapping (address => uint256)) allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
206     require(_to != address(0));
207 
208     uint256 _allowance = allowed[_from][msg.sender];
209 
210     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
211     // require (_value <= _allowance);
212 
213     balances[_from] = balances[_from].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     allowed[_from][msg.sender] = _allowance.sub(_value);
216     Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    *
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _value The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
243     return allowed[_owner][_spender];
244   }
245 
246   /**
247    * approve should be called when allowed[_spender] == 0. To increment
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    */
252   function increaseApproval (address _spender, uint _addedValue)
253     returns (bool success) {
254     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
255     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259   function decreaseApproval (address _spender, uint _subtractedValue)
260     returns (bool success) {
261     uint oldValue = allowed[msg.sender][_spender];
262     if (_subtractedValue > oldValue) {
263       allowed[msg.sender][_spender] = 0;
264     } else {
265       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266     }
267     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271 }
272 
273 
274 
275 /**
276  * @title Burnable Token
277  * @dev Token that can be irreversibly burned (destroyed).
278  */
279 contract BurnableToken is StandardToken {
280 
281     event Burn(address indexed burner, uint256 value);
282 
283     /**
284      * @dev Burns a specific amount of tokens.
285      * @param _value The amount of token to be burned.
286      */
287     function burn(uint256 _value) public {
288         require(_value > 0);
289 
290         address burner = msg.sender;
291         balances[burner] = balances[burner].sub(_value);
292         totalSupply = totalSupply.sub(_value);
293         Burn(burner, _value);
294     }
295 }
296 
297 // Coalichain (https://coalichain.io)
298 
299 
300 
301 /**
302  * The Coalichain token (ZUZ) has a fixed supply and restricts the ability
303  * to transfer tokens until after ICO (owner calls the shots wrt to that)
304  *
305  * Owner may let a token sale contract transfer ZUZ to buyers during ICO by set the amount through setCrowdsale method
306  */
307 contract CoalichainToken is StandardToken, BurnableToken, Ownable {
308 
309     // Constants
310     string  public constant name = "Coalichain Token";
311     string  public constant symbol = "ZUZ";
312     uint8   public constant decimals = 6;
313     uint256 public constant INITIAL_SUPPLY      = 770000000 * (10 ** uint256(decimals));
314     uint256 public constant CROWDSALE_ALLOWANCE = 462000000 * (10 ** uint256(decimals));
315     uint256 public constant ADMIN_ALLOWANCE     = 308000000 * (10 ** uint256(decimals));
316     
317     // Properties
318     uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
319     uint256 public adminAllowance;          // the number of tokens available for the administrator
320     address public crowdSaleAddr = 0xd742955953f5c510f21a65c90ab87823d0b12683;     // the address of a crowdsale contract set to sale ZUZ
321     address public adminAddr = 0x3aE26de0cc38B76eF670D9Bb085AafD3Ed2d487d;         // the address of the token admin account
322     bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
323 
324     // Modifiers
325     modifier onlyWhenTransferEnabled() {
326         if (!transferEnabled) {
327             require(msg.sender == adminAddr || msg.sender == crowdSaleAddr);
328         }
329         _;
330     }
331 
332     /**
333      * The listed addresses are not valid recipients of tokens.
334      *
335      * 0x0           - the zero address is not valid
336      * this          - the contract itself should not receive tokens
337      * owner         - the owner has all the initial tokens, but cannot receive any back
338      * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
339      * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
340      */
341     modifier validDestination(address _to) {
342         require(_to != address(0x0));
343         require(_to != address(this));
344         require(_to != owner);
345         require(_to != address(adminAddr));
346         require(_to != address(crowdSaleAddr));
347         _;
348     }
349 
350     /**
351      * Constructor - instantiates token supply and allocates balanace of
352      * to the owner (msg.sender).
353      */
354     function CoalichainToken() {
355         // the owner is a custodian of tokens that can
356         // give an allowance of tokens for crowdsales
357         // or to the admin, but cannot itself transfer
358         // tokens; hence, this requirement
359         //require(msg.sender != _admin);                
360 
361         totalSupply = INITIAL_SUPPLY;
362         crowdSaleAllowance = CROWDSALE_ALLOWANCE;
363         adminAllowance = ADMIN_ALLOWANCE;
364 
365         // mint all tokens
366         balances[msg.sender] = totalSupply;
367         Transfer(address(0x0), msg.sender, totalSupply);
368 
369         //adminAddr = owner;                            
370         approve(adminAddr, adminAllowance);
371     }
372 
373     /**
374      * Associates this token with a current crowdsale, giving the crowdsale
375      * an allowance of tokens from the crowdsale supply. This gives the
376      * crowdsale the ability to call transferFrom to transfer tokens to
377      * whomever has purchased them.
378      *
379      * Note that if _amountForSale is 0, then it is assumed that the full
380      * remaining crowdsale supply is made available to the crowdsale.
381      *
382      * @param _crowdSaleAddr The address of a crowdsale contract that will sell this token
383      * @param _amountForSale The supply of tokens provided to the crowdsale
384      */
385     function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
386         require(!transferEnabled);
387         require(_amountForSale <= crowdSaleAllowance);
388 
389         // if 0, then full available crowdsale supply is assumed
390         uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;
391 
392         // Clear allowance of old, and set allowance of new
393         approve(crowdSaleAddr, 0);
394         approve(_crowdSaleAddr, amount);
395 
396         crowdSaleAddr = _crowdSaleAddr;
397     }
398 
399     /**
400      * Enables the ability of anyone to transfer their tokens. This can
401      * only be called by the token owner. Once enabled, it is not
402      * possible to disable transfers.
403      */
404     function enableTransfer() external onlyOwner {
405         transferEnabled = true;
406         approve(crowdSaleAddr, 0);
407         approve(adminAddr, 0);
408         crowdSaleAllowance = 0;
409         adminAllowance = 0;
410     }
411 
412     /**
413      * Overrides ERC20 transfer function with modifier that prevents the
414      * ability to transfer tokens until after transfers have been enabled.
415      */
416     function transfer(address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
417         return super.transfer(_to, _value);
418     }
419 
420     /**
421      * Overrides ERC20 transferFrom function with modifier that prevents the
422      * ability to transfer tokens until after transfers have been enabled.
423      */
424     function transferFrom(address _from, address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
425         bool result = super.transferFrom(_from, _to, _value);
426         if (result) {
427             if (msg.sender == crowdSaleAddr)
428                 crowdSaleAllowance = crowdSaleAllowance.sub(_value);
429             if (msg.sender == adminAddr)
430                 adminAllowance = adminAllowance.sub(_value);
431         }
432         return result;
433     }
434 
435     /**
436      * Overrides the burn function so that it cannot be called until after
437      * transfers have been enabled.
438      *
439      * @param _value    The amount of tokens to burn in ZUZ
440      */
441     function burn(uint256 _value) public {
442         require(transferEnabled || msg.sender == owner);
443         require(balances[msg.sender] >= _value);
444         super.burn(_value);
445         Transfer(msg.sender, address(0x0), _value);
446     }
447 }