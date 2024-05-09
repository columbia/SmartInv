1 // SPDX-License-Identifier: MIT
2 
3 
4 /*
5 
6       $$\      $$\ $$\                               $$\       $$\           
7       $$$\    $$$ |\__|                              $$ |      $$ |          
8       $$$$\  $$$$ |$$\ $$$$$$$\   $$$$$$\   $$$$$$\  $$$$$$$\  $$ | $$$$$$\  
9       $$\$$\$$ $$ |$$ |$$  __$$\ $$  __$$\  \____$$\ $$  __$$\ $$ |$$  __$$\ 
10       $$ \$$$  $$ |$$ |$$ |  $$ |$$$$$$$$ | $$$$$$$ |$$ |  $$ |$$ |$$$$$$$$ |
11       $$ |\$  /$$ |$$ |$$ |  $$ |$$   ____|$$  __$$ |$$ |  $$ |$$ |$$   ____|
12       $$ | \_/ $$ |$$ |$$ |  $$ |\$$$$$$$\ \$$$$$$$ |$$$$$$$  |$$ |\$$$$$$$\ 
13       \__|     \__|\__|\__|  \__| \_______| \_______|\_______/ \__| \_______|
14                                                                              
15                                                                              
16                                                                             
17 */
18 
19 pragma solidity ^0.8.0;
20 
21 interface IERC20 {
22    
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address to, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(
31         address from,
32         address to,
33         uint256 amount
34     ) external returns (bool);
35 }
36 
37 
38 interface IERC165 {
39     function supportsInterface(bytes4 interfaceId) external view returns (bool);
40 }
41 
42 abstract contract ERC165 is IERC165 {
43     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
44         return interfaceId == type(IERC165).interfaceId;
45     }
46 }
47 
48 library Strings {
49     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
50     uint8 private constant _ADDRESS_LENGTH = 20;
51 
52     function toString(uint256 value) internal pure returns (string memory) {
53 
54         if (value == 0) {
55             return "0";
56         }
57         uint256 temp = value;
58         uint256 digits;
59         while (temp != 0) {
60             digits++;
61             temp /= 10;
62         }
63         bytes memory buffer = new bytes(digits);
64         while (value != 0) {
65             digits -= 1;
66             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
67             value /= 10;
68         }
69         return string(buffer);
70     }
71     function toHexString(uint256 value) internal pure returns (string memory) {
72         if (value == 0) {
73             return "0x00";
74         }
75         uint256 temp = value;
76         uint256 length = 0;
77         while (temp != 0) {
78             length++;
79             temp >>= 8;
80         }
81         return toHexString(value, length);
82     }
83 
84     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
85         bytes memory buffer = new bytes(2 * length + 2);
86         buffer[0] = "0";
87         buffer[1] = "x";
88         for (uint256 i = 2 * length + 1; i > 1; --i) {
89             buffer[i] = _HEX_SYMBOLS[value & 0xf];
90             value >>= 4;
91         }
92         require(value == 0, "Strings: hex length insufficient");
93         return string(buffer);
94     }
95 
96     function toHexString(address addr) internal pure returns (string memory) {
97         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
98     }
99 }
100 
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 interface IAccessControl {
112 
113     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
114     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
115     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
116     function hasRole(bytes32 role, address account) external view returns (bool);
117     function getRoleAdmin(bytes32 role) external view returns (bytes32);
118     function grantRole(bytes32 role, address account) external;
119     function revokeRole(bytes32 role, address account) external;
120     function renounceRole(bytes32 role, address account) external;
121 }
122 
123 abstract contract AccessControl is Context, IAccessControl, ERC165 {
124     struct RoleData {
125         mapping(address => bool) members;
126         bytes32 adminRole;
127     }
128 
129     mapping(bytes32 => RoleData) private _roles;
130 
131     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
132 
133     modifier onlyRole(bytes32 role) {
134         _checkRole(role);
135         _;
136     }
137 
138     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
139         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
140     }
141 
142     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
143         return _roles[role].members[account];
144     }
145 
146     function _checkRole(bytes32 role) internal view virtual {
147         _checkRole(role, _msgSender());
148     }
149 
150     function _checkRole(bytes32 role, address account) internal view virtual {
151         if (!hasRole(role, account)) {
152             revert(
153                 string(
154                     abi.encodePacked(
155                         "AccessControl: account ",
156                         Strings.toHexString(uint160(account), 20),
157                         " is missing role ",
158                         Strings.toHexString(uint256(role), 32)
159                     )
160                 )
161             );
162         }
163     }
164 
165     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
166         return _roles[role].adminRole;
167     }
168 
169     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
170         _grantRole(role, account);
171     }
172 
173     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
174         _revokeRole(role, account);
175     }
176 
177     function renounceRole(bytes32 role, address account) public virtual override {
178         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
179 
180         _revokeRole(role, account);
181     }
182 
183     function _setupRole(bytes32 role, address account) internal virtual {
184         _grantRole(role, account);
185     }
186 
187     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
188         bytes32 previousAdminRole = getRoleAdmin(role);
189         _roles[role].adminRole = adminRole;
190         emit RoleAdminChanged(role, previousAdminRole, adminRole);
191     }
192 
193     function _grantRole(bytes32 role, address account) internal virtual {
194         if (!hasRole(role, account)) {
195             _roles[role].members[account] = true;
196             emit RoleGranted(role, account, _msgSender());
197         }
198     }
199 
200     function _revokeRole(bytes32 role, address account) internal virtual {
201         if (hasRole(role, account)) {
202             _roles[role].members[account] = false;
203             emit RoleRevoked(role, account, _msgSender());
204         }
205     }
206 }
207 
208 contract Mineable is AccessControl {
209 
210     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
211 
212     string private _name = "Mineable";
213     string private _symbol = "$MNB";
214     uint8 private _decimals = 18;
215 
216     uint public Mined;
217     uint public miningStartAt;
218 
219     uint private frequency = 10 minutes;
220     uint private fd = 52560;
221     uint private sr = 10000 * 10 ** _decimals; 
222     uint private ddr = 210082;  
223     uint private elreward = 10 * 10 ** _decimals;
224     uint private deflationRate = 75;  
225     uint private denominator = 100;
226 
227     uint public startSupply = 250_000_000 * 10 ** _decimals;
228     uint public maxMineableSupply = 1_250_000_000 * 10 ** _decimals;
229 
230     uint private _totalSupply;
231 
232     address public minterController = address(0x0E0754c25261BB320Dd27835b703b73ED2a53c59);
233 
234     address DEAD = 0x000000000000000000000000000000000000dEaD;
235     address ZERO = 0x0000000000000000000000000000000000000000;
236 
237     mapping(address => uint) private _balances;
238     mapping(address => mapping(address => uint)) private _allowances;
239     
240     event Transfer(address indexed from, address indexed to, uint value);
241     event Approval(address indexed owner, address indexed spender, uint value);
242 
243     constructor(){
244 
245         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
246         _grantRole(MINTER_ROLE, minterController);
247 
248         _totalSupply = startSupply;
249         _balances[msg.sender] = _totalSupply; //starting token
250         emit Transfer(address(0), msg.sender, _totalSupply);
251     }
252 
253     function transfer(address to, uint256 amount) public returns (bool) {
254         address owner = msg.sender;
255         _transfer(owner, to, amount);
256         return true;
257     }
258 
259     function transferFrom(
260         address from,
261         address to,
262         uint256 amount
263     ) public returns (bool) {
264         address spender = msg.sender;
265         _spendAllowance(from, spender, amount);
266         _transfer(from, to, amount);
267         return true;
268     }
269 
270     function approve(address spender, uint256 amount) public returns (bool) {
271         address owner = msg.sender;
272         _approve(owner, spender, amount);
273         return true;
274     }
275 
276      function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
277         address owner = msg.sender;
278         _approve(owner, spender, allowance(owner, spender) + addedValue);
279         return true;
280     }
281 
282     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
283         address owner = msg.sender;
284         uint256 currentAllowance = allowance(owner, spender);
285         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
286         unchecked {
287             _approve(owner, spender, currentAllowance - subtractedValue);
288         }
289 
290         return true;
291     }
292 
293     function _transfer(
294         address from,
295         address to,
296         uint256 amount
297     ) internal {
298         require(from != address(0), "ERC20: transfer from the zero address");
299         require(to != address(0), "ERC20: transfer to the zero address");
300 
301         uint256 fromBalance = _balances[from];
302         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
303         
304         _balances[from] = fromBalance - amount;        
305         _balances[to] += amount;
306 
307         emit Transfer(from, to, amount);
308     }
309     
310     function _approve(
311         address owner,
312         address spender,
313         uint256 amount
314     ) internal {
315         require(owner != address(0), "ERC20: approve from the zero address");
316         require(spender != address(0), "ERC20: approve to the zero address");
317         _allowances[owner][spender] = amount;
318         emit Approval(owner, spender, amount);
319     }
320 
321     function _spendAllowance(
322         address owner,
323         address spender,
324         uint256 amount
325     ) internal {
326         uint256 currentAllowance = allowance(owner, spender);
327         if (currentAllowance != type(uint256).max) {
328             require(currentAllowance >= amount, "ERC20: insufficient allowance");
329             unchecked {
330                 _approve(owner, spender, currentAllowance - amount);
331             }
332         }
333     }
334 
335     function allowance(address owner, address spender) public view returns (uint256) {
336         return _allowances[owner][spender];
337     }
338 
339     function name() public view returns (string memory) {
340         return _name;
341     }
342 
343     function symbol() public view returns (string memory) {
344         return _symbol;
345     }
346 
347     function decimals() public view returns (uint8) {
348         return _decimals;
349     }
350 
351     function totalSupply() public view returns (uint256) {
352         return _totalSupply;
353     }
354 
355     function balanceOf(address account) public view returns (uint256) {
356         return _balances[account];
357     }
358 
359     function totalCirculationSupply() public view returns (uint256) {
360         return _totalSupply - _balances[DEAD] - _balances[ZERO];
361     }
362 
363     // ------------    Deflation -------------------
364 
365     function startMining() external onlyRole(MINTER_ROLE) {
366         require(miningStartAt == 0,"Error: Already Started!");
367         miningStartAt = block.timestamp;
368     }
369 
370     function triggerMint() external onlyRole(MINTER_ROLE) {
371         require(minterController != address(0),"Please set Controller Address!!");
372         uint mintable = getTriggerInfo();
373         if(mintable == 0) {
374             revert("Error: Mintable not available!");
375         }
376         Mined += mintable;
377         _totalSupply += mintable;
378         _balances[minterController] += mintable;
379         emit Transfer(address(0), minterController, mintable);
380     }
381 
382     function getTriggerInfo() public view returns (uint mintable) {  
383         uint getBlock = getBlocks();
384         uint adder = fd;
385         uint subber = 0;
386         uint blockdelta = fd;
387         uint rewarddelta = sr;
388         uint lemda = 0;
389         if(getBlock > fd) {
390             lemda = fd * sr;
391             for(uint i = 0; i < 25; i++) {
392                 uint tblock = blockdelta*deflationRate/denominator;
393                 uint tReward = rewarddelta*deflationRate/denominator;
394                 adder = adder + tblock;
395                 subber = subber + blockdelta;
396                 // Eve = i + 1; 
397                 if(getBlock > adder) {
398                     lemda += tblock*tReward;
399                     blockdelta = tblock;
400                     rewarddelta = tReward;
401                 }
402                 else {
403                     uint wr = getBlock - subber;
404                     lemda += wr * tReward;
405                     break;
406                 }
407             }
408         }
409         else {
410             lemda = getBlock * sr;
411         }
412 
413         if(getBlock > ddr) {
414             uint elst = getBlock - ddr;
415             uint tobe = elst * elreward;
416             lemda += tobe;
417         }
418 
419        return lemda > maxMineableSupply ? maxMineableSupply - Mined : lemda - Mined;  //limit max supply
420 
421     }
422 
423     function elapsedTime() public view returns (uint) {
424         return miningStartAt > 0 ? block.timestamp - miningStartAt : 0;
425     }
426 
427     function getBlocks() public view returns (uint) {
428         uint getSec = elapsedTime();
429         uint getBlock = getSec / frequency;
430         return getBlock;
431     }
432 
433     function getTime() public view returns (uint) {
434         return block.timestamp;
435     }
436 
437     function setController(address _newAdr) external onlyRole(DEFAULT_ADMIN_ROLE) {
438         minterController = _newAdr;
439     }
440 
441     function rescueFunds() external onlyRole(DEFAULT_ADMIN_ROLE) {
442         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
443         require(os);
444     }
445 
446     function rescueTokens(address _token) external onlyRole(DEFAULT_ADMIN_ROLE) {
447         uint balance = IERC20(_token).balanceOf(address(this));
448         IERC20(_token).transfer(msg.sender,balance);
449     }
450 
451     receive() payable external {}
452 
453 }