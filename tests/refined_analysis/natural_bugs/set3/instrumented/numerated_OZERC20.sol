1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.6;
3 
4 // This is modified from "@openzeppelin/contracts/token/ERC20/IERC20.sol"
5 // Modifications were made to make the tokenName, tokenSymbol, and
6 // tokenDecimals fields internal instead of private. Getters for them were
7 // removed to silence solidity inheritance issues
8 
9 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
10 import "@openzeppelin/contracts/math/SafeMath.sol";
11 
12 /**
13  * @dev Implementation of the {IERC20} interface.
14  *
15  * This implementation is agnostic to the way tokens are created. This means
16  * that a supply mechanism has to be added in a derived contract using {_mint}.
17  * For a generic mechanism see {ERC20PresetMinterPauser}.
18  *
19  * TIP: For a detailed writeup see our guide
20  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
21  * to implement supply mechanisms].
22  *
23  * We have followed general OpenZeppelin guidelines: functions revert instead
24  * of returning `false` on failure. This behavior is nonetheless conventional
25  * and does not conflict with the expectations of ERC20 applications.
26  *
27  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
28  * This allows applications to reconstruct the allowance for all accounts just
29  * by listening to said events. Other implementations of the EIP may not emit
30  * these events, as it isn't required by the specification.
31  *
32  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
33  * functions have been added to mitigate the well-known issues around setting
34  * allowances. See {IERC20-approve}.
35  */
36 abstract contract ERC20 is IERC20 {
37     using SafeMath for uint256;
38 
39     mapping(address => uint256) private balances;
40 
41     mapping(address => mapping(address => uint256)) private allowances;
42 
43     uint256 private supply;
44 
45     struct Token {
46         string name;
47         string symbol;
48         uint8 decimals;
49     }
50 
51     Token internal token;
52 
53     /**
54      * @dev See {IERC20-transfer}.
55      *
56      * Requirements:
57      *
58      * - `_recipient` cannot be the zero address.
59      * - the caller must have a balance of at least `_amount`.
60      */
61     function transfer(address _recipient, uint256 _amount)
62         public
63         virtual
64         override
65         returns (bool)
66     {
67         _transfer(msg.sender, _recipient, _amount);
68         return true;
69     }
70 
71     /**
72      * @dev See {IERC20-approve}.
73      *
74      * Requirements:
75      *
76      * - `_spender` cannot be the zero address.
77      */
78     function approve(address _spender, uint256 _amount)
79         public
80         virtual
81         override
82         returns (bool)
83     {
84         _approve(msg.sender, _spender, _amount);
85         return true;
86     }
87 
88     /**
89      * @dev See {IERC20-transferFrom}.
90      *
91      * Emits an {Approval} event indicating the updated allowance. This is not
92      * required by the EIP. See the note at the beginning of {ERC20}.
93      *
94      * Requirements:
95      *
96      * - `_sender` and `recipient` cannot be the zero address.
97      * - `_sender` must have a balance of at least `amount`.
98      * - the caller must have allowance for ``_sender``'s tokens of at least
99      * `amount`.
100      */
101     function transferFrom(
102         address _sender,
103         address _recipient,
104         uint256 _amount
105     ) public virtual override returns (bool) {
106         _transfer(_sender, _recipient, _amount);
107         _approve(
108             _sender,
109             msg.sender,
110             allowances[_sender][msg.sender].sub(
111                 _amount,
112                 "ERC20: transfer amount exceeds allowance"
113             )
114         );
115         return true;
116     }
117 
118     /**
119      * @dev Atomically increases the allowance granted to `spender` by the caller.
120      *
121      * This is an alternative to {approve} that can be used as a mitigation for
122      * problems described in {IERC20-approve}.
123      *
124      * Emits an {Approval} event indicating the updated allowance.
125      *
126      * Requirements:
127      *
128      * - `_spender` cannot be the zero address.
129      */
130     function increaseAllowance(address _spender, uint256 _addedValue)
131         public
132         virtual
133         returns (bool)
134     {
135         _approve(
136             msg.sender,
137             _spender,
138             allowances[msg.sender][_spender].add(_addedValue)
139         );
140         return true;
141     }
142 
143     /**
144      * @dev Atomically decreases the allowance granted to `spender` by the caller.
145      *
146      * This is an alternative to {approve} that can be used as a mitigation for
147      * problems described in {IERC20-approve}.
148      *
149      * Emits an {Approval} event indicating the updated allowance.
150      *
151      * Requirements:
152      *
153      * - `_spender` cannot be the zero address.
154      * - `_spender` must have allowance for the caller of at least
155      * `_subtractedValue`.
156      */
157     function decreaseAllowance(address _spender, uint256 _subtractedValue)
158         public
159         virtual
160         returns (bool)
161     {
162         _approve(
163             msg.sender,
164             _spender,
165             allowances[msg.sender][_spender].sub(
166                 _subtractedValue,
167                 "ERC20: decreased allowance below zero"
168             )
169         );
170         return true;
171     }
172 
173     /**
174      * @dev See {IERC20-totalSupply}.
175      */
176     function totalSupply() public view override returns (uint256) {
177         return supply;
178     }
179 
180     /**
181      * @dev See {IERC20-balanceOf}.
182      */
183     function balanceOf(address _account)
184         public
185         view
186         virtual
187         override
188         returns (uint256)
189     {
190         return balances[_account];
191     }
192 
193     /**
194      * @dev See {IERC20-allowance}.
195      */
196     function allowance(address _owner, address _spender)
197         public
198         view
199         virtual
200         override
201         returns (uint256)
202     {
203         return allowances[_owner][_spender];
204     }
205 
206     /**
207      * @dev Moves tokens `amount` from `_sender` to `_recipient`.
208      *
209      * This is internal function is equivalent to {transfer}, and can be used to
210      * e.g. implement automatic token fees, slashing mechanisms, etc.
211      *
212      * Emits a {Transfer} event.
213      *
214      * Requirements:
215      *
216      * - `_sender` cannot be the zero address.
217      * - `_recipient` cannot be the zero address.
218      * - `_sender` must have a balance of at least `amount`.
219      */
220     function _transfer(
221         address _sender,
222         address _recipient,
223         uint256 amount
224     ) internal virtual {
225         require(_sender != address(0), "ERC20: transfer from the zero address");
226         require(
227             _recipient != address(0),
228             "ERC20: transfer to the zero address"
229         );
230 
231         _beforeTokenTransfer(_sender, _recipient, amount);
232 
233         balances[_sender] = balances[_sender].sub(
234             amount,
235             "ERC20: transfer amount exceeds balance"
236         );
237         balances[_recipient] = balances[_recipient].add(amount);
238         emit Transfer(_sender, _recipient, amount);
239     }
240 
241     /** @dev Creates `_amount` tokens and assigns them to `_account`, increasing
242      * the total supply.
243      *
244      * Emits a {Transfer} event with `from` set to the zero address.
245      *
246      * Requirements:
247      *
248      * - `to` cannot be the zero address.
249      */
250     function _mint(address _account, uint256 _amount) internal virtual {
251         require(_account != address(0), "ERC20: mint to the zero address");
252 
253         _beforeTokenTransfer(address(0), _account, _amount);
254 
255         supply = supply.add(_amount);
256         balances[_account] = balances[_account].add(_amount);
257         emit Transfer(address(0), _account, _amount);
258     }
259 
260     /**
261      * @dev Destroys `_amount` tokens from `_account`, reducing the
262      * total supply.
263      *
264      * Emits a {Transfer} event with `to` set to the zero address.
265      *
266      * Requirements:
267      *
268      * - `_account` cannot be the zero address.
269      * - `_account` must have at least `_amount` tokens.
270      */
271     function _burn(address _account, uint256 _amount) internal virtual {
272         require(_account != address(0), "ERC20: burn from the zero address");
273 
274         _beforeTokenTransfer(_account, address(0), _amount);
275 
276         balances[_account] = balances[_account].sub(
277             _amount,
278             "ERC20: burn amount exceeds balance"
279         );
280         supply = supply.sub(_amount);
281         emit Transfer(_account, address(0), _amount);
282     }
283 
284     /**
285      * @dev Sets `_amount` as the allowance of `_spender` over the `_owner` s tokens.
286      *
287      * This internal function is equivalent to `approve`, and can be used to
288      * e.g. set automatic allowances for certain subsystems, etc.
289      *
290      * Emits an {Approval} event.
291      *
292      * Requirements:
293      *
294      * - `_owner` cannot be the zero address.
295      * - `_spender` cannot be the zero address.
296      */
297     function _approve(
298         address _owner,
299         address _spender,
300         uint256 _amount
301     ) internal virtual {
302         require(_owner != address(0), "ERC20: approve from the zero address");
303         require(_spender != address(0), "ERC20: approve to the zero address");
304 
305         allowances[_owner][_spender] = _amount;
306         emit Approval(_owner, _spender, _amount);
307     }
308 
309     /**
310      * @dev Sets {decimals_} to a value other than the default one of 18.
311      *
312      * WARNING: This function should only be called from the constructor. Most
313      * applications that interact with token contracts will not expect
314      * {decimals_} to ever change, and may work incorrectly if it does.
315      */
316     function _setupDecimals(uint8 decimals_) internal {
317         token.decimals = decimals_;
318     }
319 
320     /**
321      * @dev Hook that is called before any transfer of tokens. This includes
322      * minting and burning.
323      *
324      * Calling conditions:
325      *
326      * - when `_from` and `_to` are both non-zero, `_amount` of ``_from``'s tokens
327      * will be to transferred to `_to`.
328      * - when `_from` is zero, `_amount` tokens will be minted for `_to`.
329      * - when `_to` is zero, `_amount` of ``_from``'s tokens will be burned.
330      * - `_from` and `_to` are never both zero.
331      *
332      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
333      */
334     function _beforeTokenTransfer(
335         address _from,
336         address _to,
337         uint256 _amount
338     ) internal virtual {}
339 }
