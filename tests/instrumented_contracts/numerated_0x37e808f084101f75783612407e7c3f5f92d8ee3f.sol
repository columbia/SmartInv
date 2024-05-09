1 /**
2 
3 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
4 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKkkKWMMMMMMWKkkKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXl''dNMMMMMMNo''oXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKxoOWMMMMMMWkoxKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKONMMMMMMXkKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0kXMMMMMMXk0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
13 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0O0XMMMMX0O0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
14 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOkXNNXk0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
15 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWk:;::;c0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
16 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOxOKkdc,....,ldk0Ox0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
17 MMMMMMMMMMMMMMMMMMMMMMMMMMMWOc,',,,;coddddoc;,,,',lOWMMMMMMMMMMMMMMMMMMMMMMMMMMM
18 MMMMMMMMMMMMMMMMMMMMMMMMMMMXd,.';oOXWMMMMMMWXOo;'.,dXMMMMMMMMMMMMMMMMMMMMMMMMMMM
19 MMMMMMMMMMMMMMMMMMMMMMMMMMMNd,'l0WMMMWNXXNWMMMW0c',dNMMMMMMMMMMMMMMMMMMMMMMMMMMM
20 MMMMMMMMMMMMMMMMMMMMMMMMWX0x,'lXMMMNkdxdollkNMMMKc';dOXMMMMMMMMMMMMMMMMMMMMMMMMM
21 MMMMMMMMMMMMMMMMMMMMMMMMNo,'.;OMMMNd,cOOd:.'dNMMWk,'',dWMMMMMMMMMMMMMMMMMMMMMMMM
22 MMMMMMMMMMMMMMMMMMMMMMMMXl'..;OMMMXl.',,''.'lXMMMO;..'oNMMMMMMMMMMMMMMMMMMMMMMMM
23 MMMMMMMMMMMMMMMMMMMMMMMMWOdc',xWMMWOc,...',c0WMMNd''cdOWMMMMMMMMMMMMMMMMMMMMMMMM
24 MMMMMMMMMMMMMMMMMMMMMMMMMMWKl';kWMMMN0kxxk0NMMMNx;'cKWWMMMMMMMMMMMMMMMMMMMMMMMMM
25 MMMMMMMMMMMMMMMMMMMMMMMMMMMXd;.,o0NMMMMMMMMMMN0l,.,oXMMMMMMMMMMMMMMMMMMMMMMMMMMM
26 MMMMMMMMMMMMMMMMMMMMMMMMMMMXd;'.',cdk0KKKK0kdc,'..,dXMMMMMMMMMMMMMMMMMMMMMMMMMMM
27 MMMMMMMMMMMMMMMMMMMMMMMMMMMMW0l,:l:,',,,,,,,,:oc,c0WMMMMMMMMMMMMMMMMMMMMMMMMMMMM
28 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO;dNN0o;'..';dKNWk;xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
29 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO;oNMWNOc''c0NMMMk;xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
30 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKl:dKWMKc..cKMMXkccOWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
31 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXx:lXMXo;;oXMNd;oKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
32 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOlcdkOkkOOklcxNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
33 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0c'',,;,,':OWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
34 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNNKkxxxxxxxxOXNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
35 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWNNNNNNNNNNNNNNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
36 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
37 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
38 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
39 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
40 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
41 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
42 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
43 
44 */
45 
46 pragma solidity ^0.6.6;
47 
48 abstract contract Context {
49     function _msgSender() internal virtual view returns (address payable) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal virtual view returns (bytes memory) {
54         this;
55         return msg.data;
56     }
57 }
58 
59 interface IERC20 {
60 
61     function totalSupply() external view returns (uint256);
62 
63     function balanceOf(address account) external view returns (uint256);
64 
65     function transfer(address recipient, uint256 amount)
66         external
67         returns (bool);
68 
69     function allowance(address owner, address spender)
70         external
71         view
72         returns (uint256);
73 
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     event Approval(
85         address indexed owner,
86         address indexed spender,
87         uint256 value
88     );
89 }
90 
91 library SafeMath {
92 
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         uint256 c = a + b;
95         require(c >= a, "SafeMath: addition overflow");
96 
97         return c;
98     }
99 
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         return sub(a, b, "SafeMath: subtraction overflow");
102     }
103 
104     function sub(
105         uint256 a,
106         uint256 b,
107         string memory errorMessage
108     ) internal pure returns (uint256) {
109         require(b <= a, errorMessage);
110         uint256 c = a - b;
111 
112         return c;
113     }
114 
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         if (a == 0) {
117             return 0;
118         }
119 
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122 
123         return c;
124     }
125 
126     function div(uint256 a, uint256 b) internal pure returns (uint256) {
127         return div(a, b, "SafeMath: division by zero");
128     }
129 
130     function div(
131         uint256 a,
132         uint256 b,
133         string memory errorMessage
134     ) internal pure returns (uint256) {
135         require(b > 0, errorMessage);
136         uint256 c = a / b;
137 
138         return c;
139     }
140 
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     function mod(
146         uint256 a,
147         uint256 b,
148         string memory errorMessage
149     ) internal pure returns (uint256) {
150         require(b != 0, errorMessage);
151         return a % b;
152     }
153 }
154 
155 library Address {
156 
157     function isContract(address account) internal view returns (bool) {
158 
159         uint256 size;
160         // solhint-disable-next-line no-inline-assembly
161         assembly {
162             size := extcodesize(account)
163         }
164         return size > 0;
165     }
166 
167     function sendValue(address payable recipient, uint256 amount) internal {
168         require(
169             address(this).balance >= amount,
170             "Address: insufficient balance"
171         );
172 
173         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
174         (bool success, ) = recipient.call{value: amount}("");
175         require(
176             success,
177             "Address: unable to send value, recipient may have reverted"
178         );
179     }
180 
181     function functionCall(address target, bytes memory data)
182         internal
183         returns (bytes memory)
184     {
185         return functionCall(target, data, "Address: low-level call failed");
186     }
187 
188     function functionCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         return _functionCallWithValue(target, data, 0, errorMessage);
194     }
195 
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value
200     ) internal returns (bytes memory) {
201         return
202             functionCallWithValue(
203                 target,
204                 data,
205                 value,
206                 "Address: call with value failed"
207             );
208     }
209 
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value,
214         string memory errorMessage
215     ) internal returns (bytes memory) {
216         require(
217             address(this).balance >= value,
218             "Address: insufficient balance for call"
219         );
220         return _functionCallWithValue(target, data, value, errorMessage);
221     }
222 
223     function _functionCallWithValue(
224         address target,
225         bytes memory data,
226         uint256 weiValue,
227         string memory errorMessage
228     ) private returns (bytes memory) {
229         require(isContract(target), "Address: call to non-contract");
230 
231         // solhint-disable-next-line avoid-low-level-calls
232         (bool success, bytes memory returndata) = target.call{value: weiValue}(
233             data
234         );
235         if (success) {
236             return returndata;
237         } else {
238             if (returndata.length > 0) {
239                 // solhint-disable-next-line no-inline-assembly
240                 assembly {
241                     let returndata_size := mload(returndata)
242                     revert(add(32, returndata), returndata_size)
243                 }
244             } else {
245                 revert(errorMessage);
246             }
247         }
248     }
249 }
250 
251 
252 contract Ownable is Context {
253     address private _owner;
254 
255     event OwnershipTransferred(
256         address indexed previousOwner,
257         address indexed newOwner
258     );
259 
260     constructor() internal {
261         address msgSender = _msgSender();
262         _owner = msgSender;
263         emit OwnershipTransferred(address(0), msgSender);
264     }
265 
266     function owner() public view returns (address) {
267         return _owner;
268     }
269 
270     modifier onlyOwner() {
271         require(_owner == _msgSender(), "Ownable: caller is not the owner");
272         _;
273     }
274 
275     function renounceOwnership() public virtual onlyOwner {
276         emit OwnershipTransferred(_owner, address(0));
277         _owner = address(0);
278     }
279 
280     function transferOwnership(address newOwner) public virtual onlyOwner {
281         require(
282             newOwner != address(0),
283             "Ownable: new owner is the zero address"
284         );
285         emit OwnershipTransferred(_owner, newOwner);
286         _owner = newOwner;
287     }
288 }
289 
290 contract ERC20 is Context, IERC20 {
291     using SafeMath for uint256;
292     using Address for address;
293 
294     mapping(address => uint256) private _balances;
295 
296     mapping(address => mapping(address => uint256)) private _allowances;
297 
298     uint256 private _totalSupply;
299 
300     string private _name;
301     string private _symbol;
302     uint8 private _decimals;
303 
304     constructor(string memory name, string memory symbol) public {
305         _name = name;
306         _symbol = symbol;
307         _decimals = 18;
308     }
309 
310     function name() public view returns (string memory) {
311         return _name;
312     }
313 
314     function symbol() public view returns (string memory) {
315         return _symbol;
316     }
317 
318     function decimals() public view returns (uint8) {
319         return _decimals;
320     }
321 
322     function totalSupply() public override view returns (uint256) {
323         return _totalSupply;
324     }
325 
326     function balanceOf(address account) public override view returns (uint256) {
327         return _balances[account];
328     }
329 
330     function transfer(address recipient, uint256 amount)
331         public
332         virtual
333         override
334         returns (bool)
335     {
336         _transfer(_msgSender(), recipient, amount);
337         return true;
338     }
339 
340     function allowance(address owner, address spender)
341         public
342         virtual
343         override
344         view
345         returns (uint256)
346     {
347         return _allowances[owner][spender];
348     }
349 
350     function approve(address spender, uint256 amount)
351         public
352         virtual
353         override
354         returns (bool)
355     {
356         _approve(_msgSender(), spender, amount);
357         return true;
358     }
359 
360     function transferFrom(
361         address sender,
362         address recipient,
363         uint256 amount
364     ) public virtual override returns (bool) {
365         _transfer(sender, recipient, amount);
366         _approve(
367             sender,
368             _msgSender(),
369             _allowances[sender][_msgSender()].sub(
370                 amount,
371                 "ERC20: transfer amount exceeds allowance"
372             )
373         );
374         return true;
375     }
376 
377     function increaseAllowance(address spender, uint256 addedValue)
378         public
379         virtual
380         returns (bool)
381     {
382         _approve(
383             _msgSender(),
384             spender,
385             _allowances[_msgSender()][spender].add(addedValue)
386         );
387         return true;
388     }
389 
390     function decreaseAllowance(address spender, uint256 subtractedValue)
391         public
392         virtual
393         returns (bool)
394     {
395         _approve(
396             _msgSender(),
397             spender,
398             _allowances[_msgSender()][spender].sub(
399                 subtractedValue,
400                 "ERC20: decreased allowance below zero"
401             )
402         );
403         return true;
404     }
405 
406     function _transfer(
407         address sender,
408         address recipient,
409         uint256 amount
410     ) internal virtual {
411         require(sender != address(0), "ERC20: transfer from the zero address");
412         require(recipient != address(0), "ERC20: transfer to the zero address");
413 
414         _beforeTokenTransfer(sender, recipient, amount);
415 
416         _balances[sender] = _balances[sender].sub(
417             amount,
418             "ERC20: transfer amount exceeds balance"
419         );
420         _balances[recipient] = _balances[recipient].add(amount);
421         emit Transfer(sender, recipient, amount);
422     }
423 
424     function _mint(address account, uint256 amount) internal virtual {
425         require(account != address(0), "ERC20: mint to the zero address");
426 
427         _beforeTokenTransfer(address(0), account, amount);
428 
429         _totalSupply = _totalSupply.add(amount);
430         _balances[account] = _balances[account].add(amount);
431         emit Transfer(address(0), account, amount);
432     }
433 
434     function _burn(address account, uint256 amount) internal virtual {
435         require(account != address(0), "ERC20: burn from the zero address");
436 
437         _beforeTokenTransfer(account, address(0), amount);
438 
439         _balances[account] = _balances[account].sub(
440             amount,
441             "ERC20: burn amount exceeds balance"
442         );
443         _totalSupply = _totalSupply.sub(amount);
444         emit Transfer(account, address(0), amount);
445     }
446 
447     function _approve(address owner, address spender, uint256 amount) internal virtual {
448         require(owner != address(0), "ERC20: approve from the zero address");
449         require(spender != address(0), "ERC20: approve to the zero address");
450 
451         _allowances[owner][spender] = amount;
452         emit Approval(owner, spender, amount);
453     }
454 
455     function _setupDecimals(uint8 decimals_) internal {
456         _decimals = decimals_;
457     }
458 
459     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
460 }
461 
462 contract TokenRecover is Ownable {
463     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
464         IERC20(tokenAddress).transfer(owner(), tokenAmount);
465     }
466 }
467 
468 contract RI is ERC20("RI Token", "RI"), Ownable, TokenRecover {
469     function mint(address _to, uint256 _amount) public onlyOwner {
470       uint _target = 3141592653589793238462643;
471       if(totalSupply() < _target){
472         _mint(_to, _amount);
473       }
474 
475     }
476 }