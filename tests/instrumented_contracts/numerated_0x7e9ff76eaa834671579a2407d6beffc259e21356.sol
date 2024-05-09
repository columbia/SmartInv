1 pragma solidity ^0.4.25;
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
62     function getRate(bytes32 symbol, bytes data) public returns (uint256 rate, uint256 decimals);
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
193 /*
194     Bancor Converter interface
195 */
196 contract IBancorConverter {
197     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
198     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
199     function conversionWhitelist() public view returns (IWhitelist) {}
200     // deprecated, backward compatibility
201     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
202     function token() external returns (IERC20Token);
203     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
204 }
205 
206 
207 /*
208     ERC20 Standard Token interface
209 */
210 contract IERC20Token {
211     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
212     function name() public view returns (string) {}
213     function symbol() public view returns (string) {}
214     function decimals() public view returns (uint8) {}
215     function totalSupply() public view returns (uint256) {}
216     function balanceOf(address _owner) public view returns (uint256) { _owner; }
217     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
218 
219     function transfer(address _to, uint256 _value) public returns (bool success);
220     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
221     function approve(address _spender, uint256 _value) public returns (bool success);
222 }
223 
224 
225 /*
226     Whitelist interface
227 */
228 contract IWhitelist {
229     function isWhitelisted(address _address) public view returns (bool);
230 }
231 
232 contract BancorProxy is TokenConverter, Ownable {
233     IBancorConverter converterEthBnt;
234 
235     mapping(address => mapping(address => IBancorConverter)) public converterOf;
236     mapping(address => mapping(address => address)) public routerOf;
237     mapping(address => mapping(address => IERC20Token[])) public pathCache;
238 
239     Token ethToken;
240 
241     constructor(
242         Token _ethToken
243     ) public {
244         ethToken = _ethToken;
245     }
246 
247     function setConverter(
248         Token _token1,
249         Token _token2,
250         IBancorConverter _converter
251     ) public onlyOwner returns (bool) {
252         converterOf[_token1][_token2] = _converter;
253         converterOf[_token2][_token1] = _converter;
254         uint256 approve = uint256(0) - 1;
255         require(_token1.approve(_converter, approve), "Error approving transfer token 1");
256         require(_token2.approve(_converter, approve), "Error approving transfer token 2");
257         clearCache(_token1, _token2);
258         return true;
259     }
260 
261     function setRouter(
262         address _token1,
263         address _token2,
264         address _router
265     ) external onlyOwner returns (bool) {
266         routerOf[_token1][_token2] = _router;
267         routerOf[_token2][_token1] = _router;
268         return true;
269     }
270 
271     function clearCache(
272         Token from,
273         Token to
274     ) public onlyOwner returns (bool) {
275         pathCache[from][to].length = 0;
276         pathCache[to][from].length = 0;
277         return true;
278     }
279 
280     function getPath(
281         IBancorConverter converter,
282         Token from,
283         Token to
284     ) private returns (IERC20Token[]) {
285         if (pathCache[from][to].length != 0) {
286             return pathCache[from][to];
287         } else {
288             IERC20Token token = converter.token();
289             pathCache[from][to] = [IERC20Token(from), token, IERC20Token(to)];
290             return pathCache[from][to];
291         }
292     }
293 
294     function getReturn(Token from, Token to, uint256 sell) external view returns (uint256 amount){
295         return _getReturn(from, to, sell);
296     }
297 
298     function _getReturn(Token _from, Token _to, uint256 sell) internal view returns (uint256 amount){
299         Token from = _from == ETH_ADDRESS ? Token(ethToken) : _from;
300         Token to = _to == ETH_ADDRESS ? Token(ethToken) : _to;
301         IBancorConverter converter = converterOf[from][to];
302         if (converter != address(0)) {
303             return converter.getReturn(IERC20Token(from), IERC20Token(to), sell);
304         }
305 
306         Token router = Token(routerOf[from][to]);
307         if (router != address(0)) {
308             converter = converterOf[router][to];
309             return converter.getReturn(
310                 IERC20Token(router),
311                 IERC20Token(to),
312                 _getReturn(from, router, sell)
313             );
314         }
315         revert("No routing found - BancorProxy");
316     }
317 
318     function convert(Token _from, Token _to, uint256 sell, uint256 minReturn) external payable returns (uint256 amount){
319         Token from = _from == ETH_ADDRESS ? Token(ethToken) : _from;
320         Token to = _to == ETH_ADDRESS ? Token(ethToken) : _to;
321 
322         if (from == ethToken) {
323             require(msg.value == sell, "ETH not enought");
324         } else {
325             require(msg.value == 0, "ETH not required");
326             require(from.transferFrom(msg.sender, this, sell), "Error pulling tokens");
327         }
328 
329         amount = _convert(from, to, sell);
330         require(amount > minReturn, "Return amount too low");
331 
332         if (to == ethToken) {
333             msg.sender.transfer(amount);
334         } else {
335             require(to.transfer(msg.sender, amount), "Error sending tokens");
336         }
337     }
338 
339     function _convert(
340         Token from,
341         Token to,   
342         uint256 sell
343     ) internal returns (uint256) {
344         IBancorConverter converter = converterOf[from][to];
345         
346         uint256 amount;
347         if (converter != address(0)) {
348             amount = converter.quickConvert
349                 .value(from == ethToken ? sell : 0)(
350                 getPath(converter, from, to),
351                 sell,
352                 1
353             );
354         } else {
355             Token router = Token(routerOf[from][to]);
356             if (router != address(0)) {
357                 uint256 routerAmount = _convert(from, router, sell);
358                 converter = converterOf[router][to];
359                 amount = converter.quickConvert
360                     .value(router == ethToken ? routerAmount : 0)(
361                     getPath(converter, router, to),
362                     routerAmount,
363                     1
364                 );
365             }
366         }
367 
368         return amount;
369     } 
370 
371     function withdrawTokens(
372         Token _token,
373         address _to,
374         uint256 _amount
375     ) external onlyOwner returns (bool) {
376         return _token.transfer(_to, _amount);
377     }
378 
379     function withdrawEther(
380         address _to,
381         uint256 _amount
382     ) external onlyOwner {
383         
384         _to.transfer(_amount);
385     }
386 
387     function() external payable {}
388 }