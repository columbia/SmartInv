1 pragma solidity ^0.5.0;
2 
3 contract Context {
4     constructor () internal { }
5 
6     function _msgSender() internal view returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view returns (bytes memory) {
11         this;
12         return msg.data;
13     }
14 }
15 
16 contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor () internal {
22         address msgSender = _msgSender();
23         _owner = msgSender;
24         emit OwnershipTransferred(address(0), msgSender);
25     }
26 
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     modifier onlyOwner() {
32         require(isOwner(), "Ownable: caller is not the owner");
33         _;
34     }
35 
36     function isOwner() public view returns (bool) {
37         return _msgSender() == _owner;
38     }
39 
40     function renounceOwnership() public onlyOwner {
41         emit OwnershipTransferred(_owner, address(0));
42         _owner = address(0);
43     }
44 
45     function transferOwnership(address newOwner) public onlyOwner {
46         _transferOwnership(newOwner);
47     }
48 
49     function _transferOwnership(address newOwner) internal {
50         require(newOwner != address(0), "Ownable: new owner is the zero address");
51         emit OwnershipTransferred(_owner, newOwner);
52         _owner = newOwner;
53     }
54 }
55 
56 interface IERC777 {
57     function name() external view returns (string memory);
58 
59     function symbol() external view returns (string memory);
60 
61     function granularity() external view returns (uint256);
62 
63     function totalSupply() external view returns (uint256);
64 
65     function balanceOf(address owner) external view returns (uint256);
66 
67     function send(address recipient, uint256 amount, bytes calldata data) external;
68 
69     function burn(uint256 amount, bytes calldata data) external;
70 
71     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
72 
73     function authorizeOperator(address operator) external;
74 
75     function revokeOperator(address operator) external;
76 
77     function defaultOperators() external view returns (address[] memory);
78 
79     function operatorSend(
80         address sender,
81         address recipient,
82         uint256 amount,
83         bytes calldata data,
84         bytes calldata operatorData
85     ) external;
86 
87     function operatorBurn(
88         address account,
89         uint256 amount,
90         bytes calldata data,
91         bytes calldata operatorData
92     ) external;
93 
94     event Sent(
95         address indexed operator,
96         address indexed from,
97         address indexed to,
98         uint256 amount,
99         bytes data,
100         bytes operatorData
101     );
102 
103     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
104 
105     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
106 
107     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
108 
109     event RevokedOperator(address indexed operator, address indexed tokenHolder);
110 }
111 
112 interface IERC777Recipient {
113     function tokensReceived(
114         address operator,
115         address from,
116         address to,
117         uint256 amount,
118         bytes calldata userData,
119         bytes calldata operatorData
120     ) external;
121 }
122 
123 interface IERC777Sender {
124     function tokensToSend(
125         address operator,
126         address from,
127         address to,
128         uint256 amount,
129         bytes calldata userData,
130         bytes calldata operatorData
131     ) external;
132 }
133 
134 interface IERC20 {
135     function totalSupply() external view returns (uint256);
136 
137     function balanceOf(address account) external view returns (uint256);
138 
139     function transfer(address recipient, uint256 amount) external returns (bool);
140 
141     function allowance(address owner, address spender) external view returns (uint256);
142 
143     function approve(address spender, uint256 amount) external returns (bool);
144 
145     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
146 
147     event Transfer(address indexed from, address indexed to, uint256 value);
148 
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 library SafeMath {
153     function add(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a + b;
155         require(c >= a, "SafeMath: addition overflow");
156 
157         return c;
158     }
159 
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         return sub(a, b, "SafeMath: subtraction overflow");
162     }
163 
164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172         if (a == 0) {
173             return 0;
174         }
175 
176         uint256 c = a * b;
177         require(c / a == b, "SafeMath: multiplication overflow");
178 
179         return c;
180     }
181 
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         return div(a, b, "SafeMath: division by zero");
184     }
185 
186     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b > 0, errorMessage);
188         uint256 c = a / b;
189 
190         return c;
191     }
192 
193     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
194         return mod(a, b, "SafeMath: modulo by zero");
195     }
196 
197     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b != 0, errorMessage);
199         return a % b;
200     }
201 }
202 
203 library Address {
204     function isContract(address account) internal view returns (bool) {
205         bytes32 codehash;
206         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
207         assembly { codehash := extcodehash(account) }
208         return (codehash != accountHash && codehash != 0x0);
209     }
210 
211     function toPayable(address account) internal pure returns (address payable) {
212         return address(uint160(account));
213     }
214 
215     function sendValue(address payable recipient, uint256 amount) internal {
216         require(address(this).balance >= amount, "Address: insufficient balance");
217 
218         (bool success, ) = recipient.call.value(amount)("");
219         require(success, "Address: unable to send value, recipient may have reverted");
220     }
221 }
222 
223 interface IERC1820Registry {
224     function setManager(address account, address newManager) external;
225 
226     function getManager(address account) external view returns (address);
227 
228     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
229 
230     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
231 
232     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
233 
234     function updateERC165Cache(address account, bytes4 interfaceId) external;
235 
236     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
237 
238     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
239 
240     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
241 
242     event ManagerChanged(address indexed account, address indexed newManager);
243 }
244 
245 contract ERC777 is Context, IERC777, IERC20 {
246     using SafeMath for uint256;
247     using Address for address;
248 
249     IERC1820Registry constant internal ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
250 
251     mapping(address => uint256) private _balances;
252 
253     uint256 private _totalSupply;
254 
255     string private _name;
256     string private _symbol;
257 
258     bytes32 constant private TOKENS_SENDER_INTERFACE_HASH =
259         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
260 
261     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
262         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
263 
264     address[] private _defaultOperatorsArray;
265 
266     mapping(address => bool) private _defaultOperators;
267 
268     mapping(address => mapping(address => bool)) private _operators;
269     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
270 
271     mapping (address => mapping (address => uint256)) private _allowances;
272 
273     constructor(
274         string memory name,
275         string memory symbol,
276         address[] memory defaultOperators
277     ) public {
278         _name = name;
279         _symbol = symbol;
280 
281         _defaultOperatorsArray = defaultOperators;
282         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
283             _defaultOperators[_defaultOperatorsArray[i]] = true;
284         }
285 
286         ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
287         ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
288     }
289 
290     function name() public view returns (string memory) {
291         return _name;
292     }
293 
294     function symbol() public view returns (string memory) {
295         return _symbol;
296     }
297 
298     function decimals() public pure returns (uint8) {
299         return 18;
300     }
301 
302     function granularity() public view returns (uint256) {
303         return 1;
304     }
305 
306     function totalSupply() public view returns (uint256) {
307         return _totalSupply;
308     }
309 
310     function balanceOf(address tokenHolder) public view returns (uint256) {
311         return _balances[tokenHolder];
312     }
313 
314     function send(address recipient, uint256 amount, bytes memory data) public {
315         _send(_msgSender(), _msgSender(), recipient, amount, data, "", true);
316     }
317 
318     function transfer(address recipient, uint256 amount) public returns (bool) {
319         require(recipient != address(0), "ERC777: transfer to the zero address");
320 
321         address from = _msgSender();
322 
323         _callTokensToSend(from, from, recipient, amount, "", "");
324 
325         _move(from, from, recipient, amount, "", "");
326 
327         _callTokensReceived(from, from, recipient, amount, "", "", false);
328 
329         return true;
330     }
331 
332     function burn(uint256 amount, bytes memory data) public {
333         _burn(_msgSender(), _msgSender(), amount, data, "");
334     }
335 
336     function isOperatorFor(
337         address operator,
338         address tokenHolder
339     ) public view returns (bool) {
340         return operator == tokenHolder ||
341             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
342             _operators[tokenHolder][operator];
343     }
344 
345     function authorizeOperator(address operator) public {
346         require(_msgSender() != operator, "ERC777: authorizing self as operator");
347 
348         if (_defaultOperators[operator]) {
349             delete _revokedDefaultOperators[_msgSender()][operator];
350         } else {
351             _operators[_msgSender()][operator] = true;
352         }
353 
354         emit AuthorizedOperator(operator, _msgSender());
355     }
356 
357     function revokeOperator(address operator) public {
358         require(operator != _msgSender(), "ERC777: revoking self as operator");
359 
360         if (_defaultOperators[operator]) {
361             _revokedDefaultOperators[_msgSender()][operator] = true;
362         } else {
363             delete _operators[_msgSender()][operator];
364         }
365 
366         emit RevokedOperator(operator, _msgSender());
367     }
368 
369     function defaultOperators() public view returns (address[] memory) {
370         return _defaultOperatorsArray;
371     }
372 
373     function operatorSend(
374         address sender,
375         address recipient,
376         uint256 amount,
377         bytes memory data,
378         bytes memory operatorData
379     )
380     public
381     {
382         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
383         _send(_msgSender(), sender, recipient, amount, data, operatorData, true);
384     }
385 
386     function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public {
387         require(isOperatorFor(_msgSender(), account), "ERC777: caller is not an operator for holder");
388         _burn(_msgSender(), account, amount, data, operatorData);
389     }
390 
391     function allowance(address holder, address spender) public view returns (uint256) {
392         return _allowances[holder][spender];
393     }
394 
395     function approve(address spender, uint256 value) public returns (bool) {
396         address holder = _msgSender();
397         _approve(holder, spender, value);
398         return true;
399     }
400 
401     function transferFrom(address holder, address recipient, uint256 amount) public returns (bool) {
402         require(recipient != address(0), "ERC777: transfer to the zero address");
403         require(holder != address(0), "ERC777: transfer from the zero address");
404 
405         address spender = _msgSender();
406 
407         _callTokensToSend(spender, holder, recipient, amount, "", "");
408 
409         _move(spender, holder, recipient, amount, "", "");
410         _approve(holder, spender, _allowances[holder][spender].sub(amount, "ERC777: transfer amount exceeds allowance"));
411 
412         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
413 
414         return true;
415     }
416 
417     function _mint(
418         address operator,
419         address account,
420         uint256 amount,
421         bytes memory userData,
422         bytes memory operatorData
423     )
424     internal
425     {
426         require(account != address(0), "ERC777: mint to the zero address");
427 
428         _totalSupply = _totalSupply.add(amount);
429         _balances[account] = _balances[account].add(amount);
430 
431         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
432 
433         emit Minted(operator, account, amount, userData, operatorData);
434         emit Transfer(address(0), account, amount);
435     }
436 
437     function _send(
438         address operator,
439         address from,
440         address to,
441         uint256 amount,
442         bytes memory userData,
443         bytes memory operatorData,
444         bool requireReceptionAck
445     )
446         internal
447     {
448         require(from != address(0), "ERC777: send from the zero address");
449         require(to != address(0), "ERC777: send to the zero address");
450 
451         _callTokensToSend(operator, from, to, amount, userData, operatorData);
452 
453         _move(operator, from, to, amount, userData, operatorData);
454 
455         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
456     }
457 
458     function _burn(
459         address operator,
460         address from,
461         uint256 amount,
462         bytes memory data,
463         bytes memory operatorData
464     )
465         internal
466     {
467         require(from != address(0), "ERC777: burn from the zero address");
468 
469         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
470 
471         _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
472         _totalSupply = _totalSupply.sub(amount);
473 
474         emit Burned(operator, from, amount, data, operatorData);
475         emit Transfer(from, address(0), amount);
476     }
477 
478     function _move(
479         address operator,
480         address from,
481         address to,
482         uint256 amount,
483         bytes memory userData,
484         bytes memory operatorData
485     )
486         private
487     {
488         _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
489         _balances[to] = _balances[to].add(amount);
490 
491         emit Sent(operator, from, to, amount, userData, operatorData);
492         emit Transfer(from, to, amount);
493     }
494 
495     function _approve(address holder, address spender, uint256 value) internal {
496         require(spender != address(0), "ERC777: approve to the zero address");
497 
498         _allowances[holder][spender] = value;
499         emit Approval(holder, spender, value);
500     }
501 
502     function _callTokensToSend(
503         address operator,
504         address from,
505         address to,
506         uint256 amount,
507         bytes memory userData,
508         bytes memory operatorData
509     )
510         internal
511     {
512         address implementer = ERC1820_REGISTRY.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
513         if (implementer != address(0)) {
514             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
515         }
516     }
517 
518     function _callTokensReceived(
519         address operator,
520         address from,
521         address to,
522         uint256 amount,
523         bytes memory userData,
524         bytes memory operatorData,
525         bool requireReceptionAck
526     )
527         internal
528     {
529         address implementer = ERC1820_REGISTRY.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
530         if (implementer != address(0)) {
531             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
532         } else if (requireReceptionAck) {
533             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
534         }
535     }
536 }
537 
538 contract SmartexToken is ERC777, Ownable {
539   bool private _transferable = false;
540 
541   mapping (address => bool) public authorizedAccounts;
542   mapping (address => bool) public minters;
543 
544   modifier onlyMinter() {
545     require(_msgSender() == owner() || minters[_msgSender()], "SmartexToken: caller is not a minter");
546     _;
547   }
548 
549   constructor() public ERC777("SmartexToken", "SRX", new address[](0)) {
550     _mint(address(0), _msgSender(), 1000000 * (10 ** uint256(decimals())), '', '');
551   }
552 
553   function setTransferable(bool transferable) public onlyOwner {
554     _transferable = transferable;
555   }
556 
557   function transferable() public view returns (bool) {
558     return _transferable;
559   }
560 
561   function setAuthorization(address account, bool allowed) public onlyOwner {
562     authorizedAccounts[account] = allowed;
563   }
564 
565   function setMinter(address minter, bool allowed) public onlyOwner {
566     minters[minter] = allowed;
567   }
568 
569   function mint(address account, uint256 amount, bytes memory data) public onlyMinter {
570     _mint(_msgSender(), account, amount, data, '');
571   }
572 
573   function send(address recipient, uint256 amount, bytes memory data) public {
574     require(
575       _transferable ||
576       _isAuthorizedAccount(_msgSender()) ||
577       _isAuthorizedAccount(recipient),
578       "Send: sender/recipient is not authorized"
579     );
580 
581     super.send(recipient, amount, data);
582   }
583 
584   function transfer(address recipient, uint256 amount) public returns (bool) {
585     require(
586       _transferable ||
587       _isAuthorizedAccount(_msgSender()) ||
588       _isAuthorizedAccount(recipient),
589       "Transfer: sender/recipient is not authorized"
590     );
591 
592     return super.transfer(recipient, amount);
593   }
594 
595   function burn(uint256 amount, bytes memory data) public  {
596     require(
597       _transferable ||
598       _isAuthorizedAccount(_msgSender()),
599       "Burn: sender is not authorized"
600     );
601 
602     super.burn(amount, data);
603   }
604 
605   function operatorSend(address sender, address recipient, uint256 amount, bytes memory data, bytes memory operatorData) public {
606     require(
607       _transferable ||
608       _isAuthorizedAccount(_msgSender()) ||
609       _isAuthorizedAccount(sender) ||
610       _isAuthorizedAccount(recipient),
611       "OperatorSend: sender/recipient is not authorized"
612     );
613 
614     super.operatorSend(sender, recipient, amount, data, operatorData);
615   }
616 
617   function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public {
618     require(
619       _transferable ||
620       _isAuthorizedAccount(_msgSender()) ||
621       _isAuthorizedAccount(account),
622       "OperatorBurn: sender is not authorized"
623     );
624 
625     super.operatorBurn(account, amount, data, operatorData);
626   }
627 
628   function transferFrom(address holder, address recipient, uint256 amount) public returns (bool) {
629     require(
630       _transferable ||
631       _isAuthorizedAccount(_msgSender()) ||
632       _isAuthorizedAccount(holder) ||
633       _isAuthorizedAccount(recipient),
634       "TransferFrom: sender/recipient is not authorized"
635     );
636 
637     return super.transferFrom(holder, recipient, amount);
638   }
639 
640   function _isAuthorizedAccount(address account) internal view returns (bool) {
641     return account == owner() || authorizedAccounts[account];
642   }
643 }