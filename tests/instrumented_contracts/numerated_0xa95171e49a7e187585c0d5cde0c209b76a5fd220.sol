1 pragma solidity ^0.5.0;
2 
3 
4 interface IERC20 {
5     function transfer(address to, uint256 value) external returns (bool);
6 
7     function approve(address spender, uint256 value) external returns (bool);
8 
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address who) external view returns (uint256);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b);
30 
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b > 0);
36         uint256 c = a / b;
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a);
50 
51         return c;
52     }
53 
54     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
55         require(b != 0);
56         return a % b;
57     }
58 }
59 
60 library SafeERC20 {
61     using SafeMath for uint256;
62 
63     function safeTransfer(IERC20 token, address to, uint256 value) internal {
64         require(token.transfer(to, value));
65     }
66 
67     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
68         require(token.transferFrom(from, to, value));
69     }
70 
71     function safeApprove(IERC20 token, address spender, uint256 value) internal {
72         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
73         require(token.approve(spender, value));
74     }
75 
76     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
77         uint256 newAllowance = token.allowance(address(this), spender).add(value);
78         require(token.approve(spender, newAllowance));
79     }
80 
81     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
82         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
83         require(token.approve(spender, newAllowance));
84     }
85 }
86 
87 contract ReentrancyGuard {
88     uint256 private _guardCounter;
89 
90     constructor () internal {
91         _guardCounter = 1;
92     }
93 
94     modifier nonReentrant() {
95         _guardCounter += 1;
96         uint256 localCounter = _guardCounter;
97         _;
98         require(localCounter == _guardCounter);
99     }
100 }
101 
102 contract Crowdsale is ReentrancyGuard {
103     using SafeMath for uint256;
104     using SafeERC20 for IERC20;
105     IERC20 private _token;
106 
107     address payable private _wallet;
108 
109     uint256 private _rate;
110 
111     uint256 private _weiRaised;
112 
113      event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
114 
115     constructor (uint256 rate, address payable wallet, IERC20 token) public {
116         require(rate > 0);
117         require(wallet != address(0));
118         require(address(token) != address(0));
119 
120         _rate = rate;
121         _wallet = wallet;
122         _token = token;
123     }
124 
125     function () external payable {
126         buyTokens(msg.sender);
127     }
128 
129     function token() public view returns (IERC20) {
130         return _token;
131     }
132 
133     function wallet() public view returns (address payable) {
134         return _wallet;
135     }
136 
137     function rate() public view returns (uint256) {
138         return _rate;
139     }
140 
141     function weiRaised() public view returns (uint256) {
142         return _weiRaised;
143     }
144 
145     function buyTokens(address beneficiary) public nonReentrant payable {
146         uint256 weiAmount = msg.value;
147         _preValidatePurchase(beneficiary, weiAmount);
148 
149         uint256 tokens = _getTokenAmount(weiAmount);
150 
151         _weiRaised = _weiRaised.add(weiAmount);
152 
153         _processPurchase(beneficiary, tokens);
154         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
155 
156         _updatePurchasingState(beneficiary, weiAmount);
157 
158         _forwardFunds();
159         _postValidatePurchase(beneficiary, weiAmount);
160     }
161 
162     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
163         require(beneficiary != address(0));
164         require(weiAmount != 0);
165     }
166 
167     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
168     }
169 
170     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
171         _token.safeTransfer(beneficiary, tokenAmount);
172     }
173 
174     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
175         _deliverTokens(beneficiary, tokenAmount);
176     }
177 
178     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
179     }
180 
181     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
182         if (weiAmount < 5 ether) return weiAmount.mul(_rate);
183         
184         if (weiAmount >= 5 ether && weiAmount < 10 ether) return weiAmount.mul(1666); //$0.09 per token
185         else if (weiAmount >= 10 ether && weiAmount < 100 ether) return weiAmount.mul(1724); //$0.087 per token   
186         else if (weiAmount >= 100 ether && weiAmount < 500 ether) return weiAmount.mul(1764); //$0.085 per token   
187         else if (weiAmount >= 500 ether && weiAmount < 1000 ether) return weiAmount.mul(1875); //$0.080 per token   
188         else if (weiAmount >= 1000 ether && weiAmount < 10000 ether) return weiAmount.mul(2000); //$0.075 per token   
189         else if (weiAmount >= 10000 ether && weiAmount < 20000 ether) return weiAmount.mul(2307); //$0.065 per token   
190         else if (weiAmount >= 20000 ether && weiAmount < 50000 ether) return weiAmount.mul(2727); //$0.055 per token  
191         else if (weiAmount >= 50000 ether) return weiAmount.mul(3000); //$0.05 per token  
192     }
193 
194     function _forwardFunds() internal {
195         _wallet.transfer(msg.value);
196     }
197 }
198 contract ERC20 is IERC20 {
199     using SafeMath for uint256;
200 
201     mapping (address => uint256) private _balances;
202 
203     mapping (address => mapping (address => uint256)) private _allowed;
204 
205     uint256 private _totalSupply;
206 
207     function totalSupply() public view returns (uint256) {
208         return _totalSupply;
209     }
210 
211     function balanceOf(address owner) public view returns (uint256) {
212         return _balances[owner];
213     }
214 
215     function allowance(address owner, address spender) public view returns (uint256) {
216         return _allowed[owner][spender];
217     }
218 
219     function transfer(address to, uint256 value) public returns (bool) {
220         _transfer(msg.sender, to, value);
221         return true;
222     }
223 
224 
225     function approve(address spender, uint256 value) public returns (bool) {
226         require(spender != address(0));
227 
228         _allowed[msg.sender][spender] = value;
229         emit Approval(msg.sender, spender, value);
230         return true;
231     }
232 
233     function transferFrom(address from, address to, uint256 value) public returns (bool) {
234         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
235         _transfer(from, to, value);
236         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
237         return true;
238     }
239 
240     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
241         require(spender != address(0));
242 
243         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
244         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
245         return true;
246     }
247 
248     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
249         require(spender != address(0));
250 
251         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
252         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
253         return true;
254     }
255 
256     function _transfer(address from, address to, uint256 value) internal {
257         require(to != address(0));
258 
259         _balances[from] = _balances[from].sub(value);
260         _balances[to] = _balances[to].add(value);
261         emit Transfer(from, to, value);
262     }
263 
264     function _mint(address account, uint256 value) internal {
265         require(account != address(0));
266 
267         _totalSupply = _totalSupply.add(value);
268         _balances[account] = _balances[account].add(value);
269         emit Transfer(address(0), account, value);
270     }
271 
272     function _burn(address account, uint256 value) internal {
273         require(account != address(0));
274 
275         _totalSupply = _totalSupply.sub(value);
276         _balances[account] = _balances[account].sub(value);
277         emit Transfer(account, address(0), value);
278     }
279 
280     function _burnFrom(address account, uint256 value) internal {
281         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
282         _burn(account, value);
283         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
284     }
285 }
286 
287 library Roles {
288     struct Role {
289         mapping (address => bool) bearer;
290     }
291 
292 
293     function add(Role storage role, address account) internal {
294         require(account != address(0));
295         require(!has(role, account));
296 
297         role.bearer[account] = true;
298     }
299 
300 
301     function remove(Role storage role, address account) internal {
302         require(account != address(0));
303         require(has(role, account));
304 
305         role.bearer[account] = false;
306     }
307 
308     function has(Role storage role, address account) internal view returns (bool) {
309         require(account != address(0));
310         return role.bearer[account];
311     }
312 }
313 
314 contract MinterRole {
315     using Roles for Roles.Role;
316 
317     event MinterAdded(address indexed account);
318     event MinterRemoved(address indexed account);
319 
320     Roles.Role private _minters;
321 
322     constructor () internal {
323         _addMinter(msg.sender);
324     }
325 
326     modifier onlyMinter() {
327         require(isMinter(msg.sender));
328         _;
329     }
330 
331     function isMinter(address account) public view returns (bool) {
332         return _minters.has(account);
333     }
334 
335     function addMinter(address account) public onlyMinter {
336         _addMinter(account);
337     }
338 
339     function renounceMinter() public {
340         _removeMinter(msg.sender);
341     }
342 
343     function _addMinter(address account) internal {
344         _minters.add(account);
345         emit MinterAdded(account);
346     }
347 
348     function _removeMinter(address account) internal {
349         _minters.remove(account);
350         emit MinterRemoved(account);
351     }
352 }
353 
354 contract ERC20Mintable is ERC20, MinterRole {
355     function mint(address to, uint256 value) public onlyMinter returns (bool) {
356         _mint(to, value);
357         return true;
358     }
359 }
360 
361 contract MintedCrowdsale is Crowdsale {
362     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
363         require(ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
364     }
365 }
366 
367 contract CappedCrowdsale is Crowdsale {
368     using SafeMath for uint256;
369 
370     uint256 private _cap;
371 
372     constructor (uint256 cap) public {
373         require(cap > 0);
374         _cap = cap;
375     }
376 
377     function cap() public view returns (uint256) {
378         return _cap;
379     }
380 
381     function capReached() public view returns (bool) {
382         return weiRaised() >= _cap;
383     }
384 
385     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
386         super._preValidatePurchase(beneficiary, weiAmount);
387         require(weiRaised().add(weiAmount) <= _cap);
388     }
389 }
390 
391 contract TimedCrowdsale is Crowdsale {
392     using SafeMath for uint256;
393 
394     uint256 private _openingTime;
395     uint256 private _closingTime;
396 
397     modifier onlyWhileOpen {
398         require(isOpen());
399         _;
400     }
401 
402     constructor (uint256 openingTime, uint256 closingTime) public {
403         require(closingTime > openingTime);
404 
405         _openingTime = openingTime;
406         _closingTime = closingTime;
407     }
408 
409     function openingTime() public view returns (uint256) {
410         return _openingTime;
411     }
412 
413     function closingTime() public view returns (uint256) {
414         return _closingTime;
415     }
416 
417     function isOpen() public view returns (bool) {
418         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
419     }
420 
421     function hasClosed() public view returns (bool) {
422         return block.timestamp > _closingTime;
423     }
424 
425     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
426         super._preValidatePurchase(beneficiary, weiAmount);
427     }
428 }
429 
430 
431 contract GRAMSale is CappedCrowdsale, TimedCrowdsale, MintedCrowdsale {
432  constructor(
433   uint256 _openingTime,
434   uint256 _closingTime,
435   uint256 _rate,
436   address payable _wallet,
437   uint256 _cap,
438   ERC20Mintable _token
439  )
440   public
441   Crowdsale(_rate, _wallet, _token)
442   CappedCrowdsale(_cap)
443   TimedCrowdsale(_openingTime, _closingTime)
444  {
445 
446  }
447 }