1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     require(newOwner != address(0));      
37     owner = newOwner;
38   }
39 
40 }
41 
42 interface OraclizeI {
43     // address public cbAddress;
44     function cbAddress() constant returns (address); // Reads public variable cbAddress
45     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
46     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
47     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
48     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
49     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
50     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
51     function getPrice(string _datasoaurce) returns (uint _dsprice);
52     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
53     function useCoupon(string _coupon);
54     function setProofType(byte _proofType);
55     function setConfig(bytes32 _config);
56     function setCustomGasPrice(uint _gasPrice);
57     function randomDS_getSessionPubKeyHash() returns(bytes32);
58 }
59 
60 interface OraclizeAddrResolverI {
61     function getAddress() returns (address _addr);
62 }
63 
64 // this is a reduced and optimize version of the usingOraclize contract in https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.4.sol
65 contract myUsingOraclize is Ownable {
66     OraclizeAddrResolverI OAR;
67     OraclizeI public oraclize;
68     uint public oraclize_gaslimit = 120000;
69 
70     function myUsingOraclize() {
71         oraclize_setNetwork();
72         update_oraclize();
73     }
74 
75     function update_oraclize() onlyOwner public {
76         oraclize = OraclizeI(OAR.getAddress());
77     }
78 
79     function oraclize_query(string datasource, string arg1, string arg2) internal returns (bytes32 id) {
80         uint price = oraclize.getPrice(datasource, oraclize_gaslimit);
81         if (price > 1 ether + tx.gasprice*oraclize_gaslimit) return 0; // unexpectedly high price
82         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, oraclize_gaslimit);
83     }
84 
85     function oraclize_getPrice(string datasource) internal returns (uint) {
86         return oraclize.getPrice(datasource, oraclize_gaslimit);
87     }
88 
89 
90     function setGasLimit(uint _newLimit) onlyOwner public {
91         oraclize_gaslimit = _newLimit;
92     }
93 
94     function oraclize_setNetwork() internal {
95         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
96             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
97         }
98         else if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
99             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
100         }
101         else if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
102             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
103         }
104         else if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
105             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
106         }
107         else if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
108             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
109         }
110         else if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
111             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
112         }
113         else if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
114             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
115         }
116         else {
117             revert();
118         }
119     }
120 
121     function getCodeSize(address _addr) constant internal returns(uint _size) {
122         assembly {
123             _size := extcodesize(_addr)
124         }
125         return _size;
126     }
127 
128     // This will not throw error on wrong input, but instead consume large and unknown amount of gas
129     // This should never occure as it's use with the ShapeShift deposit return value is checked before calling function
130     function parseAddr(string _a) internal returns (address){
131         bytes memory tmp = bytes(_a);
132         uint160 iaddr = 0;
133         uint160 b1;
134         uint160 b2;
135         for (uint i=2; i<2+2*20; i+=2){
136             iaddr *= 256;
137             b1 = uint160(tmp[i]);
138             b2 = uint160(tmp[i+1]);
139             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
140             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
141             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
142             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
143             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
144             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
145             iaddr += (b1*16+b2);
146         }
147         return address(iaddr);
148     }
149 }
150 
151 /**
152  * @title InterCrypto
153  * @dev The InterCrypto offers a no-commission service using Oraclize and ShapeShift
154  * that allows for on-blockchain conversion from Ether to any other blockchain that ShapeShift supports.
155  * @author Jack Tanner - <jnt16@ic.ac.uk>
156  */
157 contract InterCrypto is Ownable, myUsingOraclize {
158     // _______________VARIABLES_______________
159     struct Conversion {
160         address returnAddress;
161         uint amount;
162     }
163 
164     mapping (uint => Conversion) public conversions;
165     uint conversionCount = 0;
166     mapping (bytes32 => uint) oraclizeMyId2conversionID;
167     mapping (address => uint) public recoverable;
168 
169     // _______________EVENTS_______________
170     event ConversionStarted(uint indexed conversionID);
171     event ConversionSentToShapeShift(uint indexed conversionID, address indexed returnAddress, address indexed depositAddress, uint amount);
172     event ConversionAborted(uint indexed conversionID, string reason);
173     event Recovered(address indexed recoveredTo, uint amount);
174 
175     // _______________EXTERNAL FUNCTIONS_______________
176     /**
177      * Constructor.
178      */
179     function InterCrypto() {}
180 
181     /**
182      * Destroys the contract and returns and Ether to the owner.
183      */
184     function kill() onlyOwner external {
185         selfdestruct(owner);
186     }
187 
188     /**
189      * Fallback function to allow contract to accept Ether.
190      */
191     function () payable {}
192 
193     /**
194      * Sets up a ShapeShift cryptocurrency conversion using Oraclize and the ShapeShift API. Must be sent more Ether than the Oraclize price.
195      * Returns a conversionID which can be used for tracking of the conversion.
196      * @param _coinSymbol The coinsymbol of the other blockchain to be used by ShapeShift. See engine() function for more details.
197      * @param _toAddress The address on the other blockchain that the converted cryptocurrency will be sent to.
198      */
199     function convert1(string _coinSymbol, string _toAddress) external payable returns(uint) {
200         return engine(_coinSymbol, _toAddress, msg.sender);
201     }
202 
203     /**
204      * Sets up a ShapeShift cryptocurrency conversion using Oraclize and the ShapeShift API. Must be sent more Ether than the Oraclize price.
205      * Returns a conversionID which can be used for tracking of the conversion.
206      * @param _coinSymbol The coinsymbol of the other blockchain to be used by ShapeShift. See engine() function for more details.
207      * @param _toAddress The address on the other blockchain that the converted cryptocurrency will be sent to.
208      * @param _returnAddress The Ethereum address that any Ether should be sent back to in the event that the ShapeShift conversion is invalid or fails
209      */
210     function convert2(string _coinSymbol, string _toAddress, address _returnAddress) external payable returns(uint) {
211         return engine(_coinSymbol, _toAddress, _returnAddress);
212     }
213 
214     /**
215      * Callback function for use exclusively by Oraclize.
216      * @param myid The Oraclize id of the query.
217      * @param result The result of the query.
218      */
219     function __callback(bytes32 myid, string result) {
220         if (msg.sender != oraclize.cbAddress()) revert();
221 
222         uint conversionID = oraclizeMyId2conversionID[myid];
223 
224         if( bytes(result).length == 0 ) {
225             ConversionAborted(conversionID, "Oraclize return value was invalid, this is probably due to incorrect convert() argments");
226             recoverable[conversions[conversionID].returnAddress] += conversions[conversionID].amount;
227             conversions[conversionID].amount = 0;
228         }
229         else {
230             address depositAddress = parseAddr(result);
231             require(depositAddress != msg.sender); // prevent DAO tpe re-entracy vulnerability that can potentially be done by Oraclize
232             uint sendAmount = conversions[conversionID].amount;
233             conversions[conversionID].amount = 0;
234             if (depositAddress.send(sendAmount)) {
235                 ConversionSentToShapeShift(conversionID, conversions[conversionID].returnAddress, depositAddress, sendAmount);
236             }
237             else {
238                 ConversionAborted(conversionID, "deposit to address returned by Oraclize failed");
239                 recoverable[conversions[conversionID].returnAddress] += sendAmount;
240             }
241         }
242     }
243 
244     /**
245      * Cancel a cryptocurrency conversion.
246      * This should only be required to be called if Oraclize fails make a return call to __callback().
247      * @param conversionID The conversion ID of the cryptocurrency conversion, generated during engine().
248      */
249      function cancelConversion(uint conversionID) external {
250         Conversion memory conversion = conversions[conversionID];
251 
252         if (conversion.amount > 0) {
253             require(msg.sender == conversion.returnAddress);
254             recoverable[msg.sender] += conversion.amount;
255             conversions[conversionID].amount = 0;
256             ConversionAborted(conversionID, "conversion cancelled by creator");
257         }
258     }
259 
260     /**
261      * Recover any recoverable funds due to the failure of InterCrypto. Failure can occure due to:
262      * 1. Bad user inputs to convert().
263      * 2. ShapeShift temporarily or permanently discontinues support of other blockchain.
264      * 3. ShapeShift service becomes unavailable.
265      * 4. Oraclize service become unavailable.
266      */
267      function recover() external {
268         uint amount = recoverable[msg.sender];
269         recoverable[msg.sender] = 0;
270         if (msg.sender.send(amount)) {
271             Recovered(msg.sender, amount);
272         }
273         else {
274             recoverable[msg.sender] = amount;
275         }
276     }
277     // _______________PUBLIC FUNCTIONS_______________
278     /**
279      * Returns the price in Wei paid to Oraclize.
280      */
281     function getInterCryptoPrice() constant public returns (uint) {
282         return oraclize_getPrice('URL');
283     }
284 
285     // _______________INTERNAL FUNCTIONS_______________
286     /**
287      * Sets up a ShapeShift cryptocurrency conversion using Oraclize and the ShapeShift API. Must be sent more Ether than the Oraclize price.
288      * Returns a conversionID which can be used for tracking of the conversion.
289      * @param _coinSymbol The coinsymbol of the other blockchain to be used by ShapeShift. See engine() function for more details.
290      * @param _toAddress The address on the other blockchain that the converted cryptocurrency will be sent to.
291      * Example first two arguments:
292      * "ltc", "LbZcDdMeP96ko85H21TQii98YFF9RgZg3D"    Litecoin
293      * "btc", "1L8oRijgmkfcZDYA21b73b6DewLtyYs87s"    Bitcoin
294      * "dash", "Xoopows17idkTwNrMZuySXBwQDorsezQAx"   Dash
295      * "zec", "t1N7tf1xRxz5cBK51JADijLDWS592FPJtya"   ZCash
296      * "doge", "DMAFvwTH2upni7eTau8au6Rktgm2bUkMei"   Dogecoin
297      * Test symbol pairs using ShapeShift API (shapeshift.io/validateAddress/[address]/[coinSymbol]) or by creating a test
298      * conversion on https://shapeshift.io first whenever possible before using it with InterCrypto.
299      * @param _returnAddress The Ethereum address that any Ether should be sent back to in the event that the ShapeShift conversion is invalid or fails.
300      */
301     function engine(string _coinSymbol, string _toAddress, address _returnAddress) internal returns(uint conversionID) {
302         conversionID = conversionCount++;
303 
304         if (
305             !isValidString(_coinSymbol, 6) || // Waves smbol is "waves"
306             !isValidString(_toAddress, 120)   // Monero integrated addresses are 106 characters
307             ) {
308             ConversionAborted(conversionID, "input parameters are too long or contain invalid symbols");
309             recoverable[msg.sender] += msg.value;
310             return;
311         }
312 
313         uint oraclizePrice = getInterCryptoPrice();
314 
315         if (msg.value > oraclizePrice) {
316             Conversion memory conversion = Conversion(_returnAddress, msg.value-oraclizePrice);
317             conversions[conversionID] = Conversion(_returnAddress, msg.value-oraclizePrice);
318 
319             string memory postData = createShapeShiftConversionPost(_coinSymbol, _toAddress);
320             bytes32 myQueryId = oraclize_query("URL", "json(https://shapeshift.io/shift).deposit", postData);
321 
322             if (myQueryId == 0) {
323                 ConversionAborted(conversionID, "unexpectedly high Oraclize price when calling oraclize_query");
324                 recoverable[msg.sender] += msg.value-oraclizePrice;
325                 conversions[conversionID].amount = 0;
326                 return;
327             }
328             oraclizeMyId2conversionID[myQueryId] = conversionID;
329             ConversionStarted(conversionID);
330         }
331         else {
332             ConversionAborted(conversionID, "Not enough Ether sent to cover Oraclize fee");
333             conversions[conversionID].amount = 0;
334             recoverable[msg.sender] += msg.value;
335         }
336     }
337 
338     /**
339      * Returns true if a given string contains only numbers and letters, and is below a maximum length.
340      * @param _string String to be checked.
341      * @param maxSize The maximum allowable sting character length. The address on the other blockchain that the converted cryptocurrency will be sent to.
342      */
343     function isValidString(string _string, uint maxSize) constant internal returns (bool allowed) {
344         bytes memory stringBytes = bytes(_string);
345         uint lengthBytes = stringBytes.length;
346         if (lengthBytes < 1 ||
347             lengthBytes > maxSize) {
348             return false;
349         }
350 
351         for (uint i = 0; i < lengthBytes; i++) {
352             byte b = stringBytes[i];
353             if ( !(
354                 (b >= 48 && b <= 57) || // 0 - 9
355                 (b >= 65 && b <= 90) || // A - Z
356                 (b >= 97 && b <= 122)   // a - z
357             )) {
358                 return false;
359             }
360         }
361         return true;
362     }
363 
364     /**
365      * Returns a concatenation of seven bytes.
366      * @param b1 The first bytes to be concatenated.
367      * ...
368      * @param b7 The last bytes to be concatenated.
369      */
370     function concatBytes(bytes b1, bytes b2, bytes b3, bytes b4, bytes b5, bytes b6, bytes b7) internal returns (bytes bFinal) {
371         bFinal = new bytes(b1.length + b2.length + b3.length + b4.length + b5.length + b6.length + b7.length);
372 
373         uint i = 0;
374         uint j;
375         for (j = 0; j < b1.length; j++) bFinal[i++] = b1[j];
376         for (j = 0; j < b2.length; j++) bFinal[i++] = b2[j];
377         for (j = 0; j < b3.length; j++) bFinal[i++] = b3[j];
378         for (j = 0; j < b4.length; j++) bFinal[i++] = b4[j];
379         for (j = 0; j < b5.length; j++) bFinal[i++] = b5[j];
380         for (j = 0; j < b6.length; j++) bFinal[i++] = b6[j];
381         for (j = 0; j < b7.length; j++) bFinal[i++] = b7[j];
382     }
383 
384     /**
385      * Returns the ShapeShift shift API string that is needed to be sent to Oraclize.
386      * @param _coinSymbol The coinsymbol of the other blockchain to be used by ShapeShift. See engine() function for more details.
387      * @param _toAddress The address on the other blockchain that the converted cryptocurrency will be sent to.
388      * Example output:
389      * ' {"withdrawal":"LbZcDdMeP96ko85H21TQii98YFF9RgZg3D","pair":"eth_ltc","returnAddress":"558999ff2e0daefcb4fcded4c89e07fdf9ccb56c"}'
390      * Note that an extra space ' ' is needed at the start to tell Oraclize to make a POST query
391      */
392     function createShapeShiftConversionPost(string _coinSymbol, string _toAddress) internal returns (string sFinal) {
393         string memory s1 = ' {"withdrawal":"';
394         string memory s3 = '","pair":"eth_';
395         string memory s5 = '","returnAddress":"';
396         string memory s7 = '"}';
397 
398         bytes memory bFinal = concatBytes(bytes(s1), bytes(_toAddress), bytes(s3), bytes(_coinSymbol), bytes(s5), bytes(addressToBytes(msg.sender)), bytes(s7));
399 
400         sFinal = string(bFinal);
401     }
402 
403     /**
404      * Returns the ASCII numeric or lower case character representation of a number.
405      * Authored by from https://github.com/axic
406      * @param nibble Nuber to be converted
407      */
408     function nibbleToChar(uint nibble) internal returns (uint ret) {
409         if (nibble > 9)
410         return nibble + 87; // nibble + 'a'- 10
411         else
412         return nibble + 48; // '0'
413     }
414 
415     /**
416      * Returns the bytes representation of a provided Ethereum address
417      * Authored by from https://github.com/axic
418      * @param _address Ethereum address to be cast to bytes
419      */
420     function addressToBytes(address _address) internal returns (bytes) {
421         uint160 tmp = uint160(_address);
422 
423         // 40 bytes of space, but actually uses 64 bytes
424         string memory holder = "                                        ";
425         bytes memory ret = bytes(holder);
426 
427         // NOTE: this is written in an expensive way, as out-of-order array access
428         //       is not supported yet, e.g. we cannot go in reverse easily
429         //       (or maybe it is a bug: https://github.com/ethereum/solidity/issues/212)
430         uint j = 0;
431         for (uint i = 0; i < 20; i++) {
432             uint _tmp = tmp / (2 ** (8*(19-i))); // shr(tmp, 8*(19-i))
433             uint nb1 = (_tmp / 0x10) & 0x0f;     // shr(tmp, 8) & 0x0f
434             uint nb2 = _tmp & 0x0f;
435             ret[j++] = byte(nibbleToChar(nb1));
436             ret[j++] = byte(nibbleToChar(nb2));
437         }
438 
439         return ret;
440     }
441 
442     // _______________PRIVATE FUNCTIONS_______________
443 
444 }