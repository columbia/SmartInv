1 pragma solidity ^0.4.16;
2 
3 /** @title owned. */
4 contract owned  {
5   address owner;
6   function owned() {
7     owner = msg.sender;
8   }
9   function changeOwner(address newOwner) onlyOwner {
10     owner = newOwner;
11   }
12   modifier onlyOwner() {
13     if (msg.sender==owner) 
14     _;
15   }
16 }
17 
18 /** @title mortal. */
19 contract mortal is owned() {
20   function kill() onlyOwner {
21     if (msg.sender == owner) selfdestruct(owner);
22   }
23 }
24  
25 
26 // <ORACLIZE_API>
27 /*
28 Copyright (c) 2015-2016 Oraclize SRL
29 Copyright (c) 2016 Oraclize LTD
30 
31 
32 Permission is hereby granted, free of charge, to any person obtaining a copy
33 of this software and associated documentation files (the "Software"), to deal
34 in the Software without restriction, including without limitation the rights
35 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
36 copies of the Software, and to permit persons to whom the Software is
37 furnished to do so, subject to the following conditions:
38 
39 The above copyright notice and this permission notice shall be included in
40 all copies or substantial portions of the Software.
41 
42 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
43 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
44 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
45 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
46 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
47 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
48 THE SOFTWARE.
49 */
50 
51 /** @title OraclizeI. */
52 contract OraclizeI {
53     address public cbAddress;
54     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
55     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
56     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
57     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
58     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
59     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
60     function getPrice(string _datasource) returns (uint _dsprice);
61     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
62     function useCoupon(string _coupon);
63     function setProofType(byte _proofType);
64     function setConfig(bytes32 _config);
65     function setCustomGasPrice(uint _gasPrice);
66     function randomDS_getSessionPubKeyHash() returns(bytes32);
67 }
68 /** @title OraclizeAddrResolverI. */
69 contract OraclizeAddrResolverI {
70     function getAddress() returns (address _addr);
71 }
72 /** @title usingOraclize. */
73 contract usingOraclize {
74     uint constant day = 60*60*24;
75     uint constant week = 60*60*24*7;
76     uint constant month = 60*60*24*30;
77     byte constant proofType_NONE = 0x00;
78     byte constant proofType_TLSNotary = 0x10;
79     byte constant proofType_Android = 0x20;
80     byte constant proofType_Ledger = 0x30;
81     byte constant proofType_Native = 0xF0;
82     byte constant proofStorage_IPFS = 0x01;
83     uint8 constant networkID_auto = 0;
84     uint8 constant networkID_mainnet = 1;
85     uint8 constant networkID_testnet = 2;
86     uint8 constant networkID_morden = 2;
87     uint8 constant networkID_consensys = 161;
88 
89     OraclizeAddrResolverI OAR;
90 
91     OraclizeI oraclize;
92     modifier oraclizeAPI {
93         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork();
94         oraclize = OraclizeI(OAR.getAddress());
95         _;
96     }
97     modifier coupon(string code){
98         oraclize = OraclizeI(OAR.getAddress());
99         oraclize.useCoupon(code);
100         _;
101     }
102 
103     function oraclize_setNetwork() internal returns(bool){
104         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
105             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
106             oraclize_setNetworkName("eth_mainnet");
107             return true;
108         }
109         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
110             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
111             oraclize_setNetworkName("eth_ropsten3");
112             return true;
113         }
114         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
115             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
116             oraclize_setNetworkName("eth_kovan");
117             return true;
118         }
119         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
120             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
121             oraclize_setNetworkName("eth_rinkeby");
122             return true;
123         }
124         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
125             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
126             return true;
127         }
128         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
129             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
130             return true;
131         }
132         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
133             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
134             return true;
135         }
136         return false;
137     }
138 
139    function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
140        return oraclize.getPrice(datasource);
141    }
142 
143    function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
144        return oraclize.getPrice(datasource, gaslimit);
145    }
146    
147 	function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal { 
148         return oraclize.setCustomGasPrice(gasPrice); 
149 	}     
150 
151 
152     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
153         uint price = oraclize.getPrice(datasource);
154         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
155         return oraclize.query.value(price)(timestamp, datasource, arg);
156     }
157     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
158         uint price = oraclize.getPrice(datasource, gaslimit);
159         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
160         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
161     }
162 
163 
164     function oraclize_cbAddress() oraclizeAPI internal returns (address){
165         return oraclize.cbAddress();
166     }
167     function oraclize_setProof(byte proofP) oraclizeAPI internal {
168         return oraclize.setProofType(proofP);
169     }
170 
171     function getCodeSize(address _addr) constant internal returns(uint _size) {
172         assembly {
173             _size := extcodesize(_addr)
174         }
175     }
176         
177     string oraclize_network_name;
178     function oraclize_setNetworkName(string _network_name) internal {
179         oraclize_network_name = _network_name;
180     }
181     
182     function oraclize_getNetworkName() internal returns (string) {
183         return oraclize_network_name;
184     }
185         
186 }
187 // </ORACLIZE_API>
188 
189 /** @title DSParser. */
190 contract DSParser{
191     uint8 constant WAD_Dec=18;
192     uint128 constant WAD = 10 ** 18;
193     function parseInt128(string _a)  constant  returns (uint128) { 
194 		return cast(parseInt( _a, WAD_Dec));
195     }
196     function cast(uint256 x) constant internal returns (uint128 z) {
197         assert((z = uint128(x)) == x);
198     }
199     function parseInt(string _a, uint _b)  
200 			constant 
201 			returns (uint) { 
202 		/** @dev Turns a string into a number with _b places
203           * @param _a String to be processed, e.g. "0.002"
204           * @param _b number of decimal places
205           * @return uint of the decimal representation
206         */
207 			bytes memory bresult = bytes(_a);
208             uint mint = 0;
209             bool decimals = false;
210             for (uint i=0; i<bresult.length; i++){
211                 if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
212                     if (decimals){
213                        if (_b == 0){
214                         //Round up if next value is 5 or greater
215                         if(uint(bresult[i])- 48>4){
216                             mint = mint+1;
217                         }    
218                         break;
219                        }
220                        else _b--;
221                     }
222                     mint *= 10;
223                     mint += uint(bresult[i]) - 48;
224                 } else if (bresult[i] == 46||bresult[i] == 44) { // cope with euro decimals using commas
225                     decimals = true;
226                 }
227             }
228             if (_b > 0) mint *= 10**_b;
229            return mint;
230     }
231 	
232 }
233 
234 /** @title I_minter. */
235 contract I_minter { 
236     event EventCreateStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
237     event EventRedeemStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
238     event EventCreateRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
239     event EventRedeemRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
240     event EventBankrupt();
241 	
242     function Leverage() constant returns (uint128)  {}
243     function RiskPrice(uint128 _currentPrice,uint128 _StaticTotal,uint128 _RiskTotal, uint128 _ETHTotal) constant returns (uint128 price)  {}
244     function RiskPrice(uint128 _currentPrice) constant returns (uint128 price)  {}     
245     function PriceReturn(uint _TransID,uint128 _Price) {}
246     function NewStatic() external payable returns (uint _TransID)  {}
247     function NewStaticAdr(address _Risk) external payable returns (uint _TransID)  {}
248     function NewRisk() external payable returns (uint _TransID)  {}
249     function NewRiskAdr(address _Risk) external payable returns (uint _TransID)  {}
250     function RetRisk(uint128 _Quantity) external payable returns (uint _TransID)  {}
251     function RetStatic(uint128 _Quantity) external payable returns (uint _TransID)  {}
252     function Strike() constant returns (uint128)  {}
253 }
254 
255 /** @title I_Pricer. */
256 contract I_Pricer {
257     uint128 public lastPrice;
258     uint public constant DELAY = 1 days;// this needs to be a day on the mainnet
259     I_minter public mint;
260     string public sURL;//="json(https://api.kraken.com/0/public/Ticker?pair=ETHEUR).result.XETHZEUR.p.1";
261     mapping (bytes32 => uint) RevTransaction;
262     function setMinter(address _newAddress) {}
263     function __callback(bytes32 myid, string result) {}
264     function queryCost() constant returns (uint128 _value) {}
265     function QuickPrice() payable {}
266     function requestPrice(uint _actionID) payable returns (uint _TrasID){}
267     function collectFee() returns(bool) {}
268     function () {
269         //if ether is sent to this address, send it back.
270         revert();
271     }
272 }
273 
274 /** @title Pricer. */
275 contract Pricer is I_Pricer, 
276 	mortal, 
277 	usingOraclize, 
278 	DSParser {
279 	// <pair_name> = pair name
280     // a = ask array(<price>, <whole lot volume>, <lot volume>),
281     // b = bid array(<price>, <whole lot volume>, <lot volume>),
282     // c = last trade closed array(<price>, <lot volume>),
283     // v = volume array(<today>, <last 24 hours>),
284     // p = volume weighted average price array(<today>, <last 24 hours>),
285     // t = number of trades array(<today>, <last 24 hours>),
286     // l = low array(<today>, <last 24 hours>),
287     // h = high array(<today>, <last 24 hours>),
288     // o = today's opening price
289 	
290     function Pricer(string _URL) {
291 		/** @dev Constructor, allows the pricer URL to be set
292           * @param _URL of the web query
293           * @return nothing
294         */
295 		oraclize_setNetwork();
296 		sURL=_URL;
297     }
298 
299 	function () {
300         //if ether is sent to this address, send it back.
301         revert();
302     }
303 
304     function setMinter(address _newAddress) 
305 		onlyOwner {
306 		/** @dev Allows the address of the minter to be set
307           * @param _newAddress Address of the minter
308           * @return nothing
309         */
310         mint=I_minter(_newAddress);
311     }
312 
313     function queryCost() 
314 		constant 
315 		returns (uint128 _value) {
316 		/** @dev ETH cost of calling the oraclize 
317           * @param _newAddress Address of the minter
318           * @return nothing
319         */
320 		return cast(oraclize_getPrice("URL")); 
321     }
322 
323     function QuickPrice() 
324 		payable {
325 		/** @dev Gets the latest price.  Be careful, All eth sent is kept by the contract.
326           * @return nothing, but the new price will be stored in variable lastPrice
327         */
328         bytes32 TrasID =oraclize_query(1, "URL", sURL);
329         RevTransaction[TrasID]=0;
330     }
331 	
332     function __callback(bytes32 myid, string result) {
333 		/** @dev ORACLIZE standard callback function-
334           * @param myid Pricer transaction ID
335 		  * @param result Address of the minter
336           * @return calls minter.PriceReturn() with the price
337         */
338         if (msg.sender != oraclize_cbAddress()) revert(); // Only oraclize
339         bytes memory tempEmptyStringTest = bytes(result); // Array uses memory
340         if (tempEmptyStringTest.length == 0) {
341              lastPrice =  0;  //0 is taken to be an error by the minter contract
342         } else {
343             lastPrice =  parseInt128(result);  //convert the string into a 18 decimal place number
344         }
345         if(RevTransaction[myid]>0){  //if it's not from QuickPrice
346             mint.PriceReturn(RevTransaction[myid],lastPrice);  //Call the minter
347         }
348         delete RevTransaction[myid]; // free up the memory
349     }
350 
351 	function setGas(uint gasPrice) 
352 		onlyOwner 
353 		returns(bool) {
354 		/** @dev Allows oraclize gas cost to be changed
355           * @return True if sucessful
356         */
357 		oraclize_setCustomGasPrice(gasPrice);
358 		return true;
359     }
360 	
361 	function collectFee() 
362 		onlyOwner 
363 		returns(bool) {
364 		/** @dev Allows ETH to be removed from this contract (only this one, not the minter)
365           * @return True if sucessful
366         */
367         return owner.send(this.balance);
368 		return true;
369     }
370 	
371 	modifier onlyminter() {
372       if (msg.sender==address(mint)) 
373       _;
374     }
375 
376     function requestPrice(uint _actionID) 
377 		payable 
378 		onlyminter 
379 		returns (uint _TrasID){
380 		/** @dev Minter only functuon.  Needs to be called with enough eth
381           * @param _actionID Pricer transaction ID
382           * @return calls minter.PriceReturn() with the price
383         */
384         // 
385         bytes32 TrasID;
386         TrasID=oraclize_query(DELAY, "URL", sURL);
387         RevTransaction[TrasID]=_actionID;
388 		return _TrasID;
389     }
390 }