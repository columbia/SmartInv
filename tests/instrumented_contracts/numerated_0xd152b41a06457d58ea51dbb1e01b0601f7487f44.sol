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
50     Bancor Converter interface
51 */
52 contract IBancorConverter{
53 
54     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256);
55 	function quickConvert(address[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
56 
57 }
58 /*
59     Bancor Quick Converter interface
60 */
61 contract IBancorQuickConverter {
62     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
63     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
64     function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) public payable returns (uint256);
65 }
66 
67 /*
68     Bancor Gas tools interface
69 */
70 contract IBancorGasPriceLimit {
71     function gasPrice() public view returns (uint256) {}
72     function validateGasPrice(uint256) public view;
73 }
74 
75 /*
76     ERC20 Standard Token interface
77 */
78 contract IERC20Token {
79     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
80     function name() public view returns (string) {}
81     function symbol() public view returns (string) {}
82     function decimals() public view returns (uint8) {}
83     function totalSupply() public view returns (uint256) {}
84     function balanceOf(address _owner) public view returns (uint256) { _owner; }
85     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
86 
87     function transfer(address _to, uint256 _value) public returns (bool success);
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
89     function approve(address _spender, uint256 _value) public returns (bool success);
90 }
91 
92 
93 /**
94 * @title Admin parameters
95 * @dev Define administration parameters for this contract
96 */
97 contract admined { //This token contract is administered
98     address public admin; //Admin address is public
99 
100     /**
101     * @dev Contract constructor
102     * define initial administrator
103     */
104     constructor() internal {
105         admin = msg.sender; //Set initial admin to contract creator
106         emit Admined(admin);
107     }
108 
109     modifier onlyAdmin() { //A modifier to define admin-only functions
110         require(msg.sender == admin);
111         _;
112     }
113 
114    /**
115     * @dev Function to set new admin address
116     * @param _newAdmin The address to transfer administration to
117     */
118     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
119         require(_newAdmin != 0);
120         admin = _newAdmin;
121         emit TransferAdminship(admin);
122     }
123 
124     event TransferAdminship(address newAdminister);
125     event Admined(address administer);
126 
127 }
128 
129 
130 /**
131 * @title ERC20Token
132 * @notice Token definition contract
133 */
134 contract MEGAINVEST is admined,IERC20Token { //Standar definition of an ERC20Token
135     using SafeMath for uint256; //SafeMath is used for uint256 operations
136 
137 ///////////////////////////////////////////////////////////////////////////////////////
138 ///									Token Related									///
139 ///////////////////////////////////////////////////////////////////////////////////////
140 
141     mapping (address => uint256) balances; //A mapping of all balances per address
142     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
143     uint256 public totalSupply;
144     
145     /**
146     * @notice Get the balance of an _owner address.
147     * @param _owner The address to be query.
148     */
149     function balanceOf(address _owner) public constant returns (uint256 bal) {
150         return balances[_owner];
151     }
152 
153     /**
154     * @notice transfer _value tokens to address _to
155     * @param _to The address to transfer to.
156     * @param _value The amount to be transferred.
157     * @return success with boolean value true if done
158     */
159     function transfer(address _to, uint256 _value) public returns (bool success) {
160         require(_to != address(0)); //If you dont want that people destroy token
161         
162         if(_to == address(this)){
163         	burnToken(msg.sender, _value);
164         	sell(msg.sender,_value);
165         	return true;
166         } else {
167             balances[msg.sender] = balances[msg.sender].sub(_value);
168 	        balances[_to] = balances[_to].add(_value);
169     	    emit Transfer(msg.sender, _to, _value);
170         	return true;
171 
172         }
173     }
174 
175     /**
176     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
177     * @param _from The address where tokens comes.
178     * @param _to The address to transfer to.
179     * @param _value The amount to be transferred.
180     * @return success with boolean value true if done
181     */
182     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
183         require(_to != address(0)); //If you dont want that people destroy token
184         balances[_from] = balances[_from].sub(_value);
185         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186         balances[_to] = balances[_to].add(_value);
187         emit Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     /**
192     * @notice Assign allowance _value to _spender address to use the msg.sender balance
193     * @param _spender The address to be allowed to spend.
194     * @param _value The amount to be allowed.
195     * @return success with boolean value true
196     */
197     function approve(address _spender, uint256 _value) public returns (bool success) {
198     	require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
199         allowed[msg.sender][_spender] = _value;
200         emit Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     /**
205     * @notice Get the allowance of an specified address to use another address balance.
206     * @param _owner The address of the owner of the tokens.
207     * @param _spender The address of the allowed spender.
208     * @return remaining with the allowance value
209     */
210     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
211         return allowed[_owner][_spender];
212     }
213 
214     /**
215     * @dev Mint token to an specified address.
216     * @param _target The address of the receiver of the tokens.
217     * @param _mintedAmount amount to mint.
218     */
219     function mintToken(address _target, uint256 _mintedAmount) private {
220         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
221         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
222         emit Transfer(0, this, _mintedAmount);
223         emit Transfer(this, _target, _mintedAmount);
224     }
225 
226     /**
227     * @dev Burn token of an specified address.
228     * @param _target The address of the holder of the tokens.
229     * @param _burnedAmount amount to burn.
230     */
231     function burnToken(address _target, uint256 _burnedAmount) private {
232         balances[_target] = SafeMath.sub(balances[_target], _burnedAmount);
233         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
234         emit Burned(_target, _burnedAmount);
235     }
236 
237     /**
238     * @dev Log Events
239     */
240     event Transfer(address indexed _from, address indexed _to, uint256 _value);
241     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
242     event Burned(address indexed _target, uint256 _value);
243 
244 ///////////////////////////////////////////////////////////////////////////////////////
245 ///								Investment related									///
246 ///////////////////////////////////////////////////////////////////////////////////////
247 
248 	//Internal Variables
249 	IBancorConverter BancorConverter = IBancorConverter(0xc6725aE749677f21E4d8f85F41cFB6DE49b9Db29);
250 	IBancorQuickConverter Bancor = IBancorQuickConverter(0xcF1CC6eD5B653DeF7417E3fA93992c3FFe49139B);
251 	IBancorGasPriceLimit BancorGas = IBancorGasPriceLimit(0x607a5C47978e2Eb6d59C6C6f51bc0bF411f4b85a);
252 
253 	IERC20Token ETHToken = IERC20Token(0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315);
254 
255 	IERC20Token BNTToken = IERC20Token(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C);
256 
257 	IERC20Token EOSRelay = IERC20Token(0x507b06c23d7Cb313194dBF6A6D80297137fb5E01);
258 	IERC20Token EOSToken = IERC20Token(0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0);
259 
260 	IERC20Token ELFRelay = IERC20Token(0x0F2318565f1996CB1eD2F88e172135791BC1FcBf);
261 	IERC20Token ELFToken = IERC20Token(0xbf2179859fc6D5BEE9Bf9158632Dc51678a4100e);
262 
263 	IERC20Token OMGRelay = IERC20Token(0x99eBD396Ce7AA095412a4Cd1A0C959D6Fd67B340);
264 	IERC20Token OMGToken = IERC20Token(0xd26114cd6EE289AccF82350c8d8487fedB8A0C07);
265 
266 	IERC20Token POARelay = IERC20Token(0x564c07255AFe5050D82c8816F78dA13f2B17ac6D);
267 	IERC20Token POAToken = IERC20Token(0x6758B7d441a9739b98552B373703d8d3d14f9e62);
268 
269 	IERC20Token DRGNRelay = IERC20Token(0xa7774F9386E1653645E1A08fb7Aae525B4DeDb24);
270 	IERC20Token DRGNToken = IERC20Token(0x419c4dB4B9e25d6Db2AD9691ccb832C8D9fDA05E);
271 
272 	IERC20Token SRNRelay = IERC20Token(0xd2Deb679ed81238CaeF8E0c32257092cEcc8888b);
273 	IERC20Token SRNToken = IERC20Token(0x68d57c9a1C35f63E2c83eE8e49A64e9d70528D25);
274 
275 	IERC20Token WAXRelay = IERC20Token(0x67563E7A0F13642068F6F999e48c690107A4571F);
276 	IERC20Token WAXToken = IERC20Token(0x39Bb259F66E1C59d5ABEF88375979b4D20D98022);
277 
278 	IERC20Token POWRRelay = IERC20Token(0x168D7Bbf38E17941173a352f1352DF91a7771dF3);
279 	IERC20Token POWRToken = IERC20Token(0x595832F8FC6BF59c85C527fEC3740A1b7a361269);
280 
281 	bool buyFlag = false; //False = set rate - True = auto rate
282 	uint256 constant internal magnitude = 2**64;
283 	//Path to exchanges
284 	mapping(uint8 => IERC20Token[]) paths;
285 
286 
287 	//public variables
288 	address public feeWallet;
289 	uint256 public rate = 6850;
290 	//token related
291 	string public name = "MEGAINVEST";
292     uint8 public decimals = 18;
293     string public symbol = "MEGA";
294     string public version = '1';
295 
296 	constructor(address _feeWallet) public {
297 		feeWallet = _feeWallet;
298 		paths[0] = [ETHToken,BNTToken,BNTToken,EOSRelay,EOSRelay,EOSRelay,EOSToken];
299     	paths[1] = [ETHToken,BNTToken,BNTToken,ELFRelay,ELFRelay,ELFRelay,ELFToken];
300     	paths[2] = [ETHToken,BNTToken,BNTToken,OMGRelay,OMGRelay,OMGRelay,OMGToken];
301     	paths[3] = [ETHToken,BNTToken,BNTToken,POARelay,POARelay,POARelay,POAToken];
302     	paths[4] = [ETHToken,BNTToken,BNTToken,DRGNRelay,DRGNRelay,DRGNRelay,DRGNToken];
303     	paths[5] = [ETHToken,BNTToken,BNTToken,SRNRelay,SRNRelay,SRNRelay,SRNToken];
304     	paths[6] = [ETHToken,BNTToken,BNTToken,WAXRelay,WAXRelay,WAXRelay,WAXToken];
305     	paths[7] = [ETHToken,BNTToken,BNTToken,POWRRelay,POWRRelay,POWRRelay,POWRToken];
306 	}
307 
308 	function changeBuyFlag(bool _flag) public onlyAdmin {
309 		buyFlag = _flag;
310 	}
311 	
312 	function updateRate(uint256 _rate) public onlyAdmin {
313 	    rate = _rate;
314 	}
315 
316 	function valueOnContract() public view returns (uint256){
317 
318 		uint256 sumUpValue;
319 		IERC20Token temp;
320 
321 		for(uint8 i=0; i<8; i++){
322 			temp = IERC20Token(paths[i][paths[i].length - 1]); 
323 			sumUpValue = sumUpValue.add(BancorConverter.getReturn(temp,ETHToken,temp.balanceOf(address(this))));
324 		}
325 
326 		return sumUpValue;
327 
328 	}
329 
330 	function buy() public payable {
331 	    BancorGas.validateGasPrice(tx.gasprice);
332 
333 		if(buyFlag == false){
334 			tokenBuy = msg.value.mul(rate);
335 		} else {
336 
337 			uint256 valueStored = valueOnContract();
338 			uint256 tokenBuy;
339 
340 			if(totalSupply > valueStored){
341 
342 				uint256 tempRate = totalSupply.div(valueStored); // Must be > 0 Tok/Eth
343 				tokenBuy = msg.value.mul(tempRate); // Eth * Tok / Eth = Tok
344 
345 			} else {
346 				
347 				uint256 tempPrice = valueStored.div(totalSupply); // Must be > 0 Eth/Tok
348 				tokenBuy = msg.value.div(tempPrice); // Eth / Eth / Tok = Tok
349 
350 			}
351 		}
352 		
353 
354 		uint256 ethFee = msg.value.mul(5)/1000; //5/1000 => 0.5%
355 		uint256 ethToInvest = msg.value.sub(ethFee);
356 
357 		feeWallet.transfer(ethFee);
358 		invest(ethToInvest);
359 
360 		mintToken(msg.sender,tokenBuy);
361 
362 	}
363 
364 	function invest(uint256 _amount) private {
365 		uint256 standarValue = _amount.div(8);
366 
367 		for(uint8 i=0; i<8; i++){ 
368 			Bancor.convertForPrioritized.value(standarValue)(paths[i],standarValue,1,address(this),0,0,0,0x0,0x0);
369 		}
370 
371 	}
372 
373 	function sell(address _target, uint256 _amount) private {
374 		uint256 tempBalance;
375 		uint256 tempFee;
376 		IERC20Token tempToken;
377 		uint256 dividedSupply = totalSupply.div(magnitude); //ethereum is not decimals friendly
378 
379 		if(dividedSupply == 0 || _amount < dividedSupply) revert();
380 		
381 		uint256 factor = _amount.div(dividedSupply);
382 
383 		if( factor == 0) revert();
384 
385 		for(uint8 i=0; i<8; i++){ 
386 	
387 			tempToken = IERC20Token(paths[i][paths[i].length - 1]);
388 			tempBalance = tempToken.balanceOf(this);
389 			tempBalance = tempBalance.mul(factor);
390 			tempBalance = tempBalance.div(magnitude);
391 			tempFee = tempBalance.mul(5);
392 			tempFee = tempFee.div(1000); //0.5%
393 			tempBalance = tempBalance.sub(tempFee);
394 			tempToken.transfer(feeWallet,tempFee);
395 			tempToken.transfer(_target,tempBalance);
396 
397 		}
398 	}
399 	
400 	function emergency() onlyAdmin public{
401 	    msg.sender.transfer(address(this).balance);
402 	}
403 	
404     function claimTokens(IERC20Token _address, address _to) onlyAdmin public  {
405         require(_to != address(0));
406         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
407         _address.transfer(_to,remainder); //Transfer tokens to creator
408     }
409 
410 	function () public payable{
411 		buy();
412 	}
413 
414 }