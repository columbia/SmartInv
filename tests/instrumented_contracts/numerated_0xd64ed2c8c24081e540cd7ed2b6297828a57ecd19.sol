1 pragma solidity ^0.4.16;
2 
3 //User interface at http://www.staticoin.com
4 //Full source code at https://github.com/genkifs/staticoin
5 
6 /** @title owned. */
7 contract owned  {
8   address owner;
9   function owned() {
10     owner = msg.sender;
11   }
12   function changeOwner(address newOwner) onlyOwner {
13     owner = newOwner;
14   }
15   modifier onlyOwner() {
16     if (msg.sender==owner) 
17     _;
18   }
19 }
20 
21 /** @title mortal. */
22 contract mortal is owned() {
23   function kill() onlyOwner {
24     if (msg.sender == owner) selfdestruct(owner);
25   }
26 }
27  
28 
29 // <ORACLIZE_API>
30 /*
31 Copyright (c) 2015-2016 Oraclize SRL
32 Copyright (c) 2016 Oraclize LTD
33 
34 
35 Permission is hereby granted, free of charge, to any person obtaining a copy
36 of this software and associated documentation files (the "Software"), to deal
37 in the Software without restriction, including without limitation the rights
38 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
39 copies of the Software, and to permit persons to whom the Software is
40 furnished to do so, subject to the following conditions:
41 
42 The above copyright notice and this permission notice shall be included in
43 all copies or substantial portions of the Software.
44 
45 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
46 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
47 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
48 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
49 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
50 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
51 THE SOFTWARE.
52 */
53 
54 /** @title OraclizeI. */
55 contract OraclizeI {
56     address public cbAddress;
57     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
58     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
59     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
60     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
61     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
62     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
63     function getPrice(string _datasource) returns (uint _dsprice);
64     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
65     function useCoupon(string _coupon);
66     function setProofType(byte _proofType);
67     function setConfig(bytes32 _config);
68     function setCustomGasPrice(uint _gasPrice);
69     function randomDS_getSessionPubKeyHash() returns(bytes32);
70 }
71 /** @title OraclizeAddrResolverI. */
72 contract OraclizeAddrResolverI {
73     function getAddress() returns (address _addr);
74 }
75 /** @title usingOraclize. */
76 contract usingOraclize {
77     uint constant day = 60*60*24;
78     uint constant week = 60*60*24*7;
79     uint constant month = 60*60*24*30;
80     byte constant proofType_NONE = 0x00;
81     byte constant proofType_TLSNotary = 0x10;
82     byte constant proofType_Android = 0x20;
83     byte constant proofType_Ledger = 0x30;
84     byte constant proofType_Native = 0xF0;
85     byte constant proofStorage_IPFS = 0x01;
86     uint8 constant networkID_auto = 0;
87     uint8 constant networkID_mainnet = 1;
88     uint8 constant networkID_testnet = 2;
89     uint8 constant networkID_morden = 2;
90     uint8 constant networkID_consensys = 161;
91 
92     OraclizeAddrResolverI OAR;
93 
94     OraclizeI oraclize;
95     modifier oraclizeAPI {
96         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork();
97         oraclize = OraclizeI(OAR.getAddress());
98         _;
99     }
100     modifier coupon(string code){
101         oraclize = OraclizeI(OAR.getAddress());
102         oraclize.useCoupon(code);
103         _;
104     }
105 
106     function oraclize_setNetwork() internal returns(bool){
107         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
108             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
109             oraclize_setNetworkName("eth_mainnet");
110             return true;
111         }
112         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
113             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
114             oraclize_setNetworkName("eth_ropsten3");
115             return true;
116         }
117         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
118             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
119             oraclize_setNetworkName("eth_kovan");
120             return true;
121         }
122         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
123             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
124             oraclize_setNetworkName("eth_rinkeby");
125             return true;
126         }
127         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
128             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
129             return true;
130         }
131         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
132             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
133             return true;
134         }
135         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
136             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
137             return true;
138         }
139         return false;
140     }
141 
142    function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
143        return oraclize.getPrice(datasource);
144    }
145 
146    function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
147        return oraclize.getPrice(datasource, gaslimit);
148    }
149    
150 	function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal { 
151         return oraclize.setCustomGasPrice(gasPrice); 
152 	}     
153 
154 
155     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
156         uint price = oraclize.getPrice(datasource);
157         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
158         return oraclize.query.value(price)(timestamp, datasource, arg);
159     }
160     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
161         uint price = oraclize.getPrice(datasource, gaslimit);
162         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
163         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
164     }
165 
166 
167     function oraclize_cbAddress() oraclizeAPI internal returns (address){
168         return oraclize.cbAddress();
169     }
170     function oraclize_setProof(byte proofP) oraclizeAPI internal {
171         return oraclize.setProofType(proofP);
172     }
173 
174     function getCodeSize(address _addr) constant internal returns(uint _size) {
175         assembly {
176             _size := extcodesize(_addr)
177         }
178     }
179         
180     string oraclize_network_name;
181     function oraclize_setNetworkName(string _network_name) internal {
182         oraclize_network_name = _network_name;
183     }
184     
185     function oraclize_getNetworkName() internal returns (string) {
186         return oraclize_network_name;
187     }
188         
189 }
190 // </ORACLIZE_API>
191 
192 /** @title DSParser. */
193 contract DSParser{
194     uint8 constant WAD_Dec=18;
195     uint128 constant WAD = 10 ** 18;
196     function parseInt128(string _a)  constant  returns (uint128) { 
197 		return cast(parseInt( _a, WAD_Dec));
198     }
199     function cast(uint256 x) constant internal returns (uint128 z) {
200         assert((z = uint128(x)) == x);
201     }
202     function parseInt(string _a, uint _b)  
203 			constant 
204 			returns (uint) { 
205 		/** @dev Turns a string into a number with _b places
206           * @param _a String to be processed, e.g. "0.002"
207           * @param _b number of decimal places
208           * @return uint of the decimal representation
209         */
210 			bytes memory bresult = bytes(_a);
211             uint mint = 0;
212             bool decimals = false;
213             for (uint i=0; i<bresult.length; i++){
214                 if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
215                     if (decimals){
216                        if (_b == 0){
217                         //Round up if next value is 5 or greater
218                         if(uint(bresult[i])- 48>4){
219                             mint = mint+1;
220                         }    
221                         break;
222                        }
223                        else _b--;
224                     }
225                     mint *= 10;
226                     mint += uint(bresult[i]) - 48;
227                 } else if (bresult[i] == 46||bresult[i] == 44) { // cope with euro decimals using commas
228                     decimals = true;
229                 }
230             }
231             if (_b > 0) mint *= 10**_b;
232            return mint;
233     }
234 	
235 }
236 
237 /** @title I_minter. */
238 contract I_minter { 
239     event EventCreateStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
240     event EventRedeemStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
241     event EventCreateRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
242     event EventRedeemRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
243     event EventBankrupt();
244 	
245     function Leverage() constant returns (uint128)  {}
246     function RiskPrice(uint128 _currentPrice,uint128 _StaticTotal,uint128 _RiskTotal, uint128 _ETHTotal) constant returns (uint128 price)  {}
247     function RiskPrice(uint128 _currentPrice) constant returns (uint128 price)  {}     
248     function PriceReturn(uint _TransID,uint128 _Price) {}
249     function NewStatic() external payable returns (uint _TransID)  {}
250     function NewStaticAdr(address _Risk) external payable returns (uint _TransID)  {}
251     function NewRisk() external payable returns (uint _TransID)  {}
252     function NewRiskAdr(address _Risk) external payable returns (uint _TransID)  {}
253     function RetRisk(uint128 _Quantity) external payable returns (uint _TransID)  {}
254     function RetStatic(uint128 _Quantity) external payable returns (uint _TransID)  {}
255     function Strike() constant returns (uint128)  {}
256 }
257 
258 /** @title I_Pricer. */
259 contract I_Pricer {
260     uint128 public lastPrice;
261     uint public constant DELAY = 1 days;// this needs to be a day on the mainnet
262     I_minter public mint;
263     string public sURL;//="json(https://api.kraken.com/0/public/Ticker?pair=ETHEUR).result.XETHZEUR.p.1";
264     mapping (bytes32 => uint) RevTransaction;
265     function setMinter(address _newAddress) {}
266     function __callback(bytes32 myid, string result) {}
267     function queryCost() constant returns (uint128 _value) {}
268     function QuickPrice() payable {}
269     function requestPrice(uint _actionID) payable returns (uint _TrasID){}
270     function collectFee() returns(bool) {}
271     function () {
272         //if ether is sent to this address, send it back.
273         revert();
274     }
275 }
276 
277 /** @title Pricer. */
278 contract Pricer is I_Pricer, 
279 	mortal, 
280 	usingOraclize, 
281 	DSParser {
282 	// <pair_name> = pair name
283     // a = ask array(<price>, <whole lot volume>, <lot volume>),
284     // b = bid array(<price>, <whole lot volume>, <lot volume>),
285     // c = last trade closed array(<price>, <lot volume>),
286     // v = volume array(<today>, <last 24 hours>),
287     // p = volume weighted average price array(<today>, <last 24 hours>),
288     // t = number of trades array(<today>, <last 24 hours>),
289     // l = low array(<today>, <last 24 hours>),
290     // h = high array(<today>, <last 24 hours>),
291     // o = today's opening price
292 	
293     function Pricer(string _URL) {
294 		/** @dev Constructor, allows the pricer URL to be set
295           * @param _URL of the web query
296           * @return nothing
297         */
298 		oraclize_setNetwork();
299 		sURL=_URL;
300     }
301 
302 	function () {
303         //if ether is sent to this address, send it back.
304         revert();
305     }
306 
307     function setMinter(address _newAddress) 
308 		onlyOwner {
309 		/** @dev Allows the address of the minter to be set
310           * @param _newAddress Address of the minter
311           * @return nothing
312         */
313         mint=I_minter(_newAddress);
314     }
315 
316     function queryCost() 
317 		constant 
318 		returns (uint128 _value) {
319 		/** @dev ETH cost of calling the oraclize 
320           * @param _newAddress Address of the minter
321           * @return nothing
322         */
323 		return cast(oraclize_getPrice("URL")); 
324     }
325 
326     function QuickPrice() 
327 		payable {
328 		/** @dev Gets the latest price.  Be careful, All eth sent is kept by the contract.
329           * @return nothing, but the new price will be stored in variable lastPrice
330         */
331         bytes32 TrasID =oraclize_query(1, "URL", sURL);
332         RevTransaction[TrasID]=0;
333     }
334 	
335     function __callback(bytes32 myid, string result) {
336 		/** @dev ORACLIZE standard callback function-
337           * @param myid Pricer transaction ID
338 		  * @param result Address of the minter
339           * @return calls minter.PriceReturn() with the price
340         */
341         if (msg.sender != oraclize_cbAddress()) revert(); // Only oraclize
342         bytes memory tempEmptyStringTest = bytes(result); // Array uses memory
343         if (tempEmptyStringTest.length == 0) {
344              lastPrice =  0;  //0 is taken to be an error by the minter contract
345         } else {
346             lastPrice =  parseInt128(result);  //convert the string into a 18 decimal place number
347         }
348         if(RevTransaction[myid]>0){  //if it's not from QuickPrice
349             mint.PriceReturn(RevTransaction[myid],lastPrice);  //Call the minter
350         }
351         delete RevTransaction[myid]; // free up the memory
352     }
353 
354 	function setGas(uint gasPrice) 
355 		onlyOwner 
356 		returns(bool) {
357 		/** @dev Allows oraclize gas cost to be changed
358           * @return True if sucessful
359         */
360 		oraclize_setCustomGasPrice(gasPrice);
361 		return true;
362     }
363 	
364 	function collectFee() 
365 		onlyOwner 
366 		returns(bool) {
367 		/** @dev Allows ETH to be removed from this contract (only this one, not the minter)
368           * @return True if sucessful
369         */
370         return owner.send(this.balance);
371 		return true;
372     }
373 	
374 	modifier onlyminter() {
375       if (msg.sender==address(mint)) 
376       _;
377     }
378 
379     function requestPrice(uint _actionID) 
380 		payable 
381 		onlyminter 
382 		returns (uint _TrasID){
383 		/** @dev Minter only functuon.  Needs to be called with enough eth
384           * @param _actionID Pricer transaction ID
385           * @return calls minter.PriceReturn() with the price
386         */
387         // 
388         bytes32 TrasID;
389         TrasID=oraclize_query(DELAY, "URL", sURL);
390         RevTransaction[TrasID]=_actionID;
391 		_TrasID=uint(TrasID);
392     }
393 }