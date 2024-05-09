1 pragma solidity 0.6.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8 
9     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
10         require(b <= a, "SafeMath: subtraction overflow");
11         uint256 c = a - b;
12 
13         return c;
14     }
15 
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 }
23 
24 /**
25  * @title Ownable
26  * @dev The Ownable contract has an owner address, and provides basic authorization control
27  * functions, this simplifies the implementation of "user permissions".
28  */
29 contract Ownable {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     constructor(address initialOwner) internal {
35         require(initialOwner != address(0), "Ownable: initial owner is the zero address");
36         _owner = initialOwner;
37         emit OwnershipTransferred(address(0), _owner);
38     }
39 
40     function owner() public view returns (address) {
41         return _owner;
42     }
43 
44     modifier onlyOwner() {
45         require(isOwner(), "Ownable: caller is not the owner");
46         _;
47     }
48 
49     function isOwner() public view returns (bool) {
50         return msg.sender == _owner;
51     }
52 
53     function transferOwnership(address newOwner) public onlyOwner {
54         require(newOwner != address(0), "Ownable: new owner is the zero address");
55         emit OwnershipTransferred(_owner, newOwner);
56         _owner = newOwner;
57     }
58 }
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://eips.ethereum.org/EIPS/eip-20
63  */
64 interface IERC20 {
65     function transfer(address to, uint256 value) external returns (bool);
66     function approve(address spender, uint256 value) external returns (bool);
67     function transferFrom(address from, address to, uint256 value) external returns (bool);
68     function totalSupply() external view returns (uint256);
69     function balanceOf(address who) external view returns (uint256);
70     function allowance(address owner, address spender) external view returns (uint256);
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 /**
76  * @title Standard ERC20 token
77  *
78  * @dev Implementation of the basic standard token.
79  * See https://eips.ethereum.org/EIPS/eip-20
80  */
81 contract ERC20 is IERC20 {
82     using SafeMath for uint256;
83 
84     mapping (address => uint256) private _balances;
85 
86     mapping (address => mapping (address => uint256)) private _allowances;
87 
88     uint256 private _totalSupply;
89 
90     string internal _name;
91     string internal _symbol;
92     uint8 internal _decimals;
93 
94     function name() public view returns (string memory) {
95         return _name;
96     }
97 
98     function symbol() public view returns (string memory) {
99         return _symbol;
100     }
101 
102     function decimals() public view returns (uint8) {
103         return _decimals;
104     }
105 
106     function totalSupply() public view override returns (uint256) {
107         return _totalSupply;
108     }
109 
110     function balanceOf(address account) public view override returns (uint256) {
111         return _balances[account];
112     }
113 
114     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
115         _transfer(msg.sender, recipient, amount);
116         return true;
117     }
118 
119     function allowance(address owner, address spender) public view virtual override returns (uint256) {
120         return _allowances[owner][spender];
121     }
122 
123     function approve(address spender, uint256 amount) public virtual override returns (bool) {
124         _approve(msg.sender, spender, amount);
125         return true;
126     }
127 
128     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
129         _transfer(sender, recipient, amount);
130         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
131         return true;
132     }
133 
134     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
135         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
136         return true;
137     }
138 
139     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
140         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
141         return true;
142     }
143 
144     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
145         require(sender != address(0), "ERC20: transfer from the zero address");
146         require(recipient != address(0), "ERC20: transfer to the zero address");
147 
148         _balances[sender] = _balances[sender].sub(amount);
149         _balances[recipient] = _balances[recipient].add(amount);
150         emit Transfer(sender, recipient, amount);
151     }
152 
153     function _mint(address account, uint256 amount) internal virtual {
154         require(account != address(0), "ERC20: mint to the zero address");
155 
156         _totalSupply = _totalSupply.add(amount);
157         _balances[account] = _balances[account].add(amount);
158         emit Transfer(address(0), account, amount);
159     }
160 
161     function _approve(address owner, address spender, uint256 amount) internal virtual {
162         require(owner != address(0), "ERC20: approve from the zero address");
163         require(spender != address(0), "ERC20: approve to the zero address");
164 
165         _allowances[owner][spender] = amount;
166         emit Approval(owner, spender, amount);
167     }
168 
169 }
170 
171 /**
172  * @title ApproveAndCall Interface.
173  * @dev ApproveAndCall system allows to communicate with smart-contracts.
174  */
175 abstract contract ApproveAndCallFallBack {
176     function receiveApproval(address from, uint256 amount, address token, bytes calldata extraData) virtual external;
177 }
178 
179 /**
180  * @title The main project contract.
181  */
182 contract DigexToken is ERC20, Ownable {
183 
184     // registered contracts (to prevent loss of token via transfer function)
185     mapping (address => bool) private _contracts;
186 
187     /**
188       * @dev constructor function that is called once at deployment of the contract.
189       * @param recipient Address to receive initial supply.
190       */
191     constructor(address initialOwner, address recipient) public Ownable(initialOwner) {
192 
193         // name of the token
194         _name = "Digex";
195         // symbol of the token
196         _symbol = "DIGEX";
197         // decimals of the token
198         _decimals = 0;
199 
200         // creation of initial supply
201         _mint(recipient, 21000000000);
202 
203     }
204 
205     /**
206     * @dev Allows to send tokens (via Approve and TransferFrom) to other smart-contract.
207     * @param spender Address of smart contracts to work with.
208     * @param amount Amount of tokens to send.
209     * @param extraData Any extra data.
210     */
211     function approveAndCall(address spender, uint256 amount, bytes memory extraData) public returns (bool) {
212         require(approve(spender, amount));
213 
214         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, amount, address(this), extraData);
215 
216         return true;
217     }
218 
219     /**
220      * @dev modified transfer function that allows to safely send tokens to smart-contract.
221      * @param to The address to transfer to.
222      * @param value The amount to be transferred.
223      */
224     function transfer(address to, uint256 value) public override returns (bool) {
225 
226         if (_contracts[to]) {
227             approveAndCall(to, value, new bytes(0));
228         } else {
229             super.transfer(to, value);
230         }
231 
232         return true;
233 
234     }
235 
236     /**
237      * @dev Allows to register other smart-contracts (to prevent loss of tokens via transfer function).
238      * @param account Address of smart contracts to work with.
239      */
240     function registerContract(address account) external onlyOwner {
241         require(_isContract(account), "DigexToken: account is not a smart-contract");
242         _contracts[account] = true;
243     }
244 
245     /**
246      * @dev Allows to unregister registered smart-contracts.
247      * @param account Address of smart contracts to work with.
248      */
249     function unregisterContract(address account) external onlyOwner {
250         require(isRegistered(account), "DigexToken: account is not registered yet");
251         _contracts[account] = false;
252     }
253 
254     /**
255     * @dev Allows to any owner of the contract withdraw needed ERC20 token from this contract (for example promo or bounties).
256     * @param ERC20Token Address of ERC20 token.
257     * @param recipient Account to receive tokens.
258     */
259     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
260         require(recipient != address(0), "DigexToken: recipient is the zero address");
261 
262         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
263         IERC20(ERC20Token).transfer(recipient, amount);
264 
265     }
266 
267     /**
268      * @return true if the address is registered as contract
269      * @param account Address to be checked.
270      */
271     function isRegistered(address account) public view returns (bool) {
272         return _contracts[account];
273     }
274 
275     /**
276      * @return true if `account` is a contract.
277      * @param account Address to be checked.
278      */
279     function _isContract(address account) internal view returns (bool) {
280         uint256 size;
281         assembly { size := extcodesize(account) }
282         return size > 0;
283     }
284 
285 }