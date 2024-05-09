1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to relinquish control of the contract.
36    */
37   function renounceOwnership() public onlyOwner {
38     emit OwnershipRenounced(owner);
39     owner = address(0);
40   }
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param _newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address _newOwner) public onlyOwner {
47     _transferOwnership(_newOwner);
48   }
49 
50   /**
51    * @dev Transfers control of the contract to a newOwner.
52    * @param _newOwner The address to transfer ownership to.
53    */
54   function _transferOwnership(address _newOwner) internal {
55     require(_newOwner != address(0));
56     emit OwnershipTransferred(owner, _newOwner);
57     owner = _newOwner;
58   }
59 }
60 
61 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
62 /**
63  * @title SafeMath
64  * @dev Math operations with safety checks that throw on error
65  */
66 library SafeMath {
67 
68   /**
69   * @dev Multiplies two numbers, throws on overflow.
70   */
71   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
72     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
73     // benefit is lost if 'b' is also tested.
74     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
75     if (a == 0) {
76       return 0;
77     }
78 
79     c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     // uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return a / b;
92   }
93 
94   /**
95   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * @dev Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
106     c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
113 /**
114  * @title ERC20Basic
115  * @dev Simpler version of ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/179
117  */
118 contract ERC20Basic {
119   function totalSupply() public view returns (uint256);
120   function balanceOf(address who) public view returns (uint256);
121   function transfer(address to, uint256 value) public returns (bool);
122   event Transfer(address indexed from, address indexed to, uint256 value);
123 }
124 
125 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
126 /**
127  * @title Basic token
128  * @dev Basic version of StandardToken, with no allowances.
129  */
130 contract BasicToken is ERC20Basic {
131   using SafeMath for uint256;
132 
133   mapping(address => uint256) balances;
134   uint256 totalSupply_;
135 
136   /**
137   * @dev total number of tokens in existence
138   */
139   function totalSupply() public view returns (uint256) {
140     return totalSupply_;
141   }
142 
143   /**
144   * @dev transfer token for a specified address
145   * @param _to The address to transfer to.
146   * @param _value The amount to be transferred.
147   */
148   function transfer(address _to, uint256 _value) public returns (bool) {
149     require(_to != address(0));
150     require(_value <= balances[msg.sender]);
151 
152     balances[msg.sender] = balances[msg.sender].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     emit Transfer(msg.sender, _to, _value);
155     return true;
156   }
157 
158   /**
159   * @dev Gets the balance of the specified address.
160   * @param _owner The address to query the the balance of.
161   * @return An uint256 representing the amount owned by the passed address.
162   */
163   function balanceOf(address _owner) public view returns (uint256) {
164     return balances[_owner];
165   }
166 
167 }
168 
169 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
170 /**
171  * @title Burnable Token
172  * @dev Token that can be irreversibly burned (destroyed).
173  */
174 contract BurnableToken is BasicToken {
175 
176   event Burn(address indexed burner, uint256 value);
177 
178   /**
179    * @dev Burns a specific amount of tokens.
180    * @param _value The amount of token to be burned.
181    */
182   function burn(uint256 _value) public {
183     _burn(msg.sender, _value);
184   }
185 
186   function _burn(address _who, uint256 _value) internal {
187     require(_value <= balances[_who]);
188     // no need to require value <= totalSupply, since that would imply the
189     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
190 
191     balances[_who] = balances[_who].sub(_value);
192     totalSupply_ = totalSupply_.sub(_value);
193     emit Burn(_who, _value);
194     emit Transfer(_who, address(0), _value);
195   }
196 }
197 
198 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
199 /**
200  * @title ERC20 interface
201  * @dev see https://github.com/ethereum/EIPs/issues/20
202  */
203 contract ERC20 is ERC20Basic {
204   function allowance(address owner, address spender)
205     public view returns (uint256);
206 
207   function transferFrom(address from, address to, uint256 value)
208     public returns (bool);
209 
210   function approve(address spender, uint256 value) public returns (bool);
211   event Approval(
212     address indexed owner,
213     address indexed spender,
214     uint256 value
215   );
216 }
217 
218 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
219 /**
220  * @title Standard ERC20 token
221  *
222  * @dev Implementation of the basic standard token.
223  * @dev https://github.com/ethereum/EIPs/issues/20
224  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
225  */
226 contract StandardToken is ERC20, BasicToken {
227 
228   mapping (address => mapping (address => uint256)) internal allowed;
229 
230   /**
231    * @dev Transfer tokens from one address to another
232    * @param _from address The address which you want to send tokens from
233    * @param _to address The address which you want to transfer to
234    * @param _value uint256 the amount of tokens to be transferred
235    */
236   function transferFrom(
237     address _from,
238     address _to,
239     uint256 _value
240   )
241     public
242     returns (bool)
243   {
244     require(_to != address(0));
245     require(_value <= balances[_from]);
246     require(_value <= allowed[_from][msg.sender]);
247 
248     balances[_from] = balances[_from].sub(_value);
249     balances[_to] = balances[_to].add(_value);
250     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
251     emit Transfer(_from, _to, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
257    *
258    * Beware that changing an allowance with this method brings the risk that someone may use both the old
259    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
260    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
261    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262    * @param _spender The address which will spend the funds.
263    * @param _value The amount of tokens to be spent.
264    */
265   function approve(address _spender, uint256 _value) public returns (bool) {
266     allowed[msg.sender][_spender] = _value;
267     emit Approval(msg.sender, _spender, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Function to check the amount of tokens that an owner allowed to a spender.
273    * @param _owner address The address which owns the funds.
274    * @param _spender address The address which will spend the funds.
275    * @return A uint256 specifying the amount of tokens still available for the spender.
276    */
277   function allowance(
278     address _owner,
279     address _spender
280    )
281     public
282     view
283     returns (uint256)
284   {
285     return allowed[_owner][_spender];
286   }
287 
288   /**
289    * @dev Increase the amount of tokens that an owner allowed to a spender.
290    *
291    * approve should be called when allowed[_spender] == 0. To increment
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param _spender The address which will spend the funds.
296    * @param _addedValue The amount of tokens to increase the allowance by.
297    */
298   function increaseApproval(
299     address _spender,
300     uint _addedValue
301   )
302     public
303     returns (bool)
304   {
305     allowed[msg.sender][_spender] = (
306       allowed[msg.sender][_spender].add(_addedValue));
307     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
308     return true;
309   }
310 
311   /**
312    * @dev Decrease the amount of tokens that an owner allowed to a spender.
313    *
314    * approve should be called when allowed[_spender] == 0. To decrement
315    * allowed value is better to use this function to avoid 2 calls (and wait until
316    * the first transaction is mined)
317    * From MonolithDAO Token.sol
318    * @param _spender The address which will spend the funds.
319    * @param _subtractedValue The amount of tokens to decrease the allowance by.
320    */
321   function decreaseApproval(
322     address _spender,
323     uint _subtractedValue
324   )
325     public
326     returns (bool)
327   {
328     uint oldValue = allowed[msg.sender][_spender];
329     if (_subtractedValue > oldValue) {
330       allowed[msg.sender][_spender] = 0;
331     } else {
332       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
333     }
334     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335     return true;
336   }
337 
338 }
339 
340 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
341 
342 /**
343  * @title Standard Burnable Token
344  * @dev Adds burnFrom method to ERC20 implementations
345  */
346 contract StandardBurnableToken is BurnableToken, StandardToken {
347 
348   /**
349    * @dev Burns a specific amount of tokens from the target address and decrements allowance
350    * @param _from address The address which you want to send tokens from
351    * @param _value uint256 The amount of token to be burned
352    */
353   function burnFrom(address _from, uint256 _value) public {
354     require(_value <= allowed[_from][msg.sender]);
355     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
356     // this function needs to emit an event with the updated approval.
357     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
358     _burn(_from, _value);
359   }
360 }
361 
362 // File: contracts/Rentledger.sol
363 
364 /**
365  * @title Rentledger Contract
366  *
367  * @dev Implementation of OpenZeppelin StandardBurnableToken.
368  * @dev Ability for Owner to save notes to each Address
369  * @dev Ability for AirDrop to be distributed by Owner
370  */
371 contract Rentledger is StandardBurnableToken, Ownable {
372     using SafeMath for uint256;
373 
374     string public name = "Rentledger";
375     string public symbol = "RTL";
376     uint public decimals = 18;
377     uint public totalAmount = 10000000000;
378     uint public multiplier = (10 ** decimals);
379 
380     address public constant addrDevelopment = 0x3de89f56eb251Bc105FB4e6e6F95cd98F3797496;
381     uint public constant developmentPercent = 10;
382 
383     address public constant addrLockedFunds = 0xA1D7A9ACa0AAD152624be07CddCE1036C3404d4C;
384     uint public constant lockedFundsPercent = 10;
385 
386     address public constant addrAirDrop = 0x9b2466235741D3d8E018acBbC8feCcf4c6C96859;
387     uint public constant airDropPercent = 10;
388 
389     address public constant addrDistribution = 0x7feB9Bdf4Ea954264C735C5C5F731E14e4D5327e;
390     uint public constant distributionPercent = 70;
391 
392     uint64 public constant lockedFundsSeconds = 60 * 60 * 24 * 365 * 1; // 1 year
393     uint public contractStartTime;
394 
395     mapping(address => string) saveData;
396 
397     constructor() public { }
398 
399     function initializeContract() onlyOwner public {
400         if (totalSupply_ != 0) return;
401 
402         require((developmentPercent + lockedFundsPercent + airDropPercent + distributionPercent) == 100);
403 
404         contractStartTime = now;
405 
406         totalSupply_ = totalAmount * multiplier;
407 
408         balances[addrDevelopment] = totalSupply_ * developmentPercent / 100;
409         balances[addrLockedFunds] = totalSupply_ * lockedFundsPercent / 100;
410         balances[addrAirDrop] = totalSupply_ * airDropPercent / 100;
411         balances[addrDistribution] = totalSupply_ * distributionPercent / 100;
412 
413         emit Transfer(0x0, addrDevelopment, balances[addrDevelopment]);
414         emit Transfer(0x0, addrLockedFunds, balances[addrLockedFunds]);
415         emit Transfer(0x0, addrAirDrop, balances[addrAirDrop]);
416         emit Transfer(0x0, addrDistribution, balances[addrDistribution]);
417     }
418 
419     function unlockFunds() onlyOwner public {
420         require(uint256(now).sub(lockedFundsSeconds) > contractStartTime);
421         uint _amount = balances[addrLockedFunds];
422         balances[addrLockedFunds] = balances[addrLockedFunds].sub(_amount);
423         balances[addrDevelopment] = balances[addrDevelopment].add(_amount);
424         emit Transfer(addrLockedFunds, addrDevelopment, _amount);
425     }
426 
427     function putSaveData(address _address, string _text) onlyOwner public {
428         saveData[_address] = _text;
429     }
430 
431     function getSaveData(address _address) constant public returns (string) {
432         return saveData[_address];
433     }
434 
435     function airDrop(address[] _recipients, uint[] _values) onlyOwner public returns (bool) {
436         return distribute(addrAirDrop, _recipients, _values);
437     }
438 
439     function distribute(address _from, address[] _recipients, uint[] _values) internal returns (bool) {
440         require(_recipients.length > 0 && _recipients.length == _values.length);
441 
442         uint total = 0;
443         for(uint i = 0; i < _values.length; i++) {
444             total = total.add(_values[i]);
445         }
446         require(total <= balances[_from]);
447         balances[_from] = balances[_from].sub(total);
448 
449         for(uint j = 0; j < _recipients.length; j++) {
450             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
451             emit Transfer(_from, _recipients[j], _values[j]);
452         }
453 
454         return true;
455     }
456 }