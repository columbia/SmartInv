1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 contract ERC20 {
5 
6     // ERC Token Standard #223 Interface
7     // https://github.com/ethereum/EIPs/issues/223
8 
9     string public symbol;
10     string public  name;
11     uint8 public decimals;
12 
13     function transfer(address _to, uint _value, bytes _data) external returns (bool success);
14 
15     // approveAndCall
16     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
17 
18     // ERC Token Standard #20 Interface
19     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
20 
21 
22     function totalSupply() public constant returns (uint);
23     function balanceOf(address tokenOwner) public constant returns (uint balance);
24     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
25     function transfer(address to, uint tokens) public returns (bool success);
26     function approve(address spender, uint tokens) public returns (bool success);
27     function transferFrom(address from, address to, uint tokens) public returns (bool success);
28     event Transfer(address indexed from, address indexed to, uint tokens);
29     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
30 
31     // bulk operations
32     function transferBulk(address[] to, uint[] tokens) public;
33     function approveBulk(address[] spender, uint[] tokens) public;
34 }
35 
36 
37 interface TokenRegistryInterface
38 {
39     function getPriceInToken(ERC20 tokenContract, uint128 priceWei) external view returns (uint128);
40     function areAllTokensAllowed(address[] tokens) external view returns (bool);
41     function isTokenInList(address[] allowedTokens, address currentToken) external pure returns (bool);
42     function getDefaultTokens() external view returns (address[]);
43     function getDefaultCreatorTokens() external view returns (address[]);
44     function onTokensReceived(ERC20 tokenContract, uint tokenCount) external;
45     function withdrawEthFromBalance() external;
46     function canConvertToEth(ERC20 tokenContract) external view returns (bool);
47     function convertTokensToEth(ERC20 tokenContract, address seller, uint sellerValue, uint fee) external;
48 }
49 
50 pragma solidity ^0.4.23;
51 
52 // https://etherscan.io/address/0x3127be52acba38beab6b4b3a406dc04e557c037c#code
53 contract PriceOracleInterface {
54 
55     // How much TOKENs you get for 1 ETH, multiplied by 10^18
56     uint256 public ETHPrice;
57 }
58 
59 pragma solidity ^0.4.18;
60 
61 
62 
63 
64 
65 /// @title Kyber Network interface
66 /// https://raw.githubusercontent.com/KyberNetwork/smart-contracts/master/contracts/KyberNetworkProxyInterface.sol
67 interface KyberNetworkProxyInterface {
68     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) external view returns (uint expectedRate, uint slippageRate);
69     function swapTokenToEther(ERC20 token, uint srcAmount, uint minConversionRate) external returns(uint);
70 }
71 
72 pragma solidity ^0.4.23;
73 
74 
75 /**
76  * @title Ownable
77  * @dev The Ownable contract has an owner address, and provides basic authorization control
78  * functions, this simplifies the implementation of "user permissions".
79  */
80 contract Ownable {
81   address public owner;
82 
83 
84   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86 
87   /**
88    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
89    * account.
90    */
91   constructor() public {
92     owner = msg.sender;
93   }
94 
95   /**
96    * @dev Throws if called by any account other than the owner.
97    */
98   modifier onlyOwner() {
99     require(msg.sender == owner);
100     _;
101   }
102 
103   /**
104    * @dev Allows the current owner to transfer control of the contract to a newOwner.
105    * @param newOwner The address to transfer ownership to.
106    */
107   function transferOwnership(address newOwner) public onlyOwner {
108     require(newOwner != address(0));
109     emit OwnershipTransferred(owner, newOwner);
110     owner = newOwner;
111   }
112 
113 }
114 
115 
116 contract TokenRegistry is TokenRegistryInterface, Ownable
117 {
118     mapping (address => PriceOracleInterface) public priceOracle;
119     address[] public allTokens;
120     address[] public allOracleTokens;
121     mapping (address => bool) operators;
122     mapping (address => KyberNetworkProxyInterface) public kyberOracle;
123     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
124     bool public allowConvertTokensToEth = true;
125 
126     modifier onlyOperator() {
127         require(operators[msg.sender] || msg.sender == owner);
128         _;
129     }
130 
131     function addOperator(address _newOperator) public onlyOwner {
132         operators[_newOperator] = true;
133     }
134 
135     function removeOperator(address _oldOperator) public onlyOwner {
136         delete(operators[_oldOperator]);
137     }
138 
139     function setAllowConvertTokensToEth(bool _newValue) public onlyOwner
140     {
141         allowConvertTokensToEth = _newValue;
142     }
143 
144     function getDefaultCreatorTokens() external view returns (address[])
145     {
146         return allOracleTokens;
147     }
148 
149     function getDefaultTokens() external view returns (address[])
150     {
151         return allTokens;
152     }
153 
154     function areAllTokensAllowed(address[] _tokens) external view returns (bool)
155     {
156         for (uint i = 0; i < _tokens.length; i++)
157         {
158             if (address(priceOracle[_tokens[i]]) == address(0x0) &&
159                 address(kyberOracle[_tokens[i]]) == address(0x0))
160             {
161                 return false;
162             }
163         }
164         return true;
165     }
166 
167     function getPriceInToken(ERC20 _tokenContract, uint128 priceWei)
168         external
169         view
170         returns (uint128)
171     {
172         if (isKyberToken(_tokenContract))
173         {
174             return getPriceInTokenKyber(_tokenContract, priceWei);
175         }
176         else
177         {
178             return getPriceInTokenOracle(_tokenContract, priceWei);
179         }
180     }
181 
182     function getPriceInTokenOracle(ERC20 _tokenContract, uint128 priceWei) public view returns (uint128)
183     {
184         PriceOracleInterface oracle = priceOracle[address(_tokenContract)];
185         require(address(oracle) != address(0));
186 
187         uint256 ethPerToken = oracle.ETHPrice();
188         int256 power = 36 - _tokenContract.decimals();
189         require(power > 0);
190         return uint128(uint256(priceWei) * ethPerToken / (10 ** uint256(power)));
191     }
192 
193     function getPriceInTokenKyber(ERC20 _tokenContract, uint128 priceWei) public view returns (uint128)
194     {
195         KyberNetworkProxyInterface oracle = kyberOracle[address(_tokenContract)];
196         require(address(oracle) != address(0));
197 
198         uint256 ethPerToken;
199         (, ethPerToken) = oracle.getExpectedRate(ETH_TOKEN_ADDRESS, _tokenContract, priceWei);
200         require(ethPerToken > 0);
201         int256 power = 36 - _tokenContract.decimals();
202         require(power > 0);
203         return uint128(uint256(priceWei) * ethPerToken / (10 ** uint256(power)));
204     }
205 
206     function isTokenInList(address[] _allowedTokens, address _currentToken) external pure returns (bool)
207     {
208         for (uint i = 0; i < _allowedTokens.length; i++)
209         {
210             if (_allowedTokens[i] == _currentToken)
211             {
212                 return true;
213             }
214         }
215         return false;
216     }
217 
218     /// @dev Allow buy cuties for token
219     function addToken(ERC20 _tokenContract, PriceOracleInterface _priceOracle) external onlyOwner
220     {
221         // check if not added yet
222         require(address(priceOracle[address(_tokenContract)]) == address(0x0));
223         require(address(kyberOracle[address(_tokenContract)]) == address(0x0));
224 
225         priceOracle[address(_tokenContract)] = _priceOracle;
226         allTokens.push(_tokenContract);
227         allOracleTokens.push(_tokenContract);
228     }
229 
230     /// @dev Allow buy cuties for token
231     function addKyberToken(ERC20 _tokenContract, KyberNetworkProxyInterface _priceOracle) external onlyOwner
232     {
233         // check if not added yet
234         require(address(priceOracle[address(_tokenContract)]) == address(0x0));
235         require(address(kyberOracle[address(_tokenContract)]) == address(0x0));
236 
237         kyberOracle[address(_tokenContract)] = _priceOracle;
238         allTokens.push(_tokenContract);
239     }
240 
241     /// @dev Disallow buy cuties for token
242     function removeToken(ERC20 _tokenContract) external onlyOwner
243     {
244         delete priceOracle[address(_tokenContract)];
245         delete kyberOracle[address(_tokenContract)];
246 
247         /*
248         uint256 kindex = 0;
249         while (kindex < allTokens.length)
250         {
251             if (address(allTokens[kindex]) == address(_tokenContract))
252             {
253                 allTokens[kindex] = allTokens[allTokens.length-1];
254                 allTokens.length--;
255             }
256             else
257             {
258                 kindex++;
259             }
260         }*/
261 
262         uint256 kindex = 0;
263         while (kindex < allOracleTokens.length)
264         {
265             if (address(allOracleTokens[kindex]) == address(_tokenContract))
266             {
267                 allOracleTokens[kindex] = allOracleTokens[allOracleTokens.length-1];
268                 allOracleTokens.length--;
269             }
270             else
271             {
272                 kindex++;
273             }
274         }
275     }
276 
277     // @dev Transfers to _withdrawToAddress all tokens controlled by
278     // contract _tokenContract.
279     function withdrawTokenFromBalance(ERC20 _tokenContract, address _withdrawToAddress) external onlyOperator
280     {
281         uint256 balance = _tokenContract.balanceOf(address(this));
282         _tokenContract.transfer(_withdrawToAddress, balance);
283     }
284 
285     function withdrawEthFromBalance() external onlyOperator
286     {
287         msg.sender.transfer(address(this).balance);
288     }
289 
290     function onTokensReceived(ERC20 tokenContract, uint tokenCount) external onlyOperator
291     {
292         if (canConvertToEth(tokenContract))
293         {
294             _swapTokenToEther(
295                 kyberOracle[address(tokenContract)],
296                 tokenContract,
297                 tokenCount,
298                 this,
299                 0);
300         }
301     }
302 
303     function canConvertToEth(ERC20 tokenContract) public view returns (bool)
304     {
305         return allowConvertTokensToEth && isKyberToken(tokenContract);
306     }
307 
308     function isKyberToken(ERC20 tokenContract) public view returns (bool)
309     {
310         return address(kyberOracle[address(tokenContract)]) != 0x0;
311     }
312 
313     //@dev Converts tokens to ETH and transfers ETH to destAddress minus fee
314     //@fee 0-10,000 means 0%-100%
315     function convertTokensToEth(ERC20 tokenContract, address destAddress, uint tokenCount, uint fee) public onlyOperator
316     {
317         require(allowConvertTokensToEth);
318 
319         _swapTokenToEther(
320             kyberOracle[address(tokenContract)],
321             tokenContract,
322             tokenCount,
323             destAddress,
324             fee);
325     }
326 
327     //@param _kyberNetworkProxy kyberNetworkProxy contract address
328     //@param token source token contract address
329     //@param tokenQty token wei amount
330     //@param destAddress address to send swapped ETH to
331     //@fee 0-10,000 means 0%-100%
332     function _swapTokenToEther(KyberNetworkProxyInterface _kyberNetworkProxy, ERC20 token, uint tokenQty, address destAddress, uint fee) internal {
333 
334         uint minRate;
335         (, minRate) = _kyberNetworkProxy.getExpectedRate(token, ETH_TOKEN_ADDRESS, tokenQty);
336 
337         // Mitigate ERC20 Approve front-running attack, by initially setting
338         // allowance to 0
339         require(token.approve(_kyberNetworkProxy, 0));
340 
341         // Approve tokens so network can take them during the swap
342         token.approve(address(_kyberNetworkProxy), tokenQty);
343         uint destAmount = _kyberNetworkProxy.swapTokenToEther(token, tokenQty, minRate);
344 
345         if (destAddress != address(this))
346         {
347             // Send received ethers to destination address
348             uint sellerValue = destAmount * (10000 - fee) / 10000;
349             destAddress.transfer(sellerValue);
350         }
351     }
352 
353     function () external payable
354     {
355     }
356 }