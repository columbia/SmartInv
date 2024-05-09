1 pragma solidity ^0.4.18;
2 
3 /*
4 Copyright (c) 2015-2016 Oraclize SRL
5 Copyright (c) 2016 Oraclize LTD
6 
7 Permission is hereby granted, free of charge, to any person obtaining a copy
8 of this software and associated documentation files (the "Software"), to deal
9 in the Software without restriction, including without limitation the rights
10 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11 copies of the Software, and to permit persons to whom the Software is
12 furnished to do so, subject to the following conditions:
13 
14 The above copyright notice and this permission notice shall be included in
15 all copies or substantial portions of the Software.
16 
17 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
18 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
19 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
20 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
21 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
22 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
23 THE SOFTWARE.
24 */
25 pragma solidity ^0.4.0;
26 
27 contract OraclizeI {
28     address public cbAddress;
29     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable public returns (bytes32 _id);
30     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
31     function setProofType(byte _proofType) public;
32     function setCustomGasPrice(uint _gasPrice) public;
33 }
34 
35 contract OraclizeAddrResolverI {
36     function getAddress() view public returns (address _addr);
37 }
38 
39 contract usingOraclize {
40     byte constant proofType_NONE = 0x00;
41     byte constant proofType_TLSNotary = 0x10;
42     byte constant proofType_Android = 0x20;
43     byte constant proofType_Ledger = 0x30;
44     byte constant proofType_Native = 0xF0;
45     byte constant proofStorage_IPFS = 0x01;
46 
47     OraclizeAddrResolverI OAR;
48     OraclizeI oraclize;
49 
50     modifier oraclizeAPI {
51         if ((address(OAR)==0)||(getCodeSize(address(OAR))==0))
52             oraclize_setNetworkAuto();
53 
54         if (address(oraclize) != OAR.getAddress())
55             oraclize = OraclizeI(OAR.getAddress());
56 
57         _;
58     }
59 
60     function oraclize_setNetworkAuto() internal returns(bool){
61         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
62             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
63             return true;
64         }
65         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
66             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
67             return true;
68         }
69         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
70             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
71             return true;
72         }
73         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
74             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
75             return true;
76         }
77         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
78             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
79             return true;
80         }
81         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
82             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
83             return true;
84         }
85         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
86             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
87             return true;
88         }
89         return false;
90     }
91 
92     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
93         return oraclize.getPrice(datasource, gaslimit);
94     }
95 
96     function oraclize_query(string datasource, string arg, uint gaslimit, uint priceLimit) oraclizeAPI internal returns (bytes32 id){
97         uint price = oraclize.getPrice(datasource, gaslimit);
98         if (price > priceLimit + tx.gasprice*gaslimit) return 0; // unexpectedly high price
99         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
100     }
101 
102     function oraclize_cbAddress() oraclizeAPI internal returns (address){
103         return oraclize.cbAddress();
104     }
105 
106     function oraclize_setProof(byte proofP) oraclizeAPI internal {
107         return oraclize.setProofType(proofP);
108     }
109 
110     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
111         return oraclize.setCustomGasPrice(gasPrice);
112     }
113 
114     function getCodeSize(address _addr) constant internal returns(uint _size) {
115         assembly {
116             _size := extcodesize(_addr)
117         }
118     }
119 }
120 
121 
122 /**
123  * @title Ownable
124  * @dev The Ownable contract has an owner address, and provides basic authorization control
125  * functions, this simplifies the implementation of "user permissions".
126  */
127 contract Ownable {
128   address public owner;
129 
130 
131   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
132 
133 
134   /**
135    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
136    * account.
137    */
138   function Ownable() public {
139     owner = msg.sender;
140   }
141 
142   /**
143    * @dev Throws if called by any account other than the owner.
144    */
145   modifier onlyOwner() {
146     require(msg.sender == owner);
147     _;
148   }
149 
150   /**
151    * @dev Allows the current owner to transfer control of the contract to a newOwner.
152    * @param newOwner The address to transfer ownership to.
153    */
154   function transferOwnership(address newOwner) public onlyOwner {
155     require(newOwner != address(0));
156     OwnershipTransferred(owner, newOwner);
157     owner = newOwner;
158   }
159 
160 }
161 
162 /**
163  * @title SafeMath
164  * @dev Math operations with safety checks that throw on error
165  */
166 library SafeMath {
167 
168   /**
169   * @dev Multiplies two numbers, throws on overflow.
170   */
171   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172     if (a == 0) {
173       return 0;
174     }
175     uint256 c = a * b;
176     assert(c / a == b);
177     return c;
178   }
179 
180   /**
181   * @dev Integer division of two numbers, truncating the quotient.
182   */
183   function div(uint256 a, uint256 b) internal pure returns (uint256) {
184     // assert(b > 0); // Solidity automatically throws when dividing by 0
185     uint256 c = a / b;
186     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
187     return c;
188   }
189 
190   /**
191   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
192   */
193   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
194     assert(b <= a);
195     return a - b;
196   }
197 
198   /**
199   * @dev Adds two numbers, throws on overflow.
200   */
201   function add(uint256 a, uint256 b) internal pure returns (uint256) {
202     uint256 c = a + b;
203     assert(c >= a);
204     return c;
205   }
206 }
207 
208 library Helpers {
209 	using SafeMath for uint256;
210 	function parseIntRound(string _a, uint256 _b) internal pure returns (uint256) {
211 		bytes memory bresult = bytes(_a);
212 		uint256 mint = 0;
213 		_b++;
214 		bool decimals = false;
215 		for (uint i = 0; i < bresult.length; i++) {
216 			if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
217 				if (decimals) {
218 					if (_b == 0) {
219 						break;
220 					}
221 					else
222 						_b--;
223 				}
224 				if (_b == 0) {
225 					if (uint(bresult[i]) - 48 >= 5)
226 						mint += 1;
227 				} else {
228 					mint *= 10;
229 					mint += uint(bresult[i]) - 48;
230 				}
231 			} else if (bresult[i] == 46)
232 				decimals = true;
233 		}
234 		if (_b > 0)
235 			mint *= 10**(_b - 1);
236 		return mint;
237 	}
238 }
239 
240 contract OracleI {
241     bytes32 public oracleName;
242     bytes16 public oracleType;
243     uint256 public rate;
244     bool public waitQuery;
245     uint256 public updateTime;
246     uint256 public callbackTime;
247     function getPrice() view public returns (uint);
248     function setBank(address _bankAddress) public;
249     function setGasPrice(uint256 _price) public;
250     function setGasLimit(uint256 _limit) public;
251     function updateRate() external returns (bool);
252 }
253 
254 
255 /**
256  * @title Base contract for Oraclize oracles.
257  *
258  * @dev Base contract for oracles. Not abstract.
259  */
260 contract OracleBase is Ownable, usingOraclize, OracleI {
261     event NewOraclizeQuery();
262     event OraclizeError(string desciption);
263     event PriceTicker(string price, bytes32 queryId, bytes proof);
264     event BankSet(address bankAddress);
265 
266     struct OracleConfig {
267         string datasource;
268         string arguments;
269     }
270 
271     bytes32 public oracleName = "Base Oracle";
272     bytes16 public oracleType = "Undefined";
273     uint256 public updateTime;
274     uint256 public callbackTime;
275     uint256 public priceLimit = 1 ether;
276 
277     mapping(bytes32=>bool) validIds; // ensure that each query response is processed only once
278     address public bankAddress;
279     uint256 public rate;
280     bool public waitQuery = false;
281     OracleConfig public oracleConfig;
282 
283     
284     uint256 public gasPrice = 20 * 10**9;
285     uint256 public gasLimit = 100000;
286 
287     uint256 constant MIN_GAS_PRICE = 1 * 10**9; // Min gas price limit
288     uint256 constant MAX_GAS_PRICE = 100 * 10**9; // Max gas limit pric
289     uint256 constant MIN_GAS_LIMIT = 95000; 
290     uint256 constant MAX_GAS_LIMIT = 1000000;
291     uint256 constant MIN_REQUEST_PRICE = 0.001118 ether;
292 
293     modifier onlyBank() {
294         require(msg.sender == bankAddress);
295         _;
296     }
297 
298     /**
299      * @dev Constructor.
300      */
301     function OracleBase() public {
302         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
303     }
304 
305     /**
306      * @dev Sets gas price.
307      * @param priceInWei New gas price.
308      */
309     function setGasPrice(uint256 priceInWei) public onlyOwner {
310         require((priceInWei >= MIN_GAS_PRICE) && (priceInWei <= MAX_GAS_PRICE));
311         gasPrice = priceInWei;
312         oraclize_setCustomGasPrice(gasPrice);
313     }
314 
315     /**
316      * @dev Sets gas limit.
317      * @param _gasLimit New gas limit.
318      */
319     function setGasLimit(uint256 _gasLimit) public onlyOwner {
320         require((_gasLimit >= MIN_GAS_LIMIT) && (_gasLimit <= MAX_GAS_LIMIT));
321         gasLimit = _gasLimit;
322     }
323 
324     /**
325      * @dev Sets bank address.
326      * @param bank Address of the bank contract.
327      */
328     function setBank(address bank) public onlyOwner {
329         bankAddress = bank;
330         BankSet(bankAddress);
331     }
332 
333     /**
334      * @dev oraclize getPrice.
335      */
336     function getPrice() public view returns (uint) {
337         return oraclize_getPrice(oracleConfig.datasource, gasLimit);
338     }
339 
340     /**
341      * @dev Requests updating rate from oraclize.
342      */
343     function updateRate() external onlyBank returns (bool) {
344         if (getPrice() > this.balance) {
345             OraclizeError("Not enough ether");
346             return false;
347         }
348         bytes32 queryId = oraclize_query(oracleConfig.datasource, oracleConfig.arguments, gasLimit, priceLimit);
349         
350         if (queryId == bytes32(0)) {
351             OraclizeError("Unexpectedly high query price");
352             return false;
353         }
354 
355         NewOraclizeQuery();
356         validIds[queryId] = true;
357         waitQuery = true;
358         updateTime = now;
359         return true;
360     }
361 
362     /**
363     * @dev Oraclize default callback with the proof set.
364     * @param myid The callback ID.
365     * @param result The callback data.
366     * @param proof The oraclize proof bytes.
367     */
368     function __callback(bytes32 myid, string result, bytes proof) public {
369         require(validIds[myid] && msg.sender == oraclize_cbAddress());
370 
371         rate = Helpers.parseIntRound(result, 3); // save it in storage as 1/1000 of $
372         delete validIds[myid];
373         callbackTime = now;
374         waitQuery = false;
375         PriceTicker(result, myid, proof);
376     }
377 
378     /**
379     * @dev Oraclize default callback without the proof set.
380     * @param myid The callback ID.
381     * @param result The callback data.
382     */
383     function __callback(bytes32 myid, string result) public {
384         bytes memory proof = new bytes(1);
385         __callback(myid, result, proof);
386     }
387 
388     /**
389     * @dev Method used for oracle funding   
390     */    
391     function () public payable {}
392 }
393 
394 /**
395  * @title Bitfinex oracle.
396  *
397  * @dev URL: https://www.bitfinex.com
398  * @dev API Docs: https://bitfinex.readme.io/v1/reference#rest-public-ticker
399  */
400 contract OracleBitfinex is OracleBase {
401     bytes32 constant ORACLE_NAME = "Bitfinex Oraclize Async";
402     bytes16 constant ORACLE_TYPE = "ETHUSD";
403     string constant ORACLE_DATASOURCE = "URL";
404     string constant ORACLE_ARGUMENTS = "json(https://api.bitfinex.com/v1/pubticker/ethusd).last_price";
405     
406     /**
407      * @dev Constructor.
408      */
409     function OracleBitfinex() public {
410         oracleName = ORACLE_NAME;
411         oracleType = ORACLE_TYPE;
412         oracleConfig = OracleConfig({datasource: ORACLE_DATASOURCE, arguments: ORACLE_ARGUMENTS});
413     }
414 }