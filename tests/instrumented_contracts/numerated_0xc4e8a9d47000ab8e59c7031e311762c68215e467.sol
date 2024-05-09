1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4   
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         require(b <= a, "SafeMath: subtraction overflow");
14         uint256 c = a - b;
15 
16         return c;
17     }
18     
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b, "SafeMath: multiplication overflow");
26 
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b > 0, "SafeMath: division by zero");
32         uint256 c = a / b;
33         return c;
34     }
35    
36     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b != 0, "SafeMath: modulo by zero");
38         return a % b;
39     }
40 }
41 
42 library Address {
43   
44     function isContract(address account) internal view returns (bool) {
45      
46         uint256 size;
47         
48         assembly { size := extcodesize(account) }
49         return size > 0;
50     }
51 }
52 
53 interface IERC1820Registry {
54    
55     function setManager(address account, address newManager) external;
56   
57     function getManager(address account) external view returns (address);
58  
59     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
60   
61     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
62    
63     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
64    
65     function updateERC165Cache(address account, bytes4 interfaceId) external;
66 
67     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
68 
69     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
70 
71     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
72 
73     event ManagerChanged(address indexed account, address indexed newManager);
74 }
75 
76 interface IERC777 {
77     
78     function name() external view returns (string memory);
79 
80     function symbol() external view returns (string memory);
81    
82     function granularity() external view returns (uint256);
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address owner) external view returns (uint256);
87   
88     function send(address recipient, uint256 amount, bytes calldata data) external;
89    
90     function burn(uint256 amount, bytes calldata data) external;
91    
92     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
93    
94     function authorizeOperator(address operator) external;
95     
96     function revokeOperator(address operator) external;
97 
98     function defaultOperators() external view returns (address[] memory);
99 
100     
101     function operatorSend(
102         address sender,
103         address recipient,
104         uint256 amount,
105         bytes calldata data,
106         bytes calldata operatorData
107     ) external;
108 
109     function operatorBurn(
110         address account,
111         uint256 amount,
112         bytes calldata data,
113         bytes calldata operatorData
114     ) external;
115 
116     event Sent(
117         address indexed operator,
118         address indexed from,
119         address indexed to,
120         uint256 amount,
121         bytes data,
122         bytes operatorData
123     );
124 
125     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
126 
127     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
128 
129     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
130 
131     event RevokedOperator(address indexed operator, address indexed tokenHolder);
132 }
133 
134 interface IERC777Recipient {
135     
136     function tokensReceived(
137         address operator,
138         address from,
139         address to,
140         uint amount,
141         bytes calldata userData,
142         bytes calldata operatorData
143     ) external;
144 }
145 
146 interface IERC777Sender {
147    
148     function tokensToSend(
149         address operator,
150         address from,
151         address to,
152         uint amount,
153         bytes calldata userData,
154         bytes calldata operatorData
155     ) external;
156 }
157 
158 interface IERC20 {
159     
160     function totalSupply() external view returns (uint256);
161 
162     function balanceOf(address account) external view returns (uint256);
163 
164     function transfer(address recipient, uint256 amount) external returns (bool);
165 
166     function allowance(address owner, address spender) external view returns (uint256);
167 
168     function approve(address spender, uint256 amount) external returns (bool);
169 
170     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
171   
172     event Transfer(address indexed from, address indexed to, uint256 value);
173 
174     event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 contract ERC777 is IERC777, IERC20 {
178     using SafeMath for uint256;
179     using Address for address;
180 
181     IERC1820Registry private _erc1820 = IERC1820Registry(0xc0cE3461c92D95b4E1D3ABeb5c9D378b1e418030);
182 
183     mapping(address => uint256) private _balances;
184 
185     uint256 private _totalSupply;
186     string private _name;
187     string private _symbol;
188     bytes32 constant private senderHash    = 0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
189     bytes32 constant private recipientHash = 0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
190 
191     address[] private _defaultOperatorsArray;
192 
193     mapping(address => bool) private _defaultOperators;
194     mapping(address => mapping(address => bool)) private _operators;
195     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
196     mapping (address => mapping (address => uint256)) private _allowances;
197 
198      constructor(
199         string memory name,
200         string memory symbol,
201         address[] memory defaultOperators
202     ) public {
203         _name   = name;
204         _symbol = symbol;
205 
206         _defaultOperatorsArray = defaultOperators;
207         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
208             _defaultOperators[_defaultOperatorsArray[i]] = true;
209         }
210         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
211         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
212     }
213 
214 
215     function name() public view returns (string memory) {
216         return _name;
217     }
218    function symbol() public view returns (string memory) {
219         return _symbol;
220     }
221     function decimals() public pure returns (uint8) {
222         return 18;
223     }
224 
225     function granularity() public view returns (uint256) {
226         return 18;
227     }
228 
229     function totalSupply() public view returns (uint256) {
230         return _totalSupply;
231     }
232  function balanceOf(address tokenHolder) public view returns (uint256) {
233         return _balances[tokenHolder];
234     }
235     function send(address recipient, uint256 amount, bytes calldata data) external {
236         _send(msg.sender, msg.sender, recipient, amount, data, "", true);
237     }
238     function transfer(address recipient, uint256 amount) external returns (bool) {
239         require(recipient != address(0), "ERC777: transfer to the zero address");
240 
241         address from = msg.sender;
242 
243         _callTokensToSend(from, from, recipient, amount, "", "");
244 
245         _move(from, from, recipient, amount, "", "");
246 
247         _callTokensReceived(from, from, recipient, amount, "", "", false);
248 
249         return true;
250     }
251 
252      function burn(uint256 amount, bytes calldata data) external {
253         _burn(msg.sender, msg.sender, amount, data, "");
254     }
255     
256     function isOperatorFor(
257         address operator,
258         address tokenHolder
259     ) public view returns (bool) {
260         return operator == tokenHolder ||
261             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
262             _operators[tokenHolder][operator];
263     }
264    function authorizeOperator(address operator) external {
265         require(msg.sender != operator, "ERC777: authorizing self as operator");
266 
267         if (_defaultOperators[operator]) {
268             delete _revokedDefaultOperators[msg.sender][operator];
269         } else {
270             _operators[msg.sender][operator] = true;
271         }
272 
273         emit AuthorizedOperator(operator, msg.sender);
274     }
275 
276      function revokeOperator(address operator) external {
277         require(operator != msg.sender, "ERC777: revoking self as operator");
278 
279         if (_defaultOperators[operator]) {
280             _revokedDefaultOperators[msg.sender][operator] = true;
281         } else {
282             delete _operators[msg.sender][operator];
283         }
284 
285         emit RevokedOperator(operator, msg.sender);
286     }
287 
288    function defaultOperators() public view returns (address[] memory) {
289         return _defaultOperatorsArray;
290     }
291 
292    function operatorSend(
293         address sender,
294         address recipient,
295         uint256 amount,
296         bytes calldata data,
297         bytes calldata operatorData
298     )
299     external
300     {
301         require(isOperatorFor(msg.sender, sender), "ERC777: caller is not an operator for holder");
302         _send(msg.sender, sender, recipient, amount, data, operatorData, true);
303     }
304 
305   
306     function operatorBurn(address account, uint256 amount, bytes calldata data, bytes calldata operatorData) external {
307         require(isOperatorFor(msg.sender, account), "ERC777: caller is not an operator for holder");
308         _burn(msg.sender, account, amount, data, operatorData);
309     }
310 
311 
312     function allowance(address holder, address spender) public view returns (uint256) {
313         return _allowances[holder][spender];
314     }
315 
316 
317     function approve(address spender, uint256 value) external returns (bool) {
318         address holder = msg.sender;
319         _approve(holder, spender, value);
320         return true;
321     }
322 
323   
324     function transferFrom(address holder, address recipient, uint256 amount) external returns (bool) {
325         require(recipient != address(0), "ERC777: transfer to the zero address");
326         require(holder != address(0), "ERC777: transfer from the zero address");
327 
328         address spender = msg.sender;
329 
330         _callTokensToSend(spender, holder, recipient, amount, "", "");
331 
332         _move(spender, holder, recipient, amount, "", "");
333         _approve(holder, spender, _allowances[holder][spender].sub(amount));
334 
335         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
336 
337         return true;
338     }
339 
340     function _mint(
341         address operator,
342         address account,
343         uint256 amount,
344         bytes memory userData,
345         bytes memory operatorData
346     )
347     internal
348     {
349         require(account != address(0), "ERC777: mint to the zero address");
350 
351         _totalSupply = _totalSupply.add(amount);
352         _balances[account] = _balances[account].add(amount);
353 
354         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
355 
356         emit Minted(operator, account, amount, userData, operatorData);
357         emit Transfer(address(0), account, amount);
358     }
359 
360     function _send(
361         address operator,
362         address from,
363         address to,
364         uint256 amount,
365         bytes memory userData,
366         bytes memory operatorData,
367         bool requireReceptionAck
368     )
369         private
370     {
371         require(from != address(0), "ERC777: send from the zero address");
372         require(to != address(0), "ERC777: send to the zero address");
373 
374         _callTokensToSend(operator, from, to, amount, userData, operatorData);
375 
376         _move(operator, from, to, amount, userData, operatorData);
377 
378         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
379     }
380     
381     function _burn(
382         address operator,
383         address from,
384         uint256 amount,
385         bytes memory data,
386         bytes memory operatorData
387     )
388         private
389     {
390         require(from != address(0), "ERC777: burn from the zero address");
391 
392         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
393 
394 
395         _totalSupply = _totalSupply.sub(amount);
396         _balances[from] = _balances[from].sub(amount);
397 
398         emit Burned(operator, from, amount, data, operatorData);
399         emit Transfer(from, address(0), amount);
400     }
401 
402     function _move(
403         address operator,
404         address from,
405         address to,
406         uint256 amount,
407         bytes memory userData,
408         bytes memory operatorData
409     )
410         private
411     {
412         _balances[from] = _balances[from].sub(amount);
413         _balances[to] = _balances[to].add(amount);
414 
415         emit Sent(operator, from, to, amount, userData, operatorData);
416         emit Transfer(from, to, amount);
417     }
418 
419     function _approve(address holder, address spender, uint256 value) private {
420            require(spender != address(0), "ERC777: approve to the zero address");
421 
422         _allowances[holder][spender] = value;
423         emit Approval(holder, spender, value);
424     }
425 
426    function _callTokensToSend(
427         address operator,
428         address from,
429         address to,
430         uint256 amount,
431         bytes memory userData,
432         bytes memory operatorData
433     )
434         private
435     {
436         address implementer = _erc1820.getInterfaceImplementer(from, senderHash);
437         if (implementer != address(0)) {
438             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
439         }
440     }
441 
442      function _callTokensReceived(
443         address operator,
444         address from,
445         address to,
446         uint256 amount,
447         bytes memory userData,
448         bytes memory operatorData,
449         bool requireReceptionAck
450     )
451         private
452     {
453         address implementer = _erc1820.getInterfaceImplementer(to, recipientHash);
454         if (implementer != address(0)) {
455             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
456         } else if (requireReceptionAck) {
457             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
458         }
459     }
460 }
461 
462 
463 //STARXtoken's smart contract
464 contract STARXtoken is ERC777 {
465       constructor () public ERC777("STARX", "STARX", new address[](0)) {
466         _mint(msg.sender, msg.sender, 1000000000 * 10 ** 18, "", "");
467     }
468 }