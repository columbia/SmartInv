1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-09
3 */
4 
5 pragma solidity ^0.5.10;
6 
7 contract Ownable {
8     address private _owner;
9 
10     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12     constructor () internal {
13         address msgSender = _msgSender();
14         _owner = msgSender;
15         emit OwnershipTransferred(address(0), msgSender);
16     }
17 
18     function owner() public view returns (address) {
19         return _owner;
20     }
21 
22     modifier onlyOwner() {
23         require(_owner == _msgSender(), "Ownable: caller is not the owner");
24         _;
25     }
26 
27     function renounceOwnership() public onlyOwner {
28         emit OwnershipTransferred(_owner, address(0));
29         _owner = address(0);
30     }
31 
32     function transferOwnership(address newOwner) public onlyOwner {
33         require(newOwner != address(0), "Ownable: new owner is the zero address");
34         emit OwnershipTransferred(_owner, newOwner);
35         _owner = newOwner;
36     }
37     
38     function _msgSender() internal view returns (address payable) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view returns (bytes memory) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 interface IERC20 {
49     function totalSupply() external view returns (uint256);
50     function balanceOf(address account) external view returns (uint256);
51     function transfer(address recipient, uint256 amount) external returns (bool);
52     function allowance(address owner, address spender) external view returns (uint256);
53     function approve(address spender, uint256 amount) external returns (bool);
54     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 library SafeMath {
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "SafeMath: addition overflow");
64 
65         return c;
66     }
67 
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         return sub(a, b, "SafeMath: subtraction overflow");
70     }
71 
72     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b <= a, errorMessage);
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     function div(uint256 a, uint256 b) internal pure returns (uint256) {
94         return div(a, b, "SafeMath: division by zero");
95     }
96 
97     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
98         require(b > 0, errorMessage);
99         uint256 c = a / b;
100         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101 
102         return c;
103     }
104 
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         return mod(a, b, "SafeMath: modulo by zero");
107     }
108 
109     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
110         require(b != 0, errorMessage);
111         return a % b;
112     }
113 }
114 
115 contract ERC20 is Ownable, IERC20 {
116     using SafeMath for uint256;
117 
118     mapping (address => uint256) private _balances;
119 
120     mapping (address => mapping (address => uint256)) private _allowances;
121 
122     uint256 private _totalSupply;
123 
124     string private _name;
125     string private _symbol;
126     uint8 private _decimals;
127 
128     constructor () public {
129         _name = "Hepius";
130         _symbol = "HEP";
131         _decimals = 6;
132         mint(_msgSender(), 1000000000 * 10**6);
133     }
134 
135     function name() public view returns (string memory) {
136         return _name;
137     }
138 
139     function symbol() public view returns (string memory) {
140         return _symbol;
141     }
142 
143     function decimals() public view returns (uint8) {
144         return _decimals;
145     }
146 
147     function totalSupply() public view returns (uint256) {
148         return _totalSupply;
149     }
150 
151     function balanceOf(address account) public view returns (uint256) {
152         return _balances[account];
153     }
154 
155     function transfer(address recipient, uint256 amount) public returns (bool) {
156         _transfer(_msgSender(), recipient, amount);
157         return true;
158     }
159 
160     function allowance(address owner, address spender) public view returns (uint256) {
161         return _allowances[owner][spender];
162     }
163 
164     function approve(address spender, uint256 amount) public returns (bool) {
165         _approve(_msgSender(), spender, amount);
166         return true;
167     }
168 
169     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
170         _transfer(sender, recipient, amount);
171         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
172         return true;
173     }
174 
175     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
176         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
177         return true;
178     }
179 
180     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
181         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
182         return true;
183     }
184 
185     function mint(address account, uint256 amount) onlyOwner internal returns (bool) {
186         require(account != address(0), "ERC20: mint to the zero address");
187 
188         _beforeTokenTransfer(address(0), account, amount);
189 
190         _totalSupply = _totalSupply.add(amount);
191         _balances[account] = _balances[account].add(amount);
192         emit Transfer(address(0), account, amount);
193         return true;
194     }
195 
196     function burn(address account, uint256 amount) onlyOwner internal returns (bool) {
197         require(account != address(0), "ERC20: burn from the zero address");
198 
199         _beforeTokenTransfer(account, address(0), amount);
200 
201         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
202         _totalSupply = _totalSupply.sub(amount);
203         emit Transfer(account, address(0), amount);
204         return true;
205     }
206 
207     function _transfer(address sender, address recipient, uint256 amount) internal {
208         require(sender != address(0), "ERC20: transfer from the zero address");
209         require(recipient != address(0), "ERC20: transfer to the zero address");
210 
211         _beforeTokenTransfer(sender, recipient, amount);
212 
213         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
214         _balances[recipient] = _balances[recipient].add(amount);
215         emit Transfer(sender, recipient, amount);
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) internal {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221 
222         _allowances[owner][spender] = amount;
223         emit Approval(owner, spender, amount);
224     }
225 
226     function _setupDecimals(uint8 decimals_) internal {
227         _decimals = decimals_;
228     }
229 
230     function _beforeTokenTransfer(address from, address to, uint256 amount) internal { }
231 }