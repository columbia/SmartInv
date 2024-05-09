1 pragma solidity ^0.4.15;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner {
30     require(newOwner != address(0));      
31     owner = newOwner;
32   }
33 
34 }
35 
36 interface OraclizeI {
37     // address public cbAddress;
38     function cbAddress() constant returns (address); // Reads public variable cbAddress 
39     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
40     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
41     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
42     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
43     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
44     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
45     function getPrice(string _datasoaurce) returns (uint _dsprice);
46     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
47     function useCoupon(string _coupon);
48     function setProofType(byte _proofType);
49     function setConfig(bytes32 _config);
50     function setCustomGasPrice(uint _gasPrice);
51     function randomDS_getSessionPubKeyHash() returns(bytes32);
52 }
53 
54 interface OraclizeAddrResolverI {
55     function getAddress() returns (address _addr);
56 }
57 
58 // this is a reduced and optimize version of the usingOracalize contract in https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.4.sol
59 contract myUsingOracalize is Ownable {
60     OraclizeAddrResolverI OAR;
61     OraclizeI public oraclize;
62     uint public oracalize_gaslimit = 100000;
63 
64     function myUsingOracalize() {
65         oraclize_setNetwork();
66         update_oracalize();
67     }
68 
69     function update_oracalize() public {
70         oraclize = OraclizeI(OAR.getAddress());
71     }
72     
73     function oraclize_query(string datasource, string arg1, string arg2) internal returns (bytes32 id) {
74         uint price = oraclize.getPrice(datasource, oracalize_gaslimit);
75         if (price > 1 ether + tx.gasprice*oracalize_gaslimit) return 0; // unexpectedly high price
76         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, oracalize_gaslimit);
77     }
78     
79     function oraclize_getPrice(string datasource) internal returns (uint) {
80         return oraclize.getPrice(datasource, oracalize_gaslimit);
81     }
82 
83     function setGasLimit(uint _newLimit) onlyOwner public {
84         oracalize_gaslimit = _newLimit;
85     }
86     
87     function oraclize_setNetwork() internal {
88         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
89             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
90         }
91         else if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
92             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
93         }
94         else if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
95             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
96         }
97         else if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
98             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
99         }
100         else if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
101             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
102         }
103         else if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
104             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
105         }
106         else if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
107             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
108         }
109         else {
110             revert();
111         }
112     }
113 
114     function getCodeSize(address _addr) constant internal returns(uint _size) {
115         assembly {
116             _size := extcodesize(_addr)
117         }
118         return _size;
119     }
120 
121     // This will not throw error on wrong input, but instead consume large and unknown amount of gas
122     // This should never occure as it's use with the ShapeShift deposit return value is checked before calling function
123     function parseAddr(string _a) internal returns (address){
124         bytes memory tmp = bytes(_a);
125         uint160 iaddr = 0;
126         uint160 b1;
127         uint160 b2;
128         for (uint i=2; i<2+2*20; i+=2){
129             iaddr *= 256;
130             b1 = uint160(tmp[i]);
131             b2 = uint160(tmp[i+1]);
132             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
133             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
134             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
135             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
136             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
137             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
138             iaddr += (b1*16+b2);
139         }
140         return address(iaddr);
141     }
142 }
143 
144 /// @title Inter-crypto currency converter
145 /// @author Jack Tanner - <jnt16@ic.ac.uk>
146 contract InterCrypto is Ownable, myUsingOracalize {
147     // _______________VARIABLES_______________
148     struct Transaction {
149         address returnAddress;
150         uint amount;
151     }
152 
153     mapping (uint => Transaction) public transactions;
154     uint transactionCount = 0;
155     mapping (bytes32 => uint) oracalizeMyId2transactionID;
156     mapping (address => uint) public recoverable;
157 
158     // _______________EVENTS_______________
159     event TransactionStarted(uint indexed transactionID);
160     event TransactionSentToShapeShift(uint indexed transactionID, address indexed returnAddress, address indexed depositAddress, uint amount);
161     event TransactionAborted(uint indexed transactionID, string reason);
162     event Recovered(address indexed recoveredTo, uint amount);
163 
164     // _______________EXTERNAL FUNCTIONS_______________
165     // constructor
166     function InterCrypto() {}
167 
168     // suicide function
169     function kill() onlyOwner external {
170         selfdestruct(owner);
171     }
172 
173     // Default function which will accept Ether
174     function () payable {}
175 
176     // Return the price of using Oracalize
177     function getInterCryptoPrice() constant public returns (uint) {
178         return oraclize_getPrice('URL');
179     }
180 
181     // Create a cryptocurrency conversion using Oracalize and Shapeshift return address = msg.sender
182     function sendToOtherBlockchain1(string _coinSymbol, string _toAddress) external payable returns(uint) {
183         return engine(_coinSymbol, _toAddress, msg.sender);
184     }
185     
186     // Create a cryptocurrency conversion using Oracalize and custom Shapeshift return address
187     function sendToOtherBlockchain2(string _coinSymbol, string _toAddress, address _returnAddress) external payable returns(uint) {
188         return engine(_coinSymbol, _toAddress, _returnAddress);
189     }
190 
191     // Callback function for Oracalize
192     function __callback(bytes32 myid, string result) {
193         if (msg.sender != oraclize.cbAddress()) revert();
194 
195         uint transactionID = oracalizeMyId2transactionID[myid];
196         Transaction memory transaction = transactions[transactionID];
197         
198         if( bytes(result).length == 0 ) {
199             TransactionAborted(transactionID, "Oracalize return value was invalid, this is probably due to incorrect sendToOtherBlockchain() argments");
200             recoverable[transaction.returnAddress] += transaction.amount;
201             transaction.amount = 0;
202         }
203         else {
204             address depositAddress = parseAddr(result);
205             require(depositAddress != msg.sender); // prevent DAO tpe recursion hack that can potentially be done by oracalize
206             uint sendAmount = transaction.amount;
207             transaction.amount = 0;
208             if (depositAddress.send(sendAmount))
209                 TransactionSentToShapeShift(transactionID, transaction.returnAddress, depositAddress, sendAmount);
210             else {
211                 TransactionAborted(transactionID, "transaction to address returned by Oracalize failed");
212                 recoverable[transaction.returnAddress] += sendAmount;
213             }
214         }
215     }
216 
217     // Cancel a transaction that has not been completed
218     // Note that this should only be required if Oracalize should fail to respond
219     function cancelTransaction(uint transactionID) external {
220         Transaction memory transaction = transactions[transactionID];
221         
222         if (transaction.amount > 0) {
223             require(msg.sender == transaction.returnAddress);
224             recoverable[msg.sender] += transaction.amount;
225             transaction.amount = 0;
226             TransactionAborted(transactionID, "transaction cancelled by creator");
227         }
228     }
229 
230     // Send any pending funds back to their owner
231     function recover() external {
232         uint amount = recoverable[msg.sender];
233         recoverable[msg.sender] = 0;
234         if (msg.sender.send(amount)) {
235             Recovered(msg.sender, amount);
236         }
237         else {
238             recoverable[msg.sender] = amount;
239         }
240     }
241     // _______________PUBLIC FUNCTIONS_______________
242 
243 
244     // _______________INTERNAL FUNCTIONS_______________
245     // Request for a ShapeShift transaction to be made
246     function engine(string _coinSymbol, string _toAddress, address _returnAddress) internal returns(uint transactionID) {
247         // Example arguments:
248         // "ltc", "LbZcDdMeP96ko85H21TQii98YFF9RgZg3D"   Litecoin
249         // "btc", "1L8oRijgmkfcZDYA21b73b6DewLtyYs87s"   Bitcoin
250         // "dash", "Xoopows17idkTwNrMZuySXBwQDorsezQAx"  Dash
251         // "zec", "t1N7tf1xRxz5cBK51JADijLDWS592FPJtya"  ZCash
252         // "doge", "DMAFvwTH2upni7eTau8au6Rktgm2bUkMei"   Dogecoin
253         // See https://info.shapeshift.io/about
254         // Test symbol pairs using ShapeShift API (shapeshift.io/validateAddress/[address]/[coinSymbol]) or by creating a test
255         // transaction first whenever possible before using it with InterCrypto
256         
257         transactionID = transactionCount++;
258 
259         if (!isValidateParameter(_coinSymbol, 6) || !isValidateParameter(_toAddress, 120)) { // Waves smbol is "waves" , Monero integrated addresses are 106 characters
260             TransactionAborted(transactionID, "input parameters are too long or contain invalid symbols");
261             recoverable[msg.sender] += msg.value;
262             return;
263         }
264         
265         uint oracalizePrice = getInterCryptoPrice();
266 
267         if (msg.value > oracalizePrice) {
268             Transaction memory transaction = Transaction(_returnAddress, msg.value-oracalizePrice);
269             transactions[transactionID] = transaction;
270             
271             // Create post data string like ' {"withdrawal":"LbZcDdMeP96ko85H21TQii98YFF9RgZg3D","pair":"eth_ltc","returnAddress":"558999ff2e0daefcb4fcded4c89e07fdf9ccb56c"}'
272             string memory postData = createShapeShiftTransactionPost(_coinSymbol, _toAddress);
273 
274             // TODO: send custom gasLimit for retrn transaction equal to the exact cost of __callback. Note that this should only be donewhen the contract is finalized
275             bytes32 myQueryId = oraclize_query("URL", "json(https://shapeshift.io/shift).deposit", postData);
276             
277             if (myQueryId == 0) {
278                 TransactionAborted(transactionID, "unexpectedly high Oracalize price when calling oracalize_query");
279                 recoverable[msg.sender] += msg.value-oracalizePrice;
280                 transaction.amount = 0;
281                 return;
282             }
283             oracalizeMyId2transactionID[myQueryId] = transactionID;
284             TransactionStarted(transactionID);
285         }
286         else {
287             TransactionAborted(transactionID, "Not enough Ether sent to cover Oracalize fee");
288             // transactions[transactionID].amount = 0;
289             recoverable[msg.sender] += msg.value;
290         }
291     }
292     
293     // Adapted from https://github.com/kieranelby/KingOfTheEtherThrone/blob/master/contracts/KingOfTheEtherThrone.sol
294     function isValidateParameter(string _parameter, uint maxSize) constant internal returns (bool allowed) {
295         bytes memory parameterBytes = bytes(_parameter);
296         uint lengthBytes = parameterBytes.length;
297         if (lengthBytes < 1 ||
298             lengthBytes > maxSize) {
299             return false;
300         }
301         
302         for (uint i = 0; i < lengthBytes; i++) {
303             byte b = parameterBytes[i];
304             if ( !(
305                 (b >= 48 && b <= 57) || // 0 - 9
306                 (b >= 65 && b <= 90) || // A - Z
307                 (b >= 97 && b <= 122)   // a - z
308             )) {
309                 return false;
310             }
311         }
312         return true;
313     }
314     
315     function concatBytes(bytes b1, bytes b2, bytes b3, bytes b4, bytes b5, bytes b6, bytes b7) internal returns (bytes bFinal) {
316         bFinal = new bytes(b1.length + b2.length + b3.length + b4.length + b5.length + b6.length + b7.length);
317 
318         uint i = 0;
319         uint j;
320         for (j = 0; j < b1.length; j++) bFinal[i++] = b1[j];
321         for (j = 0; j < b2.length; j++) bFinal[i++] = b2[j];
322         for (j = 0; j < b3.length; j++) bFinal[i++] = b3[j];
323         for (j = 0; j < b4.length; j++) bFinal[i++] = b4[j];
324         for (j = 0; j < b5.length; j++) bFinal[i++] = b5[j];
325         for (j = 0; j < b6.length; j++) bFinal[i++] = b6[j];
326         for (j = 0; j < b7.length; j++) bFinal[i++] = b7[j];
327     }
328 
329     function createShapeShiftTransactionPost(string _coinSymbol, string _toAddress) internal returns (string sFinal) {
330         string memory s1 = ' {"withdrawal":"';
331         string memory s3 = '","pair":"eth_';
332         string memory s5 = '","returnAddress":"';
333         string memory s7 = '"}';
334 
335         bytes memory bFinal = concatBytes(bytes(s1), bytes(_toAddress), bytes(s3), bytes(_coinSymbol), bytes(s5), bytes(addressToBytes(msg.sender)), bytes(s7));
336 
337         sFinal = string(bFinal);
338     }
339 
340         // Authored by https://github.com/axic
341     function nibbleToChar(uint nibble) internal returns (uint ret) {
342         if (nibble > 9)
343         return nibble + 87; // nibble + 'a'- 10
344         else
345         return nibble + 48; // '0'
346     }
347 
348     // Authored by https://github.com/axic
349     function addressToBytes(address _address) internal returns (bytes) {
350         uint160 tmp = uint160(_address);
351 
352         // 40 bytes of space, but actually uses 64 bytes
353         string memory holder = "                                        ";
354         bytes memory ret = bytes(holder);
355 
356         // NOTE: this is written in an expensive way, as out-of-order array access
357         //       is not supported yet, e.g. we cannot go in reverse easily
358         //       (or maybe it is a bug: https://github.com/ethereum/solidity/issues/212)
359         uint j = 0;
360         for (uint i = 0; i < 20; i++) {
361             uint _tmp = tmp / (2 ** (8*(19-i))); // shr(tmp, 8*(19-i))
362             uint nb1 = (_tmp / 0x10) & 0x0f;     // shr(tmp, 8) & 0x0f
363             uint nb2 = _tmp & 0x0f;
364             ret[j++] = byte(nibbleToChar(nb1));
365             ret[j++] = byte(nibbleToChar(nb2));
366         }
367 
368         return ret;
369     }
370 
371     // _______________PRIVATE FUNCTIONS_______________
372 
373 }