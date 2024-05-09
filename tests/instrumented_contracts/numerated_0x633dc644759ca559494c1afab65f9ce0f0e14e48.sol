1 pragma solidity ^0.4.24;
2 
3 
4 contract Ownable {
5   address private _owner;
6 
7   event OwnershipTransferred(
8     address indexed previousOwner,
9     address indexed newOwner
10   );
11 
12   
13   constructor() internal {
14     _owner = msg.sender;
15     emit OwnershipTransferred(address(0), _owner);
16   }
17 
18   
19   function owner() public view returns(address) {
20     return _owner;
21   }
22 
23   
24   modifier onlyOwner() {
25     require(isOwner());
26     _;
27   }
28 
29   
30   function isOwner() public view returns(bool) {
31     return msg.sender == _owner;
32   }
33 
34   
35   function renounceOwnership() public onlyOwner {
36     emit OwnershipTransferred(_owner, address(0));
37     _owner = address(0);
38   }
39 
40   
41   function transferOwnership(address newOwner) public onlyOwner {
42     _transferOwnership(newOwner);
43   }
44 
45   
46   function _transferOwnership(address newOwner) internal {
47     require(newOwner != address(0));
48     emit OwnershipTransferred(_owner, newOwner);
49     _owner = newOwner;
50   }
51 }
52 
53 interface IERC20 {
54   function totalSupply() external view returns (uint256);
55 
56   function balanceOf(address who) external view returns (uint256);
57 
58   function allowance(address owner, address spender)
59     external view returns (uint256);
60 
61   function transfer(address to, uint256 value) external returns (bool);
62 
63   function approve(address spender, uint256 value)
64     external returns (bool);
65 
66   function transferFrom(address from, address to, uint256 value)
67     external returns (bool);
68 
69   event Transfer(
70     address indexed from,
71     address indexed to,
72     uint256 value
73   );
74 
75   event Approval(
76     address indexed owner,
77     address indexed spender,
78     uint256 value
79   );
80 }
81 
82 library SafeMath {
83 
84   
85   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86     
87     
88     
89     if (a == 0) {
90       return 0;
91     }
92 
93     uint256 c = a * b;
94     require(c / a == b);
95 
96     return c;
97   }
98 
99   
100   function div(uint256 a, uint256 b) internal pure returns (uint256) {
101     require(b > 0); 
102     uint256 c = a / b;
103     
104 
105     return c;
106   }
107 
108   
109   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110     require(b <= a);
111     uint256 c = a - b;
112 
113     return c;
114   }
115 
116   
117   function add(uint256 a, uint256 b) internal pure returns (uint256) {
118     uint256 c = a + b;
119     require(c >= a);
120 
121     return c;
122   }
123 
124   
125   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
126     require(b != 0);
127     return a % b;
128   }
129 }
130 
131 contract ERC20 is IERC20 {
132   using SafeMath for uint256;
133 
134   mapping (address => uint256) private _balances;
135 
136   mapping (address => mapping (address => uint256)) private _allowed;
137 
138   uint256 private _totalSupply;
139 
140   
141   function totalSupply() public view returns (uint256) {
142     return _totalSupply;
143   }
144 
145   
146   function balanceOf(address owner) public view returns (uint256) {
147     return _balances[owner];
148   }
149 
150   
151   function allowance(
152     address owner,
153     address spender
154    )
155     public
156     view
157     returns (uint256)
158   {
159     return _allowed[owner][spender];
160   }
161 
162   
163   function transfer(address to, uint256 value) public returns (bool) {
164     _transfer(msg.sender, to, value);
165     return true;
166   }
167 
168   
169   function approve(address spender, uint256 value) public returns (bool) {
170     require(spender != address(0));
171 
172     _allowed[msg.sender][spender] = value;
173     emit Approval(msg.sender, spender, value);
174     return true;
175   }
176 
177   
178   function transferFrom(
179     address from,
180     address to,
181     uint256 value
182   )
183     public
184     returns (bool)
185   {
186     require(value <= _allowed[from][msg.sender]);
187 
188     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
189     _transfer(from, to, value);
190     return true;
191   }
192 
193   
194   function increaseAllowance(
195     address spender,
196     uint256 addedValue
197   )
198     public
199     returns (bool)
200   {
201     require(spender != address(0));
202 
203     _allowed[msg.sender][spender] = (
204       _allowed[msg.sender][spender].add(addedValue));
205     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
206     return true;
207   }
208 
209   
210   function decreaseAllowance(
211     address spender,
212     uint256 subtractedValue
213   )
214     public
215     returns (bool)
216   {
217     require(spender != address(0));
218 
219     _allowed[msg.sender][spender] = (
220       _allowed[msg.sender][spender].sub(subtractedValue));
221     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
222     return true;
223   }
224 
225   
226   function _transfer(address from, address to, uint256 value) internal {
227     require(value <= _balances[from]);
228     require(to != address(0));
229 
230     _balances[from] = _balances[from].sub(value);
231     _balances[to] = _balances[to].add(value);
232     emit Transfer(from, to, value);
233   }
234 
235   
236   function _mint(address account, uint256 value) internal {
237     require(account != 0);
238     _totalSupply = _totalSupply.add(value);
239     _balances[account] = _balances[account].add(value);
240     emit Transfer(address(0), account, value);
241   }
242 
243   
244   function _burn(address account, uint256 value) internal {
245     require(account != 0);
246     require(value <= _balances[account]);
247 
248     _totalSupply = _totalSupply.sub(value);
249     _balances[account] = _balances[account].sub(value);
250     emit Transfer(account, address(0), value);
251   }
252 
253   
254   function _burnFrom(address account, uint256 value) internal {
255     require(value <= _allowed[account][msg.sender]);
256 
257     
258     
259     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
260       value);
261     _burn(account, value);
262   }
263 }
264 
265 contract ERC20Detailed is IERC20 {
266   string private _name;
267   string private _symbol;
268   uint8 private _decimals;
269 
270   constructor(string name, string symbol, uint8 decimals) public {
271     _name = name;
272     _symbol = symbol;
273     _decimals = decimals;
274   }
275 
276   
277   function name() public view returns(string) {
278     return _name;
279   }
280 
281   
282   function symbol() public view returns(string) {
283     return _symbol;
284   }
285 
286   
287   function decimals() public view returns(uint8) {
288     return _decimals;
289   }
290 }
291 
292 library Roles {
293   struct Role {
294     mapping (address => bool) bearer;
295   }
296 
297   
298   function add(Role storage role, address account) internal {
299     require(account != address(0));
300     require(!has(role, account));
301 
302     role.bearer[account] = true;
303   }
304 
305   
306   function remove(Role storage role, address account) internal {
307     require(account != address(0));
308     require(has(role, account));
309 
310     role.bearer[account] = false;
311   }
312 
313   
314   function has(Role storage role, address account)
315     internal
316     view
317     returns (bool)
318   {
319     require(account != address(0));
320     return role.bearer[account];
321   }
322 }
323 
324 contract MinterRole {
325   using Roles for Roles.Role;
326 
327   event MinterAdded(address indexed account);
328   event MinterRemoved(address indexed account);
329 
330   Roles.Role private minters;
331 
332   constructor() internal {
333     _addMinter(msg.sender);
334   }
335 
336   modifier onlyMinter() {
337     require(isMinter(msg.sender));
338     _;
339   }
340 
341   function isMinter(address account) public view returns (bool) {
342     return minters.has(account);
343   }
344 
345   function addMinter(address account) public onlyMinter {
346     _addMinter(account);
347   }
348 
349   function renounceMinter() public {
350     _removeMinter(msg.sender);
351   }
352 
353   function _addMinter(address account) internal {
354     minters.add(account);
355     emit MinterAdded(account);
356   }
357 
358   function _removeMinter(address account) internal {
359     minters.remove(account);
360     emit MinterRemoved(account);
361   }
362 }
363 
364 contract ERC20Mintable is ERC20, MinterRole {
365   
366   function mint(
367     address to,
368     uint256 value
369   )
370     public
371     onlyMinter
372     returns (bool)
373   {
374     _mint(to, value);
375     return true;
376   }
377 }
378 
379 contract JupiterCoin is ERC20, ERC20Detailed, ERC20Mintable, Ownable{
380 
381   constructor(
382     string name,
383     string symbol,
384     uint8 decimals
385   )
386   public
387   ERC20Mintable()
388   ERC20Detailed(name, symbol, decimals)
389   ERC20() {
390   }
391 
392   
393   function mint(
394     address to,
395     uint256 value
396   )
397     public
398     onlyMinter
399     returns (bool)
400   {
401     
402     require(totalSupply() + value <= 100000000000000000000000000, "TOTAL_SUPPLY_EXCEEDED");
403     return ERC20Mintable.mint(to, value);
404   }
405 
406   
407   struct PledgeRecord {
408     address user;
409     uint256 tokens;
410   }
411 
412   
413   mapping(string => PledgeRecord) private orderPledge;
414 
415   
416   mapping(string => bool) orderIndex;
417 
418   
419   event Pledge_Succeeded(
420     address pledger,
421     string order,
422     uint256 tokens
423   );
424 
425   
426   event Refund_Succeeded(
427     address pledger,
428     string order
429   );
430 
431   
432   
433   
434   function pledge(string order, uint256 tokens) external {
435     require(!isOwner(), "INVALID_MSG_SENDER");
436     require(orderIndex[order] != true, "EXISTING_ORDER");
437     require(balanceOf(msg.sender) >= tokens, "NOT_ENOUGH_BALANCE");
438     require(transfer(owner(), tokens), "TRANSFER_FAILED");
439     emit Pledge_Succeeded(msg.sender, order, tokens);
440     orderPledge[order] = PledgeRecord(msg.sender, tokens);
441     orderIndex[order] = true;
442   }
443 
444   
445   
446   
447   function refund(string order, uint256 tokens) external onlyOwner {
448     require(orderIndex[order] == true, "INVALID_ORDER");
449 
450     PledgeRecord memory pledgeRecord = orderPledge[order];
451     address user = pledgeRecord.user;
452     uint256 amount = pledgeRecord.tokens;
453 
454     require((amount + amount) >= tokens, "NOT_CORRECT_PLEDGE");
455     require(balanceOf(msg.sender) >= amount, "NOT_ENOUGH_TOKENS");
456     require(transfer(user, amount), "TRANSFER_FAILED");
457     emit Refund_Succeeded(user, order);
458     delete orderPledge[order];
459     delete orderIndex[order];
460   }
461 
462   
463   
464   function isPledged(string order) public view returns (bool) {
465     return orderIndex[order];
466   }
467 
468   
469   
470   function pledgeRecord(string order) public view 
471     returns (address pledger, uint256 tokens) {
472     PledgeRecord memory p = orderPledge[order];
473     return (p.user, p.tokens);
474   }
475 
476   
477   struct TokenOrder {
478     address seller;
479     address buyer;
480     uint256 tokens;
481   }
482 
483   
484   mapping(uint32 => TokenOrder) private tokenOrder;
485 
486   
487   mapping(uint32 => bool) private tokenOrderIndex; 
488 
489   
490   event Transfer_Succeeded(
491     uint32 tokenOrderId,
492     address seller,
493     address buyer,
494     uint256 tokens
495   );
496 
497   
498   event Cancel_Succeeded(
499     uint32 tokenOrderId,
500     address seller
501   );
502 
503   
504   event Sell_Succeeded(
505     uint32 tokenOrderId,
506     address seller,
507     address buyer
508   );
509   
510   
511   
512   
513   
514   function transferForSale(uint32 tokenOrderId, address buyer, uint256 tokens) external {
515     require(!isOwner(), "INVALID_ADDRESS");
516     require(tokenOrderIndex[tokenOrderId] != true, "EXISTING_TOKEN_ORDER");
517     require(balanceOf(msg.sender) >= tokens, "NOT_ENOUGH_BALANCE");
518 
519     require(transfer(owner(), tokens), "TRANSFER_FAILED");
520     emit Transfer_Succeeded(tokenOrderId, msg.sender, buyer, tokens);
521     tokenOrder[tokenOrderId] = TokenOrder(msg.sender, buyer, tokens);
522     tokenOrderIndex[tokenOrderId] = true;
523   }
524 
525   
526   
527   function cancelForUser(uint32 tokenOrderId) external onlyOwner {
528     require(tokenOrderIndex[tokenOrderId] == true, "INVALID_TOKEN_ORDER");
529 
530     TokenOrder memory order = tokenOrder[tokenOrderId];
531     uint256 amount = order.tokens;
532     address seller = order.seller;
533     
534     require(balanceOf(msg.sender) >= amount, "NOT_ENOUGH_TOKENS");
535     require(transfer(seller, amount), "TRANSFER_FAILED");
536     emit Cancel_Succeeded(tokenOrderId, seller);
537     delete tokenOrder[tokenOrderId];
538     delete tokenOrderIndex[tokenOrderId];
539   }
540 
541   
542   
543   function sellForUser(uint32 tokenOrderId) external onlyOwner {
544     require(tokenOrderIndex[tokenOrderId] == true, "INVALID_TOKEN_ORDER");
545 
546     TokenOrder memory order = tokenOrder[tokenOrderId];
547     uint256 amount = order.tokens;
548     address seller = order.seller;
549     address buyer = order.buyer;
550     
551     require(balanceOf(msg.sender) >= amount, "NOT_ENOUGH_TOKENS");
552     require(transfer(buyer, amount), "TRANSFER_FAILED");
553     emit Sell_Succeeded(tokenOrderId, seller, buyer);
554     delete tokenOrder[tokenOrderId];
555     delete tokenOrderIndex[tokenOrderId];
556   }
557 
558   
559   
560   function isTransferred(uint32 tokenOrderId) public view returns (bool) {
561     return tokenOrderIndex[tokenOrderId];
562   }
563 
564   
565   
566   function tokenOrderInfo(uint32 tokenOrderId) public view 
567     returns (address seller, address buyer, uint256 tokens) {
568     TokenOrder memory t = tokenOrder[tokenOrderId];
569     return (t.seller, t.buyer, t.tokens);
570   }
571 
572 }