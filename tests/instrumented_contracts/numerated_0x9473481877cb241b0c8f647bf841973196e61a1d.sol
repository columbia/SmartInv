1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
71    */
72   constructor() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to relinquish control of the contract.
86    */
87   function renounceOwnership() public onlyOwner {
88     emit OwnershipRenounced(owner);
89     owner = address(0);
90   }
91 
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address _newOwner) public onlyOwner {
97     _transferOwnership(_newOwner);
98   }
99 
100   /**
101    * @dev Transfers control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function _transferOwnership(address _newOwner) internal {
105     require(_newOwner != address(0));
106     emit OwnershipTransferred(owner, _newOwner);
107     owner = _newOwner;
108   }
109 }
110 
111 
112 
113 contract Prop {
114     function noFeeTransfer(address _to, uint256 _value) public returns (bool);
115     function mintTokens(address _atAddress, uint256 _amount) public;
116 
117 }
118 
119 contract BST {
120     function balanceOf(address _owner) public constant returns (uint256 _balance);
121 }
122 
123 contract FirstBuyers is Ownable {
124     using SafeMath for uint256;
125 
126     /* Modifiers */
127     modifier onlyFirstBuyer() {
128         require(firstBuyers[msg.sender].tokensReceived > 0);
129         _;
130     }
131 
132     /* Struct */
133     struct FirstBuyer {
134         uint256 lastTransactionIndex;
135         uint256 tokensReceived;
136         uint256 weightedContribution;
137     }
138 
139     /* Mappings */
140     mapping(address => FirstBuyer) firstBuyers;
141     mapping(uint256 => uint256) transactions;
142     mapping(uint256 => address) firstBuyerIndex;
143 
144     /* Private variables */
145     uint256 numOfTransaction;
146     uint256 numOfFirstBuyers = 0;
147     uint256 totalWeightedContribution;
148     Prop property;
149     BST bst;
150 
151     event FirstBuyerWhitdraw(address indexed _firstBuyer, uint256 _amount);
152     event NewTransactionOfTokens(uint256 _amount, uint256 _index);
153 
154     /**
155     * @dev constructor function, creates new FirstBuyers
156     * @param _property Address of property
157     * @param _owner Owner of this ICO
158     **/
159     constructor(address _property,  address _owner) public {
160         property = Prop(_property);
161         owner = _owner;
162         bst = BST(0x509A38b7a1cC0dcd83Aa9d06214663D9eC7c7F4a);
163     }
164 
165     /**
166     * @dev add first buyers
167     * @param _addresses Array of first buyer addresses
168     * @param _amount Array of first buyer tokens
169     **/
170     function addFirstBuyers(address[] _addresses, uint256[] _amount) public onlyOwner {
171         require(_addresses.length == _amount.length);
172         for(uint256 i = 0; i < _addresses.length; i++) {
173             uint256 weightedContribution = (bst.balanceOf(_addresses[i]).mul(_amount[i])).div(10**18);
174 
175             FirstBuyer storage buyer = firstBuyers[_addresses[i]];
176             uint256 before = buyer.tokensReceived;
177             buyer.tokensReceived = buyer.tokensReceived.add(_amount[i]);
178             buyer.weightedContribution = buyer.weightedContribution.add(weightedContribution);
179 
180             property.mintTokens(_addresses[i], _amount[i]);
181             firstBuyers[_addresses[i]] = buyer;
182 
183             totalWeightedContribution = totalWeightedContribution.add(weightedContribution);
184             if(before == 0) {
185                 firstBuyerIndex[numOfFirstBuyers] = _addresses[i];
186                 numOfFirstBuyers++;
187             }
188         }
189     }
190 
191     /**
192     * @dev allows First buyers to collect fee from transactions
193     **/
194     function withdrawTokens() public onlyFirstBuyer {
195         FirstBuyer storage buyer = firstBuyers[msg.sender];
196         require(numOfTransaction >= buyer.lastTransactionIndex);
197         uint256 iterateOver = numOfTransaction.sub(buyer.lastTransactionIndex);
198         if (iterateOver > 30) {
199             iterateOver = 30;
200         }
201         uint256 iterate = buyer.lastTransactionIndex.add(iterateOver);
202         uint256 amount = 0;
203         for (uint256 i = buyer.lastTransactionIndex; i < iterate; i++) {
204             uint256 ratio = ((buyer.weightedContribution.mul(10**14)).div(totalWeightedContribution));
205             amount = amount.add((transactions[buyer.lastTransactionIndex].mul(ratio)).div(10**14));
206             buyer.lastTransactionIndex = buyer.lastTransactionIndex.add(1);
207         }
208         assert(property.noFeeTransfer(msg.sender, amount));
209         emit FirstBuyerWhitdraw(msg.sender, amount);
210     }
211 
212     /**
213     * @dev save every transaction that BSPT sends
214     * @param _amount Amount of tokens taken as fee
215     **/
216     function incomingTransaction(uint256 _amount) public {
217         require(msg.sender == address(property));
218         transactions[numOfTransaction] = _amount;
219         numOfTransaction += 1;
220         emit NewTransactionOfTokens(_amount, numOfTransaction);
221     }
222 
223     /**
224     * @dev get transaction index of last transaction that First buyer claimed
225     * @param _firstBuyer First buyer address
226     * @return Return transaction index
227     **/
228     function getFirstBuyer(address _firstBuyer) constant public returns (uint256, uint256, uint256) {
229         return (firstBuyers[_firstBuyer].lastTransactionIndex,firstBuyers[_firstBuyer].tokensReceived,firstBuyers[_firstBuyer].weightedContribution);
230     }
231 
232     /**
233     * @dev get number of first buyers
234     * @return Number of first buyers
235     **/
236     function getNumberOfFirstBuyer() constant public returns(uint256) {
237         return numOfFirstBuyers;
238     }
239 
240     /**
241     * @dev get address of first buyer by index
242     * @param _index Index of first buyer
243     * @return Address of first buyer
244     **/
245     function getFirstBuyerAddress(uint256 _index) constant public returns(address) {
246         return firstBuyerIndex[_index];
247     }
248 
249     /**
250     * @dev get total number of transactions
251     * @return Total number of transactions that came in
252     **/
253     function getNumberOfTransactions() constant public returns(uint256) {
254         return numOfTransaction;
255     }
256 
257     /**
258     * @dev get total weighted contribution
259     * @return Total sum of all weighted contribution
260     **/
261     function getTotalWeightedContribution() constant public returns(uint256) {
262         return totalWeightedContribution;
263     }
264 
265     /**
266     * @dev fallback function to prevent any ether to be sent to this contract
267     **/
268     function () public payable {
269         revert();
270     }
271 }
272 
273 
274 /*****************************/
275 /*   STANDARD ERC20 TOKEN    */
276 /*****************************/
277 
278 contract ERC20Token {
279 
280     /** Functions needed to be implemented by ERC20 standard **/
281     function totalSupply() public constant returns (uint256 _totalSupply);
282     function balanceOf(address _owner) public constant returns (uint256 _balance);
283     function transfer(address _to, uint256 _amount) public returns (bool _success);
284     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool _success);
285     function approve(address _spender, uint256 _amount) public returns (bool _success);
286     function allowance(address _owner, address _spender) public constant returns (uint256 _remaining);
287 
288     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
289     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
290 }
291 
292 contract Data {
293     function canMakeNoFeeTransfer(address _from, address _to) constant public returns(bool);
294     function getNetworkFee() public constant returns (uint256);
295     function getBlocksquareFee() public constant returns (uint256);
296     function getCPFee() public constant returns (uint256);
297     function getFirstBuyersFee() public constant returns (uint256);
298     function hasPrestige(address _owner) public constant returns(bool);
299 }
300 
301 /*****************/
302 /*   PROPERTY    */
303 /*****************/
304 
305 contract PropToken is ERC20Token, Ownable {
306     using SafeMath for uint256;
307 
308     struct Prop {
309         string primaryPropertyType;
310         string secondaryPropertyType;
311         uint64 cadastralMunicipality;
312         uint64 parcelNumber;
313         uint64 id;
314     }
315 
316 
317     /* Info about property */
318     string mapURL = "https://www.google.com/maps/place/Tehnolo%C5%A1ki+park+Ljubljana+d.o.o./@46.0491873,14.458252,17z/data=!3m1!4b1!4m5!3m4!1s0x477ad2b1cdee0541:0x8e60f36e738253f0!8m2!3d46.0491873!4d14.4604407";
319     string public name = "PropToken BETA 000000000001"; // Name of property
320     string public symbol = "BSPT-BETA-000000000001"; // Symbol for property
321     uint8 public decimals = 18; // Decimals
322     uint8 public numOfProperties;
323 
324     bool public tokenFrozen; // Can property be transfered
325 
326     /* Fee-recievers */
327     FirstBuyers public firstBuyers; //FirstBuyers
328     address public networkReserveFund; // Address of Reserve funds
329     address public blocksquare; // Address of Blocksquare
330     address public certifiedPartner; // Address of partner who is selling property
331 
332     /* Private variables */
333     uint256 supply; //Current supply, at end total supply
334     uint256 MAXSUPPLY = 100000 * 10 ** 18; // Total supply
335     uint256 feePercent;
336     mapping(address => uint256) balances;
337     mapping(address => mapping(address => uint256)) allowances;
338 
339     Data data;
340 
341     Prop[] properties;
342 
343     /* Events */
344     event TokenFrozen(bool _frozen, string _reason);
345     event Mint(address indexed _to, uint256 _value);
346 
347     /**
348     * @dev constructor
349     **/
350     constructor() public {
351         owner = msg.sender;
352         tokenFrozen = true;
353         feePercent = 2;
354         networkReserveFund = address(0x7E8f1b7655fc05e48462082E5A12e53DBc33464a);
355         blocksquare = address(0x84F4CE7a40238062edFe3CD552cacA656d862f27);
356         certifiedPartner = address(0x3706E1CdB3254a1601098baE8D1A8312Cf92f282);
357         firstBuyers = new FirstBuyers(this, owner);
358     }
359 
360     /**
361     * @dev add new property under this BSPT
362     * @param _primaryPropertyType Primary type of property
363     * @param _secondaryPropertyType Secondary type of property
364     * @param _cadastralMunicipality Cadastral municipality
365     * @param _parcelNumber Parcel number
366     * @param _id Id of property
367     **/
368     function addProperty(string _primaryPropertyType, string _secondaryPropertyType, uint64 _cadastralMunicipality, uint64 _parcelNumber, uint64 _id) public onlyOwner {
369         properties.push(Prop(_primaryPropertyType, _secondaryPropertyType, _cadastralMunicipality, _parcelNumber, _id));
370         numOfProperties++;
371     }
372 
373     /**
374     * @dev set data factory
375     * @param _data Address of data factory
376     **/
377     function setDataFactory(address _data) public onlyOwner {
378         data = Data(_data);
379     }
380 
381     /**
382     * @dev send tokens without fee
383     * @param _from Address of sender.
384     * @param _to Address of recipient.
385     * @param _amount Amount to send.
386     * @return Whether the transfer was successful or not.
387     **/
388     function noFee(address _from, address _to, uint256 _amount) private returns (bool) {
389         require(!tokenFrozen);
390         require(balances[_from] >= _amount);
391         balances[_to] = balances[_to].add(_amount);
392         balances[_from] = balances[_from].sub(_amount);
393         emit Transfer(_from, _to, _amount);
394         return true;
395     }
396 
397     /**
398     * @dev allows first buyers contract to transfer BSPT without fee
399     * @param _to Where to send BSPT
400     * @param _amount Amount of BSPT to send
401     * @return True if transfer was successful, false instead
402     **/
403     function noFeeTransfer(address _to, uint256 _amount) public returns (bool) {
404         require(msg.sender == address(firstBuyers));
405         return noFee(msg.sender, _to, _amount);
406     }
407 
408     /**
409     * @dev calculate and distribute fee for fee-recievers
410     * @param _fee Fee amount
411     **/
412     function distributeFee(uint256 _fee) private {
413         balances[networkReserveFund] = balances[networkReserveFund].add((_fee.mul(data.getNetworkFee())).div(100));
414         balances[blocksquare] = balances[blocksquare].add((_fee.mul(data.getBlocksquareFee())).div(100));
415         balances[certifiedPartner] = balances[certifiedPartner].add((_fee.mul(data.getCPFee())).div(100));
416         balances[address(firstBuyers)] = balances[address(firstBuyers)].add((_fee.mul(data.getFirstBuyersFee())).div(100));
417         firstBuyers.incomingTransaction((_fee.mul(data.getFirstBuyersFee())).div(100));
418     }
419 
420     /**
421     * @dev send tokens
422     * @param _from Address of sender.
423     * @param _to Address of recipient.
424     * @param _amount Amount to send.
425     **/
426     function _transfer(address _from, address _to, uint256 _amount) private {
427         require(_to != 0x0);
428         require(_to != address(this));
429         require(balances[_from] >= _amount);
430         uint256 fee = (_amount.mul(feePercent)).div(100);
431         distributeFee(fee);
432         balances[_to] = balances[_to].add(_amount.sub(fee));
433         balances[_from] = balances[_from].sub(_amount);
434         emit Transfer(_from, _to, _amount.sub(fee));
435     }
436 
437     /**
438     * @dev send tokens from your address.
439     * @param _to Address of recipient.
440     * @param _amount Amount to send.
441     * @return Whether the transfer was successful or not.
442     **/
443     function transfer(address _to, uint256 _amount) public returns (bool) {
444         require(!tokenFrozen);
445         if (data.canMakeNoFeeTransfer(msg.sender, _to) || data.hasPrestige(msg.sender)) {
446             noFee(msg.sender, _to, _amount);
447         }
448         else {
449             _transfer(msg.sender, _to, _amount);
450         }
451         return true;
452     }
453 
454     /**
455     * @dev set allowance for someone to spend tokens from your address
456     * @param _spender Address of spender.
457     * @param _amount Max amount allowed to spend.
458     * @return Whether the approve was successful or not.
459     **/
460     function approve(address _spender, uint256 _amount) public returns (bool) {
461         allowances[msg.sender][_spender] = _amount;
462         emit Approval(msg.sender, _spender, _amount);
463         return true;
464     }
465 
466     /**
467     * @dev send tokens
468     * @param _from Address of sender.
469     * @param _to Address of recipient.
470     * @param _amount Amount of token to send.
471     * @return Whether the transfer was successful or not.
472     **/
473     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
474         require(_amount <= allowances[_from][msg.sender]);
475         require(!tokenFrozen);
476         _transfer(_from, _to, _amount);
477         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);
478         return true;
479     }
480 
481     /**
482     * @dev mint tokens, can only be done by first buyers contract
483     * @param _atAddress Adds tokens to address
484     * @param _amount Amount of tokens to add
485     **/
486     function mintTokens(address _atAddress, uint256 _amount) public {
487         require(msg.sender == address(firstBuyers));
488         require(balances[_atAddress].add(_amount) > balances[_atAddress]);
489         require((supply.add(_amount)) <= MAXSUPPLY);
490         supply = supply.add(_amount);
491         balances[_atAddress] = balances[_atAddress].add(_amount);
492         emit Mint(_atAddress, _amount);
493         emit Transfer(0x0, _atAddress, _amount);
494     }
495 
496     /**
497     * @dev changes status of frozen
498     * @param _reason Reason for freezing or unfreezing token
499     **/
500     function changeFreezeTransaction(string _reason) public onlyOwner {
501         tokenFrozen = !tokenFrozen;
502         emit TokenFrozen(tokenFrozen, _reason);
503     }
504 
505     /**
506     * @dev change fee percent
507     * @param _fee New fee percent
508     **/
509     function changeFee(uint256 _fee) public onlyOwner {
510         feePercent = _fee;
511     }
512 
513     /**
514     * @dev get allowance
515     * @param _owner Owner address
516     * @param _spender Spender address
517     * @return Return amount allowed to spend from '_owner' by '_spender'
518     **/
519     function allowance(address _owner, address _spender) public constant returns (uint256) {
520         return allowances[_owner][_spender];
521     }
522 
523     /**
524     * @dev total amount of token
525     * @return Total amount of token
526     **/
527     function totalSupply() public constant returns (uint256) {
528         return supply;
529     }
530 
531     /**
532     * @dev check balance of address
533     * @param _owner Address
534     * @return Amount of token in possession
535     **/
536     function balanceOf(address _owner) public constant returns (uint256) {
537         return balances[_owner];
538     }
539 
540     /**
541     * @dev get information about property
542     * @param _index Index of property
543     * @return Primary type, secondary type, cadastral municipality, parcel number and id of property
544     **/
545     function getPropertyInfo(uint8 _index) public constant returns (string, string, uint64, uint64, uint64) {
546         return (properties[_index].primaryPropertyType, properties[_index].secondaryPropertyType, properties[_index].cadastralMunicipality, properties[_index].parcelNumber, properties[_index].id);
547     }
548 
549     /**
550     * @dev get google maps url of property location
551     **/
552     function getMap() public constant returns (string) {
553         return mapURL;
554     }
555 }