1 pragma solidity 0.4.23;
2 ///////////////////////////////////////
3 //Written by f.antonio.akel@gmail.com//
4 ///////////////////////////////////////
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
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
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /*
52     Owned contract interface
53 */
54 contract IOwned {
55     // this function isn't abstract since the compiler emits automatically generated getter functions as external
56     function owner() public view returns (address) {}
57 
58     function transferOwnership(address _newOwner) public;
59     function acceptOwnership() public;
60 }
61 
62 /*
63     Bancor Converter interface
64 */
65 contract IBancorConverter{
66 
67     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256);
68 	function quickConvert(address[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
69 
70 }
71 /*
72     Bancor Quick Converter interface
73 */
74 contract IBancorQuickConverter {
75     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
76     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
77     function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) public payable returns (uint256);
78 }
79 
80 /*
81     Bancor Gas tools interface
82 */
83 contract IBancorGasPriceLimit {
84     function gasPrice() public view returns (uint256) {}
85     function validateGasPrice(uint256) public view;
86 }
87 
88 /*
89     EIP228 Token Converter interface
90 */
91 contract ITokenConverter {
92     function convertibleTokenCount() public view returns (uint16);
93     function convertibleToken(uint16 _tokenIndex) public view returns (address);
94     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
95     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
96     // deprecated, backward compatibility
97     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
98 }
99 
100 /*
101     ERC20 Standard Token interface
102 */
103 contract IERC20Token {
104     function balanceOf(address _owner) public view returns (uint256);
105     function allowance(address _owner, address _spender) public view returns (uint256);
106     function transfer(address _to, uint256 _value) public returns (bool success);
107     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
108     function approve(address _spender, uint256 _value) public returns (bool success);
109 }
110 
111 /*
112     Smart Token interface
113 */
114 contract ISmartToken is IOwned, IERC20Token {
115     function disableTransfers(bool _disable) public;
116     function issue(address _to, uint256 _amount) public;
117     function destroy(address _from, uint256 _amount) public;
118 }
119 
120 /**
121 * @title Admin parameters
122 * @dev Define administration parameters for this contract
123 */
124 contract admined { //This token contract is administered
125     address public admin; //Admin address is public
126 
127     /**
128     * @dev Contract constructor
129     * define initial administrator
130     */
131     constructor() internal {
132         admin = msg.sender; //Set initial admin to contract creator
133         emit Admined(admin);
134     }
135 
136     modifier onlyAdmin() { //A modifier to define admin-only functions
137         require(msg.sender == admin);
138         _;
139     }
140 
141    /**
142     * @dev Function to set new admin address
143     * @param _newAdmin The address to transfer administration to
144     */
145     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
146         require(_newAdmin != 0);
147         admin = _newAdmin;
148         emit TransferAdminship(admin);
149     }
150 
151     event TransferAdminship(address newAdminister);
152     event Admined(address administer);
153 
154 }
155 
156 
157 /**
158 * @title ERC20Token
159 * @notice Token definition contract
160 */
161 contract MEGA is admined,IERC20Token { //Standar definition of an ERC20Token
162     using SafeMath for uint256; //SafeMath is used for uint256 operations
163 
164 ///////////////////////////////////////////////////////////////////////////////////////
165 ///									Token Related									///
166 ///////////////////////////////////////////////////////////////////////////////////////
167 
168     mapping (address => uint256) balances; //A mapping of all balances per address
169     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
170     uint256 public totalSupply;
171     
172     /**
173     * @notice Get the balance of an _owner address.
174     * @param _owner The address to be query.
175     */
176     function balanceOf(address _owner) public constant returns (uint256 bal) {
177         return balances[_owner];
178     }
179 
180     /**
181     * @notice transfer _value tokens to address _to
182     * @param _to The address to transfer to.
183     * @param _value The amount to be transferred.
184     * @return success with boolean value true if done
185     */
186     function transfer(address _to, uint256 _value) public returns (bool success) {
187         require(_to != address(0)); //If you dont want that people destroy token
188         
189         if(_to == address(this)){
190         	burnToken(msg.sender, _value);
191         	sell(msg.sender,_value);
192         	return true;
193         } else {
194             balances[msg.sender] = balances[msg.sender].sub(_value);
195 	        balances[_to] = balances[_to].add(_value);
196     	    emit Transfer(msg.sender, _to, _value);
197         	return true;
198 
199         }
200     }
201 
202     /**
203     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
204     * @param _from The address where tokens comes.
205     * @param _to The address to transfer to.
206     * @param _value The amount to be transferred.
207     * @return success with boolean value true if done
208     */
209     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
210         require(_to != address(0)); //If you dont want that people destroy token
211         balances[_from] = balances[_from].sub(_value);
212         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
213         balances[_to] = balances[_to].add(_value);
214         emit Transfer(_from, _to, _value);
215         return true;
216     }
217 
218     /**
219     * @notice Assign allowance _value to _spender address to use the msg.sender balance
220     * @param _spender The address to be allowed to spend.
221     * @param _value The amount to be allowed.
222     * @return success with boolean value true
223     */
224     function approve(address _spender, uint256 _value) public returns (bool success) {
225     	require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
226         allowed[msg.sender][_spender] = _value;
227         emit Approval(msg.sender, _spender, _value);
228         return true;
229     }
230 
231     /**
232     * @notice Get the allowance of an specified address to use another address balance.
233     * @param _owner The address of the owner of the tokens.
234     * @param _spender The address of the allowed spender.
235     * @return remaining with the allowance value
236     */
237     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
238         return allowed[_owner][_spender];
239     }
240 
241     /**
242     * @dev Mint token to an specified address.
243     * @param _target The address of the receiver of the tokens.
244     * @param _mintedAmount amount to mint.
245     */
246     function mintToken(address _target, uint256 _mintedAmount) private {
247         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
248         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
249         emit Transfer(0, this, _mintedAmount);
250         emit Transfer(this, _target, _mintedAmount);
251     }
252 
253     /**
254     * @dev Burn token of an specified address.
255     * @param _target The address of the holder of the tokens.
256     * @param _burnedAmount amount to burn.
257     */
258     function burnToken(address _target, uint256 _burnedAmount) private {
259         balances[_target] = SafeMath.sub(balances[_target], _burnedAmount);
260         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
261         emit Burned(_target, _burnedAmount);
262     }
263 
264     /**
265     * @dev Log Events
266     */
267     event Transfer(address indexed _from, address indexed _to, uint256 _value);
268     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
269     event Burned(address indexed _target, uint256 _value);
270 
271 ///////////////////////////////////////////////////////////////////////////////////////
272 ///								Investment related									///
273 ///////////////////////////////////////////////////////////////////////////////////////
274 
275 	//Internal Variables
276 	IBancorConverter BancorConverter = IBancorConverter(0xc6725aE749677f21E4d8f85F41cFB6DE49b9Db29);
277 	IBancorQuickConverter Bancor = IBancorQuickConverter(0xcF1CC6eD5B653DeF7417E3fA93992c3FFe49139B);
278 	IBancorGasPriceLimit BancorGas = IBancorGasPriceLimit(0x607a5C47978e2Eb6d59C6C6f51bc0bF411f4b85a);
279 
280 	IERC20Token ETHToken = IERC20Token(0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315);
281 
282 	IERC20Token BNTToken = IERC20Token(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C);
283 
284 	IERC20Token EOSRelay = IERC20Token(0x507b06c23d7Cb313194dBF6A6D80297137fb5E01);
285 	IERC20Token EOSToken = IERC20Token(0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0);
286 
287 	IERC20Token ELFRelay = IERC20Token(0x0F2318565f1996CB1eD2F88e172135791BC1FcBf);
288 	IERC20Token ELFToken = IERC20Token(0xbf2179859fc6D5BEE9Bf9158632Dc51678a4100e);
289 
290 	IERC20Token OMGRelay = IERC20Token(0x99eBD396Ce7AA095412a4Cd1A0C959D6Fd67B340);
291 	IERC20Token OMGToken = IERC20Token(0xd26114cd6EE289AccF82350c8d8487fedB8A0C07);
292 
293 	IERC20Token POARelay = IERC20Token(0x564c07255AFe5050D82c8816F78dA13f2B17ac6D);
294 	IERC20Token POAToken = IERC20Token(0x6758B7d441a9739b98552B373703d8d3d14f9e62);
295 
296 	IERC20Token DRGNRelay = IERC20Token(0xa7774F9386E1653645E1A08fb7Aae525B4DeDb24);
297 	IERC20Token DRGNToken = IERC20Token(0x419c4dB4B9e25d6Db2AD9691ccb832C8D9fDA05E);
298 
299 	IERC20Token SRNRelay = IERC20Token(0xd2Deb679ed81238CaeF8E0c32257092cEcc8888b);
300 	IERC20Token SRNToken = IERC20Token(0x68d57c9a1C35f63E2c83eE8e49A64e9d70528D25);
301 
302 	IERC20Token WAXRelay = IERC20Token(0x67563E7A0F13642068F6F999e48c690107A4571F);
303 	IERC20Token WAXToken = IERC20Token(0x39Bb259F66E1C59d5ABEF88375979b4D20D98022);
304 
305 	IERC20Token POWRRelay = IERC20Token(0x168D7Bbf38E17941173a352f1352DF91a7771dF3);
306 	IERC20Token POWRToken = IERC20Token(0x595832F8FC6BF59c85C527fEC3740A1b7a361269);
307 
308 	bool buyFlag = false; //False = set rate - True = auto rate
309 	//Path to exchanges
310 	mapping(uint8 => IERC20Token[]) paths;
311 	mapping(uint8 => IERC20Token[]) reversePaths;
312 
313 
314 	//public variables
315 	address public feeWallet;
316 	uint256 public rate = 6850;
317 	//token related
318 	string public name = "MEGAINVEST v4";
319     uint8 public decimals = 18;
320     string public symbol = "MEG4";
321     string public version = '2';
322 
323 	constructor(address _feeWallet) public {
324 		feeWallet = _feeWallet;
325 		paths[0] = [ETHToken,BNTToken,BNTToken,EOSRelay,EOSRelay,EOSRelay,EOSToken];
326     	paths[1] = [ETHToken,BNTToken,BNTToken,ELFRelay,ELFRelay,ELFRelay,ELFToken];
327     	paths[2] = [ETHToken,BNTToken,BNTToken,OMGRelay,OMGRelay,OMGRelay,OMGToken];
328     	paths[3] = [ETHToken,BNTToken,BNTToken,POARelay,POARelay,POARelay,POAToken];
329     	paths[4] = [ETHToken,BNTToken,BNTToken,DRGNRelay,DRGNRelay,DRGNRelay,DRGNToken];
330     	paths[5] = [ETHToken,BNTToken,BNTToken,SRNRelay,SRNRelay,SRNRelay,SRNToken];
331     	paths[6] = [ETHToken,BNTToken,BNTToken,WAXRelay,WAXRelay,WAXRelay,WAXToken];
332     	paths[7] = [ETHToken,BNTToken,BNTToken,POWRRelay,POWRRelay,POWRRelay,POWRToken];
333 
334     	reversePaths[0] = [EOSToken,EOSRelay,EOSRelay,EOSRelay,BNTToken,BNTToken,ETHToken];
335     	reversePaths[1] = [ELFToken,ELFRelay,ELFRelay,ELFRelay,BNTToken,BNTToken,ETHToken];
336     	reversePaths[2] = [OMGToken,OMGRelay,OMGRelay,OMGRelay,BNTToken,BNTToken,ETHToken];
337     	reversePaths[3] = [POAToken,POARelay,POARelay,POARelay,BNTToken,BNTToken,ETHToken];
338     	reversePaths[4] = [DRGNToken,DRGNRelay,DRGNRelay,DRGNRelay,BNTToken,BNTToken,ETHToken];
339     	reversePaths[5] = [SRNToken,SRNRelay,SRNRelay,SRNRelay,BNTToken,BNTToken,ETHToken];
340     	reversePaths[6] = [WAXToken,WAXRelay,WAXRelay,WAXRelay,BNTToken,BNTToken,ETHToken];
341     	reversePaths[7] = [POWRToken,POWRRelay,POWRRelay,POWRRelay,BNTToken,BNTToken,ETHToken];
342 	}
343 
344 	function updateBancorContracts(
345 		IBancorConverter _BancorConverter,
346 		IBancorQuickConverter _Bancor,
347 		IBancorGasPriceLimit _BancorGas) public onlyAdmin{
348 
349 		BancorConverter = _BancorConverter;
350 		Bancor = _Bancor;
351 		BancorGas = _BancorGas;
352 	}
353 
354 	function updatePath(IERC20Token[] _path, IERC20Token[] _reversePath, uint8 _index) public onlyAdmin{
355 		paths[_index] = _path;
356 		reversePaths[_index] = _reversePath;
357 	}
358 
359 	function changeBuyFlag(bool _flag) public onlyAdmin {
360 		buyFlag = _flag;
361 	}
362 	
363 	function updateRate(uint256 _rate) public onlyAdmin {
364 	    rate = _rate;
365 	}
366 
367 	function valueOnContract() public view returns (uint256){
368 
369 		ISmartToken smartToken;
370         IERC20Token toToken;
371         ITokenConverter converter;
372         IERC20Token[] memory _path;
373         uint256 pathLength;
374         uint256 sumUp;
375         uint256 _amount;
376         IERC20Token _fromToken;
377 
378         for(uint8 j=0;j<8;j++){
379         	_path = reversePaths[j];
380         	// iterate over the conversion path
381 	        pathLength = _path.length;
382 	        _fromToken = _path[0];
383 	        _amount = _fromToken.balanceOf(address(this));
384 
385 	        for (uint256 i = 1; i < pathLength; i += 2) {
386 	            smartToken = ISmartToken(_path[i]);
387 	            toToken = _path[i + 1];
388 	            converter = ITokenConverter(smartToken.owner());
389 
390 	            // make the conversion - if it's the last one, also provide the minimum return value
391 	            _amount = converter.getReturn(_fromToken, toToken, _amount);
392 	            _fromToken = toToken;
393 	        }
394 	        
395 	        sumUp += _amount;
396         }
397 
398         return sumUp;
399 
400 	}
401 
402 	function buy() public payable {
403 	    BancorGas.validateGasPrice(tx.gasprice);
404 
405 		if(buyFlag == false){
406 			tokenBuy = msg.value.mul(rate);
407 		} else {
408 
409 			uint256 valueStored = valueOnContract();
410 			uint256 tokenBuy;
411 
412 			if(totalSupply > valueStored){
413 
414 				uint256 tempRate = totalSupply.div(valueStored); // Must be > 0 Tok/Eth
415 				tokenBuy = msg.value.mul(tempRate); // Eth * Tok / Eth = Tok
416 
417 			} else {
418 				
419 				uint256 tempPrice = valueStored.div(totalSupply); // Must be > 0 Eth/Tok
420 				tokenBuy = msg.value.div(tempPrice); // Eth / Eth / Tok = Tok
421 
422 			}
423 		}
424 		
425 
426 		uint256 ethFee = msg.value.mul(5)/1000; //5/1000 => 0.5%
427 		uint256 ethToInvest = msg.value.sub(ethFee);
428 
429 		feeWallet.transfer(ethFee);
430 		invest(ethToInvest);
431 
432 		mintToken(msg.sender,tokenBuy);
433 
434 	}
435 
436 	function invest(uint256 _amount) private {
437 		uint256 standarValue = _amount.div(8);
438 
439 		for(uint8 i=0; i<8; i++){ 
440 			Bancor.convertForPrioritized.value(standarValue)(paths[i],standarValue,1,address(this),0,0,0,0x0,0x0);
441 		}
442 
443 	}
444 
445 	function sell(address _target, uint256 _amount) private {
446 		uint256 tempBalance;
447 		uint256 tempFee;
448 		uint256 dividedSupply = totalSupply.div(1e5); //ethereum is not decimals friendly
449 
450 		if(dividedSupply == 0 || _amount < dividedSupply) revert();
451 		
452 		uint256 factor = _amount.div(dividedSupply);
453 
454 		if( factor == 0) revert();
455 	
456 		tempBalance = EOSToken.balanceOf(this);
457 		tempFee = tempBalance.mul(5);
458 		tempFee = tempFee.div(1000); //0.5%
459 		tempBalance = tempBalance.sub(tempFee);
460 		EOSToken.transfer(feeWallet,tempFee);
461 		EOSToken.transfer(_target,tempBalance);
462 
463 		tempBalance = ELFToken.balanceOf(this);
464 		tempFee = tempBalance.mul(5);
465 		tempFee = tempFee.div(1000); //0.5%
466 		tempBalance = tempBalance.sub(tempFee);
467 		ELFToken.transfer(feeWallet,tempFee);
468 		ELFToken.transfer(_target,tempBalance);
469 
470 		tempBalance = OMGToken.balanceOf(this);
471 		tempFee = tempBalance.mul(5);
472 		tempFee = tempFee.div(1000); //0.5%
473 		tempBalance = tempBalance.sub(tempFee);
474 		OMGToken.transfer(feeWallet,tempFee);
475 		OMGToken.transfer(_target,tempBalance);
476 
477 		tempBalance = POAToken.balanceOf(this);
478 		tempFee = tempBalance.mul(5);
479 		tempFee = tempFee.div(1000); //0.5%
480 		tempBalance = tempBalance.sub(tempFee);
481 		POAToken.transfer(feeWallet,tempFee);
482 		POAToken.transfer(_target,tempBalance);
483 
484 		tempBalance = DRGNToken.balanceOf(this);
485 		tempFee = tempBalance.mul(5);
486 		tempFee = tempFee.div(1000); //0.5%
487 		tempBalance = tempBalance.sub(tempFee);
488 		DRGNToken.transfer(feeWallet,tempFee);
489 		DRGNToken.transfer(_target,tempBalance);
490 
491 		tempBalance = SRNToken.balanceOf(this);
492 		tempFee = tempBalance.mul(5);
493 		tempFee = tempFee.div(1000); //0.5%
494 		tempBalance = tempBalance.sub(tempFee);
495 		SRNToken.transfer(feeWallet,tempFee);
496 		SRNToken.transfer(_target,tempBalance);
497 
498 		tempBalance = WAXToken.balanceOf(this);
499 		tempFee = tempBalance.mul(5);
500 		tempFee = tempFee.div(1000); //0.5%
501 		tempBalance = tempBalance.sub(tempFee);
502 		WAXToken.transfer(feeWallet,tempFee);
503 		WAXToken.transfer(_target,tempBalance);
504 
505 		tempBalance = POWRToken.balanceOf(this);
506 		tempFee = tempBalance.mul(5);
507 		tempFee = tempFee.div(1000); //0.5%
508 		tempBalance = tempBalance.sub(tempFee);
509 		POWRToken.transfer(feeWallet,tempFee);
510 		POWRToken.transfer(_target,tempBalance);
511 	}
512 	
513 	function emergency() onlyAdmin public{
514 		uint256 tempBalance;
515 	    msg.sender.transfer(address(this).balance);
516 	    
517 	    tempBalance = EOSToken.balanceOf(this);
518 		EOSToken.transfer(admin,tempBalance);
519 
520 		tempBalance = ELFToken.balanceOf(this);
521 		ELFToken.transfer(admin,tempBalance);
522 
523 		tempBalance = OMGToken.balanceOf(this);
524 		OMGToken.transfer(admin,tempBalance);
525 
526 		tempBalance = POAToken.balanceOf(this);
527 		POAToken.transfer(admin,tempBalance);
528 
529 		tempBalance = DRGNToken.balanceOf(this);
530 		DRGNToken.transfer(admin,tempBalance);
531 
532 		tempBalance = SRNToken.balanceOf(this);
533 		SRNToken.transfer(admin,tempBalance);
534 
535 		tempBalance = WAXToken.balanceOf(this);
536 		WAXToken.transfer(admin,tempBalance);
537 
538 		tempBalance = POWRToken.balanceOf(this);
539 		POWRToken.transfer(admin,tempBalance);
540 	}
541 	
542     function claimTokens(IERC20Token _address, address _to) onlyAdmin public  {
543         require(_to != address(0));
544         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
545         _address.transfer(_to,remainder); //Transfer tokens to creator
546     }
547 
548 	function () public payable{
549 		buy();
550 	}
551 
552 }