1 pragma solidity ^0.5.0;
2 
3 
4 interface IERC20 {
5     
6     function totalSupply() external view returns (uint256);
7 
8     
9     function balanceOf(address account) external view returns (uint256);
10 
11     
12     function transfer(address recipient, uint256 amount) external returns (bool);
13 
14     
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22 
23     
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 contract ERC20Detailed is IERC20 {
31     string private _name;
32     string private _symbol;
33     uint8 private _decimals;
34 
35     
36     constructor (string memory name, string memory symbol, uint8 decimals) public {
37         _name = name;
38         _symbol = symbol;
39         _decimals = decimals;
40     }
41 
42     
43     function name() public view returns (string memory) {
44         return _name;
45     }
46 
47     
48     function symbol() public view returns (string memory) {
49         return _symbol;
50     }
51 
52     
53     function decimals() public view returns (uint8) {
54         return _decimals;
55     }
56 }
57 
58 library SafeMath {
59     
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a, "SafeMath: subtraction overflow");
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         
78         
79         
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         
93         require(b > 0, "SafeMath: division by zero");
94         uint256 c = a / b;
95         
96 
97         return c;
98     }
99 
100     
101     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b != 0, "SafeMath: modulo by zero");
103         return a % b;
104     }
105 }
106 
107 contract ERC20 is IERC20 {
108     using SafeMath for uint256;
109 
110     mapping (address => uint256) private _balances;
111 
112     mapping (address => mapping (address => uint256)) private _allowances;
113 
114     uint256 private _totalSupply;
115 
116     
117     function totalSupply() public view returns (uint256) {
118         return _totalSupply;
119     }
120 
121     
122     function balanceOf(address account) public view returns (uint256) {
123         return _balances[account];
124     }
125 
126     
127     function transfer(address recipient, uint256 amount) public returns (bool) {
128         _transfer(msg.sender, recipient, amount);
129         return true;
130     }
131 
132     
133     function allowance(address owner, address spender) public view returns (uint256) {
134         return _allowances[owner][spender];
135     }
136 
137     
138     function approve(address spender, uint256 value) public returns (bool) {
139         _approve(msg.sender, spender, value);
140         return true;
141     }
142 
143     
144     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
145         _transfer(sender, recipient, amount);
146         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
147         return true;
148     }
149 
150     
151     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
152         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
153         return true;
154     }
155 
156     
157     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
158         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
159         return true;
160     }
161 
162     
163     function _transfer(address sender, address recipient, uint256 amount) internal {
164         require(sender != address(0), "ERC20: transfer from the zero address");
165         require(recipient != address(0), "ERC20: transfer to the zero address");
166 
167         _balances[sender] = _balances[sender].sub(amount);
168         _balances[recipient] = _balances[recipient].add(amount);
169         emit Transfer(sender, recipient, amount);
170     }
171 
172     
173     function _mint(address account, uint256 amount) internal {
174         require(account != address(0), "ERC20: mint to the zero address");
175 
176         _totalSupply = _totalSupply.add(amount);
177         _balances[account] = _balances[account].add(amount);
178         emit Transfer(address(0), account, amount);
179     }
180 
181      
182     function _burn(address account, uint256 value) internal {
183         require(account != address(0), "ERC20: burn from the zero address");
184 
185         _totalSupply = _totalSupply.sub(value);
186         _balances[account] = _balances[account].sub(value);
187         emit Transfer(account, address(0), value);
188     }
189 
190     
191     function _approve(address owner, address spender, uint256 value) internal {
192         require(owner != address(0), "ERC20: approve from the zero address");
193         require(spender != address(0), "ERC20: approve to the zero address");
194 
195         _allowances[owner][spender] = value;
196         emit Approval(owner, spender, value);
197     }
198 
199     
200     function _burnFrom(address account, uint256 amount) internal {
201         _burn(account, amount);
202         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
203     }
204 }
205 
206 library Roles {
207     struct Role {
208         mapping (address => bool) bearer;
209     }
210 
211     
212     function add(Role storage role, address account) internal {
213         require(!has(role, account), "Roles: account already has role");
214         role.bearer[account] = true;
215     }
216 
217     
218     function remove(Role storage role, address account) internal {
219         require(has(role, account), "Roles: account does not have role");
220         role.bearer[account] = false;
221     }
222 
223     
224     function has(Role storage role, address account) internal view returns (bool) {
225         require(account != address(0), "Roles: account is the zero address");
226         return role.bearer[account];
227     }
228 }
229 
230 contract PauserRole {
231     using Roles for Roles.Role;
232 
233     event PauserAdded(address indexed account);
234     event PauserRemoved(address indexed account);
235 
236     Roles.Role private _pausers;
237 
238     constructor () internal {
239         _addPauser(msg.sender);
240     }
241 
242     modifier onlyPauser() {
243         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
244         _;
245     }
246 
247     function isPauser(address account) public view returns (bool) {
248         return _pausers.has(account);
249     }
250 
251     function addPauser(address account) public onlyPauser {
252         _addPauser(account);
253     }
254 
255     function renouncePauser() public {
256         _removePauser(msg.sender);
257     }
258 
259     function _addPauser(address account) internal {
260         _pausers.add(account);
261         emit PauserAdded(account);
262     }
263 
264     function _removePauser(address account) internal {
265         _pausers.remove(account);
266         emit PauserRemoved(account);
267     }
268 }
269 
270 contract Pausable is PauserRole {
271     
272     event Paused(address account);
273 
274     
275     event Unpaused(address account);
276 
277     bool private _paused;
278 
279     
280     constructor () internal {
281         _paused = false;
282     }
283 
284     
285     function paused() public view returns (bool) {
286         return _paused;
287     }
288 
289     
290     modifier whenNotPaused() {
291         require(!_paused, "Pausable: paused");
292         _;
293     }
294 
295     
296     modifier whenPaused() {
297         require(_paused, "Pausable: not paused");
298         _;
299     }
300 
301     
302     function pause() public onlyPauser whenNotPaused {
303         _paused = true;
304         emit Paused(msg.sender);
305     }
306 
307     
308     function unpause() public onlyPauser whenPaused {
309         _paused = false;
310         emit Unpaused(msg.sender);
311     }
312 }
313 
314 contract ERC20Pausable is ERC20, Pausable {
315     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
316         return super.transfer(to, value);
317     }
318 
319     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
320         return super.transferFrom(from, to, value);
321     }
322 
323     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
324         return super.approve(spender, value);
325     }
326 
327     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
328         return super.increaseAllowance(spender, addedValue);
329     }
330 
331     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
332         return super.decreaseAllowance(spender, subtractedValue);
333     }
334 }
335 
336 contract UnirisToken is ERC20Pausable, ERC20Detailed {
337 
338   
339   uint256 public constant funding_pool_supply = 3820000000000000000000000000;
340 
341   
342   uint256 public constant deliverable_supply = 2360000000000000000000000000;
343 
344   
345   uint256 public constant network_pool_supply = 1460000000000000000000000000;
346 
347   
348   uint256 public constant enhancement_supply = 900000000000000000000000000;
349 
350   
351   uint256 public constant team_supply = 560000000000000000000000000;
352 
353   
354   uint256 public constant exch_pool_supply = 340000000000000000000000000;
355 
356   
357   uint256 public constant marketing_supply = 340000000000000000000000000;
358 
359   
360   uint256 public constant foundation_supply = 220000000000000000000000000;
361 
362   address public funding_pool_beneficiary;
363   address public deliverables_beneficiary;
364   address public network_pool_beneficiary;
365   address public enhancement_beneficiary;
366   address public team_beneficiary;
367   address public exch_pool_beneficiary;
368   address public marketing_beneficiary;
369   address public foundation_beneficiary;
370 
371   modifier onlyUnlocked(address from, uint256 value) {
372     
373     
374     require(from != enhancement_beneficiary, "Enhancement wallet is locked forever until mainnet");
375 
376     
377     
378     
379     
380     if (from == deliverables_beneficiary) {
381       uint256 _delivered = deliverable_supply - balanceOf(deliverables_beneficiary);
382       require(_delivered.add(value) <= deliverable_supply.mul(10).div(100), "Only 10% of the deliverable supply is unlocked before mainnet");
383     }
384     else if (from == network_pool_beneficiary) {
385       uint256 _delivered = network_pool_supply - balanceOf(network_pool_beneficiary);
386       require(_delivered.add(value) <= network_pool_supply.mul(10).div(100), "Only 10% of the network supply is unlocked before mainnet");
387     }
388     _;
389   }
390 
391   constructor(
392     address _funding_pool_beneficiary,
393     address _deliverables_beneficiary,
394     address _network_pool_beneficiary,
395     address _enhancement_beneficiary,
396     address _team_beneficiary,
397     address _exch_pool_beneficiary,
398     address _marketing_beneficiary,
399     address _foundation_beneficiary
400     ) public ERC20Detailed("UnirisToken", "UCO", 18) {
401 
402     require(_funding_pool_beneficiary != address(0), "Invalid funding pool beneficiary address");
403     require(_deliverables_beneficiary != address(0), "Invalid deliverables beneficiary address");
404     require(_network_pool_beneficiary != address(0), "Invalid network pool beneficiary address");
405     require(_enhancement_beneficiary != address(0), "Invalid enhancement beneficiary address");
406     require(_team_beneficiary != address(0), "Invalid team beneficiary address");
407     require(_exch_pool_beneficiary != address(0), "Invalid exch pool beneficiary address");
408     require(_marketing_beneficiary != address(0), "Invalid marketing beneficiary address");
409     require(_foundation_beneficiary != address(0), "Invalid foundation beneficiary address");
410 
411     funding_pool_beneficiary = _funding_pool_beneficiary;
412     deliverables_beneficiary = _deliverables_beneficiary;
413     network_pool_beneficiary = _network_pool_beneficiary;
414     enhancement_beneficiary = _enhancement_beneficiary;
415     team_beneficiary = _team_beneficiary;
416     exch_pool_beneficiary = _exch_pool_beneficiary;
417     marketing_beneficiary = _marketing_beneficiary;
418     foundation_beneficiary = _foundation_beneficiary;
419 
420     _mint(funding_pool_beneficiary, funding_pool_supply);
421     _mint(deliverables_beneficiary, deliverable_supply);
422     _mint(network_pool_beneficiary, network_pool_supply);
423     _mint(enhancement_beneficiary, enhancement_supply);
424     _mint(team_beneficiary, team_supply);
425     _mint(exch_pool_beneficiary, exch_pool_supply);
426     _mint(marketing_beneficiary, marketing_supply);
427     _mint(foundation_beneficiary, foundation_supply);
428   }
429 
430   function transfer(address _to, uint256 _value) public onlyUnlocked(msg.sender, _value) returns (bool success) {
431     return super.transfer(_to, _value);
432   }
433 
434   function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked(_from, _value) returns (bool success) {
435     return super.transferFrom(_from, _to, _value);
436   }
437 }