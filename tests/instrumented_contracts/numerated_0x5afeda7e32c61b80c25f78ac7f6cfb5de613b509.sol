1 pragma solidity ^0.4.18;
2 
3 /**
4 
5 PinkDate Token-Share Contract (PDP)
6 Using code generously from https://github.com/OpenZeppelin/zeppelin-solidity/
7 
8 The MIT License (MIT)
9 
10 Copyright (c) 2016 Smart Contract Solutions, Inc.
11 
12 Permission is hereby granted, free of charge, to any person obtaining
13 a copy of this software and associated documentation files (the
14 "Software"), to deal in the Software without restriction, including
15 without limitation the rights to use, copy, modify, merge, publish,
16 distribute, sublicense, and/or sell copies of the Software, and to
17 permit persons to whom the Software is furnished to do so, subject to
18 the following conditions:
19 
20 The above copyright notice and this permission notice shall be included
21 in all copies or substantial portions of the Software.
22 
23 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
24 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
25 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
26 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
27 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
28 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
29 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
30 
31 */
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38 
39   /**
40   * @dev Multiplies two numbers, throws on overflow.
41   */
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     if (a == 0) {
44       return 0;
45     }
46     uint256 c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   /**
52   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 contract Ownable {
70   address public owner;
71 
72   /**
73    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
74    * account.
75    */
76   function Ownable() public {
77     owner = msg.sender;
78   }
79 
80   /**
81    * @dev Throws if called by any account other than the owner.
82    */
83   modifier onlyOwner() {
84     require(msg.sender == owner);
85     _;
86   }
87 
88 }
89 
90 contract ERC20Basic {
91   function totalSupply() public view returns (uint256);
92   function balanceOf(address who) public view returns (uint256);
93   function transfer(address to, uint256 value) public returns (bool);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95 }
96 
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender) public view returns (uint256);
99   function transferFrom(address from, address to, uint256 value) public returns (bool);
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 library SafeERC20 {
105   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
106     assert(token.transfer(to, value));
107   }
108 
109   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
110     assert(token.transferFrom(from, to, value));
111   }
112 
113   function safeApprove(ERC20 token, address spender, uint256 value) internal {
114     assert(token.approve(spender, value));
115   }
116 }
117 
118 contract CanReclaimToken is Ownable {
119   using SafeERC20 for ERC20Basic;
120 
121   /**
122    * @dev Reclaim all ERC20Basic compatible tokens
123    * @param token ERC20Basic The address of the token contract
124    */
125   function reclaimToken(ERC20Basic token) external onlyOwner {
126     uint256 balance = token.balanceOf(this);
127     token.safeTransfer(owner, balance);
128   }
129 
130 }
131 
132 contract BasicToken is ERC20Basic {
133   using SafeMath for uint256;
134 
135   mapping(address => uint256) balances;
136 
137   uint256 totalSupply_;
138 
139   /**
140   * @dev total number of tokens in existence
141   */
142   function totalSupply() public view returns (uint256) {
143     return totalSupply_;
144   }
145 
146   /**
147   * @dev transfer token for a specified address
148   */
149   function transfer(address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[msg.sender]);
152 
153     // SafeMath.sub will throw if there is not enough balance.
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   */
163   function balanceOf(address _owner) public view returns (uint256 balance) {
164     return balances[_owner];
165   }
166 
167 }
168 
169 contract StandardToken is ERC20, BasicToken {
170 
171   mapping (address => mapping (address => uint256)) internal allowed;
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    */
176   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177     require(_to != address(0));
178     require(_value <= balances[_from]);
179     require(_value <= allowed[_from][msg.sender]);
180 
181     balances[_from] = balances[_from].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184     Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    */
191   function approve(address _spender, uint256 _value) public returns (bool) {
192     allowed[msg.sender][_spender] = _value;
193     Approval(msg.sender, _spender, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens that an owner allowed to a spender.
199    */
200   function allowance(address _owner, address _spender) public view returns (uint256) {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * @dev Increase the amount of tokens that an owner allowed to a spender.
206    */
207   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
208     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
209     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213   /**
214    * @dev Decrease the amount of tokens that an owner allowed to a spender.
215    */
216   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
217     uint oldValue = allowed[msg.sender][_spender];
218     if (_subtractedValue > oldValue) {
219       allowed[msg.sender][_spender] = 0;
220     } else {
221       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222     }
223     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 }
227 
228 // --- BEGIN Custom Code ---
229 // Up until here things have been stock from OpenZeppelin
230 contract CappedBurnToken is StandardToken, Ownable {
231 
232   uint256 public cap;
233 
234   function CappedBurnToken(uint256 _cap) public {
235     require(_cap > 0);
236     cap = _cap;
237   }
238 
239   event Mint(address indexed to, uint256 amount);
240   event Unmint(address indexed from, uint256 amount);
241 
242   function mint(address _to, uint256 _amount) onlyOwner external returns (bool) {
243     require(totalSupply_.add(_amount) <= cap);
244     totalSupply_ = totalSupply_.add(_amount);
245     balances[_to] = balances[_to].add(_amount);
246     Mint(_to, _amount);
247     Transfer(address(0), _to, _amount);
248     return true;
249   }
250 
251   event Burn(address indexed burner, uint256 value);
252 
253   /// Permanently destroy tokens
254   function burn(uint256 _value) external {
255     address burner = msg.sender;
256     require(_value <= balances[burner]);
257     balances[burner] = balances[burner].sub(_value);
258     totalSupply_ = totalSupply_.sub(_value);
259     cap = cap.sub(_value);
260     Burn(burner, _value);
261     Transfer(msg.sender, address(0), _value);
262   }
263 
264   /// Same as burn without reducing cap, allows re-minting
265   function unmint(uint256 _value) external {
266     address burner = msg.sender;
267     require(_value <= balances[burner]);
268     balances[burner] = balances[burner].sub(_value);
269     totalSupply_ = totalSupply_.sub(_value);
270     Unmint(burner, _value);
271     Transfer(msg.sender, address(0), _value);
272   }
273 
274 }
275 
276 contract DetailedERC20 is ERC20 {
277   string public name;
278   string public symbol;
279   uint8 public decimals;
280 
281   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
282     name = _name;
283     symbol = _symbol;
284     decimals = _decimals;
285   }
286 }
287 
288 contract PDP is CappedBurnToken(144200000), DetailedERC20, CanReclaimToken { 
289   uint256 public saleMinShares;
290   uint256 public salePriceWei;
291   uint256 public saleSharesAvail;
292   address internal saleWallet;
293   uint256 public saleSharesSold;
294 
295   function PDP() DetailedERC20("PinkDate Platform Token-Share", "PDP", 0) public { 
296       saleWallet = address(0);
297       salePriceWei = 0;
298       saleSharesAvail = 0;
299       saleSharesSold = 0;
300   }
301 
302   event Purchase(address indexed to, uint256 shares);
303 
304   /// Tokens are manually issued to addresses that have sent ether
305   /// The contract sells a limited amount to ensure no oversale happens due to off-chain purchases
306   function() external payable { 
307       require(saleWallet != address(0)); // Other checks are done on setSale
308       uint256 shareTarget = msg.value / salePriceWei;
309       require(shareTarget >= saleMinShares);
310       require(shareTarget <= saleSharesAvail);
311       saleSharesAvail = saleSharesAvail.sub(shareTarget);
312       saleSharesSold = saleSharesSold.add(shareTarget);
313       Purchase(msg.sender, shareTarget);
314       saleWallet.transfer(msg.value);
315   }
316 
317   function setSale(uint256 newPriceWei, uint256 newSharesAvail, uint256 newMinShares, address newWallet) onlyOwner external {
318     // This may be called multiple time to allow more sales on-chain or to change parameters
319     // Call with 0 to end sale
320     if (newWallet == address(0)) {
321       // End sale
322       saleWallet = address(0);
323       salePriceWei = 0;
324       saleSharesAvail = 0;
325       saleMinShares = 0;
326     } else {
327       // These checks are just to be a bit safer and avoid typo mistake
328       require(totalSupply_ + saleSharesSold + newSharesAvail <= cap); // Do not exceed cap
329       require(newSharesAvail > 100 && newSharesAvail < 10000000); // Between 100 and 10M at a time
330       require(newMinShares < 20000); // Min purchase should not be too high
331       require(newPriceWei > 100000000000000); // At least around $0.10 / share
332       saleMinShares = newMinShares;
333       salePriceWei = newPriceWei;
334       saleSharesAvail = newSharesAvail;
335       saleWallet = newWallet;
336     }
337   }
338 
339   /// Only to be used in case tokens are distributed to allow setSale to issue more in case cap would be hit
340   function clearSaleSharesSold(uint256 confirm) onlyOwner external {
341     // Checks are just for a bit of safety
342     require(confirm == 1);
343     require(saleWallet == address(0)); // Sale must be over
344     // Next check is not perfect in light of multiple sale rounds but should work for main single round 
345     require(totalSupply_ >= saleSharesSold); // All sold tokens must be distributed
346     saleSharesSold = 0;
347   }
348 
349 }