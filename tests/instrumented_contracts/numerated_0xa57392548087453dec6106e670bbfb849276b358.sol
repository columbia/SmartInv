1 pragma solidity ^0.4.19;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 // File: contracts/tokens/AirDropToken.sol
265 
266 contract AirDropToken is StandardToken, Ownable {
267 
268     function drop(address[] _participants, uint _value) public onlyOwner {
269         require(_participants.length > 0);
270         require(_value > 0);
271 
272         uint commonValue = _value * _participants.length;
273 
274         require(commonValue <= balances[msg.sender]);
275 
276         // SafeMath.sub will throw if there is not enough balance.
277         balances[msg.sender] = balances[msg.sender].sub(commonValue);
278 
279         for(uint i = 0; i < _participants.length; i++) {
280             address participant = _participants[i];
281             require(participant != address(0));
282             balances[participant] = balances[participant].add(_value);
283             Transfer(msg.sender, participant, _value);
284         }
285     }
286 }
287 
288 // File: contracts/tokens/TransferCommissionToken.sol
289 
290 contract TransferCommissionToken is StandardToken, Ownable  {
291     event FeeCollected(address indexed from, address indexed to, uint256 value);
292     event CommissionUpdated(uint256 newCommission);
293 
294     uint constant public MAX_WHITELISTED_COUNT = 5;
295 
296     uint constant public PERCENT_DELIMITER = 10 ** 3;
297 
298     uint public commission;
299     address public collector;
300     address[] public whitelist;
301 
302     function TransferCommissionToken(uint _commission) public {
303         _updateCommission(_commission);
304     }
305 
306     function setCollector(address _collector) external onlyOwner {
307         require(_collector != address(0));
308         collector = _collector;
309     }
310 
311     function setCommission(uint _commission) external onlyOwner {
312         _updateCommission(_commission);
313     }
314 
315     function resetCommission() external onlyOwner {
316         commission = 0;
317         CommissionUpdated(0);
318     }
319 
320     function _updateCommission(uint _commission) internal {
321         require(_commission > 0);
322 
323         commission = _commission;
324         CommissionUpdated(commission);
325     }
326 
327     function setWhitelist(address[] _whitelist) external onlyOwner {
328         require(_whitelist.length > 0);
329         require(_whitelist.length <= MAX_WHITELISTED_COUNT);
330 
331         whitelist = _whitelist;
332     }
333 
334     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
335         super.transferFrom(_from, _to, _value);
336         _collectFee(_from, _to, _value);
337         return true;
338     }
339 
340     function transfer(address _to, uint256 _value) public returns (bool) {
341         super.transfer(_to, _value);
342         _collectFee(msg.sender, _to, _value);
343         return true;
344     }
345 
346     function _collectFee(address _from, address _to, uint _value) internal {
347         if(collector == address(0)) return;
348         if(whitelist.length > 0 && (_contains(whitelist, _from) || _contains(whitelist, _to))) return;
349 
350         uint feeValue = _value.mul(commission).div(PERCENT_DELIMITER).div(100);
351 
352         require(feeValue <= balances[_from]);
353 
354         balances[_from] = balances[_from].sub(feeValue);
355         balances[collector] = balances[collector].add(feeValue);
356         FeeCollected(_from, collector, feeValue);
357     }
358 
359     function _contains(address[] _list, address _item) internal returns (bool) {
360         for(uint i = 0; i < _list.length; i++){
361             if(_list[i] == _item) return true;
362         }
363 
364         return false;
365     }
366 }
367 
368 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
369 
370 /**
371  * @title Burnable Token
372  * @dev Token that can be irreversibly burned (destroyed).
373  */
374 contract BurnableToken is BasicToken {
375 
376   event Burn(address indexed burner, uint256 value);
377 
378   /**
379    * @dev Burns a specific amount of tokens.
380    * @param _value The amount of token to be burned.
381    */
382   function burn(uint256 _value) public {
383     require(_value <= balances[msg.sender]);
384     // no need to require value <= totalSupply, since that would imply the
385     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
386 
387     address burner = msg.sender;
388     balances[burner] = balances[burner].sub(_value);
389     totalSupply_ = totalSupply_.sub(_value);
390     Burn(burner, _value);
391   }
392 }
393 
394 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
395 
396 contract DetailedERC20 is ERC20 {
397   string public name;
398   string public symbol;
399   uint8 public decimals;
400 
401   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
402     name = _name;
403     symbol = _symbol;
404     decimals = _decimals;
405   }
406 }
407 
408 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
409 
410 /**
411  * @title Mintable token
412  * @dev Simple ERC20 Token example, with mintable token creation
413  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
414  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
415  */
416 contract MintableToken is StandardToken, Ownable {
417   event Mint(address indexed to, uint256 amount);
418   event MintFinished();
419 
420   bool public mintingFinished = false;
421 
422 
423   modifier canMint() {
424     require(!mintingFinished);
425     _;
426   }
427 
428   /**
429    * @dev Function to mint tokens
430    * @param _to The address that will receive the minted tokens.
431    * @param _amount The amount of tokens to mint.
432    * @return A boolean that indicates if the operation was successful.
433    */
434   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
435     totalSupply_ = totalSupply_.add(_amount);
436     balances[_to] = balances[_to].add(_amount);
437     Mint(_to, _amount);
438     Transfer(address(0), _to, _amount);
439     return true;
440   }
441 
442   /**
443    * @dev Function to stop minting new tokens.
444    * @return True if the operation was successful.
445    */
446   function finishMinting() onlyOwner canMint public returns (bool) {
447     mintingFinished = true;
448     MintFinished();
449     return true;
450   }
451 }
452 
453 // File: contracts/tokens/CoreToken.sol
454 
455 contract CoreToken is DetailedERC20, TransferCommissionToken, AirDropToken, MintableToken, BurnableToken {
456     /**
457      * @dev Constructor that gives msg.sender all of existing tokens.
458      */
459     function CoreToken(uint _commission, string _name, string _symbol, uint8 _decimals)
460     DetailedERC20(_name, _symbol, _decimals)
461     TransferCommissionToken(_commission)
462     public { }
463 }