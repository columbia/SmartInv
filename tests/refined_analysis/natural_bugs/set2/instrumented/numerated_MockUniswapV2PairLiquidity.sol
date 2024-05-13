1 /*
2     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
3 
4     Licensed under the Apache License, Version 2.0 (the "License");
5     you may not use this file except in compliance with the License.
6     You may obtain a copy of the License at
7 
8     http://www.apache.org/licenses/LICENSE-2.0
9 
10     Unless required by applicable law or agreed to in writing, software
11     distributed under the License is distributed on an "AS IS" BASIS,
12     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13     See the License for the specific language governing permissions and
14     limitations under the License.
15 */
16 
17 // SPDX-License-Identifier: GPL-3.0-or-later
18 pragma solidity ^0.8.4;
19 
20 import "@openzeppelin/contracts/utils/math/SafeMath.sol";
21 import "../external/Decimal.sol";
22 import "@uniswap/lib/contracts/libraries/FixedPoint.sol";
23 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
24 
25 contract MockUniswapV2PairLiquidity {
26     using SafeMath for uint256;
27     using Decimal for Decimal.D256;
28 
29     uint112 private reserve0; // uses single storage slot, accessible via getReserves
30     uint112 private reserve1; // uses single storage slot, accessible via getReserves
31     uint256 private liquidity;
32     address public token0;
33     address public token1;
34 
35     constructor(address _token0, address _token1) {
36         token0 = _token0;
37         token1 = _token1;
38     }
39 
40     function getReserves()
41         external
42         view
43         returns (
44             uint112,
45             uint112,
46             uint32
47         )
48     {
49         return (reserve0, reserve1, 0);
50     }
51 
52     function mint(address to) public returns (uint256) {
53         _mint(to, liquidity);
54         return liquidity;
55     }
56 
57     function mintAmount(address to, uint256 _liquidity) public payable {
58         _mint(to, _liquidity);
59     }
60 
61     function set(
62         uint112 newReserve0,
63         uint112 newReserve1,
64         uint256 newLiquidity
65     ) external payable {
66         reserve0 = newReserve0;
67         reserve1 = newReserve1;
68         liquidity = newLiquidity;
69         mint(msg.sender);
70     }
71 
72     function setReserves(uint112 newReserve0, uint112 newReserve1) external {
73         reserve0 = newReserve0;
74         reserve1 = newReserve1;
75     }
76 
77     function faucet(address account, uint256 amount) external returns (bool) {
78         _mint(account, amount);
79         return true;
80     }
81 
82     function burnEth(address to, Decimal.D256 memory ratio) public returns (uint256 amountEth, uint256 amount1) {
83         uint256 balanceEth = address(this).balance;
84         amountEth = ratio.mul(balanceEth).asUint256();
85         payable(to).transfer(amountEth);
86 
87         uint256 balance1 = reserve1;
88         amount1 = ratio.mul(balance1).asUint256();
89         IERC20(token1).transfer(to, amount1);
90     }
91 
92     function withdrawFei(address to, uint256 amount) public {
93         IERC20(token1).transfer(to, amount);
94     }
95 
96     function burnToken(address to, Decimal.D256 memory ratio) public returns (uint256 amount0, uint256 amount1) {
97         uint256 balance0 = reserve0;
98         amount0 = ratio.mul(balance0).asUint256();
99         IERC20(token0).transfer(to, amount0);
100 
101         uint256 balance1 = reserve1;
102         amount1 = ratio.mul(balance1).asUint256();
103         IERC20(token1).transfer(to, amount1);
104     }
105 
106     function swap(
107         uint256 amount0Out,
108         uint256 amount1Out,
109         address to,
110         bytes calldata
111     ) external {
112         if (amount0Out != 0) {
113             IERC20(token0).transfer(to, amount0Out);
114         }
115 
116         if (amount1Out != 0) {
117             IERC20(token1).transfer(to, amount1Out);
118         }
119     }
120 
121     function sync() external {} // no-op
122 
123     // @openzeppelin/contracts/token/ERC20/ERC20.sol
124 
125     mapping(address => uint256) private _balances;
126 
127     mapping(address => mapping(address => uint256)) private _allowances;
128 
129     uint256 private _totalSupply;
130 
131     /**
132      * @dev See {IERC20-totalSupply}.
133      */
134     function totalSupply() public view returns (uint256) {
135         return _totalSupply;
136     }
137 
138     /**
139      * @dev See {IERC20-balanceOf}.
140      */
141     function balanceOf(address account) public view returns (uint256) {
142         return _balances[account];
143     }
144 
145     /**
146      * @dev See {IERC20-transfer}.
147      *
148      * Requirements:
149      *
150      * - `recipient` cannot be the zero address.
151      * - the caller must have a balance of at least `amount`.
152      */
153     function transfer(address recipient, uint256 amount) public returns (bool) {
154         _transfer(msg.sender, recipient, amount);
155         return true;
156     }
157 
158     /**
159      * @dev See {IERC20-allowance}.
160      */
161     function allowance(address owner, address spender) public view returns (uint256) {
162         return _allowances[owner][spender];
163     }
164 
165     /**
166      * @dev See {IERC20-approve}.
167      *
168      * Requirements:
169      *
170      * - `spender` cannot be the zero address.
171      */
172     function approve(address spender, uint256 amount) public returns (bool) {
173         _approve(msg.sender, spender, amount);
174         return true;
175     }
176 
177     /**
178      * @dev See {IERC20-transferFrom}.
179      *
180      * Emits an {Approval} event indicating the updated allowance. This is not
181      * required by the EIP. See the note at the beginning of {ERC20};
182      *
183      * Requirements:
184      * - `sender` and `recipient` cannot be the zero address.
185      * - `sender` must have a balance of at least `amount`.
186      * - the caller must have allowance for `sender`'s tokens of at least
187      * `amount`.
188      */
189     function transferFrom(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) public returns (bool) {
194         _transfer(sender, recipient, amount);
195         _approve(
196             sender,
197             msg.sender,
198             _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance")
199         );
200         return true;
201     }
202 
203     /**
204      * @dev Atomically increases the allowance granted to `spender` by the caller.
205      *
206      * This is an alternative to {approve} that can be used as a mitigation for
207      * problems described in {IERC20-approve}.
208      *
209      * Emits an {Approval} event indicating the updated allowance.
210      *
211      * Requirements:
212      *
213      * - `spender` cannot be the zero address.
214      */
215     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
216         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
217         return true;
218     }
219 
220     /**
221      * @dev Atomically decreases the allowance granted to `spender` by the caller.
222      *
223      * This is an alternative to {approve} that can be used as a mitigation for
224      * problems described in {IERC20-approve}.
225      *
226      * Emits an {Approval} event indicating the updated allowance.
227      *
228      * Requirements:
229      *
230      * - `spender` cannot be the zero address.
231      * - `spender` must have allowance for the caller of at least
232      * `subtractedValue`.
233      */
234     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
235         _approve(
236             msg.sender,
237             spender,
238             _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero")
239         );
240         return true;
241     }
242 
243     /**
244      * @dev Moves tokens `amount` from `sender` to `recipient`.
245      *
246      * This is internal function is equivalent to {transfer}, and can be used to
247      * e.g. implement automatic token fees, slashing mechanisms, etc.
248      *
249      * Emits a {Transfer} event.
250      *
251      * Requirements:
252      *
253      * - `sender` cannot be the zero address.
254      * - `recipient` cannot be the zero address.
255      * - `sender` must have a balance of at least `amount`.
256      */
257     function _transfer(
258         address sender,
259         address recipient,
260         uint256 amount
261     ) internal {
262         require(sender != address(0), "ERC20: transfer from the zero address");
263         require(recipient != address(0), "ERC20: transfer to the zero address");
264 
265         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
266         _balances[recipient] = _balances[recipient].add(amount);
267     }
268 
269     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
270      * the total supply.
271      *
272      * Emits a {Transfer} event with `from` set to the zero address.
273      *
274      * Requirements
275      *
276      * - `to` cannot be the zero address.
277      */
278     function _mint(address account, uint256 amount) internal {
279         require(account != address(0), "ERC20: mint to the zero address");
280 
281         _totalSupply = _totalSupply.add(amount);
282         _balances[account] = _balances[account].add(amount);
283     }
284 
285     /**
286      * @dev Destroys `amount` tokens from `account`, reducing the
287      * total supply.
288      *
289      * Emits a {Transfer} event with `to` set to the zero address.
290      *
291      * Requirements
292      *
293      * - `account` cannot be the zero address.
294      * - `account` must have at least `amount` tokens.
295      */
296     function _burn(address account, uint256 amount) internal {
297         require(account != address(0), "ERC20: burn from the zero address");
298 
299         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
300         _totalSupply = _totalSupply.sub(amount);
301     }
302 
303     /**
304      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
305      *
306      * This is internal function is equivalent to `approve`, and can be used to
307      * e.g. set automatic allowances for certain subsystems, etc.
308      *
309      * Emits an {Approval} event.
310      *
311      * Requirements:
312      *
313      * - `owner` cannot be the zero address.
314      * - `spender` cannot be the zero address.
315      */
316     function _approve(
317         address owner,
318         address spender,
319         uint256 amount
320     ) internal {
321         require(owner != address(0), "ERC20: approve from the zero address");
322         require(spender != address(0), "ERC20: approve to the zero address");
323 
324         _allowances[owner][spender] = amount;
325     }
326 
327     /**
328      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
329      * from the caller's allowance.
330      *
331      * See {_burn} and {_approve}.
332      */
333     function _burnFrom(address account, uint256 amount) internal {
334         _burn(account, amount);
335         _approve(
336             account,
337             msg.sender,
338             _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance")
339         );
340     }
341 }
