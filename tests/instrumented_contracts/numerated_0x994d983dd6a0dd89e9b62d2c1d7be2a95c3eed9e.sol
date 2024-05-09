1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeSub(uint a, uint b) internal returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function safeAdd(uint a, uint b) internal returns (uint) {
16     uint c = a + b;
17     assert(c>=a && c>=b);
18     return c;
19   }
20 }
21 
22 contract Token {
23   /// @return total amount of tokens
24   function totalSupply() constant returns (uint256 supply) {
25     return 0;
26   }
27 
28   /// @param _owner The address from which the balance will be retrieved
29   /// @return The balance
30   function balanceOf(address _owner) constant returns (uint256 balance) {
31     _owner = _owner;
32     return 0;
33   }
34 
35   /// @notice send `_value` token to `_to` from `msg.sender`
36   /// @param _to The address of the recipient
37   /// @param _value The amount of token to be transferred
38   /// @return Whether the transfer was successful or not
39   function transfer(address _to, uint256 _value) returns (bool success) {
40     _to = _to;
41     _value = _value;
42     return false;
43   }
44 
45   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
46   /// @param _from The address of the sender
47   /// @param _to The address of the recipient
48   /// @param _value The amount of token to be transferred
49   /// @return Whether the transfer was successful or not
50   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
51     _from = _from;
52     _to = _to;
53     _value = _value;
54     return false;
55   }
56 
57   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
58   /// @param _spender The address of the account able to transfer the tokens
59   /// @param _value The amount of wei to be approved for transfer
60   /// @return Whether the approval was successful or not
61   function approve(address _spender, uint256 _value) returns (bool success) {
62     _spender = _spender;
63     _value = _value;
64     return false;
65   }
66 
67   /// @param _owner The address of the account owning tokens
68   /// @param _spender The address of the account able to transfer the tokens
69   /// @return Amount of remaining tokens allowed to spent
70   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
71     _owner = _owner;
72     _spender = _spender;
73     return 0;
74   }
75 
76   event Transfer(address indexed _from, address indexed _to, uint256 _value);
77   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78 
79   uint public decimals;
80   string public name;
81 }
82 
83 contract StandardToken is Token {
84 
85   function transfer(address _to, uint256 _value) returns (bool success) {
86     //Default assumes totalSupply can't be over max (2^256 - 1).
87     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
88     //Replace the if with this one instead.
89     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
90     //if (balances[msg.sender] >= _value && _value > 0) {
91       balances[msg.sender] -= _value;
92       balances[_to] += _value;
93       Transfer(msg.sender, _to, _value);
94       return true;
95     } else { return false; }
96   }
97 
98   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
99     //same as above. Replace this line with the following if you want to protect against wrapping uints.
100     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
101     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
102       balances[_to] += _value;
103       balances[_from] -= _value;
104       allowed[_from][msg.sender] -= _value;
105       Transfer(_from, _to, _value);
106       return true;
107     } else { return false; }
108   }
109 
110   function balanceOf(address _owner) constant returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114   function approve(address _spender, uint256 _value) returns (bool success) {
115     allowed[msg.sender][_spender] = _value;
116     Approval(msg.sender, _spender, _value);
117     return true;
118   }
119 
120   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
121     return allowed[_owner][_spender];
122   }
123 
124   mapping(address => uint256) balances;
125 
126   mapping (address => mapping (address => uint256)) allowed;
127 
128   uint256 public totalSupply;
129 }
130 
131 contract EtherPush is SafeMath {
132   struct Order {
133     uint    id;
134     address sell;
135     uint    sellamount;
136     address buy;
137     uint    buyamount;
138     address seller;
139     address buyer;
140     uint    created;
141     uint    expired;
142     uint    timestamp;
143   }
144 
145   mapping (address => mapping (address => uint))            public tokens;
146   mapping (uint => mapping (address => Order))              public orders;
147 
148   string  public constant  name = "EtherPush";
149   string  public constant  version = "20170913";
150 
151   bool    public           running = true;
152 
153   uint    public           sellerfee = 0.005 ether;
154   uint    public constant    sellerfeeDivide = 1 ether;
155 
156   uint    public           buyerfee = 0.005 ether;
157   uint    public constant    buyerfeeDivide = 1 ether;
158 
159   uint    private          _id = 0;
160   uint    private          _nonce = 0;
161   address  private          owner;
162 
163   event onSell(bytes32 nonce, uint id, address sell, uint sellamount, address buy, uint buyamount, address seller, address buyer, uint created, uint expired, uint timestamp);
164   event onBuy(bytes32 nonce, uint id, address sell, uint sellamount, uint balanceSellamount,
165               address buy, uint buyamount, uint balanceBuyamount, address seller, address buyer,
166               uint created, uint timestamp);
167   event onCancel(bytes32 nonce, uint id, address seller);
168   event onDeposit(address token, address user, uint amount, uint balance);
169   event onWithdraw(address token, address user, uint amount, uint balance);
170 
171   modifier onlyRunning() {
172     require(running);
173     _;
174   }
175 
176   modifier onlyOwner() {
177     require(msg.sender == owner);
178     _;
179   }
180 
181   function EtherPush() {
182     owner = msg.sender;
183   }
184 
185   function ownerChangeRunning(bool _running)
186     public
187     onlyOwner
188   {
189     running = _running;
190   }
191 
192   function ownerChangeSellerfee(uint _fee)
193     public
194     onlyOwner
195   {
196     /*
197      * between [0.1%, 2%]
198      */
199     require (_fee >= 0.001 ether && _fee <= 0.02 ether);
200 
201     sellerfee = _fee;
202   }
203 
204   function ownerChangeBuyerfee(uint _fee)
205     public
206     onlyOwner
207   {
208     /*
209      * between [0.1%, 2%]
210      */
211     require (_fee >= 0.001 ether && _fee <= 0.02 ether);
212     buyerfee = _fee;
213   }
214 
215   function ownerChangeOwner(address _owner)
216     public
217     onlyOwner
218   {
219     require (_owner > 0);
220     owner = _owner;
221   }
222 
223   function ownerWithdrawAccount(address account)
224     public
225     onlyOwner
226   {
227     account.transfer(this.balance);
228   }
229 
230   function ownerWithdraw()
231     public
232     onlyOwner
233   {
234     owner.transfer(this.balance);
235   }
236 
237   function getRunning() public constant returns (bool) {
238     return running;
239   }
240 
241   function getSellerfee() public constant returns (uint) {
242     return sellerfee;
243   }
244 
245   function getBuyerfee() public constant returns (uint) {
246     return buyerfee;
247   }
248 
249   function withdrawAmountETH(uint amount) {
250     if (tokens[0][msg.sender] < amount) {
251       revert();
252     }
253 
254     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
255 
256     msg.sender.transfer(amount);
257 
258     onWithdraw(0, msg.sender, amount, tokens[0][msg.sender]);
259   }
260 
261   function withdrawETH() {
262     uint amount = tokens[0][msg.sender];
263     tokens[0][msg.sender] = 0;
264 
265     msg.sender.transfer(amount);
266 
267     onWithdraw(0, msg.sender, amount, tokens[0][msg.sender]);
268   }
269 
270   function withdrawToken(address token) {
271     if (token == address(0)) {
272       revert();
273     }
274 
275     uint amount = tokens[token][msg.sender];
276     tokens[token][msg.sender] = 0;
277 
278     if (!Token(token).transfer(msg.sender, amount)) {
279       revert();
280     }
281 
282     onWithdraw(token, msg.sender, amount, tokens[token][msg.sender]);
283   }
284 
285   function withdrawAmountToken(address token, uint amount) {
286     if (token == address(0)) {
287       revert();
288     }
289 
290     if (tokens[token][msg.sender] < amount) {
291       revert();
292     }
293 
294     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
295 
296     if (!Token(token).transfer(msg.sender, amount)) {
297       revert();
298     }
299 
300     onWithdraw(token, msg.sender, amount, tokens[token][msg.sender]);
301   }
302 
303   function depositETH()
304     public
305     payable
306   {
307     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
308     onDeposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
309   }
310 
311   function depositToken(address token, uint amount)
312     public
313   {
314     if (token == address(0)) {
315       revert();
316     }
317 
318     if (!Token(token).transferFrom(msg.sender, this, amount)) {
319       revert();
320     }
321 
322     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
323     onDeposit(token, msg.sender, amount, tokens[token][msg.sender]);
324   }
325 
326   function balanceOf(address token, address user)
327     public
328     constant
329     returns
330     (uint)
331   {
332     return tokens[token][user];
333   }
334 
335   function tobuy(uint id, address seller, uint buyamount)
336     public
337     onlyRunning
338   {
339     if (orders[id][seller].expired < block.number) {
340       revert();
341     }
342 
343     if (orders[id][seller].buyer > 0) {
344       if (orders[id][seller].buyer != msg.sender) {
345         revert();
346       }
347     }
348 
349     if (orders[id][seller].buyamount < buyamount) {
350       revert();
351     }
352 
353     address sell = orders[id][seller].sell;
354     address buy = orders[id][seller].buy;
355     uint    ordersellamount = orders[id][seller].sellamount;
356     uint    orderbuyamount = orders[id][seller].buyamount;
357     uint    sellamount = safeMul(ordersellamount, buyamount) / orderbuyamount;
358     buyamount = safeMul(sellamount, orderbuyamount) / ordersellamount;
359 
360     if (ordersellamount < sellamount) {
361       revert();
362     }
363 
364     if (tokens[sell][seller] < sellamount) {
365       revert();
366     }
367 
368     if (tokens[buy][msg.sender] < buyamount) {
369       revert();
370     }
371 
372     uint _sellerfee = safeMul(sellamount, sellerfee) / sellerfeeDivide;
373     uint _buyerfee = safeMul(buyamount, buyerfee) / buyerfeeDivide;
374 
375     /*
376      * order
377      */
378 
379     orders[id][seller].sellamount = safeSub(orders[id][seller].sellamount, sellamount);
380     orders[id][seller].buyamount = safeSub(orders[id][seller].buyamount, buyamount);
381 
382     /*
383      * balance sell token
384      */
385 
386     tokens[sell][seller] = safeSub(tokens[sell][seller], sellamount);
387     tokens[sell][owner] = safeAdd(tokens[sell][owner], _sellerfee);
388     tokens[sell][msg.sender] = safeAdd(tokens[sell][msg.sender], safeSub(sellamount, _sellerfee));
389 
390     /*
391      * balance buy token
392      */
393 
394     tokens[buy][msg.sender] = safeSub(tokens[buy][msg.sender], buyamount);
395     tokens[buy][owner] = safeAdd(tokens[buy][owner], _buyerfee);
396     tokens[buy][seller] = safeAdd(tokens[buy][seller], safeSub(buyamount, _buyerfee));
397 
398     /*
399      * call to buy function to clear stack
400      */
401 
402     _tobuy(id, seller, sellamount, buyamount);
403   }
404 
405   function _tobuy(uint id, address seller, uint sellamount, uint buyamount)
406     private
407   {
408     bytes32 nonce = sha3(block.number, msg.data, _nonce++);
409     onBuy(
410          nonce,
411          id,
412          orders[id][seller].sell,
413          sellamount,
414          orders[id][seller].sellamount,
415          orders[id][seller].buy,
416          buyamount,
417          orders[id][seller].buyamount,
418          seller,
419          msg.sender,
420          block.number,
421          now
422          );
423   }
424 
425   function tosell(address sell, uint sellamount, address buy, uint buyamount,
426                address buyer, uint expire, uint broadcast)
427     public
428     onlyRunning
429   {
430 
431     if (tokens[sell][msg.sender] < sellamount) {
432       revert();
433     }
434 
435     /*
436      * if buyer > 0, the order only can be purchased by the specified buyer.
437      * and here we do not check the token balance to imporve the poor performance
438      */
439 
440     _id = _id + 1;
441     orders[_id][msg.sender].id = _id;
442     orders[_id][msg.sender].sell = sell;
443     orders[_id][msg.sender].sellamount = sellamount;
444     orders[_id][msg.sender].buy = buy;
445     orders[_id][msg.sender].buyamount = buyamount;
446     orders[_id][msg.sender].seller = msg.sender;
447     orders[_id][msg.sender].buyer = buyer;
448     orders[_id][msg.sender].created = block.number;
449     orders[_id][msg.sender].expired = safeAdd(block.number, expire);
450 
451     bytes32 nonce = sha3(block.number, msg.data, _nonce++);
452 
453     onSell(nonce, _id, sell, sellamount, buy, buyamount, msg.sender, buyer, block.number, orders[_id][msg.sender].expired, now);
454   }
455 
456   function tocancel(uint id)
457     public
458   {
459     orders[id][msg.sender].sellamount = 0;
460 
461     bytes32 nonce = sha3(block.number, msg.data, _nonce++);
462 
463     onCancel(nonce, id, msg.sender);
464   }
465 
466   function getOrder(uint id, address seller)
467     public
468     constant
469     returns
470     (address, uint, address, uint, address, uint)
471   {
472     return (orders[id][seller].sell,
473       orders[id][seller].sellamount,
474       orders[id][seller].buy,
475       orders[id][seller].buyamount,
476       orders[id][seller].buyer,
477       orders[id][seller].expired
478     );
479   }
480 }