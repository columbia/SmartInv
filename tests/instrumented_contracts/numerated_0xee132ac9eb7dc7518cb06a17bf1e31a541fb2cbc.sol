1 // File: contracts/IERC20Token.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /*
6     ERC20 Standard Token interface
7 */
8 contract IERC20Token {
9     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
10     function name() public view returns (string) {}
11     function symbol() public view returns (string) {}
12     function decimals() public view returns (uint8) {}
13     function totalSupply() public view returns (uint256) {}
14     function balanceOf(address _owner) public view returns (uint256) { _owner; }
15     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
16 
17     function transfer(address _to, uint256 _value) public returns (bool success);
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
19     function approve(address _spender, uint256 _value) public returns (bool success);
20 }
21 
22 // File: contracts/Bancor.sol
23 
24 pragma solidity ^0.4.24;
25 
26 
27 contract Bancor {
28   function claimAndConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {}
29   function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {}
30 }
31 
32 // File: contracts/EtherDelta.sol
33 
34 pragma solidity ^0.4.24;
35 
36 contract EtherDelta {
37   function deposit() payable {}
38   function depositToken(address token, uint amount) {}
39   function withdraw(uint amount) {}
40   function withdrawToken(address token, uint amount) {}
41   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {}
42   function balanceOf(address token, address user) constant returns (uint) {}
43 }
44 
45 // File: contracts/Token.sol
46 
47 pragma solidity ^0.4.24;
48 
49 contract Token {
50   /// @return total amount of tokens
51   function totalSupply() constant returns (uint256 supply) {}
52 
53   /// @param _owner The address from which the balance will be retrieved
54   /// @return The balance
55   function balanceOf(address _owner) constant returns (uint256 balance) {}
56 
57   /// @notice send `_value` token to `_to` from `msg.sender`
58   /// @param _to The address of the recipient
59   /// @param _value The amount of token to be transferred
60   /// @return Whether the transfer was successful or not
61   function transfer(address _to, uint256 _value) returns (bool success) {}
62 
63   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
64   /// @param _from The address of the sender
65   /// @param _to The address of the recipient
66   /// @param _value The amount of token to be transferred
67   /// @return Whether the transfer was successful or not
68   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
69 
70   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
71   /// @param _spender The address of the account able to transfer the tokens
72   /// @param _value The amount of wei to be approved for transfer
73   /// @return Whether the approval was successful or not
74   function approve(address _spender, uint256 _value) returns (bool success) {}
75 
76   /// @param _owner The address of the account owning tokens
77   /// @param _spender The address of the account able to transfer the tokens
78   /// @return Amount of remaining tokens allowed to spent
79   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
80 
81   event Transfer(address indexed _from, address indexed _to, uint256 _value);
82   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83 
84   uint public decimals;
85   string public name;
86 }
87 
88 // File: contracts/TokenNoBool.sol
89 
90 pragma solidity ^0.4.24;
91 
92 contract TokenNoBool {
93   /// @return total amount of tokens
94   function totalSupply() constant returns (uint256 supply) {}
95 
96   /// @param _owner The address from which the balance will be retrieved
97   /// @return The balance
98   function balanceOf(address _owner) constant returns (uint256 balance) {}
99 
100   /// @notice send `_value` token to `_to` from `msg.sender`
101   /// @param _to The address of the recipient
102   /// @param _value The amount of token to be transferred
103   /// @return Whether the transfer was successful or not
104   function transfer(address _to, uint256 _value) {}
105 
106   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
107   /// @param _from The address of the sender
108   /// @param _to The address of the recipient
109   /// @param _value The amount of token to be transferred
110   /// @return Whether the transfer was successful or not
111   function transferFrom(address _from, address _to, uint256 _value) {}
112 
113   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
114   /// @param _spender The address of the account able to transfer the tokens
115   /// @param _value The amount of wei to be approved for transfer
116   /// @return Whether the approval was successful or not
117   function approve(address _spender, uint256 _value) {}
118 
119   /// @param _owner The address of the account owning tokens
120   /// @param _spender The address of the account able to transfer the tokens
121   /// @return Amount of remaining tokens allowed to spent
122   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
123 
124   event Transfer(address indexed _from, address indexed _to, uint256 _value);
125   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
126 
127   uint public decimals;
128   string public name;
129 }
130 
131 // File: contracts/GST2.sol
132 
133 pragma solidity ^0.4.24;
134 
135 contract GST2 {
136   function mint(uint256 value) public {}
137   function freeUpTo(uint256 value) public returns (uint256 freed) {}
138   function freeFromUpTo(address from, uint256 value) public returns (uint256 freed) {}
139 }
140 
141 // File: contracts/Arbot.sol
142 
143 pragma solidity ^0.4.24;
144 pragma experimental ABIEncoderV2;
145 
146 
147 
148 
149 
150 
151 
152 contract Arbot {
153   enum Exchange { ETHERDELTA, BANCOR }
154   struct DeltaTrade {
155     DeltaOrder order;
156     // amountMinusFee (- 0.3% of delta fee)
157     uint256 amount;
158   }
159 
160   struct DeltaOrder {
161     // 0 tokenGet
162     // 1 tokenGive
163     // 2 order user
164     address[3] addresses;
165     // 0 amountGet
166     // 1 amountGive
167     // 2 expires
168     // 3 nonce
169     uint256[4] values;
170     uint8 v;
171     bytes32 r;
172     bytes32 s;
173   }
174 
175   EtherDelta etherDelta;
176   Bancor bancor;
177   address owner;
178   address executor;
179 
180   modifier onlyOwner() {
181     require(msg.sender == owner);
182     _;
183   }
184 
185   modifier onlyOwnerAndExecutor() {
186     require(msg.sender == owner || msg.sender == executor);
187     _;
188   }
189 
190   constructor() public {
191     owner = msg.sender;
192     executor = 0xA21623FD5dd105F0d2d61327438F4C695aBA6dC3;
193   }
194 
195   function setExecutor(address _newExecutor) public onlyOwner {
196     executor = _newExecutor;
197   }
198 
199   function atomicTrade(
200     Exchange buyExchange,
201     IERC20Token[] _path,
202     // addresses:
203     // 0 etherdelta contract address
204     // 1 bancor contract address
205     // 2 token to trade contract address
206     address[3] addresses,
207     // values:
208     // 0 bancorAmount
209     // 1 bancorMinReturn
210     // 2 depositAmount
211     uint256[3] values,
212     DeltaTrade[] deltaTrades,
213     bool balanceCheck,
214     bool _isProperERC20
215   ) internal returns (uint256, uint256) {
216     require(addresses[0] != address(0));
217     require(addresses[1] != address(0));
218     require(addresses[2] != address(0));
219 
220     etherDelta = EtherDelta(addresses[0]);
221     bancor = Bancor(addresses[1]);
222 
223     uint256 balanceBefore = address(this).balance;
224     uint256 tokenBalance = 0;
225     uint256 ethReturned = 0;
226 
227     if (buyExchange == Exchange.ETHERDELTA) {
228       tokenBalance = makeBuyTradeEtherDeltaTrade(deltaTrades, values[2]);
229       ensureAllowance(addresses[2], address(bancor), tokenBalance, _isProperERC20);
230       ethReturned = bancor.claimAndConvert(_path, tokenBalance, values[1]);
231     } else {
232       tokenBalance = bancor.convert.value(values[0])(_path, values[0], values[1]);
233       ensureAllowance(addresses[2], address(etherDelta), tokenBalance, _isProperERC20);
234       ethReturned = makeSellTradeEtherDeltaTrade(deltaTrades, tokenBalance);
235     }
236 
237     if (balanceCheck) {
238       require(address(this).balance >= balanceBefore - 1); // 1 due to rounding errors
239     }
240     return (address(this).balance, ethReturned);
241   }
242 
243   // we are filling sell orders in delta
244   function makeBuyTradeEtherDeltaTrade(DeltaTrade[] trades, uint256 depositValue) private returns (uint256) {
245     etherDelta.deposit.value(depositValue)(); // we deposit "amount" (which is in order.amountGet terms which is eth)
246 
247     for (uint256 i = 0; i < trades.length; i++) {
248       etherDelta.trade(
249         trades[i].order.addresses[0], // tokenGet is 0x0
250         trades[i].order.values[0], // amountGet
251         trades[i].order.addresses[1], // tokenGive
252         trades[i].order.values[1], // amountGive
253 
254         trades[i].order.values[2], // expires
255         trades[i].order.values[3], // nonce
256         trades[i].order.addresses[2], // trades[i].order user
257         trades[i].order.v, trades[i].order.r, trades[i].order.s, // signature
258         trades[i].amount // amountMinusFee (- 0.3% of delta fee)
259       );
260     }
261 
262     // ALWAYS get back eth and tokens in surplus
263     deltaWithdrawAllEth();
264     return deltaWithdrawAllTokens(trades[0].order.addresses[1]); // tokenGive
265   }
266 
267   // we are filling a buy order in delta
268   function makeSellTradeEtherDeltaTrade(DeltaTrade[] trades, uint256 tokenBalance) private returns (uint256) {
269     etherDelta.depositToken(
270       trades[0].order.addresses[0], // order.tokenGet
271       tokenBalance // which should always be <= tokenBalance
272     );
273 
274     for (uint256 i = 0; i < trades.length; i++) {
275       etherDelta.trade(
276         trades[i].order.addresses[0], // tokenGet
277         trades[i].order.values[0], // amountGet
278         trades[i].order.addresses[1], // tokenGive is 0x0
279         trades[i].order.values[1], // amountGive
280         trades[i].order.values[2], // expires
281         trades[i].order.values[3], // nonce
282         trades[i].order.addresses[2], // trades[i].order user
283         trades[i].order.v, trades[i].order.r, trades[i].order.s, // signature
284         trades[i].amount // amount (- 0.3% of delta fee)
285       );
286     }
287 
288     // ALWAYS get back tokens and eth in surplus
289     deltaWithdrawAllTokens(trades[0].order.addresses[0]); // tokenGet
290     return deltaWithdrawAllEth();
291   }
292 
293   function deltaWithdrawAllEth() public onlyOwnerAndExecutor returns (uint256) {
294     uint256 ethBalance = etherDelta.balanceOf(0x0000000000000000000000000000000000000000, address(this));
295     if (ethBalance != 0) {
296       etherDelta.withdraw(ethBalance);
297     }
298     return ethBalance;
299   }
300 
301   function deltaWithdrawAllTokens(address token) public onlyOwnerAndExecutor returns (uint256) {
302     uint256 tokenBalance = etherDelta.balanceOf(token, address(this));
303     if (tokenBalance != 0) {
304       etherDelta.withdrawToken(token, tokenBalance);
305     }
306     return tokenBalance;
307   }
308 
309   /*
310    * Makes token tradeable by setting an allowance for etherDelta and BancorNetwork contract.
311    * Also sets an allowance for the owner of the contracts therefore allowing to withdraw tokens.
312    */
313   /* function setAllowances(address tokenAddr, uint256 amount) public onlyOwner { */
314     /* ensureAllowance(tokenAddr, address(etherDelta), amount); */
315     /* ensureAllowance(tokenAddr, address(bancor), amount); */
316     /* ensureAllowance(tokenAddr, address(this), amount); // This should not be needed */
317     /* ensureAllowance(tokenAddr, owner, amount); */
318   /* } */
319 
320 
321   function ensureAllowance(address tokenAddr, address _spender, uint256 _value, bool _isProperERC20) private {
322     // needed for tokens that do not return  book for approve
323     if (_isProperERC20) {
324       Token _token = Token(tokenAddr);
325       // check if allowance for the given amount already exists
326       if (_token.allowance(this, _spender) >= _value) {
327         return;
328       }
329 
330       // if the allowance is nonzero, must reset it to 0 first
331       if (_token.allowance(this, _spender) != 0) {
332         _token.approve(_spender, 0);
333       }
334 
335       // approve the new allowance
336       _token.approve(_spender, _value);
337     } else {
338       TokenNoBool _tokenNoBool = TokenNoBool(tokenAddr);
339       // check if allowance for the given amount already exists
340       if (_tokenNoBool.allowance(this, _spender) >= _value) {
341         return;
342       }
343 
344       // if the allowance is nonzero, must reset it to 0 first
345       if (_tokenNoBool.allowance(this, _spender) != 0) {
346         _tokenNoBool.approve(_spender, 0);
347       }
348 
349       // approve the new allowance
350       _tokenNoBool.approve(_spender, _value);
351     }
352   }
353 
354   function withdraw() external onlyOwner {
355     owner.transfer(address(this).balance);
356   }
357 
358   function withdrawToken(address _token, bool _isProperERC20) external onlyOwner {
359     // needed for tokens that do not return bool for transfer
360     if (_isProperERC20) {
361       Token token = Token(_token);
362       token.transfer(owner, token.balanceOf(address(this)));
363     } else {
364       TokenNoBool tokenNoBool = TokenNoBool(_token);
365       tokenNoBool.transfer(owner, tokenNoBool.balanceOf(address(this)));
366     }
367   }
368 
369   function destroyContract() external onlyOwner {
370     selfdestruct(owner);
371   }
372 
373   // fallback function for getting eth sent directly to the contract address
374   function() public payable {}
375 
376   // ======== Gas Token functions
377   function storeGas(uint256 num_tokens) public onlyOwner {
378     GST2 gst2 = GST2(0x0000000000b3F879cb30FE243b4Dfee438691c04);
379     gst2.mint(num_tokens);
380   }
381   function useCheapGas(uint256 num_tokens) private returns (uint256 freed) {
382     // see here https://github.com/projectchicago/gastoken/blob/master/contract/gst2_free_example.sol
383     GST2 gst2 = GST2(0x0000000000b3F879cb30FE243b4Dfee438691c04);
384 
385     uint256 safe_num_tokens = 0;
386     uint256 gas = msg.gas;
387 
388     if (gas >= 27710) {
389       safe_num_tokens = (gas - 27710) / (1148 + 5722 + 150);
390     }
391 
392     if (num_tokens > safe_num_tokens) {
393       num_tokens = safe_num_tokens;
394     }
395 
396     if (num_tokens > 0) {
397       return gst2.freeUpTo(num_tokens);
398     } else {
399       return 0;
400     }
401   }
402 
403   //
404   function atomicTradeGST(
405     Exchange buyExchange,
406     IERC20Token[] _path,
407     address[3] addresses,
408     uint256[3] values,
409     DeltaTrade[] deltaTrades,
410     bool balanceCheck,
411     uint256 numTokens,
412     bool _isProperERC20
413   ) public onlyOwnerAndExecutor returns (uint256, uint256) {
414     // Free numTokens but always pass
415     require(useCheapGas(numTokens) >= 0);
416     return atomicTrade(
417       buyExchange,
418       _path,
419       addresses,
420       values,
421       deltaTrades,
422       balanceCheck,
423       _isProperERC20
424     );
425   }
426 }