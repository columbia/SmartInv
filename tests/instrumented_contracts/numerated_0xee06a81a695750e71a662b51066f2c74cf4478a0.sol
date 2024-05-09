1 // SPDX-License-Identifier: -- 🎲 --
2 
3 pragma solidity ^0.7.5;
4 
5 contract Context {
6 
7     function _msgSender() internal view virtual returns (address payable) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this;
13         return msg.data;
14     }
15 }
16 
17 contract ERC20 is Context {
18     using SafeMath for uint256;
19 
20     mapping (address => uint256) private _balances;
21     mapping (address => mapping (address => uint256)) private _allowances;
22 
23     uint256 private _totalSupply;
24 
25     string private _name;
26     string private _symbol;
27     uint8 private _decimals;
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 
32     constructor (string memory __name, string memory __symbol) {
33         _name = __name;
34         _symbol = __symbol;
35         _decimals = 18;
36     }
37 
38     /**
39      * @dev Returns the name of the token.
40      */
41     function name() public view returns (string memory) {
42         return _name;
43     }
44 
45     /**
46      * @dev Returns the symbol of the token, usually a shorter version of the
47      * name.
48      */
49     function symbol() public view returns (string memory) {
50         return _symbol;
51     }
52 
53     function decimals() public view returns (uint8) {
54         return _decimals;
55     }
56 
57     function totalSupply() public view returns (uint256) {
58         return _totalSupply;
59     }
60 
61     function balanceOf(address account) public view returns (uint256) {
62         return _balances[account];
63     }
64 
65     function transfer(
66         address recipient,
67         uint256 amount
68     ) public returns (bool) {
69         _transfer(_msgSender(), recipient, amount);
70         return true;
71     }
72 
73     function allowance(
74         address owner,
75         address spender
76     ) public view returns (uint256) {
77         return _allowances[owner][spender];
78     }
79 
80     function approve(
81         address spender,
82         uint256 amount
83     ) public returns (bool) {
84         _approve(_msgSender(), spender, amount);
85         return true;
86     }
87 
88     function transferFrom(
89         address sender,
90         address recipient,
91         uint256 amount
92     ) public returns (bool) {
93         _transfer(sender, recipient, amount);
94         _approve(sender,
95             _msgSender(), _allowances[sender][_msgSender()].sub(
96                 amount,
97                 "ERC20: transfer amount exceeds allowance"
98             )
99         );
100         return true;
101     }
102 
103     function increaseAllowance(
104         address spender,
105         uint256 addedValue
106     ) public virtual returns (bool) {
107         _approve(
108             _msgSender(), spender, _allowances[_msgSender()][spender].add(
109                 addedValue
110             )
111         );
112         return true;
113     }
114 
115     function decreaseAllowance(
116         address spender,
117         uint256 subtractedValue
118     ) public virtual returns (bool) {
119         _approve(
120             _msgSender(), spender, _allowances[_msgSender()][spender].sub(
121                 subtractedValue,
122                 "ERC20: decreased allowance below zero"
123             )
124         );
125         return true;
126     }
127 
128     /**
129      * @dev Moves tokens `amount` from `sender` to `recipient`.
130      *
131      * Emits a {Transfer} event.
132      * Requirements:
133      *
134      * - `sender` cannot be the zero address.
135      * - `recipient` cannot be the zero address.
136      * - `sender` must have a balance of at least `amount`.
137      */
138     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
139 
140         require(
141             sender != address(0),
142             "ERC20: transfer from the zero address"
143         );
144 
145         require(
146             recipient != address(0),
147             "ERC20: transfer to the zero address"
148         );
149 
150         _balances[sender] = _balances[sender].sub(
151             amount,
152             "ERC20: transfer amount exceeds balance"
153         );
154 
155         _balances[recipient] = _balances[recipient].add(amount);
156         emit Transfer(sender, recipient, amount);
157     }
158 
159     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
160      * the total supply.
161      *
162      * Emits a {Transfer} event with `from` set to the zero address.
163      * Requirements:
164      *
165      * - `to` cannot be the zero address.
166      */
167     function _mint(address account, uint256 amount) internal virtual {
168 
169         require(
170             account != address(0),
171             "ERC20: mint to the zero address"
172         );
173 
174         _totalSupply = _totalSupply.add(amount);
175         _balances[account] = _balances[account].add(amount);
176         emit Transfer(address(0), account, amount);
177     }
178 
179     /**
180      * @dev Destroys `amount` tokens from `account`, reducing the
181      * total supply.
182      *
183      * Emits a {Transfer} event with `to` set to the zero address.
184      *
185      * Requirements:
186      *
187      * - `account` cannot be the zero address.
188      * - `account` must have at least `amount` tokens.
189      */
190     function _burn(address account, uint256 amount) internal virtual {
191 
192         require(
193             account != address(0x0),
194             "ERC20: burn from the zero address"
195         );
196 
197         _balances[account] = _balances[account].sub(
198             amount,
199             "ERC20: burn amount exceeds balance"
200         );
201 
202         _totalSupply = _totalSupply.sub(amount);
203         emit Transfer(account, address(0), amount);
204     }
205 
206     /**
207      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
208      * Emits an {Approval} event.
209      *
210      * Requirements:
211      *
212      * - `owner` cannot be the zero address.
213      * - `spender` cannot be the zero address.
214      */
215     function _approve(address owner, address spender, uint256 amount) internal virtual {
216 
217         require(
218             owner != address(0x0),
219             "ERC20: approve from the zero address"
220         );
221 
222         require(
223             spender != address(0x0),
224             "ERC20: approve to the zero address"
225         );
226 
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 }
231 
232 contract dgToken is ERC20 {
233     constructor() ERC20("decentral.games", "$DG") {
234         _mint(msg.sender, 1000000E18);
235     }
236 }
237 
238 library SafeMath {
239 
240     function add(uint256 a, uint256 b) internal pure returns (uint256) {
241         uint256 c = a + b;
242         require(c >= a, "SafeMath: addition overflow");
243 
244         return c;
245     }
246 
247     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
248         return sub(a, b, "SafeMath: subtraction overflow");
249     }
250 
251     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b <= a, errorMessage);
253         uint256 c = a - b;
254 
255         return c;
256     }
257 
258     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
259 
260         if (a == 0) {
261             return 0;
262         }
263 
264         uint256 c = a * b;
265         require(c / a == b, "SafeMath: multiplication overflow");
266 
267         return c;
268     }
269 
270     function div(uint256 a, uint256 b) internal pure returns (uint256) {
271         return div(a, b, "SafeMath: division by zero");
272     }
273 
274 
275     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b > 0, errorMessage);
277         uint256 c = a / b;
278         return c;
279     }
280 
281     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
282         return mod(a, b, "SafeMath: modulo by zero");
283     }
284 
285     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b != 0, errorMessage);
287         return a % b;
288     }
289 }