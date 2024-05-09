1 //with love nakamoyo55
2 
3 //SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.4;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address account) external view returns (uint256);
11 
12     function transfer(address recipient, uint256 amount)
13         external
14         returns (bool);
15 
16     function allowance(address owner, address spender)
17         external
18         view
19         returns (uint256);
20 
21     function approve(address spender, uint256 amount) external returns (bool);
22 
23     function transferFrom(
24         address sender,
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(
31         address indexed owner,
32         address indexed spender,
33         uint256 value
34     );
35 }
36 
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41 
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     function sub(
50         uint256 a,
51         uint256 b,
52         string memory errorMessage
53     ) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56 
57         return c;
58     }
59 
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         if (a == 0) {
62             return 0;
63         }
64 
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67 
68         return c;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return div(a, b, "SafeMath: division by zero");
73     }
74 
75     function div(
76         uint256 a,
77         uint256 b,
78         string memory errorMessage
79     ) internal pure returns (uint256) {
80         // Solidity only automatically asserts when dividing by 0
81         require(b > 0, errorMessage);
82         uint256 c = a / b;
83 
84         return c;
85     }
86 }
87 
88 contract Context {
89     constructor() {}
90 
91     // solhint-disable-previous-line no-empty-blocks
92 
93     function _msgSender() internal view returns (address) {
94         return msg.sender;
95     }
96 }
97 
98 abstract contract Ownable is Context {
99     address private _owner;
100 
101     event OwnershipTransferred(
102         address indexed previousOwner,
103         address indexed newOwner
104     );
105 
106     /**
107      * @dev Initializes the contract setting the deployer as the initial owner.
108      */
109     constructor() {
110         address msgSender = _msgSender();
111         _owner = msgSender;
112         emit OwnershipTransferred(address(0), msgSender);
113     }
114 
115     /**
116      * @dev Returns the address of the current owner.
117      */
118     function owner() public view returns (address) {
119         return _owner;
120     }
121 
122     /**
123      * @dev Throws if called by any account other than the owner.
124      */
125     modifier onlyOwner() {
126         require(_owner == _msgSender(), "Ownable: caller is not the owner");
127         _;
128     }
129 }
130 
131 contract ERC20 is Context, Ownable, IERC20 {
132     using SafeMath for uint256;
133 
134     mapping(address => uint256) internal _balances;
135 
136     mapping(address => mapping(address => uint256)) internal _allowances;
137 
138     uint256 internal _totalSupply;
139     bool burnActive = false;
140 
141     function totalSupply() public view override returns (uint256) {
142         return _totalSupply;
143     }
144 
145     function balanceOf(address account) public view override returns (uint256) {
146         return _balances[account];
147     }
148 
149     function transfer(address recipient, uint256 amount)
150         public
151         override
152         returns (bool)
153     {
154         _transfer(_msgSender(), recipient, amount);
155         return true;
156     }
157 
158     function allowance(address towner, address spender)
159         public
160         view
161         override
162         returns (uint256)
163     {
164         return _allowances[towner][spender];
165     }
166 
167     function approve(address spender, uint256 amount)
168         public
169         override
170         returns (bool)
171     {
172         _approve(_msgSender(), spender, amount);
173         return true;
174     }
175 
176     function transferFrom(
177         address sender,
178         address recipient,
179         uint256 amount
180     ) public override returns (bool) {
181         _transfer(sender, recipient, amount);
182         _approve(
183             sender,
184             _msgSender(),
185             _allowances[sender][_msgSender()].sub(
186                 amount,
187                 "ERC20: transfer amount exceeds allowance"
188             )
189         );
190         return true;
191     }
192 
193     function increaseAllowance(address spender, uint256 addedValue)
194         public
195         returns (bool)
196     {
197         _approve(
198             _msgSender(),
199             spender,
200             _allowances[_msgSender()][spender].add(addedValue)
201         );
202         return true;
203     }
204 
205     function decreaseAllowance(address spender, uint256 subtractedValue)
206         public
207         returns (bool)
208     {
209         _approve(
210             _msgSender(),
211             spender,
212             _allowances[_msgSender()][spender].sub(
213                 subtractedValue,
214                 "ERC20: decreased allowance below zero"
215             )
216         );
217         return true;
218     }
219 
220     function _transfer(
221         address sender,
222         address recipient,
223         uint256 amount
224     ) internal {
225         require(sender != address(0), "ERC20: transfer from the zero address");
226         require(recipient != address(0), "ERC20: transfer to the zero address");
227 
228         _balances[sender] = _balances[sender].sub(
229             amount,
230             "ERC20: transfer amount exceeds balance"
231         );
232         _balances[recipient] = _balances[recipient].add(amount);
233         emit Transfer(sender, recipient, amount);
234     }
235 
236     function _approve(
237         address towner,
238         address spender,
239         uint256 amount
240     ) internal {
241         require(towner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243 
244         _allowances[towner][spender] = amount;
245         emit Approval(towner, spender, amount);
246     }
247 }
248 
249 contract ERC20Detailed is ERC20 {
250     string private _name;
251     string private _symbol;
252     uint8 private _decimals;
253 
254     constructor(
255         string memory tname,
256         string memory tsymbol,
257         uint8 tdecimals
258     ) {
259         _name = tname;
260         _symbol = tsymbol;
261         _decimals = tdecimals;
262     }
263 
264     function name() public view returns (string memory) {
265         return _name;
266     }
267 
268     function symbol() public view returns (string memory) {
269         return _symbol;
270     }
271 
272     function decimals() public view returns (uint8) {
273         return _decimals;
274     }
275 }
276 
277 library Address {
278     function isContract(address account) internal view returns (bool) {
279         bytes32 codehash;
280         bytes32 accountHash =
281             0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
282         // solhint-disable-next-line no-inline-assembly
283         assembly {
284             codehash := extcodehash(account)
285         }
286         return (codehash != 0x0 && codehash != accountHash);
287     }
288 }
289 
290 library SafeERC20 {
291     using SafeMath for uint256;
292     using Address for address;
293 
294     function safeTransfer(
295         IERC20 token,
296         address to,
297         uint256 value
298     ) internal {
299         callOptionalReturn(
300             token,
301             abi.encodeWithSelector(token.transfer.selector, to, value)
302         );
303     }
304 
305     function safeTransferFrom(
306         IERC20 token,
307         address from,
308         address to,
309         uint256 value
310     ) internal {
311         callOptionalReturn(
312             token,
313             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
314         );
315     }
316 
317     function safeApprove(
318         IERC20 token,
319         address spender,
320         uint256 value
321     ) internal {
322         require(
323             (value == 0) || (token.allowance(address(this), spender) == 0),
324             "SafeERC20: approve from non-zero to non-zero allowance"
325         );
326         callOptionalReturn(
327             token,
328             abi.encodeWithSelector(token.approve.selector, spender, value)
329         );
330     }
331 
332     function callOptionalReturn(IERC20 token, bytes memory data) private {
333         require(address(token).isContract(), "SafeERC20: call to non-contract");
334 
335         // solhint-disable-next-line avoid-low-level-calls
336         (bool success, bytes memory returndata) = address(token).call(data);
337         require(success, "SafeERC20: low-level call failed");
338 
339         if (returndata.length > 0) {
340             // Return data is optional
341             // solhint-disable-next-line max-line-length
342             require(
343                 abi.decode(returndata, (bool)),
344                 "SafeERC20: ERC20 operation did not succeed"
345             );
346         }
347     }
348 }
349 
350 contract Voxel is ERC20, ERC20Detailed {
351     using SafeERC20 for IERC20;
352     using Address for address;
353     using SafeMath for uint256;
354 
355     string public VNetwork = "VNetwork";
356     string public VDex = "VDex";
357 
358     address public _owner;
359 
360     constructor() ERC20Detailed("Voxel X Network", "VXL", 18) {
361         _owner = msg.sender;
362         _totalSupply = 500000000 * (10**uint256(18));
363 
364         _balances[_owner] = _totalSupply;
365     }
366 
367     function SetVNetwork(string memory _name1) public onlyOwner {
368         VNetwork = _name1;
369     }
370 
371     function SetVDex(string memory _name2) public onlyOwner {
372         VDex = _name2;
373     }
374 }