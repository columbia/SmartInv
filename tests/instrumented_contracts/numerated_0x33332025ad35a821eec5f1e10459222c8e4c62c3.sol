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
20     function setOwner(address _to) public onlyOwner returns (bool) {
21         require(_to != address(0));
22         owner = _to;
23         return true;
24     } 
25 }
26 
27 
28 contract Delegable is Ownable {
29     event AddDelegate(address delegate);
30     event RemoveDelegate(address delegate);
31 
32     mapping(address => DelegateLog) public delegates;
33 
34     struct DelegateLog {
35         uint256 started;
36         uint256 ended;
37     }
38 
39     /**
40         @dev Only allows current delegates.
41     */
42     modifier onlyDelegate() {
43         DelegateLog memory delegateLog = delegates[msg.sender];
44         require(delegateLog.started != 0 && delegateLog.ended == 0);
45         _;
46     }
47     
48     /**
49         @dev Checks if a delegate existed at the timestamp.
50 
51         @param _address Address of the delegate
52         @param timestamp Moment to check
53 
54         @return true if at the timestamp the delegate existed
55     */
56     function wasDelegate(address _address, uint256 timestamp) public view returns (bool) {
57         DelegateLog memory delegateLog = delegates[_address];
58         return timestamp >= delegateLog.started && delegateLog.started != 0 && (delegateLog.ended == 0 || timestamp < delegateLog.ended);
59     }
60 
61     /**
62         @dev Checks if a delegate is active
63 
64         @param _address Address of the delegate
65         
66         @return true if the delegate is active
67     */
68     function isDelegate(address _address) public view returns (bool) {
69         DelegateLog memory delegateLog = delegates[_address];
70         return delegateLog.started != 0 && delegateLog.ended == 0;
71     }
72 
73     /**
74         @dev Adds a new worker.
75 
76         @param _address Address of the worker
77     */
78     function addDelegate(address _address) public onlyOwner returns (bool) {
79         DelegateLog storage delegateLog = delegates[_address];
80         require(delegateLog.started == 0);
81         delegateLog.started = block.timestamp;
82         emit AddDelegate(_address);
83         return true;
84     }
85 
86     /**
87         @dev Removes an existing worker, removed workers can't be added back.
88 
89         @param _address Address of the worker to remove
90     */
91     function removeDelegate(address _address) public onlyOwner returns (bool) {
92         DelegateLog storage delegateLog = delegates[_address];
93         require(delegateLog.started != 0 && delegateLog.ended == 0);
94         delegateLog.ended = block.timestamp;
95         emit RemoveDelegate(_address);
96         return true;
97     }
98 }
99 
100 contract BytesUtils {
101     function readBytes32(bytes data, uint256 index) internal pure returns (bytes32 o) {
102         require(data.length / 32 > index);
103         assembly {
104             o := mload(add(data, add(32, mul(32, index))))
105         }
106     }
107 }
108 
109 contract Token {
110     function transfer(address _to, uint _value) public returns (bool success);
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
112     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
113     function approve(address _spender, uint256 _value) public returns (bool success);
114     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
115     function balanceOf(address _owner) public view returns (uint256 balance);
116 }
117 
118 
119 /**
120     @dev Defines the interface of a standard RCN oracle.
121 
122     The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,
123     it's primarily used by the exchange but could be used by any other agent.
124 */
125 contract Oracle is Ownable {
126     uint256 public constant VERSION = 4;
127 
128     event NewSymbol(bytes32 _currency);
129 
130     mapping(bytes32 => bool) public supported;
131     bytes32[] public currencies;
132 
133     /**
134         @dev Returns the url where the oracle exposes a valid "oracleData" if needed
135     */
136     function url() public view returns (string);
137 
138     /**
139         @dev Returns a valid convertion rate from the currency given to RCN
140 
141         @param symbol Symbol of the currency
142         @param data Generic data field, could be used for off-chain signing
143     */
144     function getRate(bytes32 symbol, bytes data) public returns (uint256 rate, uint256 decimals);
145 
146     /**
147         @dev Adds a currency to the oracle, once added it cannot be removed
148 
149         @param ticker Symbol of the currency
150 
151         @return if the creation was done successfully
152     */
153     function addCurrency(string ticker) public onlyOwner returns (bool) {
154         bytes32 currency = encodeCurrency(ticker);
155         NewSymbol(currency);
156         supported[currency] = true;
157         currencies.push(currency);
158         return true;
159     }
160 
161     /**
162         @return the currency encoded as a bytes32
163     */
164     function encodeCurrency(string currency) public pure returns (bytes32 o) {
165         require(bytes(currency).length <= 32);
166         assembly {
167             o := mload(add(currency, 32))
168         }
169     }
170     
171     /**
172         @return the currency string from a encoded bytes32
173     */
174     function decodeCurrency(bytes32 b) public pure returns (string o) {
175         uint256 ns = 256;
176         while (true) { if (ns == 0 || (b<<ns-8) != 0) break; ns -= 8; }
177         assembly {
178             ns := div(ns, 8)
179             o := mload(0x40)
180             mstore(0x40, add(o, and(add(add(ns, 0x20), 0x1f), not(0x1f))))
181             mstore(o, ns)
182             mstore(add(o, 32), b)
183         }
184     }
185 }
186 
187 
188 contract RipioOracle is Oracle, Delegable, BytesUtils {
189     event DelegatedCall(address requester, address to);
190     event CacheHit(address requester, bytes32 currency, uint256 requestTimestamp, uint256 deliverTimestamp, uint256 rate, uint256 decimals);
191     event DeliveredRate(address requester, bytes32 currency, address signer, uint256 requestTimestamp, uint256 rate, uint256 decimals);
192 
193     uint256 public expiration = 6 hours;
194 
195     uint constant private INDEX_TIMESTAMP = 0;
196     uint constant private INDEX_RATE = 1;
197     uint constant private INDEX_DECIMALS = 2;
198     uint constant private INDEX_V = 3;
199     uint constant private INDEX_R = 4;
200     uint constant private INDEX_S = 5;
201 
202     string private infoUrl;
203     
204     address public prevOracle;
205     Oracle public fallback;
206     mapping(bytes32 => RateCache) public cache;
207 
208     struct RateCache {
209         uint256 timestamp;
210         uint256 rate;
211         uint256 decimals;
212     }
213 
214     function url() public view returns (string) {
215         return infoUrl;
216     }
217 
218     /**
219         @dev Sets the time window of the validity of the rates signed.
220 
221         @param time Duration of the window
222 
223         @return true is the time was set correctly
224     */
225     function setExpirationTime(uint256 time) public onlyOwner returns (bool) {
226         expiration = time;
227         return true;
228     }
229 
230     /**
231         @dev Sets the url to retrieve the data for 'getRate'
232 
233         @param _url New url
234     */
235     function setUrl(string _url) public onlyOwner returns (bool) {
236         infoUrl = _url;
237         return true;
238     }
239 
240     /**
241         @dev Sets another oracle as the replacement to this oracle
242         All 'getRate' calls will be forwarded to this new oracle
243 
244         @param _fallback New oracle
245     */
246     function setFallback(Oracle _fallback) public onlyOwner returns (bool) {
247         fallback = _fallback;
248         return true;
249     }
250 
251     /**
252         @dev Invalidates the cache of a given currency
253 
254         @param currency Currency to invalidate the cache
255     */
256     function invalidateCache(bytes32 currency) public onlyOwner returns (bool) {
257         delete cache[currency].timestamp;
258         return true;
259     }
260     
261     function setPrevOracle(address oracle) public onlyOwner returns (bool) {
262         prevOracle = oracle;
263         return true;
264     }
265 
266     function isExpired(uint256 timestamp) internal view returns (bool) {
267         return timestamp <= now - expiration;
268     }
269 
270     /**
271         @dev Retrieves the convertion rate of a given currency, the information of the rate is carried over the 
272         data field. If there is a newer rate on the cache, that rate is delivered and the data field is ignored.
273 
274         If the data contains a more recent rate than the cache, the cache is updated.
275 
276         @param currency Hash of the currency
277         @param data Data with the rate signed by a delegate
278 
279         @return the rate and decimals of the currency convertion
280     */
281     function getRate(bytes32 currency, bytes data) public returns (uint256, uint256) {
282         if (fallback != address(0)) {
283             emit DelegatedCall(msg.sender, fallback);
284             return fallback.getRate(currency, data);
285         }
286 
287         uint256 timestamp = uint256(readBytes32(data, INDEX_TIMESTAMP));
288         RateCache memory rateCache = cache[currency];
289         if (rateCache.timestamp >= timestamp && !isExpired(rateCache.timestamp)) {
290             emit CacheHit(msg.sender, currency, timestamp, rateCache.timestamp, rateCache.rate, rateCache.decimals);
291             return (rateCache.rate, rateCache.decimals);
292         } else {
293             require(!isExpired(timestamp), "The rate provided is expired");
294             uint256 rate = uint256(readBytes32(data, INDEX_RATE));
295             uint256 decimals = uint256(readBytes32(data, INDEX_DECIMALS));
296             uint8 v = uint8(readBytes32(data, INDEX_V));
297             bytes32 r = readBytes32(data, INDEX_R);
298             bytes32 s = readBytes32(data, INDEX_S);
299             
300             bytes32 _hash = keccak256(abi.encodePacked(this, currency, rate, decimals, timestamp));
301             address signer = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)),v,r,s);
302 
303             if(!isDelegate(signer)) {
304                 _hash = keccak256(abi.encodePacked(prevOracle, currency, rate, decimals, timestamp));
305                 signer = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)),v,r,s);
306                 if(!isDelegate(signer)) {
307                     revert('Signature not valid');
308                 }
309             }
310 
311             cache[currency] = RateCache(timestamp, rate, decimals);
312 
313             emit DeliveredRate(msg.sender, currency, signer, timestamp, rate, decimals);
314             return (rate, decimals);
315         }
316     }
317 }