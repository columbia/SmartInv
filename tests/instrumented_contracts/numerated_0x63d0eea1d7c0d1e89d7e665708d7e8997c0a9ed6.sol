1 // "SPDX-License-Identifier: MIT"
2 pragma solidity 0.7.2;
3 
4 library SafeMath {
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15 
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19 
20         return c;
21     }
22 
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
25         // benefit is lost if 'b' is also tested.
26         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
27         if (a == 0) {
28             return 0;
29         }
30 
31         uint256 c = a * b;
32         require(c / a == b, "SafeMath: multiplication overflow");
33 
34         return c;
35     }
36 
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40 
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45 
46         return c;
47     }
48 
49     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
50         return mod(a, b, "SafeMath: modulo by zero");
51     }
52 
53     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b != 0, errorMessage);
55         return a % b;
56     }
57 }
58 
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address payable) {
61         return msg.sender;
62     }
63 
64     function _msgData() internal view virtual returns (bytes memory) {
65         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
66         return msg.data;
67     }
68 }
69 
70 interface IERC20 {
71     function totalSupply() external view returns (uint256);
72 
73     function balanceOf(address account) external view returns (uint256);
74 
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     function allowance(address owner, address spender) external view returns (uint256);
78 
79     function approve(address spender, uint256 amount) external returns (bool);
80     
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82    
83     function burn(uint256 amount) external returns(bool);
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 abstract contract Ownable is Context {
91     address private _owner;
92 
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95     constructor() {
96         address msgSender = _msgSender();
97         _owner = msgSender;
98         emit OwnershipTransferred(address(0), msgSender);
99     }
100 
101     function owner() public view returns (address) {
102         return _owner;
103     }
104 
105     modifier onlyOwner() {
106         require(_owner == _msgSender(), "Ownable: caller is not the owner");
107         _;
108     }
109 
110     function renounceOwnership() public virtual onlyOwner {
111         emit OwnershipTransferred(_owner, address(0));
112         _owner = address(0);
113     }
114 
115     function transferOwnership(address newOwner) public virtual onlyOwner {
116         require(newOwner != address(0), "Ownable: new owner is the zero address");
117         emit OwnershipTransferred(_owner, newOwner);
118         _owner = newOwner;
119     }
120 }
121 
122 contract Ethanol is Context, IERC20, Ownable {
123     using SafeMath for uint;
124     address public wallet;
125     uint private _totalSupply;
126     uint public totalBurnt;
127     string private _name;
128     string private _symbol;
129     uint8 private _decimals;
130     
131     
132     mapping (address => uint256) private _balances;
133     mapping (address => mapping (address => uint256)) private _allowances;
134     
135     constructor(address _wallet) {
136         _name = "Ethanol";
137         _symbol = "ENOL";
138         _decimals = 18;
139         
140         uint _amount = 10000 ether;
141         totalBurnt = 0;
142         wallet = _wallet;
143         
144         _totalSupply = _totalSupply.add(_amount);
145         _balances[msg.sender] = _balances[msg.sender].add(_amount);
146         emit Transfer(address(0), msg.sender, _amount);
147     }
148     
149     function name() public view returns (string memory) {
150         return _name;
151     }
152 
153     function symbol() public view returns (string memory) {
154         return _symbol;
155     }
156 
157     function decimals() public view returns (uint8) {
158         return _decimals;
159     }
160 
161     function totalSupply() public view override returns (uint256) {
162         return _totalSupply;
163     }
164 
165     function balanceOf(address account) public view override returns (uint256) {
166         return _balances[account];
167     }
168 
169     function allowance(address owner, address spender) public view virtual override returns (uint256) {
170         return _allowances[owner][spender];
171     }
172 
173     function approve(address spender, uint256 amount) public virtual override returns (bool) {
174         _approve(_msgSender(), spender, amount);
175         return true;
176     }
177 
178     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
179         _transfer(sender, recipient, amount);
180         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
181         return true;
182     }
183 
184     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
185         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
186         return true;
187     }
188 
189     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
190         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
191         return true;
192     }
193 
194     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
195         require(sender != address(0), "ERC20: transfer from the zero address");
196         require(recipient != address(0), "ERC20: transfer to the zero address");
197 
198         _beforeTokenTransfer(sender, recipient, amount);
199 
200         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
201         _balances[recipient] = _balances[recipient].add(amount);
202         emit Transfer(sender, recipient, amount);
203     }
204 
205     function transfer(address _recipient, uint _amount) public override returns (bool) {
206         require(_msgSender() != _recipient, "Sender and Recipient are the same");
207 
208         uint _taxedAmount = _amount.mul(4).div(100);
209         uint _totalBalance = _amount.sub(_taxedAmount);
210         
211         _transfer(_msgSender(), wallet, _taxedAmount); // 4% goes to the wallet
212         _transfer(_msgSender(), _recipient, _totalBalance);
213         
214         return true;
215     }
216 
217     function _burn(address account, uint256 amount) internal virtual {
218         require(account != address(0), "ERC20: burn from the zero address");
219 
220         _beforeTokenTransfer(account, address(0), amount);
221 
222         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
223         totalBurnt = totalBurnt.add(amount);
224         _totalSupply = _totalSupply.sub(amount);
225         emit Transfer(account, address(0), amount);
226     }
227 
228     function _approve(address owner, address spender, uint256 amount) internal virtual {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231 
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function _setupDecimals(uint8 decimals_) internal {
237         _decimals = decimals_;
238     }
239 
240     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
241     
242     function burn(uint256 amount) public override returns(bool) {
243         _burn(_msgSender(), amount);
244         return true;
245     }
246 
247     function burnFrom(address account, uint256 amount) public virtual {
248         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
249 
250         _approve(account, _msgSender(), decreasedAllowance);
251         _burn(account, amount);
252     }
253 }