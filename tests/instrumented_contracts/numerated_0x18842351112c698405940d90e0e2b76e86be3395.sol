1 pragma solidity 0.4.23;
2 /**
3 * @notice Multiple Investment BNT TOKEN CONTRACT
4 * @dev ERC-20 Token Standar Compliant
5 */
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     if (a == 0) {
18       return 0;
19     }
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
53 /*
54     Owned contract interface
55 */
56 contract IOwned {
57     // this function isn't abstract since the compiler emits automatically generated getter functions as external
58     function owner() public view returns (address) {}
59 
60     function transferOwnership(address _newOwner) public;
61     function acceptOwnership() public;
62 }
63 
64 /*
65     Bancor Converter interface
66 */
67 contract IBancorConverter{
68 
69     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256);
70 	function quickConvert(address[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
71 
72 }
73 /*
74     Bancor Quick Converter interface
75 */
76 contract IBancorQuickConverter {
77     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
78     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
79     function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) public payable returns (uint256);
80 }
81 
82 /*
83     Bancor Gas tools interface
84 */
85 contract IBancorGasPriceLimit {
86     function gasPrice() public view returns (uint256) {}
87     function validateGasPrice(uint256) public view;
88 }
89 
90 /*
91     EIP228 Token Converter interface
92 */
93 contract ITokenConverter {
94     function convertibleTokenCount() public view returns (uint16);
95     function convertibleToken(uint16 _tokenIndex) public view returns (address);
96     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
97     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
98     // deprecated, backward compatibility
99     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
100 }
101 
102 /*
103     ERC20 Standard Token interface
104 */
105 contract IERC20Token {
106     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
107     function name() public view returns (string) {}
108     function symbol() public view returns (string) {}
109     function decimals() public view returns (uint8) {}
110     function totalSupply() public view returns (uint256) {}
111     function balanceOf(address _owner) public view returns (uint256) { _owner; }
112     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
113 
114     function transfer(address _to, uint256 _value) public returns (bool success);
115     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
116     function approve(address _spender, uint256 _value) public returns (bool success);
117 }
118 
119 /*
120     Smart Token interface
121 */
122 contract ISmartToken is IOwned, IERC20Token {
123     function disableTransfers(bool _disable) public;
124     function issue(address _to, uint256 _amount) public;
125     function destroy(address _from, uint256 _amount) public;
126 }
127 
128 /**
129 * @title Admin parameters
130 * @dev Define administration parameters for this contract
131 */
132 contract admined { //This token contract is administered
133     address public admin; //Admin address is public
134 
135     /**
136     * @dev Contract constructor
137     * define initial administrator
138     */
139     constructor() internal {
140         admin = msg.sender; //Set initial admin to contract creator
141         emit Admined(admin);
142     }
143 
144     modifier onlyAdmin() { //A modifier to define admin-only functions
145         require(msg.sender == admin);
146         _;
147     }
148 
149    /**
150     * @dev Function to set new admin address
151     * @param _newAdmin The address to transfer administration to
152     */
153     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
154         require(_newAdmin != 0);
155         admin = _newAdmin;
156         emit TransferAdminship(admin);
157     }
158 
159     event TransferAdminship(address newAdminister);
160     event Admined(address administer);
161 
162 }
163 
164 
165 /**
166 * @title ERC20Token
167 * @notice Token definition contract
168 */
169 contract MIB is admined,IERC20Token { //Standar definition of an ERC20Token
170     using SafeMath for uint256; //SafeMath is used for uint256 operations
171 
172 ///////////////////////////////////////////////////////////////////////////////////////
173 ///									Token Related									///
174 ///////////////////////////////////////////////////////////////////////////////////////
175 
176     mapping (address => uint256) balances; //A mapping of all balances per address
177     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
178     uint256 public totalSupply;
179     
180     /**
181     * @notice Get the balance of an _owner address.
182     * @param _owner The address to be query.
183     */
184     function balanceOf(address _owner) public constant returns (uint256 bal) {
185         return balances[_owner];
186     }
187 
188     /**
189     * @notice transfer _value tokens to address _to
190     * @param _to The address to transfer to.
191     * @param _value The amount to be transferred.
192     * @return success with boolean value true if done
193     */
194     function transfer(address _to, uint256 _value) public returns (bool success) {
195         require(_to != address(0)); //If you dont want that people destroy token
196         
197         if(_to == address(this)){
198         	sell(msg.sender,_value);
199         	return true;
200         } else {
201             balances[msg.sender] = balances[msg.sender].sub(_value);
202 	        balances[_to] = balances[_to].add(_value);
203     	    emit Transfer(msg.sender, _to, _value);
204         	return true;
205 
206         }
207     }
208 
209     /**
210     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
211     * @param _from The address where tokens comes.
212     * @param _to The address to transfer to.
213     * @param _value The amount to be transferred.
214     * @return success with boolean value true if done
215     */
216     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
217         require(_to != address(0)); //If you dont want that people destroy token
218         balances[_from] = balances[_from].sub(_value);
219         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220         balances[_to] = balances[_to].add(_value);
221         emit Transfer(_from, _to, _value);
222         return true;
223     }
224 
225     /**
226     * @notice Assign allowance _value to _spender address to use the msg.sender balance
227     * @param _spender The address to be allowed to spend.
228     * @param _value The amount to be allowed.
229     * @return success with boolean value true
230     */
231     function approve(address _spender, uint256 _value) public returns (bool success) {
232     	require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
233         allowed[msg.sender][_spender] = _value;
234         emit Approval(msg.sender, _spender, _value);
235         return true;
236     }
237 
238     /**
239     * @notice Get the allowance of an specified address to use another address balance.
240     * @param _owner The address of the owner of the tokens.
241     * @param _spender The address of the allowed spender.
242     * @return remaining with the allowance value
243     */
244     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
245         return allowed[_owner][_spender];
246     }
247 
248     /**
249     * @dev Mint token to an specified address.
250     * @param _target The address of the receiver of the tokens.
251     * @param _mintedAmount amount to mint.
252     */
253     function mintToken(address _target, uint256 _mintedAmount) private {
254         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
255         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
256         emit Transfer(0, this, _mintedAmount);
257         emit Transfer(this, _target, _mintedAmount);
258     }
259 
260     /**
261     * @dev Burn token of an specified address.
262     * @param _target The address of the holder of the tokens.
263     * @param _burnedAmount amount to burn.
264     */
265     function burnToken(address _target, uint256 _burnedAmount) private {
266         balances[_target] = SafeMath.sub(balances[_target], _burnedAmount);
267         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
268         emit Burned(_target, _burnedAmount);
269     }
270 
271     /**
272     * @dev Log Events
273     */
274     event Transfer(address indexed _from, address indexed _to, uint256 _value);
275     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
276     event Burned(address indexed _target, uint256 _value);
277 
278 ///////////////////////////////////////////////////////////////////////////////////////
279 ///								Investment related									///
280 ///////////////////////////////////////////////////////////////////////////////////////
281 
282 	//Internal Bancor Variables
283 	IBancorConverter BancorConverter = IBancorConverter(0xc6725aE749677f21E4d8f85F41cFB6DE49b9Db29);
284 	IBancorQuickConverter Bancor = IBancorQuickConverter(0xcF1CC6eD5B653DeF7417E3fA93992c3FFe49139B);
285 	IBancorGasPriceLimit BancorGas = IBancorGasPriceLimit(0x607a5C47978e2Eb6d59C6C6f51bc0bF411f4b85a);
286 	//ERC20 ETH token
287 	IERC20Token ETHToken = IERC20Token(0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315);
288 	//BNT token
289 	IERC20Token BNTToken = IERC20Token(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C);
290 	//Flag for initial sale
291 	bool buyFlag = false; //False = set rate - True = auto rate
292 	//Relays initial list
293 	IERC20Token[8]	relays = [
294 			IERC20Token(0x507b06c23d7Cb313194dBF6A6D80297137fb5E01),
295 			IERC20Token(0x0F2318565f1996CB1eD2F88e172135791BC1FcBf),
296 			IERC20Token(0x5a4deB5704C1891dF3575d3EecF9471DA7F61Fa4),
297 			IERC20Token(0x564c07255AFe5050D82c8816F78dA13f2B17ac6D),
298 			IERC20Token(0xa7774F9386E1653645E1A08fb7Aae525B4DeDb24),
299 			IERC20Token(0xd2Deb679ed81238CaeF8E0c32257092cEcc8888b),
300 			IERC20Token(0x67563E7A0F13642068F6F999e48c690107A4571F),
301 			IERC20Token(0x168D7Bbf38E17941173a352f1352DF91a7771dF3)
302 		];
303 	//Tokens initial list
304 	IERC20Token[8]	tokens = [
305 			IERC20Token(0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0),
306 			IERC20Token(0xbf2179859fc6D5BEE9Bf9158632Dc51678a4100e),
307 			IERC20Token(0xA15C7Ebe1f07CaF6bFF097D8a589fb8AC49Ae5B3),
308 			IERC20Token(0x6758B7d441a9739b98552B373703d8d3d14f9e62),
309 			IERC20Token(0x419c4dB4B9e25d6Db2AD9691ccb832C8D9fDA05E),
310 			IERC20Token(0x68d57c9a1C35f63E2c83eE8e49A64e9d70528D25),
311 			IERC20Token(0x39Bb259F66E1C59d5ABEF88375979b4D20D98022),
312 			IERC20Token(0x595832F8FC6BF59c85C527fEC3740A1b7a361269)
313 		];
314 	//Path to exchanges
315 	mapping(uint8 => IERC20Token[]) paths;
316 	mapping(uint8 => IERC20Token[]) reversePaths;
317 	//public variables
318 	address public feeWallet;
319 	uint256 public rate = 10000;
320 	//token related
321 	string public name = "MULTIPLE INVEST BNT";
322     uint8 public decimals = 18;
323     string public symbol = "MIB";//Like Men In Black B)
324     string public version = '1';
325 
326 	constructor(address _feeWallet) public {
327 		feeWallet = _feeWallet;
328 
329 		paths[0] = [ETHToken,BNTToken,BNTToken,relays[0],relays[0],relays[0],tokens[0]];
330     	paths[1] = [ETHToken,BNTToken,BNTToken,relays[1],relays[1],relays[1],tokens[1]];
331     	paths[2] = [ETHToken,BNTToken,BNTToken,relays[2],relays[2],relays[2],tokens[2]];
332     	paths[3] = [ETHToken,BNTToken,BNTToken,relays[3],relays[3],relays[3],tokens[3]];
333     	paths[4] = [ETHToken,BNTToken,BNTToken,relays[4],relays[4],relays[4],tokens[4]];
334     	paths[5] = [ETHToken,BNTToken,BNTToken,relays[5],relays[5],relays[5],tokens[5]];
335     	paths[6] = [ETHToken,BNTToken,BNTToken,relays[6],relays[6],relays[6],tokens[6]];
336     	paths[7] = [ETHToken,BNTToken,BNTToken,relays[7],relays[7],relays[7],tokens[7]];
337 
338     	reversePaths[0] = [tokens[0],relays[0],relays[0],relays[0],BNTToken,BNTToken,ETHToken];
339     	reversePaths[1] = [tokens[1],relays[1],relays[1],relays[1],BNTToken,BNTToken,ETHToken];
340     	reversePaths[2] = [tokens[2],relays[2],relays[2],relays[2],BNTToken,BNTToken,ETHToken];
341     	reversePaths[3] = [tokens[3],relays[3],relays[3],relays[3],BNTToken,BNTToken,ETHToken];
342     	reversePaths[4] = [tokens[4],relays[4],relays[4],relays[4],BNTToken,BNTToken,ETHToken];
343     	reversePaths[5] = [tokens[5],relays[5],relays[5],relays[5],BNTToken,BNTToken,ETHToken];
344     	reversePaths[6] = [tokens[6],relays[6],relays[6],relays[6],BNTToken,BNTToken,ETHToken];
345     	reversePaths[7] = [tokens[7],relays[7],relays[7],relays[7],BNTToken,BNTToken,ETHToken];
346 	}
347 
348 	function viewTokenName(uint8 _index) public view returns(string){
349 		return tokens[_index].name();
350 	}
351 
352 	function viewMaxGasPrice() public view returns(uint256){
353 		return BancorGas.gasPrice();
354 	}
355 
356 	function updateBancorContracts(
357 		IBancorConverter _BancorConverter,
358 		IBancorQuickConverter _Bancor,
359 		IBancorGasPriceLimit _BancorGas) public onlyAdmin{
360 
361 		BancorConverter = _BancorConverter;
362 		Bancor = _Bancor;
363 		BancorGas = _BancorGas;
364 	}
365 
366 	function valueOnContract() public view returns (uint256){
367 
368 		ISmartToken smartToken;
369         IERC20Token toToken;
370         ITokenConverter converter;
371         IERC20Token[] memory _path;
372         uint256 pathLength;
373         uint256 sumUp;
374         uint256 _amount;
375         IERC20Token _fromToken;
376 
377         for(uint8 j=0;j<8;j++){
378         	_path = reversePaths[j];
379         	// iterate over the conversion path
380 	        pathLength = _path.length;
381 	        _fromToken = _path[0];
382 	        _amount = _fromToken.balanceOf(address(this));
383 
384 	        for (uint256 i = 1; i < pathLength; i += 2) {
385 	            smartToken = ISmartToken(_path[i]);
386 	            toToken = _path[i + 1];
387 	            converter = ITokenConverter(smartToken.owner());
388 
389 	            // make the conversion - if it's the last one, also provide the minimum return value
390 	            _amount = converter.getReturn(_fromToken, toToken, _amount);
391 	            _fromToken = toToken;
392 	        }
393 	        
394 	        sumUp += _amount;
395         }
396 
397         return sumUp;
398 
399 	}
400 
401 	function buy() public payable {
402 	    BancorGas.validateGasPrice(tx.gasprice);
403 
404 	    if(totalSupply >= 10000000*10**18){
405 	    	buyFlag = true;
406 	    }
407 
408 		if(buyFlag == false){
409 			tokenBuy = msg.value.mul(rate);
410 		} else {
411 
412 			uint256 valueStored = valueOnContract();
413 			uint256 tokenBuy;
414 
415 			if(totalSupply > valueStored){
416 
417 				uint256 tempRate = totalSupply.div(valueStored); // Must be > 0 Tok/Eth
418 				tokenBuy = msg.value.mul(tempRate); // Eth * Tok / Eth = Tok
419 
420 			} else {
421 				
422 				uint256 tempPrice = valueStored.div(totalSupply); // Must be > 0 Eth/Tok
423 				tokenBuy = msg.value.div(tempPrice); // Eth / Eth / Tok = Tok
424 
425 			}
426 		}
427 
428 		uint256 ethFee = msg.value.mul(5);
429 		ethFee = ethFee.div(1000); //5/1000 => 0.5%
430 		uint256 ethToInvest = msg.value.sub(ethFee);
431 		//tranfer fees
432 		feeWallet.transfer(ethFee);
433 		//invest on tokens
434 		invest(ethToInvest);
435 		//deliver your shares
436 		mintToken(msg.sender,tokenBuy);
437 
438 	}
439 
440 	function invest(uint256 _amount) private {
441 		uint256 standarValue = _amount.div(8); //evenly distributed eth on tokens
442 
443 		for(uint8 i=0; i<8; i++){ 
444 			Bancor.convertForPrioritized.value(standarValue)(paths[i],standarValue,1,address(this),0,0,0,0x0,0x0);
445 		}
446 
447 	}
448 
449 	function sell(address _target, uint256 _amount) private {
450 		uint256 tempBalance;
451 		uint256 tempFee;
452 		uint256 dividedSupply = totalSupply.div(1e5); //ethereum is not decimals friendly
453 
454 		if(dividedSupply == 0 || _amount < dividedSupply) revert();
455 		
456 		uint256 factor = _amount.div(dividedSupply);
457 
458 		if( factor == 0) revert();
459 
460 		burnToken(_target, _amount);
461 		
462 		for(uint8 i=0;i<8;i++){
463 			tempBalance = tokens[i].balanceOf(this);
464 			tempBalance = tempBalance.mul(factor);
465 			tempBalance = tempBalance.div(1e5);
466 			tempFee = tempBalance.mul(5);
467 			tempFee = tempFee.div(1000); //0.5%
468 			tempBalance = tempBalance.sub(tempFee);
469 
470 			tokens[i].transfer(feeWallet,tempFee);
471 			tokens[i].transfer(_target,tempBalance);
472 		}
473 		
474 
475 	}
476 	
477 	function () public payable{
478 		buy();
479 	}
480 
481 }