1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (_a == 0) {
83       return 0;
84     }
85 
86     c = _a * _b;
87     assert(c / _a == _b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
95     // assert(_b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = _a / _b;
97     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
98     return _a / _b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
105     assert(_b <= _a);
106     return _a - _b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
113     c = _a + _b;
114     assert(c >= _a);
115     return c;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address _who) public view returns (uint256);
129   function transfer(address _to, uint256 _value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) internal balances;
143 
144   uint256 internal totalSupply_;
145 
146   /**
147   * @dev Total number of tokens in existence
148   */
149   function totalSupply() public view returns (uint256) {
150     return totalSupply_;
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_value <= balances[msg.sender]);
160     require(_to != address(0));
161 
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address _owner, address _spender)
187     public view returns (uint256);
188 
189   function transferFrom(address _from, address _to, uint256 _value)
190     public returns (bool);
191 
192   function approve(address _spender, uint256 _value) public returns (bool);
193   event Approval(
194     address indexed owner,
195     address indexed spender,
196     uint256 value
197   );
198 }
199 
200 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * https://github.com/ethereum/EIPs/issues/20
207  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(
221     address _from,
222     address _to,
223     uint256 _value
224   )
225     public
226     returns (bool)
227   {
228     require(_value <= balances[_from]);
229     require(_value <= allowed[_from][msg.sender]);
230     require(_to != address(0));
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     emit Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(
261     address _owner,
262     address _spender
263    )
264     public
265     view
266     returns (uint256)
267   {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(
281     address _spender,
282     uint256 _addedValue
283   )
284     public
285     returns (bool)
286   {
287     allowed[msg.sender][_spender] = (
288       allowed[msg.sender][_spender].add(_addedValue));
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint256 _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint256 oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue >= oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 // File: contracts/EtherRichLand.sol
322 
323 contract EtherRichLand is Ownable, StandardToken {
324     string public constant name = "Ether Rich Land"; // name of token
325     string public constant symbol = "ERL"; // symbol of token
326     //uint8 public constant decimals = 18;
327 
328     using SafeMath for uint256;
329 
330     struct Investor {
331         uint256 weiDonated;
332         uint256 weiIncome;
333         address landlord;
334         uint256 taxRate;
335     }
336 
337     mapping(uint256 => Investor) Land;
338     uint256 public weiCollected = 0;
339     uint256 public constant landTotal = 100;
340     address public constant manager1 = 0x978076A6a69A29f6f114072950A4AF9D2bB23435;
341     address public constant manager2 = 0xB362D19e44CbA1625d3837149F31bEaf318f5E61;
342     address public constant manager3 = 0xF62C64729717E230445C3A1Bbfc0c8fbdb9CCB72;
343 
344    //address private crowdsale;
345  
346   constructor(
347     ) public {
348     //crowdsale = address(this);
349   }
350 
351 
352   function () external payable {
353 
354     require(msg.value >= 0.001 ether); // minimal ether to buy
355 
356     playGame(msg.sender, msg.value); // the msg.value is in wei
357   }
358 
359 
360   function getLandTaxRate(uint256 _value) internal pure returns (uint256) {
361     require(_value > 0);
362     uint256 _taxRate = 0;
363 
364     if (_value > 0 && _value <= 1 ether) {
365         _taxRate = 1;
366     } else if (_value > 1 ether && _value <= 10 ether) {
367         _taxRate = 5;
368     } else if (_value > 10 ether && _value <= 100 ether) {
369         _taxRate = 10;
370     } else if (_value > 100 ether && _value <= 500 ether) {
371         _taxRate = 15;
372     } else if (_value > 500 ether && _value <= 1000 ether) {
373         _taxRate = 20;
374     } else if (_value > 1000 ether) {
375         _taxRate = 30;
376     }
377     return _taxRate;
378   }
379 
380 
381   function playGame(address _from, uint256 _value) private  
382   {
383     require(_from != 0x0); // 0x0 is meaning to destory(burn)
384     require(_value > 0);
385 
386     // the unit of the msg.value is in wei 
387     uint256 _landId = uint256(blockhash(block.number-1))%landTotal;
388     uint256 _chanceId = uint256(blockhash(block.number-1))%10;
389 
390     uint256 weiTotal;
391     address landlord;
392     uint256 weiToLandlord;
393     uint256 weiToSender;
394 
395     if (Land[_landId].weiDonated > 0) {
396         // there is a landlord in the land
397         if (_from != Land[_landId].landlord) {
398             if (_chanceId == 5) {
399                 // the old landlord get his wei and his landlord role is ended
400                 weiTotal = Land[_landId].weiDonated + Land[_landId].weiIncome;
401                 landlord = Land[_landId].landlord;
402                 // the new player is the new landlord
403                 Land[_landId].weiDonated = _value;
404                 Land[_landId].weiIncome = 0;
405                 Land[_landId].landlord = _from;
406                 Land[_landId].taxRate = getLandTaxRate(_value);
407 
408                 landlord.transfer(weiTotal);
409             } else {
410                 // pay tax to the landlord
411                 weiToLandlord = _value * Land[_landId].taxRate / 100;
412                 weiToSender = _value - weiToLandlord;
413                 Land[_landId].weiIncome += weiToLandlord;
414 
415                 _from.transfer(weiToSender);
416             }
417         } else {
418             // change the tax rate of the land
419             Land[_landId].weiDonated += _value;
420             Land[_landId].taxRate = getLandTaxRate(Land[_landId].weiDonated);
421         }   
422     } else {
423         // no landlord in the land
424         Land[_landId].weiDonated = _value;
425         Land[_landId].weiIncome = 0;
426         Land[_landId].landlord = _from;
427         Land[_landId].taxRate = getLandTaxRate(_value);
428     }
429   }
430 
431 
432   function sellLand() public {
433     uint256 _landId;
434     uint256 totalWei = 0;
435     //uint256 totalIncome = 0;
436     address _from;
437 
438     for(_landId=0; _landId<landTotal;_landId++) {
439         if (Land[_landId].landlord == msg.sender) {
440             totalWei += Land[_landId].weiDonated;
441             totalWei += Land[_landId].weiIncome;
442             //totalIncome += Land[_landId].weiIncome;
443             Land[_landId].weiDonated = 0;
444             Land[_landId].weiIncome = 0;
445             Land[_landId].landlord = 0x0;
446             Land[_landId].taxRate = 0;
447         }
448     }
449     if (totalWei > 0) {
450         uint256 communityFunding = totalWei * 1 / 100;
451         uint256 finalWei = totalWei - communityFunding;
452 
453         weiCollected += communityFunding;
454         _from = msg.sender;
455         _from.transfer(finalWei);
456     }
457   }
458 
459   function getMyBalance() view public returns (uint256, uint256, uint256) {
460     require(msg.sender != 0x0);
461     uint256 _landId;
462     uint256 _totalWeiDonated = 0;
463     uint256 _totalWeiIncome = 0;
464     uint256 _totalLand = 0;
465 
466     for(_landId=0; _landId<landTotal;_landId++) {
467         if (Land[_landId].landlord == msg.sender) {
468             _totalWeiDonated += Land[_landId].weiDonated;
469             _totalWeiIncome += Land[_landId].weiIncome;
470             _totalLand += 1;
471         }
472     }
473     return (_totalLand, _totalWeiDonated, _totalWeiIncome);
474   }
475 
476   function getBalanceOfAccount(address _to) view public onlyOwner() returns (uint256, uint256, uint256) {
477     require(_to != 0x0);
478 
479     uint256 _landId;
480     uint256 _totalWeiDonated = 0;
481     uint256 _totalWeiIncome = 0;
482     uint256 _totalLand = 0;
483 
484     for(_landId=0; _landId<landTotal;_landId++) {
485         if (Land[_landId].landlord == _to) {
486             _totalWeiDonated += Land[_landId].weiDonated;
487             _totalWeiIncome += Land[_landId].weiIncome;
488             _totalLand += 1;
489         }
490     }
491     return (_totalLand, _totalWeiDonated, _totalWeiIncome);
492   }
493 
494   function sendFunding(address _to, uint256 _value) public onlyOwner() {
495     require(_to != 0x0);
496     require(_to == manager1 || _to == manager2 || _to == manager3);
497     require(_value > 0);
498     require(weiCollected >= _value);
499 
500     weiCollected -= _value;
501     _to.transfer(_value); // wei
502   }
503 }