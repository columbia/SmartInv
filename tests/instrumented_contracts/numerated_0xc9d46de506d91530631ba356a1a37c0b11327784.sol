1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72 
73     // SafeMath.sub will throw if there is not enough balance.
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of.
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) public constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amount of tokens to be transferred
108    */
109   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111 
112     uint256 _allowance = allowed[_from][msg.sender];
113 
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // require (_value <= _allowance);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    *
127    * Beware that changing an allowance with this method brings the risk that someone may use both the old
128    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150   /**
151    * approve should be called when allowed[_spender] == 0. To increment
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    */
156   function increaseApproval (address _spender, uint _addedValue)
157     returns (bool success) {
158     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   function decreaseApproval (address _spender, uint _subtractedValue)
164     returns (bool success) {
165     uint oldValue = allowed[msg.sender][_spender];
166     if (_subtractedValue > oldValue) {
167       allowed[msg.sender][_spender] = 0;
168     } else {
169       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
170     }
171     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175 }
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 contract Ownable {
183   address public owner;
184 
185 
186   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188 
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   function Ownable() {
194     owner = msg.sender;
195   }
196 
197 
198   /**
199    * @dev Throws if called by any account other than the owner.
200    */
201   modifier onlyOwner() {
202     require(msg.sender == owner);
203     _;
204   }
205 
206 
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newOwner.
209    * @param newOwner The address to transfer ownership to.
210    */
211   function transferOwnership(address newOwner) onlyOwner public {
212     require(newOwner != address(0));
213     OwnershipTransferred(owner, newOwner);
214     owner = newOwner;
215   }
216 
217 }
218 
219 contract Announceable is Ownable {
220 
221   string public announcement;
222 
223   function setAnnouncement(string value) public onlyOwner {
224     announcement = value;
225   }
226 
227 }
228 
229 contract Withdrawable {
230 
231   address public withdrawOwner;
232 
233   function Withdrawable(address _withdrawOwner) public {
234     require(_withdrawOwner != address(0));
235     withdrawOwner = _withdrawOwner;
236   }
237 
238   /**
239    * Transfers all the funs on this contract to the sender which must be withdrawOwner.
240    */
241   function withdraw() public {
242     withdrawTo(msg.sender, this.balance);
243   }
244 
245   /**
246    * Transfers the given amount of funds to given beneficiary address. Must be called by the withdrawOwner.
247    */
248   function withdrawTo(address _beneficiary, uint _amount) public {
249     require(msg.sender == withdrawOwner);
250     require(_beneficiary != address(0));
251     require(_amount > 0);
252     _beneficiary.transfer(_amount);
253   }
254 
255   /**
256    * Transfer withdraw ownership to another account.
257    */
258   function setWithdrawOwner(address _newOwner) public {
259     require(msg.sender == withdrawOwner);
260     require(_newOwner != address(0));
261     withdrawOwner = _newOwner;
262   }
263 
264 }
265 
266 contract Cryptoverse is StandardToken, Ownable, Announceable, Withdrawable {
267   using SafeMath for uint;
268 
269   string public constant name = "Cryptoverse Sector";
270   string public constant symbol = "CVS";
271   uint8 public constant decimals = 0;
272 
273   /**
274    * Raised whenever grid sector is updated. The event will be raised for any update operation, even when nothing
275    * effectively changes.
276    */
277   event SectorUpdated(
278     uint16 indexed offset,
279     address indexed owner,
280     string link,
281     string content,
282     string title,
283     bool nsfw
284   );
285 
286   /** Structure holding the information about the sector state. */
287   struct Sector {
288     address owner;
289     string link;
290     string content;
291     string title;
292     bool nsfw;
293     bool forceNsfw;
294   }
295 
296   /** Time of the last purchase (or contract creation time). */
297   uint public lastPurchaseTimestamp = now;
298 
299   /** Whether owner is allowed to claim free sectors. */
300   bool public allowClaiming = true;
301 
302   /** The pricing */
303   uint[13] public prices = [1000 finney, 800 finney, 650 finney, 550 finney, 500 finney, 450 finney, 400 finney, 350 finney, 300 finney, 250 finney, 200 finney, 150 finney, 100 finney];
304 
305   uint8 public constant width = 125;
306   uint8 public constant height = 80;
307   uint16 public constant length = 10000;
308 
309   /**
310    * The current state of the grid is stored here.
311    *
312    * The grid has coordinates like screenspace/contentspace has: The [0;0] coordinate is at the top left corner. X axis
313    * goes from top to bottom, Y axis goes from left to right.
314    *
315    * The coordinates are stored as grid[transform(x, y)] = grid[x + 125 * y], .
316    */
317   Sector[10000] public grid;
318 
319   function Cryptoverse() Withdrawable(msg.sender) public { }
320 
321   function () public payable {
322     // how many sectors is sender going to buy
323     // NOTE: purchase via fallback is at flat price
324     uint sectorCount = msg.value / 1000 finney;
325     require(sectorCount > 0);
326 
327     // fire transfer event ahead of update event
328     Transfer(address(0), msg.sender, sectorCount);
329 
330     // now find as many free sectors
331     for (uint16 offset = 0; offset < length; offset++) {
332       Sector storage sector = grid[offset];
333 
334       if (sector.owner == address(0)) {
335         // free sector
336         setSectorOwnerInternal(offset, msg.sender, false);
337         sectorCount--;
338 
339         if (sectorCount == 0) {
340           return;
341         }
342       }
343     }
344 
345     // not enough available free sectors
346     revert();
347   }
348 
349   /**
350    * Purchases the sectors at given offsets. The array length must be even and the bounds must be within grid size.
351    */
352   function buy(uint16[] memory _offsets) public payable {
353     require(_offsets.length > 0);
354     uint cost = _offsets.length * currentPrice();
355     require(msg.value >= cost);
356 
357     // fire transfer event ahead of update event
358     Transfer(address(0), msg.sender, _offsets.length);
359 
360     for (uint i = 0; i < _offsets.length; i++) {
361       setSectorOwnerInternal(_offsets[i], msg.sender, false);
362     }
363   }
364 
365   /**
366   * !override
367   * @param _to The address to transfer to.
368   * @param _value The amount to be transferred.
369   */
370   function transfer(address _to, uint _value) public returns (bool result) {
371     result = super.transfer(_to, _value);
372 
373     if (result && _value > 0) {
374       transferSectorOwnerInternal(_value, msg.sender, _to);
375     }
376   }
377 
378   /**
379    * !override
380    * @param _from address The address which you want to send tokens from
381    * @param _to address The address which you want to transfer to
382    * @param _value uint the amount of tokens to be transferred
383    */
384   function transferFrom(address _from, address _to, uint _value) public returns (bool result) {
385     result = super.transferFrom(_from, _to, _value);
386 
387     if (result && _value > 0) {
388       transferSectorOwnerInternal(_value, _from, _to);
389     }
390   }
391 
392   /**
393    * Allows to transfer the sectors at given coordinates to a new owner.
394    */
395   function transferSectors(uint16[] memory _offsets, address _to) public returns (bool result) {
396     result = super.transfer(_to, _offsets.length);
397 
398     if (result) {
399       for (uint i = 0; i < _offsets.length; i++) {
400         Sector storage sector = grid[_offsets[i]];
401         require(sector.owner == msg.sender);
402         setSectorOwnerInternal(_offsets[i], _to, true);
403       }
404     }
405   }
406 
407   /**
408    * Sets the state of the sector by its rightful owner.
409    */
410   function set(uint16[] memory _offsets, string _link, string _content, string _title, bool _nsfw) public {
411     require(_offsets.length > 0);
412     for (uint i = 0; i < _offsets.length; i++) {
413       Sector storage sector = grid[_offsets[i]];
414       require(msg.sender == sector.owner);
415 
416       sector.link = _link;
417       sector.content = _content;
418       sector.title = _title;
419       sector.nsfw = _nsfw;
420 
421       onUpdatedInternal(_offsets[i], sector);
422     }
423   }
424 
425   /**
426    * Sets the owner of the sector.
427    *
428    * - Does not check whether caller is allowed to do that.
429    * - Does not manipulate balances upon transfer (ensure to call appropriate parent functions).
430    */
431   function setSectorOwnerInternal(uint16 _offset, address _to, bool _canTransfer) internal {
432     require(_to != address(0));
433 
434     // coordinate checks is done by an array type
435     Sector storage sector = grid[_offset];
436 
437     // sector must be empty (not purchased yet)
438     address from = sector.owner;
439     bool isTransfer = (from != address(0));
440     require(_canTransfer || !isTransfer);
441 
442     // variable is a reference to the storage, this will persist the info
443     sector.owner = _to;
444 
445     // NOTE: do not manipulate balance on transfer, only on initial purchase
446     if (!isTransfer) {
447       // initial sector purchase
448       totalSupply = totalSupply.add(1);
449       balances[_to] = balances[_to].add(1);
450       lastPurchaseTimestamp = now;
451     }
452 
453     onUpdatedInternal(_offset, sector);
454   }
455 
456   /**
457    * Transfers the owner of _value implicit sectors.
458    *
459    * !throws Reverts when the _from does not own as many as _value sectors.
460    */
461   function transferSectorOwnerInternal(uint _value, address _from, address _to) internal {
462     require(_value > 0);
463     require(_from != address(0));
464     require(_to != address(0));
465 
466     uint sectorCount = _value;
467 
468     for (uint16 offsetPlusOne = length; offsetPlusOne > 0; offsetPlusOne--) {
469       Sector storage sector = grid[offsetPlusOne - 1];
470 
471       if (sector.owner == _from) {
472         setSectorOwnerInternal(offsetPlusOne - 1, _to, true);
473         sectorCount--;
474 
475         if (sectorCount == 0) {
476           // we have transferred exactly _value ownerships
477           return;
478         }
479       }
480     }
481 
482     // _from does not own at least _value sectors
483     revert();
484   }
485 
486   function setForceNsfw(uint16[] memory _offsets, bool _nsfw) public onlyOwner {
487     require(_offsets.length > 0);
488     for (uint i = 0; i < _offsets.length; i++) {
489       Sector storage sector = grid[_offsets[i]];
490       sector.forceNsfw = _nsfw;
491 
492       onUpdatedInternal(_offsets[i], sector);
493     }
494   }
495 
496   /**
497    * Gets the current price in wei.
498    */
499   function currentPrice() public view returns (uint) {
500     uint sinceLastPurchase = (block.timestamp - lastPurchaseTimestamp);
501 
502     for (uint i = 0; i < prices.length - 1; i++) {
503       if (sinceLastPurchase < (i + 1) * 1 days) {
504         return prices[i];
505       }
506     }
507 
508     return prices[prices.length - 1];
509   }
510 
511   function transform(uint8 _x, uint8 _y) public pure returns (uint16) {
512     uint16 offset = _y;
513     offset = offset * width;
514     offset = offset + _x;
515     return offset;
516   }
517 
518   function untransform(uint16 _offset) public pure returns (uint8, uint8) {
519     uint8 y = uint8(_offset / width);
520     uint8 x = uint8(_offset - y * width);
521     return (x, y);
522   }
523 
524   function claimA() public { claimInternal(60, 37, 5, 5); }
525   function claimB1() public { claimInternal(0, 0, 62, 1); }
526   function claimB2() public { claimInternal(62, 0, 63, 1); }
527   function claimC1() public { claimInternal(0, 79, 62, 1); }
528   function claimC2() public { claimInternal(62, 79, 63, 1); }
529   function claimD() public { claimInternal(0, 1, 1, 78); }
530   function claimE() public { claimInternal(124, 1, 1, 78); }
531   function claimF() public { claimInternal(20, 20, 8, 8); }
532   function claimG() public { claimInternal(45, 10, 6, 10); }
533   function claimH1() public { claimInternal(90, 50, 8, 10); }
534   function claimH2() public { claimInternal(98, 50, 7, 10); }
535   function claimI() public { claimInternal(94, 22, 7, 7); }
536   function claimJ() public { claimInternal(48, 59, 12, 8); }
537 
538   /**
539    * Closes the opportunity to claim free blocks for the owner for good.
540    */
541   function closeClaims() public onlyOwner {
542     allowClaiming = false;
543   }
544 
545   function claimInternal(uint8 _left, uint8 _top, uint8 _width, uint8 _height) internal {
546     require(allowClaiming);
547 
548     // NOTE: SafeMath not needed, we operate on safe numbers
549     uint8 _right = _left + _width;
550     uint8 _bottom = _top + _height;
551 
552     uint area = _width;
553     area = area * _height;
554     Transfer(address(0), owner, area);
555 
556     for (uint8 x = _left; x < _right; x++) {
557       for (uint8 y = _top; y < _bottom; y++) {
558         setSectorOwnerInternal(transform(x, y), owner, false);
559       }
560     }
561   }
562 
563   /**
564    * Raises SectorUpdated event.
565    */
566   function onUpdatedInternal(uint16 _offset, Sector storage _sector) internal {
567     SectorUpdated(
568       _offset,
569       _sector.owner,
570       _sector.link,
571       _sector.content,
572       _sector.title,
573       _sector.nsfw || _sector.forceNsfw
574     );
575   }
576 
577 }