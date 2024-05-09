1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: contracts/PlayCoin.sol
258 
259 /**
260  * @title PlayCoin contract 
261  */
262 contract PlayCoin is StandardToken {
263     string public symbol;
264     string public name;
265     uint8 public decimals = 9;
266 
267     uint noOfTokens = 1000000000; // 1,000,000,000 (1B)
268 
269     // Address of playcoin vault (a PlayCoinMultiSigWallet contract)
270     // The vault will have all the playcoin issued and the operation
271     // on its token will be protected by multi signing.
272     // In addtion, vault can recall(transfer back) the reserved amount
273     // from some address.
274     address internal vault;
275 
276     // Address of playcoin owner (a PlayCoinMultiSigWallet contract)
277     // The owner can change admin and vault address, but the change operation
278     // will be protected by multi signing.
279     address internal owner;
280 
281     // Address of playcoin admin (a PlayCoinMultiSigWallet contract)
282     // The admin can change reserve. The reserve is the amount of token
283     // assigned to some address but not permitted to use.
284     // Once the signers of the admin agree with removing the reserve,
285     // they can change the reserve to zero to permit the user to use all reserved
286     // amount. So in effect, reservation will postpone the use of some tokens
287     // being used until all stakeholders agree with giving permission to use that
288     // token to the token owner.
289     // All admin operation will be protected by multi signing.
290     address internal admin;
291 
292     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
293     event VaultChanged(address indexed previousVault, address indexed newVault);
294     event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
295     event ReserveChanged(address indexed _address, uint amount);
296     event Recalled(address indexed from, uint amount);
297 
298     // for debugging
299     event MsgAndValue(string message, bytes32 value);
300 
301     /**
302      * @dev reserved number of tokens per each address
303      *
304      * To limit token transaction for some period by the admin or owner,
305      * each address' balance cannot become lower than this amount
306      *
307      */
308     mapping(address => uint) public reserves;
309 
310     /**
311        * @dev modifier to limit access to the owner only
312        */
313     modifier onlyOwner() {
314         require(msg.sender == owner);
315         _;
316     }
317 
318     /**
319        * @dev limit access to the vault only
320        */
321     modifier onlyVault() {
322         require(msg.sender == vault);
323         _;
324     }
325 
326     /**
327        * @dev limit access to the admin only
328        */
329     modifier onlyAdmin() {
330         require(msg.sender == admin);
331         _;
332     }
333 
334     /**
335        * @dev limit access to admin or vault
336        */
337     modifier onlyAdminOrVault() {
338         require(msg.sender == vault || msg.sender == admin);
339         _;
340     }
341 
342     /**
343        * @dev limit access to owner or vault
344        */
345     modifier onlyOwnerOrVault() {
346         require(msg.sender == owner || msg.sender == vault);
347         _;
348     }
349 
350     /**
351        * @dev limit access to owner or admin
352        */
353     modifier onlyAdminOrOwner() {
354         require(msg.sender == owner || msg.sender == admin);
355         _;
356     }
357 
358     /**
359        * @dev limit access to owner or admin or vault
360        */
361     modifier onlyAdminOrOwnerOrVault() {
362         require(msg.sender == owner || msg.sender == vault || msg.sender == admin);
363         _;
364     }
365 
366     /**
367      * @dev initialize QRC20(ERC20)
368      *
369      * all token will deposit into the vault
370      * later, the vault, owner will be multi sign contract to protect privileged operations
371      *
372      * @param _symbol token symbol
373      * @param _name   token name
374      * @param _owner  owner address
375      * @param _admin  admin address
376      * @param _vault  vault address
377      */
378     constructor (string _symbol, string _name, address _owner, address _admin, address _vault) public {
379         require(bytes(_symbol).length > 0);
380         require(bytes(_name).length > 0);
381 
382         totalSupply_ = noOfTokens * (10 ** uint(decimals));
383         // 1E9 tokens initially
384 
385         symbol = _symbol;
386         name = _name;
387         owner = _owner;
388         admin = _admin;
389         vault = _vault;
390 
391         balances[vault] = totalSupply_;
392         emit Transfer(address(0), vault, totalSupply_);
393     }
394 
395     /**
396      * @dev change the amount of reserved token
397      *    reserve should be less than or equal to the current token balance
398      *
399      *    Refer to the comment on the admin if you want to know more.
400      *
401      * @param _address the target address whose token will be frozen for future use
402      * @param _reserve  the amount of reserved token
403      *
404      */
405     function setReserve(address _address, uint _reserve) public onlyAdmin {
406         require(_reserve <= totalSupply_);
407         require(_address != address(0));
408 
409         reserves[_address] = _reserve;
410         emit ReserveChanged(_address, _reserve);
411     }
412 
413     /**
414      * @dev transfer token from sender to other
415      *         the result balance should be greater than or equal to the reserved token amount
416      */
417     function transfer(address _to, uint256 _value) public returns (bool) {
418         // check the reserve
419         require(balanceOf(msg.sender) - _value >= reserveOf(msg.sender));
420         return super.transfer(_to, _value);
421     }
422 
423     /**
424      * @dev change vault address
425      *    BEWARE! this withdraw all token from old vault and store it to the new vault
426      *            and new vault's allowed, reserve will be set to zero
427      * @param _newVault new vault address
428      */
429     function setVault(address _newVault) public onlyOwner {
430         require(_newVault != address(0));
431         require(_newVault != vault);
432 
433         address _oldVault = vault;
434 
435         // change vault address
436         vault = _newVault;
437         emit VaultChanged(_oldVault, _newVault);
438 
439         // adjust balance
440         uint _value = balances[_oldVault];
441         balances[_oldVault] = 0;
442         balances[_newVault] = balances[_newVault].add(_value);
443 
444         // vault cannot have any allowed or reserved amount!!!
445         allowed[_newVault][msg.sender] = 0;
446         reserves[_newVault] = 0;
447         emit Transfer(_oldVault, _newVault, _value);
448     }
449 
450     /**
451      * @dev change owner address
452      * @param _newOwner new owner address
453      */
454     function setOwner(address _newOwner) public onlyVault {
455         require(_newOwner != address(0));
456         require(_newOwner != owner);
457 
458         owner = _newOwner;
459         emit OwnerChanged(owner, _newOwner);
460     }
461 
462     /**
463      * @dev change admin address
464      * @param _newAdmin new admin address
465      */
466     function setAdmin(address _newAdmin) public onlyOwnerOrVault {
467         require(_newAdmin != address(0));
468         require(_newAdmin != admin);
469 
470         admin = _newAdmin;
471 
472         emit AdminChanged(admin, _newAdmin);
473     }
474 
475     /**
476      * @dev transfer a part of reserved amount to the vault
477      *
478      *    Refer to the comment on the vault if you want to know more.
479      *
480      * @param _from the address from which the reserved token will be taken
481      * @param _amount the amount of token to be taken
482      */
483     function recall(address _from, uint _amount) public onlyAdmin {
484         require(_from != address(0));
485         require(_amount > 0);
486 
487         uint currentReserve = reserveOf(_from);
488         uint currentBalance = balanceOf(_from);
489 
490         require(currentReserve >= _amount);
491         require(currentBalance >= _amount);
492 
493         uint newReserve = currentReserve - _amount;
494         reserves[_from] = newReserve;
495         emit ReserveChanged(_from, newReserve);
496 
497         // transfer token _from to vault
498         balances[_from] = balances[_from].sub(_amount);
499         balances[vault] = balances[vault].add(_amount);
500         emit Transfer(_from, vault, _amount);
501 
502         emit Recalled(_from, _amount);
503     }
504 
505     /**
506      * @dev Transfer tokens from one address to another
507      *
508      * The _from's PLY balance should be larger than the reserved amount(reserves[_from]) plus _value.
509      *
510      */
511     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
512         require(_value <= balances[_from].sub(reserves[_from]));
513         return super.transferFrom(_from, _to, _value);
514     }
515 
516     function getOwner() public view onlyAdminOrOwnerOrVault returns (address) {
517         return owner;
518     }
519 
520     function getVault() public view onlyAdminOrOwnerOrVault returns (address) {
521         return vault;
522     }
523 
524     function getAdmin() public view onlyAdminOrOwnerOrVault returns (address) {
525         return admin;
526     }
527 
528     function getOnePlayCoin() public view returns (uint) {
529         return (10 ** uint(decimals));
530     }
531 
532     function getMaxNumberOfTokens() public view returns (uint) {
533         return noOfTokens;
534     }
535 
536     /**
537      * @dev get the amount of reserved token
538      */
539     function reserveOf(address _address) public view returns (uint _reserve) {
540         return reserves[_address];
541     }
542 
543     /**
544      * @dev get the amount reserved token of the sender
545      */
546     function reserve() public view returns (uint _reserve) {
547         return reserves[msg.sender];
548     }
549 }