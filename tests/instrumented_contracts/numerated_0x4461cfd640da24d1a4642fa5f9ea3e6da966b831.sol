1 pragma solidity ^0.7.6;
2 
3 contract Context {
4     constructor ()  { }
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38 
39         return c;
40     }
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43         // benefit is lost if 'b' is also tested.
44         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51 
52         return c;
53     }
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         // Solidity only automatically asserts when dividing by 0
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63         return c;
64     }
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         return mod(a, b, "SafeMath: modulo by zero");
67     }
68     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b != 0, errorMessage);
70         return a % b;
71     }
72 }
73 
74 library Address {
75     function isContract(address account) internal view returns (bool) {
76         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
77         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
78         // for accounts without code, i.e. `keccak256('')`
79         bytes32 codehash;
80         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
81         // solhint-disable-next-line no-inline-assembly
82         assembly { codehash := extcodehash(account) }
83         return (codehash != accountHash && codehash != 0x0);
84     }
85     function sendValue(address payable recipient, uint256 amount) internal {
86         require(address(this).balance >= amount, "Address: insufficient balance");
87 
88         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
89         (bool success, ) = recipient.call{ value: amount }("");
90         require(success, "Address: unable to send value, recipient may have reverted");
91     }
92 }
93 
94 abstract contract BPContract{
95     function protect( address sender, address receiver, uint256 amount ) external virtual;
96 }
97 
98 contract Cosmostarter is Context, IERC20 {
99     using SafeMath for uint256;
100     using Address for address;
101     BPContract public BP;
102     bool public bpEnabled;
103     bool public BPDisabledForever = false;
104 
105     address _owner;
106     mapping (address => uint256) private _balances;
107 
108     mapping (address => mapping (address => uint256)) private _allowances;
109 
110     uint256 private _totalSupply;
111 
112     string private _name;
113     string private _symbol;
114     uint8 private _decimals;
115 
116     modifier onlyOwner() {
117         require(msg.sender == _owner);
118         _;
119     }
120 
121     function setBPAddrss(address _bp) external onlyOwner {
122         require(address(BP)== address(0), "Can only be initialized once");
123         BP = BPContract(_bp);
124     }
125     function setBpEnabled(bool _enabled) external onlyOwner {
126         bpEnabled = _enabled;
127     }
128     function setBotProtectionDisableForever() external onlyOwner{
129         require(BPDisabledForever == false);
130         BPDisabledForever = true;
131     }
132 
133     /**
134      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
135      * a default value of 18.
136      *
137      * To select a different value for {decimals}, use {_setupDecimals}.
138      *
139      * All three of these values are immutable: they can only be set once during
140      * construction.
141      */
142     constructor () {
143         _name = "Cosmostarter";
144         _symbol = "CSMS";
145         _decimals = 18;
146         _totalSupply = 0;
147         _mint(msg.sender, 100000000000000000000000000);
148         _owner = msg.sender;
149     }
150 
151     function name() public view returns (string memory) {
152         return _name;
153     }
154     function symbol() public view returns (string memory) {
155         return _symbol;
156     }
157     function decimals() public view returns (uint8) {
158         return _decimals;
159     }
160     function totalSupply() public view override returns (uint256) {
161         return _totalSupply;
162     }
163     function balanceOf(address account) public view override returns (uint256) {
164         return _balances[account];
165     }
166 
167     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
168         _transfer(_msgSender(), recipient, amount);
169         return true;
170     }
171 
172     function allowance(address owner, address spender) public view virtual override returns (uint256) {
173         return _allowances[owner][spender];
174     }
175 
176     function approve(address spender, uint256 amount) public virtual override returns (bool) {
177         _approve(_msgSender(), spender, amount);
178         return true;
179     }
180 
181     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
182         _transfer(sender, recipient, amount);
183         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
184         return true;
185     }
186 
187     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
188         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
189         return true;
190     }
191 
192     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
193         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
194         return true;
195     }
196 
197     /**
198      * @dev Moves tokens `amount` from `sender` to `recipient`.
199      *
200      * This is internal function is equivalent to {transfer}, and can be used to
201      * e.g. implement automatic token fees, slashing mechanisms, etc.
202      *
203      * Emits a {Transfer} event.
204      *
205      * Requirements:
206      *
207      * - `sender` cannot be the zero address.
208      * - `recipient` cannot be the zero address.
209      * - `sender` must have a balance of at least `amount`.
210      */
211     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
212         if (bpEnabled && !BPDisabledForever){
213             BP.protect(sender, recipient, amount);
214         }
215 
216         require(sender != address(0), "ERC20: transfer from the zero address");
217         require(recipient != address(0), "ERC20: transfer to the zero address");
218 
219         _beforeTokenTransfer(sender, recipient, amount);
220 
221         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
222         _balances[recipient] = _balances[recipient].add(amount);
223         emit Transfer(sender, recipient, amount);
224     }
225 
226     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
227      * the total supply.
228      *
229      * Emits a {Transfer} event with `from` set to the zero address.
230      *
231      * Requirements
232      *
233      * - `to` cannot be the zero address.
234      */
235     function _mint(address account, uint256 amount) internal virtual {
236         require(account != address(0), "ERC20: mint to the zero address");
237 
238         _beforeTokenTransfer(address(0), account, amount);
239 
240         _totalSupply = _totalSupply.add(amount);
241         _balances[account] = _balances[account].add(amount);
242         emit Transfer(address(0), account, amount);
243     }
244 
245     /**
246      * @dev Destroys `amount` tokens from `account`, reducing the
247      * total supply.
248      *
249      * Emits a {Transfer} event with `to` set to the zero address.
250      *
251      * Requirements
252      *
253      * - `account` cannot be the zero address.
254      * - `account` must have at least `amount` tokens.
255      */
256     function _burn(address account, uint256 amount) internal virtual {
257         require(account != address(0), "ERC20: burn from the zero address");
258 
259         _beforeTokenTransfer(account, address(0), amount);
260 
261         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
262         _totalSupply = _totalSupply.sub(amount);
263         emit Transfer(account, address(0), amount);
264     }
265 
266     /**
267      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
268      *
269      * This is internal function is equivalent to `approve`, and can be used to
270      * e.g. set automatic allowances for certain subsystems, etc.
271      *
272      * Emits an {Approval} event.
273      *
274      * Requirements:
275      *
276      * - `owner` cannot be the zero address.
277      * - `spender` cannot be the zero address.
278      */
279     function _approve(address owner, address spender, uint256 amount) internal virtual {
280         require(owner != address(0), "ERC20: approve from the zero address");
281         require(spender != address(0), "ERC20: approve to the zero address");
282 
283         _allowances[owner][spender] = amount;
284         emit Approval(owner, spender, amount);
285     }
286 
287     /**
288      * @dev Sets {decimals} to a value other than the default one of 18.
289      *
290      * WARNING: This function should only be called from the constructor. Most
291      * applications that interact with token contracts will not expect
292      * {decimals} to ever change, and may work incorrectly if it does.
293      */
294     function _setupDecimals(uint8 decimals_) internal {
295         _decimals = decimals_;
296     }
297 
298     /**
299      * @dev Hook that is called before any transfer of tokens. This includes
300      * minting and burning.
301      *
302      * Calling conditions:
303      *
304      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
305      * will be to transferred to `to`.
306      * - when `from` is zero, `amount` tokens will be minted for `to`.
307      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
308      * - `from` and `to` are never both zero.
309      *
310      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
311      */
312     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
313 }