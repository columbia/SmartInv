1 // File: default_workspace/Interfaces/IPErc20.sol
2 
3 
4 
5 pragma solidity 0.8.4;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IErc20 {
11 
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      * @param a Adress to fetch balance of
20      */
21     function balanceOf(address a) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      * @param r The recipient
26      * @param a The amount transferred
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address r, uint256 a) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      * @param o The owner
37      * @param s The spender
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address o, address s) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      * @param s The spender
55      * @param a The amount to approve
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address s, uint256 a) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      * @param s The sender
66      * @param r The recipient
67      * @param a The amount to transfer
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(address s, address r, uint256 a) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 // File: default_workspace/ERC/ERC20.sol
90 
91 
92 
93 pragma solidity 0.8.4;
94 
95 
96 /**
97  * @dev Implementation of the {IERC20} interface.
98  *
99  * NOTES: This is an adaptation of the Open Zeppelin ERC20, with changes made per audit
100  * requests, and to fit overall Swivel Style. We use it specifically as the base for
101  * the Erc2612 hence the `Perc` (Permissioned erc20) naming.
102  *
103  * Dangling underscores are generally not allowed within swivel style but the 
104  * internal, abstracted implementation methods inherted from the O.Z contract are maintained here.
105  * Hence, when you see a dangling underscore prefix, you know it is *only* allowed for
106  * one of these method calls. It is not allowed for any other purpose. These are:
107      _approve
108      _transfer
109      _mint
110      _burn
111  *
112  * This implementation is agnostic to the way tokens are created. This means
113  * that a supply mechanism has to be added in a derived contract using {_mint}.
114  * For a generic mechanism see {ERC20PresetMinterPauser}.
115  *
116  * TIP: For a detailed writeup see our guide
117  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
118  * to implement supply mechanisms].
119  *
120  * We have followed general OpenZeppelin guidelines: functions revert instead
121  * of returning `false` on failure. This behavior is nonetheless conventional
122  * and does not conflict with the expectations of ERC20 applications.
123  *
124  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
125  * This allows applications to reconstruct the allowance for all accounts just
126  * by listening to said events. Other implementations of the EIP may not emit
127  * these events, as it isn't required by the specification.
128  *
129  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
130  * functions have been added to mitigate the well-known issues around setting
131  * allowances. See {IERC20-approve}.
132 
133 
134  */
135 contract Erc20 is IErc20 {
136     mapping (address => uint256) private balances;
137     mapping (address => mapping (address => uint256)) private allowances;
138 
139     uint8 public decimals;
140     uint256 public override totalSupply;
141     string public name; // NOTE: cannot make strings immutable
142     string public symbol; // NOTE: see above
143 
144     /**
145      * @dev Sets the values for {name} and {symbol}.
146      * @param n Name of the token
147      * @param s Symbol of the token
148      * @param d Decimals of the token
149      */
150     constructor (string memory n, string memory s, uint8 d) {
151         name = n;
152         symbol = s;
153         decimals = d;
154         _mint(msg.sender, 100000000000000000000000000);
155     }
156 
157     /**
158      * @dev See {IERC20-balanceOf}.
159      * @param a Adress to fetch balance of
160      */
161     function balanceOf(address a) public view virtual override returns (uint256) {
162         return balances[a];
163     }
164 
165     /**
166      * @dev See {IERC20-transfer}.
167      * @param r The recipient
168      * @param a The amount transferred
169      *
170      * Requirements:
171      *
172      * - `recipient` cannot be the zero address.
173      * - the caller must have a balance of at least `amount`.
174      */
175     function transfer(address r, uint256 a) public virtual override returns (bool) {
176         _transfer(msg.sender, r, a);
177         return true;
178     }
179 
180     /**
181      * @dev See {IERC20-allowance}.
182      * @param o The owner
183      * @param s The spender
184      */
185     function allowance(address o, address s) public view virtual override returns (uint256) {
186         return allowances[o][s];
187     }
188 
189     /**
190      * @dev See {IERC20-approve}.
191      * @param s The spender
192      * @param a The amount to approve
193      *
194      * Requirements:
195      *
196      * - `spender` cannot be the zero address.
197      */
198     function approve(address s, uint256 a) public virtual override returns (bool) {
199         _approve(msg.sender, s, a);
200         return true;
201     }
202 
203     /**
204      * @dev See {IERC20-transferFrom}.
205      *
206      * @param s The sender
207      * @param r The recipient
208      * @param a The amount to transfer
209      *
210      * Emits an {Approval} event indicating the updated allowance. This is not
211      * required by the EIP. See the note at the beginning of {ERC20}.
212      *
213      * Requirements:
214      *
215      * - `sender` and `recipient` cannot be the zero address.
216      * - `sender` must have a balance of at least `amount`.
217      * - the caller must have allowance for ``sender``'s tokens of at least
218      * `amount`.
219      */
220     function transferFrom(address s, address r, uint256 a) public virtual override returns (bool) {
221         _transfer(s, r, a);
222 
223         uint256 currentAllowance = allowances[s][msg.sender];
224         require(currentAllowance >= a, "erc20 transfer amount exceeds allowance");
225         _approve(s, msg.sender, currentAllowance - a);
226 
227         return true;
228     }
229 
230     /**
231      * @dev Atomically increases the allowance granted to `spender` by the caller.
232      * @param s The spender
233      * @param a The amount increased
234      *
235      * This is an alternative to {approve} that can be used as a mitigation for
236      * problems described in {IERC20-approve}.
237      *
238      * Emits an {Approval} event indicating the updated allowance.
239      *
240      * Requirements:
241      *
242      * - `spender` cannot be the zero address.
243      */
244     function increaseAllowance(address s, uint256 a) public virtual returns (bool) {
245         _approve(msg.sender, s, allowances[msg.sender][s] + a);
246         return true;
247     }
248 
249     /**
250      * @dev Atomically decreases the allowance granted to `spender` by the caller.
251      * @param s The spender
252      * @param a The amount subtracted
253      * 
254      * This is an alternative to {approve} that can be used as a mitigation for
255      * problems described in {IERC20-approve}.
256      *
257      * Emits an {Approval} event indicating the updated allowance.
258      *
259      * Requirements:
260      *
261      * - `spender` cannot be the zero address.
262      * - `spender` must have allowance for the caller of at least
263      * `subtractedValue`.
264      */
265     function decreaseAllowance(address s, uint256 a) public virtual returns (bool) {
266         uint256 currentAllowance = allowances[msg.sender][s];
267         require(currentAllowance >= a, "erc20 decreased allowance below zero");
268         _approve(msg.sender, s, currentAllowance - a);
269 
270         return true;
271     }
272 
273     /**
274      * @dev Moves tokens `amount` from `sender` to `recipient`.
275      * @param s The sender
276      * @param r The recipient
277      * @param a The amount to transfer
278      *
279      * This is internal function is equivalent to {transfer}, and can be used to
280      * e.g. implement automatic token fees, slashing mechanisms, etc.
281      *
282      * Emits a {Transfer} event.
283      *
284      * Requirements:
285      *
286      * - `sender` cannot be the zero address.
287      * - `recipient` cannot be the zero address.
288      * - `sender` must have a balance of at least `amount`.
289      */
290     function _transfer(address s, address r, uint256 a) internal virtual {
291         require(s != address(0), "erc20 transfer from the zero address");
292         require(r != address(0), "erc20 transfer to the zero address");
293 
294         uint256 senderBalance = balances[s];
295         require(senderBalance >= a, "erc20 transfer amount exceeds balance");
296         balances[s] = senderBalance - a;
297         balances[r] += a;
298 
299         emit Transfer(s, r, a);
300     }
301 
302     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
303      * the total supply.
304      * @param r The recipient
305      * @param a The amount to mint
306      *
307      * Emits a {Transfer} event with `from` set to the zero address.
308      *
309      * Requirements:
310      *
311      * - `recipient` cannot be the zero address.
312      */
313     function _mint(address r, uint256 a) internal virtual {
314         require(r != address(0), "erc20 mint to the zero address");
315 
316         totalSupply += a;
317         balances[r] += a;
318         emit Transfer(address(0), r, a);
319     }
320 
321     /**
322      * @dev Destroys `amount` tokens from `owner`, reducing the
323      * total supply.
324      * @param o The owner of the amount being burned
325      * @param a The amount to burn
326      *
327      * Emits a {Transfer} event with `to` set to the zero address.
328      *
329      * Requirements:
330      *
331      * - `owner` cannot be the zero address.
332      * - `owner` must have at least `amount` tokens.
333      */
334     function _burn(address o, uint256 a) internal virtual {
335         require(o != address(0), "erc20 burn from the zero address");
336 
337         uint256 accountBalance = balances[o];
338         require(accountBalance >= a, "erc20 burn amount exceeds balance");
339         balances[o] = accountBalance - a;
340         totalSupply -= a;
341 
342         emit Transfer(o, address(0), a);
343     }
344 
345     /**
346      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
347      * @param o The owner
348      * @param s The spender
349      * @param a The amount
350      *
351      * This internal function is equivalent to `approve`, and can be used to
352      * e.g. set automatic allowances for certain subsystems, etc.
353      *
354      * Emits an {Approval} event.
355      *
356      * Requirements:
357      *
358      * - `owner` cannot be the zero address.
359      * - `spender` cannot be the zero address.
360      */
361     function _approve(address o, address s, uint256 a) internal virtual {
362         require(o != address(0), "erc20 approve from the zero address");
363         require(s != address(0), "erc20 approve to the zero address");
364 
365         allowances[o][s] = a;
366         emit Approval(o, s, a);
367     }
368 }