1 /*! lk.sol | (c) 2019 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.5.7;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if(a == 0) return 0;
8         uint256 c = a * b;
9         require(c / a == b, "SafeMath: multiplication overflow");
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b > 0, "SafeMath: division by zero");
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         require(b <= a, "SafeMath: subtraction overflow");
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b != 0, "SafeMath: modulo by zero");
31         return a % b;
32     }
33 }
34 
35 contract Ownable {
36     address private _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     constructor() internal {
41         _owner = msg.sender;
42         emit OwnershipTransferred(address(0), _owner);
43     }
44 
45     function owner() public view returns (address) {
46         return _owner;
47     }
48 
49     modifier onlyOwner() {
50         require(isOwner(), "Ownable: caller is not the owner");
51         _;
52     }
53 
54     function isOwner() public view returns (bool) {
55         return msg.sender == _owner;
56     }
57 
58     function renounceOwnership() public onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62 
63     function transferOwnership(address newOwner) public onlyOwner {
64         _transferOwnership(newOwner);
65     }
66 
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0), "Ownable: new owner is the zero address");
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 interface IERC20 {
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 
78     function transfer(address to, uint256 value) external returns (bool);
79     function approve(address spender, uint256 value) external returns (bool);
80     function transferFrom(address from, address to, uint256 value) external returns (bool);
81     function totalSupply() external view returns (uint256);
82     function balanceOf(address who) external view returns (uint256);
83     function allowance(address owner, address spender) external view returns (uint256);
84 }
85 
86 contract StandardToken is IERC20 {
87     using SafeMath for uint256;
88 
89     mapping (address => uint256) private _balances;
90     mapping (address => mapping (address => uint256)) private _allowed;
91 
92     uint256 private _totalSupply;
93     string private _name;
94     string private _symbol;
95     uint8 private _decimals;
96 
97     constructor(string memory name, string memory symbol, uint8 decimals) public {
98         _name = name;
99         _symbol = symbol;
100         _decimals = decimals;
101     }
102 
103     function name() public view returns (string memory) {
104         return _name;
105     }
106 
107     function symbol() public view returns (string memory) {
108         return _symbol;
109     }
110 
111     function decimals() public view returns (uint8) {
112         return _decimals;
113     }
114 
115     function totalSupply() public view returns (uint256) {
116         return _totalSupply;
117     }
118 
119     function balanceOf(address owner) public view returns (uint256) {
120         return _balances[owner];
121     }
122 
123     function allowance(address owner, address spender) public view returns (uint256) {
124         return _allowed[owner][spender];
125     }
126     
127     function transfer(address to, uint256 value) public returns (bool) {
128         _transfer(msg.sender, to, value);
129         return true;
130     }
131 
132     function multiTransfer(address[] memory to, uint256[] memory value) public returns (bool) {
133         require(to.length > 0 && to.length == value.length, "Invalid params");
134 
135         for(uint i = 0; i < to.length; i++) {
136             _transfer(msg.sender, to[i], value[i]);
137         }
138 
139         return true;
140     }
141 
142     function approve(address spender, uint256 value) public returns (bool) {
143         _approve(msg.sender, spender, value);
144         return true;
145     }
146 
147     function transferFrom(address from, address to, uint256 value) public returns (bool) {
148         _transfer(from, to, value);
149         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
150         return true;
151     }
152 
153     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
154         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
155         return true;
156     }
157 
158     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
159         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
160         return true;
161     }
162 
163     function _transfer(address from, address to, uint256 value) internal {
164         require(to != address(0), "ERC20: transfer to the zero address");
165 
166         _balances[from] = _balances[from].sub(value);
167         _balances[to] = _balances[to].add(value);
168 
169         emit Transfer(from, to, value);
170     }
171 
172     function _mint(address account, uint256 value) internal {
173         require(account != address(0), "ERC20: mint to the zero address");
174 
175         _totalSupply = _totalSupply.add(value);
176         _balances[account] = _balances[account].add(value);
177 
178         emit Transfer(address(0), account, value);
179     }
180     
181     function _burn(address account, uint256 value) internal {
182         require(account != address(0), "ERC20: burn from the zero address");
183 
184         _totalSupply = _totalSupply.sub(value);
185         _balances[account] = _balances[account].sub(value);
186 
187         emit Transfer(account, address(0), value);
188     }
189     
190     function _approve(address owner, address spender, uint256 value) internal {
191         require(owner != address(0), "ERC20: approve from the zero address");
192         require(spender != address(0), "ERC20: approve to the zero address");
193 
194         _allowed[owner][spender] = value;
195 
196         emit Approval(owner, spender, value);
197     }
198     
199     function _burnFrom(address account, uint256 value) internal {
200         _burn(account, value);
201         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
202     }
203 }
204 
205 contract MintableToken is StandardToken, Ownable {
206     bool public mintingFinished = false;
207 
208     event MintFinished(address account);
209 
210     modifier canMint() {
211         require(!mintingFinished);
212         _;
213     }
214 
215     function finishMinting() onlyOwner canMint public returns(bool) {
216         mintingFinished = true;
217 
218         emit MintFinished(msg.sender);
219         return true;
220     }
221 
222     function mint(address to, uint256 value) public canMint onlyOwner returns (bool) {
223         _mint(to, value);
224         return true;
225     }
226 }
227 
228 contract CappedToken is MintableToken {
229     uint256 private _cap;
230 
231     constructor(uint256 cap) public {
232         require(cap > 0, "ERC20Capped: cap is 0");
233 
234         _cap = cap;
235     }
236 
237     function cap() public view returns (uint256) {
238         return _cap;
239     }
240 
241     function _mint(address account, uint256 value) internal {
242         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
243         super._mint(account, value);
244     }
245 }
246 
247 contract BurnableToken is StandardToken {
248     function burn(uint256 value) public {
249         _burn(msg.sender, value);
250     }
251 
252     function burnFrom(address from, uint256 value) public {
253         _burnFrom(from, value);
254     }
255 }
256 
257 contract Withdrawable is Ownable {
258     event WithdrawEther(address indexed to, uint value);
259 
260     function withdrawEther(address payable _to, uint _value) onlyOwner public {
261         require(_to != address(0));
262         require(address(this).balance >= _value);
263 
264         address(_to).transfer(_value);
265 
266         emit WithdrawEther(_to, _value);
267     }
268 
269     function withdrawTokensTransfer(IERC20 _token, address _to, uint256 _value) onlyOwner public {
270         require(_token.transfer(_to, _value));
271     }
272 
273     function withdrawTokensTransferFrom(IERC20 _token, address _from, address _to, uint256 _value) onlyOwner public {
274         require(_token.transferFrom(_from, _to, _value));
275     }
276 
277     function withdrawTokensApprove(IERC20 _token, address _spender, uint256 _value) onlyOwner public {
278         require(_token.approve(_spender, _value));
279     }
280 }
281 
282 contract Pausable is Ownable {
283     event Paused(address account);
284     event Unpaused(address account);
285 
286     bool private _paused;
287 
288     constructor() internal {
289         _paused = false;
290     }
291 
292     function paused() public view returns (bool) {
293         return _paused;
294     }
295 
296     modifier whenNotPaused() {
297         require(!_paused, "Pausable: paused");
298         _;
299     }
300 
301     modifier whenPaused() {
302         require(_paused, "Pausable: not paused");
303         _;
304     }
305 
306     function pause() public onlyOwner whenNotPaused {
307         _paused = true;
308 
309         emit Paused(msg.sender);
310     }
311 
312     function unpause() public onlyOwner whenPaused {
313         _paused = false;
314 
315         emit Unpaused(msg.sender);
316     }
317 }
318 
319 contract Manageable is Ownable {
320     address[] public managers;
321 
322     event ManagerAdded(address indexed manager);
323     event ManagerRemoved(address indexed manager);
324 
325     modifier onlyManager() { require(isManager(msg.sender)); _; }
326 
327     function countManagers() view public returns(uint) {
328         return managers.length;
329     }
330 
331     function getManagers() view public returns(address[] memory) {
332         return managers;
333     }
334 
335     function isManager(address _manager) view public returns(bool) {
336         for(uint i = 0; i < managers.length; i++) {
337             if(managers[i] == _manager) {
338                 return true;
339             }
340         }
341         return false;
342     }
343 
344     function addManager(address _manager) onlyOwner public {
345         require(_manager != address(0));
346         require(!isManager(_manager));
347 
348         managers.push(_manager);
349 
350         emit ManagerAdded(_manager);
351     }
352 
353     function removeManager(address _manager) onlyOwner public {
354         uint index = managers.length;
355         for(uint i = 0; i < managers.length; i++) {
356             if(managers[i] == _manager) {
357                 index = i;
358             }
359         }
360 
361         if(index >= managers.length) revert();
362 
363         for(; index < managers.length - 1; index++) {
364             managers[index] = managers[index + 1];
365         }
366         
367         managers.length--;
368         emit ManagerRemoved(_manager);
369     }
370 }
371 
372 
373 /*
374     Local Credit International
375 */
376 contract Token is CappedToken, BurnableToken, Withdrawable {
377     constructor() CappedToken(1000000 * 1e8) StandardToken("Local Credit International", "LCI", 8) public {
378         
379     }
380 }
381 
382 contract Crowdsale is Manageable, Withdrawable, Pausable {
383     using SafeMath for uint;
384 
385     Token public token;
386     bool public crowdsaleClosed = false;
387 
388     event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);
389     event CrowdsaleClose();
390    
391     constructor() public {
392         token = new Token();
393     }
394 
395     function externalPurchase(address _to, string memory _tx, string memory _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager public {
396         require(!crowdsaleClosed);
397         require(_to != address(0));
398 
399         token.mint(_to, _tokens);
400         emit ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);
401     }
402 
403     function closeCrowdsale(address _newTokenOwner) onlyOwner external {
404         require(!crowdsaleClosed);
405         require(_newTokenOwner != address(0));
406 
407         token.finishMinting();
408         token.transferOwnership(_newTokenOwner);
409 
410         crowdsaleClosed = true;
411 
412         emit CrowdsaleClose();
413     }
414     
415     function transferTokenOwnership(address _to) onlyOwner external {
416         require(crowdsaleClosed);
417         require(_to != address(0));
418 
419         token.transferOwnership(_to);
420     }
421 }