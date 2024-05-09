1 pragma solidity ^0.5.8;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 
109 /*
110 This file incorporates code covered by the following terms:
111 
112 The MIT License (MIT)
113 
114 Copyright (c) 2016-2019 zOS Global Limited
115 
116 Permission is hereby granted, free of charge, to any person obtaining
117 a copy of this software and associated documentation files (the
118 "Software"), to deal in the Software without restriction, including
119 without limitation the rights to use, copy, modify, merge, publish,
120 distribute, sublicense, and/or sell copies of the Software, and to
121 permit persons to whom the Software is furnished to do so, subject to
122 the following conditions:
123 
124 The above copyright notice and this permission notice shall be included
125 in all copies or substantial portions of the Software.
126 */
127 
128 contract TrustlinesNetworkToken {
129     using SafeMath for uint256;
130 
131     // We use MAX_UINT value for an approval of infinite value
132     uint constant MAX_UINT = 2 ** 256 - 1;
133     string private _name;
134     string private _symbol;
135     uint8 private _decimals;
136     uint256 private _totalSupply;
137 
138     mapping(address => uint256) private _balances;
139     mapping(address => mapping(address => uint256)) private _allowances;
140 
141     event Transfer(address indexed from, address indexed to, uint256 value);
142     event Approval(
143         address indexed owner,
144         address indexed spender,
145         uint256 value
146     );
147 
148     constructor(
149         string memory name,
150         string memory symbol,
151         uint8 decimals,
152         address preMintAddress,
153         uint256 preMintAmount
154     ) public {
155         _name = name;
156         _symbol = symbol;
157         _decimals = decimals;
158 
159         _mint(preMintAddress, preMintAmount);
160     }
161 
162     /**
163     * @dev Returns the amount of tokens owned by `account`.
164     */
165     function balanceOf(address account) public view returns (uint256) {
166         return _balances[account];
167     }
168 
169     /**
170     * @dev Returns the remaining number of tokens that `spender` will be
171     * allowed to spend on behalf of `owner` through {transferFrom}. This is
172     * zero by default.
173     *
174     * This value changes when {approve} or {transferFrom} are called.
175     */
176     function allowance(address owner, address spender)
177         public
178         view
179         returns (uint256)
180     {
181         return _allowances[owner][spender];
182     }
183 
184     function name() public view returns (string memory) {
185         return _name;
186     }
187 
188     function symbol() public view returns (string memory) {
189         return _symbol;
190     }
191 
192     function decimals() public view returns (uint8) {
193         return _decimals;
194     }
195 
196     /**
197     * @dev Returns the amount of tokens in existence.
198     */
199     function totalSupply() public view returns (uint256) {
200         return _totalSupply;
201     }
202 
203     /**
204     * @dev Moves `amount` tokens from the caller's account to `recipient`.
205     *
206     * Returns a boolean value indicating whether the operation succeeded.
207     *
208     * Emits a {Transfer} event.
209     */
210     function transfer(address recipient, uint256 amount) public returns (bool) {
211         _transfer(msg.sender, recipient, amount);
212         return true;
213     }
214 
215     /**
216     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
217     *
218     * Returns a boolean value indicating whether the operation succeeded.
219     *
220     * Approve with a value of `MAX_UINT = 2 ** 256 - 1` will symbolize
221     * an approval of infinite value.
222     *
223     * IMPORTANT:to prevent the risk that someone may use both the old and
224     * the new allowance by unfortunate transaction ordering,
225     * the approval must be set to 0 before it can be changed to any
226     * different desired value.
227     *
228     * see: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229     *
230     * Emits an {Approval} event.
231     */
232     function approve(address spender, uint256 value) public returns (bool) {
233         require(
234             value == 0 || _allowances[msg.sender][spender] == 0,
235             "ERC20: approve only to or from 0 value"
236         );
237         _approve(msg.sender, spender, value);
238         return true;
239     }
240 
241     /**
242     * @dev Moves `amount` tokens from `sender` to `recipient` using the
243     * allowance mechanism. `amount` is then deducted from the caller's
244     * allowance unless the allowance is `MAX_UINT = 2 ** 256 - 1`.
245     *
246     * Returns a boolean value indicating whether the operation succeeded.
247     *
248     * Emits a {Transfer} event.
249     */
250     function transferFrom(address sender, address recipient, uint256 amount)
251         public
252         returns (bool)
253     {
254         _transfer(sender, recipient, amount);
255 
256         uint _allowance = _allowances[sender][msg.sender];
257         if (_allowance < MAX_UINT) {
258             uint updatedAllowance = _allowance.sub(amount);
259             _approve(sender, msg.sender, updatedAllowance);
260         }
261         return true;
262     }
263 
264     function burn(uint256 amount) public {
265         _burn(msg.sender, amount);
266     }
267 
268     function _mint(address account, uint256 amount) internal {
269         require(account != address(0), "ERC20: mint to the zero address");
270 
271         _totalSupply = _totalSupply.add(amount);
272         _balances[account] = _balances[account].add(amount);
273         emit Transfer(address(0), account, amount);
274     }
275 
276     function _transfer(address sender, address recipient, uint256 amount)
277         internal
278     {
279         require(sender != address(0), "ERC20: transfer from the zero address");
280         require(recipient != address(0), "ERC20: transfer to the zero address");
281 
282         _balances[sender] = _balances[sender].sub(amount);
283         _balances[recipient] = _balances[recipient].add(amount);
284         emit Transfer(sender, recipient, amount);
285     }
286 
287     function _approve(address owner, address spender, uint256 value) internal {
288         require(owner != address(0), "ERC20: approve from the zero address");
289         require(spender != address(0), "ERC20: approve to the zero address");
290 
291         _allowances[owner][spender] = value;
292         emit Approval(owner, spender, value);
293     }
294 
295     function _burn(address account, uint256 value) internal {
296         require(account != address(0), "ERC20: burn from the zero address");
297 
298         _totalSupply = _totalSupply.sub(value);
299         _balances[account] = _balances[account].sub(value);
300         emit Transfer(account, address(0), value);
301     }
302 }
303 
304 /*
305 This file incorporates code covered by the following terms:
306 
307 The MIT License (MIT)
308 
309 Copyright (c) 2016-2019 zOS Global Limited
310 
311 Permission is hereby granted, free of charge, to any person obtaining
312 a copy of this software and associated documentation files (the
313 "Software"), to deal in the Software without restriction, including
314 without limitation the rights to use, copy, modify, merge, publish,
315 distribute, sublicense, and/or sell copies of the Software, and to
316 permit persons to whom the Software is furnished to do so, subject to
317 the following conditions:
318 
319 The above copyright notice and this permission notice shall be included
320 in all copies or substantial portions of the Software.
321 */