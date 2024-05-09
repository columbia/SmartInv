1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.4.25;
4 
5 /**
6  * Math operations with safety checks
7  */
8 library SafeMath {
9   function mul(uint a, uint b) internal returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint a, uint b) internal returns (uint) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint a, uint b) internal returns (uint) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint a, uint b) internal returns (uint) {
28     uint c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a >= b ? a : b;
35   }
36 
37   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
38     return a < b ? a : b;
39   }
40 
41   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a >= b ? a : b;
43   }
44 
45   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
46     return a < b ? a : b;
47   }
48 
49   function assert(bool assertion) internal {
50     if (!assertion) {
51       throw;
52     }
53   }
54 }
55 
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control 
60  * functions, this simplifies the implementation of "user permissions". 
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   /** 
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() {
71     owner = msg.sender;
72   }
73 
74 
75   /**
76    * @dev Throws if called by any account other than the owner. 
77    */
78   modifier onlyOwner() {
79     if (msg.sender != owner) {
80       throw;
81     }
82     _;
83   }
84 
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param newOwner The address to transfer ownership to. 
89    */
90   function transferOwnership(address newOwner) onlyOwner {
91     if (newOwner != address(0)) {
92       owner = newOwner;
93     }
94   }
95 
96 }
97 
98 /**
99  * @title Pausable
100  * @dev Base contract which allows children to implement an emergency stop mechanism.
101  */
102 contract Pausable is Ownable {
103   event Pause();
104   event Unpause();
105 
106   bool public paused = false;
107 
108 
109   /**
110    * @dev modifier to allow actions only when the contract IS paused
111    */
112   modifier whenNotPaused() {
113     if (paused) throw;
114     _;
115   }
116 
117   /**
118    * @dev modifier to allow actions only when the contract IS NOT paused
119    */
120   modifier whenPaused {
121     if (!paused) throw;
122     _;
123   }
124 
125   /**
126    * @dev called by the owner to pause, triggers stopped state
127    */
128   function pause() onlyOwner whenNotPaused returns (bool) {
129     paused = true;
130     Pause();
131     return true;
132   }
133 
134   /**
135    * @dev called by the owner to unpause, returns to normal state
136    */
137   function unpause() onlyOwner whenPaused returns (bool) {
138     paused = false;
139     Unpause();
140     return true;
141   }
142 }
143 
144 /**
145  * @title ERC20Basic
146  * @dev Simpler version of ERC20 interface
147  * @dev see https://github.com/ethereum/EIPs/issues/20
148  */
149 contract ERC20Basic {
150   uint public _totalSupply;
151   function totalSupply() constant returns (uint);
152   function balanceOf(address who) constant returns (uint);
153   function transfer(address to, uint value);
154   event Transfer(address indexed from, address indexed to, uint value);
155 }
156 
157 /**
158  * @title ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/20
160  */
161 contract ERC20 is ERC20Basic {
162   function allowance(address owner, address spender) constant returns (uint);
163   function transferFrom(address from, address to, uint value);
164   function approve(address spender, uint value);
165   event Approval(address indexed owner, address indexed spender, uint value);
166 }
167 
168 /**
169  * @title Basic token
170  * @dev Basic version of StandardToken, with no allowances.
171  */
172 contract BasicToken is Ownable, ERC20Basic {
173   using SafeMath for uint;
174 
175   mapping(address => uint) balances;
176 
177   // additional variables for use if transaction fees ever became necessary
178   uint public basisPointsRate = 0;
179   uint public maximumFee = 0;
180 
181   /**
182    * @dev Fix for the ERC20 short address attack.
183    */
184   modifier onlyPayloadSize(uint size) {
185      if(msg.data.length < size + 4) {
186        throw;
187      }
188      _;
189   }
190 
191   /**
192   * @dev transfer token for a specified address
193   * @param _to The address to transfer to.
194   * @param _value The amount to be transferred.
195   */
196   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
197     uint fee = (_value.mul(basisPointsRate)).div(10000);
198     if (fee > maximumFee) {
199       fee = maximumFee;
200     }
201     uint sendAmount = _value.sub(fee);
202     balances[msg.sender] = balances[msg.sender].sub(_value);
203     balances[_to] = balances[_to].add(sendAmount);
204     balances[owner] = balances[owner].add(fee);
205     Transfer(msg.sender, _to, sendAmount);
206     Transfer(msg.sender, owner, fee);
207   }
208 
209   /**
210   * @dev Gets the balance of the specified address.
211   * @param _owner The address to query the the balance of.
212   * @return An uint representing the amount owned by the passed address.
213   */
214   function balanceOf(address _owner) constant returns (uint balance) {
215     return balances[_owner];
216   }
217 
218 }
219 
220 
221 /**
222  * @title Standard ERC20 token
223  *
224  * @dev Implementation of the basic standard token.
225  * @dev https://github.com/ethereum/EIPs/issues/20
226  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
227  */
228 contract StandardToken is BasicToken, ERC20 {
229 
230   mapping (address => mapping (address => uint)) allowed;
231 
232   uint constant MAX_UINT = 2**256 - 1;
233 
234   /**
235    * @dev Transfer tokens from one address to another
236    * @param _from address The address which you want to send tokens from
237    * @param _to address The address which you want to transfer to
238    * @param _value uint the amount of tokens to be transferred
239    */
240   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
241     var _allowance = allowed[_from][msg.sender];
242 
243     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
244     // if (_value > _allowance) throw;
245 
246     uint fee = (_value.mul(basisPointsRate)).div(10000);
247     if (fee > maximumFee) {
248       fee = maximumFee;
249     }
250     uint sendAmount = _value.sub(fee);
251 
252     balances[_to] = balances[_to].add(sendAmount);
253     balances[owner] = balances[owner].add(fee);
254     balances[_from] = balances[_from].sub(_value);
255     if (_allowance < MAX_UINT) {
256       allowed[_from][msg.sender] = _allowance.sub(_value);
257     }
258     Transfer(_from, _to, sendAmount);
259     Transfer(_from, owner, fee);
260   }
261 
262   /**
263    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
264    * @param _spender The address which will spend the funds.
265    * @param _value The amount of tokens to be spent.
266    */
267   function approve(address _spender, uint _value) onlyPayloadSize(2 * 32) {
268 
269     // To change the approve amount you first have to reduce the addresses`
270     //  allowance to zero by calling `approve(_spender, 0)` if it is not
271     //  already 0 to mitigate the race condition described here:
272     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
273     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
274 
275     allowed[msg.sender][_spender] = _value;
276     Approval(msg.sender, _spender, _value);
277   }
278 
279   /**
280    * @dev Function to check the amount of tokens than an owner allowed to a spender.
281    * @param _owner address The address which owns the funds.
282    * @param _spender address The address which will spend the funds.
283    * @return A uint specifying the amount of tokens still available for the spender.
284    */
285   function allowance(address _owner, address _spender) constant returns (uint remaining) {
286     return allowed[_owner][_spender];
287   }
288 
289 }
290 
291 contract UpgradedStandardToken is StandardToken{
292         // those methods are called by the legacy contract
293         // and they must ensure msg.sender to be the contract address
294         function transferByLegacy(address from, address to, uint value);
295         function transferFromByLegacy(address sender, address from, address spender, uint value);
296         function approveByLegacy(address from, address spender, uint value);
297 }
298 
299 
300 /// @title - Tether Token Contract - Tether.to
301 /// @author Enrico Rubboli - <enrico@bitfinex.com>
302 /// @author Will Harborne - <will@ethfinex.com>
303 
304 contract GOKU is Pausable, StandardToken {
305 
306   string public name;
307   string public symbol;
308   uint public decimals;
309   address public upgradedAddress;
310   bool public deprecated;
311 
312   //  The contract can be initialized with a number of tokens
313   //  All the tokens are deposited to the owner address
314   //
315   // @param _balance Initial supply of the contract
316   // @param _name Token Name
317   // @param _symbol Token symbol
318   // @param _decimals Token decimals
319   function GokuInterface(uint _initialSupply, string _name, string _symbol, uint _decimals) {
320       _totalSupply = _initialSupply;
321       name = _name;
322       symbol = _symbol;
323       decimals = _decimals;
324       balances[owner] = _initialSupply;
325       deprecated = false;
326   }
327   
328   constructor() GOKU() {
329       GokuInterface(300000000000000, "Goku JPY", "GOKU", 6);
330   }
331   
332   /**
333  * @dev Burns a specific amount of tokens.
334  * @param _value The amount of token to be burned.
335  */
336   function burn(uint256 _value) onlyOwner {
337     require(_value > 0);
338     require(_value <= balances[msg.sender]);
339     // no need to require value <= totalSupply, since that would imply the
340     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
341 
342     address burner = msg.sender;
343     balances[burner] = balances[burner].sub(_value);
344     _totalSupply = _totalSupply.sub(_value);
345   }
346 
347   // Forward ERC20 methods to upgraded contract if this one is deprecated
348   function transfer(address _to, uint _value) whenNotPaused {
349     if (deprecated) {
350       return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
351     } else {
352       return super.transfer(_to, _value);
353     }
354   }
355 
356   // Forward ERC20 methods to upgraded contract if this one is deprecated
357   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
358     if (deprecated) {
359       return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
360     } else {
361       return super.transferFrom(_from, _to, _value);
362     }
363   }
364 
365   // Forward ERC20 methods to upgraded contract if this one is deprecated
366   function balanceOf(address who) constant returns (uint){
367     if (deprecated) {
368       return UpgradedStandardToken(upgradedAddress).balanceOf(who);
369     } else {
370       return super.balanceOf(who);
371     }
372   }
373 
374   // Forward ERC20 methods to upgraded contract if this one is deprecated
375   function approve(address _spender, uint _value) onlyPayloadSize(2 * 32) {
376     if (deprecated) {
377       return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
378     } else {
379       return super.approve(_spender, _value);
380     }
381   }
382 
383   // Forward ERC20 methods to upgraded contract if this one is deprecated
384   function allowance(address _owner, address _spender) constant returns (uint remaining) {
385     if (deprecated) {
386       return StandardToken(upgradedAddress).allowance(_owner, _spender);
387     } else {
388       return super.allowance(_owner, _spender);
389     }
390   }
391 
392   // deprecate current contract in favour of a new one
393   function deprecate(address _upgradedAddress) onlyOwner {
394     deprecated = true;
395     upgradedAddress = _upgradedAddress;
396     Deprecate(_upgradedAddress);
397   }
398 
399   // deprecate current contract if favour of a new one
400   function totalSupply() constant returns (uint){
401     if (deprecated) {
402       return StandardToken(upgradedAddress).totalSupply();
403     } else {
404       return _totalSupply;
405     }
406   }
407 
408   // Issue a new amount of tokens
409   // these tokens are deposited into the owner address
410   //
411   // @param _amount Number of tokens to be issued
412   function issue(uint amount) onlyOwner {
413     if (_totalSupply + amount < _totalSupply) throw;
414     if (balances[owner] + amount < balances[owner]) throw;
415 
416     balances[owner] += amount;
417     _totalSupply += amount;
418     Issue(amount);
419   }
420 
421   // Redeem tokens.
422   // These tokens are withdrawn from the owner address
423   // if the balance must be enough to cover the redeem
424   // or the call will fail.
425   // @param _amount Number of tokens to be issued
426   function redeem(uint amount) onlyOwner {
427       if (_totalSupply < amount) throw;
428       if (balances[owner] < amount) throw;
429 
430       _totalSupply -= amount;
431       balances[owner] -= amount;
432       Redeem(amount);
433   }
434 
435   function setParams(uint newBasisPoints, uint newMaxFee) onlyOwner {
436       // Ensure transparency by hardcoding limit beyond which fees can never be added
437       if (newBasisPoints > 20) throw;
438       if (newMaxFee > 50) throw;
439 
440       basisPointsRate = newBasisPoints;
441       maximumFee = newMaxFee.mul(10**decimals);
442 
443       Params(basisPointsRate, maximumFee);
444   }
445 
446   // Called when new token are issued
447   event Issue(uint amount);
448 
449   // Called when tokens are redeemed
450   event Redeem(uint amount);
451 
452   // Called when contract is deprecated
453   event Deprecate(address newAddress);
454 
455   // Called if contract ever adds fees
456   event Params(uint feeBasisPoints, uint maxFee);
457 }