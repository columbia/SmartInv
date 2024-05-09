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
178 
179   /**
180    * @dev Fix for the ERC20 short address attack.
181    */
182   modifier onlyPayloadSize(uint size) {
183      if(msg.data.length < size + 4) {
184        throw;
185      }
186      _;
187   }
188 
189   /**
190   * @dev transfer token for a specified address
191   * @param _to The address to transfer to.
192   * @param _value The amount to be transferred.
193   */
194   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
195     uint fee = (_value.mul(basisPointsRate)).div(10000);
196     if (fee > maximumFee) {
197       fee = maximumFee;
198     }
199     uint sendAmount = _value.sub(fee);
200     balances[msg.sender] = balances[msg.sender].sub(_value);
201     balances[_to] = balances[_to].add(sendAmount);
202     balances[owner] = balances[owner].add(fee);
203     Transfer(msg.sender, _to, sendAmount);
204     Transfer(msg.sender, owner, fee);
205   }
206 
207   /**
208   * @dev Gets the balance of the specified address.
209   * @param _owner The address to query the the balance of.
210   * @return An uint representing the amount owned by the passed address.
211   */
212   function balanceOf(address _owner) constant returns (uint balance) {
213     return balances[_owner];
214   }
215 
216 }
217 
218 
219 /**
220  * @title Standard ERC20 token
221  *
222  * @dev Implementation of the basic standard token.
223  * @dev https://github.com/ethereum/EIPs/issues/20
224  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
225  */
226 contract StandardToken is BasicToken, ERC20 {
227 
228   mapping (address => mapping (address => uint)) allowed;
229 
230   uint constant MAX_UINT = 2**256 - 1;
231 
232   /**
233    * @dev Transfer tokens from one address to another
234    * @param _from address The address which you want to send tokens from
235    * @param _to address The address which you want to transfer to
236    * @param _value uint the amount of tokens to be transferred
237    */
238   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
239     var _allowance = allowed[_from][msg.sender];
240 
241     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
242     // if (_value > _allowance) throw;
243 
244     uint fee = (_value.mul(basisPointsRate)).div(10000);
245     if (fee > maximumFee) {
246       fee = maximumFee;
247     }
248     uint sendAmount = _value.sub(fee);
249 
250     balances[_to] = balances[_to].add(sendAmount);
251     balances[owner] = balances[owner].add(fee);
252     balances[_from] = balances[_from].sub(_value);
253     if (_allowance < MAX_UINT) {
254       allowed[_from][msg.sender] = _allowance.sub(_value);
255     }
256     Transfer(_from, _to, sendAmount);
257     Transfer(_from, owner, fee);
258   }
259 
260   /**
261    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
262    * @param _spender The address which will spend the funds.
263    * @param _value The amount of tokens to be spent.
264    */
265   function approve(address _spender, uint _value) onlyPayloadSize(2 * 32) {
266 
267     // To change the approve amount you first have to reduce the addresses`
268     //  allowance to zero by calling `approve(_spender, 0)` if it is not
269     //  already 0 to mitigate the race condition described here:
270     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
272 
273     allowed[msg.sender][_spender] = _value;
274     Approval(msg.sender, _spender, _value);
275   }
276 
277   /**
278    * @dev Function to check the amount of tokens than an owner allowed to a spender.
279    * @param _owner address The address which owns the funds.
280    * @param _spender address The address which will spend the funds.
281    * @return A uint specifying the amount of tokens still available for the spender.
282    */
283   function allowance(address _owner, address _spender) constant returns (uint remaining) {
284     return allowed[_owner][_spender];
285   }
286 
287 }
288 
289 contract UpgradedStandardToken is StandardToken{
290         // those methods are called by the legacy contract
291         // and they must ensure msg.sender to be the contract address
292         function transferByLegacy(address from, address to, uint value);
293         function transferFromByLegacy(address sender, address from, address spender, uint value);
294         function approveByLegacy(address from, address spender, uint value);
295 }
296 
297 
298 /// @title - Tether Token Contract - Tether.to
299 /// @author Enrico Rubboli - <enrico@bitfinex.com>
300 /// @author Will Harborne - <will@ethfinex.com>
301 
302 contract TetherToken is Pausable, StandardToken {
303 
304   string public name;
305   string public symbol;
306   uint public decimals;
307   address public upgradedAddress;
308   bool public deprecated;
309 
310   //  The contract can be initialized with a number of tokens
311   //  All the tokens are deposited to the owner address
312   //
313   // @param _balance Initial supply of the contract
314   // @param _name Token Name
315   // @param _symbol Token symbol
316   // @param _decimals Token decimals
317   function TetherToken(uint _initialSupply, string _name, string _symbol, uint _decimals){
318       _totalSupply = _initialSupply;
319       name = _name;
320       symbol = _symbol;
321       decimals = _decimals;
322       balances[owner] = _initialSupply;
323       deprecated = false;
324   }
325 
326   // Forward ERC20 methods to upgraded contract if this one is deprecated
327   function transfer(address _to, uint _value) whenNotPaused {
328     if (deprecated) {
329       return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
330     } else {
331       return super.transfer(_to, _value);
332     }
333   }
334 
335   // Forward ERC20 methods to upgraded contract if this one is deprecated
336   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
337     if (deprecated) {
338       return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
339     } else {
340       return super.transferFrom(_from, _to, _value);
341     }
342   }
343 
344   // Forward ERC20 methods to upgraded contract if this one is deprecated
345   function balanceOf(address who) constant returns (uint){
346     if (deprecated) {
347       return UpgradedStandardToken(upgradedAddress).balanceOf(who);
348     } else {
349       return super.balanceOf(who);
350     }
351   }
352 
353   // Forward ERC20 methods to upgraded contract if this one is deprecated
354   function approve(address _spender, uint _value) onlyPayloadSize(2 * 32) {
355     if (deprecated) {
356       return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
357     } else {
358       return super.approve(_spender, _value);
359     }
360   }
361 
362   // Forward ERC20 methods to upgraded contract if this one is deprecated
363   function allowance(address _owner, address _spender) constant returns (uint remaining) {
364     if (deprecated) {
365       return StandardToken(upgradedAddress).allowance(_owner, _spender);
366     } else {
367       return super.allowance(_owner, _spender);
368     }
369   }
370 
371   // deprecate current contract in favour of a new one
372   function deprecate(address _upgradedAddress) onlyOwner {
373     deprecated = true;
374     upgradedAddress = _upgradedAddress;
375     Deprecate(_upgradedAddress);
376   }
377 
378   // deprecate current contract if favour of a new one
379   function totalSupply() constant returns (uint){
380     if (deprecated) {
381       return StandardToken(upgradedAddress).totalSupply();
382     } else {
383       return _totalSupply;
384     }
385   }
386 
387   // Issue a new amount of tokens
388   // these tokens are deposited into the owner address
389   //
390   // @param _amount Number of tokens to be issued
391   function issue(uint amount) onlyOwner {
392     if (_totalSupply + amount < _totalSupply) throw;
393     if (balances[owner] + amount < balances[owner]) throw;
394 
395     balances[owner] += amount;
396     _totalSupply += amount;
397     Issue(amount);
398   }
399 
400   // Redeem tokens.
401   // These tokens are withdrawn from the owner address
402   // if the balance must be enough to cover the redeem
403   // or the call will fail.
404   // @param _amount Number of tokens to be issued
405   function redeem(uint amount) onlyOwner {
406       if (_totalSupply < amount) throw;
407       if (balances[owner] < amount) throw;
408 
409       _totalSupply -= amount;
410       balances[owner] -= amount;
411       Redeem(amount);
412   }
413 
414   function setParams(uint newBasisPoints, uint newMaxFee) onlyOwner {
415       // Ensure transparency by hardcoding limit beyond which fees can never be added
416       if (newBasisPoints > 20) throw;
417       if (newMaxFee > 50) throw;
418 
419       basisPointsRate = newBasisPoints;
420       maximumFee = newMaxFee.mul(10**decimals);
421 
422       Params(basisPointsRate, maximumFee);
423   }
424 
425   // Called when new token are issued
426   event Issue(uint amount);
427 
428   // Called when tokens are redeemed
429   event Redeem(uint amount);
430 
431   // Called when contract is deprecated
432   event Deprecate(address newAddress);
433 
434   // Called if contract ever adds fees
435   event Params(uint feeBasisPoints, uint maxFee);
436 }