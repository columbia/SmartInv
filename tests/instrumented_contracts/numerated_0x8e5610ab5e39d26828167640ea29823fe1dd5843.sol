1 pragma solidity ^0.4.23;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 
118 /**
119  * @title Basic token
120  * @dev Basic version of StandardToken, with no allowances.
121  */
122 contract BasicToken is ERC20Basic {
123   using SafeMath for uint256;
124 
125   mapping(address => uint256) balances;
126 
127   uint256 totalSupply_;
128 
129   /**
130   * @dev total number of tokens in existence
131   */
132   function totalSupply() public view returns (uint256) {
133     return totalSupply_;
134   }
135 
136   /**
137   * @dev transfer token for a specified address
138   * @param _to The address to transfer to.
139   * @param _value The amount to be transferred.
140   */
141   function transfer(address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[msg.sender]);
144 
145     // SafeMath.sub will throw if there is not enough balance.
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param _owner The address to query the the balance of.
155   * @return An uint256 representing the amount owned by the passed address.
156   */
157   function balanceOf(address _owner) public view returns (uint256 balance) {
158     return balances[_owner];
159   }
160 
161 }
162 
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173   mapping (address => mapping (address => uint256)) internal allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183     require(_to != address(0));
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186 
187     balances[_from] = balances[_from].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190     Transfer(_from, _to, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    *
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(address _owner, address _spender) public view returns (uint256) {
217     return allowed[_owner][_spender];
218   }
219 
220   /**
221    * @dev Increase the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To increment
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _addedValue The amount of tokens to increase the allowance by.
229    */
230   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
231     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    *
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
247     uint oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue > oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257 }
258 
259 
260 
261 contract KanadeCoin is StandardToken, Ownable {
262     using SafeMath for uint256;
263 
264     struct VoteStruct {
265         uint128 number;
266         uint256 amount;
267         address from;
268         uint128 time;
269     }
270 
271     struct QuestionStruct {
272         uint8   isStarted;
273         address recipient;
274         uint128 finish;
275         uint    under;
276         VoteStruct[] votes;
277     }
278 
279     struct RandomBoxStruct {
280         uint8   isStarted;
281         address recipient;
282         uint64  volume;
283         uint256 amount;
284         uint128 finish;
285     }
286 
287     struct RandomItemStruct {
288         mapping(bytes32 => uint256[]) values;
289     }
290 
291 
292     address public constant addrDevTeam      = 0x4d85FCF252c02FA849258f16c5464aF529ebFA5F; // 1%
293     address public constant addrLockUp       = 0x0101010101010101010101010101010101010101; // 9%
294     address public constant addrBounty       = 0x3CCDb82F43EEF681A39AE854Be37ad1C40446F0d; // 25%
295     address public constant addrDistribution = 0x9D6FB734a716306a9575E3ce971AB8839eDcEdF3; // 10%
296     address public constant addrAirDrop      = 0xD6A4ce07f18619Ec73f91CcDbefcCE53f048AE05; // 55%
297 
298     uint public constant atto = 100000000;
299     uint public constant decimals = 8;
300 
301     string public constant name   = "KanadeCoin";
302     string public constant symbol = "KNDC";
303 
304     uint public contractStartTime;
305 
306     uint64 public constant lockupSeconds = 60 * 60 * 24 * 365 * 3;
307 
308     mapping(bytes32 => QuestionStruct) questions;
309     mapping(address => string) saveData;
310     mapping(bytes32 => RandomBoxStruct) randomBoxes;
311     mapping(address => RandomItemStruct) randomItems;
312 
313     constructor() public {
314     }
315 
316     function initializeContract() onlyOwner public {
317         if (totalSupply_ != 0) return;
318 
319         contractStartTime = now;
320 
321         balances[addrDevTeam]      = 10000000000 * 0.01 * atto;
322         balances[addrLockUp]       = 10000000000 * 0.09 * atto;
323         balances[addrBounty]       = 10000000000 * 0.25 * atto;
324         balances[addrDistribution] = 10000000000 * 0.10 * atto;
325         balances[addrAirDrop]      = 10000000000 * 0.55 * atto;
326 
327         Transfer(0x0, addrDevTeam, balances[addrDevTeam]);
328         Transfer(0x0, addrLockUp, balances[addrLockUp]);
329         Transfer(0x0, addrBounty, balances[addrBounty]);
330         Transfer(0x0, addrDistribution, balances[addrDistribution]);
331         Transfer(0x0, addrAirDrop, balances[addrAirDrop]);
332 
333         totalSupply_ = 10000000000 * atto;
334     }
335 
336 
337     ////////////////////////////////////////////////////////////////////////
338 
339     function unLockup() onlyOwner public {
340         require(uint256(now).sub(lockupSeconds) > contractStartTime);
341         uint _amount = balances[addrLockUp];
342         balances[addrLockUp] = balances[addrLockUp].sub(_amount);
343         balances[addrDevTeam] = balances[addrDevTeam].add(_amount);
344         Transfer(addrLockUp, addrDevTeam, _amount);
345     }
346 
347 
348     ////////////////////////////////////////////////////////////////////////
349 
350     function createQuestion(string _id_max32, address _recipient, uint128 _finish, uint _under) public {
351         bytes32 _idByte = keccak256(_id_max32);
352         require(questions[_idByte].isStarted == 0);
353 
354         transfer(addrBounty, 5000 * atto);
355 
356         questions[_idByte].isStarted = 1;
357         questions[_idByte].recipient = _recipient;
358         questions[_idByte].finish = _finish;
359         questions[_idByte].under = _under;
360     }
361 
362     function getQuestion(string _id_max32) constant public returns (uint[4]) {
363         bytes32 _idByte = keccak256(_id_max32);
364         uint[4] values;
365         values[0] = questions[_idByte].isStarted;
366         values[1] = uint(questions[_idByte].recipient);
367         values[2] = questions[_idByte].finish;
368         values[3] = questions[_idByte].under;
369         return values;
370     }
371 
372     function vote(string _id_max32, uint128 _number, uint _amount) public {
373         bytes32 _idByte = keccak256(_id_max32);
374         require(
375             questions[_idByte].isStarted == 1 &&
376             questions[_idByte].under <= _amount &&
377             questions[_idByte].finish >= uint128(now));
378 
379         if (_amount > 0) {
380             transfer(questions[_idByte].recipient, _amount);
381         }
382 
383         questions[_idByte].votes.push(VoteStruct(_number, _amount, msg.sender, uint128(now)));
384     }
385 
386     function getQuestionVotesAllCount(string _id_max32) constant public returns (uint) {
387         return questions[keccak256(_id_max32)].votes.length;
388     }
389 
390     function getQuestionVote(string _id_max32, uint _position) constant public returns (uint[4]) {
391         bytes32 _idByte = keccak256(_id_max32);
392         uint[4] values;
393         values[0] = questions[_idByte].votes[_position].number;
394         values[1] = questions[_idByte].votes[_position].amount;
395         values[2] = uint(questions[_idByte].votes[_position].from);
396         values[3] = questions[_idByte].votes[_position].time;
397         return values;
398     }
399 
400 
401     ////////////////////////////////////////////////////////////////////////
402 
403     function putSaveData(string _text) public {
404         saveData[msg.sender] = _text;
405     }
406 
407     function getSaveData(address _address) constant public returns (string) {
408         return saveData[_address];
409     }
410 
411 
412     ////////////////////////////////////////////////////////////////////////
413 
414     function createRandomBox(string _id_max32, address _recipient, uint64 _volume, uint256 _amount, uint128 _finish) public {
415         require(_volume > 0);
416 
417         bytes32 _idByte = keccak256(_id_max32);
418         require(randomBoxes[_idByte].isStarted == 0);
419 
420         transfer(addrBounty, 5000 * atto);
421 
422         randomBoxes[_idByte].isStarted = 1;
423         randomBoxes[_idByte].recipient = _recipient;
424         randomBoxes[_idByte].volume = _volume;
425         randomBoxes[_idByte].amount = _amount;
426         randomBoxes[_idByte].finish = _finish;
427     }
428 
429     function getRandomBox(string _id_max32) constant public returns (uint[5]) {
430         bytes32 _idByte = keccak256(_id_max32);
431         uint[5] values;
432         values[0] = randomBoxes[_idByte].isStarted;
433         values[1] = uint(randomBoxes[_idByte].recipient);
434         values[2] = randomBoxes[_idByte].volume;
435         values[3] = randomBoxes[_idByte].amount;
436         values[4] = randomBoxes[_idByte].finish;
437         return values;
438     }
439 
440     function drawRandomItem(string _id_max32, uint _count) public {
441         require(_count > 0 && _count <= 1000);
442 
443         bytes32 _idByte = keccak256(_id_max32);
444         uint _totalAmount = randomBoxes[_idByte].amount.mul(_count);
445         require(
446             randomBoxes[_idByte].isStarted == 1 &&
447             randomBoxes[_idByte].finish >= uint128(now));
448 
449         transfer(randomBoxes[_idByte].recipient, _totalAmount);
450 
451         for (uint i = 0; i < _count; i++) {
452             uint randomVal = uint(
453                 keccak256(blockhash(block.number-1), randomItems[msg.sender].values[_idByte].length))
454                 % randomBoxes[_idByte].volume;
455             randomItems[msg.sender].values[_idByte].push(randomVal);
456         }
457     }
458 
459     function getRandomItems(address _addrss, string _id_max32) constant public returns (uint[]) {
460         return randomItems[_addrss].values[keccak256(_id_max32)];
461     }
462 
463 
464     ////////////////////////////////////////////////////////////////////////
465 
466     function airDrop(address[] _recipients, uint[] _values) onlyOwner public returns (bool) {
467         return distribute(addrAirDrop, _recipients, _values);
468     }
469 
470     function rain(address[] _recipients, uint[] _values) public returns (bool) {
471         return distribute(msg.sender, _recipients, _values);
472     }
473 
474     function distribute(address _from, address[] _recipients, uint[] _values) internal returns (bool) {
475         require(_recipients.length > 0 && _recipients.length == _values.length);
476 
477         uint total = 0;
478         for(uint i = 0; i < _values.length; i++) {
479             total = total.add(_values[i]);
480         }
481         require(total <= balances[_from]);
482 
483         for(uint j = 0; j < _recipients.length; j++) {
484             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
485             Transfer(_from, _recipients[j], _values[j]);
486         }
487 
488         balances[_from] = balances[_from].sub(total);
489 
490         return true;
491     }
492 
493 }