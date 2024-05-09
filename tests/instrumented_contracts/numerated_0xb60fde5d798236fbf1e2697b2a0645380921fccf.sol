1 pragma solidity ^0.5.2;
2 
3 /*
4 *  STONK.sol
5 *  STONK v4 0.3125% FoT token smart contract
6 *  2020-06-20
7 **/
8 
9 interface IERC20 {
10     function totalSupply() external view returns(uint256);
11 
12     function balanceOf(address who) external view returns(uint256);
13 
14     function allowance(address owner, address spender) external view returns(uint256);
15 
16     function transfer(address to, uint256 value) external returns(bool);
17 
18     function approve(address spender, uint256 value) external returns(bool);
19 
20     function transferFrom(address from, address to, uint256 value) external returns(bool);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27 
28     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b);
35 
36         return c;
37     }
38 
39     function div(uint256 a, uint256 b) internal pure returns(uint256) {
40         require(b > 0);
41         uint256 c = a / b;
42 
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
47         require(b <= a);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     function add(uint256 a, uint256 b) internal pure returns(uint256) {
54         uint256 c = a + b;
55         require(c >= a);
56 
57         return c;
58     }
59 
60     function ceil(uint256 a, uint256 m) internal pure returns(uint256) {
61         uint256 c = add(a, m);
62         uint256 d = sub(c, 1);
63         return mul(div(d, m), m);
64     }
65 }
66 
67 contract ERC20Detailed is IERC20 {
68 
69     string private _name;
70     string private _symbol;
71     uint8 private _decimals;
72 
73     constructor(string memory name, string memory symbol, uint8 decimals) public {
74         _name = name;
75         _symbol = symbol;
76         _decimals = decimals;
77     }
78 
79     function name() public view returns(string memory) {
80         return _name;
81     }
82 
83     function symbol() public view returns(string memory) {
84         return _symbol;
85     }
86 
87     function decimals() public view returns(uint8) {
88         return _decimals;
89     }
90 }
91 
92 contract STONK is ERC20Detailed {
93 
94     using SafeMath for uint256;
95     mapping(address => uint256) private _balances;
96     mapping(address => mapping(address => uint256)) private _allowances;
97 
98     uint256 private _totalSupply = 101000000000000000000000000;
99 
100     /// @note The base percent for the burn amount.
101     uint256 public basePercent = 320;
102 
103     constructor() public ERC20Detailed("STONK", "STONK", 18) {
104         _mint(msg.sender, _totalSupply);
105     }
106 
107     /// @return Total number of tokens in circulation
108     function totalSupply() public view returns(uint256) {
109         return _totalSupply;
110     }
111 
112     /**
113      * @notice Get the number of tokens held by the `owner`
114      * @param owner The address of the account to get the balance of
115      * @return The number of tokens held
116      */
117     function balanceOf(address owner) public view returns(uint256) {
118         return _balances[owner];
119     }
120 
121     /**
122      * @notice Get the number of tokens `spender` is approved to spend on behalf of `owner`
123      * @param owner The address of the account holding the funds
124      * @param spender The address of the account spending the funds
125      * @return The number of tokens approved
126      */
127     function allowance(address owner, address spender) public view returns(uint256) {
128         return _allowances[owner][spender];
129     }
130 
131     /**
132      * @notice Find the number of tokens to burn from `value`. Approximated at 0.3125%.
133      * @param value The value to find the burn amount from
134      * @return The found burn amount
135      */
136     function findBurnAmount(uint256 value) public view returns(uint256) {
137         //Allow transfers of 0.000000000000000001
138         if (value == 1) {
139             return 0;
140         }
141         uint256 roundValue = value.ceil(basePercent);
142         //Gas optimized
143         uint256 burnAmount = roundValue.mul(100).div(32000);
144         return burnAmount;
145     }
146 
147     /**
148      * @notice Transfer `value` minus `findBurnAmount(value)` tokens from `msg.sender` to `to`, 
149      * while subtracting `findBurnAmount(value)` tokens from `_totalSupply`. This performs a transfer with an approximated fee of 0.3125%
150      * @param to The address of the destination account
151      * @param value The number of tokens to transfer
152      * @return Whether or not the transfer succeeded
153      */
154     function transfer(address to, uint256 value) public returns(bool) {
155         require(to != address(0));
156 
157         uint256 tokensToBurn = findBurnAmount(value);
158         uint256 tokensToTransfer = value.sub(tokensToBurn);
159 
160         _balances[msg.sender] = _balances[msg.sender].sub(value);
161         _balances[to] = _balances[to].add(tokensToTransfer);
162 
163         _totalSupply = _totalSupply.sub(tokensToBurn);
164 
165         emit Transfer(msg.sender, to, tokensToTransfer);
166         emit Transfer(msg.sender, address(0), tokensToBurn);
167         return true;
168     }
169 
170     /**
171      * @notice Approve `spender` to transfer up to `value` from `from`
172      * @dev This will overwrite the approval amount for `spender`
173      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
174      * @param spender The address of the account which may transfer tokens
175      * @param value The number of tokens that are approved
176      * @return Whether or not the approval succeeded
177      */
178     function approve(address spender, uint256 value) public returns(bool) {
179         require(spender != address(0));
180         _allowances[msg.sender][spender] = value;
181         emit Approval(msg.sender, spender, value);
182         return true;
183     }
184 
185     /**
186      * @notice Transfer `value` minus `findBurnAmount(value)` tokens from `from` to `to`, 
187      * while subtracting `findBurnAmount(value)` tokens from `_totalSupply`. This performs a transfer with an approximated fee of 0.3125%
188      * @param from The address of the source account
189      * @param to The address of the destination account
190      * @param value The number of tokens to transfer
191      * @return Whether or not the transfer succeeded
192      */
193     function transferFrom(address from, address to, uint256 value) public returns(bool) {
194         require(value <= _allowances[from][msg.sender]);
195         require(to != address(0));
196 
197         _balances[from] = _balances[from].sub(value);
198 
199         uint256 tokensToBurn = findBurnAmount(value);
200         uint256 tokensToTransfer = value.sub(tokensToBurn);
201 
202         _balances[to] = _balances[to].add(tokensToTransfer);
203         _totalSupply = _totalSupply.sub(tokensToBurn);
204 
205         _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
206 
207         emit Transfer(from, to, tokensToTransfer);
208         emit Transfer(from, address(0), tokensToBurn);
209 
210         return true;
211     }
212 
213     /**
214      * @notice Increase allowance of `spender` by 'addedValue'
215      * @param spender The address of the account which may transfer tokens
216      * @param addedValue Value to be added onto the existing allowance amount
217      * @return Whether or not the allowance increase succeeded
218      */
219     function increaseAllowance(address spender, uint256 addedValue) public returns(bool) {
220         require(spender != address(0));
221         _allowances[msg.sender][spender] = (_allowances[msg.sender][spender].add(addedValue));
222         emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
223         return true;
224     }
225 
226     /**
227      * @notice Decrease allowance of `spender` by 'subtractedValue'
228      * @param spender The address of the account which may transfer tokens
229      * @param subtractedValue Value to be subtracted onto the existing allowance amount
230      * @return Whether or not the allowance decrease succeeded
231      */
232     function decreaseAllowance(address spender, uint256 subtractedValue) public returns(bool) {
233         require(spender != address(0));
234         _allowances[msg.sender][spender] = (_allowances[msg.sender][spender].sub(subtractedValue));
235         emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
236         return true;
237     }
238 
239     function _mint(address account, uint256 amount) internal {
240         require(amount != 0);
241         _balances[account] = _balances[account].add(amount);
242         emit Transfer(address(0), account, amount);
243     }
244 
245     /**
246      * @notice Burn `amount` of tokens from `msg.sender` by sending them to `address(0)`
247      * @param amount The amount of tokens to burn
248      */
249     function burn(uint256 amount) external {
250         _burn(msg.sender, amount);
251     }
252 
253     function _burn(address account, uint256 amount) internal {
254         require(amount != 0);
255         _totalSupply = _totalSupply.sub(amount);
256         _balances[account] = _balances[account].sub(amount);
257         emit Transfer(account, address(0), amount);
258     }
259 
260     /**
261      * @notice Burn `amount` of tokens from `account` by sending them to `address(0)`
262      * @param amount The amount of tokens to burn
263      */
264     function burnFrom(address account, uint256 amount) external {
265         require(amount <= _allowances[account][msg.sender]);
266         _allowances[account][msg.sender] = _allowances[account][msg.sender].sub(amount);
267         _burn(account, amount);
268     }
269 }