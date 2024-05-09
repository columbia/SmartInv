1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4     address public owner;
5 
6     modifier onlyOwner() {
7         require(msg.sender == owner);
8         _;
9     }
10 
11     function Ownable() public {
12         owner = msg.sender; 
13     }
14 
15     /**
16         @dev Transfers the ownership of the contract.
17 
18         @param _to Address of the new owner
19     */
20     function transferTo(address _to) public onlyOwner returns (bool) {
21         require(_to != address(0));
22         owner = _to;
23         return true;
24     } 
25 } 
26 
27 
28 contract Delegable is Ownable {
29     mapping(address => DelegateLog) public delegates;
30 
31     struct DelegateLog {
32         uint256 started;
33         uint256 ended;
34     }
35 
36     /**
37         @dev Only allows current delegates.
38     */
39     modifier onlyDelegate() {
40         DelegateLog memory delegateLog = delegates[msg.sender];
41         require(delegateLog.started != 0 && delegateLog.ended == 0);
42         _;
43     }
44     
45     /**
46         @dev Checks if a delegate existed at the timestamp.
47 
48         @param _address Address of the delegate
49         @param timestamp Moment to check
50 
51         @return true if at the timestamp the delegate existed
52     */
53     function wasDelegate(address _address, uint256 timestamp) public view returns (bool) {
54         DelegateLog memory delegateLog = delegates[_address];
55         return timestamp >= delegateLog.started && delegateLog.started != 0 && (delegateLog.ended == 0 || timestamp < delegateLog.ended);
56     }
57 
58     /**
59         @dev Checks if a delegate is active
60 
61         @param _address Address of the delegate
62         
63         @return true if the delegate is active
64     */
65     function isDelegate(address _address) public view returns (bool) {
66         DelegateLog memory delegateLog = delegates[_address];
67         return delegateLog.started != 0 && delegateLog.ended == 0;
68     }
69 
70     /**
71         @dev Adds a new worker.
72 
73         @param _address Address of the worker
74     */
75     function addDelegate(address _address) public onlyOwner returns (bool) {
76         DelegateLog storage delegateLog = delegates[_address];
77         require(delegateLog.started == 0);
78         delegateLog.started = block.timestamp;
79         return true;
80     }
81 
82     /**
83         @dev Removes an existing worker, removed workers can't be added back.
84 
85         @param _address Address of the worker to remove
86     */
87     function removeDelegate(address _address) public onlyOwner returns (bool) {
88         DelegateLog storage delegateLog = delegates[_address];
89         require(delegateLog.started != 0 && delegateLog.ended == 0);
90         delegateLog.ended = block.timestamp;
91         return true;
92     }
93 }
94 
95 /**
96     @dev Defines the interface of a standard RCN oracle.
97 
98     The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,
99     it's primarily used by the exchange but could be used by any other agent.
100 */
101 contract Oracle is Ownable {
102     uint256 public constant VERSION = 4;
103 
104     event NewSymbol(bytes32 _currency);
105 
106     mapping(bytes32 => bool) public supported;
107     bytes32[] public currencies;
108 
109     /**
110         @dev Returns the url where the oracle exposes a valid "oracleData" if needed
111     */
112     function url() public view returns (string);
113 
114     /**
115         @dev Returns a valid convertion rate from the currency given to RCN
116 
117         @param symbol Symbol of the currency
118         @param data Generic data field, could be used for off-chain signing
119     */
120     function getRate(bytes32 symbol, bytes data) public returns (uint256 rate, uint256 decimals);
121 
122     /**
123         @dev Adds a currency to the oracle, once added it cannot be removed
124 
125         @param ticker Symbol of the currency
126 
127         @return if the creation was done successfully
128     */
129     function addCurrency(string ticker) public onlyOwner returns (bool) {
130         bytes32 currency = encodeCurrency(ticker);
131         NewSymbol(currency);
132         supported[currency] = true;
133         currencies.push(currency);
134         return true;
135     }
136 
137     /**
138         @return the currency encoded as a bytes32
139     */
140     function encodeCurrency(string currency) public pure returns (bytes32 o) {
141         require(bytes(currency).length <= 32);
142         assembly {
143             o := mload(add(currency, 32))
144         }
145     }
146     
147     /**
148         @return the currency string from a encoded bytes32
149     */
150     function decodeCurrency(bytes32 b) public pure returns (string o) {
151         uint256 ns = 256;
152         while (true) { if (ns == 0 || (b<<ns-8) != 0) break; ns -= 8; }
153         assembly {
154             ns := div(ns, 8)
155             o := mload(0x40)
156             mstore(0x40, add(o, and(add(add(ns, 0x20), 0x1f), not(0x1f))))
157             mstore(o, ns)
158             mstore(add(o, 32), b)
159         }
160     }
161 }
162 
163 
164 contract RipioOracle is Oracle, Delegable {
165     uint256 public expiration = 15 minutes;
166 
167     uint constant private INDEX_TIMESTAMP = 0;
168     uint constant private INDEX_RATE = 1;
169     uint constant private INDEX_DECIMALS = 2;
170     uint constant private INDEX_V = 3;
171     uint constant private INDEX_R = 4;
172     uint constant private INDEX_S = 5;
173 
174     string private infoUrl;
175 
176     mapping(bytes32 => RateCache) private cache;
177 
178     address public fallback;
179 
180     struct RateCache {
181         uint256 timestamp;
182         uint256 rate;
183         uint256 decimals;
184     }
185 
186     function url() public view returns (string) {
187         return infoUrl;
188     }
189 
190     /**
191         @notice Sets the time window of the validity of the signed rates.
192         
193         @param time Duration of the window
194 
195         @return true is the time was set correctly
196     */
197     function setExpirationTime(uint256 time) public onlyOwner returns (bool) {
198         expiration = time;
199         return true;
200     }
201 
202     /**
203         @notice Sets the URL where the oracleData can be retrieved
204 
205         @param _url The URL
206 
207         @return true if it was set correctly
208     */
209     function setUrl(string _url) public onlyOwner returns (bool) {
210         infoUrl = _url;
211         return true;
212     }
213 
214     /**
215         @notice Sets the address of another contract to handle the requests of this contract,
216             it can be used to deprecate this Oracle
217 
218         @dev The fallback is only used if is not address(0)
219 
220         @param _fallback The address of the contract
221 
222         @return true if it was set correctly
223     */
224     function setFallback(address _fallback) public onlyOwner returns (bool) {
225         fallback = _fallback;
226         return true;
227     }
228 
229     /**
230         @notice Reads a bytes32 word of a bytes array
231 
232         @param data The bytes array
233         @param index The index of the word, in chunks of 32 bytes
234 
235         @return o The bytes32 word readed, or 0x0 if index out of bounds
236     */
237     function readBytes32(bytes data, uint256 index) internal pure returns (bytes32 o) {
238         if(data.length / 32 > index) {
239             assembly {
240                 o := mload(add(data, add(32, mul(32, index))))
241             }
242         }
243     }
244 
245     /**
246         @notice Executes a transaction from this contract
247 
248         @dev It can be used to retrieve lost tokens or ETH
249 
250         @param to Address to call
251         @param value Ethers to send
252         @param data Data for the call
253 
254         @return true If the call didn't throw an exception
255     */
256     function sendTransaction(address to, uint256 value, bytes data) public onlyOwner returns (bool) {
257         return to.call.value(value)(data);
258     }
259 
260 
261     /**
262         @dev Retrieves the convertion rate of a given currency, the information of the rate is carried over the 
263         data field. If there is a newer rate on the cache, that rate is delivered and the data field is ignored.
264 
265         If the data contains a more recent rate than the cache, the cache is updated.
266 
267         @param currency Hash of the currency
268         @param data Data with the rate signed by a delegate
269 
270         @return the rate and decimals of the currency convertion
271     */
272     function getRate(bytes32 currency, bytes data) public returns (uint256, uint256) {
273         if (fallback != address(0)) {
274             return Oracle(fallback).getRate(currency, data);
275         }
276 
277         uint256 timestamp = uint256(readBytes32(data, INDEX_TIMESTAMP));
278         require(timestamp <= block.timestamp);
279 
280         uint256 expirationTime = block.timestamp - expiration;
281 
282         if (cache[currency].timestamp >= timestamp && cache[currency].timestamp >= expirationTime) {
283             return (cache[currency].rate, cache[currency].decimals);
284         } else {
285             require(timestamp >= expirationTime);
286             uint256 rate = uint256(readBytes32(data, INDEX_RATE));
287             uint256 decimals = uint256(readBytes32(data, INDEX_DECIMALS));
288             uint8 v = uint8(readBytes32(data, INDEX_V));
289             bytes32 r = readBytes32(data, INDEX_R);
290             bytes32 s = readBytes32(data, INDEX_S);
291             
292             bytes32 _hash = keccak256(this, currency, rate, decimals, timestamp);
293             address signer = ecrecover(keccak256("\x19Ethereum Signed Message:\n32", _hash),v,r,s);
294 
295             require(isDelegate(signer));
296 
297             cache[currency] = RateCache(timestamp, rate, decimals);
298 
299             return (rate, decimals);
300         }
301     }
302 }