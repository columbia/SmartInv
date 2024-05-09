1 pragma solidity ^0.4.10;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 
33 }
34 
35 pragma solidity ^0.4.10;
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43 
44     address public owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50      * account.
51      */
52     function Ownable() public {
53         owner = msg.sender;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     /**
65      * @dev Allows the current owner to transfer control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function transferOwnership(address newOwner) onlyOwner public {
69         require(newOwner != address(0));
70         OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72     }
73 
74 }
75 
76 
77 pragma solidity ^0.4.21;
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic is Ownable {
85   function totalSupply() public view returns (uint256);
86   function balanceOf(address who) public view returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public view returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111   uint256 totalSupply_;
112   bool transferable = false;
113 
114   /**
115   * @dev total number of tokens in existence
116   */
117   function totalSupply() public view returns (uint256) {
118     return totalSupply_;
119   }
120 
121   modifier canTransfer() {
122       if (msg.sender != owner) {
123           require(transferable);
124       }
125       _;
126   }
127 
128   /**
129   * @dev transfer token for a specified address
130   * @param _to The address to transfer to.
131   * @param _value The amount to be transferred.
132   */
133   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
134     require(_to != address(0));
135     require(_value <= balances[msg.sender]);
136 
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     emit Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 /**
155  * @title Standard ERC20 token
156  *
157  * @dev Implementation of the basic standard token.
158  * @dev https://github.com/ethereum/EIPs/issues/20
159  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
160  */
161 contract StandardToken is ERC20, BasicToken {
162 
163   mapping (address => mapping (address => uint256)) internal allowed;
164 
165 
166   /**
167    * @dev Transfer tokens from one address to another
168    * @param _from address The address which you want to send tokens from
169    * @param _to address The address which you want to transfer to
170    * @param _value uint256 the amount of tokens to be transferred
171    */
172   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
173     require(_to != address(0));
174     require(_value <= balances[_from]);
175     require(_value <= allowed[_from][msg.sender]);
176 
177     balances[_from] = balances[_from].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180     emit Transfer(_from, _to, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186    *
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * @param _spender The address which will spend the funds.
192    * @param _value The amount of tokens to be spent.
193    */
194   function approve(address _spender, uint256 _value) public returns (bool) {
195     allowed[msg.sender][_spender] = _value;
196     emit Approval(msg.sender, _spender, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Function to check the amount of tokens that an owner allowed to a spender.
202    * @param _owner address The address which owns the funds.
203    * @param _spender address The address which will spend the funds.
204    * @return A uint256 specifying the amount of tokens still available for the spender.
205    */
206   function allowance(address _owner, address _spender) public view returns (uint256) {
207     return allowed[_owner][_spender];
208   }
209 
210   /**
211    * @dev Increase the amount of tokens that an owner allowed to a spender.
212    *
213    * approve should be called when allowed[_spender] == 0. To increment
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _addedValue The amount of tokens to increase the allowance by.
219    */
220   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
221     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   /**
227    * @dev Decrease the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
237     uint oldValue = allowed[msg.sender][_spender];
238     if (_subtractedValue > oldValue) {
239       allowed[msg.sender][_spender] = 0;
240     } else {
241       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242     }
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 }
247 
248 /**
249  * @title Burnable Token
250  * @dev Token that can be irreversibly burned (destroyed).
251  */
252 contract BurnableToken is BasicToken {
253 
254   event Burn(address indexed burner, uint256 value);
255 
256   /**
257    * @dev Burns a specific amount of tokens.
258    * @param _value The amount of token to be burned.
259    */
260   function burn(uint256 _value) public {
261     _burn(msg.sender, _value);
262   }
263 
264   function _burn(address _who, uint256 _value) internal {
265     require(_value <= balances[_who]);
266     // no need to require value <= totalSupply, since that would imply the
267     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
268 
269     balances[_who] = balances[_who].sub(_value);
270     totalSupply_ = totalSupply_.sub(_value);
271     emit Burn(_who, _value);
272     emit Transfer(_who, address(0), _value);
273   }
274 }
275 
276 
277 contract PapushaToken is BurnableToken {
278 
279     string public constant name = "Papusha Rocket Token";
280     string public constant symbol = "PRT";
281     uint32 public constant decimals = 18;
282     uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;
283 
284     function PapushaToken() public {
285         totalSupply_ = INITIAL_SUPPLY;
286         balances[msg.sender] = INITIAL_SUPPLY;
287         Transfer(address(0), msg.sender, INITIAL_SUPPLY);
288         transferable = false;
289     }
290 
291     modifier saleIsOn() {
292         require(transferable == false);
293         _;
294     }
295 
296     function refund(address _from, uint256 _value) onlyOwner saleIsOn public returns(bool) {
297         balances[_from] = balances[_from].sub(_value);
298         balances[owner] = balances[owner].add(_value);
299         Transfer(_from, owner, _value);
300         return true;
301     }
302 
303     function stopSale() onlyOwner saleIsOn public returns(bool) {
304         transferable = true;
305         return true;
306     }
307 
308 }
309 
310 pragma solidity ^0.4.21;
311 
312 contract Presale is Ownable {
313 
314     using SafeMath for uint;
315 
316     address public multisig;
317     uint256 public rate;
318     PapushaToken public token; //Token contract
319     Crowdsale public crowdsale; // Crowdsale contract
320     uint256 public hardcap;
321     uint256 public weiRaised;
322 
323     uint256 public saleSupply = 60000000 * 1 ether;
324 
325     function Presale(address _multisig) public {
326         multisig = _multisig;
327         rate = 250000000000000;
328         token = new PapushaToken();
329         hardcap = 5000 * 1 ether;
330     }
331 
332     modifier isUnderHardcap {
333         require(weiRaised < hardcap);
334         _;
335     }
336 
337     function startCrowdsale() onlyOwner public returns(bool) {
338         crowdsale = new Crowdsale(multisig, token, saleSupply);
339         token.transfer(address(crowdsale), token.balanceOf(this));
340         token.transferOwnership(address(crowdsale));
341         crowdsale.transferOwnership(owner);
342         return true;
343     }
344 
345     function createTokens() isUnderHardcap payable public {
346         uint256 weiAmount = msg.value;
347         require(weiAmount <= hardcap - weiRaised);
348         weiRaised = weiRaised.add(weiAmount);
349         uint256 tokens = weiAmount.div(rate);
350         require(saleSupply >= tokens);
351         saleSupply = saleSupply.sub(tokens);
352         token.transfer(msg.sender, tokens);
353         forwardFunds(msg.value);
354     }
355 
356     function forwardFunds(uint256 _value) private {
357         multisig.transfer(_value);
358     }
359 
360     function setPrice(uint256 _rate) onlyOwner public {
361         rate = _rate;
362     }
363 
364     function setMultisig(address _multisig) onlyOwner public {
365         multisig = _multisig;
366     }
367 
368     function() external payable {
369         createTokens();
370     }
371 
372 }
373 
374 pragma solidity ^0.4.10;
375 
376 contract Crowdsale is Ownable {
377 
378     using SafeMath for uint;
379 
380     address public multisig;
381     uint256 public rate;
382     PapushaToken public token; //Token contract
383     uint256 public saleSupply;
384     uint256 public saledSupply;
385     bool public saleStopped;
386     bool public sendToTeam;
387 
388     uint256 public RESERVED_SUPPLY = 40000000 * 1 ether;
389     uint256 public BONUS_SUPPLY = 20000000 * 1 ether;
390 
391     function Crowdsale(address _multisig, PapushaToken _token, uint _saleSupply) public {
392         multisig = _multisig;
393         token = _token;
394         saleSupply = _saleSupply;
395         saleStopped = false;
396         sendToTeam = false;
397     }
398 
399     modifier saleNoStopped() {
400         require(saleStopped == false);
401         _;
402     }
403 
404     function stopSale() onlyOwner public returns(bool) {
405         if (saleSupply > 0) {
406             token.burn(saleSupply);
407             saleSupply = 0;
408         }
409         saleStopped = true;
410         return token.stopSale();
411     }
412 
413     function createTokens() payable public {
414         if (saledSupply < BONUS_SUPPLY) {
415             rate = 360000000000000;
416         } else {
417             rate = 410000000000000;
418         }
419         uint256 tokens = msg.value.div(rate);
420         require(saleSupply >= tokens);
421         saleSupply = saleSupply.sub(tokens);
422         saledSupply = saledSupply.add(tokens);
423         token.transfer(msg.sender, tokens);
424         forwardFunds(msg.value);
425     }
426 
427     function adminSendTokens(address _to, uint256 _value) onlyOwner saleNoStopped public returns(bool) {
428         require(saleSupply >= _value);
429         saleSupply = saleSupply.sub(_value);
430         saledSupply = saledSupply.add(_value);
431         return token.transfer(_to, _value);
432     }
433 
434     function adminRefundTokens(address _from, uint256 _value) onlyOwner saleNoStopped public returns(bool) {
435         saleSupply = saleSupply.add(_value);
436         saledSupply = saledSupply.sub(_value);
437         return token.refund(_from, _value);
438     }
439 
440     function refundTeamTokens() onlyOwner public returns(bool) {
441         require(sendToTeam == false);
442         sendToTeam = true;
443         return token.transfer(msg.sender, RESERVED_SUPPLY);
444     }
445 
446     function forwardFunds(uint256 _value) private {
447         multisig.transfer(_value);
448     }
449 
450     function setPrice(uint256 _rate) onlyOwner public {
451         rate = _rate;
452     }
453 
454     function setMultisig(address _multisig) onlyOwner public {
455         multisig = _multisig;
456     }
457 
458     function() external payable {
459         createTokens();
460     }
461 
462 }