1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     require(c / a == b);
11     return c;
12   }
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     require(b > 0); 
15     uint256 c = a / b;
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     require(b <= a);
20     uint256 c = a - b;
21     return c;
22   }
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     require(c >= a);
26     return c;
27   }
28   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
29     require(b != 0);
30     return a % b;
31   }
32 }
33 
34 library Roles {
35     
36   struct Role {
37     mapping (address => bool) bearer;
38   }
39   function add(Role storage role, address account) internal {
40     require(account != address(0));
41     require(!has(role, account));
42     role.bearer[account] = true;
43   }
44   function remove(Role storage role, address account) internal {
45     require(account != address(0));
46     require(has(role, account));
47     role.bearer[account] = false;
48   }
49   function has(Role storage role, address account) internal view returns (bool) {
50     require(account != address(0));
51     return role.bearer[account];
52   }
53 }
54 
55 contract Ownable {
56 
57   address private _owner;
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59   constructor() internal {
60     _owner = msg.sender;
61     emit OwnershipTransferred(address(0), _owner);
62   }
63   function owner() public view returns(address) {
64     return _owner;
65   }
66   modifier onlyOwner() {
67     require(isOwner());
68     _;
69   }
70   function isOwner() public view returns(bool) {
71     return msg.sender == _owner;
72   }
73   function renounceOwnership() public onlyOwner {
74     emit OwnershipTransferred(_owner, address(0));
75     _owner = address(0);
76   }
77   function transferOwnership(address newOwner) public onlyOwner {
78     _transferOwnership(newOwner);
79   }
80   function _transferOwnership(address newOwner) internal {
81     require(newOwner != address(0));
82     emit OwnershipTransferred(_owner, newOwner);
83     _owner = newOwner;
84   }
85 }
86 
87 contract ERC223ReceivingContract {
88 
89     function tokenFallback(address _from, uint256 _value, bytes _data) public;
90 }
91 
92 interface IERC20 {
93     
94   function totalSupply() external view returns (uint256);
95   function balanceOf(address who) external view returns (uint256);
96   function allowance(address owner, address spender) external view returns (uint256);
97   function transfer(address to, uint256 value) external returns (bool);
98   function approve(address spender, uint256 value) external returns (bool);
99   function transferFrom(address from, address to, uint256 value) external returns (bool);
100   //event Transfer(address indexed from, address indexed to, uint256 value);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 
103   //ERC223
104   function transfer(address to, uint256 value, bytes data) external returns (bool success);
105   event Transfer(address indexed from, address indexed to, uint256 value);
106 }
107 
108 contract ERC20 is IERC20, Ownable {
109     
110   using SafeMath for uint256;
111   mapping (address => uint256) private _balances;
112   mapping (address => mapping (address => uint256)) private _allowed;
113   mapping (address => bool) public frozenAccount;
114   event frozenFunds(address account, bool freeze);
115   uint256 private _totalSupply;
116   function totalSupply() public view returns (uint256) {
117     return _totalSupply;
118   }
119   function balanceOf(address owner) public view returns (uint256) {
120     return _balances[owner];
121   }
122   function allowance(address owner, address spender) public view returns (uint256) {
123     return _allowed[owner][spender];
124   }
125   function transfer(address to, uint256 value) public returns (bool) {
126     _transfer(msg.sender, to, value);
127     return true;
128   }
129   function transfer(address to, uint256 value, bytes data) external returns (bool) {
130     require(transfer(to, value));
131 
132    uint codeLength;
133 
134    assembly {
135     // Retrieve the size of the code on target address, this needs assembly.
136     codeLength := extcodesize(to)
137   }
138 
139   if (codeLength > 0) {
140     ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
141     receiver.tokenFallback(msg.sender, value, data);
142     }
143   return true;
144   }
145   function approve(address spender, uint256 value) public returns (bool) {
146     require(spender != address(0));
147     _allowed[msg.sender][spender] = value;
148     emit Approval(msg.sender, spender, value);
149     return true;
150   }
151   function transferFrom(address from, address to, uint256 value) public returns (bool) {
152     require(value <= _allowed[from][msg.sender]);
153     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
154     _transfer(from, to, value);
155     return true;
156   }
157   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
158     require(spender != address(0));
159     _allowed[msg.sender][spender] = (
160       _allowed[msg.sender][spender].add(addedValue));
161     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
162     return true;
163   }
164   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
165     require(spender != address(0));
166     _allowed[msg.sender][spender] = (
167       _allowed[msg.sender][spender].sub(subtractedValue));
168     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
169     return true;
170   }
171   function _transfer(address from, address to, uint256 value) internal {
172     require(value <= _balances[from]);
173     require(to != address(0));
174     _balances[from] = _balances[from].sub(value);
175     _balances[to] = _balances[to].add(value);
176     emit Transfer(from, to, value);
177    require(!frozenAccount[msg.sender]);
178   }
179   function _mint(address account, uint256 value) internal {
180     require(account != 0);
181     _totalSupply = _totalSupply.add(value);
182     _balances[account] = _balances[account].add(value);
183     emit Transfer(address(0), account, value);
184   }
185   function _burn(address account, uint256 value) internal {
186     require(account != 0);
187     require(value <= _balances[account]);
188     _totalSupply = _totalSupply.sub(value);
189     _balances[account] = _balances[account].sub(value);
190     emit Transfer(account, address(0), value);
191   }
192   function _burnFrom(address account, uint256 value) internal {
193     require(value <= _allowed[account][msg.sender]);
194     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
195     _burn(account, value);
196   }
197 }
198 
199 contract PauserRole {
200     
201   using Roles for Roles.Role;
202   event PauserAdded(address indexed account);
203   event PauserRemoved(address indexed account);
204   Roles.Role private pausers;
205   constructor() internal {
206     _addPauser(msg.sender);
207   }
208   modifier onlyPauser() {
209     require(isPauser(msg.sender));
210     _;
211   }
212   function isPauser(address account) public view returns (bool) {
213     return pausers.has(account);
214   }
215   function addPauser(address account) public onlyPauser {
216     _addPauser(account);
217   }
218   function renouncePauser() public {
219     _removePauser(msg.sender);
220   }
221   function _addPauser(address account) internal {
222     pausers.add(account);
223     emit PauserAdded(account);
224   }
225   function _removePauser(address account) internal {
226     pausers.remove(account);
227     emit PauserRemoved(account);
228   }
229 }
230 
231 contract Pausable is PauserRole {
232     
233   event Paused(address account);
234   event Unpaused(address account);
235   bool private _paused;
236   constructor() internal {
237     _paused = false;
238   }
239   function paused() public view returns(bool) {
240     return _paused;
241   }
242   modifier whenNotPaused() {
243     require(!_paused);
244     _;
245   }
246   modifier whenPaused() {
247     require(_paused);
248     _;
249   }
250   function pause() public onlyPauser whenNotPaused {
251     _paused = true;
252     emit Paused(msg.sender);
253   }
254   function unpause() public onlyPauser whenPaused {
255     _paused = false;
256     emit Unpaused(msg.sender);
257   }
258 }
259 
260 contract MinterRole {
261     
262   using Roles for Roles.Role;
263   event MinterAdded(address indexed account);
264   event MinterRemoved(address indexed account);
265   Roles.Role private minters;
266   constructor() internal {
267     _addMinter(msg.sender);
268   }
269   modifier onlyMinter() {
270     require(isMinter(msg.sender));
271     _;
272   }
273   function isMinter(address account) public view returns (bool) {
274     return minters.has(account);
275   }
276   function addMinter(address account) public onlyMinter {
277     _addMinter(account);
278   }
279   function renounceMinter() public {
280     _removeMinter(msg.sender);
281   }
282   function _addMinter(address account) internal {
283     minters.add(account);
284     emit MinterAdded(account);
285   }
286   function _removeMinter(address account) internal {
287     minters.remove(account);
288     emit MinterRemoved(account);
289   }
290 }
291 
292 contract ERC20Mintable is ERC20, MinterRole {
293 
294   uint256 private _maxSupply = 1000000000000000000000000001;
295   uint256 private _totalSupply;
296   function maxSupply() public view returns (uint256) {
297     return _maxSupply;
298   }
299   function mint(address to, uint256 value) public onlyMinter returns (bool) {
300     require(_maxSupply > totalSupply().add(value));
301     _mint(to, value);
302     return true;        
303   }
304 }
305 
306 contract ERC20Burnable is ERC20 {
307 
308   function burn(uint256 value) public {
309     _burn(msg.sender, value);
310   }
311   function burnFrom(address from, uint256 value) public {
312     _burnFrom(from, value);
313   }
314 }
315 
316 contract ERC20Pausable is ERC20, Pausable {
317 
318   function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
319     return super.transfer(to, value);
320   }
321   function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
322     return super.transferFrom(from, to, value);
323   }
324   function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
325     return super.approve(spender, value);
326   }
327   function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
328     return super.increaseAllowance(spender, addedValue);
329   }
330   function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
331     return super.decreaseAllowance(spender, subtractedValue);
332   }
333 }
334 
335 library SafeERC20 {
336 
337   using SafeMath for uint256;
338   function safeTransfer(IERC20 token, address to, uint256 value) internal {
339     require(token.transfer(to, value));
340   }
341   function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
342     require(token.transferFrom(from, to, value));
343   }
344   function safeApprove(IERC20 token, address spender, uint256 value) internal {
345     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
346     require(token.approve(spender, value));
347   }
348   function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
349     uint256 newAllowance = token.allowance(address(this), spender).add(value);
350     require(token.approve(spender, newAllowance));
351   }
352   function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
353     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
354     require(token.approve(spender, newAllowance));
355   }
356 }
357 
358 contract ERC20Frozen is ERC20 {
359     
360   function freezeAccount (address target, bool freeze) onlyOwner public {
361     frozenAccount[target]=freeze;
362     emit frozenFunds(target, freeze);
363   }
364 }
365 
366 contract OneKiloGifttoken is ERC20Mintable, ERC20Burnable, ERC20Pausable, ERC20Frozen {
367 
368   string public constant name = "OneKiloGifttoken";
369   string public constant symbol = "1KG";
370   uint8 public constant decimals = 18;
371   uint256 public constant INITIAL_SUPPLY = 10000000 * (10 ** uint256(decimals));
372   
373   constructor() public {
374     _mint(msg.sender, INITIAL_SUPPLY);
375     
376   }
377 }
378 
379 /*
380 
381 상품권 표준약관
382 
383 제1조 (목적) 이 약관은 주식회사 칼랩 (이하 ‘발행자’라 함. 주소: 서울시 중구 창경궁로 18-1, 606)이 발행한 상품권을 
384 구매자 또는 구매자로부터 이전 받은 자(이하 ‘고객’ 이라 함)가 사용함에 있어 고객과 발행자 또는 발행자와 가맹계약을 
385 맺은 자 (이하, ‘가맹점’이라 함) 등 발행자가 지정한 자(이하, ‘발행자 등’이라 함) 간에 준수할 사항을 규정한다. 
386 
387 제2조 (상품권의 정의 등)
388 정액 형 선불전자지급수단으로서 유효기간 내에 잔액 범위 내에서 사용 횟수에 제한없이 자유롭게 상품 등을 제공 받을 수 
389 있는 상품권으로 정의한다.
390 
391 제3조 (발행 등)
392 1. 발행자는 상품권의 발행 시 소요되는 제반 비용 등을 부담한다.
393 2. 발행자 : 주식회사 칼랩 
394 3. 구매 수량 및 구매가격 : 정액 형 전자 유형 상품권 단위당 1,000원
395 
396 제4조 (상품권의 사용)
397 1 .고객이 유효기간 내에 상품권의 금액 또는 수량의 범위 내에서 물품 등의 제공을 요구하는 경우 
398 발행자 등은 즉시 해당 물품을 제공한다. 
399 2 .고객은 발행자 등에서 판매하는 물품 등에 대하여 가격할인기간을 포함하여 언제든지 상품권을 사용할 수 있다. 
400 3 .발행자가 발행한 상품권의 경우, 잔액 범위 내에서 사용 횟수에 제한 없이 사용가능하며 사용시 사용금액만큼 차감된다. 
401 
402 제5조 (환불) 고객은 상품권의 구매일로부터 7일 이내에 구매액 전부를 환불 받을 수 있다. 
403 
404 제6조 (소멸시효) 상품권 소멸시효는 발행 후 10년이다. 소멸시효가 지나도 10년이 경과 되기 전에는 소유자의 청구 잔액
405 모두를 지급한다.
406 
407 제7조 (지급보증 등) 상품권 발행자는 상품권의 지급보증 또는 피해보상보험계약(이하 “지급보증 등”이라 함)을 한다. 
408 
409 제8조 (발행자의 책임) 1. 상품권의 이용과 관련된 고객의 권리에 대한 최종적 책임은 발행자가 진다. 
410 
411 2 데이터의 위조 또는 변조 등으로 고객에게 피해가 발생한 경우, 발행자는 고객의 피해에 대해서 손해를 배상한다. 
412 다만, 발행자가 사용자의 관리소홀 등의 책임을 입증하거나 천재지변 등 불가항력적인 사유로 인한 것임을 입증한 경우에는 
413 그러하지 아니하다. 
414 
415 제9조 (분쟁해결) 이 약관과 관련하여 발행자 등과 고객 사이에 발생한 분쟁에 관한 소송은 서울중앙지방법원에 제기한다. 
416 
417 제10조 (기타) 이 약관에 명시되지 않은 사항 또는 약관 해석상 다툼이 있는 경우에는 고객과 발행자 등의 합의 의하여 결정한다. 
418 다만, 합의가 이루어지지 않은 경우에는「약관의 규제에 관한 법률」등 관계법령 및 거래관행에 따른다. 
419 
420 
421 Terms and Conditions 
422 
423 Article 1 (Purpose)
424 These Terms and Conditions shall be governed by the terms and conditions of the Gift Certificate issued by CALLAB Corp. 
425 (hereinafter referred to as "Issuer")  The Terms and Conditions pertains to the buyer (hereinafter referred to as "Customer") 
426 of the Gift Certificate, the customer, issuer, or those that have made a franchise agreement with the issuer 
427 (Hereinafter referred to as "Franchise").
428 
429 Article 2 (Definition of Gift Certificate)
430 Non-cumulative (meaning that it can be charged from time to time, hereinafter referred to as the 'charge type') 
431 Or prepaid electronic payment meaning that as a flat-rate prepaid electronic payment valid within a set period of 
432 time is defined as a gift certificate that can be used in exchange for goods.
433 
434 Article 3 (Issuance) 
435 1. The issuer shall bear all expenses incurred in issuing the gift certificate.
436 2. Issuer: CALLAB Co., Ltd.
437 3. Purchase quantity and purchase price: Prepaid electronic type gift certificate 1,000 KRW per unit.
438 
439 Article 4 (Use of Gift Certificates)
440 1. Within the validity period, the customer shall not be responsible for the supply of goods. 
441 If requested, the issuer, etc. will immediately provide the goods.
442 2. Gift certificates may be used on any product during the valid time frame including those that are one sale.
443 3. In the case of gift certificates issued the the issuer, there is no limitation to the number of usages within 
444 the range of the balance. The amount will be deducted from the total once used.
445 
446 Article 5 (Refund)
447 1. Customer will be entitled to a full refund within 7 days of the gift certificate purchase.
448 
449 Article 6 (Extinctive Prescription)
450 There is no extinctive prescription of the gift certificate.
451 
452 Article 7 (Payment Guarantee) 
453 The issuer of the gift certificate is obliged to provide the payment guarantee of the gift certificate or damage compensation 
454 insurance contract (hereinafter referred to as "Payment Guarantee”).
455 
456 Article 8 (Responsibility of the Issuer) 
457 1. The ultimate responsibility for the customer's rights in relation to the use of the gift certificate shall be borne 
458 by the issuer.
459 2 If damage is caused to the customer by forgery or alteration of data, the issuer will compensate for the damage. 
460 However, if the issuer proves the liability of the user including those caused outside the control of the issuer such as 
461 natural disasters, the issuer does not need to compensate for it. 
462 
463 Article 9 (Settlement of Disputes)
464 In relation to this Agreement, all lawsuits relating to disputes between the issuer and the customer will be submitted 
465 to the Seoul Central District Court.
466 
467 Article 10 (Other)
468 If there are any disagreements in the interpretation of the terms or conditions not specified in these Terms and Conditions, 
469 it shall be decided by reaching an agreement between both the customer and the issuer. However, if no agreement is reached, 
470 related laws will govern the outcome.
471 
472 */