1 /**
2 Twitter:https://twitter.com/slothi_official
3 Web:https://www.slothiswap.finance (migrating)
4 Tele:https://t.me/SlothimemeErc
5 Dis:https://discord.com/invite/w55cKj6KzM
6 */
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity ^0.8.15;
10 
11  
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 
23 
24 pragma solidity ^0.8.15;
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
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
40  
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43 
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46   
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49 
50     function transferFrom(
51         address sender,
52         address recipient,
53         uint256 amount
54     ) external returns (bool);
55 
56 
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 
59     /**
60      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
61      * a call to {approve}. `value` is the new allowance.
62      */
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 
67 
68 pragma solidity ^0.8.15;
69 
70 /**
71  * @dev Interface for the optional metadata functions from the ERC20 standard.
72  *
73  * _Available since v4.1._
74  */
75 interface IERC20Metadata is IERC20 {
76     /**
77      * @dev Returns the name of the token.
78      */
79     function name() external view returns (string memory);
80 
81     /**
82      * @dev Returns the symbol of the token.
83      */
84     function symbol() external view returns (string memory);
85 
86     /**
87      * @dev Returns the decimals places of the token.
88      */
89     function decimals() external view returns (uint8);
90 }
91 
92 
93 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
94 
95 
96 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
97 
98 pragma solidity ^0.8.15;
99 
100 
101 
102 contract ERC20 is Context, IERC20, IERC20Metadata {
103     mapping(address => uint256) private _balances;
104 
105     mapping(address => mapping(address => uint256)) private _allowances;
106 
107     uint256 private _totalSupply;
108 
109     string private _name;
110     string private _symbol;
111 
112    
113     constructor(string memory name_, string memory symbol_) {
114         _name = name_;
115         _symbol = symbol_;
116     }
117 
118     /**
119      * @dev Returns the name of the token.
120      */
121     function name() public view virtual override returns (string memory) {
122         return _name;
123     }
124 
125     /**
126      * @dev Returns the symbol of the token, usually a shorter version of the
127      * name.
128      */
129     function symbol() public view virtual override returns (string memory) {
130         return _symbol;
131     }
132 
133 
134     function decimals() public view virtual override returns (uint8) {
135         return 18;
136     }
137 
138     /**
139      * @dev See {IERC20-totalSupply}.
140      */
141     function totalSupply() public view virtual override returns (uint256) {
142         return _totalSupply;
143     }
144 
145     /**
146      * @dev See {IERC20-balanceOf}.
147      */
148     function balanceOf(address account) public view virtual override returns (uint256) {
149         return _balances[account];
150     }
151 
152 
153     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
154         _transfer(_msgSender(), recipient, amount);
155         return true;
156     }
157 
158     /**
159      * @dev See {IERC20-allowance}.
160      */
161     function allowance(address owner, address spender) public view virtual override returns (uint256) {
162         return _allowances[owner][spender];
163     }
164 
165 
166     function approve(address spender, uint256 amount) public virtual override returns (bool) {
167         _approve(_msgSender(), spender, amount);
168         return true;
169     }
170 
171 
172     function transferFrom(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) public virtual override returns (bool) {
177         _transfer(sender, recipient, amount);
178 
179         uint256 currentAllowance = _allowances[sender][_msgSender()];
180         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
181         unchecked {
182             _approve(sender, _msgSender(), currentAllowance - amount);
183         }
184 
185         return true;
186     }
187 
188 
189     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
190         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
191         return true;
192     }
193 
194  
195     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
196         uint256 currentAllowance = _allowances[_msgSender()][spender];
197         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
198         unchecked {
199             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
200         }
201 
202         return true;
203     }
204 
205     function _transfer(
206         address sender,
207         address recipient,
208         uint256 amount
209     ) internal virtual {
210         require(sender != address(0), "ERC20: transfer from the zero address");
211         require(recipient != address(0), "ERC20: transfer to the zero address");
212 
213         _beforeTokenTransfer(sender, recipient, amount);
214 
215         uint256 senderBalance = _balances[sender];
216         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
217         unchecked {
218             _balances[sender] = senderBalance - amount;
219         }
220         _balances[recipient] += amount;
221 
222         emit Transfer(sender, recipient, amount);
223 
224         _afterTokenTransfer(sender, recipient, amount);
225     }
226 
227  
228     function _mint(address account, uint256 amount) internal virtual {
229         require(account != address(0), "ERC20: mint to the zero address");
230 
231         _beforeTokenTransfer(address(0), account, amount);
232 
233         _totalSupply += amount;
234         _balances[account] += amount;
235         emit Transfer(address(0), account, amount);
236 
237         _afterTokenTransfer(address(0), account, amount);
238     }
239 
240  
241     function _burn(address account, uint256 amount) internal virtual {
242         require(account != address(0), "ERC20: burn from the zero address");
243 
244         _beforeTokenTransfer(account, address(0), amount);
245 
246         uint256 accountBalance = _balances[account];
247         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
248         unchecked {
249             _balances[account] = accountBalance - amount;
250         }
251         _totalSupply -= amount;
252 
253         emit Transfer(account, address(0), amount);
254 
255         _afterTokenTransfer(account, address(0), amount);
256     }
257 
258 
259     function _approve(
260         address owner,
261         address spender,
262         uint256 amount
263     ) internal virtual {
264         require(owner != address(0), "ERC20: approve from the zero address");
265         require(spender != address(0), "ERC20: approve to the zero address");
266 
267         _allowances[owner][spender] = amount;
268         emit Approval(owner, spender, amount);
269     }
270 
271 
272     function _beforeTokenTransfer(
273         address from,
274         address to,
275         uint256 amount
276     ) internal virtual {}
277 
278 
279     function _afterTokenTransfer(
280         address from,
281         address to,
282         uint256 amount
283     ) internal virtual {}
284 }
285 
286 
287 // File contracts/baped.sol
288 
289 pragma solidity ^0.8.15;
290 
291 contract Slothi is ERC20 { 
292     constructor() ERC20("Slothi", "Slth") {
293         _mint(msg.sender, 6200000000000000 * 10 ** decimals());
294     } 
295 }