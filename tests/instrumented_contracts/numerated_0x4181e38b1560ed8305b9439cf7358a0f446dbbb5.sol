1 // File: contracts/token/interfaces/IERC20Token.sol
2 
3 pragma solidity 0.4.26;
4 
5 /*
6     ERC20 Standard Token interface
7 */
8 contract IERC20Token {
9     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
10     function name() public view returns (string) {this;}
11     function symbol() public view returns (string) {this;}
12     function decimals() public view returns (uint8) {this;}
13     function totalSupply() public view returns (uint256) {this;}
14     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
15     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
16 
17     function transfer(address _to, uint256 _value) public returns (bool success);
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
19     function approve(address _spender, uint256 _value) public returns (bool success);
20 }
21 
22 // File: contracts/utility/interfaces/IOwned.sol
23 
24 pragma solidity 0.4.26;
25 
26 /*
27     Owned contract interface
28 */
29 contract IOwned {
30     // this function isn't abstract since the compiler emits automatically generated getter functions as external
31     function owner() public view returns (address) {this;}
32 
33     function transferOwnership(address _newOwner) public;
34     function acceptOwnership() public;
35 }
36 
37 // File: contracts/token/interfaces/ISmartToken.sol
38 
39 pragma solidity 0.4.26;
40 
41 
42 
43 /*
44     Smart Token interface
45 */
46 contract ISmartToken is IOwned, IERC20Token {
47     function disableTransfers(bool _disable) public;
48     function issue(address _to, uint256 _amount) public;
49     function destroy(address _from, uint256 _amount) public;
50 }
51 
52 // File: contracts/utility/interfaces/IWhitelist.sol
53 
54 pragma solidity 0.4.26;
55 
56 /*
57     Whitelist interface
58 */
59 contract IWhitelist {
60     function isWhitelisted(address _address) public view returns (bool);
61 }
62 
63 // File: contracts/converter/interfaces/IBancorConverter.sol
64 
65 pragma solidity 0.4.26;
66 
67 
68 
69 /*
70     Bancor Converter interface
71 */
72 contract IBancorConverter {
73     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256);
74     function convert2(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee) public returns (uint256);
75     function quickConvert2(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee) public payable returns (uint256);
76     function conversionWhitelist() public view returns (IWhitelist) {this;}
77     function conversionFee() public view returns (uint32) {this;}
78     function reserves(address _address) public view returns (uint256, uint32, bool, bool, bool) {_address; this;}
79     function getReserveBalance(IERC20Token _reserveToken) public view returns (uint256);
80     function reserveTokens(uint256 _index) public view returns (IERC20Token) {_index; this;}
81     // deprecated, backward compatibility
82     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
83     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
84     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
85     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool);
86     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
87     function connectorTokens(uint256 _index) public view returns (IERC20Token);
88 }
89 
90 // File: contracts/bot/Owned.sol
91 
92 pragma solidity 0.4.26;
93 
94 contract Owned {
95     address public owner;
96     address public newOwner;
97 
98     event OwnerUpdate(address _prevOwner, address _newOwner);
99 
100     constructor () public { owner = msg.sender; }
101 
102     modifier ownerOnly {
103         assert(msg.sender == owner);
104         _;
105     }
106 
107     function setOwner(address _newOwner) public ownerOnly {
108         require(_newOwner != owner && _newOwner != address(0), "Unauthorized");
109         emit OwnerUpdate(owner, _newOwner);
110         owner = _newOwner;
111         newOwner = address(0);
112     }
113 
114     function transferOwnership(address _newOwner) public ownerOnly {
115         require(_newOwner != owner, "Invalid");
116         newOwner = _newOwner;
117     }
118 
119     function acceptOwnership() public {
120         require(msg.sender == newOwner, "Unauthorized");
121         emit OwnerUpdate(owner, newOwner);
122         owner = newOwner;
123         newOwner = 0x0;
124     }
125 }
126 
127 // File: solidity/contracts/bot/ArbBot.sol
128 
129 pragma solidity 0.4.26;
130 
131 
132 
133 
134 
135 contract ArbBot is Owned {
136     
137     IERC20Token public tokenBNT;
138     IERC20Token public tokenUSDB;
139     IERC20Token public tokenSAI;
140     IERC20Token public tokenPEGUSD;
141 
142     ISmartToken public relayUSDB;
143     ISmartToken public relaySAI;
144     ISmartToken public relayPEGUSD;
145 
146     uint256 public tradeValue = 200 ether;
147     uint256 public threshold = 0;
148 
149     constructor (
150         IERC20Token _tokenBNT,
151         IERC20Token _tokenSAI,
152         IERC20Token _tokenUSDB,
153         IERC20Token _tokenPEGUSD,
154         ISmartToken _relayUSDB,
155         ISmartToken _relaySAI,
156         ISmartToken _relayPEGUSD
157     ) public {
158         tokenBNT = _tokenBNT;
159         tokenSAI = _tokenSAI;
160         tokenUSDB = _tokenUSDB;
161         tokenPEGUSD = _tokenPEGUSD;
162 
163         relayUSDB = _relayUSDB;
164         relaySAI = _relaySAI;
165         relayPEGUSD = _relayPEGUSD;
166     }
167 
168     function getReturnSAI (bool _fromUSDB) public view returns(uint256) {
169         IERC20Token tokenUSD = (_fromUSDB == true) ? tokenUSDB : tokenPEGUSD;
170         ISmartToken relayUSD = (_fromUSDB == true) ? relayUSDB : relayPEGUSD;
171         IBancorConverter converterSAI = IBancorConverter(relaySAI.owner());
172         uint256 returnBNT;
173         IBancorConverter converterUSDB = IBancorConverter(relayUSD.owner());
174         (returnBNT, ) = converterUSDB.getReturn(tokenUSD, tokenBNT, tradeValue);
175         uint256 returnSAI;
176         (returnSAI, ) = converterSAI.getReturn(tokenBNT, tokenSAI, returnBNT);
177         return returnSAI;
178     }
179 
180     function getReturnUSD (bool _fromUSDB) public view returns(uint256) {
181         IERC20Token tokenUSD = (_fromUSDB == true) ? tokenUSDB : tokenPEGUSD;
182         ISmartToken relayUSD = (_fromUSDB == true) ? relayUSDB : relayPEGUSD;
183         IBancorConverter converterSAI = IBancorConverter(relaySAI.owner());
184         uint256 returnBNT;
185         (returnBNT, ) = converterSAI.getReturn(tokenSAI, tokenBNT, tradeValue);
186         uint256 returnUSD;
187         IBancorConverter converterUSDB = IBancorConverter(relayUSD.owner());
188         (returnUSD, ) = converterUSDB.getReturn(tokenBNT, tokenUSD, returnBNT);
189         return returnUSD;
190     }
191 
192     function isReadyToTrade(bool _fromUSDB) public view returns(bool) {
193         uint256 returnUSD = getReturnUSD(_fromUSDB);
194         uint256 returnSAI = getReturnSAI(_fromUSDB);
195         if(returnSAI > tradeValue) {
196             return ((returnSAI - tradeValue) >= threshold);
197         } else {
198             if(returnUSD > tradeValue)
199                 return ((returnUSD - tradeValue) >= threshold);
200             else
201                 return false;
202         }
203     }
204 
205     function trade(bool _fromUSDB) public returns(bool) {
206         IERC20Token tokenUSD = (_fromUSDB == true) ? tokenUSDB : tokenPEGUSD;
207         ISmartToken relayUSD = (_fromUSDB == true) ? relayUSDB : relayPEGUSD;
208         IBancorConverter converterUSD = (_fromUSDB == true) ? IBancorConverter(relayUSD.owner()) : IBancorConverter(relayUSD.owner());
209         IBancorConverter converterSAI = IBancorConverter(relaySAI.owner());
210 
211         uint256 returnUSD = getReturnUSD(_fromUSDB);
212         uint256 returnSAI = getReturnSAI(_fromUSDB);
213         IERC20Token[] memory path = new IERC20Token[](5);
214         if(returnSAI > tradeValue) {
215             require((returnSAI - tradeValue) >= threshold, 'Trade not yet available.');
216             require(tokenUSD.balanceOf(address(this)) >= tradeValue, 'Insufficient USD balance.');
217             // [tokenUSD, relayUSD, tokenBNT, relaySAI, tokenSAI];
218             path[0] = tokenUSD;
219             path[1] = IERC20Token(relayUSD);
220             path[2] = tokenBNT;
221             path[3] = IERC20Token(relaySAI);
222             path[4] = tokenSAI;
223             converterUSD.quickConvert(path, tradeValue, tradeValue);
224         } else {
225             require(returnUSD > tradeValue, 'Trade not yet available.');
226             require((returnUSD - tradeValue) >= threshold, 'Trade not yet available.');
227             require(tokenSAI.balanceOf(address(this)) >= tradeValue, 'Insufficient SAI balance.');
228             // [tokenSAI, relaySAI, tokenBNT, relayUSD, tokenUSD];
229             path[0] = tokenSAI;
230             path[1] = IERC20Token(relaySAI);
231             path[2] = tokenBNT;
232             path[3] = IERC20Token(relayUSD);
233             path[4] = tokenUSD;
234             converterSAI.quickConvert(path, tradeValue, tradeValue);
235         }
236         return true;
237     }
238 
239     function unlockTokens() public {
240         tokenUSDB.approve(address(relayUSDB.owner()), 0);
241         tokenUSDB.approve(address(relayUSDB.owner()), 1000000 ether);
242 
243         tokenSAI.approve(address(relaySAI.owner()), 0);
244         tokenSAI.approve(address(relaySAI.owner()), 1000000 ether);
245 
246         tokenPEGUSD.approve(address(relayPEGUSD.owner()), 0);
247         tokenPEGUSD.approve(address(relayPEGUSD.owner()), 1000000 ether);
248     }
249 
250     function updateTradeValue(uint256 _tradeValue) public ownerOnly {
251         tradeValue = _tradeValue;
252     }
253 
254     function updateThreshold(uint256 _threshold) public ownerOnly {
255         threshold = _threshold;
256     }
257 
258     function updateTokens(
259         IERC20Token _tokenBNT,
260         IERC20Token _tokenSAI,
261         IERC20Token _tokenUSDB,
262         IERC20Token _tokenPEGUSD
263     ) public ownerOnly {
264         tokenBNT = _tokenBNT;
265         tokenSAI = _tokenSAI;
266         tokenUSDB = _tokenUSDB;
267         tokenPEGUSD = _tokenPEGUSD;
268     }
269 
270     function updateRelays(
271         ISmartToken _relayUSDB,
272         ISmartToken _relaySAI,
273         ISmartToken _relayPEGUSD
274     ) public ownerOnly {
275         relayUSDB = _relayUSDB;
276         relaySAI = _relaySAI;
277         relayPEGUSD = _relayPEGUSD;
278     }
279 
280     function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
281         _token.transfer(_to, _amount);
282     }
283 
284     function() public payable {}
285     
286 }