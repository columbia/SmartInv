1 pragma solidity 0.4.23;
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
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /*
50     Owned contract interface
51 */
52 contract IOwned {
53     // this function isn't abstract since the compiler emits automatically generated getter functions as external
54     function owner() public view returns (address) {}
55 
56     function transferOwnership(address _newOwner) public;
57     function acceptOwnership() public;
58 }
59 
60 /*
61     Bancor Converter interface
62 */
63 contract IBancorConverter{
64 
65     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256);
66 	function quickConvert(address[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
67 
68 }
69 /*
70     Bancor Quick Converter interface
71 */
72 contract IBancorQuickConverter {
73     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
74     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
75     function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) public payable returns (uint256);
76 }
77 
78 /*
79     Bancor Gas tools interface
80 */
81 contract IBancorGasPriceLimit {
82     function gasPrice() public view returns (uint256) {}
83     function validateGasPrice(uint256) public view;
84 }
85 
86 /*
87     EIP228 Token Converter interface
88 */
89 contract ITokenConverter {
90     function convertibleTokenCount() public view returns (uint16);
91     function convertibleToken(uint16 _tokenIndex) public view returns (address);
92     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
93     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
94     // deprecated, backward compatibility
95     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
96 }
97 
98 /*
99     ERC20 Standard Token interface
100 */
101 contract IERC20Token {
102     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
103     function name() public view returns (string) {}
104     function symbol() public view returns (string) {}
105     function decimals() public view returns (uint8) {}
106     function totalSupply() public view returns (uint256) {}
107     function balanceOf(address _owner) public view returns (uint256) { _owner; }
108     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
109 
110     function transfer(address _to, uint256 _value) public returns (bool success);
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
112     function approve(address _spender, uint256 _value) public returns (bool success);
113 }
114 
115 /*
116     Smart Token interface
117 */
118 contract ISmartToken is IOwned, IERC20Token {
119     function disableTransfers(bool _disable) public;
120     function issue(address _to, uint256 _amount) public;
121     function destroy(address _from, uint256 _amount) public;
122 }
123 
124 /**
125 * @title Admin parameters
126 * @dev Define administration parameters for this contract
127 */
128 contract admined { //This token contract is administered
129     address public admin; //Admin address is public
130 
131     /**
132     * @dev Contract constructor
133     * define initial administrator
134     */
135     constructor() internal {
136         admin = msg.sender; //Set initial admin to contract creator
137         emit Admined(admin);
138     }
139 
140     modifier onlyAdmin() { //A modifier to define admin-only functions
141         require(msg.sender == admin);
142         _;
143     }
144 
145    /**
146     * @dev Function to set new admin address
147     * @param _newAdmin The address to transfer administration to
148     */
149     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
150         require(_newAdmin != 0);
151         admin = _newAdmin;
152         emit TransferAdminship(admin);
153     }
154 
155     event TransferAdminship(address newAdminister);
156     event Admined(address administer);
157 
158 }
159 
160 
161 /**
162 * @title ERC20Token
163 * @notice Token definition contract
164 */
165 contract CDMED is admined,IERC20Token { //Standar definition of an ERC20Token
166     using SafeMath for uint256; //SafeMath is used for uint256 operations
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
190         	sell(msg.sender,_value);
191         	return true;
192         } else {
193             balances[msg.sender] = balances[msg.sender].sub(_value);
194 	        balances[_to] = balances[_to].add(_value);
195     	    emit Transfer(msg.sender, _to, _value);
196         	return true;
197 
198         }
199     }
200 
201     /**
202     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
203     * @param _from The address where tokens comes.
204     * @param _to The address to transfer to.
205     * @param _value The amount to be transferred.
206     * @return success with boolean value true if done
207     */
208     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
209         require(_to != address(0)); //If you dont want that people destroy token
210         balances[_from] = balances[_from].sub(_value);
211         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212         balances[_to] = balances[_to].add(_value);
213         emit Transfer(_from, _to, _value);
214         return true;
215     }
216 
217     /**
218     * @notice Assign allowance _value to _spender address to use the msg.sender balance
219     * @param _spender The address to be allowed to spend.
220     * @param _value The amount to be allowed.
221     * @return success with boolean value true
222     */
223     function approve(address _spender, uint256 _value) public returns (bool success) {
224     	require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
225         allowed[msg.sender][_spender] = _value;
226         emit Approval(msg.sender, _spender, _value);
227         return true;
228     }
229 
230     /**
231     * @notice Get the allowance of an specified address to use another address balance.
232     * @param _owner The address of the owner of the tokens.
233     * @param _spender The address of the allowed spender.
234     * @return remaining with the allowance value
235     */
236     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
237         return allowed[_owner][_spender];
238     }
239 
240     /**
241     * @dev Mint token to an specified address.
242     * @param _target The address of the receiver of the tokens.
243     * @param _mintedAmount amount to mint.
244     */
245     function mintToken(address _target, uint256 _mintedAmount) private {
246         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
247         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
248         emit Transfer(0, this, _mintedAmount);
249         emit Transfer(this, _target, _mintedAmount);
250     }
251 
252     /**
253     * @dev Burn token of an specified address.
254     * @param _target The address of the holder of the tokens.
255     * @param _burnedAmount amount to burn.
256     */
257     function burnToken(address _target, uint256 _burnedAmount) private {
258         balances[_target] = SafeMath.sub(balances[_target], _burnedAmount);
259         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
260         emit Burned(_target, _burnedAmount);
261     }
262 
263     /**
264     * @dev Log Events
265     */
266     event Transfer(address indexed _from, address indexed _to, uint256 _value);
267     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
268     event Burned(address indexed _target, uint256 _value);
269 
270 	//Internal Bancor Variables
271 	IBancorConverter BancorConverter = IBancorConverter(0xc6725aE749677f21E4d8f85F41cFB6DE49b9Db29);
272 	IBancorQuickConverter Bancor = IBancorQuickConverter(0xcF1CC6eD5B653DeF7417E3fA93992c3FFe49139B);
273 	IBancorGasPriceLimit BancorGas = IBancorGasPriceLimit(0x607a5C47978e2Eb6d59C6C6f51bc0bF411f4b85a);
274 	//ERC20 ETH token
275 	IERC20Token ETHToken = IERC20Token(0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315);
276 	//ERC20 BNT token
277 	IERC20Token BNTToken = IERC20Token(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C);
278 	//Flag for initial sale
279 	bool buyFlag = false; //False = set rate - True = auto rate
280 	//Relays initial list
281 	IERC20Token[8]	relays = [
282 			IERC20Token(0x507b06c23d7Cb313194dBF6A6D80297137fb5E01),
283 			IERC20Token(0x0F2318565f1996CB1eD2F88e172135791BC1FcBf),
284 			IERC20Token(0xA9DE5935aE3eae8a7F943C9329940EDA160267f4),
285 			IERC20Token(0x564c07255AFe5050D82c8816F78dA13f2B17ac6D),
286 			IERC20Token(0xa7774F9386E1653645E1A08fb7Aae525B4DeDb24),
287 			IERC20Token(0xd2Deb679ed81238CaeF8E0c32257092cEcc8888b),
288 			IERC20Token(0x67563E7A0F13642068F6F999e48c690107A4571F),
289 			IERC20Token(0x168D7Bbf38E17941173a352f1352DF91a7771dF3)
290 		];
291 	//Tokens initial list
292 	IERC20Token[8]	tokens = [
293 			IERC20Token(0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0),
294 			IERC20Token(0xbf2179859fc6D5BEE9Bf9158632Dc51678a4100e),
295 			IERC20Token(0x9a0242b7a33DAcbe40eDb927834F96eB39f8fBCB),
296 			IERC20Token(0x6758B7d441a9739b98552B373703d8d3d14f9e62),
297 			IERC20Token(0x419c4dB4B9e25d6Db2AD9691ccb832C8D9fDA05E),
298 			IERC20Token(0x68d57c9a1C35f63E2c83eE8e49A64e9d70528D25),
299 			IERC20Token(0x39Bb259F66E1C59d5ABEF88375979b4D20D98022),
300 			IERC20Token(0x595832F8FC6BF59c85C527fEC3740A1b7a361269)
301 		];
302 	//Path to exchanges
303 	mapping(uint8 => IERC20Token[]) paths;
304 	mapping(uint8 => IERC20Token[]) reversePaths;
305 	//public variables
306 	address public feeWallet;
307 	uint256 public rate = 6850;
308 	//token related
309 	string public name = "CDMED";
310     uint8 public decimals = 18;
311     string public symbol = "CDMED";
312     string public version = '1';
313 
314 	constructor(address _feeWallet) public {
315 		feeWallet = _feeWallet;
316 
317 		paths[0] = [ETHToken,BNTToken,BNTToken,relays[0],relays[0],relays[0],tokens[0]];
318     	paths[1] = [ETHToken,BNTToken,BNTToken,relays[1],relays[1],relays[1],tokens[1]];
319     	paths[2] = [ETHToken,BNTToken,BNTToken,relays[2],relays[2],relays[2],tokens[2]];
320     	paths[3] = [ETHToken,BNTToken,BNTToken,relays[3],relays[3],relays[3],tokens[3]];
321     	paths[4] = [ETHToken,BNTToken,BNTToken,relays[4],relays[4],relays[4],tokens[4]];
322     	paths[5] = [ETHToken,BNTToken,BNTToken,relays[5],relays[5],relays[5],tokens[5]];
323     	paths[6] = [ETHToken,BNTToken,BNTToken,relays[6],relays[6],relays[6],tokens[6]];
324     	paths[7] = [ETHToken,BNTToken,BNTToken,relays[7],relays[7],relays[7],tokens[7]];
325 
326     	reversePaths[0] = [tokens[0],relays[0],relays[0],relays[0],BNTToken,BNTToken,ETHToken];
327     	reversePaths[1] = [tokens[1],relays[1],relays[1],relays[1],BNTToken,BNTToken,ETHToken];
328     	reversePaths[2] = [tokens[2],relays[2],relays[2],relays[2],BNTToken,BNTToken,ETHToken];
329     	reversePaths[3] = [tokens[3],relays[3],relays[3],relays[3],BNTToken,BNTToken,ETHToken];
330     	reversePaths[4] = [tokens[4],relays[4],relays[4],relays[4],BNTToken,BNTToken,ETHToken];
331     	reversePaths[5] = [tokens[5],relays[5],relays[5],relays[5],BNTToken,BNTToken,ETHToken];
332     	reversePaths[6] = [tokens[6],relays[6],relays[6],relays[6],BNTToken,BNTToken,ETHToken];
333     	reversePaths[7] = [tokens[7],relays[7],relays[7],relays[7],BNTToken,BNTToken,ETHToken];
334 	}
335 
336 	function viewTokenName(uint8 _index) public view returns(string){ //for validation purpouses
337 		return tokens[_index].name();
338 	}
339 
340 	function changeBuyFlag(bool _flag) public onlyAdmin {
341 		buyFlag = _flag;
342 	}
343 	
344 	function updateRate(uint256 _rate) public onlyAdmin {
345 	    rate = _rate;
346 	}
347 
348 	function valueOnContract() public view returns (uint256){
349 
350 		ISmartToken smartToken;
351         IERC20Token toToken;
352         ITokenConverter converter;
353         IERC20Token[] memory _path;
354         uint256 pathLength;
355         uint256 sumUp;
356         uint256 _amount;
357         IERC20Token _fromToken;
358 
359         for(uint8 j=0;j<8;j++){
360         	_path = reversePaths[j];
361         	// iterate over the conversion path
362 	        pathLength = _path.length;
363 	        _fromToken = _path[0];
364 	        _amount = _fromToken.balanceOf(address(this));
365 
366 	        for (uint256 i = 1; i < pathLength; i += 2) {
367 	            smartToken = ISmartToken(_path[i]);
368 	            toToken = _path[i + 1];
369 	            converter = ITokenConverter(smartToken.owner());
370 
371 	            // make the conversion - if it's the last one, also provide the minimum return value
372 	            _amount = converter.getReturn(_fromToken, toToken, _amount);
373 	            _fromToken = toToken;
374 	        }
375 	        
376 	        sumUp += _amount;
377         }
378 
379         return sumUp;
380 
381 	}
382 
383     function viewMaxGasPrice() public view returns(uint256){
384         return BancorGas.gasPrice();
385     }
386 
387 	function buy() public payable {
388 	    BancorGas.validateGasPrice(tx.gasprice);
389 
390 		if(buyFlag == false){
391 			tokenBuy = msg.value.mul(rate);
392 		} else {
393 
394 			uint256 valueStored = valueOnContract();
395 			uint256 tokenBuy;
396 
397 			if(totalSupply > valueStored){
398 
399 				uint256 tempRate = totalSupply.div(valueStored); // Must be > 0 Tok/Eth
400 				tokenBuy = msg.value.mul(tempRate); // Eth * Tok / Eth = Tok
401 
402 			} else {
403 				
404 				uint256 tempPrice = valueStored.div(totalSupply); // Must be > 0 Eth/Tok
405 				tokenBuy = msg.value.div(tempPrice); // Eth / Eth / Tok = Tok
406 
407 			}
408 		}
409 		
410 
411 		uint256 ethFee = msg.value.mul(5)/1000; //5/1000 => 0.5%
412 		uint256 ethToInvest = msg.value.sub(ethFee);
413 
414 		feeWallet.transfer(ethFee);
415 		invest(ethToInvest);
416 
417 		mintToken(msg.sender,tokenBuy);
418 
419 	}
420 
421 	function invest(uint256 _amount) private {
422 		uint256 standarValue = _amount.div(8);
423 
424 		for(uint8 i=0; i<8; i++){ 
425 			Bancor.convertForPrioritized.value(standarValue)(paths[i],standarValue,1,address(this),0,0,0,0x0,0x0);
426 		}
427 
428 	}
429 
430 	function sell(address _target, uint256 _amount) private {
431 		uint256 tempBalance;
432 		uint256 tempFee;
433 		uint256 dividedSupply = totalSupply.div(1e5); //ethereum is not decimals friendly
434 
435 		if(dividedSupply == 0 || _amount < dividedSupply) revert();
436 		
437 		uint256 factor = _amount.div(dividedSupply);
438 
439 		if( factor == 0) revert();
440 
441         burnToken(_target, _amount);
442 		
443 		for(uint8 i=0;i<8;i++){
444 			tempBalance = tokens[i].balanceOf(this);
445             tempBalance = tempBalance.mul(factor);
446             tempBalance = tempBalance.div(1e5);
447 			tempFee = tempBalance.mul(5);
448 			tempFee = tempFee.div(1000); //0.5%
449 			tempBalance = tempBalance.sub(tempFee);
450 			tokens[i].transfer(feeWallet,tempFee);
451 			tokens[i].transfer(_target,tempBalance);
452 		}
453 		
454 
455 	}
456 
457 	function () public payable{
458 		buy();
459 	}
460 
461 }