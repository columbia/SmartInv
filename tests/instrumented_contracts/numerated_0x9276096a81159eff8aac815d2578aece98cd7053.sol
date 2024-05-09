1 pragma solidity 0.4.24;
2 
3 
4 contract OraclizeI {
5 
6     address public cbAddress;
7     function setProofType(byte _proofType) external;
8 
9     function setCustomGasPrice(uint _gasPrice) external;
10 
11     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
12     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
13 
14     function query(uint _timestamp, string _datasource, string _arg)
15         external
16         payable
17         returns (bytes32 _id);
18 
19     function getPrice(string _datasource) public returns (uint _dsprice);
20 }
21 
22 
23 contract OraclizeAddrResolverI {
24     function getAddress() public returns (address _addr);
25 }
26 
27 
28 contract UsingOraclize {
29 
30     byte constant internal proofType_Ledger = 0x30;
31     byte constant internal proofType_Android = 0x40;
32     byte constant internal proofStorage_IPFS = 0x01;
33     uint8 constant internal networkID_auto = 0;
34     uint8 constant internal networkID_mainnet = 1;
35     uint8 constant internal networkID_testnet = 2;
36 
37     OraclizeAddrResolverI OAR;
38 
39     OraclizeI oraclize;
40 
41     modifier oraclizeAPI {
42         if ((address(OAR) == 0)||(getCodeSize(address(OAR)) == 0))
43             oraclize_setNetwork(networkID_auto);
44 
45         if (address(oraclize) != OAR.getAddress())
46             oraclize = OraclizeI(OAR.getAddress());
47 
48         _;
49     }
50 
51     function oraclize_setNetwork(uint8 networkID) internal returns(bool) {
52         return oraclize_setNetwork();
53         /* solium-disable-next-line */
54         networkID; // silence the warning and remain backwards compatible
55     }
56 
57     function oraclize_setNetwork() internal returns(bool){
58         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0){ //mainnet
59             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
60             oraclize_setNetworkName("eth_mainnet");
61             return true;
62         }
63         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
64             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
65             oraclize_setNetworkName("eth_ropsten3");
66             return true;
67         }
68         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0){ //kovan testnet
69             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
70             oraclize_setNetworkName("eth_kovan");
71             return true;
72         }
73         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
74             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
75             oraclize_setNetworkName("eth_rinkeby");
76             return true;
77         }
78         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
79             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
80             return true;
81         }
82         return false;
83     }
84 
85     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
86         return oraclize.getPrice(datasource);
87     }
88 
89     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
90         return oraclize.getPrice(datasource, gaslimit);
91     }
92 
93     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
94         uint price = oraclize.getPrice(datasource);
95         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
96         return oraclize.query.value(price)(0, datasource, arg);
97     }
98 
99     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
100         uint price = oraclize.getPrice(datasource, gaslimit);
101         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
102         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
103     }
104 
105     function oraclize_query(uint timestamp, string datasource, string arg)
106         oraclizeAPI
107         internal
108         returns (bytes32 id)
109     {
110         uint price = oraclize.getPrice(datasource);
111         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
112         return oraclize.query.value(price)(timestamp, datasource, arg);
113     }
114 
115     function oraclize_cbAddress() internal oraclizeAPI returns (address) {
116         return oraclize.cbAddress();
117     }
118 
119     function oraclize_setProof(byte proofP) internal oraclizeAPI {
120         return oraclize.setProofType(proofP);
121     }
122 
123     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
124         return oraclize.setCustomGasPrice(gasPrice);
125     }
126 
127     function getCodeSize(address _addr) internal view returns(uint _size) {
128         /* solium-disable-next-line */
129         assembly {
130             _size := extcodesize(_addr)
131         }
132     }
133 
134     /* solium-disable-next-line */ // parseInt(parseFloat*10^_b)
135     function parseInt(string _a, uint _b) internal pure returns (uint) {
136         bytes memory bresult = bytes(_a);
137         uint mint = 0;
138         bool decimals = false;
139         for (uint i = 0; i < bresult.length; i++) {
140             if ((bresult[i] >= 48)&&(bresult[i] <= 57)) {
141                 if (decimals) {
142                     if (_b == 0) break;
143                     else _b--;
144                 }
145                 mint *= 10;
146                 mint += uint(bresult[i]) - 48;
147             } else if (bresult[i] == 46) decimals = true;
148         }
149         if (_b > 0) mint *= 10**_b;
150         return mint;
151     }
152 
153     string public oraclize_network_name;
154 
155     function oraclize_setNetworkName(string _networkName) internal {
156         oraclize_network_name = _networkName;
157     }
158 
159 }
160 
161 
162 /**
163  * @title SafeMath
164  * @dev Math operations with safety checks that throw on error
165  */
166 library SafeMath {
167 
168     /**
169     * @dev Multiplies two numbers, throws on overflow.
170     */
171     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
172         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
173         // benefit is lost if 'b' is also tested.
174         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
175         if (a == 0) {
176             return 0;
177         }
178 
179         c = a * b;
180         assert(c / a == b);
181         return c;
182     }
183 
184     /**
185     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
186     */
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         assert(b <= a);
189         return a - b;
190     }
191 
192     /**
193     * @dev Adds two numbers, throws on overflow.
194     */
195     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
196         c = a + b;
197         assert(c >= a);
198         return c;
199     }
200 
201     function pow(uint256 a, uint256 power) internal pure returns (uint256 result) {
202         assert(a >= 0);
203         result = 1;
204         for (uint256 i = 0; i < power; i++) {
205             result *= a;
206             assert(result >= a);
207         }
208     }
209 }
210 
211 
212 /**
213  * @title Ownable
214  * @dev The Ownable contract has an owner address, and provides basic authorization control
215  * functions, this simplifies the implementation of "user permissions".
216  */
217 contract Ownable {
218 
219     address public owner;
220     address public pendingOwner;
221 
222     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
223 
224     /**
225     * @dev Throws if called by any account other than the owner.
226     */
227     modifier onlyOwner() {
228         require(msg.sender == owner);
229         _;
230     }
231 
232     /**
233     * @dev Modifier throws if called by any account other than the pendingOwner.
234     */
235     modifier onlyPendingOwner() {
236         require(msg.sender == pendingOwner);
237         _;
238     }
239 
240     constructor() public {
241         owner = msg.sender;
242     }
243 
244     /**
245     * @dev Allows the current owner to set the pendingOwner address.
246     * @param newOwner The address to transfer ownership to.
247     */
248     function transferOwnership(address newOwner) public onlyOwner {
249         pendingOwner = newOwner;
250     }
251 
252     /**
253     * @dev Allows the pendingOwner address to finalize the transfer.
254     */
255     function claimOwnership() public onlyPendingOwner {
256         emit OwnershipTransferred(owner, pendingOwner);
257         owner = pendingOwner;
258         pendingOwner = address(0);
259     }
260 }
261 
262 
263 /**
264  * @title Whitelist
265  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
266  * @dev This simplifies the implementation of "user permissions".
267  */
268 contract Accessable is Ownable {
269 
270     uint256 public billingPeriod = 28 days;
271 
272     uint256 public oneTimePrice = 200 szabo;
273 
274     uint256 public billingAmount = 144 finney;
275 
276     mapping(address => uint256) public access;
277 
278     event AccessGranted(address addr, uint256 expired);
279 
280     /**
281      * @dev Throws if called by any account that's not whitelisted.
282      */
283     modifier onlyPayed() {
284         require(access[msg.sender] > now || msg.value == oneTimePrice);
285         _;
286     }
287 
288     function () external payable {
289         processPurchase(msg.sender);
290     }
291 
292     //we need to increase the price when the network is under heavy load
293     function setOneTimePrice(uint256 _priceInWei) external onlyOwner {
294         require(_priceInWei < 2000 szabo);
295         oneTimePrice = _priceInWei;
296     }
297 
298     function setbillingAmount(uint256 _priceInWei) external onlyOwner {
299         require(_priceInWei < oneTimePrice * 24 * billingPeriod);
300         billingAmount = _priceInWei;
301     }
302 
303     function hasAccess(address _who) external returns(bool) {
304         return access[_who] > now;
305     }
306 
307     function processPurchase(address _beneficiary) public payable {
308         require(_beneficiary != address(0));
309         uint256 _units = msg.value / billingAmount;
310         require(_units > 0);
311         uint256 _remainder = msg.value % billingAmount;
312         _beneficiary.transfer(_remainder);
313         grantAccess(_beneficiary, _units);
314     }
315 
316     /**
317      * @dev add an address to the whitelist
318      */
319     function grantAccess(address _addr, uint256 _periods) internal {
320         uint256 _accessExpTime;
321         if (access[_addr] < now) {
322             _accessExpTime = now + billingPeriod * _periods;
323         } else {
324             _accessExpTime = _accessExpTime + billingPeriod * _periods;
325         }
326         access[_addr] = _accessExpTime;
327         emit AccessGranted(_addr, _accessExpTime);
328     }
329 }
330 
331 
332 contract Reoraclizer is UsingOraclize, Accessable {
333     using SafeMath for uint256;
334 
335     uint256 public lastTimeUpdate;
336     uint256 minUpdatePeriod = 3300; // min update period
337 
338     string internal response; //price in cents
339 
340     uint256 internal CALLBACK_GAS_LIMIT = 115000;
341 
342     // will rewritten after deploying
343     // needs to prevent high gas price at first oraclize response
344     uint256 internal price = 999999;
345 
346     event NewOraclizeQuery(string description);
347 
348     constructor() public {
349         oraclize_setProof(proofType_Android | proofStorage_IPFS);
350         oraclize_setCustomGasPrice(10000000000);
351     }
352 
353     /**
354     * @dev Receives the response from oraclize.
355     */
356     function __callback(bytes32 _myid, string _result, bytes _proof) public {
357         require((lastTimeUpdate + minUpdatePeriod) < now);
358         if (msg.sender != oraclize_cbAddress()) revert();
359 
360         price = parseInt(_result, 4);
361         lastTimeUpdate = now;
362 
363         _update(3600);
364     }
365 
366     function getEthUsdPrice() external onlyPayed payable returns(uint256) {
367         return price;
368     }
369 
370     /**
371      * @dev Cyclic query to update ETHUSD price. Period is one hour.
372      */
373     function _update(uint256 _timeout) internal {
374         oraclize_query(_timeout, "URL", "json(https://api.coinmarketcap.com/v2/ticker/1027).data.quotes.USD.price", CALLBACK_GAS_LIMIT);
375     }
376 
377     function update(uint256 _timeout) public payable onlyOwner {
378         _update(_timeout);
379     }
380 
381     function setOraclizeGasLimit (uint256 _gasLimit) external onlyOwner {
382         CALLBACK_GAS_LIMIT = _gasLimit;
383     }
384 
385     function setGasPrice(uint256 _gasPrice) external onlyOwner {
386         oraclize_setCustomGasPrice(_gasPrice);
387     }
388 
389     function withdrawEth(uint256 _value) external onlyOwner {
390         require(address(this).balance > _value.add(3 ether));
391         owner.transfer(_value);
392     }
393 
394     function setMinUpdatePeriod(uint256 _minUpdatePeriod) external onlyOwner {
395         minUpdatePeriod = _minUpdatePeriod;
396     }
397 }