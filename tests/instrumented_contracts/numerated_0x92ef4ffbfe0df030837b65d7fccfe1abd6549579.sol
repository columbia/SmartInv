1 pragma solidity ^0.6.0;
2 
3 contract Context {
4     constructor () internal { }
5 
6     function _msgSender() internal view returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15  
16  contract Ownable is Context {
17     address payable private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor () internal {
22         address payable msgSender = _msgSender();
23         _owner = msgSender;
24         emit OwnershipTransferred(address(0), msgSender);
25     }
26 
27     function owner() public view returns (address payable) {
28         return _owner;
29     }
30 
31     modifier onlyOwner() {
32         require(isOwner(), "Ownable: caller is not the owner");
33         _;
34     }
35 
36     function isOwner() public view returns (bool) {
37         return _msgSender() == _owner;
38     }
39 
40     
41 
42     function transferOwnership(address payable newOwner) public onlyOwner {
43         _transferOwnership(newOwner);
44     }
45 
46     function _transferOwnership(address payable newOwner) internal {
47         require(newOwner != address(0), "Ownable: new owner is the zero address");
48         emit OwnershipTransferred(_owner, newOwner);
49         _owner = newOwner;
50     }
51 }
52 
53 library SafeMath {
54     
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65 
66     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b <= a, errorMessage);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         return div(a, b, "SafeMath: division by zero");
89     }
90 
91     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         // Solidity only automatically asserts when dividing by 0
93         require(b > 0, errorMessage);
94         uint256 c = a / b;
95         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96 
97         return c;
98     }
99 
100     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
101         return mod(a, b, "SafeMath: modulo by zero");
102     }
103 
104     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b != 0, errorMessage);
106         return a % b;
107     }
108 }
109 
110 interface IERC20 {
111     function totalSupply() external view returns (uint256);
112     function balanceOf(address account) external view returns (uint256);
113     function transfer(address recipient, uint256 amount) external returns (bool);
114     function allowance(address owner, address spender) external view returns (uint256);
115     function approve(address spender, uint256 amount) external returns (bool);
116     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
117     event Transfer(address indexed from, address indexed to, uint256 value);
118     event Approval(address indexed owner, address indexed spender, uint256 value);
119     
120 }
121 
122 
123 
124 abstract contract ERC20Detailed is IERC20 {
125     string private _name;
126     string private _symbol;
127     uint8 private _decimals;
128 
129    
130     constructor (string memory name, string memory symbol, uint8 decimals) public {
131         _name = name;
132         _symbol = symbol;
133         _decimals = decimals;
134     }
135 
136     function name() public view returns (string memory) {
137         return _name;
138     }
139 
140     function symbol() public view returns (string memory) {
141         return _symbol;
142     }
143 
144     function decimals() public view returns (uint8) {
145         return _decimals;
146     }
147 }
148 
149 
150 contract SWG is  Context, Ownable, IERC20 , ERC20Detailed  {
151     using SafeMath for uint256;
152 
153     mapping (address => uint256) public _balances;
154     mapping (address => mapping (address => uint256)) private _allowances;
155    
156     uint256 private _totalSupply;
157   
158  
159     
160     constructor() public ERC20Detailed("Swirge", "SWG", 18){
161         _createToken(_msgSender(), 80000000*10**18);
162     }
163 
164     function totalSupply() override public view returns (uint256) {
165         return _totalSupply;
166     }
167 
168     function balanceOf(address account) override public view returns (uint256) {
169         return _balances[account];
170     }
171 
172     function transfer(address recipient, uint256 amount) override public returns (bool) {
173         _transfer(_msgSender(), recipient, amount);
174         return true;
175     }
176 
177     function allowance(address owner, address spender) override public view returns (uint256) {
178         return _allowances[owner][spender];
179     }
180 
181     function approve(address spender, uint256 amount) override public returns (bool) {
182         _approve(_msgSender(), spender, amount);
183         return true;
184     }
185 
186     function transferFrom(address sender, address recipient, uint256 amount) override public returns (bool) {
187         _transfer(sender, recipient, amount);
188         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
189         return true;
190     }
191 
192     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
193         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
194         return true;
195     }
196 
197     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
198         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
199         return true;
200     }
201 
202     function _transfer(address sender, address recipient, uint256 amount) internal {
203         require(sender != address(0), "ERC20: transfer from the zero address");
204         require(recipient != address(0), "ERC20: transfer to the zero address");
205           _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
206           _balances[recipient]=_balances[recipient].add(amount);
207          emit Transfer(sender,recipient,amount);
208         
209     }
210 
211    function _createToken(address account, uint256 amount) private {
212         require(account != address(0), "ERC20: mint to the zero address");
213 
214         _totalSupply = _totalSupply.add(amount);
215         
216         _balances[account] = _balances[account].add(amount);
217         
218         
219         emit Transfer(address(0), account,amount);
220     }
221 
222     
223 
224     function _approve(address owner, address spender, uint256 amount) internal {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227 
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 
232    
233      
234 }