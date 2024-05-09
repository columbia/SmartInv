1 pragma solidity ^0.4.13;
2 
3 contract ApproveAndCallFallBack {
4     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
5 }
6 
7 contract ERC20Interface {
8     function totalSupply() public constant returns (uint);
9     function balanceOf(address tokenOwner) public constant returns (uint balance);
10     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15     event Transfer(address indexed from, address indexed to, uint tokens);
16     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 contract Owned {
20     address public owner;
21     address public newOwner;
22 
23     event OwnershipTransferred(address indexed _from, address indexed _to);
24 
25     function Owned() public {
26         owner = msg.sender;
27     }
28 
29     modifier onlyOwner {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     function transferOwnership(address _newOwner) public onlyOwner {
35         newOwner = _newOwner;
36     }
37 
38     function acceptOwnership() public {
39         require(msg.sender == newOwner);
40         OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42         newOwner = address(0);
43     }
44 }
45 
46 contract NeuroChainClausius is Owned, ERC20Interface {
47 
48   // Adding safe calculation methods to uint256
49   using SafeMath for uint;
50   // Defining balances mapping (ERC20)
51   mapping(address => uint256) balances;
52   // Defining allowances mapping (ERC20)
53   mapping(address => mapping (address => uint256)) allowed;
54   // Defining addresses allowed to bypass global freeze
55   mapping(address => bool) public freezeBypassing;
56   // Defining addresses association between NeuroChain and ETH network
57   mapping(address => string) public neuroChainAddresses;
58   // Event raised when a NeuroChain address is changed
59   event NeuroChainAddressSet(
60     address ethAddress,
61     string neurochainAddress,
62     uint timestamp,
63     bool isForcedChange
64   );
65   // Event raised when trading status is toggled
66   event FreezeStatusChanged(
67     bool toStatus,
68     uint timestamp
69   );
70   // Token Symbol
71   string public symbol = "NCC";
72   // Token Name
73   string public name = "NeuroChain Clausius";
74   // Token Decimals
75   uint8 public decimals = 18;
76   // Total supply of token
77   uint public _totalSupply = 657440000 * 10**uint(decimals);
78   // Current distributed supply
79   uint public _circulatingSupply = 0;
80   // Global freeze toggle
81   bool public tradingLive = false;
82   // Address of the Crowdsale Contract
83   address public icoContractAddress;
84   /**
85    * @notice Sending Tokens to an address
86    * @param to The receiver address
87    * @param tokens The amount of tokens to send (without de decimal part)
88    * @return {"success": "If the operation completed successfuly"}
89    */
90   function distributeSupply(
91     address to,
92     uint tokens
93   )
94   public onlyOwner returns (bool success)
95   {
96     uint tokenAmount = tokens.mul(10**uint(decimals));
97     require(_circulatingSupply.add(tokenAmount) <= _totalSupply);
98     _circulatingSupply = _circulatingSupply.add(tokenAmount);
99     balances[to] = tokenAmount;
100     return true;
101   }
102   /**
103    * @notice Allowing a spender to bypass global frezze
104    * @param sender The allowed address
105    * @return {"success": "If the operation completed successfuly"}
106    */
107   function allowFreezeBypass(
108     address sender
109   )
110   public onlyOwner returns (bool success)
111   {
112     freezeBypassing[sender] = true;
113     return true;
114   }
115   /**
116    * @notice Sets if the trading is live
117    * @param isLive Enabling/Disabling trading
118    */
119   function setTradingStatus(
120     bool isLive
121   )
122   public onlyOwner
123   {
124     tradingLive = isLive;
125     FreezeStatusChanged(tradingLive, block.timestamp);
126   }
127   // Modifier that requires the trading to be live or
128   // allowed to bypass the freeze status
129   modifier tokenTradingMustBeLive(address sender) {
130     require(tradingLive || freezeBypassing[sender]);
131     _;
132   }
133   /**
134    * @notice Sets the ICO Contract Address variable to be used with the
135    * `onlyIcoContract` modifier.
136    * @param contractAddress The NeuroChainCrowdsale deployed address
137    */
138   function setIcoContractAddress(
139     address contractAddress
140   )
141   public onlyOwner
142   {
143     freezeBypassing[contractAddress] = true;
144     icoContractAddress = contractAddress;
145   }
146   // Modifier that requires msg.sender to be Crowdsale Contract
147   modifier onlyIcoContract() {
148     require(msg.sender == icoContractAddress);
149     _;
150   }
151   /**
152    * @notice Permit `msg.sender` to set its NeuroChain Address
153    * @param neurochainAddress The NeuroChain Address
154    */
155   function setNeuroChainAddress(
156     string neurochainAddress
157   )
158   public
159   {
160     neuroChainAddresses[msg.sender] = neurochainAddress;
161     NeuroChainAddressSet(
162       msg.sender,
163       neurochainAddress,
164       block.timestamp,
165       false
166     );
167   }
168   /**
169    * @notice Force NeuroChain Address to be associated to a
170    * standard ERC20 account
171    * @dev Can only be called by the ICO Contract
172    * @param ethAddress The ETH address to associate
173    * @param neurochainAddress The NeuroChain Address
174    */
175   function forceNeuroChainAddress(
176     address ethAddress,
177     string neurochainAddress
178   )
179   public onlyIcoContract
180   {
181     neuroChainAddresses[ethAddress] = neurochainAddress;
182     NeuroChainAddressSet(
183       ethAddress,
184       neurochainAddress,
185       block.timestamp,
186       true
187     );
188   }
189   /**
190    * @notice Return the total supply of the token
191    * @dev This function is part of the ERC20 standard
192    * @return The token supply
193    */
194   function totalSupply() public constant returns (uint) {
195     return _totalSupply;
196   }
197   /**
198    * @notice Get the token balance of `tokenOwner`
199    * @dev This function is part of the ERC20 standard
200    * @param tokenOwner The wallet to get the balance of
201    * @return {"balance": "The balance of `tokenOwner`"}
202    */
203   function balanceOf(
204     address tokenOwner
205   )
206   public constant returns (uint balance)
207   {
208     return balances[tokenOwner];
209   }
210   /**
211    * @notice Transfers `tokens` from msg.sender to `to`
212    * @dev This function is part of the ERC20 standard
213    * @param to The address that receives the tokens
214    * @param tokens Token amount to transfer
215    * @return {"success": "If the operation completed successfuly"}
216    */
217   function transfer(
218     address to,
219     uint tokens
220   )
221   public tokenTradingMustBeLive(msg.sender) returns (bool success)
222   {
223     balances[msg.sender] = balances[msg.sender].sub(tokens);
224     balances[to] = balances[to].add(tokens);
225     Transfer(msg.sender, to, tokens);
226     return true;
227   }
228   /**
229    * @notice Transfer tokens from an address to another
230    * through an allowance made beforehand
231    * @dev This function is part of the ERC20 standard
232    * @param from The address sending the tokens
233    * @param to The address recieving the tokens
234    * @param tokens Token amount to transfer
235    * @return {"success": "If the operation completed successfuly"}
236    */
237   function transferFrom(
238     address from,
239     address to,
240     uint tokens
241   )
242   public tokenTradingMustBeLive(from) returns (bool success)
243   {
244     balances[from] = balances[from].sub(tokens);
245     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
246     balances[to] = balances[to].add(tokens);
247     Transfer(from, to, tokens);
248     return true;
249   }
250   /**
251    * @notice Approve an address to send `tokenAmount` tokens to `msg.sender` (make an allowance)
252    * @dev This function is part of the ERC20 standard
253    * @param spender The allowed address
254    * @param tokens The maximum amount allowed to spend
255    * @return {"success": "If the operation completed successfuly"}
256    */
257   function approve(
258     address spender,
259     uint tokens
260   )
261   public returns (bool success)
262   {
263     allowed[msg.sender][spender] = tokens;
264     Approval(msg.sender, spender, tokens);
265     return true;
266   }
267   /**
268    * @notice Get the remaining allowance for a spender on a given address
269    * @dev This function is part of the ERC20 standard
270    * @param tokenOwner The address that owns the tokens
271    * @param spender The spender
272    * @return {"remaining": "The amount of tokens remaining in the allowance"}
273    */
274   function allowance(
275     address tokenOwner,
276     address spender
277   )
278   public constant returns (uint remaining)
279   {
280     return allowed[tokenOwner][spender];
281   }
282   /**
283    * @notice Permits to create an approval on a contract and then call a method
284    * on the approved contract right away.
285    * @param spender The allowed address
286    * @param tokens The maximum amount allowed to spend
287    * @param data The data sent back as parameter to the contract (bytes array)
288    * @return {"success": "If the operation completed successfuly"}
289    */
290   function approveAndCall(
291     address spender,
292     uint tokens,
293     bytes data
294   )
295   public returns (bool success)
296   {
297     allowed[msg.sender][spender] = tokens;
298     Approval(msg.sender, spender, tokens);
299     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
300     return true;
301   }
302   /**
303    * @notice Permits to withdraw any ERC20 tokens that have been mistakingly sent to this contract
304    * @param tokenAddress The received ERC20 token address
305    * @param tokens The amount of ERC20 tokens to withdraw from this contract
306    * @return {"success": "If the operation completed successfuly"}
307    */
308   function transferAnyERC20Token(
309     address tokenAddress,
310     uint tokens
311   )
312   public onlyOwner returns (bool success)
313   {
314     return ERC20Interface(tokenAddress).transfer(owner, tokens);
315   }
316 }
317 
318 library SafeMath {
319     function add(uint a, uint b) internal pure returns (uint c) {
320         c = a + b;
321         require(c >= a);
322     }
323     function sub(uint a, uint b) internal pure returns (uint c) {
324         require(b <= a);
325         c = a - b;
326     }
327     function mul(uint a, uint b) internal pure returns (uint c) {
328         c = a * b;
329         require(a == 0 || c / a == b);
330     }
331     function div(uint a, uint b) internal pure returns (uint c) {
332         require(b > 0);
333         c = a / b;
334     }
335 
336     /**
337     * @dev Divides two numbers with 18 decimals, represented as uints (e.g. ether or token values)
338     */
339     uint constant ETHER_PRECISION = 10 ** 18;
340     function ediv(uint x, uint y) internal pure returns (uint z) {
341         // Put x to the 36th order of magnitude, so natural division will put it back to the 18th
342         // Adding y/2 before putting x back to the 18th order of magnitude is necessary to force the EVM to round up instead of down
343         z = add(mul(x, ETHER_PRECISION), y / 2) / y;
344     }
345 }