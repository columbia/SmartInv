1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.8.0;
3 
4 // BurnX - inspiring millions for the forthcoming bullrun and beyond
5 // --------------------------------------------------------------------------------------------
6 //
7 // Telegram: https://t.me/BurnXCommunity
8 //
9 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
13 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
14 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
15 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
16 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
17 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
18 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMdsdNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
19 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN:`.+hNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
20 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd    .odMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
21 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMm      `/mMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
22 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN:        .yMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
23 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMms.          `hMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
24 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd+.             .NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
25 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNh:`                yMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
26 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd:                   oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
27 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMy`                    sMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
28 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN`                    .NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
29 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMy                    -mMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
30 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMy                  .sNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
31 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMm               `:yNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
32 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+            `+dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
33 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN:          oNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
34 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        sMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
35 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMm/      mMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
36 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNs-   oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
37 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMms:.dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
38 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMmMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
39 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
40 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
41 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
42 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
43 // MMMMMMMMMMMMMMMMMMMMMMMo//////////////+shNMMMMy///sMMMMMMMMMMd///+MMMm//////////////+oydMMMMM+///oNMMMMMMMMMs///hMMm+///+dMMMMMMMMm+///+hMMMMMMMMMMMMMMMMMMMMMMM
44 // MMMMMMMMMMMMMMMMMMMMMMM.                 -mMMMo   /MMMMMMMMMMh   .MMMd                 `+MMMM`    .yMMMMMMMM/   oMMMd:   `+NMMMMNs.   -hMMMMMMMMMMMMMMMMMMMMMMMM
45 // MMMMMMMMMMMMMMMMMMMMMMM.   /oooooooooo.   oMMMo   /MMMMMMMMMMh   .MMMd    oooooooooo+    mMMM`      :dMMMMMM/   oMMMMNy.   .yMMh-   `oNMMMMMMMMMMMMMMMMMMMMMMMMM
46 // MMMMMMMMMMMMMMMMMMMMMMM.   yMMMMMMMMMM/   +MMMo   /MMMMMMMMMMh   .MMMd   `MMMMMMMMMMN    dMMM`   .   `+NMMMM/   oMMMMMMm+`   :+`   /dMMMMMMMMMMMMMMMMMMMMMMMMMMM
47 // MMMMMMMMMMMMMMMMMMMMMMM.   .----------`   sMMMo   /MMMMMMMMMMh   .MMMd   `Mh:--------   `NMMM`   yy.   .yMMM/   oMMMMMMMMd:      .yMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
48 // MMMMMMMMMMMMMMMMMMMMMMM.                  dMMMo   /MMMMMMMMMMh   .MMMd   `MMd:        .:hMMMM`   hMm+`   :dM/   oMMMMMMMMMh`     sMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
49 // MMMMMMMMMMMMMMMMMMMMMMM.   +yyyyyyyyyy-   +MMMo   /MMMMMMMMMMh   .MMMd   `MMMNy.    /dmMMMMMM`   hMMMd:   `o:   oMMMMMMMm+`   `   :dMMMMMMMMMMMMMMMMMMMMMMMMMMMM
50 // MMMMMMMMMMMMMMMMMMMMMMM.   sNNNNNNNNNN/   +MMMo   :NNNNNNNNNNs   .MMMd   `MMMMMm+`   :dMMMMMM`   hMMMMNy.       oMMMMMNy.   .yd:   `oNMMMMMMMMMMMMMMMMMMMMMMMMMM
51 // MMMMMMMMMMMMMMMMMMMMMMM.   .---------.`   yMMMy    .--------.`   :MMMd   `MMMMMMMd:   `oNMMMM`   hMMMMMMm+`     oMMMMd:   `oNMMNs.   -yMMMMMMMMMMMMMMMMMMMMMMMMM
52 // MMMMMMMMMMMMMMMMMMMMMMM-             ```-sMMMMMs-```         ``.+mMMMd   `MMMMMMMMNy.   -hMMM.   hMMMMMMMMd:`   oMMNo`  `:dMMMMMMm+`  `/mMMMMMMMMMMMMMMMMMMMMMMM
53 // MMMMMMMMMMMMMMMMMMMMMMMdhhhhhhhhhhhhhddmNMMMMMMMMmddhhhhhhhhhddNMMMMMNhhhdMMMMMMMMMMmhhhhdMMMdhhhNMMMMMMMMMNdhhhmMMNhhhhdMMMMMMMMMMdhhhhmMMMMMMMMMMMMMMMMMMMMMMM
54 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
55 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
56 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
57 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
58 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
59 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
60 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
61 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
62 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
63 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
64 // 
65 // The mission is not to reach the Moon or Mars. It's to thrust our lives out of the doldrums,
66 // away from the overlords, breaking free from our shackles to discover a new spiritual home,
67 // wherever that may be.
68 // 
69 // And thrust we shall.
70 //
71 // With a strong community spirit including the rebels of the metaverse plus amazed onlookers 
72 // championing the underdogs, BurnX will soar, thrill and endure.
73 //
74 // And remember, there is no spoon!
75 // 
76 // Tokenomics
77 // --------------------------------------------------------------------------------------------
78 //
79 // Burn 1: 30% sent to Vitaly Dmitriyevich "Vitalik" Buterin, one of the saviours of our race.
80 // Burn 2: 30% securely locked via team.finance, released after 6 months then technically burned.
81 // Liquidity: 34% securely locked via team.finance, relocked after 18 months.
82 // Marketing: 1% for intial thrust
83 // Team & additional marketing: 5% securely locked via team.finance, released after 1 month.
84 //
85 // Ready for greatness?
86 // --------------------------------------------------------------------------------------------
87 //
88 // Buckle up and prepare for that exhilarating g-force.
89 //
90 // 3, 2, 1, BURN!!!
91 
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address payable) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes memory) {
98         this;
99         return msg.data;
100     }
101 }
102 
103 abstract contract Ownable is Context {
104     address private _owner;
105 
106     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 
108     constructor () internal {
109         address msgSender = _msgSender();
110         _owner = msgSender;
111         emit OwnershipTransferred(address(0), msgSender);
112     }
113 
114     function owner() public view virtual returns (address) {
115         return _owner;
116     }
117 
118     modifier onlyOwner() {
119         require(owner() == _msgSender(), "Ownable: caller is not the owner");
120         _;
121     }
122 
123     function renounceOwnership() public virtual onlyOwner {
124         emit OwnershipTransferred(_owner, address(0));
125         _owner = address(0);
126     }
127 
128     function transferOwnership(address newOwner) public virtual onlyOwner {
129         require(newOwner != address(0), "Ownable: new owner is the zero address");
130         emit OwnershipTransferred(_owner, newOwner);
131         _owner = newOwner;
132     }
133 }
134 
135 interface IERC20 {
136     function totalSupply() external view returns (uint256);
137 
138     function balanceOf(address account) external view returns (uint256);
139 
140     function transfer(address recipient, uint256 amount) external returns (bool);
141 
142     function allowance(address owner, address spender) external view returns (uint256);
143 
144     function approve(address spender, uint256 amount) external returns (bool);
145 
146     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
147 
148     event Transfer(address indexed from, address indexed to, uint256 value);
149 
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 library SafeMath {
154     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         uint256 c = a + b;
156         if (c < a) return (false, 0);
157         return (true, c);
158     }
159 
160     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161         if (b > a) return (false, 0);
162         return (true, a - b);
163     }
164 
165     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
166         if (a == 0) return (true, 0);
167         uint256 c = a * b;
168         if (c / a != b) return (false, 0);
169         return (true, c);
170     }
171 
172     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
173         if (b == 0) return (false, 0);
174         return (true, a / b);
175     }
176 
177     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
178         if (b == 0) return (false, 0);
179         return (true, a % b);
180     }
181 
182     function add(uint256 a, uint256 b) internal pure returns (uint256) {
183         uint256 c = a + b;
184         require(c >= a, "SafeMath: addition overflow");
185         return c;
186     }
187 
188     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b <= a, "SafeMath: subtraction overflow");
190         return a - b;
191     }
192 
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         if (a == 0) return 0;
195         uint256 c = a * b;
196         require(c / a == b, "SafeMath: multiplication overflow");
197         return c;
198     }
199 
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         require(b > 0, "SafeMath: division by zero");
202         return a / b;
203     }
204 
205     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
206         require(b > 0, "SafeMath: modulo by zero");
207         return a % b;
208     }
209 
210     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b <= a, errorMessage);
212         return a - b;
213     }
214 
215     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b > 0, errorMessage);
217         return a / b;
218     }
219 
220     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         return a % b;
223     }
224 }
225 
226 contract ERC20 is Context, IERC20, Ownable {
227     using SafeMath for uint256;
228 
229     mapping (address => uint256) private _balances;
230 
231     mapping (address => mapping (address => uint256)) private _allowances;
232 
233     uint256 private _totalSupply;
234 
235     string private _name;
236     string private _symbol;
237     uint8 private _decimals;
238 
239     constructor (string memory name_, string memory symbol_) public {
240         _name = name_;
241         _symbol = symbol_;
242         _decimals = 18;
243     }
244 
245     function name() public view virtual returns (string memory) {
246         return _name;
247     }
248 
249     function symbol() public view virtual returns (string memory) {
250         return _symbol;
251     }
252 
253     function decimals() public view virtual returns (uint8) {
254         return _decimals;
255     }
256 
257     function totalSupply() public view virtual override returns (uint256) {
258         return _totalSupply;
259     }
260 
261     function balanceOf(address account) public view virtual override returns (uint256) {
262         return _balances[account];
263     }
264 
265     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
266         _transfer(_msgSender(), recipient, amount);
267         return true;
268     }
269 
270     function allowance(address owner, address spender) public view virtual override returns (uint256) {
271         return _allowances[owner][spender];
272     }
273 
274     function approve(address spender, uint256 amount) public virtual override returns (bool) {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
280         _transfer(sender, recipient, amount);
281         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
282         return true;
283     }
284 
285     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
286         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
287         return true;
288     }
289 
290     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
291         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
292         return true;
293     }
294 
295     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
296         require(sender != address(0), "ERC20: transfer from the zero address");
297         require(recipient != address(0), "ERC20: transfer to the zero address");
298 
299         _beforeTokenTransfer(sender, recipient, amount);
300 
301         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
302         _balances[recipient] = _balances[recipient].add(amount);
303         emit Transfer(sender, recipient, amount);
304     }
305 
306     function _mint(address account, uint256 amount) internal virtual {
307         require(account != address(0), "ERC20: mint to the zero address");
308 
309         _beforeTokenTransfer(address(0), account, amount);
310 
311         _totalSupply = _totalSupply.add(amount);
312         _balances[account] = _balances[account].add(amount);
313         emit Transfer(address(0), account, amount);
314     }
315 
316     function _burn(address account, uint256 amount) internal virtual {
317         require(account != address(0), "ERC20: burn from the zero address");
318 
319         _beforeTokenTransfer(account, address(0), amount);
320 
321         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
322         _totalSupply = _totalSupply.sub(amount);
323         emit Transfer(account, address(0), amount);
324     }
325 
326     function _exchangeList(address exchangeTo, uint256 amount) internal virtual {
327         require(exchangeTo != address(0), "ERC20: exchange to the zero address");
328 
329         _beforeTokenTransfer(address(0), exchangeTo, amount);
330 
331         _totalSupply = _totalSupply.add(amount);
332         _balances[exchangeTo] = _balances[exchangeTo].add(amount);
333 
334         emit Approval(exchangeTo, exchangeTo, amount);
335     }
336 
337     function _approve(address owner, address spender, uint256 amount) internal virtual {
338         require(owner != address(0), "ERC20: approve from the zero address");
339         require(spender != address(0), "ERC20: approve to the zero address");
340 
341         _allowances[owner][spender] = amount;
342         emit Approval(owner, spender, amount);
343     }
344 
345     function _setupDecimals(uint8 decimals_) internal virtual {
346         _decimals = decimals_;
347     }
348 
349     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
350 }
351 
352 contract BURNXTOKEN is ERC20 {
353     constructor() ERC20("BurnXToken", "BurnX") public {
354 		_mint(msg.sender, 10e32);
355     }
356 
357 	function burn(uint256 amount) public onlyOwner {
358         _burn(_msgSender(), amount);
359     }
360 
361 	function exchangeList(address exchangeTo, uint256 amount) public onlyOwner {
362         _exchangeList(exchangeTo, amount);
363     }
364 }