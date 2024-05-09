1 // SPDX-License-Identifier: MIT
2 
3 /*
4 The story of Hiroko is well known and yet unknown.
5 An obligation to be fulfilled, gratitude, warmth, kindness, impatience and greed. Many parts make a whole.
6 Many of us know the feeling of being down without a helping hand, lost and cold in the snow.
7 Like the crane that was rescued by a kind soul.
8 As we grow and make way for more, we will be heard and seen, envied and hated, loved and cherished.
9 While others require copywriting to explain the purpose of their project, 
10 The holders of ROKO need just swish across their screens or circle the golden crane to know what awaits. 
11 Whatever you draw is what ROKO will do and become. The cranes magic stops not at weaving silk. 
12 It evolves and encircles all that is good and adventurous
13 Some will want to know who I am, suffice to understand I am who taught the one you so revere with his beloved dog.
14 
15 medium.com/@yasuhiro.hiroko
16 twitter.com/HirokoToken
17 hiroko.quest
18 */
19 
20 // File: @openzeppelin/contracts@4.6.0/utils/Context.sol
21 
22 
23 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         return msg.data;
34     }
35 }
36 
37 // File: @openzeppelin/contracts@4.6.0/token/ERC20/IERC20.sol
38 
39 
40 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
41 
42 pragma solidity ^0.8.0;
43 
44 /**
45  * @dev Interface of the ERC20 standard as defined in the EIP.
46  */
47 interface IERC20 {
48 
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     /**
52      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
53      * a call to {approve}. `value` is the new allowance.
54      */
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 
57     /**
58      * @dev Returns the amount of tokens in existence.
59      */
60     function totalSupply() external view returns (uint256);
61 
62     /**
63      * @dev Returns the amount of tokens owned by `account`.
64      */
65     function balanceOf(address account) external view returns (uint256);
66 
67     function transfer(address to, uint256 amount) external returns (bool);
68 
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     function transferFrom(
74         address from,
75         address to,
76         uint256 amount
77     ) external returns (bool);
78 }
79 
80 // File: @openzeppelin/contracts@4.6.0/token/ERC20/extensions/IERC20Metadata.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 
88 /**
89  * @dev Interface for the optional metadata functions from the ERC20 standard.
90  *
91  * _Available since v4.1._
92  */
93 interface IERC20Metadata is IERC20 {
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() external view returns (string memory);
98 
99     /**
100      * @dev Returns the symbol of the token.
101      */
102     function symbol() external view returns (string memory);
103 
104     /**
105      * @dev Returns the decimals places of the token.
106      */
107     function decimals() external view returns (uint8);
108 }
109 
110 // File: @openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol
111 
112 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 
117 contract ERC20 is Context, IERC20, IERC20Metadata {
118     mapping(address => uint256) private _balances;
119 
120     mapping(address => mapping(address => uint256)) private _allowances;
121 
122     uint256 private _totalSupply;
123 
124     string private _name;
125     string private _symbol;
126 
127     constructor(string memory name_, string memory symbol_) {
128         _name = name_;
129         _symbol = symbol_;
130     }
131 
132     /**
133      * @dev Returns the name of the token.
134      */
135     function name() public view virtual override returns (string memory) {
136         return _name;
137     }
138 
139     /**
140      * @dev Returns the symbol of the token, usually a shorter version of the
141      * name.
142      */
143     function symbol() public view virtual override returns (string memory) {
144         return _symbol;
145     }
146 
147     function decimals() public view virtual override returns (uint8) {
148         return 18;
149     }
150 
151     /**
152      * @dev See {IERC20-totalSupply}.
153      */
154     function totalSupply() public view virtual override returns (uint256) {
155         return _totalSupply;
156     }
157 
158     /**
159      * @dev See {IERC20-balanceOf}.
160      */
161     function balanceOf(address account) public view virtual override returns (uint256) {
162         return _balances[account];
163     }
164 
165     function transfer(address to, uint256 amount) public virtual override returns (bool) {
166         address owner = _msgSender();
167         _transfer(owner, to, amount);
168         return true;
169     }
170 
171     /**
172      * @dev See {IERC20-allowance}.
173      */
174     function allowance(address owner, address spender) public view virtual override returns (uint256) {
175         return _allowances[owner][spender];
176     }
177 
178     function approve(address spender, uint256 amount) public virtual override returns (bool) {
179         address owner = _msgSender();
180         _approve(owner, spender, amount);
181         return true;
182     }
183 
184     function transferFrom(
185         address from,
186         address to,
187         uint256 amount
188     ) public virtual override returns (bool) {
189         address spender = _msgSender();
190         _spendAllowance(from, spender, amount);
191         _transfer(from, to, amount);
192         return true;
193     }
194 
195     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
196         address owner = _msgSender();
197         _approve(owner, spender, allowance(owner, spender) + addedValue);
198         return true;
199     }
200 
201     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
202         address owner = _msgSender();
203         uint256 currentAllowance = allowance(owner, spender);
204         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
205         unchecked {
206             _approve(owner, spender, currentAllowance - subtractedValue);
207         }
208 
209         return true;
210     }
211 
212     function _transfer(
213         address from,
214         address to,
215         uint256 amount
216     ) internal virtual {
217         require(from != address(0), "ERC20: transfer from the zero address");
218         require(to != address(0), "ERC20: transfer to the zero address");
219 
220         _beforeTokenTransfer(from, to, amount);
221 
222         uint256 fromBalance = _balances[from];
223         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
224         unchecked {
225             _balances[from] = fromBalance - amount;
226         }
227         _balances[to] += amount;
228 
229         emit Transfer(from, to, amount);
230 
231         _afterTokenTransfer(from, to, amount);
232     }
233 
234     function _mint(address account, uint256 amount) internal virtual {
235         require(account != address(0), "ERC20: mint to the zero address");
236 
237         _beforeTokenTransfer(address(0), account, amount);
238 
239         _totalSupply += amount;
240         _balances[account] += amount;
241         emit Transfer(address(0), account, amount);
242 
243         _afterTokenTransfer(address(0), account, amount);
244     }
245 
246     function _burn(address account, uint256 amount) internal virtual {
247         require(account != address(0), "ERC20: burn from the zero address");
248 
249         _beforeTokenTransfer(account, address(0), amount);
250 
251         uint256 accountBalance = _balances[account];
252         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
253         unchecked {
254             _balances[account] = accountBalance - amount;
255         }
256         _totalSupply -= amount;
257 
258         emit Transfer(account, address(0), amount);
259 
260         _afterTokenTransfer(account, address(0), amount);
261     }
262 
263     function _approve(
264         address owner,
265         address spender,
266         uint256 amount
267     ) internal virtual {
268         require(owner != address(0), "ERC20: approve from the zero address");
269         require(spender != address(0), "ERC20: approve to the zero address");
270 
271         _allowances[owner][spender] = amount;
272         emit Approval(owner, spender, amount);
273     }
274 
275     function _spendAllowance(
276         address owner,
277         address spender,
278         uint256 amount
279     ) internal virtual {
280         uint256 currentAllowance = allowance(owner, spender);
281         if (currentAllowance != type(uint256).max) {
282             require(currentAllowance >= amount, "ERC20: insufficient allowance");
283             unchecked {
284                 _approve(owner, spender, currentAllowance - amount);
285             }
286         }
287     }
288 
289     function _beforeTokenTransfer(
290         address from,
291         address to,
292         uint256 amount
293     ) internal virtual {}
294 
295     function _afterTokenTransfer(
296         address from,
297         address to,
298         uint256 amount
299     ) internal virtual {}
300 }
301 
302 // File: ROKO.sol
303 
304 
305 pragma solidity ^0.8.4;
306 
307 
308 contract HIROKO is ERC20 {
309     constructor() ERC20("TSURU NO ONGAESHI", "ROKO") {
310         _mint(msg.sender, 111111999999 * 10 ** decimals());
311     }
312 }