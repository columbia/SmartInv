1 pragma solidity ^0.4.24;
2 
3 contract Token {
4     function transfer(address _to, uint _value) public returns (bool success);
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
6     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
7     function approve(address _spender, uint256 _value) public returns (bool success);
8     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
9     function balanceOf(address _owner) public view returns (uint256 balance);
10 }
11 
12 contract Ownable {
13     address public owner;
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner, "msg.sender is not the owner");
17         _;
18     }
19 
20     constructor() public {
21         owner = msg.sender;
22     }
23 
24     /**
25         @dev Transfers the ownership of the contract.
26 
27         @param _to Address of the new owner
28     */
29     function transferTo(address _to) external onlyOwner returns (bool) {
30         require(_to != address(0), "Can't transfer to address 0x0");
31         owner = _to;
32         return true;
33     }
34 }
35 
36 
37 /**
38     @dev Defines the interface of a standard RCN oracle.
39 
40     The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,
41     it's primarily used by the exchange but could be used by any other agent.
42 */
43 contract Oracle is Ownable {
44     uint256 public constant VERSION = 4;
45 
46     event NewSymbol(bytes32 _currency);
47 
48     mapping(bytes32 => bool) public supported;
49     bytes32[] public currencies;
50 
51     /**
52         @dev Returns the url where the oracle exposes a valid "oracleData" if needed
53     */
54     function url() public view returns (string);
55 
56     /**
57         @dev Returns a valid convertion rate from the currency given to RCN
58 
59         @param symbol Symbol of the currency
60         @param data Generic data field, could be used for off-chain signing
61     */
62     function getRate(bytes32 symbol, bytes data) external returns (uint256 rate, uint256 decimals);
63 
64     /**
65         @dev Adds a currency to the oracle, once added it cannot be removed
66 
67         @param ticker Symbol of the currency
68 
69         @return if the creation was done successfully
70     */
71     function addCurrency(string ticker) public onlyOwner returns (bool) {
72         bytes32 currency = encodeCurrency(ticker);
73         emit NewSymbol(currency);
74         supported[currency] = true;
75         currencies.push(currency);
76         return true;
77     }
78 
79     /**
80         @return the currency encoded as a bytes32
81     */
82     function encodeCurrency(string currency) public pure returns (bytes32 o) {
83         require(bytes(currency).length <= 32, "Currency too long");
84         assembly {
85             o := mload(add(currency, 32))
86         }
87     }
88     
89     /**
90         @return the currency string from a encoded bytes32
91     */
92     function decodeCurrency(bytes32 b) public pure returns (string o) {
93         uint256 ns = 256;
94         while (true) { if (ns == 0 || (b<<ns-8) != 0) break; ns -= 8; }
95         assembly {
96             ns := div(ns, 8)
97             o := mload(0x40)
98             mstore(0x40, add(o, and(add(add(ns, 0x20), 0x1f), not(0x1f))))
99             mstore(o, ns)
100             mstore(add(o, 32), b)
101         }
102     }
103 }
104 
105 contract Engine {
106     uint256 public VERSION;
107     string public VERSION_NAME;
108 
109     enum Status { initial, lent, paid, destroyed }
110     struct Approbation {
111         bool approved;
112         bytes data;
113         bytes32 checksum;
114     }
115 
116     function getTotalLoans() public view returns (uint256);
117     function getOracle(uint index) public view returns (Oracle);
118     function getBorrower(uint index) public view returns (address);
119     function getCosigner(uint index) public view returns (address);
120     function ownerOf(uint256) public view returns (address owner);
121     function getCreator(uint index) public view returns (address);
122     function getAmount(uint index) public view returns (uint256);
123     function getPaid(uint index) public view returns (uint256);
124     function getDueTime(uint index) public view returns (uint256);
125     function getApprobation(uint index, address _address) public view returns (bool);
126     function getStatus(uint index) public view returns (Status);
127     function isApproved(uint index) public view returns (bool);
128     function getPendingAmount(uint index) public returns (uint256);
129     function getCurrency(uint index) public view returns (bytes32);
130     function cosign(uint index, uint256 cost) external returns (bool);
131     function approveLoan(uint index) public returns (bool);
132     function transfer(address to, uint256 index) public returns (bool);
133     function takeOwnership(uint256 index) public returns (bool);
134     function withdrawal(uint index, address to, uint256 amount) public returns (bool);
135     function identifierToIndex(bytes32 signature) public view returns (uint256);
136 }
137 
138 
139 /**
140     @dev Defines the interface of a standard RCN cosigner.
141 
142     The cosigner is an agent that gives an insurance to the lender in the event of a defaulted loan, the confitions
143     of the insurance and the cost of the given are defined by the cosigner. 
144 
145     The lender will decide what cosigner to use, if any; the address of the cosigner and the valid data provided by the
146     agent should be passed as params when the lender calls the "lend" method on the engine.
147     
148     When the default conditions defined by the cosigner aligns with the status of the loan, the lender of the engine
149     should be able to call the "claim" method to receive the benefit; the cosigner can define aditional requirements to
150     call this method, like the transfer of the ownership of the loan.
151 */
152 contract Cosigner {
153     uint256 public constant VERSION = 2;
154     
155     /**
156         @return the url of the endpoint that exposes the insurance offers.
157     */
158     function url() public view returns (string);
159     
160     /**
161         @dev Retrieves the cost of a given insurance, this amount should be exact.
162 
163         @return the cost of the cosign, in RCN wei
164     */
165     function cost(address engine, uint256 index, bytes data, bytes oracleData) public view returns (uint256);
166     
167     /**
168         @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of
169         the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or
170         does not return true to this method, the operation fails.
171 
172         @return true if the cosigner accepts the liability
173     */
174     function requestCosign(Engine engine, uint256 index, bytes data, bytes oracleData) public returns (bool);
175     
176     /**
177         @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the
178         current lender of the loan.
179 
180         @return true if the claim was done correctly.
181     */
182     function claim(address engine, uint256 index, bytes oracleData) public returns (bool);
183 }
184 
185 
186 contract TokenConverter {
187     address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
188     function getReturn(Token _fromToken, Token _toToken, uint256 _fromAmount) external view returns (uint256 amount);
189     function convert(Token _fromToken, Token _toToken, uint256 _fromAmount, uint256 _minReturn) external payable returns (uint256 amount);
190 }
191 
192 
193 contract TokenConverterOracle is Oracle {
194     address public delegate;
195     address public ogToken;
196 
197     mapping(bytes32 => Currency) public sources;
198     mapping(bytes32 => Cache) public cache;
199     
200     event DelegatedCall(address _requester, address _to);
201     event CacheHit(address _requester, bytes32 _currency, uint256 _rate, uint256 _decimals);
202     event DeliveredRate(address _requester, bytes32 _currency, uint256 _rate, uint256 _decimals);
203     event SetSource(bytes32 _currency, address _converter, address _token, uint128 _sample, bool _cached);
204     event SetDelegate(address _prev, address _new);
205     event SetOgToken(address _prev, address _new);
206 
207     struct Cache {
208         uint64 decimals;
209         uint64 blockNumber;
210         uint128 rate;
211     }
212 
213     struct Currency {
214         bool cached;
215         uint8 decimals;
216         address converter;
217         address token;
218     }
219 
220     function setDelegate(
221         address _delegate
222     ) external onlyOwner {
223         emit SetDelegate(delegate, _delegate);
224         delegate = _delegate;
225     }
226 
227     function setOgToken(
228         address _ogToken
229     ) external onlyOwner {
230         emit SetOgToken(ogToken, _ogToken);
231         ogToken = _ogToken;
232     }
233 
234     function setCurrency(
235         string code,
236         address converter,
237         address token,
238         uint8 decimals,
239         bool cached
240     ) external onlyOwner returns (bool) {
241         // Set supported currency
242         bytes32 currency = encodeCurrency(code);
243         if (!supported[currency]) {
244             emit NewSymbol(currency);
245             supported[currency] = true;
246             currencies.push(currency);
247         }
248 
249         // Save converter info
250         sources[currency] = Currency({
251             cached: cached,
252             converter: converter,
253             token: token,
254             decimals: decimals
255         });
256 
257         emit SetSource(currency, converter, token, decimals, cached);
258         return true;
259     }
260 
261     function url() public view returns (string) {
262         return "";
263     }
264 
265     function getRate(
266         bytes32 _symbol,
267         bytes _data
268     ) external returns (uint256 rate, uint256 decimals) {
269         if (delegate != address(0)) {
270             emit DelegatedCall(msg.sender, delegate);
271             return Oracle(delegate).getRate(_symbol, _data);
272         }
273 
274         Currency memory currency = sources[_symbol];
275 
276         if (currency.cached) {
277             Cache memory _cache = cache[_symbol];
278             if (_cache.blockNumber == block.number) {
279                 emit CacheHit(msg.sender, _symbol, _cache.rate, _cache.decimals);
280                 return (_cache.rate, _cache.decimals);
281             }
282         }
283         
284         require(currency.converter != address(0), "Currency not supported");
285         decimals = currency.decimals;
286         rate = TokenConverter(currency.converter).getReturn(Token(ogToken), Token(currency.token), 10 ** decimals);
287         emit DeliveredRate(msg.sender, _symbol, rate, decimals);
288 
289         // If cached and rate < 2 ** 128
290         if (currency.cached && rate < 340282366920938463463374607431768211456) {
291             cache[_symbol] = Cache({
292                 decimals: currency.decimals,
293                 blockNumber: uint64(block.number),
294                 rate: uint128(rate)
295             });
296         }
297     }
298 }