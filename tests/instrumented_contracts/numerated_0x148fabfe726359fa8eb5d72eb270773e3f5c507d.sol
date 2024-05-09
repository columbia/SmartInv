1 pragma solidity 0.5.4;
2 
3 
4 library SafeMath {
5 
6     uint256 constant internal MAX_UINT = 2 ** 256 - 1; // max uint256
7 
8     /**
9      * @dev Multiplies two numbers, reverts on overflow.
10      */
11     function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {
12         if (_a == 0) {
13             return 0;
14         }
15         require(MAX_UINT / _a >= _b);
16         return _a * _b;
17     }
18 
19     /**
20      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
21      */
22     function div(uint256 _a, uint256 _b) internal pure returns(uint256) {
23         require(_b != 0);
24         return _a / _b;
25     }
26 
27     /**
28      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
29      */
30     function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {
31         require(_b <= _a);
32         return _a - _b;
33     }
34 
35     /**
36      * @dev Adds two numbers, reverts on overflow.
37      */
38     function add(uint256 _a, uint256 _b) internal pure returns(uint256) {
39         require(MAX_UINT - _a >= _b);
40         return _a + _b;
41     }
42 
43 }
44 
45 interface AbcInterface {
46     function decimals() external view returns (uint8);
47     function tokenFallback(address _from, uint _value, bytes calldata _data) external;
48     function transfer(address _to, uint _value) external returns (bool);
49 }
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address public owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62      * account.
63      */
64     constructor () public {
65         owner = msg.sender;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      * @param newOwner The address to transfer ownership to.
79      */
80     function transferOwnership(address newOwner) public onlyOwner {
81         _transferOwnership(newOwner);
82     }
83 
84     /**
85      * @dev Transfers control of the contract to a newOwner.
86      * @param newOwner The address to transfer ownership to.
87      */
88     function _transferOwnership(address newOwner) internal {
89         require(newOwner != address(0));
90         emit OwnershipTransferred(owner, newOwner);
91         owner = newOwner;
92     }
93 }
94 
95 
96 contract Pausable is Ownable {
97     event Pause();
98     event Unpause();
99 
100     bool public paused = false;
101 
102     /**
103      * @dev Modifier to make a function callable only when the contract is not paused.
104      */
105     modifier whenNotPaused() {
106         require(!paused);
107         _;
108     }
109 
110     /**
111      * @dev Modifier to make a function callable only when the contract is paused.
112      */
113     modifier whenPaused() {
114         require(paused);
115         _;
116     }
117 
118     /**
119      * @dev called by the owner to pause, triggers stopped state
120      */
121     function pause() public onlyOwner whenNotPaused {
122         paused = true;
123         emit Pause();
124     }
125 
126     /**
127      * @dev called by the owner to unpause, returns to normal state
128      */
129     function unpause() public onlyOwner whenPaused {
130         paused = false;
131         emit Unpause();
132     }
133 }
134 
135 
136 contract StandardToken {
137     using SafeMath for uint256;
138 
139     mapping(address => uint256) internal balances;
140 
141     mapping(address => mapping(address => uint256)) internal allowed;
142 
143     uint256 public totalSupply;
144 
145     event Transfer(address indexed from, address indexed to, uint256 value);
146 
147     event Approval(address indexed owner, address indexed spender, uint256 value);
148 
149     /**
150      * @dev Gets the balance of the specified address.
151      * @param _owner The address to query the the balance of.
152      * @return An uint256 representing the value owned by the passed address.
153      */
154     function balanceOf(address _owner) public view returns(uint256) {
155         return balances[_owner];
156     }
157 
158     /**
159      * @dev Function to check the value of tokens that an owner allowed to a spender.
160      * @param _owner address The address which owns the funds.
161      * @param _spender address The address which will spend the funds.
162      * @return A uint256 specifying the value of tokens still available for the spender.
163      */
164     function allowance(address _owner, address _spender) public view returns(uint256) {
165         return allowed[_owner][_spender];
166     }
167 
168     /**
169      * @dev Transfer token for a specified address
170      * @param _to The address to transfer to.
171      * @param _value The value to be transferred.
172      */
173     function transfer(address _to, uint256 _value) public returns(bool) {
174         require(_to != address(0));
175         require(_value <= balances[msg.sender]);
176 
177         balances[msg.sender] = balances[msg.sender].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         emit Transfer(msg.sender, _to, _value);
180         return true;
181     }
182 
183     /**
184      * @dev Approve the passed address to spend the specified value of tokens on behalf of msg.sender.
185      * Beware that changing an allowance with this method brings the risk that someone may use both the old
186      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
187      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
188      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189      * @param _spender The address which will spend the funds.
190      * @param _value The value of tokens to be spent.
191      */
192     function approve(address _spender, uint256 _value) public returns(bool) {
193         allowed[msg.sender][_spender] = _value;
194         emit Approval(msg.sender, _spender, _value);
195         return true;
196     }
197 
198     /**
199      * @dev Transfer tokens from one address to another
200      * @param _from address The address which you want to send tokens from
201      * @param _to address The address which you want to transfer to
202      * @param _value uint256 the value of tokens to be transferred
203      */
204     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
205         require(_to != address(0));
206         require(_value <= balances[_from]);
207         require(_value <= allowed[_from][msg.sender]);
208 
209         balances[_from] = balances[_from].sub(_value);
210         balances[_to] = balances[_to].add(_value);
211         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212         emit Transfer(_from, _to, _value);
213         return true;
214     }
215 
216     /**
217      * @dev Increase the value of tokens that an owner allowed to a spender.
218      * approve should be called when allowed[_spender] == 0. To increment
219      * allowed value is better to use this function to avoid 2 calls (and wait until
220      * the first transaction is mined)
221      * From MonolithDAO Token.sol
222      * @param _spender The address which will spend the funds.
223      * @param _addedValue The value of tokens to increase the allowance by.
224      */
225     function increaseApproval(address _spender, uint256 _addedValue) public returns(bool) {
226         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
227         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228         return true;
229     }
230 
231     /**
232      * @dev Decrease the value of tokens that an owner allowed to a spender.
233      * approve should be called when allowed[_spender] == 0. To decrement
234      * allowed value is better to use this function to avoid 2 calls (and wait until
235      * the first transaction is mined)
236      * From MonolithDAO Token.sol
237      * @param _spender The address which will spend the funds.
238      * @param _subtractedValue The value of tokens to decrease the allowance by.
239      */
240     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns(bool) {
241         uint256 oldValue = allowed[msg.sender][_spender];
242         if (_subtractedValue >= oldValue) {
243             allowed[msg.sender][_spender] = 0;
244         } else {
245             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246         }
247         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248         return true;
249     }
250 
251     function _burn(address account, uint256 value) internal {
252         require(account != address(0));
253         totalSupply = totalSupply.sub(value);
254         balances[account] = balances[account].sub(value);
255         emit Transfer(account, address(0), value);
256     }
257 
258     /**
259      * @dev Internal function that burns an value of the token of a given
260      * account, deducting from the sender's allowance for said account. Uses the
261      * internal burn function.
262      * @param account The account whose tokens will be burnt.
263      * @param value The value that will be burnt.
264      */
265     function _burnFrom(address account, uint256 value) internal {
266         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
267         // this function needs to emit an event with the updated approval.
268         allowed[account][msg.sender] = allowed[account][msg.sender].sub(value);
269         _burn(account, value);
270     }
271 
272 }
273 
274 
275 contract BurnableToken is StandardToken {
276 
277     /**
278      * @dev Burns a specific value of tokens.
279      * @param value The value of token to be burned.
280      */
281     function burn(uint256 value) public {
282         _burn(msg.sender, value);
283     }
284 
285     /**
286      * @dev Burns a specific value of tokens from the target address and decrements allowance
287      * @param from address The address which you want to send tokens from
288      * @param value uint256 The value of token to be burned
289      */
290     function burnFrom(address from, uint256 value) public {
291         _burnFrom(from, value);
292     }
293 }
294 
295 
296 /**
297  * @title Pausable token
298  * @dev ERC20 modified with pausable transfers.
299  */
300 contract PausableToken is StandardToken, Pausable {
301     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
302         return super.transfer(to, value);
303     }
304 
305     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
306         return super.transferFrom(from, to, value);
307     }
308 
309     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
310         return super.approve(spender, value);
311     }
312 
313     function increaseApproval(address spender, uint256 addedValue) public whenNotPaused returns (bool success) {
314         return super.increaseApproval(spender, addedValue);
315     }
316 
317     function decreaseApproval(address spender, uint256 subtractedValue) public whenNotPaused returns (bool success) {
318         return super.decreaseApproval(spender, subtractedValue);
319     }
320 }
321 
322 contract Token is PausableToken, BurnableToken {
323     string public name; // name of Token
324     string public symbol; // symbol of Token
325     uint8 public decimals;
326 
327     constructor(string memory _name, string memory _symbol, uint8 _decimals) public {
328         name = _name;
329         symbol = _symbol;
330         decimals = _decimals;
331     }
332 }
333 
334 contract BDR is Token {
335     struct Trx {
336         bool executed;
337         address from;
338         uint256 value;
339         address[] signers;
340     }
341 
342     mapping(address => bool) public isSigner;
343     mapping(uint256 => Trx) public exchangeTrx;
344     address public AbcInstance;  // address of AbcToken
345     uint256 public requestSigners = 2;  // BDR => Abc need signers number
346     uint256 public applyCounts = 0;  // Sequence of exchange request
347     mapping(address => uint256) public exchangeLock;
348 
349     event SetSigner(address indexed signer,bool isSigner);  // emit when add/remove signer
350     event ApplyExchangeToken(address indexed from,uint256 value,uint256 trxSeq);  // emit when exchange successful
351     event ConfirmTrx(address indexed signer,uint256 indexed trxSeq);  // emit when signer confirmed exchange request
352     event CancleConfirmTrx(address indexed signer,uint256 indexed trxSeq);  // emit when signer cancles confirmed exchange request
353     event CancleExchangeRequest(address indexed signer,uint256 indexed trxSeq);  // emit when signer/requester cancles exchange request
354     event TokenExchange(address indexed from,uint256 value,bool AbcExchangeBDR); // emit when Abc <=> Bdr,true:Abc => BDR,false:BDR => abc
355     event Mint(address indexed target,uint256 value);
356 
357     modifier onlySigner() {
358         require(isSigner[msg.sender]);
359         _;
360     }
361     /**
362      * @dev initialize token info
363      * @param _name string The name of token
364      * @param _symbol string The symbol of token
365      * @param _decimals uint8 The decimals of token
366      */
367     constructor(string memory _name, string memory _symbol, uint8 _decimals) Token(_name,_symbol,_decimals) public {
368     }
369 
370     /**
371      * @dev rewrite transfer function，user can't transfer token to AbcToken's address directly
372      */
373     function transfer(address _to,uint256 _value) public returns (bool success) {
374         require(_to != AbcInstance,"can't transfer to AbcToken address directly");
375         return super.transfer(_to,_value);
376     }
377 
378     /**
379      * @dev rewrite transferFrom function，user can't transferFrom token to AbcToken's address directly
380      */
381     function transferFrom(address _from, address _to,uint256 _value) public returns (bool success) {
382         require(_to != AbcInstance,"can't transferFrom to AbcToken address directly");
383         return super.transferFrom(_from,_to,_value);
384     }
385 
386     /**
387      * @dev set AbcToken's address
388      */
389     function setAbcInstance(address _abc) public onlyOwner {
390         require(_abc != address(0));
391         AbcInstance = _abc;
392     }
393 
394     /**
395      * @dev add/remove signers
396      * @param _signers address[] The array of signers to add/remove
397      * @param _addSigner bool true:add signers,false:remove:signers
398      */
399     function setSigners(address[] memory _signers,bool _addSigner) public onlyOwner {
400         for(uint256 i = 0;i< _signers.length;i++){
401             require(_signers[i] != address(0));
402             isSigner[_signers[i]] = _addSigner;
403             emit SetSigner(_signers[i],_addSigner);
404         }
405     }
406 
407     /**
408      * @dev set the number of exchange request in order to execute
409      * @param _requestSigners uint256 The number of signers
410      */
411     function setrequestSigners(uint256 _requestSigners) public onlyOwner {
412         require(_requestSigners != 0);
413         requestSigners = _requestSigners;
414     }
415 
416     /**
417      * @dev check whether the signer confirmed this exchange request
418      */
419     function isConfirmer(uint256 _trxSeq,address _signer) public view returns (bool) {
420         require(exchangeTrx[_trxSeq].from != address(0),"trxSeq not exist");
421         for(uint256 i = 0;i < exchangeTrx[_trxSeq].signers.length;i++){
422             if(exchangeTrx[_trxSeq].signers[i] == _signer){
423                 return true;
424             }
425         }
426         return false;
427     }
428 
429     /**
430      * @dev get how many signers that confirmed this exchange request
431      */
432     function getConfirmersLengthOfTrx(uint256 _trxSeq) public view returns (uint256) {
433         return exchangeTrx[_trxSeq].signers.length;
434     }
435 
436     /**
437      * @dev get signers's address that confirmed this exchange request
438      * @param _trxSeq uint256 the Sequence of exchange request
439      * @param _index uint256 the index of signers
440      */
441     function getConfirmerOfTrx(uint256 _trxSeq,uint256 _index) public view returns (address) {
442         require(_index < getConfirmersLengthOfTrx(_trxSeq),"out of range");
443         return exchangeTrx[_trxSeq].signers[_index];
444     }
445 
446     /**
447      * @dev apply BDR exchange Abc
448      * @param _value uint256 amount of BDR to exchange
449      * @return uint256 the sequence of exchange request
450      */
451     function applyExchangeToken(uint256 _value) public whenNotPaused returns (uint256) {
452         uint256 trxSeq = applyCounts;
453         require(exchangeTrx[trxSeq].from == address(0),"trxSeq already exist");
454         require(balances[msg.sender] >= _value);
455         exchangeTrx[trxSeq].executed = false;
456         exchangeTrx[trxSeq].from = msg.sender;
457         exchangeTrx[trxSeq].value = _value;
458         applyCounts = applyCounts.add(1);
459         balances[address(this)] = balances[address(this)].add(_value);
460         balances[exchangeTrx[trxSeq].from] = balances[exchangeTrx[trxSeq].from].sub(_value);
461         exchangeLock[exchangeTrx[trxSeq].from] = exchangeLock[exchangeTrx[trxSeq].from].add(_value);
462         emit ApplyExchangeToken(exchangeTrx[trxSeq].from,exchangeTrx[trxSeq].value,trxSeq);
463         emit Transfer(msg.sender,address(this),_value);
464         return trxSeq;
465     }
466 
467     /**
468      * @dev signer confirms one exchange request
469      * @param _trxSeq uint256 the Sequence of exchange request
470      */
471     function confirmExchangeTrx(uint256 _trxSeq) public onlySigner {
472         require(exchangeTrx[_trxSeq].from != address(0),"_trxSeq not exist");
473         require(exchangeTrx[_trxSeq].signers.length < requestSigners,"trx already has enough signers");
474         require(exchangeTrx[_trxSeq].executed == false,"trx already executed");
475         require(isConfirmer(_trxSeq, msg.sender) == false,"signer already confirmed");
476         exchangeTrx[_trxSeq].signers.push(msg.sender);
477         emit ConfirmTrx(msg.sender, _trxSeq);
478     }
479 
480     /**
481      * @dev signer cancel confirmed exchange request
482      * @param _trxSeq uint256 the Sequence of exchange request
483      */
484     function cancelConfirm(uint256 _trxSeq) public onlySigner {
485         require(exchangeTrx[_trxSeq].from != address(0),"_trxSeq not exist");
486         require(isConfirmer(_trxSeq, msg.sender),"Signer didn't confirm");
487         require(exchangeTrx[_trxSeq].executed == false,"trx already executed");
488         uint256 len = exchangeTrx[_trxSeq].signers.length;
489         for(uint256 i = 0;i < len;i++){
490             if(exchangeTrx[_trxSeq].signers[i] == msg.sender){
491                 exchangeTrx[_trxSeq].signers[i] = exchangeTrx[_trxSeq].signers[len.sub(1)] ;
492                 exchangeTrx[_trxSeq].signers.length --;
493                 break;
494             }
495         }
496         emit CancleConfirmTrx(msg.sender,_trxSeq);
497     }
498 
499     /**
500      * @dev signer cancel exchange request
501      * @param _trxSeq uint256 the Sequence of exchange request
502      */
503     function cancleExchangeRequest(uint256 _trxSeq) public {
504         require(exchangeTrx[_trxSeq].from != address(0),"_trxSeq not exist");
505         require(exchangeTrx[_trxSeq].executed == false,"trx already executed");
506         require(isSigner[msg.sender] || exchangeTrx[_trxSeq].from == msg.sender);
507         balances[address(this)] = balances[address(this)].sub(exchangeTrx[_trxSeq].value);
508         balances[exchangeTrx[_trxSeq].from] = balances[exchangeTrx[_trxSeq].from].add(exchangeTrx[_trxSeq].value);
509         exchangeLock[exchangeTrx[_trxSeq].from] = exchangeLock[exchangeTrx[_trxSeq].from].sub(exchangeTrx[_trxSeq].value);
510         delete exchangeTrx[_trxSeq];
511         emit CancleExchangeRequest(msg.sender,_trxSeq);
512         emit Transfer(address(this),exchangeTrx[_trxSeq].from,exchangeTrx[_trxSeq].value);
513     }
514 
515     /**
516      * @dev execute exchange request which confirmed by enough signers
517      * @param _trxSeq uint256 the Sequence of exchange request
518      */
519     function executeExchangeTrx(uint256 _trxSeq) public whenNotPaused{
520         address from = exchangeTrx[_trxSeq].from;
521         uint256 value = exchangeTrx[_trxSeq].value;
522         require(from != address(0),"trxSeq not exist");
523         require(exchangeTrx[_trxSeq].executed == false,"trxSeq has executed");
524         require(exchangeTrx[_trxSeq].signers.length >= requestSigners);
525         require(from == msg.sender|| isSigner[msg.sender]);
526         require(value <= balances[address(this)]);
527         _burn(address(this), value);
528         exchangeLock[from] = exchangeLock[from].sub(value);
529         exchangeTrx[_trxSeq].executed = true;
530         AbcInterface(AbcInstance).tokenFallback(from,value,bytes(""));
531         emit TokenExchange(exchangeTrx[_trxSeq].from,exchangeTrx[_trxSeq].value,false);
532     }
533 
534     /**
535      * @dev exchange Abc token to BDR token,only AbcInstance can invoke this function
536      */
537     function tokenFallback(address _from, uint _value, bytes memory) public {
538         require(msg.sender == AbcInstance);
539         require(_from != address(0));
540         require(_value > 0);
541         uint256 exchangeAmount = _value.mul(10**uint256(decimals)).div(10**uint256(AbcInterface(AbcInstance).decimals()));
542         _mint(_from, exchangeAmount);
543         emit Transfer(address(0x00),_from,exchangeAmount);
544         emit TokenExchange(_from,_value,true);
545     }
546 
547     /**
548      * @dev mint BDR token
549      */
550     function _mint(address target, uint256 value ) internal {
551         balances[target] = balances[target].add(value);
552         totalSupply = totalSupply.add(value);
553         emit Mint(target,value);
554     }
555 }