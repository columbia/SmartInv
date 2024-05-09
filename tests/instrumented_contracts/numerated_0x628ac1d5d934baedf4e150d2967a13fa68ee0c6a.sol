1 // File: contracts/bot/CustomOwned.sol
2 
3 pragma solidity 0.4.26;
4 
5 contract CustomOwned {
6     address public owner;
7     address public newOwner;
8 
9     event OwnerUpdate(address _prevOwner, address _newOwner);
10 
11     constructor () public { owner = msg.sender; }
12 
13     modifier ownerOnly {
14         assert(msg.sender == owner);
15         _;
16     }
17 
18     function setOwner(address _newOwner) public ownerOnly {
19         require(_newOwner != owner && _newOwner != address(0), "Unauthorized");
20         emit OwnerUpdate(owner, _newOwner);
21         owner = _newOwner;
22         newOwner = address(0);
23     }
24 
25     function transferOwnership(address _newOwner) public ownerOnly {
26         require(_newOwner != owner, "Invalid");
27         newOwner = _newOwner;
28     }
29 
30     function acceptOwnership() public {
31         require(msg.sender == newOwner, "Unauthorized");
32         emit OwnerUpdate(owner, newOwner);
33         owner = newOwner;
34         newOwner = 0x0;
35     }
36 }
37 
38 // File: contracts/token/interfaces/IERC20Token.sol
39 
40 pragma solidity 0.4.26;
41 
42 /*
43     ERC20 Standard Token interface
44 */
45 contract IERC20Token {
46     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
47     function name() public view returns (string) {this;}
48     function symbol() public view returns (string) {this;}
49     function decimals() public view returns (uint8) {this;}
50     function totalSupply() public view returns (uint256) {this;}
51     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
52     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
53 
54     function transfer(address _to, uint256 _value) public returns (bool success);
55     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
56     function approve(address _spender, uint256 _value) public returns (bool success);
57 }
58 
59 // File: contracts/utility/interfaces/IOwned.sol
60 
61 pragma solidity 0.4.26;
62 
63 /*
64     Owned contract interface
65 */
66 contract IOwned {
67     // this function isn't abstract since the compiler emits automatically generated getter functions as external
68     function owner() public view returns (address) {this;}
69 
70     function transferOwnership(address _newOwner) public;
71     function acceptOwnership() public;
72 }
73 
74 // File: contracts/utility/interfaces/ITokenHolder.sol
75 
76 pragma solidity 0.4.26;
77 
78 
79 
80 /*
81     Token Holder interface
82 */
83 contract ITokenHolder is IOwned {
84     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
85 }
86 
87 // File: contracts/converter/interfaces/IConverterAnchor.sol
88 
89 pragma solidity 0.4.26;
90 
91 
92 
93 /*
94     Converter Anchor interface
95 */
96 contract IConverterAnchor is IOwned, ITokenHolder {
97 }
98 
99 // File: contracts/token/interfaces/ISmartToken.sol
100 
101 pragma solidity 0.4.26;
102 
103 
104 
105 
106 /*
107     Smart Token interface
108 */
109 contract ISmartToken is IConverterAnchor, IERC20Token {
110     function disableTransfers(bool _disable) public;
111     function issue(address _to, uint256 _amount) public;
112     function destroy(address _from, uint256 _amount) public;
113 }
114 
115 // File: contracts/IBancorNetwork.sol
116 
117 pragma solidity 0.4.26;
118 
119 
120 /*
121     Bancor Network interface
122 */
123 contract IBancorNetwork {
124     function convert2(
125         IERC20Token[] _path,
126         uint256 _amount,
127         uint256 _minReturn,
128         address _affiliateAccount,
129         uint256 _affiliateFee
130     ) public payable returns (uint256);
131 
132     function claimAndConvert2(
133         IERC20Token[] _path,
134         uint256 _amount,
135         uint256 _minReturn,
136         address _affiliateAccount,
137         uint256 _affiliateFee
138     ) public returns (uint256);
139 
140     function convertFor2(
141         IERC20Token[] _path,
142         uint256 _amount,
143         uint256 _minReturn,
144         address _for,
145         address _affiliateAccount,
146         uint256 _affiliateFee
147     ) public payable returns (uint256);
148 
149     function claimAndConvertFor2(
150         IERC20Token[] _path,
151         uint256 _amount,
152         uint256 _minReturn,
153         address _for,
154         address _affiliateAccount,
155         uint256 _affiliateFee
156     ) public returns (uint256);
157 
158     // deprecated, backward compatibility
159     function convert(
160         IERC20Token[] _path,
161         uint256 _amount,
162         uint256 _minReturn
163     ) public payable returns (uint256);
164 
165     // deprecated, backward compatibility
166     function claimAndConvert(
167         IERC20Token[] _path,
168         uint256 _amount,
169         uint256 _minReturn
170     ) public returns (uint256);
171 
172     // deprecated, backward compatibility
173     function convertFor(
174         IERC20Token[] _path,
175         uint256 _amount,
176         uint256 _minReturn,
177         address _for
178     ) public payable returns (uint256);
179 
180     // deprecated, backward compatibility
181     function claimAndConvertFor(
182         IERC20Token[] _path,
183         uint256 _amount,
184         uint256 _minReturn,
185         address _for
186     ) public returns (uint256);
187 
188     function rateByPath(
189         IERC20Token[] _path,
190         uint256 _amount
191     ) public view returns (uint256);
192 }
193 
194 // File: contracts/utility/interfaces/IContractRegistry.sol
195 
196 pragma solidity 0.4.26;
197 
198 /*
199     Contract Registry interface
200 */
201 contract IContractRegistry {
202     function addressOf(bytes32 _contractName) public view returns (address);
203 
204     // deprecated, backward compatibility
205     function getAddress(bytes32 _contractName) public view returns (address);
206 }
207 
208 // File: contracts/bot/ArbBot.sol
209 
210 pragma solidity 0.4.26;
211 
212 
213 
214 
215 
216 
217 
218 contract ArbBot is CustomOwned {
219     bytes32 internal constant BANCOR_NETWORK = "BancorNetwork";
220 
221     IERC20Token public tokenBNT;
222     IERC20Token public tokenUSDB;
223     IERC20Token public tokenDAI;
224     IERC20Token public tokenPEGUSD;
225 
226     ISmartToken public relayUSDB;
227     ISmartToken public relayDAI;
228     ISmartToken public relayPEGUSD;
229 
230     IContractRegistry public registry;
231 
232     uint256 public threshold = 0;
233 
234     constructor (
235         IERC20Token _tokenBNT,
236         IERC20Token _tokenDAI,
237         IERC20Token _tokenUSDB,
238         IERC20Token _tokenPEGUSD,
239         ISmartToken _relayUSDB,
240         ISmartToken _relayDAI,
241         ISmartToken _relayPEGUSD,
242         IContractRegistry _registry
243     ) public {
244         tokenBNT = _tokenBNT;
245         tokenDAI = _tokenDAI;
246         tokenUSDB = _tokenUSDB;
247         tokenPEGUSD = _tokenPEGUSD;
248 
249         relayUSDB = _relayUSDB;
250         relayDAI = _relayDAI;
251         relayPEGUSD = _relayPEGUSD;
252 
253         registry = _registry;
254     }
255 
256     function generatePath (bool _isUSDB, bool _fromUSD) private view returns(IERC20Token[] memory) {
257         IERC20Token tokenUSD = (_isUSDB == true) ? tokenUSDB : tokenPEGUSD;
258         ISmartToken relayUSD = (_isUSDB == true) ? relayUSDB : relayPEGUSD;
259 
260         IERC20Token[] memory path = new IERC20Token[](5);
261         if(_fromUSD) {
262             path[0] = tokenUSD;
263             path[1] = IERC20Token(relayUSD);
264             path[2] = tokenBNT;
265             path[3] = IERC20Token(relayDAI);
266             path[4] = tokenDAI;
267         } else {
268             path[0] = tokenDAI;
269             path[1] = IERC20Token(relayDAI);
270             path[2] = tokenBNT;
271             path[3] = IERC20Token(relayUSD);
272             path[4] = tokenUSD;
273         }
274 
275         return path;
276     }
277 
278     function getReturnDAI (bool _isUSDB, uint256 _amount) public view returns(uint256) {
279         IBancorNetwork network = IBancorNetwork(registry.addressOf(BANCOR_NETWORK));
280         return network.rateByPath(generatePath(_isUSDB, false), _amount);
281     }
282 
283     function getReturnUSD (bool _isUSDB, uint256 _amount) public view returns(uint256) {
284         IBancorNetwork network = IBancorNetwork(registry.addressOf(BANCOR_NETWORK));
285         return network.rateByPath(generatePath(_isUSDB, true), _amount);
286     }
287 
288     function isReadyToTrade(bool _isUSDB, uint256 _amount) public view returns(bool) {
289         IBancorNetwork network = IBancorNetwork(registry.addressOf(BANCOR_NETWORK));
290         uint256 returnUSD = network.rateByPath(generatePath(_isUSDB, true), _amount);
291         uint256 returnDAI = network.rateByPath(generatePath(_isUSDB, false), _amount);
292         if(returnDAI > _amount) {
293             return ((returnDAI - _amount) >= threshold);
294         } else {
295             if(returnUSD > _amount)
296                 return ((returnUSD - _amount) >= threshold);
297             else
298                 return false;
299         }
300     }
301 
302     function testTrade(bool _isUSDB, bool _fromUSD, uint256 _amount) public ownerOnly returns(bool) {
303         IBancorNetwork network = IBancorNetwork(registry.addressOf(BANCOR_NETWORK));
304         network.convertFor(generatePath(_isUSDB, _fromUSD), _amount, 1, address(this));
305     }
306 
307     function trade(bool _isUSDB, uint256 _amount) public returns(bool) {
308         IBancorNetwork network = IBancorNetwork(registry.addressOf(BANCOR_NETWORK));
309         uint256 returnUSD = network.rateByPath(generatePath(_isUSDB, true), _amount);
310         uint256 returnDAI = network.rateByPath(generatePath(_isUSDB, false), _amount);
311         IERC20Token tokenUSD = (_isUSDB == true) ? tokenUSDB : tokenPEGUSD;
312 
313         if(returnDAI > _amount) {
314             require((returnDAI - _amount) >= threshold, 'Trade not yet available.');
315             require(tokenUSD.balanceOf(address(this)) >= _amount, 'Insufficient USD balance.');
316             network.convertFor(generatePath(_isUSDB, false), _amount, _amount, address(this));
317         } else {
318             require(returnUSD > _amount, 'Trade not yet available.');
319             require((returnUSD - _amount) >= threshold, 'Trade not yet available.');
320             require(tokenDAI.balanceOf(address(this)) >= _amount, 'Insufficient DAI balance.');
321             network.convertFor(generatePath(_isUSDB, true), _amount, _amount, address(this));
322         }
323         return true;
324     }
325 
326     function lockTokens()  public ownerOnly {
327         address network = registry.addressOf(BANCOR_NETWORK);
328 
329         tokenUSDB.approve(address(relayUSDB.owner()), 0);
330         tokenDAI.approve(address(relayDAI.owner()), 0);
331         tokenPEGUSD.approve(address(relayPEGUSD.owner()), 0);
332 
333         tokenUSDB.approve(network, 0);
334         tokenDAI.approve(network, 0);
335         tokenPEGUSD.approve(network, 0);
336     }
337 
338     function unlockTokensConverter()  public ownerOnly {
339         tokenUSDB.approve(address(relayUSDB.owner()), 0);
340         tokenUSDB.approve(address(relayUSDB.owner()), 1000000 ether);
341 
342         tokenDAI.approve(address(relayDAI.owner()), 0);
343         tokenDAI.approve(address(relayDAI.owner()), 1000000 ether);
344 
345         tokenPEGUSD.approve(address(relayPEGUSD.owner()), 0);
346         tokenPEGUSD.approve(address(relayPEGUSD.owner()), 1000000 ether);
347     }
348 
349     function unlockTokensNetwork() public ownerOnly  {
350         address network = registry.addressOf(BANCOR_NETWORK);
351 
352         tokenUSDB.approve(network, 0);
353         tokenUSDB.approve(network, 1000000 ether);
354 
355         tokenDAI.approve(network, 0);
356         tokenDAI.approve(network, 1000000 ether);
357 
358         tokenPEGUSD.approve(network, 0);
359         tokenPEGUSD.approve(network, 1000000 ether);
360     }
361 
362     function updateThreshold(uint256 _threshold) public ownerOnly {
363         threshold = _threshold;
364     }
365 
366     function updateRegistry(IContractRegistry _registry) public ownerOnly {
367         registry = _registry;
368     }
369 
370     function updateTokens(
371         IERC20Token _tokenBNT,
372         IERC20Token _tokenDAI,
373         IERC20Token _tokenUSDB,
374         IERC20Token _tokenPEGUSD
375     ) public ownerOnly {
376         tokenBNT = _tokenBNT;
377         tokenDAI = _tokenDAI;
378         tokenUSDB = _tokenUSDB;
379         tokenPEGUSD = _tokenPEGUSD;
380     }
381 
382     function updateRelays(
383         ISmartToken _relayUSDB,
384         ISmartToken _relayDAI,
385         ISmartToken _relayPEGUSD
386     ) public ownerOnly {
387         relayUSDB = _relayUSDB;
388         relayDAI = _relayDAI;
389         relayPEGUSD = _relayPEGUSD;
390     }
391 
392     function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
393         _token.transfer(_to, _amount);
394     }
395 
396     function() public payable {}
397     
398 }