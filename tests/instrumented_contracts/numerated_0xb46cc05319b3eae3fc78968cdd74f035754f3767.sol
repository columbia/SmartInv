1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-29
3 */
4 
5 /*! lk.sol | (c) 2019 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
6 
7 pragma solidity 0.5.7;
8 
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if(a == 0) return 0;
12         uint256 c = a * b;
13         require(c / a == b, "SafeMath: multiplication overflow");
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         require(b > 0, "SafeMath: division by zero");
19         return a / b;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a, "SafeMath: subtraction overflow");
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32 
33     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b != 0, "SafeMath: modulo by zero");
35         return a % b;
36     }
37 }
38 
39 contract Ownable {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     constructor() internal {
45         _owner = msg.sender;
46         emit OwnershipTransferred(address(0), _owner);
47     }
48 
49     function owner() public view returns (address) {
50         return _owner;
51     }
52 
53     modifier onlyOwner() {
54         require(isOwner(), "Ownable: caller is not the owner");
55         _;
56     }
57 
58     function isOwner() public view returns (bool) {
59         return msg.sender == _owner;
60     }
61 
62     function renounceOwnership() public onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     function transferOwnership(address newOwner) public onlyOwner {
68         _transferOwnership(newOwner);
69     }
70 
71     function _transferOwnership(address newOwner) internal {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 interface IERC20 {
79     event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 
82     function transfer(address to, uint256 value) external returns (bool);
83     function approve(address spender, uint256 value) external returns (bool);
84     function transferFrom(address from, address to, uint256 value) external returns (bool);
85     function totalSupply() external view returns (uint256);
86     function balanceOf(address who) external view returns (uint256);
87     function allowance(address owner, address spender) external view returns (uint256);
88 }
89 
90 contract StandardToken is IERC20 {
91     using SafeMath for uint256;
92 
93     mapping (address => uint256) private _balances;
94     mapping (address => mapping (address => uint256)) private _allowed;
95 
96     uint256 private _totalSupply;
97     string private _name;
98     string private _symbol;
99     uint8 private _decimals;
100 
101     constructor(string memory name, string memory symbol, uint8 decimals) public {
102         _name = name;
103         _symbol = symbol;
104         _decimals = decimals;
105     }
106 
107     function name() public view returns (string memory) {
108         return _name;
109     }
110 
111     function symbol() public view returns (string memory) {
112         return _symbol;
113     }
114 
115     function decimals() public view returns (uint8) {
116         return _decimals;
117     }
118 
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     function balanceOf(address owner) public view returns (uint256) {
124         return _balances[owner];
125     }
126 
127     function allowance(address owner, address spender) public view returns (uint256) {
128         return _allowed[owner][spender];
129     }
130     
131     function transfer(address to, uint256 value) public returns (bool) {
132         _transfer(msg.sender, to, value);
133         return true;
134     }
135 
136     function multiTransfer(address[] memory to, uint256[] memory value) public returns (bool) {
137         require(to.length > 0 && to.length == value.length, "Invalid params");
138 
139         for(uint i = 0; i < to.length; i++) {
140             _transfer(msg.sender, to[i], value[i]);
141         }
142 
143         return true;
144     }
145 
146     function approve(address spender, uint256 value) public returns (bool) {
147         _approve(msg.sender, spender, value);
148         return true;
149     }
150 
151     function transferFrom(address from, address to, uint256 value) public returns (bool) {
152         _transfer(from, to, value);
153         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
154         return true;
155     }
156 
157     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
158         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
159         return true;
160     }
161 
162     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
163         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
164         return true;
165     }
166 
167     function _transfer(address from, address to, uint256 value) internal {
168         require(to != address(0), "ERC20: transfer to the zero address");
169 
170         _balances[from] = _balances[from].sub(value);
171         _balances[to] = _balances[to].add(value);
172 
173         emit Transfer(from, to, value);
174     }
175 
176     function _mint(address account, uint256 value) internal {
177         require(account != address(0), "ERC20: mint to the zero address");
178 
179         _totalSupply = _totalSupply.add(value);
180         _balances[account] = _balances[account].add(value);
181 
182         emit Transfer(address(0), account, value);
183     }
184     
185     function _burn(address account, uint256 value) internal {
186         require(account != address(0), "ERC20: burn from the zero address");
187 
188         _totalSupply = _totalSupply.sub(value);
189         _balances[account] = _balances[account].sub(value);
190 
191         emit Transfer(account, address(0), value);
192     }
193     
194     function _approve(address owner, address spender, uint256 value) internal {
195         require(owner != address(0), "ERC20: approve from the zero address");
196         require(spender != address(0), "ERC20: approve to the zero address");
197 
198         _allowed[owner][spender] = value;
199 
200         emit Approval(owner, spender, value);
201     }
202     
203     function _burnFrom(address account, uint256 value) internal {
204         _burn(account, value);
205         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
206     }
207 }
208 
209 contract MintableToken is StandardToken, Ownable {
210     bool public mintingFinished = false;
211 
212     event MintFinished(address account);
213 
214     modifier canMint() {
215         require(!mintingFinished);
216         _;
217     }
218 
219     function finishMinting() onlyOwner canMint public returns(bool) {
220         mintingFinished = true;
221 
222         emit MintFinished(msg.sender);
223         return true;
224     }
225 
226     function mint(address to, uint256 value) public canMint onlyOwner returns (bool) {
227         _mint(to, value);
228         return true;
229     }
230 }
231 
232 contract CappedToken is MintableToken {
233     uint256 private _cap;
234 
235     constructor(uint256 cap) public {
236         require(cap > 0, "ERC20Capped: cap is 0");
237 
238         _cap = cap;
239     }
240 
241     function cap() public view returns (uint256) {
242         return _cap;
243     }
244 
245     function _mint(address account, uint256 value) internal {
246         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
247         super._mint(account, value);
248     }
249 }
250 
251 contract BurnableToken is StandardToken {
252     function burn(uint256 value) public {
253         _burn(msg.sender, value);
254     }
255 
256     function burnFrom(address from, uint256 value) public {
257         _burnFrom(from, value);
258     }
259 }
260 
261 contract Withdrawable is Ownable {
262     event WithdrawEther(address indexed to, uint value);
263 
264     function withdrawEther(address payable _to, uint _value) onlyOwner public {
265         require(_to != address(0));
266         require(address(this).balance >= _value);
267 
268         address(_to).transfer(_value);
269 
270         emit WithdrawEther(_to, _value);
271     }
272 
273     function withdrawTokensTransfer(IERC20 _token, address _to, uint256 _value) onlyOwner public {
274         require(_token.transfer(_to, _value));
275     }
276 
277     function withdrawTokensTransferFrom(IERC20 _token, address _from, address _to, uint256 _value) onlyOwner public {
278         require(_token.transferFrom(_from, _to, _value));
279     }
280 
281     function withdrawTokensApprove(IERC20 _token, address _spender, uint256 _value) onlyOwner public {
282         require(_token.approve(_spender, _value));
283     }
284 }
285 
286 contract Pausable is Ownable {
287     event Paused(address account);
288     event Unpaused(address account);
289 
290     bool private _paused;
291 
292     constructor() internal {
293         _paused = false;
294     }
295 
296     function paused() public view returns (bool) {
297         return _paused;
298     }
299 
300     modifier whenNotPaused() {
301         require(!_paused, "Pausable: paused");
302         _;
303     }
304 
305     modifier whenPaused() {
306         require(_paused, "Pausable: not paused");
307         _;
308     }
309 
310     function pause() public onlyOwner whenNotPaused {
311         _paused = true;
312 
313         emit Paused(msg.sender);
314     }
315 
316     function unpause() public onlyOwner whenPaused {
317         _paused = false;
318 
319         emit Unpaused(msg.sender);
320     }
321 }
322 
323 contract Manageable is Ownable {
324     address[] public managers;
325 
326     event ManagerAdded(address indexed manager);
327     event ManagerRemoved(address indexed manager);
328 
329     modifier onlyManager() { require(isManager(msg.sender)); _; }
330 
331     function countManagers() view public returns(uint) {
332         return managers.length;
333     }
334 
335     function getManagers() view public returns(address[] memory) {
336         return managers;
337     }
338 
339     function isManager(address _manager) view public returns(bool) {
340         for(uint i = 0; i < managers.length; i++) {
341             if(managers[i] == _manager) {
342                 return true;
343             }
344         }
345         return false;
346     }
347 
348     function addManager(address _manager) onlyOwner public {
349         require(_manager != address(0));
350         require(!isManager(_manager));
351 
352         managers.push(_manager);
353 
354         emit ManagerAdded(_manager);
355     }
356 
357     function removeManager(address _manager) onlyOwner public {
358         uint index = managers.length;
359         for(uint i = 0; i < managers.length; i++) {
360             if(managers[i] == _manager) {
361                 index = i;
362             }
363         }
364 
365         if(index >= managers.length) revert();
366 
367         for(; index < managers.length - 1; index++) {
368             managers[index] = managers[index + 1];
369         }
370         
371         managers.length--;
372         emit ManagerRemoved(_manager);
373     }
374 }
375 
376 
377 contract Token is CappedToken, BurnableToken, Withdrawable {
378     constructor() CappedToken(58700000 * 1e8) StandardToken("Kernel", "KNL", 8) public {
379         
380     }
381 }
382 
383 contract Crowdsale is Manageable, Withdrawable, Pausable {
384     using SafeMath for uint;
385 
386     Token public token;
387     bool public crowdsaleClosed = false;
388 
389     event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);
390     event CrowdsaleClose();
391    
392     constructor() public {
393         token = new Token();
394     }
395 
396     function externalPurchase(address _to, string memory _tx, string memory _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager public {
397         require(!crowdsaleClosed);
398         require(_to != address(0));
399 
400         token.mint(_to, _tokens);
401         emit ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);
402     }
403 
404     function closeCrowdsale(address _newTokenOwner) onlyOwner external {
405         require(!crowdsaleClosed);
406         require(_newTokenOwner != address(0));
407 
408         token.finishMinting();
409         token.transferOwnership(_newTokenOwner);
410 
411         crowdsaleClosed = true;
412 
413         emit CrowdsaleClose();
414     }
415     
416     function transferTokenOwnership(address _to) onlyOwner external {
417         require(crowdsaleClosed);
418         require(_to != address(0));
419 
420         token.transferOwnership(_to);
421     }
422 }