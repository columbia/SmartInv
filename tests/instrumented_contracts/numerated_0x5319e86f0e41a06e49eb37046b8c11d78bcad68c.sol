1 pragma solidity ^0.5.11;
2 
3 // ----------------------------------------------------------------------------
4 // Standard    : ERC-20
5 // Symbol      : ZLW
6 // Name        : ZELWIN
7 // Total supply: 300 000 000
8 // Decimals    : 18
9 // (c) by Team @ ZELWIN 2019
10 // ----------------------------------------------------------------------------
11 
12 
13 library SafeMath {
14     
15     function add(uint256 a, uint256 b) internal pure returns(uint c) {
16         c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18     }
19     function sub(uint256 a, uint256 b) internal pure returns(uint c) {
20         require(b <= a, "SafeMath: subtraction overflow");
21         c = a - b;
22     }
23     function mul(uint256 a, uint256 b) internal pure returns(uint c) {
24         if (a == 0) {
25             return 0;
26         }
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29     }
30     function div(uint256 a, uint256 b) internal pure returns(uint c) {
31         require(b > 0, "SafeMath: division by zero");
32         c = a / b;
33     }
34 }
35 
36 
37 contract IERC20 {
38     
39     function totalSupply() external view returns(uint256);
40     function balanceOf(address account) external view returns(uint256);
41     function transfer(address to, uint256 amount) external returns(bool);
42     function allowance(address owner, address spender) external view returns(uint256);
43     function approve(address spender, uint256 amount) external returns(bool);
44     function transferFrom(address from, address to, uint256 amount) external returns(bool);
45     event Transfer(address indexed from, address indexed to, uint256 amount);
46     event Approval(address indexed owner, address indexed spender, uint256 amount);
47 }
48 
49 
50 contract Ownable {
51     
52     address private _owner;
53     
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     constructor() public {
57         _owner = msg.sender;
58         emit OwnershipTransferred(address(0), _owner);
59     }
60     
61     function owner() public view returns(address) {
62         return _owner;
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == _owner);
67         _;
68     }
69 
70     function transferOwnership(address newOwner) public onlyOwner {
71         require(newOwner != address(0), "New owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 
78 contract Details {
79     
80     string private _name;
81     string private _symbol;
82     uint8 private _decimals;
83     
84     constructor() public {
85         _name = "ZELWIN";
86         _symbol = "ZLW";
87         _decimals = 18;
88     }
89     
90     function name() public view returns(string memory) {
91         return _name;
92     }
93     
94     function symbol() public view returns(string memory) {
95         return _symbol;
96     }
97     
98     function decimals() public view returns(uint8) {
99         return _decimals;
100     }
101 }
102 
103 
104 contract ZELWIN is IERC20, Ownable, Details {
105     using SafeMath for uint256;
106     
107     uint256 private _totalSupply;
108     mapping(address => uint256) private _balances;
109     mapping(address => mapping(address => uint256)) private _allowances;
110     
111     constructor() public {
112         _totalSupply = 300000000 * 10 ** uint256(decimals());
113         _balances[owner()] = _totalSupply;
114         
115         emit Transfer(address(0), owner(), _totalSupply);
116     }
117     
118     modifier isNotZeroAddress (address _address) {
119         require(_address != address(0), "ERC20: Zero address");
120         _;
121     }
122     
123     modifier isNotZELWIN (address _address) {
124         require(_address != address(this), "ERC20: ZELWIN Token address");
125         _;
126     }
127     
128     
129     function totalSupply() public view returns(uint256) {
130         return _totalSupply;
131     }
132     
133     function balanceOf(address account) public view returns(uint256) {
134         return _balances[account];
135     }
136     
137     function allowance(address owner, address spender) public view returns(uint256) {
138         return _allowances[owner][spender];
139     }
140     
141     
142     function transfer(address to, uint256 amount)
143         public
144         isNotZeroAddress(to)
145         isNotZELWIN(to)
146         returns(bool)
147     {
148         _balances[msg.sender] = _balances[msg.sender].sub(amount);
149         _balances[to] = _balances[to].add(amount);
150         emit Transfer(msg.sender, to, amount);
151         return true;
152     }
153     
154     function approve(address spender, uint256 amount)
155         public
156         isNotZeroAddress(spender)
157         returns(bool)
158     {
159         _allowances[msg.sender][spender] = amount;
160         emit Approval(msg.sender, spender, amount);
161         return true;
162     }
163     
164     function increaseAllowance(address spender, uint256 addedValue)
165         public
166         isNotZeroAddress(spender)
167         returns (bool)
168     {
169         uint256 __newValue = _allowances[msg.sender][spender].add(addedValue);
170         _allowances[msg.sender][spender] = __newValue;
171         emit Approval(msg.sender, spender, __newValue);
172         return true;
173     }
174     
175     function decreaseAllowance(address spender, uint256 subtractedValue) 
176         public
177         isNotZeroAddress(spender)
178         returns (bool)
179     {   
180         uint256 __newValue = _allowances[msg.sender][spender].sub(subtractedValue);
181         _allowances[msg.sender][spender] = __newValue;
182         emit Approval(msg.sender, spender, __newValue);
183         return true;
184     }
185 
186     function transferFrom(address from, address to, uint256 amount)
187         public
188         isNotZeroAddress(to)
189         isNotZELWIN(to)
190         returns(bool)
191     {
192         _balances[from] = _balances[from].sub(amount);
193         _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(amount);
194         _balances[to] = _balances[to].add(amount);
195         emit Transfer(from, to, amount);
196         return true;
197     }
198 }