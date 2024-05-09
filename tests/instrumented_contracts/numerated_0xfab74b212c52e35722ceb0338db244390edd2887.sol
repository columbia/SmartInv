1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function add(uint a, uint b) internal pure returns (uint c) {
5     c = a + b;
6     require(c >= a);
7   }
8   function sub(uint a, uint b) internal pure returns (uint c) {
9     require(b <= a);
10     c = a - b;
11   }
12   function mul(uint a, uint b) internal pure returns (uint c) {
13     c = a * b;
14     require(a == 0 || c / a == b);
15   }
16   function div(uint a, uint b) internal pure returns (uint c) {
17     require(b > 0);
18     c = a / b;
19   }
20 }
21 
22 contract ERC20 {
23   function totalSupply() public constant returns (uint256);
24   function balanceOf(address tokenOwner) public constant returns (uint256 balance);
25   function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
26   function transfer(address to, uint tokens) public returns (bool success);
27   function approve(address spender, uint tokens) public returns (bool success);
28   function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30   event Transfer(address indexed from, address indexed to, uint256 tokens);
31   event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
32 }
33 
34 contract Owned {
35   address public owner;
36 
37   // ------------------------------------------------------------------------
38   // Constructor
39   // ------------------------------------------------------------------------
40   constructor() public {
41     owner = msg.sender;
42   }
43 
44   modifier onlyOwner {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   function transferOwnership(address newOwner) public onlyOwner returns (address account) {
50     owner = newOwner;
51     return owner;
52   }
53 }
54 
55 contract CSTKDropToken is ERC20, Owned {
56   using SafeMath for uint256;
57 
58   string public symbol;
59   string public  name;
60   uint256 public decimals;
61   uint256 _totalSupply;
62 
63   bool public started;
64 
65   address public token;
66 
67   struct Level {
68     uint256 price;
69     uint256 available;
70   }
71 
72   Level[] levels;
73 
74   mapping(address => uint256) balances;
75   mapping(address => mapping(string => uint256)) orders;
76 
77   event TransferETH(address indexed from, address indexed to, uint256 eth);
78   event Sell(address indexed to, uint256 tokens, uint256 eth);
79 
80   // ------------------------------------------------------------------------
81   // Constructor
82   // ------------------------------------------------------------------------
83   constructor(string _symbol, string _name, uint256 _supply, uint256 _decimals, address _token) public {
84     symbol = _symbol;
85     name = _name;
86     decimals = _decimals;
87     token = _token;
88     _totalSupply = _supply;
89     balances[owner] = _totalSupply;
90     started = false;
91     emit Transfer(address(0), owner, _totalSupply);
92   }
93 
94   function destruct() public onlyOwner {
95     ERC20 tokenInstance = ERC20(token);
96 
97     uint256 balance = tokenInstance.balanceOf(this);
98 
99     if (balance > 0) {
100       tokenInstance.transfer(owner, balance);
101     }
102 
103     selfdestruct(owner);
104   }
105 
106   // ------------------------------------------------------------------------
107   // Changes the address of the supported token
108   // ------------------------------------------------------------------------
109   function setToken(address newTokenAddress) public onlyOwner returns (bool success) {
110     token = newTokenAddress;
111     return true;
112   }
113 
114   // ------------------------------------------------------------------------
115   // Total supply
116   // ------------------------------------------------------------------------
117   function totalSupply() public view returns (uint256) {
118     return _totalSupply.sub(balances[address(0)]);
119   }
120 
121   // ------------------------------------------------------------------------
122   // Changes the total supply value
123   //
124   // a new supply must be no less then the current supply
125   // or the owner must have enough amount to cover supply reduction
126   // ------------------------------------------------------------------------
127   function changeTotalSupply(uint256 newSupply) public onlyOwner returns (bool success) {
128     require(newSupply >= 0 && (
129       newSupply >= _totalSupply || _totalSupply - newSupply <= balances[owner]
130     ));
131     uint256 diff = 0;
132     if (newSupply >= _totalSupply) {
133       diff = newSupply.sub(_totalSupply);
134       balances[owner] = balances[owner].add(diff);
135       emit Transfer(address(0), owner, diff);
136     } else {
137       diff = _totalSupply.sub(newSupply);
138       balances[owner] = balances[owner].sub(diff);
139       emit Transfer(owner, address(0), diff);
140     }
141     _totalSupply = newSupply;
142     return true;
143   }
144 
145   // ------------------------------------------------------------------------
146   // Get the token balance for account `tokenOwner`
147   // ------------------------------------------------------------------------
148   function balanceOf(address tokenOwner) public view returns (uint256 balance) {
149     return balances[tokenOwner];
150   }
151 
152   // ------------------------------------------------------------------------
153   // Start accept orders
154   // ------------------------------------------------------------------------
155   function start() public onlyOwner {
156     started = true;
157   }
158 
159   // ------------------------------------------------------------------------
160   // Start accept orders
161   // ------------------------------------------------------------------------
162   function stop() public onlyOwner {
163     started = false;
164   }
165 
166   // ------------------------------------------------------------------------
167   // Adds new Level to the levels array
168   // ------------------------------------------------------------------------
169   function addLevel(uint256 price, uint256 available) public onlyOwner {
170     levels.push(Level(price, available));
171   }
172 
173   // ------------------------------------------------------------------------
174   // Removes a level with specified price from the levels array
175   // ------------------------------------------------------------------------
176   function removeLevel(uint256 price) public onlyOwner {
177     if (levels.length < 1) {
178       return;
179     }
180 
181     Level[] memory tmp = levels;
182 
183     delete levels;
184 
185     for (uint i = 0; i < tmp.length; i++) {
186       if (tmp[i].price != price) {
187         levels.push(tmp[i]);
188       }
189     }
190   }
191 
192   // ------------------------------------------------------------------------
193   // Replaces a particular level index by a new Level values
194   // ------------------------------------------------------------------------
195   function replaceLevel(uint index, uint256 price, uint256 available) public onlyOwner {
196     levels[index] = Level(price, available);
197   }
198 
199   // ------------------------------------------------------------------------
200   // Clears the levels array
201   // ------------------------------------------------------------------------
202   function clearLevels() public onlyOwner {
203     delete levels;
204   }
205 
206   // ------------------------------------------------------------------------
207   // Finds a level with specified price and returns an amount of available tokens on the level
208   // ------------------------------------------------------------------------
209   function getLevelAmount(uint256 price) public view returns (uint256 available) {
210     if (levels.length < 1) {
211       return 0;
212     }
213 
214     for (uint i = 0; i < levels.length; i++) {
215       if (levels[i].price == price) {
216         return levels[i].available;
217       }
218     }
219   }
220 
221   // ------------------------------------------------------------------------
222   // Returns a Level by it's array index
223   // ------------------------------------------------------------------------
224   function getLevelByIndex(uint index) public view returns (uint256 price, uint256 available) {
225     price = levels[index].price;
226     available = levels[index].available;
227   }
228 
229   // ------------------------------------------------------------------------
230   // Returns a count of levels
231   // ------------------------------------------------------------------------
232   function getLevelsCount() public view returns (uint) {
233     return levels.length;
234   }
235 
236   // ------------------------------------------------------------------------
237   // Returns a Level by it's array index
238   // ------------------------------------------------------------------------
239   function getCurrentLevel() public view returns (uint256 price, uint256 available) {
240     if (levels.length < 1) {
241       return;
242     }
243 
244     for (uint i = 0; i < levels.length; i++) {
245       if (levels[i].available > 0) {
246         price = levels[i].price;
247         available = levels[i].available;
248         break;
249       }
250     }
251   }
252 
253   // ------------------------------------------------------------------------
254   // Get the order's balance of tokens for account `customer`
255   // ------------------------------------------------------------------------
256   function orderTokensOf(address customer) public view returns (uint256 balance) {
257     return orders[customer]['tokens'];
258   }
259 
260   // ------------------------------------------------------------------------
261   // Get the order's balance of ETH for account `customer`
262   // ------------------------------------------------------------------------
263   function orderEthOf(address customer) public view returns (uint256 balance) {
264     return orders[customer]['eth'];
265   }
266 
267   // ------------------------------------------------------------------------
268   // Delete customer's order
269   // ------------------------------------------------------------------------
270   function cancelOrder(address customer) public onlyOwner returns (bool success) {
271     orders[customer]['eth'] = 0;
272     orders[customer]['tokens'] = 0;
273     return true;
274   }
275 
276   // ------------------------------------------------------------------------
277   // Checks the order values by the customer's address and sends required
278   // promo tokens based on the received amount of `this` tokens and ETH
279   // ------------------------------------------------------------------------
280   function _checkOrder(address customer) private returns (uint256 tokens, uint256 eth) {
281     require(started);
282 
283     eth = 0;
284     tokens = 0;
285 
286     if (getLevelsCount() <= 0 || orders[customer]['tokens'] <= 0 || orders[customer]['eth'] <= 0) {
287       return;
288     }
289 
290     uint256 decimalsDiff = 10 ** (18 - 2 * decimals);
291 
292     ERC20 tokenInstance = ERC20(token);
293     uint256 balance = tokenInstance.balanceOf(this);
294 
295     uint256 orderEth = orders[customer]['eth'];
296     uint256 orderTokens = orders[customer]['tokens'] > balance ? balance : orders[customer]['tokens'];
297 
298     for (uint i = 0; i < levels.length; i++) {
299       if (levels[i].available <= 0) {
300         continue;
301       }
302 
303       uint256 _tokens = orderEth / levels[i].price / decimalsDiff;
304 
305       // check if there enough tokens on the level
306       if (_tokens > levels[i].available) {
307         _tokens = levels[i].available;
308       }
309 
310       // check the order tokens limit
311       if (_tokens > orderTokens) {
312         _tokens = orderTokens;
313       }
314 
315       uint256 _eth = _tokens * levels[i].price * decimalsDiff;
316       levels[i].available -= _tokens;
317 
318       // accumulate total price and tokens
319       eth += _eth;
320       tokens += _tokens;
321 
322       // reduce remaining limits
323       orderEth -= _eth;
324       orderTokens -= _tokens;
325 
326       if (orderEth <= 0 || orderTokens <= 0) {
327         // order is calculated
328         break;
329       }
330     }
331 
332     // charge required amount of the tokens and ETHs
333     orders[customer]['tokens'] = orders[customer]['tokens'].sub(tokens);
334     orders[customer]['eth'] = orders[customer]['eth'].sub(eth);
335 
336     tokenInstance.transfer(customer, tokens);
337 
338     emit Sell(customer, tokens, eth);
339   }
340 
341   // ------------------------------------------------------------------------
342   // public entry point for the `_checkOrder` function
343   // ------------------------------------------------------------------------
344   function checkOrder(address customer) public onlyOwner returns (uint256 tokens, uint256 eth) {
345     return _checkOrder(customer);
346   }
347 
348   // ------------------------------------------------------------------------
349   // Transfer the balance from token owner's account to `to` account
350   // - Owner's account must have sufficient balance to transfer
351   // - 0 value transfers are allowed
352   // - only owner is allowed to send tokens to any address
353   // - not owners can transfer the balance only to owner's address
354   // ------------------------------------------------------------------------
355   function transfer(address to, uint256 tokens) public returns (bool success) {
356     require(msg.sender == owner || to == owner || to == address(this));
357     address receiver = msg.sender == owner ? to : owner;
358 
359     balances[msg.sender] = balances[msg.sender].sub(tokens);
360     balances[receiver] = balances[receiver].add(tokens);
361 
362     emit Transfer(msg.sender, receiver, tokens);
363 
364     if (receiver == owner) {
365       orders[msg.sender]['tokens'] = orders[msg.sender]['tokens'].add(tokens);
366       _checkOrder(msg.sender);
367     }
368 
369     return true;
370   }
371 
372   // ------------------------------------------------------------------------
373   // `allowance` is not allowed
374   // ------------------------------------------------------------------------
375   function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
376     tokenOwner;
377     spender;
378     return uint256(0);
379   }
380 
381   // ------------------------------------------------------------------------
382   // `approve` is not allowed
383   // ------------------------------------------------------------------------
384   function approve(address spender, uint tokens) public returns (bool success) {
385     spender;
386     tokens;
387     return true;
388   }
389 
390   // ------------------------------------------------------------------------
391   // `transferFrom` is not allowed
392   // ------------------------------------------------------------------------
393   function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
394     from;
395     to;
396     tokens;
397     return true;
398   }
399 
400   // ------------------------------------------------------------------------
401   // Accept ETH
402   // ------------------------------------------------------------------------
403   function () public payable {
404     owner.transfer(msg.value);
405     emit TransferETH(msg.sender, address(this), msg.value);
406 
407     orders[msg.sender]['eth'] = orders[msg.sender]['eth'].add(msg.value);
408     _checkOrder(msg.sender);
409   }
410 
411   // ------------------------------------------------------------------------
412   // Owner can transfer out any accidentally sent ERC20 tokens
413   // ------------------------------------------------------------------------
414   function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
415     return ERC20(tokenAddress).transfer(owner, tokens);
416   }
417 
418   // ------------------------------------------------------------------------
419   // Owner can transfer out promo token
420   // ------------------------------------------------------------------------
421   function transferToken(uint256 tokens) public onlyOwner returns (bool success) {
422     return transferAnyERC20Token(token, tokens);
423   }
424 
425   // ------------------------------------------------------------------------
426   // Owner can return specified amount from `tokenOwner`
427   // ------------------------------------------------------------------------
428   function returnFrom(address tokenOwner, uint256 tokens) public onlyOwner returns (bool success) {
429     balances[tokenOwner] = balances[tokenOwner].sub(tokens);
430     balances[owner] = balances[owner].add(tokens);
431     emit Transfer(tokenOwner, owner, tokens);
432     return true;
433   }
434 
435   // ------------------------------------------------------------------------
436   // Owner can return all tokens from `tokenOwner`
437   // ------------------------------------------------------------------------
438   function nullifyFrom(address tokenOwner) public onlyOwner returns (bool success) {
439     return returnFrom(tokenOwner, balances[tokenOwner]);
440   }
441 }
442 
443 contract CSTK_KRM is CSTKDropToken('CSTK_KRM', 'CryptoStock KRM Promo Token', 100000000 * 10**5, 5, 0x124c801606Be4b90bb46Fbb03fc0264B461B821B) {
444 
445 }