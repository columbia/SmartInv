1 // "SPDX-License-Identifier: MIT"
2 pragma solidity ^0.7.2;
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
13         require(b <= a, "SafeMath: subtraction overflow");
14         uint256 c = a - b;
15 
16         return c;
17     }
18 
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b, "SafeMath: multiplication overflow");
26 
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0, "SafeMath: division by zero");
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39 }
40 
41 contract Owned {
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed from, address indexed _to);
46 
47     constructor(address _owner) public {
48         owner = _owner;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) external onlyOwner {
57         newOwner = _newOwner;
58     }
59     function acceptOwnership() external {
60         require(msg.sender == newOwner);
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 interface IERC20 {
68     function totalSupply() external view returns (uint256);
69     
70     function balanceOf(address account) external view returns (uint256);
71     
72     function transfer(address recipient, uint256 amount) external returns (bool);
73     
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79 
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 abstract contract ERC20 is IERC20, Owned {
86     using SafeMath for uint256;
87 
88     mapping (address => uint256) internal _balances;
89 
90     mapping (address => mapping (address => uint256)) private _allowances;
91 
92     uint256 internal _totalSupply;
93 
94     function totalSupply() public override view returns (uint256) {
95         return _totalSupply;
96     }
97 
98     function balanceOf(address account) public override view returns (uint256) {
99         return _balances[account];
100     }
101 
102     function allowance(address owner, address spender) public override view returns (uint256) {
103         return _allowances[owner][spender];
104     }
105 
106     function approve(address spender, uint256 value) public override returns (bool) {
107         _approve(msg.sender, spender, value);
108         return true;
109     }
110 
111     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
112         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
113         return true;
114     }
115 
116     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
117         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
118         return true;
119     }
120 
121     function _transfer(address sender, address recipient, uint256 amount) internal {
122         require(sender != address(0), "ERC20: transfer from the zero address");
123         require(recipient != address(0), "ERC20: transfer to the zero address");
124 
125         _balances[sender] = _balances[sender].sub(amount);
126         _balances[recipient] = _balances[recipient].add(amount);
127         emit Transfer(sender, recipient, amount);
128     }
129 
130     function _burn(address account, uint256 value) internal {
131         require(account != address(0), "ERC20: burn from the zero address");
132 
133         _totalSupply = _totalSupply.sub(value);
134         _balances[account] = _balances[account].sub(value);
135         emit Transfer(account, address(0), value);
136     }
137 
138     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
139         _transfer(sender, recipient, amount);
140         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
141         return true;
142     }
143 
144     function _approve(address owner, address spender, uint256 value) internal {
145         require(owner != address(0), "ERC20: approve from the zero address");
146         require(spender != address(0), "ERC20: approve to the zero address");
147 
148         _allowances[owner][spender] = value;
149         emit Approval(owner, spender, value);
150     }
151 
152 }
153 
154 contract Flexi is ERC20 {
155 
156     using SafeMath for uint256;
157     string  public  name;
158     string  public  symbol;
159     uint8   public decimals;
160     uint256 public totalBurnt;
161 
162     constructor(string memory _name, string memory _symbol) public Owned(msg.sender) {
163         name = _name;
164         symbol = _symbol;
165         decimals = 18;
166 
167         _totalSupply = _totalSupply.add(1000 ether);
168         _balances[msg.sender] = _balances[msg.sender].add(1000 ether);
169         totalBurnt = 0;
170         emit Transfer(address(0), msg.sender, 1000 ether);
171     }
172     
173     function burn(uint256 _amount) external returns (bool) {
174       super._burn(msg.sender, _amount);
175       totalBurnt = totalBurnt.add(_amount);
176       return true;
177     }
178 
179     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
180         if(totalSupply() <= 750 ether) {
181             super._transfer(msg.sender, _recipient, _amount);
182             return true;
183         }
184         uint _rand = randNumber();
185         uint _amountToBurn = _amount.mul(_rand).div(100);
186         _burn(msg.sender, _amountToBurn);
187         totalBurnt = totalBurnt.add(_amountToBurn);
188         uint _unBurntToken = _amount.sub(_amountToBurn);
189         super._transfer(msg.sender, _recipient, _unBurntToken);
190         return true;
191     }
192 
193     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
194         super._transferFrom(_sender, _recipient, _amount);
195         return true;
196     }
197     
198     function randNumber() internal view returns(uint _rand) {
199         _rand = uint(keccak256(abi.encode(block.timestamp, block.difficulty, msg.sender))) % 9;
200         return _rand;
201     }
202     
203     receive() external payable {
204         uint _amount = msg.value;
205         msg.sender.transfer(_amount);
206     }
207 }