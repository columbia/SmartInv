1 pragma solidity ^0.4.23;
2 
3 
4 
5 
6 
7 // ----------------------------------------------------------------------------
8 contract ERC20 {
9 
10     // ERC Token Standard #223 Interface
11     // https://github.com/ethereum/EIPs/issues/223
12 
13     string public symbol;
14     string public  name;
15     uint8 public decimals;
16 
17     function transfer(address _to, uint _value, bytes _data) external returns (bool success);
18 
19     // approveAndCall
20     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
21 
22     // ERC Token Standard #20 Interface
23     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
24 
25 
26     function totalSupply() public constant returns (uint);
27     function balanceOf(address tokenOwner) public constant returns (uint balance);
28     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
29     function transfer(address to, uint tokens) public returns (bool success);
30     function approve(address spender, uint tokens) public returns (bool success);
31     function transferFrom(address from, address to, uint tokens) public returns (bool success);
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 
35     // bulk operations
36     function transferBulk(address[] to, uint[] tokens) public;
37     function approveBulk(address[] spender, uint[] tokens) public;
38 }
39 
40 
41 interface TokenRegistryInterface
42 {
43     function getPriceInToken(ERC20 _tokenContract, uint128 priceWei) external view returns (uint128);
44     function areAllTokensAllowed(address[] _tokens) external view returns (bool);
45     function isTokenInList(address[] _allowedTokens, address _currentToken) external pure returns (bool);
46     function getAllSupportedTokens() external view returns (address[]);
47 }
48 
49 
50 
51 // https://etherscan.io/address/0x3127be52acba38beab6b4b3a406dc04e557c037c#code
52 contract PriceOracleInterface {
53 
54     // How much TOKENs you get for 1 ETH, multiplied by 10^18
55     uint256 public ETHPrice;
56 }
57 
58 pragma solidity ^0.4.18;
59 
60 
61 
62 
63 
64 /// @title Kyber Network interface
65 /// https://raw.githubusercontent.com/KyberNetwork/smart-contracts/master/contracts/KyberNetworkProxyInterface.sol
66 interface KyberNetworkProxyInterface {
67     function maxGasPrice() external view returns(uint);
68     function getUserCapInWei(address user) external view returns(uint);
69     function getUserCapInTokenWei(address user, ERC20 token) external view returns(uint);
70     function enabled() external view returns(bool);
71     function info(bytes32 id) external view returns(uint);
72 
73     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) external view
74     returns (uint expectedRate, uint slippageRate);
75 
76     function tradeWithHint(ERC20 src, uint srcAmount, ERC20 dest, address destAddress, uint maxDestAmount,
77         uint minConversionRate, address walletId, bytes hint) external payable returns(uint);
78 }
79 
80 
81 
82 
83 /**
84  * @title Ownable
85  * @dev The Ownable contract has an owner address, and provides basic authorization control
86  * functions, this simplifies the implementation of "user permissions".
87  */
88 contract Ownable {
89   address public owner;
90 
91 
92   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94 
95   /**
96    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
97    * account.
98    */
99   constructor() public {
100     owner = msg.sender;
101   }
102 
103   /**
104    * @dev Throws if called by any account other than the owner.
105    */
106   modifier onlyOwner() {
107     require(msg.sender == owner);
108     _;
109   }
110 
111   /**
112    * @dev Allows the current owner to transfer control of the contract to a newOwner.
113    * @param newOwner The address to transfer ownership to.
114    */
115   function transferOwnership(address newOwner) public onlyOwner {
116     require(newOwner != address(0));
117     emit OwnershipTransferred(owner, newOwner);
118     owner = newOwner;
119   }
120 
121 }
122 
123 
124 contract TokenRegistry is TokenRegistryInterface, Ownable
125 {
126     mapping (address => PriceOracleInterface) public priceOracle;
127     address[] public allTokens;
128     address operatorAddress;
129     mapping (address => KyberNetworkProxyInterface) public kyberOracle;
130     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
131 
132     modifier onlyOperator() {
133         require(msg.sender == operatorAddress || msg.sender == owner);
134         _;
135     }
136 
137     function setOperator(address _newOperator) public onlyOwner {
138         require(_newOperator != address(0));
139 
140         operatorAddress = _newOperator;
141     }
142 
143     function getAllSupportedTokens() external view returns (address[])
144     {
145         return allTokens;
146     }
147 
148     function areAllTokensAllowed(address[] _tokens) external view returns (bool)
149     {
150         for (uint i = 0; i < _tokens.length; i++)
151         {
152             if (address(priceOracle[_tokens[i]]) == address(0x0))
153             {
154                 return false;
155             }
156         }
157         return true;
158     }
159 
160     function getPriceInToken(ERC20 _tokenContract, uint128 priceWei)
161         external
162         view
163         returns (uint128)
164     {
165         if (address(kyberOracle[address(_tokenContract)]) != 0x0)
166         {
167             return getPriceInTokenKyber(_tokenContract, priceWei);
168         }
169         else
170         {
171             return getPriceInTokenCustom(_tokenContract, priceWei);
172         }
173     }
174 
175     function getPriceInTokenCustom(ERC20 _tokenContract, uint128 priceWei)
176         internal
177         view
178         returns (uint128)
179     {
180         PriceOracleInterface oracle = priceOracle[address(_tokenContract)];
181         require(address(oracle) != address(0));
182 
183         uint256 ethPerToken = oracle.ETHPrice();
184         int256 power = 36 - _tokenContract.decimals();
185         require(power > 0);
186         return uint128(uint256(priceWei) * ethPerToken / (10 ** uint256(power)));
187     }
188 
189     function getPriceInTokenKyber(ERC20 _tokenContract, uint128 priceWei)
190         internal
191         view
192         returns (uint128)
193     {
194         KyberNetworkProxyInterface oracle = kyberOracle[address(_tokenContract)];
195         require(address(oracle) != address(0));
196 
197         uint256 ethPerToken;
198         (, ethPerToken) = oracle.getExpectedRate(ETH_TOKEN_ADDRESS, _tokenContract, priceWei);
199         require(ethPerToken > 0);
200         int256 power = 36 - _tokenContract.decimals();
201         require(power > 0);
202         return uint128(uint256(priceWei) * ethPerToken / (10 ** uint256(power)));
203     }
204 
205     function isTokenInList(address[] _allowedTokens, address _currentToken)
206         external
207         pure
208         returns (bool)
209     {
210         for (uint i = 0; i < _allowedTokens.length; i++)
211         {
212             if (_allowedTokens[i] == _currentToken)
213             {
214                 return true;
215             }
216         }
217         return false;
218     }
219 
220     /// @dev Allow buy cuties for token
221     function addToken(ERC20 _tokenContract, PriceOracleInterface _priceOracle) external onlyOwner
222     {
223         // check if not added yet
224         require(address(priceOracle[address(_tokenContract)]) == address(0x0));
225         require(address(kyberOracle[address(_tokenContract)]) == address(0x0));
226 
227         priceOracle[address(_tokenContract)] = _priceOracle;
228         allTokens.push(_tokenContract);
229     }
230 
231     /// @dev Allow buy cuties for token
232     function addKyberToken(ERC20 _tokenContract, KyberNetworkProxyInterface _priceOracle) external onlyOwner
233     {
234         // check if not added yet
235         require(address(priceOracle[address(_tokenContract)]) == address(0x0));
236         require(address(kyberOracle[address(_tokenContract)]) == address(0x0));
237 
238         kyberOracle[address(_tokenContract)] = _priceOracle;
239         allTokens.push(_tokenContract);
240     }
241 
242     /// @dev Disallow buy cuties for token
243     function removeToken(ERC20 _tokenContract) external onlyOwner
244     {
245         delete priceOracle[address(_tokenContract)];
246         delete kyberOracle[address(_tokenContract)];
247 
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
260         }
261     }
262 
263     // @dev Transfers to _withdrawToAddress all tokens controlled by
264     // contract _tokenContract.
265     function withdrawTokenFromBalance(ERC20 _tokenContract, address _withdrawToAddress) external
266     {
267         require(
268             msg.sender == owner ||
269             msg.sender == operatorAddress
270         );
271         uint256 balance = _tokenContract.balanceOf(address(this));
272         _tokenContract.transfer(_withdrawToAddress, balance);
273     }
274 }