1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { 
4 
5     function receiveApproval(
6 
7         address _from, 
8 
9         uint256 _value,
10 
11         address _token, 
12 
13         bytes _extraData
14 
15     ) public; 
16 
17 }
18 
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract Ownable {
49   address public owner;
50 
51 
52   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   function Ownable() public {
60     owner = msg.sender;
61   }
62 
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     require(newOwner != address(0));
79     OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 
83 }
84 
85 contract Pausable is Ownable {
86   event Pause();
87   event Unpause();
88 
89   bool public paused = false;
90 
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is not paused.
94    */
95   modifier whenNotPaused() {
96     require(!paused);
97     _;
98   }
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is paused.
102    */
103   modifier whenPaused() {
104     require(paused);
105     _;
106   }
107 
108   /**
109    * @dev called by the owner to pause, triggers stopped state
110    */
111   function pause() onlyOwner whenNotPaused public {
112     paused = true;
113     Pause();
114   }
115 
116   /**
117    * @dev called by the owner to unpause, returns to normal state
118    */
119   function unpause() onlyOwner whenPaused public {
120     paused = false;
121     Unpause();
122   }
123 }
124 
125 contract ERC20Basic {
126   uint256 public totalSupply;
127   function balanceOf(address who) public view returns (uint256);
128   function transfer(address to, uint256 value) public returns (bool);
129   event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 contract BasicToken is ERC20Basic {
133   using SafeMath for uint256;
134 
135   mapping(address => uint256) balances;
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145 
146     // SafeMath.sub will throw if there is not enough balance.
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 contract BurnableToken is BasicToken {
165 
166     event Burn(address indexed burner, uint256 value);
167 
168     /**
169      * @dev Burns a specific amount of tokens.
170      * @param _value The amount of token to be burned.
171      */
172     function burn(uint256 _value) public {
173         require(_value <= balances[msg.sender]);
174         // no need to require value <= totalSupply, since that would imply the
175         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
176 
177         address burner = msg.sender;
178         balances[burner] = balances[burner].sub(_value);
179         totalSupply = totalSupply.sub(_value);
180         Burn(burner, _value);
181     }
182 }
183 
184 contract ERC20 is ERC20Basic {
185   function allowance(address owner, address spender) public view returns (uint256);
186   function transferFrom(address from, address to, uint256 value) public returns (bool);
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 contract StandardToken is ERC20, BasicToken {
192 
193   mapping (address => mapping (address => uint256)) internal allowed;
194 
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param _from address The address which you want to send tokens from
199    * @param _to address The address which you want to transfer to
200    * @param _value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204     require(_value <= balances[_from]);
205     require(_value <= allowed[_from][msg.sender]);
206 
207     balances[_from] = balances[_from].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210     Transfer(_from, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    *
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param _spender The address which will spend the funds.
222    * @param _value The amount of tokens to be spent.
223    */
224   function approve(address _spender, uint256 _value) public returns (bool) {
225     allowed[msg.sender][_spender] = _value;
226     Approval(msg.sender, _spender, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236   function allowance(address _owner, address _spender) public view returns (uint256) {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _addedValue The amount of tokens to increase the allowance by.
249    */
250   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
251     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
252     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256   /**
257    * @dev Decrease the amount of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To decrement
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _subtractedValue The amount of tokens to decrease the allowance by.
265    */
266   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
267     uint oldValue = allowed[msg.sender][_spender];
268     if (_subtractedValue > oldValue) {
269       allowed[msg.sender][_spender] = 0;
270     } else {
271       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
272     }
273     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277 }
278 
279 contract MintableToken is StandardToken, Ownable {
280   event Mint(address indexed to, uint256 amount);
281   event MintFinished();
282 
283   bool public mintingFinished = false;
284 
285 
286   modifier canMint() {
287     require(!mintingFinished);
288     _;
289   }
290 
291   /**
292    * @dev Function to mint tokens
293    * @param _to The address that will receive the minted tokens.
294    * @param _amount The amount of tokens to mint.
295    * @return A boolean that indicates if the operation was successful.
296    */
297   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
298     totalSupply = totalSupply.add(_amount);
299     balances[_to] = balances[_to].add(_amount);
300     Mint(_to, _amount);
301     Transfer(address(0), _to, _amount);
302     return true;
303   }
304 
305   /**
306    * @dev Function to stop minting new tokens.
307    * @return True if the operation was successful.
308    */
309   function finishMinting() onlyOwner canMint public returns (bool) {
310     mintingFinished = true;
311     MintFinished();
312     return true;
313   }
314 }
315 
316 contract PausableToken is StandardToken, Pausable {
317 
318   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
319     return super.transfer(_to, _value);
320   }
321 
322   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
323     return super.transferFrom(_from, _to, _value);
324   }
325 
326   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
327     return super.approve(_spender, _value);
328   }
329 
330   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
331     return super.increaseApproval(_spender, _addedValue);
332   }
333 
334   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
335     return super.decreaseApproval(_spender, _subtractedValue);
336   }
337 }
338 
339 contract DRCToken is BurnableToken, MintableToken, PausableToken {    
340 
341     string public name = 'DRC Token';
342 
343     string public symbol = 'DRC';
344 
345     uint8 public decimals = 18;
346 
347     uint256 public INITIAL_SUPPLY = 1000000000000000000000000000;
348 
349     // add map for recording the accounts that will not be allowed to transfer tokens
350     mapping (address => bool) public frozenAccount;
351     event FrozenFunds(address _target, bool _frozen);
352 
353     /**
354      * contruct the token by total amount 
355      *
356      * initial balance is set. 
357      */
358     function DRCToken() public {
359         totalSupply = INITIAL_SUPPLY;
360         balances[msg.sender] = totalSupply;
361     }
362     
363     /**
364      * freeze the account's balance 
365      *
366      * by default all the accounts will not be frozen until set freeze value as true. 
367      */
368     function freezeAccount(address _target, bool _freeze) onlyOwner public {
369         frozenAccount[_target] = _freeze;
370         FrozenFunds(_target, _freeze);
371     }
372 
373   /**
374    * @dev transfer token for a specified address with froze status checking
375    * @param _to The address to transfer to.
376    * @param _value The amount to be transferred.
377    */
378   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
379     require(!frozenAccount[msg.sender]);
380     return super.transfer(_to, _value);
381   }
382   
383   /**
384    * @dev Transfer tokens from one address to another with checking the frozen status
385    * @param _from address The address which you want to send tokens from
386    * @param _to address The address which you want to transfer to
387    * @param _value uint256 the amount of tokens to be transferred
388    */
389   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
390     require(!frozenAccount[_from]);
391     return super.transferFrom(_from, _to, _value);
392   }
393 
394   /**
395    * @dev transfer token for a specified address with froze status checking
396    * @param _toMulti The addresses to transfer to.
397    * @param _values The array of the amount to be transferred.
398    */
399   function transferMultiAddress(address[] _toMulti, uint256[] _values) public whenNotPaused returns (bool) {
400     require(!frozenAccount[msg.sender]);
401     assert(_toMulti.length == _values.length);
402 
403     uint256 i = 0;
404     while ( i < _toMulti.length) {
405         require(_toMulti[i] != address(0));
406         require(_values[i] <= balances[msg.sender]);
407 
408         // SafeMath.sub will throw if there is not enough balance.
409         balances[msg.sender] = balances[msg.sender].sub(_values[i]);
410         balances[_toMulti[i]] = balances[_toMulti[i]].add(_values[i]);
411         Transfer(msg.sender, _toMulti[i], _values[i]);
412 
413         i = i.add(1);
414     }
415 
416     return true;
417   }
418 
419   /**
420    * @dev Transfer tokens from one address to another with checking the frozen status
421    * @param _from address The address which you want to send tokens from
422    * @param _toMulti address[] The addresses which you want to transfer to in boundle
423    * @param _values uint256[] the array of amount of tokens to be transferred
424    */
425   function transferMultiAddressFrom(address _from, address[] _toMulti, uint256[] _values) public whenNotPaused returns (bool) {
426     require(!frozenAccount[_from]);
427     assert(_toMulti.length == _values.length);
428     
429     uint256 i = 0;
430     while ( i < _toMulti.length) {
431         require(_toMulti[i] != address(0));
432         require(_values[i] <= balances[_from]);
433         require(_values[i] <= allowed[_from][msg.sender]);
434 
435         // SafeMath.sub will throw if there is not enough balance.
436         balances[_from] = balances[_from].sub(_values[i]);
437         balances[_toMulti[i]] = balances[_toMulti[i]].add(_values[i]);
438         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_values[i]);
439         Transfer(_from, _toMulti[i], _values[i]);
440 
441         i = i.add(1);
442     }
443 
444     return true;
445   }
446   
447     /**
448      * @dev Burns a specific amount of tokens.
449      * @param _value The amount of token to be burned.
450      */
451     function burn(uint256 _value) whenNotPaused public {
452         super.burn(_value);
453     }
454 
455     /**
456      * Destroy tokens from other account
457      *
458      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
459      *
460      * @param _from the address of the sender
461      * @param _value the amount of money to burn
462      */
463     function burnFrom(address _from, uint256 _value) public whenNotPaused returns (bool success) {
464         require(balances[_from] >= _value);                // Check if the targeted balance is enough
465         require(_value <= allowed[_from][msg.sender]);    // Check allowance
466         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
467         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
468         totalSupply = totalSupply.sub(_value);
469         Burn(_from, _value);
470         return true;
471     }
472 
473   /**
474    * @dev Function to mint tokens
475    * @param _to The address that will receive the minted tokens.
476    * @param _amount The amount of tokens to mint.
477    * @return A boolean that indicates if the operation was successful.
478    */
479   function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
480       return super.mint(_to, _amount);
481   }
482 
483   /**
484    * @dev Function to stop minting new tokens.
485    * @return True if the operation was successful.
486    */
487   function finishMinting() onlyOwner canMint whenNotPaused public returns (bool) {
488       return super.finishMinting();
489   }
490 
491 
492     /**
493 
494      * Set allowance for other address and notify
495 
496      *
497 
498      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
499 
500      *
501 
502      * @param _spender The address authorized to spend
503 
504      * @param _value the max amount they can spend
505 
506      * @param _extraData some extra information to send to the approved contract
507 
508      */
509 
510     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public whenNotPaused returns (bool success) {
511 
512         tokenRecipient spender = tokenRecipient(_spender);
513 
514         if (approve(_spender, _value)) {
515 
516             spender.receiveApproval(msg.sender, _value, this, _extraData);
517 
518             return true;
519 
520         }
521 
522     }
523 
524 }