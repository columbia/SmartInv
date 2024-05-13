1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.4.0;
4 
5 import '../interfaces/IBEP20.sol';
6 import '@openzeppelin/contracts/access/Ownable.sol';
7 import '@openzeppelin/contracts/utils/Context.sol';
8 import '../libraries/SafeMath.sol';
9 import '../libraries/Address.sol';
10 
11 /**
12  * @dev Implementation of the {IBEP20} interface.
13  *
14  * This implementation is agnostic to the way tokens are created. This means
15  * that a supply mechanism has to be added in a derived contract using {_mint}.
16  * For a generic mechanism see {BEP20PresetMinterPauser}.
17  *
18  * TIP: For a detailed writeup see our guide
19  * https://forum.zeppelin.solutions/t/how-to-implement-BEP20-supply-mechanisms/226[How
20  * to implement supply mechanisms].
21  *
22  * We have followed general OpenZeppelin guidelines: functions revert instead
23  * of returning `false` on failure. This behavior is nonetheless conventional
24  * and does not conflict with the expectations of BEP20 applications.
25  *
26  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
27  * This allows applications to reconstruct the allowance for all accounts just
28  * by listening to said events. Other implementations of the EIP may not emit
29  * these events, as it isn't required by the specification.
30  *
31  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
32  * functions have been added to mitigate the well-known issues around setting
33  * allowances. See {IBEP20-approve}.
34  */
35 contract BEP20 is Context, IBEP20, Ownable {
36     using SafeMath for uint256;
37     using Address for address;
38 
39     mapping(address => uint256) private _balances;
40 
41     mapping(address => mapping(address => uint256)) private _allowances;
42 
43     uint256 private _totalSupply;
44 
45     string private _name;
46     string private _symbol;
47     uint8 private _decimals;
48 
49     /**
50      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
51      * a default value of 18.
52      *
53      * To select a different value for {decimals}, use {_setupDecimals}.
54      *
55      * All three of these values are immutable: they can only be set once during
56      * construction.
57      */
58     constructor(string memory name_, string memory symbol_) {
59         _name = name_;
60         _symbol = symbol_;
61         _decimals = 18;
62     }
63 
64     /**
65      * @dev Returns the bep token owner.
66      */
67     function getOwner() external override view returns (address) {
68         return owner();
69     }
70 
71     /**
72      * @dev Returns the token name.
73      */
74     function name() public override view returns (string memory) {
75         return _name;
76     }
77 
78     /**
79      * @dev Returns the token decimals.
80      */
81     function decimals() public override view returns (uint8) {
82         return _decimals;
83     }
84 
85     /**
86      * @dev Returns the token symbol.
87      */
88     function symbol() public override view returns (string memory) {
89         return _symbol;
90     }
91 
92     /**
93      * @dev See {BEP20-totalSupply}.
94      */
95     function totalSupply() public override view returns (uint256) {
96         return _totalSupply;
97     }
98 
99     /**
100      * @dev See {BEP20-balanceOf}.
101      */
102     function balanceOf(address account) public override view returns (uint256) {
103         return _balances[account];
104     }
105 
106     /**
107      * @dev See {BEP20-transfer}.
108      *
109      * Requirements:
110      *
111      * - `recipient` cannot be the zero address.
112      * - the caller must have a balance of at least `amount`.
113      */
114     function transfer(address recipient, uint256 amount) public override returns (bool) {
115         _transfer(_msgSender(), recipient, amount);
116         return true;
117     }
118 
119     /**
120      * @dev See {BEP20-allowance}.
121      */
122     function allowance(address owner, address spender) public override view returns (uint256) {
123         return _allowances[owner][spender];
124     }
125 
126     /**
127      * @dev See {BEP20-approve}.
128      *
129      * Requirements:
130      *
131      * - `spender` cannot be the zero address.
132      */
133     function approve(address spender, uint256 amount) public override returns (bool) {
134         _approve(_msgSender(), spender, amount);
135         return true;
136     }
137 
138     /**
139      * @dev See {BEP20-transferFrom}.
140      *
141      * Emits an {Approval} event indicating the updated allowance. This is not
142      * required by the EIP. See the note at the beginning of {BEP20};
143      *
144      * Requirements:
145      * - `sender` and `recipient` cannot be the zero address.
146      * - `sender` must have a balance of at least `amount`.
147      * - the caller must have allowance for `sender`'s tokens of at least
148      * `amount`.
149      */
150     function transferFrom(
151         address sender,
152         address recipient,
153         uint256 amount
154     ) public override returns (bool) {
155         _transfer(sender, recipient, amount);
156         _approve(
157             sender,
158             _msgSender(),
159             _allowances[sender][_msgSender()].sub(amount, 'BEP20: transfer amount exceeds allowance')
160         );
161         return true;
162     }
163 
164     /**
165      * @dev Atomically increases the allowance granted to `spender` by the caller.
166      *
167      * This is an alternative to {approve} that can be used as a mitigation for
168      * problems described in {BEP20-approve}.
169      *
170      * Emits an {Approval} event indicating the updated allowance.
171      *
172      * Requirements:
173      *
174      * - `spender` cannot be the zero address.
175      */
176     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
177         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
178         return true;
179     }
180 
181     /**
182      * @dev Atomically decreases the allowance granted to `spender` by the caller.
183      *
184      * This is an alternative to {approve} that can be used as a mitigation for
185      * problems described in {BEP20-approve}.
186      *
187      * Emits an {Approval} event indicating the updated allowance.
188      *
189      * Requirements:
190      *
191      * - `spender` cannot be the zero address.
192      * - `spender` must have allowance for the caller of at least
193      * `subtractedValue`.
194      */
195     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
196         _approve(
197             _msgSender(),
198             spender,
199             _allowances[_msgSender()][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero')
200         );
201         return true;
202     }
203 
204     /**
205      * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
206      * the total supply.
207      *
208      * Requirements
209      *
210      * - `msg.sender` must be the token owner
211      */
212     function mint(uint256 amount) public virtual onlyOwner returns (bool) {
213         _mint(_msgSender(), amount);
214         return true;
215     }
216 
217     /**
218      * @dev Moves tokens `amount` from `sender` to `recipient`.
219      *
220      * This is internal function is equivalent to {transfer}, and can be used to
221      * e.g. implement automatic token fees, slashing mechanisms, etc.
222      *
223      * Emits a {Transfer} event.
224      *
225      * Requirements:
226      *
227      * - `sender` cannot be the zero address.
228      * - `recipient` cannot be the zero address.
229      * - `sender` must have a balance of at least `amount`.
230      */
231     function _transfer(
232         address sender,
233         address recipient,
234         uint256 amount
235     ) internal {
236         require(sender != address(0), 'BEP20: transfer from the zero address');
237         require(recipient != address(0), 'BEP20: transfer to the zero address');
238 
239         _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
240         _balances[recipient] = _balances[recipient].add(amount);
241         emit Transfer(sender, recipient, amount);
242     }
243 
244     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
245      * the total supply.
246      *
247      * Emits a {Transfer} event with `from` set to the zero address.
248      *
249      * Requirements
250      *
251      * - `to` cannot be the zero address.
252      */
253     function _mint(address account, uint256 amount) internal {
254         require(account != address(0), 'BEP20: mint to the zero address');
255 
256         _totalSupply = _totalSupply.add(amount);
257         _balances[account] = _balances[account].add(amount);
258         emit Transfer(address(0), account, amount);
259     }
260 
261     /**
262      * @dev Destroys `amount` tokens from `account`, reducing the
263      * total supply.
264      *
265      * Emits a {Transfer} event with `to` set to the zero address.
266      *
267      * Requirements
268      *
269      * - `account` cannot be the zero address.
270      * - `account` must have at least `amount` tokens.
271      */
272     function _burn(address account, uint256 amount) internal {
273         require(account != address(0), 'BEP20: burn from the zero address');
274 
275         _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
276         _totalSupply = _totalSupply.sub(amount);
277         emit Transfer(account, address(0), amount);
278     }
279 
280     /**
281      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
282      *
283      * This is internal function is equivalent to `approve`, and can be used to
284      * e.g. set automatic allowances for certain subsystems, etc.
285      *
286      * Emits an {Approval} event.
287      *
288      * Requirements:
289      *
290      * - `owner` cannot be the zero address.
291      * - `spender` cannot be the zero address.
292      */
293     function _approve(
294         address owner,
295         address spender,
296         uint256 amount
297     ) internal {
298         require(owner != address(0), 'BEP20: approve from the zero address');
299         require(spender != address(0), 'BEP20: approve to the zero address');
300 
301         _allowances[owner][spender] = amount;
302         emit Approval(owner, spender, amount);
303     }
304 
305     /**
306      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
307      * from the caller's allowance.
308      *
309      * See {_burn} and {_approve}.
310      */
311     function _burnFrom(address account, uint256 amount) internal {
312         _burn(account, amount);
313         _approve(
314             account,
315             _msgSender(),
316             _allowances[account][_msgSender()].sub(amount, 'BEP20: burn amount exceeds allowance')
317         );
318     }
319 }
