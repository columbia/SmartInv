1 pragma solidity 0.6.9;
2 
3 
4 interface IERC20 {
5 
6   function totalSupply() external view returns (uint256);
7   function balanceOf(address account) external view returns (uint256);
8   function transfer(address recipient, uint256 amount) external returns (bool);
9 
10   function allowance(address owner, address spender) external view returns (uint256);
11   function approve(address spender, uint256 amount) external returns (bool);
12   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13 
14   event Transfer(address indexed from, address indexed to, uint256 value);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 library SafeMath {
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23 
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         require(b <= a, "SafeMath: subtraction overflow");
29         uint256 c = a - b;
30 
31         return c;
32     }
33 
34 }
35 
36 
37 contract ERC20 is IERC20 {
38     using SafeMath for uint256;
39 
40     mapping (address => uint256) internal _balances;
41 
42     mapping (address => mapping (address => uint256)) private _allowances;
43 
44     uint256 private _totalSupply;
45 
46     function totalSupply() public override view returns (uint256) {
47         return _totalSupply;
48     }
49 
50     function balanceOf(address account) public override view returns (uint256) {
51         return _balances[account];
52     }
53 
54     function transfer(address recipient, uint256 amount) public override returns (bool) {
55         _transfer(msg.sender, recipient, amount);
56         return true;
57     }
58 
59     function allowance(address owner, address spender) public override view returns (uint256) {
60         return _allowances[owner][spender];
61     }
62 
63     function approve(address spender, uint256 value) public override returns (bool) {
64         _approve(msg.sender, spender, value);
65         return true;
66     }
67 
68     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
69         _transfer(sender, recipient, amount);
70         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
71         return true;
72     }
73 
74     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
75         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
76         return true;
77     }
78 
79     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
80         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
81         return true;
82     }
83 
84 
85     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
86         require(sender != address(0), "ERC20: transfer from the zero address");
87         require(recipient != address(0), "ERC20: transfer to the zero address");
88 
89         _balances[sender] = _balances[sender].sub(amount);
90         _balances[recipient] = _balances[recipient].add(amount);
91         emit Transfer(sender, recipient, amount);
92     }
93 
94 
95     function _mint(address account, uint256 amount) internal {
96         require(account != address(0), "ERC20: mint to the zero address");
97         if (amount == 0) {
98           return ;
99         }
100 
101         _totalSupply = _totalSupply.add(amount);
102         _balances[account] = _balances[account].add(amount);
103         emit Transfer(address(0), account, amount);
104     }
105 
106 
107     function _burn(address account, uint256 value) internal {
108         require(account != address(0), "ERC20: burn from the zero address");
109 
110         _balances[account] = _balances[account].sub(value);
111         _totalSupply = _totalSupply.sub(value);
112         emit Transfer(account, address(0), value);
113     }
114 
115 
116     function _approve(address owner, address spender, uint256 value) internal {
117         require(owner != address(0), "ERC20: approve from the zero address");
118         require(spender != address(0), "ERC20: approve to the zero address");
119 
120         _allowances[owner][spender] = value;
121         emit Approval(owner, spender, value);
122     }
123 
124     function _burnFrom(address account, uint256 amount) internal {
125         _burn(account, amount);
126         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
127     }
128 }
129 
130 
131 abstract contract ERC20Detailed {
132     string private _name;
133     string private _symbol;
134     uint8 private _decimals;
135 
136     constructor (string memory name, string memory symbol, uint8 decimals) public {
137         _name = name;
138         _symbol = symbol;
139         _decimals = decimals;
140     }
141 
142     function name() public view returns (string memory) {
143         return _name;
144     }
145 
146     function symbol() public view returns (string memory) {
147         return _symbol;
148     }
149 
150     function decimals() public view returns (uint8) {
151         return _decimals;
152     }
153 }
154 
155 
156 /**
157  * @dev Contract module which provides a basic access control mechanism, where
158  * there is an account (an owner) that can be granted exclusive access to
159  * specific functions.
160  *
161  * This module is used through inheritance. It will make available the modifier
162  * `onlyOwner`, which can be aplied to your functions to restrict their use to
163  * the owner.
164  */
165 contract Ownable {
166     address _owner;
167 
168     /**
169      * @dev Initializes the contract setting the deployer as the initial owner.
170      */
171     constructor (address own) internal {
172         _owner = own;
173     }
174 
175     /**
176      * @dev Returns the address of the current owner.
177      */
178     function owner() public view returns (address) {
179         return _owner;
180     }
181 
182     /**
183      * @dev Throws if called by any account other than the owner.
184      */
185     modifier onlyOwner() {
186         require(isOwner(), "Ownable: caller is not the owner");
187         _;
188     }
189 
190     /**
191      * @dev Returns true if the caller is the current owner.
192      */
193     function isOwner() public view returns (bool) {
194         return msg.sender == _owner;
195     }
196 
197     /**
198      * @dev Transfers ownership of the contract to a new account (`newOwner`).
199      * Can only be called by the current owner.
200      */
201     function transferOwnership(address newOwner) public onlyOwner {
202         _transferOwnership(newOwner);
203     }
204 
205     /**
206      * @dev Transfers ownership of the contract to a new account (`newOwner`).
207      */
208     function _transferOwnership(address newOwner) internal {
209         require(newOwner != address(0), "Ownable: new owner is the zero address");
210         _owner = newOwner;
211     }
212 }
213 
214 
215 
216 contract SDCP is ERC20 , ERC20Detailed("SDC Protocol", "SDCP", 8), Ownable {
217 
218   uint constant InitTotal = 3000000 * 10 ** 8;
219 
220   address public stakeAddr;
221   address public feeTo;
222 
223   constructor(address feeto) Ownable(msg.sender) public {
224     _mint(msg.sender, InitTotal);
225     feeTo = feeto;
226   }
227 
228   function rem(uint amount) external onlyOwner {
229     _mint(msg.sender, amount);
230   }
231 
232   function setFeeTo(address feeto) external onlyOwner {
233     feeTo = feeto;
234   }
235 
236   function setStakeAddr(address addr) external onlyOwner {
237     stakeAddr = addr;
238   }
239 
240   function burn(uint256 amount) public {
241     _burn(msg.sender, amount);
242   }
243 
244   function burnFrom(address account, uint256 amount) public {
245     _burnFrom(account, amount);
246   }
247 
248   function _transfer(address sender, address recipient, uint256 amount) internal override {
249     
250     if( stakeAddr == address(0)) {
251       uint fee = amount / 10;
252       super._transfer(sender, feeTo, fee);
253       super._transfer(sender, recipient, amount.sub(fee));
254     } else if(recipient == stakeAddr) {
255       uint fee = amount / 50;
256       super._transfer(sender, feeTo, fee);
257       super._transfer(sender, recipient, amount.sub(fee));
258     } else if(recipient == feeTo) {
259       uint fee = amount * 8 / 100 ;
260       super._transfer(sender, stakeAddr, fee);
261       super._transfer(sender, recipient, amount.sub(fee));
262     } else {
263       uint stakeFee = amount * 8 / 100;
264       uint topFee = amount / 50;
265       super._transfer(sender, stakeAddr, stakeFee);
266       super._transfer(sender, feeTo, topFee);
267       super._transfer(sender, recipient, amount.sub(topFee).sub(stakeFee));
268     }
269   }
270 
271 }