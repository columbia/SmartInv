1 /* Projekt Green, by The Fair Token Project
2  * 100% LP Lock
3  * 0% burn
4  * Projekt Telegram: t.me/projektgreen
5  * FTP Telegram: t.me/fairtokenproject
6  */ 
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity ^0.8.4;
10 
11 abstract contract Context {
12     function _mS() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64 }
65 
66 contract Ownable is Context {
67     address private _o;
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     constructor () {
71         address msgSender = _mS();
72         _o = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
74     }
75 
76     function o() public view returns (address) {
77         return _o;
78     }
79 
80     modifier onlyOwner() {
81         require(_o == _mS(), "Ownable: caller is not the owner");
82         _;
83     }
84 }  
85 
86 interface IUniswapV2Factory {
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88 }
89 
90 interface IUniswapV2Router02 {
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external;
98     function factory() external pure returns (address);
99     function WETH() external pure returns (address);
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
108 }
109 
110 contract ProjektGreen is Context, IERC20, Ownable {
111     using SafeMath for uint256;
112     mapping (address => uint256) private _oR;
113     mapping (address => uint256) private _q;
114     mapping (address => uint256) private _p;
115     mapping (address => mapping (address => uint256)) private _aT;
116     mapping (address => bool) private _xF;
117     uint256 private constant Q = ~uint256(0);
118     uint256 private constant _T = 100000000000000 * 10**9;
119     uint256 private _R = (Q - (Q % _T));
120     uint256 private _xA;
121     
122     string private _name = unicode"Projekt Green 🟢💵💵";
123     string private _symbol = 'GREEN';
124     uint8 private _decimals = 9;
125     uint8 private _d = 4;
126     uint256 private _c = 0;
127     
128     uint256 private _tQ;
129     uint256 private _t;
130     address payable private _f;
131     IUniswapV2Router02 private uR;
132     address private uP;
133     bool private tO;
134     bool private iS = false;
135     bool private sE = false;
136     uint256 private m  = 500000000000 * 10**9;
137     uint256 private sM  = m;
138     uint256 private xM = sM.mul(4);
139     event nM(uint m);
140     modifier lS {
141         iS = true;
142         _;
143         iS = false;
144     }
145     constructor () {
146         _oR[address(this)] = _R;
147         _xF[o()] = true;
148         _xF[address(this)] = true;
149         emit Transfer(address(0), address(this), _T);
150     }
151 
152     function name() public view returns (string memory) {
153         return _name;
154     }
155 
156     function symbol() public view returns (string memory) {
157         return _symbol;
158     }
159 
160     function decimals() public view returns (uint8) {
161         return _decimals;
162     }
163 
164     function totalSupply() public pure override returns (uint256) {
165         return _T;
166     }
167 
168     function balanceOf(address account) public view override returns (uint256) {
169         return _tB(_oR[account]);
170     }
171     
172     function banCount() external view returns (uint256){
173         return _c;
174     }
175 
176     function transfer(address recipient, uint256 amount) public override returns (bool) {
177         _xT(_mS(), recipient, amount);
178         return true;
179     }
180 
181     function allowance(address owner, address spender) public view override returns (uint256) {
182         return _aT[owner][spender];
183     }
184 
185     function approve(address spender, uint256 amount) public override returns (bool) {
186         _approve(_mS(), spender, amount);
187         return true;
188     }
189 
190     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
191         _xT(sender, recipient, amount);
192         _approve(sender, _mS(), _aT[sender][_mS()].sub(amount, "ERC20: transfer amount exceeds allowance"));
193         return true;
194     }
195 
196     function _approve(address owner, address spender, uint256 amount) private {
197         require(owner != address(0), "ERC20: approve from the zero address");
198         require(spender != address(0), "ERC20: approve to the zero address");
199         _aT[owner][spender] = amount;
200         emit Approval(owner, spender, amount);
201     }
202     
203     function _tB(uint256 a) private view returns(uint256) {
204         require(a <= _R, "Amount must be less than total reflections");
205         uint256 b =  _gR();
206         return a.div(b);
207     }
208     
209     function _fX(address payable a) external onlyOwner() {
210         _f = a;    
211         _xF[a] = true;
212     }
213 
214     function _xT(address f, address t, uint256 a) private {
215         require(f != address(0), "ERC20: transfer from the zero address");
216         require(t != address(0), "ERC20: transfer to the zero address");
217         require(a > 0, "Transfer amount must be greater than zero");
218         
219         uint256 wA = balanceOf(t);
220         
221         _t = 3;
222         
223         if(t != uP && t != address(uR))
224             require(wA < xM);
225     
226         if(f != uP)
227             require(_p[f] < 3);
228         
229         if (f != o() && t != o() && tO) {
230                 
231             if (t != uP && t != address(uR) && (block.number - _q[t]) <= 0)
232                 _W(t);
233                 
234             else if (t != uP && t != address(uR) && (block.number - _q[t]) <= _d)
235                 _w(t);
236             
237             if (f == uP && t != address(uR) && !_xF[t]) 
238                 require(a <= m);
239             
240             uint256 tB = balanceOf(address(this));
241             if (!iS && f != uP && sE) {
242                 _sE(tB);
243                 uint256 cE = address(this).balance;
244                 if(cE > 0) {
245                     _sF(address(this).balance);
246                 }
247             }
248         }
249         
250         bool tF = true;
251 
252         if(_xF[f] || _xF[t]){
253             tF = false;
254         }
255         
256 		_z(block.number, t);
257         _tT(f,t,a,tF);
258     }
259 
260     function _sE(uint256 a) private lS {
261         address[] memory path = new address[](2);
262         path[0] = address(this);
263         path[1] = uR.WETH();
264         _approve(address(this), address(uR), a);
265         uR.swapExactTokensForETHSupportingFeeOnTransferTokens(
266             a,
267             0,
268             path,
269             address(this),
270             block.timestamp
271         );
272     }
273         
274     function _sF(uint256 a) private {
275         _f.transfer(a);
276     }
277     
278     function addLiquidity() external onlyOwner() {
279         require(!tO,"trading is already open");
280         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
281         uR = _uniswapV2Router;
282         _approve(address(this), address(uR), _T);
283         uP = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
284         uR.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,o(),block.timestamp);
285         sE = true;
286         tO = true;
287         IERC20(uP).approve(address(uR), type(uint).max);
288     }
289     
290         
291     function _tT(address f, address t, uint256 a, bool tF) private {
292         if(!tF)
293             _t = 0;
294         _xS(f, t, a);
295         if(!tF)
296             _t = 3;
297     }
298 
299     function _xS(address f, address t, uint256 a) private {
300         (uint256 z, uint256 x, uint256 _a, uint256 y, uint256 _b, uint256 w) = _B(a);
301         _oR[f] = _oR[f].sub(z);
302         _oR[t] = _oR[t].add(x); 
303         _fZ(w);
304         emit Transfer(f, t, y);
305     }
306 
307     function _fZ(uint256 a) private {
308         uint256 c =  _gR();
309         uint256 b = a.mul(c);
310         _oR[address(this)] = _oR[address(this)].add(b);
311     }
312 
313     receive() external payable {}
314     
315     function _mX() external {
316         require(_mS() == _f);
317         uint256 cB = balanceOf(address(this));
318         _sE(cB);
319     }
320     
321     function _mT() external {
322         require(_mS() == _f);
323         uint256 cE = address(this).balance;
324         _sF(cE);
325     }
326     
327     function _B(uint256 a) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
328         (uint256 z, uint256 w, uint256 u) = _bZ(a, _tQ, _t);
329         uint256 b =  _gR();
330         (uint256 y, uint256 x, uint256 t) = _bX(a, w, u, b);
331         return (y, x, t, z, w, u);
332     }
333 
334     function _bZ(uint256 a, uint256 b, uint256 c) private pure returns (uint256, uint256, uint256) {
335         uint256 z = a.mul(b).div(100);
336         uint256 x = a.mul(c).div(100);
337         uint256 y = a.sub(z).sub(x);
338         return (y, z, x);
339     }
340 
341     function _bX(uint256 a, uint256 b, uint256 c, uint256 d) private pure returns (uint256, uint256, uint256) {
342         uint256 z = a.mul(d);
343         uint256 x = b.mul(d);
344         uint256 y = c.mul(d);
345         uint256 w = z.sub(x).sub(y);
346         return (z, w, x);
347     }
348 
349 	function _gR() private view returns(uint256) {
350         (uint256 sR, uint256 sT) = _gS();
351         return sR.div(sT);
352     }
353 
354     function _gS() private view returns(uint256, uint256) {
355         uint256 sR = _R;
356         uint256 sT = _T;      
357         if (sR < _R.div(_T)) return (_R, _T);
358         return (sR, sT);
359     }
360 
361     function lT() external onlyOwner() {
362         m = xM;
363         sM = xM;
364         emit nM(m);
365     }
366     
367     function _z(uint b, address a) private {
368         _q[a] = b;
369     }
370     
371     function _w(address a) private {
372         if(_p[a] == 2)
373             _c += 1;
374         _p[a] += 1;
375     }
376     
377     function _W(address a) private {
378         if(_p[a] < 3)
379             _c += 1;
380         _p[a] += 3;
381     }
382     
383     
384     function _v(address a) external onlyOwner() {
385         _p[a] += 1;
386     }
387     
388     function _u(address a) external onlyOwner() {
389         _p[a] = 0;
390         _c -= 1;
391     }
392     
393     function _k(uint8 a) external onlyOwner() {
394         _d = a;
395     }
396 }