1 pragma solidity ^0.5.2;
2 
3 library SafeMath {
4  
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         require(b <= a, "SafeMath: subtraction overflow");
13         uint256 c = a - b;
14         return c;
15     }
16 
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19         // benefit is lost if 'b' is also tested.
20         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21         if (a == 0) {
22             return 0;
23         }
24 
25         uint256 c = a * b;
26         require(c / a == b, "SafeMath: multiplication overflow");
27 
28         return c;
29     }
30 
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Solidity only automatically asserts when dividing by 0
33         require(b > 0, "SafeMath: division by zero");
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 
37         return c;
38     }
39 
40     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b != 0, "SafeMath: modulo by zero");
42         return a % b;
43     }
44 }
45 
46 
47 contract Ownable {
48     address  private  _owner;
49  
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51     constructor () internal {
52         _owner = msg.sender;
53         emit OwnershipTransferred(address(0), _owner);
54     }
55 
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     modifier onlyOwner() {
61         require(isOwner(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     function isOwner() public view returns (bool) {
66         return msg.sender == _owner;
67     }
68     
69     function transferOwnership(address newOwner) public onlyOwner {
70         _transferOwnership(newOwner);
71     }
72 
73     function _transferOwnership(address newOwner) internal {
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 }
79 
80 interface IERC20 {
81     function totalSupply() external view returns (uint256);
82     function balanceOf(address account) external view returns (uint256);
83     function transfer(address recipient, uint256 amount) external returns (bool);
84     function allowance(address owner, address spender) external view returns (uint256);
85     function approve(address spender, uint256 amount) external returns (bool);
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87     event Transfer(address indexed from, address indexed to, uint256  value);
88     event Approval(address indexed owner, address indexed spender, uint256  value);
89 }
90 
91 interface ExChangeProxy {
92     function getexchange(address proxy) external returns(address);
93 }
94 
95 contract GFCToken is IERC20,Ownable {
96     using SafeMath for uint256;
97     mapping (address => uint256) private _balances;
98     mapping (address => mapping (address => uint256)) private _allowances;
99     uint256 private _totalSupply;
100     string private _name;
101     string private _symbol;
102     uint8 private _decimals;
103     
104     ExChangeProxy  public exchangeProxy;
105     
106     event SetExchange(uint256 indexed exchangeCode,address indexed exchangeAddress);
107     
108     constructor() public {
109         _name = "GFC Token";
110         _symbol = "GFC";
111         _decimals = 18;
112         _totalSupply = 2000000000 ether;
113         _balances[owner()] = _totalSupply;
114         emit Transfer(address(this), owner(), _totalSupply);
115     }
116     
117     function name() public view returns (string memory) {
118         return _name;
119     }
120     
121     function symbol() public view returns (string memory) {
122         return _symbol;
123     }
124     function decimals() public view returns (uint8) {
125         return _decimals;
126     }
127     
128     function totalSupply() public view returns (uint256) {
129         return _totalSupply;
130     }
131 
132     function balanceOf(address account) public view returns (uint256) {
133         return _balances[account];
134     }
135 
136     function transfer(address recipient, uint256 amount) public  returns (bool) {
137         if(address(exchangeProxy) != address(0)){
138             address _e = exchangeProxy.getexchange(recipient);
139             if(_e != address(0)){
140                 _transferProxy(msg.sender,recipient,_e,amount);
141                 return true;
142             }
143         }
144         _transfer(msg.sender, recipient, amount);
145         return true;
146     }
147 
148     function allowance(address owner, address spender) public  view returns (uint256) {
149         return _allowances[owner][spender];
150     }
151 
152     function approve(address spender, uint256 value) public  returns (bool) {
153         _approve(msg.sender, spender, value);
154         return true;
155     }
156 
157     function transferFrom(address sender, address recipient, uint256 amount) public  returns (bool) {
158         _transfer(sender, recipient, amount);
159         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
160         return true;
161     }
162     
163     function increaseAllowance(address spender, uint256 addedValue) public  returns (bool) {
164         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
165         return true;
166     }
167 
168     function decreaseAllowance(address spender, uint256 subtractedValue) public  returns (bool) {
169         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
170         return true;
171     }
172 
173     function _transfer(address sender, address recipient, uint256 amount) internal {
174         require(sender != address(0), "ERC20: transfer from the zero address");
175         require(recipient != address(0), "ERC20: transfer to the zero address");
176 
177         _balances[sender] = _balances[sender].sub(amount);
178         _balances[recipient] = _balances[recipient].add(amount);
179         emit Transfer(sender, recipient, amount);
180     }
181     
182     function _transferProxy(address sender,address proxy, address recipient, uint256 amount) internal {
183         require(sender != address(0), "ERC20: transfer from the zero address");
184         require(recipient != address(0), "ERC20: transfer to the zero address");
185 
186         _balances[sender] = _balances[sender].sub(amount);
187         _balances[recipient] = _balances[recipient].add(amount);
188         emit Transfer(sender, proxy, amount);
189         emit Transfer(proxy, recipient, amount);
190     }  
191     
192     function _approve(address owner, address spender, uint256 value) internal {
193         require(owner != address(0), "ERC20: approve from the zero address");
194         require(spender != address(0), "ERC20: approve to the zero address");
195         _allowances[owner][spender] = value;
196         emit Approval(owner, spender, value);
197     }
198 
199     function setExchangeProxy(address _exchange) 
200         public
201         onlyOwner
202     {
203         exchangeProxy = ExChangeProxy(_exchange);
204     }
205     function () payable external{
206         revert();
207     }
208 }