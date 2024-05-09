1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   uint256 totalSupply_;
72 
73   /**
74   * @dev total number of tokens in existence
75   */
76   function totalSupply() public view returns (uint256) {
77     return totalSupply_;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 /**
108  * @title Ownable
109  * @dev The Ownable contract has an owner address, and provides basic authorization control
110  * functions, this simplifies the implementation of "user permissions".
111  */
112 contract Ownable {
113   address public owner;
114 
115 
116   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
117 
118 
119   /**
120    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
121    * account.
122    */
123   function Ownable() public {
124     owner = msg.sender;
125   }
126 
127   /**
128    * @dev Throws if called by any account other than the owner.
129    */
130   modifier onlyOwner() {
131     require(msg.sender == owner);
132     _;
133   }
134 
135   /**
136    * @dev Allows the current owner to transfer control of the contract to a newOwner.
137    * @param newOwner The address to transfer ownership to.
138    */
139   function transferOwnership(address newOwner) public onlyOwner {
140     require(newOwner != address(0));
141     OwnershipTransferred(owner, newOwner);
142     owner = newOwner;
143   }
144 
145 }
146 
147 /**
148  * @title Burnable Token
149  * @dev Token that can be irreversibly burned (destroyed).
150  */
151 contract BurnableToken is BasicToken {
152 
153   event Burn(address indexed burner, uint256 value);
154 
155   /**
156    * @dev Burns a specific amount of tokens.
157    * @param _value The amount of token to be burned.
158    */
159   function burn(uint256 _value) public {
160     require(_value <= balances[msg.sender]);
161     // no need to require value <= totalSupply, since that would imply the
162     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
163 
164     address burner = msg.sender;
165     balances[burner] = balances[burner].sub(_value);
166     totalSupply_ = totalSupply_.sub(_value);
167     Burn(burner, _value);
168     Transfer(burner, address(0), _value);
169   }
170 }
171 
172 
173 
174 /**
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 is ERC20Basic {
179   function allowance(address owner, address spender) public view returns (uint256);
180   function transferFrom(address from, address to, uint256 value) public returns (bool);
181   function approve(address spender, uint256 value) public returns (bool);
182   event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 /**
186  * @title Standard ERC20 token
187  *
188  * @dev Implementation of the basic standard token.
189  * @dev https://github.com/ethereum/EIPs/issues/20
190  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
191  */
192 contract StandardToken is ERC20, BasicToken {
193 
194   mapping (address => mapping (address => uint256)) internal allowed;
195 
196 
197   /**
198    * @dev Transfer tokens from one address to another
199    * @param _from address The address which you want to send tokens from
200    * @param _to address The address which you want to transfer to
201    * @param _value uint256 the amount of tokens to be transferred
202    */
203   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
204     require(_to != address(0));
205     require(_value <= balances[_from]);
206     require(_value <= allowed[_from][msg.sender]);
207 
208     balances[_from] = balances[_from].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
211     Transfer(_from, _to, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217    *
218    * Beware that changing an allowance with this method brings the risk that someone may use both the old
219    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222    * @param _spender The address which will spend the funds.
223    * @param _value The amount of tokens to be spent.
224    */
225   function approve(address _spender, uint256 _value) public returns (bool) {
226     allowed[msg.sender][_spender] = _value;
227     Approval(msg.sender, _spender, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Function to check the amount of tokens that an owner allowed to a spender.
233    * @param _owner address The address which owns the funds.
234    * @param _spender address The address which will spend the funds.
235    * @return A uint256 specifying the amount of tokens still available for the spender.
236    */
237   function allowance(address _owner, address _spender) public view returns (uint256) {
238     return allowed[_owner][_spender];
239   }
240 
241   /**
242    * @dev Increase the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To increment
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _addedValue The amount of tokens to increase the allowance by.
250    */
251   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
252     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
253     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257   /**
258    * @dev Decrease the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To decrement
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _subtractedValue The amount of tokens to decrease the allowance by.
266    */
267   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
268     uint oldValue = allowed[msg.sender][_spender];
269     if (_subtractedValue > oldValue) {
270       allowed[msg.sender][_spender] = 0;
271     } else {
272       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
273     }
274     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278 }
279 
280 contract AMOCoin is StandardToken, BurnableToken, Ownable {
281     using SafeMath for uint256;
282 
283     string public constant symbol = "AMO";
284     string public constant name = "AMO Coin";
285     uint8 public constant decimals = 18;
286     uint256 public constant INITIAL_SUPPLY = 20000000000 * (10 ** uint256(decimals));
287     uint256 public constant TOKEN_SALE_ALLOWANCE = 10000000000 * (10 ** uint256(decimals));
288     uint256 public constant ADMIN_ALLOWANCE = INITIAL_SUPPLY - TOKEN_SALE_ALLOWANCE;
289 
290     // Address of token administrator
291     address public adminAddr;
292 
293     // Address of token sale contract
294     address public tokenSaleAddr;
295 
296     // Enable transfer after token sale is completed
297     bool public transferEnabled = false;
298 
299     // Accounts to be locked for certain period
300     mapping(address => uint256) private lockedAccounts;
301 
302     /*
303      *
304      * Permissions when transferEnabled is false :
305      *              ContractOwner    Admin    SaleContract    Others
306      * transfer            x           v            v           x
307      * transferFrom        x           v            v           x
308      *
309      * Permissions when transferEnabled is true :
310      *              ContractOwner    Admin    SaleContract    Others
311      * transfer            v           v            v           v
312      * transferFrom        v           v            v           v
313      *
314      */
315 
316     /*
317      * Check if token transfer is allowed
318      * Permission table above is result of this modifier
319      */
320     modifier onlyWhenTransferAllowed() {
321         require(transferEnabled == true
322             || msg.sender == adminAddr
323             || msg.sender == tokenSaleAddr);
324         _;
325     }
326 
327     /*
328      * Check if token sale address is not set
329      */
330     modifier onlyWhenTokenSaleAddrNotSet() {
331         require(tokenSaleAddr == address(0x0));
332         _;
333     }
334 
335     /*
336      * Check if token transfer destination is valid
337      */
338     modifier onlyValidDestination(address to) {
339         require(to != address(0x0)
340             && to != address(this)
341             && to != owner
342             && to != adminAddr
343             && to != tokenSaleAddr);
344         _;
345     }
346 
347     modifier onlyAllowedAmount(address from, uint256 amount) {
348         require(balances[from].sub(amount) >= lockedAccounts[from]);
349         _;
350     }
351     /*
352      * The constructor of AMOCoin contract
353      *
354      * @param _adminAddr: Address of token administrator
355      */
356     function AMOCoin(address _adminAddr) public {
357         totalSupply_ = INITIAL_SUPPLY;
358 
359         balances[msg.sender] = totalSupply_;
360         Transfer(address(0x0), msg.sender, totalSupply_);
361 
362         adminAddr = _adminAddr;
363         approve(adminAddr, ADMIN_ALLOWANCE);
364     }
365 
366     /*
367      * Set amount of token sale to approve allowance for sale contract
368      *
369      * @param _tokenSaleAddr: Address of sale contract
370      * @param _amountForSale: Amount of token for sale
371      */
372     function setTokenSaleAmount(address _tokenSaleAddr, uint256 amountForSale)
373         external
374         onlyOwner
375         onlyWhenTokenSaleAddrNotSet
376     {
377         require(!transferEnabled);
378 
379         uint256 amount = (amountForSale == 0) ? TOKEN_SALE_ALLOWANCE : amountForSale;
380         require(amount <= TOKEN_SALE_ALLOWANCE);
381 
382         approve(_tokenSaleAddr, amount);
383         tokenSaleAddr = _tokenSaleAddr;
384     }
385 
386     /*
387      * Set transferEnabled variable to true
388      */
389     function enableTransfer() external onlyOwner {
390         transferEnabled = true;
391         approve(tokenSaleAddr, 0);
392     }
393 
394     /*
395      * Set transferEnabled variable to false
396      */
397     function disableTransfer() external onlyOwner {
398         transferEnabled = false;
399     }
400 
401     /*
402      * Transfer token from message sender to another
403      *
404      * @param to: Destination address
405      * @param value: Amount of AMO token to transfer
406      */
407     function transfer(address to, uint256 value)
408         public
409         onlyWhenTransferAllowed
410         onlyValidDestination(to)
411         onlyAllowedAmount(msg.sender, value)
412         returns (bool)
413     {
414         return super.transfer(to, value);
415     }
416 
417     /*
418      * Transfer token from 'from' address to 'to' addreess
419      *
420      * @param from: Origin address
421      * @param to: Destination address
422      * @param value: Amount of AMO Coin to transfer
423      */
424     function transferFrom(address from, address to, uint256 value)
425         public
426         onlyWhenTransferAllowed
427         onlyValidDestination(to)
428         onlyAllowedAmount(from, value)
429         returns (bool)
430     {
431         return super.transferFrom(from, to, value);
432     }
433 
434     /*
435      * Burn token, only owner is allowed
436      *
437      * @param value: Amount of AMO Coin to burn
438      */
439     function burn(uint256 value) public onlyOwner {
440         require(transferEnabled);
441         super.burn(value);
442     }
443 
444     /*
445      * Disable transfering tokens more than allowed amount from certain account
446      *
447      * @param addr: Account to set allowed amount
448      * @param amount: Amount of tokens to allow
449      */
450     function lockAccount(address addr, uint256 amount)
451         external
452         onlyOwner
453         onlyValidDestination(addr)
454     {
455         require(amount > 0);
456         lockedAccounts[addr] = amount;
457     }
458 
459     /*
460      * Enable transfering tokens of locked account
461      *
462      * @param addr: Account to unlock
463      */
464 
465     function unlockAccount(address addr)
466         external
467         onlyOwner
468         onlyValidDestination(addr)
469     {
470         lockedAccounts[addr] = 0;
471     }
472 }