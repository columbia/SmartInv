1 pragma solidity ^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       throw;
50     }
51   }
52 }
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control 
58  * functions, this simplifies the implementation of "user permissions". 
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   /** 
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   function Ownable() {
69     owner = msg.sender;
70   }
71 
72 
73   /**
74    * @dev Throws if called by any account other than the owner. 
75    */
76   modifier onlyOwner() {
77     if (msg.sender != owner) {
78       throw;
79     }
80     _;
81   }
82 
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to. 
87    */
88   function transferOwnership(address newOwner) onlyOwner {
89     if (newOwner != address(0)) {
90       owner = newOwner;
91     }
92   }
93 
94 }
95 
96 /**
97  * @title Pausable
98  * @dev Base contract which allows children to implement an emergency stop mechanism.
99  */
100 contract Pausable is Ownable {
101   event Pause();
102   event Unpause();
103 
104   bool public paused = false;
105 
106 
107   /**
108    * @dev modifier to allow actions only when the contract IS paused
109    */
110   modifier whenNotPaused() {
111     if (paused) throw;
112     _;
113   }
114 
115   /**
116    * @dev modifier to allow actions only when the contract IS NOT paused
117    */
118   modifier whenPaused {
119     if (!paused) throw;
120     _;
121   }
122 
123   /**
124    * @dev called by the owner to pause, triggers stopped state
125    */
126   function pause() onlyOwner whenNotPaused returns (bool) {
127     paused = true;
128     Pause();
129     return true;
130   }
131 
132   /**
133    * @dev called by the owner to unpause, returns to normal state
134    */
135   function unpause() onlyOwner whenPaused returns (bool) {
136     paused = false;
137     Unpause();
138     return true;
139   }
140 }
141 
142 /**
143  * @title ERC20Basic
144  * @dev Simpler version of ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 contract ERC20Basic {
148   uint public _totalSupply;
149   function totalSupply() constant returns (uint);
150   function balanceOf(address who) constant returns (uint);
151   function transfer(address to, uint value);
152   event Transfer(address indexed from, address indexed to, uint value);
153 }
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) constant returns (uint);
161   function transferFrom(address from, address to, uint value);
162   function approve(address spender, uint value);
163   event Approval(address indexed owner, address indexed spender, uint value);
164 }
165 
166 /**
167  * @title Basic token
168  * @dev Basic version of StandardToken, with no allowances.
169  */
170 contract BasicToken is Ownable, ERC20Basic {
171   using SafeMath for uint;
172 
173   mapping(address => uint) balances;
174 
175   // additional variables for use if transaction fees ever became necessary
176   uint public basisPointsRate = 0;
177   uint public maximumFee = 0;
178   uint public minimumFee = 0;
179 
180   /**
181    * @dev Fix for the ERC20 short address attack.
182    */
183   modifier onlyPayloadSize(uint size) {
184      if(msg.data.length < size + 4) {
185        throw;
186      }
187      _;
188   }
189 
190   /**
191   * @dev transfer token for a specified address
192   * @param _to The address to transfer to.
193   * @param _value The amount to be transferred.
194   */
195   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
196     uint fee = (_value.mul(basisPointsRate)).div(100);
197     if (fee > maximumFee) {
198       fee = maximumFee;
199     }
200     
201     if(basisPointsRate > 0)
202     {
203         if (fee < minimumFee) {
204           fee = minimumFee;
205         }
206     }
207     uint sendAmount = _value.sub(fee);
208     balances[msg.sender] = balances[msg.sender].sub(_value);
209     balances[_to] = balances[_to].add(sendAmount);
210     balances[owner] = balances[owner].add(fee);
211     Transfer(msg.sender, _to, sendAmount);
212     Transfer(msg.sender, owner, fee);
213   }
214 
215   /**
216   * @dev Gets the balance of the specified address.
217   * @param _owner The address to query the the balance of.
218   * @return An uint representing the amount owned by the passed address.
219   */
220   function balanceOf(address _owner) constant returns (uint balance) {
221     return balances[_owner];
222   }
223 
224 }
225 
226 
227 /**
228  * @title Standard ERC20 token
229  *
230  * @dev Implementation of the basic standard token.
231  * @dev https://github.com/ethereum/EIPs/issues/20
232  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
233  */
234 contract StandardToken is BasicToken, ERC20 {
235 
236   mapping (address => mapping (address => uint)) allowed;
237 
238   uint constant MAX_UINT = 2**256 - 1;
239 
240   /**
241    * @dev Transfer tokens from one address to another
242    * @param _from address The address which you want to send tokens from
243    * @param _to address The address which you want to transfer to
244    * @param _value uint the amount of tokens to be transferred
245    */
246   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
247     var _allowance = allowed[_from][msg.sender];
248 
249     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
250     // if (_value > _allowance) throw;
251 
252     uint fee = (_value.mul(basisPointsRate)).div(100);
253     if (fee > maximumFee) {
254       fee = maximumFee;
255     }
256     
257     if(basisPointsRate > 0)
258     {
259         if (fee < minimumFee) {
260           fee = minimumFee;
261         }
262     }
263     
264     uint sendAmount = _value.sub(fee);
265 
266     balances[_to] = balances[_to].add(sendAmount);
267     balances[owner] = balances[owner].add(fee);
268     balances[_from] = balances[_from].sub(_value);
269     if (_allowance < MAX_UINT) {
270       allowed[_from][msg.sender] = _allowance.sub(_value);
271     }
272     Transfer(_from, _to, sendAmount);
273     Transfer(_from, owner, fee);
274   }
275 
276   /**
277    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
278    * @param _spender The address which will spend the funds.
279    * @param _value The amount of tokens to be spent.
280    */
281   function approve(address _spender, uint _value) onlyPayloadSize(2 * 32) {
282 
283     // To change the approve amount you first have to reduce the addresses`
284     //  allowance to zero by calling `approve(_spender, 0)` if it is not
285     //  already 0 to mitigate the race condition described here:
286     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
288 
289     allowed[msg.sender][_spender] = _value;
290     Approval(msg.sender, _spender, _value);
291   }
292 
293   /**
294    * @dev Function to check the amount of tokens than an owner allowed to a spender.
295    * @param _owner address The address which owns the funds.
296    * @param _spender address The address which will spend the funds.
297    * @return A uint specifying the amount of tokens still available for the spender.
298    */
299   function allowance(address _owner, address _spender) constant returns (uint remaining) {
300     return allowed[_owner][_spender];
301   }
302 
303 }
304 
305 contract UpgradedStandardToken is StandardToken{
306         // those methods are called by the legacy contract
307         // and they must ensure msg.sender to be the contract address
308         function transferByLegacy(address from, address to, uint value);
309         function transferFromByLegacy(address sender, address from, address spender, uint value);
310         function approveByLegacy(address from, address spender, uint value);
311 }
312  
313 /// VNDC Token Contract - vndc.io
314 
315 contract VNDCToken is Pausable, StandardToken {
316 
317   string public name;
318   string public symbol;
319   uint public decimals;
320   address public upgradedAddress;
321   bool public deprecated;
322   mapping (address => bool) public isBlackListed;
323    
324   
325   //  The contract can be initialized with a number of tokens
326   //  All the tokens are deposited to the owner address
327   //
328   // @param _balance Initial supply of the contract
329   // @param _name Token Name
330   // @param _symbol Token symbol
331   // @param _decimals Token decimals
332   function VNDCToken(){
333       _totalSupply = 100000000000 * 10**uint(decimals);
334       name = "VNDC";
335       symbol = "VNDC";
336       balances[owner] = 100000000000 * 10**uint(decimals);
337       deprecated = false;
338       
339   }
340 
341   // Forward ERC20 methods to upgraded contract if this one is deprecated
342   function transfer(address _to, uint _value) whenNotPaused   {
343       
344         require(!isBlackListed[_to]);
345         require(!isBlackListed[msg.sender]);
346         if (deprecated) {
347           return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
348         } else {
349           return super.transfer(_to, _value);
350         }
351        
352      
353   }
354 
355   // Forward ERC20 methods to upgraded contract if this one is deprecated
356   function transferFrom(address _from, address _to, uint _value) whenNotPaused   {
357     
358         require(!isBlackListed[_from]);
359         require(!isBlackListed[_to]);
360         require(!isBlackListed[msg.sender]);
361 
362         if (deprecated) {
363           return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
364         } else {
365           return super.transferFrom(_from, _to, _value);
366         }
367         
368        
369   }
370 
371   // Forward ERC20 methods to upgraded contract if this one is deprecated
372   function balanceOf(address who) constant returns (uint){
373     if (deprecated) {
374       return UpgradedStandardToken(upgradedAddress).balanceOf(who);
375     } else {
376       return super.balanceOf(who);
377     }
378   }
379 
380   // Forward ERC20 methods to upgraded contract if this one is deprecated
381   function approve(address _spender, uint _value) onlyPayloadSize(2 * 32) {
382       
383     if (deprecated) {
384       return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
385     } else {
386       return super.approve(_spender, _value);
387     }
388   }
389 
390   // Forward ERC20 methods to upgraded contract if this one is deprecated
391   function allowance(address _owner, address _spender) constant returns (uint remaining) {
392 
393     if (deprecated) {
394       return StandardToken(upgradedAddress).allowance(_owner, _spender);
395     } else {
396       return super.allowance(_owner, _spender);
397     }
398   }
399 
400   // deprecate current contract in favour of a new one
401   function deprecate(address _upgradedAddress) onlyOwner {
402     deprecated = true;
403     upgradedAddress = _upgradedAddress;
404     Deprecate(_upgradedAddress);
405   }
406 
407   // deprecate current contract if favour of a new one
408   function totalSupply() constant returns (uint){
409     if (deprecated) {
410       return StandardToken(upgradedAddress).totalSupply();
411     } else {
412       return _totalSupply;
413     }
414   }
415 
416   // Issue a new amount of tokens
417   // these tokens are deposited into the owner address
418   //
419   // @param _amount Number of tokens to be issued
420   function issue(uint amount) onlyOwner {
421     if (_totalSupply + amount < _totalSupply) throw;
422     if (balances[owner] + amount < balances[owner]) throw;
423 
424     balances[owner] += amount;
425     _totalSupply += amount;
426     Issue(amount);
427   }
428 
429   // Burn tokens.
430   // These tokens are burned from the owner address
431   // @param _amount Number of tokens to be issued
432   function burn(uint amount) onlyOwner {
433       if (_totalSupply < amount) throw;
434       if (balances[owner] < amount) throw;
435 
436       _totalSupply -= amount;
437       balances[owner] -= amount;
438       Burn(amount);
439   }
440 
441   function setParams(uint newBasisPoints, uint newMaxFee, uint newMinFee) onlyOwner {
442       // Ensure transparency by hardcoding limit beyond which fees can never be added
443     
444       basisPointsRate = newBasisPoints;
445       minimumFee = newMinFee;
446       maximumFee = newMaxFee;
447       Params(basisPointsRate, maximumFee, minimumFee);
448   }
449   
450    function getBlackListStatus(address _maker) external constant returns (bool) {
451         return isBlackListed[_maker];
452     }
453 
454 
455     
456     function addBlackList (address _evilUser) public onlyOwner {
457         isBlackListed[_evilUser] = true;
458         AddedBlackList(_evilUser);
459     }
460 
461     function removeBlackList (address _clearedUser) public onlyOwner {
462         isBlackListed[_clearedUser] = false;
463         RemovedBlackList(_clearedUser);
464     }
465 
466     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
467         require(isBlackListed[_blackListedUser]);
468         uint dirtyFunds = balanceOf(_blackListedUser);
469         balances[_blackListedUser] = 0;
470         _totalSupply -= dirtyFunds;
471         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
472     }
473 
474     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
475 
476     event AddedBlackList(address _user);
477 
478     event RemovedBlackList(address _user);
479     
480 
481   // Called when new token are issued
482   event Issue(uint amount);
483 
484   // Called when tokens are Burned
485   event Burn(uint amount);
486 
487   // Called when contract is deprecated
488   event Deprecate(address newAddress);
489 
490   // Called if contract ever adds fees
491   event Params(uint feeBasisPoints, uint maxFee, uint minFee);
492 }