1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner {
38     require(newOwner != address(0));      
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 interface OraclizeI {
46     // address public cbAddress;
47     function cbAddress() constant returns (address); // Reads public variable cbAddress
48     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
49     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
50     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
51     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
52     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
53     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
54     function getPrice(string _datasoaurce) returns (uint _dsprice);
55     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
56     function useCoupon(string _coupon);
57     function setProofType(byte _proofType);
58     function setConfig(bytes32 _config);
59     function setCustomGasPrice(uint _gasPrice);
60     function randomDS_getSessionPubKeyHash() returns(bytes32);
61 }
62 
63 interface OraclizeAddrResolverI {
64     function getAddress() returns (address _addr);
65 }
66 
67 // this is a reduced and optimize version of the usingOraclize contract in https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.4.sol
68 contract myUsingOraclize is Ownable {
69     OraclizeAddrResolverI OAR;
70     OraclizeI public oraclize;
71     uint public oraclize_gaslimit = 120000;
72 
73     function myUsingOraclize() {
74         oraclize_setNetwork();
75         update_oraclize();
76     }
77 
78     function update_oraclize() onlyOwner public {
79         oraclize = OraclizeI(OAR.getAddress());
80     }
81 
82     function oraclize_query(string datasource, string arg1, string arg2) internal returns (bytes32 id) {
83         uint price = oraclize.getPrice(datasource, oraclize_gaslimit);
84         if (price > 1 ether + tx.gasprice*oraclize_gaslimit) return 0; // unexpectedly high price
85         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, oraclize_gaslimit);
86     }
87 
88     function oraclize_getPrice(string datasource) internal returns (uint) {
89         return oraclize.getPrice(datasource, oraclize_gaslimit);
90     }
91     
92     function oraclize_setGasPrice(uint _gasPrice) onlyOwner public {
93         oraclize.setCustomGasPrice(_gasPrice);
94     }
95 
96 
97     function setGasLimit(uint _newLimit) onlyOwner public {
98         oraclize_gaslimit = _newLimit;
99     }
100 
101     function oraclize_setNetwork() internal {
102         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
103             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
104         }
105         else if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
106             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
107         }
108         else if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
109             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
110         }
111         else if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
112             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
113         }
114         else if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
115             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
116         }
117         else if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
118             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
119         }
120         else if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
121             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
122         }
123         else {
124             revert();
125         }
126     }
127 
128     function getCodeSize(address _addr) constant internal returns(uint _size) {
129         assembly {
130             _size := extcodesize(_addr)
131         }
132         return _size;
133     }
134 
135     // This will not throw error on wrong input, but instead consume large and unknown amount of gas
136     // This should never occure as it's use with the ShapeShift deposit return value is checked before calling function
137     function parseAddr(string _a) internal returns (address){
138         bytes memory tmp = bytes(_a);
139         uint160 iaddr = 0;
140         uint160 b1;
141         uint160 b2;
142         for (uint i=2; i<2+2*20; i+=2){
143             iaddr *= 256;
144             b1 = uint160(tmp[i]);
145             b2 = uint160(tmp[i+1]);
146             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
147             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
148             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
149             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
150             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
151             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
152             iaddr += (b1*16+b2);
153         }
154         return address(iaddr);
155     }
156 }
157 
158 /**
159  * @title InterCrypto
160  * @dev The InterCrypto offers a no-commission service using Oraclize and ShapeShift
161  * that allows for on-blockchain conversion from Ether to any other blockchain that ShapeShift supports.
162  * @author Jack Tanner - <jnt16@ic.ac.uk>
163  */
164 contract InterCrypto is Ownable, myUsingOraclize {
165     // _______________VARIABLES_______________
166     struct Conversion {
167         address returnAddress;
168         uint amount;
169     }
170 
171     mapping (uint => Conversion) public conversions;
172     uint conversionCount = 0;
173     mapping (bytes32 => uint) oraclizeMyId2conversionID;
174     mapping (address => uint) public recoverable;
175 
176     // _______________EVENTS_______________
177     event ConversionStarted(uint indexed conversionID);
178     event ConversionSentToShapeShift(uint indexed conversionID, address indexed returnAddress, address indexed depositAddress, uint amount);
179     event ConversionAborted(uint indexed conversionID, string reason);
180     event Recovered(address indexed recoveredTo, uint amount);
181 
182     // _______________EXTERNAL FUNCTIONS_______________
183     /**
184      * Constructor.
185      */
186     function InterCrypto() {}
187 
188     /**
189      * Destroys the contract and returns and Ether to the owner.
190      */
191     function kill() onlyOwner external {
192         selfdestruct(owner);
193     }
194 
195     /**
196      * Fallback function to allow contract to accept Ether.
197      */
198     function () payable {}
199 
200     /**
201      * Sets up a ShapeShift cryptocurrency conversion using Oraclize and the ShapeShift API. Must be sent more Ether than the Oraclize price.
202      * Returns a conversionID which can be used for tracking of the conversion.
203      * @param _coinSymbol The coinsymbol of the other blockchain to be used by ShapeShift. See engine() function for more details.
204      * @param _toAddress The address on the other blockchain that the converted cryptocurrency will be sent to.
205      */
206     function convert1(string _coinSymbol, string _toAddress) external payable returns(uint) {
207         return engine(_coinSymbol, _toAddress, msg.sender);
208     }
209 
210     /**
211      * Sets up a ShapeShift cryptocurrency conversion using Oraclize and the ShapeShift API. Must be sent more Ether than the Oraclize price.
212      * Returns a conversionID which can be used for tracking of the conversion.
213      * @param _coinSymbol The coinsymbol of the other blockchain to be used by ShapeShift. See engine() function for more details.
214      * @param _toAddress The address on the other blockchain that the converted cryptocurrency will be sent to.
215      * @param _returnAddress The Ethereum address that any Ether should be sent back to in the event that the ShapeShift conversion is invalid or fails
216      */
217     function convert2(string _coinSymbol, string _toAddress, address _returnAddress) external payable returns(uint) {
218         return engine(_coinSymbol, _toAddress, _returnAddress);
219     }
220 
221     /**
222      * Callback function for use exclusively by Oraclize.
223      * @param myid The Oraclize id of the query.
224      * @param result The result of the query.
225      */
226     function __callback(bytes32 myid, string result) {
227         if (msg.sender != oraclize.cbAddress()) revert();
228 
229         uint conversionID = oraclizeMyId2conversionID[myid];
230 
231         if( bytes(result).length == 0 ) {
232             ConversionAborted(conversionID, "Oraclize return value was invalid, this is probably due to incorrect convert() argments");
233             recoverable[conversions[conversionID].returnAddress] += conversions[conversionID].amount;
234             conversions[conversionID].amount = 0;
235         }
236         else {
237             address depositAddress = parseAddr(result);
238             require(depositAddress != msg.sender); // prevent DAO tpe re-entracy vulnerability that can potentially be done by Oraclize
239             uint sendAmount = conversions[conversionID].amount;
240             conversions[conversionID].amount = 0;
241             if (depositAddress.send(sendAmount)) {
242                 ConversionSentToShapeShift(conversionID, conversions[conversionID].returnAddress, depositAddress, sendAmount);
243             }
244             else {
245                 ConversionAborted(conversionID, "deposit to address returned by Oraclize failed");
246                 recoverable[conversions[conversionID].returnAddress] += sendAmount;
247             }
248         }
249     }
250 
251     /**
252      * Cancel a cryptocurrency conversion.
253      * This should only be required to be called if Oraclize fails make a return call to __callback().
254      * @param conversionID The conversion ID of the cryptocurrency conversion, generated during engine().
255      */
256      function cancelConversion(uint conversionID) external {
257         Conversion memory conversion = conversions[conversionID];
258 
259         if (conversion.amount > 0) {
260             require(msg.sender == conversion.returnAddress);
261             recoverable[msg.sender] += conversion.amount;
262             conversions[conversionID].amount = 0;
263             ConversionAborted(conversionID, "conversion cancelled by creator");
264         }
265     }
266 
267     /**
268      * Recover any recoverable funds due to the failure of InterCrypto. Failure can occure due to:
269      * 1. Bad user inputs to convert().
270      * 2. ShapeShift temporarily or permanently discontinues support of other blockchain.
271      * 3. ShapeShift service becomes unavailable.
272      * 4. Oraclize service become unavailable.
273      */
274      function recover() external {
275         uint amount = recoverable[msg.sender];
276         recoverable[msg.sender] = 0;
277         if (msg.sender.send(amount)) {
278             Recovered(msg.sender, amount);
279         }
280         else {
281             recoverable[msg.sender] = amount;
282         }
283     }
284     // _______________PUBLIC FUNCTIONS_______________
285     /**
286      * Returns the price in Wei paid to Oraclize.
287      */
288     function getInterCryptoPrice() constant public returns (uint) {
289         return oraclize_getPrice('URL');
290     }
291 
292     // _______________INTERNAL FUNCTIONS_______________
293     /**
294      * Sets up a ShapeShift cryptocurrency conversion using Oraclize and the ShapeShift API. Must be sent more Ether than the Oraclize price.
295      * Returns a conversionID which can be used for tracking of the conversion.
296      * @param _coinSymbol The coinsymbol of the other blockchain to be used by ShapeShift. See engine() function for more details.
297      * @param _toAddress The address on the other blockchain that the converted cryptocurrency will be sent to.
298      * Example first two arguments:
299      * "ltc", "LbZcDdMeP96ko85H21TQii98YFF9RgZg3D"    Litecoin
300      * "btc", "1L8oRijgmkfcZDYA21b73b6DewLtyYs87s"    Bitcoin
301      * "dash", "Xoopows17idkTwNrMZuySXBwQDorsezQAx"   Dash
302      * "zec", "t1N7tf1xRxz5cBK51JADijLDWS592FPJtya"   ZCash
303      * "doge", "DMAFvwTH2upni7eTau8au6Rktgm2bUkMei"   Dogecoin
304      * Test symbol pairs using ShapeShift API (shapeshift.io/validateAddress/[address]/[coinSymbol]) or by creating a test
305      * conversion on https://shapeshift.io first whenever possible before using it with InterCrypto.
306      * @param _returnAddress The Ethereum address that any Ether should be sent back to in the event that the ShapeShift conversion is invalid or fails.
307      */
308     function engine(string _coinSymbol, string _toAddress, address _returnAddress) internal returns(uint conversionID) {
309         conversionID = conversionCount++;
310 
311         if (
312             !isValidString(_coinSymbol, 6) || // Waves smbol is "waves"
313             !isValidString(_toAddress, 120)   // Monero integrated addresses are 106 characters
314             ) {
315             ConversionAborted(conversionID, "input parameters are too long or contain invalid symbols");
316             recoverable[msg.sender] += msg.value;
317             return;
318         }
319 
320         uint oraclizePrice = getInterCryptoPrice();
321 
322         if (msg.value > oraclizePrice) {
323             Conversion memory conversion = Conversion(_returnAddress, msg.value-oraclizePrice);
324             conversions[conversionID] = Conversion(_returnAddress, msg.value-oraclizePrice);
325 
326             string memory postData = createShapeShiftConversionPost(_coinSymbol, _toAddress);
327             bytes32 myQueryId = oraclize_query("URL", "json(https://shapeshift.io/shift).deposit", postData);
328 
329             if (myQueryId == 0) {
330                 ConversionAborted(conversionID, "unexpectedly high Oraclize price when calling oraclize_query");
331                 recoverable[msg.sender] += msg.value-oraclizePrice;
332                 conversions[conversionID].amount = 0;
333                 return;
334             }
335             oraclizeMyId2conversionID[myQueryId] = conversionID;
336             ConversionStarted(conversionID);
337         }
338         else {
339             ConversionAborted(conversionID, "Not enough Ether sent to cover Oraclize fee");
340             conversions[conversionID].amount = 0;
341             recoverable[msg.sender] += msg.value;
342         }
343     }
344 
345     /**
346      * Returns true if a given string contains only numbers and letters, and is below a maximum length.
347      * @param _string String to be checked.
348      * @param maxSize The maximum allowable sting character length. The address on the other blockchain that the converted cryptocurrency will be sent to.
349      */
350     function isValidString(string _string, uint maxSize) constant internal returns (bool allowed) {
351         bytes memory stringBytes = bytes(_string);
352         uint lengthBytes = stringBytes.length;
353         if (lengthBytes < 1 ||
354             lengthBytes > maxSize) {
355             return false;
356         }
357 
358         for (uint i = 0; i < lengthBytes; i++) {
359             byte b = stringBytes[i];
360             if ( !(
361                 (b >= 48 && b <= 57) || // 0 - 9
362                 (b >= 65 && b <= 90) || // A - Z
363                 (b >= 97 && b <= 122)   // a - z
364             )) {
365                 return false;
366             }
367         }
368         return true;
369     }
370 
371     /**
372      * Returns a concatenation of seven bytes.
373      * @param b1 The first bytes to be concatenated.
374      * ...
375      * @param b7 The last bytes to be concatenated.
376      */
377     function concatBytes(bytes b1, bytes b2, bytes b3, bytes b4, bytes b5, bytes b6, bytes b7) internal returns (bytes bFinal) {
378         bFinal = new bytes(b1.length + b2.length + b3.length + b4.length + b5.length + b6.length + b7.length);
379 
380         uint i = 0;
381         uint j;
382         for (j = 0; j < b1.length; j++) bFinal[i++] = b1[j];
383         for (j = 0; j < b2.length; j++) bFinal[i++] = b2[j];
384         for (j = 0; j < b3.length; j++) bFinal[i++] = b3[j];
385         for (j = 0; j < b4.length; j++) bFinal[i++] = b4[j];
386         for (j = 0; j < b5.length; j++) bFinal[i++] = b5[j];
387         for (j = 0; j < b6.length; j++) bFinal[i++] = b6[j];
388         for (j = 0; j < b7.length; j++) bFinal[i++] = b7[j];
389     }
390 
391     /**
392      * Returns the ShapeShift shift API string that is needed to be sent to Oraclize.
393      * @param _coinSymbol The coinsymbol of the other blockchain to be used by ShapeShift. See engine() function for more details.
394      * @param _toAddress The address on the other blockchain that the converted cryptocurrency will be sent to.
395      * Example output:
396      * ' {"withdrawal":"LbZcDdMeP96ko85H21TQii98YFF9RgZg3D","pair":"eth_ltc","returnAddress":"558999ff2e0daefcb4fcded4c89e07fdf9ccb56c"}'
397      * Note that an extra space ' ' is needed at the start to tell Oraclize to make a POST query
398      */
399     function createShapeShiftConversionPost(string _coinSymbol, string _toAddress) internal returns (string sFinal) {
400         string memory s1 = ' {"withdrawal":"';
401         string memory s3 = '","pair":"eth_';
402         string memory s5 = '","returnAddress":"';
403         string memory s7 = '"}';
404 
405         bytes memory bFinal = concatBytes(bytes(s1), bytes(_toAddress), bytes(s3), bytes(_coinSymbol), bytes(s5), bytes(addressToBytes(msg.sender)), bytes(s7));
406 
407         sFinal = string(bFinal);
408     }
409 
410     /**
411      * Returns the ASCII numeric or lower case character representation of a number.
412      * Authored by from https://github.com/axic
413      * @param nibble Nuber to be converted
414      */
415     function nibbleToChar(uint nibble) internal returns (uint ret) {
416         if (nibble > 9)
417         return nibble + 87; // nibble + 'a'- 10
418         else
419         return nibble + 48; // '0'
420     }
421 
422     /**
423      * Returns the bytes representation of a provided Ethereum address
424      * Authored by from https://github.com/axic
425      * @param _address Ethereum address to be cast to bytes
426      */
427     function addressToBytes(address _address) internal returns (bytes) {
428         uint160 tmp = uint160(_address);
429 
430         // 40 bytes of space, but actually uses 64 bytes
431         string memory holder = "                                        ";
432         bytes memory ret = bytes(holder);
433 
434         // NOTE: this is written in an expensive way, as out-of-order array access
435         //       is not supported yet, e.g. we cannot go in reverse easily
436         //       (or maybe it is a bug: https://github.com/ethereum/solidity/issues/212)
437         uint j = 0;
438         for (uint i = 0; i < 20; i++) {
439             uint _tmp = tmp / (2 ** (8*(19-i))); // shr(tmp, 8*(19-i))
440             uint nb1 = (_tmp / 0x10) & 0x0f;     // shr(tmp, 8) & 0x0f
441             uint nb2 = _tmp & 0x0f;
442             ret[j++] = byte(nibbleToChar(nb1));
443             ret[j++] = byte(nibbleToChar(nb2));
444         }
445 
446         return ret;
447     }
448 
449     // _______________PRIVATE FUNCTIONS_______________
450 
451 }