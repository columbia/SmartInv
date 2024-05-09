1 pragma solidity ^0.4.21;
2 
3 // SafeMath is a part of Zeppelin Solidity library
4 // licensed under MIT License
5 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/LICENSE
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 // https://github.com/OpenZeppelin/zeppelin-solidity
41 
42 /**
43  * @title ERC20Basic
44  * @dev Simpler version of ERC20 interface
45  * @dev see https://github.com/ethereum/EIPs/issues/179
46  */
47 contract ERC20Basic {
48     function totalSupply() public view returns (uint256);
49     function balanceOf(address who) public view returns (uint256);
50     function transfer(address to, uint256 value) public returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 /**
55  * @title ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  */
58 contract ERC20 is ERC20Basic {
59     function allowance(address owner, address spender) public view returns (uint256);
60     function transferFrom(address from, address to, uint256 value) public returns (bool);
61     function approve(address spender, uint256 value) public returns (bool);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70     using SafeMath for uint256;
71 
72     mapping(address => uint256) balances;
73 
74     uint256 totalSupply_;
75 
76     /**
77     * @dev Protection from short address attack
78     */
79     modifier onlyPayloadSize(uint size) {
80         assert(msg.data.length == size + 4);
81         _;
82     }
83 
84     /**
85     * @dev total number of tokens in existence
86     */
87     function totalSupply() public view returns (uint256) {
88         return totalSupply_;
89     }
90 
91     /**
92     * @dev transfer token for a specified address
93     * @param _to The address to transfer to.
94     * @param _value The amount to be transferred.
95     */
96     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
97         require(_to != address(0));
98         require(_value <= balances[msg.sender]);
99 
100         // SafeMath.sub will throw if there is not enough balance.
101         balances[msg.sender] = balances[msg.sender].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         emit Transfer(msg.sender, _to, _value);
104 
105         _postTransferHook(msg.sender, _to, _value);
106 
107         return true;
108     }
109 
110     /**
111     * @dev Gets the balance of the specified address.
112     * @param _owner The address to query the the balance of.
113     * @return An uint256 representing the amount owned by the passed address.
114     */
115     function balanceOf(address _owner) public view returns (uint256 balance) {
116         return balances[_owner];
117     }
118 
119     /**
120     * @dev Hook for custom actions to be executed after transfer has completed
121     * @param _from Transferred from
122     * @param _to Transferred to
123     * @param _value Value transferred
124     */
125     function _postTransferHook(address _from, address _to, uint256 _value) internal;
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137     mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140     /**
141      * @dev Transfer tokens from one address to another
142      * @param _from address The address which you want to send tokens from
143      * @param _to address The address which you want to transfer to
144      * @param _value uint256 the amount of tokens to be transferred
145      */
146     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147         require(_to != address(0));
148         require(_value <= balances[_from]);
149         require(_value <= allowed[_from][msg.sender]);
150 
151         balances[_from] = balances[_from].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154         emit Transfer(_from, _to, _value);
155 
156         _postTransferHook(_from, _to, _value);
157 
158         return true;
159     }
160 
161     /**
162      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163      *
164      * Beware that changing an allowance with this method brings the risk that someone may use both the old
165      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      * @param _spender The address which will spend the funds.
169      * @param _value The amount of tokens to be spent.
170      */
171     function approve(address _spender, uint256 _value) public returns (bool) {
172         allowed[msg.sender][_spender] = _value;
173         emit Approval(msg.sender, _spender, _value);
174         return true;
175     }
176 
177     /**
178      * @dev Function to check the amount of tokens that an owner allowed to a spender.
179      * @param _owner address The address which owns the funds.
180      * @param _spender address The address which will spend the funds.
181      * @return A uint256 specifying the amount of tokens still available for the spender.
182      */
183     function allowance(address _owner, address _spender) public view returns (uint256) {
184         return allowed[_owner][_spender];
185     }
186 
187     /**
188      * @dev Increase the amount of tokens that an owner allowed to a spender.
189      *
190      * approve should be called when allowed[_spender] == 0. To increment
191      * allowed value is better to use this function to avoid 2 calls (and wait until
192      * the first transaction is mined)
193      * From MonolithDAO Token.sol
194      * @param _spender The address which will spend the funds.
195      * @param _addedValue The amount of tokens to increase the allowance by.
196      */
197     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
198         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200         return true;
201     }
202 
203     /**
204      * @dev Decrease the amount of tokens that an owner allowed to a spender.
205      *
206      * approve should be called when allowed[_spender] == 0. To decrement
207      * allowed value is better to use this function to avoid 2 calls (and wait until
208      * the first transaction is mined)
209      * From MonolithDAO Token.sol
210      * @param _spender The address which will spend the funds.
211      * @param _subtractedValue The amount of tokens to decrease the allowance by.
212      */
213     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
214         uint oldValue = allowed[msg.sender][_spender];
215         if (_subtractedValue > oldValue) {
216             allowed[msg.sender][_spender] = 0;
217         } else {
218             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
219         }
220         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221         return true;
222     }
223 
224 }
225 
226 contract Owned {
227     address owner;
228 
229     modifier onlyOwner {
230         require(msg.sender == owner);
231         _;
232     }
233 
234     /// @dev Contract constructor
235     function Owned() public {
236         owner = msg.sender;
237     }
238 }
239 
240 
241 contract AcceptsTokens {
242     ETToken public tokenContract;
243 
244     function AcceptsTokens(address _tokenContract) public {
245         tokenContract = ETToken(_tokenContract);
246     }
247 
248     modifier onlyTokenContract {
249         require(msg.sender == address(tokenContract));
250         _;
251     }
252 
253     function acceptTokens(address _from, uint256 _value, uint256 param1, uint256 param2, uint256 param3) external;
254 }
255 
256 contract ETToken is Owned, StandardToken {
257     using SafeMath for uint;
258 
259     string public name = "ETH.TOWN Token";
260     string public symbol = "ETIT";
261     uint8 public decimals = 18;
262 
263     address public beneficiary;
264     address public oracle;
265     address public heroContract;
266     modifier onlyOracle {
267         require(msg.sender == oracle);
268         _;
269     }
270 
271     mapping (uint32 => address) public floorContracts;
272     mapping (address => bool) public canAcceptTokens;
273 
274     mapping (address => bool) public isMinter;
275 
276     modifier onlyMinters {
277         require(msg.sender == owner || isMinter[msg.sender]);
278         _;
279     }
280 
281     event Dividend(uint256 value);
282     event Withdrawal(address indexed to, uint256 value);
283     event Burn(address indexed from, uint256 value);
284 
285     function ETToken() public {
286         oracle = owner;
287         beneficiary = owner;
288 
289         totalSupply_ = 0;
290     }
291 
292     function setOracle(address _oracle) external onlyOwner {
293         oracle = _oracle;
294     }
295     function setBeneficiary(address _beneficiary) external onlyOwner {
296         beneficiary = _beneficiary;
297     }
298     function setHeroContract(address _heroContract) external onlyOwner {
299         heroContract = _heroContract;
300     }
301 
302     function _mintTokens(address _user, uint256 _amount) private {
303         require(_user != 0x0);
304 
305         balances[_user] = balances[_user].add(_amount);
306         totalSupply_ = totalSupply_.add(_amount);
307 
308         emit Transfer(address(this), _user, _amount);
309     }
310 
311     function authorizeFloor(uint32 _index, address _floorContract) external onlyOwner {
312         floorContracts[_index] = _floorContract;
313     }
314 
315     function _acceptDividends(uint256 _value) internal {
316         uint256 beneficiaryShare = _value / 5;
317         uint256 poolShare = _value.sub(beneficiaryShare);
318 
319         beneficiary.transfer(beneficiaryShare);
320 
321         emit Dividend(poolShare);
322     }
323 
324     function acceptDividends(uint256 _value, uint32 _floorIndex) external {
325         require(floorContracts[_floorIndex] == msg.sender);
326 
327         _acceptDividends(_value);
328     }
329 
330     function rewardTokensFloor(address _user, uint256 _tokens, uint32 _floorIndex) external {
331         require(floorContracts[_floorIndex] == msg.sender);
332 
333         _mintTokens(_user, _tokens);
334     }
335 
336     function rewardTokens(address _user, uint256 _tokens) external onlyMinters {
337         _mintTokens(_user, _tokens);
338     }
339 
340     function() payable public {
341         // Intentionally left empty, for use by floors
342     }
343 
344     function payoutDividends(address _user, uint256 _value) external onlyOracle {
345         _user.transfer(_value);
346 
347         emit Withdrawal(_user, _value);
348     }
349 
350     function accountAuth(uint256 /*_challenge*/) external {
351         // Does nothing by design
352     }
353 
354     function burn(uint256 _amount) external {
355         require(balances[msg.sender] >= _amount);
356 
357         balances[msg.sender] = balances[msg.sender].sub(_amount);
358         totalSupply_ = totalSupply_.sub(_amount);
359 
360         emit Burn(msg.sender, _amount);
361     }
362 
363     function setCanAcceptTokens(address _address, bool _value) external onlyOwner {
364         canAcceptTokens[_address] = _value;
365     }
366 
367     function setIsMinter(address _address, bool _value) external onlyOwner {
368         isMinter[_address] = _value;
369     }
370 
371     function _invokeTokenRecipient(address _from, address _to, uint256 _value, uint256 _param1, uint256 _param2, uint256 _param3) internal {
372         if (!canAcceptTokens[_to]) {
373             return;
374         }
375 
376         AcceptsTokens recipient = AcceptsTokens(_to);
377 
378         recipient.acceptTokens(_from, _value, _param1, _param2, _param3);
379     }
380 
381     /**
382     * @dev transfer token for a specified address and forward the parameters to token recipient if any
383     * @param _to The address to transfer to.
384     * @param _value The amount to be transferred.
385     * @param _param1 Parameter 1 for the token recipient
386     * @param _param2 Parameter 2 for the token recipient
387     * @param _param3 Parameter 3 for the token recipient
388     */
389     function transferWithParams(address _to, uint256 _value, uint256 _param1, uint256 _param2, uint256 _param3) onlyPayloadSize(5 * 32) external returns (bool) {
390         require(_to != address(0));
391         require(_value <= balances[msg.sender]);
392 
393         // SafeMath.sub will throw if there is not enough balance.
394         balances[msg.sender] = balances[msg.sender].sub(_value);
395         balances[_to] = balances[_to].add(_value);
396         emit Transfer(msg.sender, _to, _value);
397 
398         _invokeTokenRecipient(msg.sender, _to, _value, _param1, _param2, _param3);
399 
400         return true;
401     }
402 
403     /**
404     * @dev Hook for custom actions to be executed after transfer has completed
405     * @param _from Transferred from
406     * @param _to Transferred to
407     * @param _value Value transferred
408     */
409     function _postTransferHook(address _from, address _to, uint256 _value) internal {
410         _invokeTokenRecipient(_from, _to, _value, 0, 0, 0);
411     }
412 
413 
414 }
415 
416 contract PresaleContract is Owned {
417     ETToken public tokenContract;
418 
419     /// @dev Contract constructor
420     function PresaleContract(address _tokenContract) public {
421         tokenContract = ETToken(_tokenContract);
422     }
423 }
424 
425 
426 contract ETCharPresale is PresaleContract {
427     using SafeMath for uint;
428 
429     bool public enabled = true;
430     uint32 public maxCharId = 300;
431     uint32 public currentCharId = 1;
432 
433     uint256 public currentPrice = 0.1 ether;
434 
435     mapping (uint32 => address) public owners;
436     mapping (address => uint32[]) public characters;
437 
438     event Purchase(address from, uint32 charId, uint256 amount);
439 
440     function ETCharPresale(address _presaleToken)
441         PresaleContract(_presaleToken)
442         public
443     {
444     }
445 
446     function _isContract(address _user) internal view returns (bool) {
447         uint size;
448         assembly { size := extcodesize(_user) }
449         return size > 0;
450     }
451 
452     function _provideChars(address _address, uint32 _number) internal {
453 
454         for (uint32 i = 0; i < _number; i++) {
455             owners[currentCharId + i] = _address;
456             characters[_address].push(currentCharId + i);
457             emit Purchase(_address, currentCharId + i, currentPrice);
458         }
459 
460         currentCharId += _number;
461         currentPrice += priceIncrease() * _number;
462     }
463 
464     function priceIncrease() public view returns (uint256) {
465         uint256 _currentPrice = currentPrice;
466 
467         if (_currentPrice > 0.3 ether) {
468             return 0.05 finney;
469         } else if (_currentPrice > 0.25 ether) {
470             return 0.1 finney;
471         } else if (_currentPrice > 0.2 ether) {
472             return 0.2 finney;
473         } else if (_currentPrice > 0.15 ether) {
474             return 0.4 finney;
475         } else {
476             return 0.8 finney;
477         }
478     }
479 
480     function() public payable {
481         require(enabled);
482         require(!_isContract(msg.sender));
483 
484         require(msg.value >= currentPrice);
485 
486         uint32 chars = uint32(msg.value.div(currentPrice));
487 
488         require(chars <= 50);
489 
490         if (chars > 5) {
491             chars = 5;
492         }
493 
494         require(currentCharId + chars - 1 <= maxCharId);
495 
496         uint256 purchaseValue = currentPrice.mul(chars);
497         uint256 change = msg.value.sub(purchaseValue);
498 
499         _provideChars(msg.sender, chars);
500 
501         tokenContract.rewardTokens(msg.sender, purchaseValue * 200);
502 
503         if (currentCharId > maxCharId) {
504             enabled = false;
505         }
506 
507         if (change > 0) {
508             msg.sender.transfer(change);
509         }
510     }
511 
512     function setEnabled(bool _enabled) public onlyOwner {
513         enabled = _enabled;
514     }
515 
516     function setMaxCharId(uint32 _maxCharId) public onlyOwner {
517         maxCharId = _maxCharId;
518     }
519 
520     function setCurrentPrice(uint256 _currentPrice) public onlyOwner {
521         currentPrice = _currentPrice;
522     }
523 
524     function withdraw() public onlyOwner {
525         owner.transfer(address(this).balance);
526     }
527 
528     function charactersOf(address _user) public view returns (uint32[]) {
529         return characters[_user];
530     }
531 }