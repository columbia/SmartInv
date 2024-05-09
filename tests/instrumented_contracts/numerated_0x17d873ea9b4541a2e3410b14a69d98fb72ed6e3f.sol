1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 library SafeMath {
6   function add(uint a, uint b) internal pure returns (uint c) {
7     c = a + b;
8     require(c >= a);
9   }
10   function sub(uint a, uint b) internal pure returns (uint c) {
11     require(b <= a);
12     c = a - b;
13   }
14   function mul(uint a, uint b) internal pure returns (uint c) {
15     c = a * b;
16     require(a == 0 || c / a == b);
17   }
18   function div(uint a, uint b) internal pure returns (uint c) {
19     require(b > 0);
20     c = a / b;
21   }
22 }
23 
24 contract ERC20 {
25   function totalSupply() public constant returns (uint256);
26   function balanceOf(address tokenOwner) public constant returns (uint256 balance);
27   function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
28   function transfer(address to, uint tokens) public returns (bool success);
29   function approve(address spender, uint tokens) public returns (bool success);
30   function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32   event Transfer(address indexed from, address indexed to, uint256 tokens);
33   event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
34 }
35 
36 contract Owned {
37   address public owner;
38 
39   // ------------------------------------------------------------------------
40   // Constructor
41   // ------------------------------------------------------------------------
42   constructor() public {
43     owner = msg.sender;
44   }
45 
46   modifier onlyOwner {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   function transferOwnership(address newOwner) public onlyOwner returns (address account) {
52     owner = newOwner;
53     return owner;
54   }
55 }
56 contract CoinLoanCS is ERC20, Owned {
57   using SafeMath for uint256;
58 
59   string public symbol;
60   string public  name;
61   uint256 public decimals;
62   uint256 _totalSupply;
63 
64   address public token;
65   uint256 public price;
66 
67   mapping(address => uint256) balances;
68   mapping(address => mapping(string => uint256)) orders;
69 
70   event TransferETH(address indexed from, address indexed to, uint256 eth);
71   event Sell(address indexed to, uint256 tokens);
72 
73   // ------------------------------------------------------------------------
74   // Constructor
75   // ------------------------------------------------------------------------
76   constructor() public {
77     symbol = "CLT_CS";
78     name = "CoinLoan CryptoStock Promo Token";
79     decimals = 8;
80     token = 0x2001f2A0Cf801EcFda622f6C28fb6E10d803D969;
81     price = 3000000;  // = 0.03000000
82     _totalSupply = 100000 * 10**decimals;
83     balances[owner] = _totalSupply;
84     emit Transfer(address(0), owner, _totalSupply);
85   }
86 
87   // ------------------------------------------------------------------------
88   // Changes the address of the supported token
89   // ------------------------------------------------------------------------
90   function setToken(address newTokenAddress) public onlyOwner returns (bool success) {
91     token = newTokenAddress;
92     return true;
93   }
94 
95   // ------------------------------------------------------------------------
96   // Return a contract address of the supported token
97   // ------------------------------------------------------------------------
98   function getToken() public view returns (address) {
99     return token;
100   }
101 
102   // ------------------------------------------------------------------------
103   // Sets `price` value
104   // ------------------------------------------------------------------------
105   function setPrice(uint256 newPrice) public onlyOwner returns (bool success) {
106     price = newPrice;
107     return true;
108   }
109 
110   // ------------------------------------------------------------------------
111   // Returns current price (without decimals)
112   // ------------------------------------------------------------------------
113   function getPrice() public view returns (uint256) {
114     return price;
115   }
116 
117   // ------------------------------------------------------------------------
118   // Total supply
119   // ------------------------------------------------------------------------
120   function totalSupply() public view returns (uint256) {
121     return _totalSupply.sub(balances[address(0)]);
122   }
123 
124   // ------------------------------------------------------------------------
125   // Changes the total supply value
126   //
127   // a new supply must be no less then the current supply
128   // or the owner must have enough amount to cover supply reduction
129   // ------------------------------------------------------------------------
130   function changeTotalSupply(uint256 newSupply) public onlyOwner returns (bool success) {
131     require(newSupply >= 0 && (
132       newSupply >= _totalSupply || _totalSupply - newSupply <= balances[owner]
133     ));
134     uint256 diff = 0;
135     if (newSupply >= _totalSupply) {
136       diff = newSupply.sub(_totalSupply);
137       balances[owner] = balances[owner].add(diff);
138       emit Transfer(address(0), owner, diff);
139     } else {
140       diff = _totalSupply.sub(newSupply);
141       balances[owner] = balances[owner].sub(diff);
142       emit Transfer(owner, address(0), diff);
143     }
144     _totalSupply = newSupply;
145     return true;
146   }
147 
148   // ------------------------------------------------------------------------
149   // Get the token balance for account `tokenOwner`
150   // ------------------------------------------------------------------------
151   function balanceOf(address tokenOwner) public view returns (uint256 balance) {
152     return balances[tokenOwner];
153   }
154 
155   // ------------------------------------------------------------------------
156   // Get the order's balance of tokens for account `customer`
157   // ------------------------------------------------------------------------
158   function orderTokensOf(address customer) public view returns (uint256 balance) {
159     return orders[customer]['tokens'];
160   }
161 
162   // ------------------------------------------------------------------------
163   // Get the order's balance of ETH for account `customer`
164   // ------------------------------------------------------------------------
165   function orderEthOf(address customer) public view returns (uint256 balance) {
166     return orders[customer]['eth'];
167   }
168 
169   // ------------------------------------------------------------------------
170   // Delete customer's order
171   // ------------------------------------------------------------------------
172   function cancelOrder(address customer) public onlyOwner returns (bool success) {
173     orders[customer]['eth'] = 0;
174     orders[customer]['tokens'] = 0;
175     return true;
176   }
177 
178   // ------------------------------------------------------------------------
179   // Checks the order values by the customer's address and sends required
180   // promo tokens based on the received amount of `this` tokens and ETH
181   // ------------------------------------------------------------------------
182   function _checkOrder(address customer) private returns (uint256) {
183     require(price > 0);
184     if (orders[customer]['tokens'] <= 0 || orders[customer]['eth'] <= 0) {
185       return 0;
186     }
187 
188     uint256 decimalsDiff = 10 ** (18 - 2 * decimals);
189     uint256 eth = orders[customer]['eth'];
190     uint256 tokens = orders[customer]['eth'] / price / decimalsDiff;
191 
192     if (orders[customer]['tokens'] < tokens) {
193       tokens = orders[customer]['tokens'];
194       eth = tokens * price * decimalsDiff;
195     }
196 
197     ERC20 tokenInstance = ERC20(token);
198 
199     // complete the order
200     require(tokenInstance.balanceOf(this) >= tokens);
201 
202     // charge required amount of the tokens and ETHs
203     orders[customer]['tokens'] = orders[customer]['tokens'].sub(tokens);
204     orders[customer]['eth'] = orders[customer]['eth'].sub(eth);
205 
206     tokenInstance.transfer(customer, tokens);
207 
208     emit Sell(customer, tokens);
209 
210     return tokens;
211   }
212 
213   // ------------------------------------------------------------------------
214   // public entry point for the `_checkOrder` function
215   // ------------------------------------------------------------------------
216   function checkOrder(address customer) public onlyOwner returns (uint256) {
217     return _checkOrder(customer);
218   }
219 
220   // ------------------------------------------------------------------------
221   // Transfer the balance from token owner's account to `to` account
222   // - Owner's account must have sufficient balance to transfer
223   // - 0 value transfers are allowed
224   // - only owner is allowed to send tokens to any address
225   // - not owners can transfer the balance only to owner's address
226   // ------------------------------------------------------------------------
227   function transfer(address to, uint256 tokens) public returns (bool success) {
228     require(msg.sender == owner || to == owner || to == address(this));
229     address receiver = msg.sender == owner ? to : owner;
230     balances[msg.sender] = balances[msg.sender].sub(tokens);
231     balances[receiver] = balances[receiver].add(tokens);
232     emit Transfer(msg.sender, receiver, tokens);
233     if (receiver == owner) {
234       orders[msg.sender]['tokens'] = orders[msg.sender]['tokens'].add(tokens);
235       _checkOrder(msg.sender);
236     }
237     return true;
238   }
239 
240   // ------------------------------------------------------------------------
241   // `allowance` is not allowed
242   // ------------------------------------------------------------------------
243   function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
244     tokenOwner;
245     spender;
246     return uint256(0);
247   }
248 
249   // ------------------------------------------------------------------------
250   // `approve` is not allowed
251   // ------------------------------------------------------------------------
252   function approve(address spender, uint tokens) public returns (bool success) {
253     spender;
254     tokens;
255     return true;
256   }
257 
258   // ------------------------------------------------------------------------
259   // `transferFrom` is not allowed
260   // ------------------------------------------------------------------------
261   function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
262     from;
263     to;
264     tokens;
265     return true;
266   }
267 
268   // ------------------------------------------------------------------------
269   // Accept ETH
270   // ------------------------------------------------------------------------
271   function () public payable {
272     owner.transfer(msg.value);
273     orders[msg.sender]['eth'] = orders[msg.sender]['eth'].add(msg.value);
274     _checkOrder(msg.sender);
275     emit TransferETH(msg.sender, address(this), msg.value);
276   }
277 
278   // ------------------------------------------------------------------------
279   // Owner can transfer out any accidentally sent ERC20 tokens
280   // ------------------------------------------------------------------------
281   function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
282     return ERC20(tokenAddress).transfer(owner, tokens);
283   }
284 
285   // ------------------------------------------------------------------------
286   // Owner can transfer out promo token
287   // ------------------------------------------------------------------------
288   function transferToken(uint256 tokens) public onlyOwner returns (bool success) {
289     return transferAnyERC20Token(token, tokens);
290   }
291 
292   // ------------------------------------------------------------------------
293   // Owner can return specified amount from `tokenOwner`
294   // ------------------------------------------------------------------------
295   function returnFrom(address tokenOwner, uint256 tokens) public onlyOwner returns (bool success) {
296     balances[tokenOwner] = balances[tokenOwner].sub(tokens);
297     balances[owner] = balances[owner].add(tokens);
298     emit Transfer(tokenOwner, owner, tokens);
299     return true;
300   }
301 
302   // ------------------------------------------------------------------------
303   // Owner can returns all tokens from `tokenOwner`
304   // ------------------------------------------------------------------------
305   function nullifyFrom(address tokenOwner) public onlyOwner returns (bool success) {
306     return returnFrom(tokenOwner, balances[tokenOwner]);
307   }
308 }