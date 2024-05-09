1 pragma solidity 0.4.23;
2 ///////////////////////////////
3 //By f.antonio.akel@gmail.com//
4 ///////////////////////////////
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
104     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
105     function name() public view returns (string) {}
106     function symbol() public view returns (string) {}
107     function decimals() public view returns (uint8) {}
108     function totalSupply() public view returns (uint256) {}
109     function balanceOf(address _owner) public view returns (uint256) { _owner; }
110     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
111 
112     function transfer(address _to, uint256 _value) public returns (bool success);
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
114     function approve(address _spender, uint256 _value) public returns (bool success);
115 }
116 
117 /*
118     Smart Token interface
119 */
120 contract ISmartToken is IOwned, IERC20Token {
121     function disableTransfers(bool _disable) public;
122     function issue(address _to, uint256 _amount) public;
123     function destroy(address _from, uint256 _amount) public;
124 }
125 
126 /**
127 * @title Admin parameters
128 * @dev Define administration parameters for this contract
129 */
130 contract admined { //This token contract is administered
131     address public admin; //Admin address is public
132 
133     /**
134     * @dev Contract constructor
135     * define initial administrator
136     */
137     constructor() internal {
138         admin = msg.sender; //Set initial admin to contract creator
139         emit Admined(admin);
140     }
141 
142     modifier onlyAdmin() { //A modifier to define admin-only functions
143         require(msg.sender == admin);
144         _;
145     }
146 
147    /**
148     * @dev Function to set new admin address
149     * @param _newAdmin The address to transfer administration to
150     */
151     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
152         require(_newAdmin != 0);
153         admin = _newAdmin;
154         emit TransferAdminship(admin);
155     }
156 
157     event TransferAdminship(address newAdminister);
158     event Admined(address administer);
159 
160 }
161 
162 
163 /**
164 * @title ERC20Token
165 * @notice Token definition contract
166 */
167 contract MEGA is admined,IERC20Token { //Standar definition of an ERC20Token
168     using SafeMath for uint256; //SafeMath is used for uint256 operations
169 
170 ///////////////////////////////////////////////////////////////////////////////////////
171 ///									Token Related									///
172 ///////////////////////////////////////////////////////////////////////////////////////
173 
174     mapping (address => uint256) balances; //A mapping of all balances per address
175     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
176     uint256 public totalSupply;
177     
178     /**
179     * @notice Get the balance of an _owner address.
180     * @param _owner The address to be query.
181     */
182     function balanceOf(address _owner) public constant returns (uint256 bal) {
183         return balances[_owner];
184     }
185 
186     /**
187     * @notice transfer _value tokens to address _to
188     * @param _to The address to transfer to.
189     * @param _value The amount to be transferred.
190     * @return success with boolean value true if done
191     */
192     function transfer(address _to, uint256 _value) public returns (bool success) {
193         require(_to != address(0)); //If you dont want that people destroy token
194         
195         if(_to == address(this)){
196         	burnToken(msg.sender, _value);
197         	sell(msg.sender,_value);
198         	return true;
199         } else {
200             balances[msg.sender] = balances[msg.sender].sub(_value);
201 	        balances[_to] = balances[_to].add(_value);
202     	    emit Transfer(msg.sender, _to, _value);
203         	return true;
204 
205         }
206     }
207 
208     /**
209     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
210     * @param _from The address where tokens comes.
211     * @param _to The address to transfer to.
212     * @param _value The amount to be transferred.
213     * @return success with boolean value true if done
214     */
215     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
216         require(_to != address(0)); //If you dont want that people destroy token
217         balances[_from] = balances[_from].sub(_value);
218         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
219         balances[_to] = balances[_to].add(_value);
220         emit Transfer(_from, _to, _value);
221         return true;
222     }
223 
224     /**
225     * @notice Assign allowance _value to _spender address to use the msg.sender balance
226     * @param _spender The address to be allowed to spend.
227     * @param _value The amount to be allowed.
228     * @return success with boolean value true
229     */
230     function approve(address _spender, uint256 _value) public returns (bool success) {
231     	require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
232         allowed[msg.sender][_spender] = _value;
233         emit Approval(msg.sender, _spender, _value);
234         return true;
235     }
236 
237     /**
238     * @notice Get the allowance of an specified address to use another address balance.
239     * @param _owner The address of the owner of the tokens.
240     * @param _spender The address of the allowed spender.
241     * @return remaining with the allowance value
242     */
243     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
244         return allowed[_owner][_spender];
245     }
246 
247     /**
248     * @dev Mint token to an specified address.
249     * @param _target The address of the receiver of the tokens.
250     * @param _mintedAmount amount to mint.
251     */
252     function mintToken(address _target, uint256 _mintedAmount) private {
253         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
254         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
255         emit Transfer(0, this, _mintedAmount);
256         emit Transfer(this, _target, _mintedAmount);
257     }
258 
259     /**
260     * @dev Burn token of an specified address.
261     * @param _target The address of the holder of the tokens.
262     * @param _burnedAmount amount to burn.
263     */
264     function burnToken(address _target, uint256 _burnedAmount) private {
265         balances[_target] = SafeMath.sub(balances[_target], _burnedAmount);
266         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
267         emit Burned(_target, _burnedAmount);
268     }
269 
270     /**
271     * @dev Log Events
272     */
273     event Transfer(address indexed _from, address indexed _to, uint256 _value);
274     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
275     event Burned(address indexed _target, uint256 _value);
276 
277 ///////////////////////////////////////////////////////////////////////////////////////
278 ///								Investment related									///
279 ///////////////////////////////////////////////////////////////////////////////////////
280 
281 	//Internal Variables
282 	IBancorConverter BancorConverter = IBancorConverter(0xc6725aE749677f21E4d8f85F41cFB6DE49b9Db29);
283 	IBancorQuickConverter Bancor = IBancorQuickConverter(0xcF1CC6eD5B653DeF7417E3fA93992c3FFe49139B);
284 	IBancorGasPriceLimit BancorGas = IBancorGasPriceLimit(0x607a5C47978e2Eb6d59C6C6f51bc0bF411f4b85a);
285 
286 	IERC20Token ETHToken = IERC20Token(0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315);
287 
288 	IERC20Token BNTToken = IERC20Token(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C);
289 
290 	IERC20Token EOSRelay = IERC20Token(0x507b06c23d7Cb313194dBF6A6D80297137fb5E01);
291 	IERC20Token EOSToken = IERC20Token(0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0);
292 
293 	IERC20Token ELFRelay = IERC20Token(0x0F2318565f1996CB1eD2F88e172135791BC1FcBf);
294 	IERC20Token ELFToken = IERC20Token(0xbf2179859fc6D5BEE9Bf9158632Dc51678a4100e);
295 
296 	IERC20Token OMGRelay = IERC20Token(0x99eBD396Ce7AA095412a4Cd1A0C959D6Fd67B340);
297 	IERC20Token OMGToken = IERC20Token(0xd26114cd6EE289AccF82350c8d8487fedB8A0C07);
298 
299 	IERC20Token POARelay = IERC20Token(0x564c07255AFe5050D82c8816F78dA13f2B17ac6D);
300 	IERC20Token POAToken = IERC20Token(0x6758B7d441a9739b98552B373703d8d3d14f9e62);
301 
302 	IERC20Token DRGNRelay = IERC20Token(0xa7774F9386E1653645E1A08fb7Aae525B4DeDb24);
303 	IERC20Token DRGNToken = IERC20Token(0x419c4dB4B9e25d6Db2AD9691ccb832C8D9fDA05E);
304 
305 	IERC20Token SRNRelay = IERC20Token(0xd2Deb679ed81238CaeF8E0c32257092cEcc8888b);
306 	IERC20Token SRNToken = IERC20Token(0x68d57c9a1C35f63E2c83eE8e49A64e9d70528D25);
307 
308 	IERC20Token WAXRelay = IERC20Token(0x67563E7A0F13642068F6F999e48c690107A4571F);
309 	IERC20Token WAXToken = IERC20Token(0x39Bb259F66E1C59d5ABEF88375979b4D20D98022);
310 
311 	IERC20Token POWRRelay = IERC20Token(0x168D7Bbf38E17941173a352f1352DF91a7771dF3);
312 	IERC20Token POWRToken = IERC20Token(0x595832F8FC6BF59c85C527fEC3740A1b7a361269);
313 
314 	bool buyFlag = false; //False = set rate - True = auto rate
315 	//Path to exchanges
316 	mapping(uint8 => IERC20Token[]) paths;
317 	mapping(uint8 => IERC20Token[]) reversePaths;
318 
319 
320 	//public variables
321 	address public feeWallet;
322 	uint256 public rate = 6850;
323 	//token related
324 	string public name = "MEGAINVEST v3";
325     uint8 public decimals = 18;
326     string public symbol = "MEG3";
327     string public version = '3';
328 
329 	constructor(address _feeWallet) public {
330 		feeWallet = _feeWallet;
331 		paths[0] = [ETHToken,BNTToken,BNTToken,EOSRelay,EOSRelay,EOSRelay,EOSToken];
332     	paths[1] = [ETHToken,BNTToken,BNTToken,ELFRelay,ELFRelay,ELFRelay,ELFToken];
333     	paths[2] = [ETHToken,BNTToken,BNTToken,OMGRelay,OMGRelay,OMGRelay,OMGToken];
334     	paths[3] = [ETHToken,BNTToken,BNTToken,POARelay,POARelay,POARelay,POAToken];
335     	paths[4] = [ETHToken,BNTToken,BNTToken,DRGNRelay,DRGNRelay,DRGNRelay,DRGNToken];
336     	paths[5] = [ETHToken,BNTToken,BNTToken,SRNRelay,SRNRelay,SRNRelay,SRNToken];
337     	paths[6] = [ETHToken,BNTToken,BNTToken,WAXRelay,WAXRelay,WAXRelay,WAXToken];
338     	paths[7] = [ETHToken,BNTToken,BNTToken,POWRRelay,POWRRelay,POWRRelay,POWRToken];
339 
340     	reversePaths[0] = [EOSToken,EOSRelay,EOSRelay,EOSRelay,BNTToken,BNTToken,ETHToken];
341     	reversePaths[1] = [ELFToken,ELFRelay,ELFRelay,ELFRelay,BNTToken,BNTToken,ETHToken];
342     	reversePaths[2] = [OMGToken,OMGRelay,OMGRelay,OMGRelay,BNTToken,BNTToken,ETHToken];
343     	reversePaths[3] = [POAToken,POARelay,POARelay,POARelay,BNTToken,BNTToken,ETHToken];
344     	reversePaths[4] = [DRGNToken,DRGNRelay,DRGNRelay,DRGNRelay,BNTToken,BNTToken,ETHToken];
345     	reversePaths[5] = [SRNToken,SRNRelay,SRNRelay,SRNRelay,BNTToken,BNTToken,ETHToken];
346     	reversePaths[6] = [WAXToken,WAXRelay,WAXRelay,WAXRelay,BNTToken,BNTToken,ETHToken];
347     	reversePaths[7] = [POWRToken,POWRRelay,POWRRelay,POWRRelay,BNTToken,BNTToken,ETHToken];
348 	}
349 
350 	function updateBancorContracts(
351 		IBancorConverter _BancorConverter,
352 		IBancorQuickConverter _Bancor,
353 		IBancorGasPriceLimit _BancorGas) public onlyAdmin{
354 
355 		BancorConverter = _BancorConverter;
356 		Bancor = _Bancor;
357 		BancorGas = _BancorGas;
358 	}
359 
360 	function updatePath(IERC20Token[] _path, IERC20Token[] _reversePath, uint8 _index) public onlyAdmin{
361 		paths[_index] = _path;
362 		reversePaths[_index] = _reversePath;
363 	}
364 
365 	function changeBuyFlag(bool _flag) public onlyAdmin {
366 		buyFlag = _flag;
367 	}
368 	
369 	function updateRate(uint256 _rate) public onlyAdmin {
370 	    rate = _rate;
371 	}
372 
373 	function valueOnContract() public view returns (uint256){
374 
375 		ISmartToken smartToken;
376         IERC20Token toToken;
377         ITokenConverter converter;
378         IERC20Token[] memory _path;
379         uint256 pathLength;
380         uint256 sumUp;
381         uint256 _amount;
382         IERC20Token _fromToken;
383 
384         for(uint8 j=0;j<8;j++){
385         	_path = reversePaths[j];
386         	// iterate over the conversion path
387 	        pathLength = _path.length;
388 	        _fromToken = _path[0];
389 	        _amount = _fromToken.balanceOf(address(this));
390 
391 	        for (uint256 i = 1; i < pathLength; i += 2) {
392 	            smartToken = ISmartToken(_path[i]);
393 	            toToken = _path[i + 1];
394 	            converter = ITokenConverter(smartToken.owner());
395 
396 	            // make the conversion - if it's the last one, also provide the minimum return value
397 	            _amount = converter.getReturn(_fromToken, toToken, _amount);
398 	            _fromToken = toToken;
399 	        }
400 	        
401 	        sumUp += _amount;
402         }
403 
404         return sumUp;
405 
406 	}
407 
408 	function buy() public payable {
409 	    BancorGas.validateGasPrice(tx.gasprice);
410 
411 		if(buyFlag == false){
412 			tokenBuy = msg.value.mul(rate);
413 		} else {
414 
415 			uint256 valueStored = valueOnContract();
416 			uint256 tokenBuy;
417 
418 			if(totalSupply > valueStored){
419 
420 				uint256 tempRate = totalSupply.div(valueStored); // Must be > 0 Tok/Eth
421 				tokenBuy = msg.value.mul(tempRate); // Eth * Tok / Eth = Tok
422 
423 			} else {
424 				
425 				uint256 tempPrice = valueStored.div(totalSupply); // Must be > 0 Eth/Tok
426 				tokenBuy = msg.value.div(tempPrice); // Eth / Eth / Tok = Tok
427 
428 			}
429 		}
430 		
431 
432 		uint256 ethFee = msg.value.mul(5)/1000; //5/1000 => 0.5%
433 		uint256 ethToInvest = msg.value.sub(ethFee);
434 
435 		feeWallet.transfer(ethFee);
436 		invest(ethToInvest);
437 
438 		mintToken(msg.sender,tokenBuy);
439 
440 	}
441 
442 	function invest(uint256 _amount) private {
443 		uint256 standarValue = _amount.div(8);
444 
445 		for(uint8 i=0; i<8; i++){ 
446 			Bancor.convertForPrioritized.value(standarValue)(paths[i],standarValue,1,address(this),0,0,0,0x0,0x0);
447 		}
448 
449 	}
450 
451 	function sell(address _target, uint256 _amount) private {
452 		uint256 tempBalance;
453 		uint256 tempFee;
454 		IERC20Token tempToken;
455 		uint256 dividedSupply = totalSupply.div(1e5); //ethereum is not decimals friendly
456 
457 		if(dividedSupply == 0 || _amount < dividedSupply) revert();
458 		
459 		uint256 factor = _amount.div(dividedSupply);
460 
461 		if( factor == 0) revert();
462 
463 		for(uint8 i=0; i<8; i++){ 
464 	
465 			tempToken = reversePaths[i][0];
466 			tempBalance = tempToken.balanceOf(this);
467 			tempBalance = tempBalance.mul(factor);
468 			tempBalance = tempBalance.div(1e5);
469 			tempFee = tempBalance.mul(5);
470 			tempFee = tempFee.div(1000); //0.5%
471 			tempBalance = tempBalance.sub(tempFee);
472 			tempToken.transfer(feeWallet,tempFee);
473 			tempToken.transfer(_target,tempBalance);
474 
475 		}
476 	}
477 	
478 	function emergency() onlyAdmin public{
479 	    uint256 tempBalance;
480 		uint256 tempFee;
481 		IERC20Token tempToken;
482 	    msg.sender.transfer(address(this).balance);
483 	    for(uint8 i=0; i<8; i++){ 
484 	
485 			tempToken = reversePaths[i][0];
486 			tempBalance = tempToken.balanceOf(this);
487 			tempBalance = tempBalance.sub(tempFee);
488 			tempToken.transfer(admin,tempBalance);
489 
490 		}
491 	}
492 	
493     function claimTokens(IERC20Token _address, address _to) onlyAdmin public  {
494         require(_to != address(0));
495         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
496         _address.transfer(_to,remainder); //Transfer tokens to creator
497     }
498 
499 	function () public payable{
500 		buy();
501 	}
502 
503 }