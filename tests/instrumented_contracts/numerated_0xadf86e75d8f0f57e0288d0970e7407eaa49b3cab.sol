1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity >=0.8.0 <0.9.0;
5 
6 //Use 0.8.3
7 
8 library SafeMath {
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         return a / b;
12     }
13 
14 
15     function sub(
16         uint256 a,
17         uint256 b,
18         string memory errorMessage
19     ) internal pure returns (uint256) {
20         unchecked {
21             require(b <= a, errorMessage);
22             return a - b;
23         }
24     }
25 
26     
27 }
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 interface IUniswapV2Router02 {
40     function factory() external pure returns (address);
41     function WETH() external pure returns (address);
42 }
43 
44 interface IUniswapV2Factory {
45     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
46     function getPair(address tokenA, address tokenB) external view returns (address pair);
47     function createPair(address tokenA, address tokenB) external returns (address pair);
48 }
49 
50 interface IERC20 {
51     function totalSupply() external view returns (uint256);
52     function balanceOf(address account) external view returns (uint256);
53     function transfer(address recipient, uint256 amount) external returns (bool);
54     function allowance(address owner, address spender) external view returns (uint256);
55     function approve(address spender, uint256 amount) external returns (bool);
56     function transferFrom(
57         address sender,
58         address recipient,
59         uint256 amount
60     ) external returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 
66 
67 contract ApolloInu is IERC20, Context {
68     using SafeMath for uint256;
69 
70     mapping (address => uint256) private _rOwned;
71     mapping (address => uint256) private _tOwned;
72     mapping (address => mapping (address => uint256)) private _allowances;
73 
74     mapping (address => bool) private _isExcludedFromReflection;
75     address[] private _excludedFromReflection;
76    
77     uint256 private constant MAX = ~uint256(0);
78     uint256 private constant _tTotal = 2 * 10**12 * 10**9;
79     uint256 public rTotal = (MAX - (MAX % _tTotal));
80     uint256 public tFeeTotal;
81 
82     string private _name = 'Apollo Inu';
83     string private _symbol = 'APOLLO';
84     uint8 private _decimals = 9;
85     
86     uint256 public reflectionFee = 3;
87     uint256 public burnFee = 2;
88     uint256 public artistFee = 1;
89     
90     uint256 private _previousReflectionFee = 0;
91     uint256 private _previousBurnFee = 0;
92     uint256 private _previousArtistFee = 0;
93     
94     address public burnAddress = address(0);
95     address public artistDAO;
96     
97     address[] private _excludedFromFees;
98 
99     IUniswapV2Router02 public uniswapRouter;
100     address public ethPair;
101     
102     event newDaoAddress(address indexed newDAO);
103 
104     constructor () {
105         _rOwned[_msgSender()] = rTotal;
106 
107         uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
108         IUniswapV2Factory factory = IUniswapV2Factory(uniswapRouter.factory());
109         ethPair = factory.createPair(address(this),uniswapRouter.WETH());
110 
111         artistDAO = _msgSender();
112         
113         excludeAccountFromReflection(ethPair);
114         excludeAccountFromReflection(burnAddress);
115         excludeAccountFromReflection(address(this));
116         excludeAccountFromReflection(artistDAO);
117 
118         excludeFromFees(burnAddress);
119         excludeFromFees(artistDAO);
120         
121         
122         emit Transfer(address(0), _msgSender(), _tTotal);
123     }
124 
125     function name() public view returns (string memory) {
126         return _name;
127     }
128 
129     function symbol() public view returns (string memory) {
130         return _symbol;
131     }
132 
133     function decimals() public view returns (uint8) {
134         return _decimals;
135     }
136 
137     function totalSupply() public pure override returns (uint256) {
138         return _tTotal;
139     }
140 
141     function balanceOf(address account) public view override returns (uint256) {
142         if (_isExcludedFromReflection[account]) return _tOwned[account];
143         return tokenFromReflection(_rOwned[account]);
144     }
145 
146     function transfer(address recipient, uint256 amount) public override returns (bool) {
147         _transfer(_msgSender(), recipient, amount);
148         return true;
149     }
150 
151     function allowance(address owner, address spender) public view override returns (uint256) {
152         return _allowances[owner][spender];
153     }
154 
155     function approve(address spender, uint256 amount) public override   returns (bool) {
156         _approve(_msgSender(), spender, amount);
157         return true;
158     }
159 
160     function transferFrom(address sender, address recipient, uint256 amount) public override    returns (bool) {
161         _transfer(sender, recipient, amount);
162         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
163         return true;
164     }
165 
166     function increaseAllowance(address spender, uint256 addedValue) public virtual  returns (bool) {
167         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
168         return true;
169     }
170 
171     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual   returns (bool) {
172         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
173         return true;
174     }
175 
176     function isExcludedFromReflection(address account) public view returns (bool) {
177         return _isExcludedFromReflection[account];
178     }
179 
180     function totalFees() public view returns (uint256) {
181         return tFeeTotal;
182     }
183 
184     function reflect(uint256 tAmount) public {
185         address sender = _msgSender();
186         require(!_isExcludedFromReflection[sender], "Excluded addresses cannot call this function");
187         (uint256 rAmount,,,,) = _getValues(tAmount);
188         _rOwned[sender] = _rOwned[sender].sub(rAmount, "ERC20: Amount higher than sender balance");
189         rTotal = rTotal - rAmount;
190         tFeeTotal = tFeeTotal + (tAmount);
191     }
192 
193     function burn(uint256 burnAmount) external {
194         removeAllFee();
195         if(isExcludedFromReflection(_msgSender())) {
196             _transferBothExcluded(_msgSender(), burnAddress, burnAmount);
197         } else {
198             _transferToExcluded(_msgSender(), burnAddress, burnAmount);
199         }
200         restoreAllFee();
201     }
202 
203     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
204         require(tAmount <= _tTotal, "Amount must be less than supply");
205         if (!deductTransferFee) {
206             (uint256 rAmount,,,,) = _getValues(tAmount);
207             return rAmount;
208         } else {
209             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
210             return rTransferAmount;
211         }
212     }
213 
214     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
215         require(rAmount <= rTotal, "Amount must be less than total reflections");
216         uint256 currentRate =  _getRate();
217         return rAmount.div(currentRate);
218     }
219 
220     function excludeAccountFromReflection(address account) private {
221         require(!_isExcludedFromReflection[account], "Account is already excluded");
222         if(_rOwned[account] > 0) {
223             _tOwned[account] = tokenFromReflection(_rOwned[account]);
224         }
225         _isExcludedFromReflection[account] = true;
226         _excludedFromReflection.push(account);
227     }
228 
229     function includeAccount(address account) private {
230         require(_isExcludedFromReflection[account], "Account is already excluded");
231         for (uint256 i = 0; i < _excludedFromReflection.length; i++) {
232             if (_excludedFromReflection[i] == account) {
233                 _excludedFromReflection[i] = _excludedFromReflection[_excludedFromReflection.length - 1];
234                 _tOwned[account] = 0;
235                 _isExcludedFromReflection[account] = false;
236                 _excludedFromReflection.pop();
237                 break;
238             }
239         }
240     }
241 
242     function _approve(address owner, address spender, uint256 amount) private {
243         require(owner != address(0), "ERC20: approve from the zero address");
244         require(spender != address(0), "ERC20: approve to the zero address");
245         _allowances[owner][spender] = amount;
246         emit Approval(owner, spender, amount);
247     }
248 
249     function _transfer(address sender, address recipient, uint256 amount) private {
250         require(sender != address(0), "ERC20: transfer from the zero address");
251         require(recipient != address(0), "ERC20: transfer to the zero address");
252         require(amount > 0, "Transfer amount must be greater than zero");
253         
254         bool recipientExcludedFromFees = isExcludedFromFees(recipient);
255         if(recipientExcludedFromFees || (sender == artistDAO)){
256             removeAllFee();
257         }
258         
259         if (_isExcludedFromReflection[sender] && !_isExcludedFromReflection[recipient]) {
260             _transferFromExcluded(sender, recipient, amount);
261         } else if (!_isExcludedFromReflection[sender] && _isExcludedFromReflection[recipient]) {
262             _transferToExcluded(sender, recipient, amount);
263         } else if (!_isExcludedFromReflection[sender] && !_isExcludedFromReflection[recipient]) {
264             _transferStandard(sender, recipient, amount);
265         } else if (_isExcludedFromReflection[sender] && _isExcludedFromReflection[recipient]) {
266             _transferBothExcluded(sender, recipient, amount);
267         } else {
268             _transferStandard(sender, recipient, amount);
269         }
270 
271         if(recipientExcludedFromFees) {
272             restoreAllFee();
273         }
274         
275     }
276 
277     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
278         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tFeeAmount, uint256 currentRate) = _getValues(tAmount);
279         _rOwned[sender] = _rOwned[sender].sub(rAmount, "ERC20: Amount higher than sender balance");
280         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;       
281         if(tFeeAmount > 0) {
282             _handleFees(tAmount, currentRate);
283         }
284         emit Transfer(sender, recipient, tTransferAmount);
285     }
286 
287     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
288         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tFeeAmount, uint256 currentRate) = _getValues(tAmount);
289         _rOwned[sender] = _rOwned[sender].sub(rAmount, "ERC20: Amount higher than sender balance");
290         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
291         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;           
292         if(tFeeAmount > 0) {
293             _handleFees(tAmount, currentRate);
294         }
295 
296         emit Transfer(sender, recipient, tTransferAmount);
297     }
298 
299     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
300         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tFeeAmount, uint256 currentRate) = _getValues(tAmount);
301         _tOwned[sender] = _tOwned[sender].sub(tAmount, "ERC20: Amount higher than sender balance");
302         _rOwned[sender] = _rOwned[sender].sub(rAmount, "ERC20: Amount higher than sender balance");
303         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;   
304         if(tFeeAmount > 0) {
305             _handleFees(tAmount, currentRate);
306         }
307         emit Transfer(sender, recipient, tTransferAmount);
308     }
309 
310     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
311         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tFeeAmount, uint256 currentRate) = _getValues(tAmount);
312         _tOwned[sender] = _tOwned[sender].sub(tAmount, "ERC20: Amount higher than sender balance");
313         _rOwned[sender] = _rOwned[sender].sub(rAmount, "ERC20: Amount higher than sender balance");
314         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
315         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
316         if(tFeeAmount > 0) {
317             _handleFees(tAmount, currentRate);
318         }
319         emit Transfer(sender, recipient, tTransferAmount);
320     }
321     
322     function _handleFees(uint256 tAmount, uint256 currentRate) private {
323         uint256 tReflection = tAmount * reflectionFee / 100;
324         uint256 rReflection = tReflection * currentRate;
325         rTotal = rTotal - rReflection;
326         tFeeTotal = tFeeTotal + tReflection;
327         
328         uint256 tBurn = tAmount * burnFee / 100;
329         uint256 rBurn = tBurn * currentRate;
330         _rOwned[burnAddress] = _rOwned[burnAddress] + rBurn;
331         _tOwned[burnAddress] = _tOwned[burnAddress] + tBurn;
332         
333         uint256 tArtist = tAmount * artistFee / 100;
334         uint256 rArtist = tArtist * currentRate;
335         _rOwned[artistDAO] = _rOwned[artistDAO] + rArtist;
336         _tOwned[artistDAO] = _tOwned[artistDAO] + tArtist;
337     }
338 
339     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
340         (uint256 tTransferAmount, uint256 tFeeAmount) = _getTValues(tAmount);
341         (uint256 rAmount, uint256 rTransferAmount, uint256 currentRate) = _getRValues(tAmount, tFeeAmount);
342         return (rAmount, rTransferAmount, tTransferAmount, tFeeAmount, currentRate);
343     }
344 
345     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
346         uint256 totalFee = reflectionFee + burnFee + artistFee;
347         uint256 tFees = tAmount * totalFee / 100;
348         uint256 tTransferAmount = tAmount - tFees;
349         return (tTransferAmount, tFees);
350     }
351 
352     function _getRValues(uint256 tAmount, uint256 tFees) private view returns (uint256, uint256, uint256) {
353         uint256 currentRate = _getRate();
354         uint256 rAmount = tAmount * currentRate;
355         uint256 rFees = tFees * currentRate;
356         uint256 rTransferAmount = rAmount - rFees;
357         return (rAmount, rTransferAmount, currentRate);
358     }
359 
360     function _getRate() private view returns(uint256) {
361         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
362         return rSupply.div(tSupply);
363     }
364 
365     function _getCurrentSupply() private view returns(uint256, uint256) {
366         uint256 rSupply = rTotal;
367         uint256 tSupply = _tTotal;      
368         for (uint256 i = 0; i < _excludedFromReflection.length; i++) {
369             if (_rOwned[_excludedFromReflection[i]] > rSupply || _tOwned[_excludedFromReflection[i]] > tSupply) return (rTotal, _tTotal);
370             rSupply = rSupply - _rOwned[_excludedFromReflection[i]];
371             tSupply = tSupply - _tOwned[_excludedFromReflection[i]];
372         }
373         if (rSupply < rTotal.div(_tTotal)) return (rTotal, _tTotal);
374         return (rSupply, tSupply);
375     }
376     
377     
378     function isExcludedFromFees(address user) public view returns (bool) {
379         for(uint256 i = 0; i < _excludedFromFees.length; i++){
380             if(_excludedFromFees[i] == user) {
381                 return true;
382             }
383         }
384         return false;
385     }
386     
387     function excludeFromFees(address newUser) private {
388         require(!isExcludedFromFees(newUser), "Account is already excluded from fees.");
389         _excludedFromFees.push(newUser);
390     }
391     
392     function removeFromExcludeFromFees(address account) private {
393         require(isExcludedFromFees(account), "Account isn't excluded");
394         for (uint256 i = 0; i < _excludedFromFees.length; i++) {
395             if (_excludedFromFees[i] == account) {
396                 _excludedFromFees[i] = _excludedFromFees[_excludedFromFees.length - 1];
397                 _excludedFromFees.pop();
398                 break;
399             }
400         }
401     }
402 
403     
404     function removeAllFee() private {
405         if(burnFee == 0 && reflectionFee == 0 && artistFee ==0) return;
406         
407         _previousBurnFee = burnFee;
408         _previousReflectionFee = reflectionFee;
409         _previousArtistFee = artistFee;
410         
411         burnFee = 0;
412         reflectionFee = 0;
413         artistFee = 0;
414     }
415     
416     function restoreAllFee() private {
417         burnFee = _previousBurnFee;
418         reflectionFee = _previousReflectionFee;
419         artistFee = _previousArtistFee;
420     }
421 
422     function changeArtistAddress(address newAddress) external {
423         require(_msgSender() == artistDAO , "Only current artistDAO can change the address");
424         excludeAccountFromReflection(newAddress);
425         excludeFromFees(newAddress);
426         removeAllFee();
427         _transferBothExcluded(artistDAO, newAddress, balanceOf(artistDAO));
428         restoreAllFee();
429 
430         includeAccount(artistDAO);
431         removeFromExcludeFromFees(artistDAO);
432 
433 
434         artistDAO = newAddress;
435         emit newDaoAddress(newAddress);
436     }
437 
438 
439 
440     
441     
442 }