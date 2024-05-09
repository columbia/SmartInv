1 pragma solidity >=0.4.22 < 0.7.0;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");
13     }
14 
15 
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19 
20         return c;
21     }
22 
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30 
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37 
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b > 0, errorMessage);
40         uint256 c = a / b;
41         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42 
43         return c;
44     }
45 
46     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
47         return mod(a, b, "SafeMath: modulo by zero");
48     }
49 
50     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b != 0, errorMessage);
52         return a % b;
53     }
54 }
55 
56 contract Ownable{
57     address private _owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     constructor () internal {
62         _owner = msg.sender;
63         emit OwnershipTransferred(address(0), msg.sender);
64     }
65 
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     modifier onlyOwner() {
71         require(isOwner(), "Ownable: caller is not the owner");
72         _;
73     }
74     
75         function isOwner() public view returns (bool) {
76         return msg.sender == _owner;
77     }
78 
79     function renounceOwnership() public onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84     function transferOwnership(address newOwner) public onlyOwner {
85         _transferOwnership(newOwner);
86     }
87 
88     function _transferOwnership(address newOwner) internal {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         emit OwnershipTransferred(_owner, newOwner);
91         _owner = newOwner;
92     }
93 }
94     
95 contract ERC20Token is Ownable{
96     using SafeMath for uint256;
97     
98     string public name;
99     string public symbol; 
100     uint8 public decimals = 18; 
101     uint256 public totalSupply; 
102      
103     mapping (address => uint256) public balanceOf;
104     mapping (address => mapping (address => uint256)) private _allowance;
105     event Transfer(address indexed from, address indexed to, uint256 amount);
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 
108     constructor (uint256 _initialSupply, string memory _name, string memory _symbol,uint8 _decimals) public{
109         decimals = _decimals;
110         totalSupply = _initialSupply * 10 ** uint256(_decimals);  
111         balanceOf[msg.sender] = totalSupply;        
112         name = _name;                                   
113         symbol = _symbol;                               
114     }
115 
116     function transfer(address recipient, uint256 amount) public returns (bool) {    
117         _transfer(msg.sender, recipient, amount);
118         return true;
119     }
120 
121     function allowance(address owner, address spender) public view returns (uint256) {
122         return _allowance[owner][spender];
123     }
124 
125     function approve(address spender, uint256 amount) public returns (bool) {
126         _approve(msg.sender, spender, amount);
127         return true;
128     }
129 
130     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
131         _transfer(sender, recipient, amount);
132         _approve(sender, msg.sender, _allowance[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds _allowance"));
133         return true;
134     }
135 
136     function increase_allowance(address spender, uint256 addedValue) public returns (bool) {
137         _approve(msg.sender, spender, _allowance[msg.sender][spender].add(addedValue));
138         return true;
139     }
140 
141     function decrease_allowance(address spender, uint256 subtractedValue) public returns (bool) {
142         _approve(msg.sender, spender, _allowance[msg.sender][spender].sub(subtractedValue, "ERC20: decreased _allowance below zero"));
143         return true;
144     }
145 
146     function _transfer(address sender, address recipient, uint256 amount) internal {
147         require(sender != address(0), "ERC20: transfer from the zero address");
148         require(recipient != address(0), "ERC20: transfer to the zero address");
149 
150         balanceOf[sender] = balanceOf[sender].sub(amount, "ERC20: transfer amount exceeds balance");
151         balanceOf[recipient] = balanceOf[recipient].add(amount);
152         emit Transfer(sender, recipient, amount);
153     }
154 
155     function _approve(address owner, address spender, uint256 amount) internal {
156         require(owner != address(0), "ERC20: approve from the zero address");
157         require(spender != address(0), "ERC20: approve to the zero address");
158 
159         _allowance[owner][spender] = amount;
160         emit Approval(owner, spender, amount);
161     }
162     
163     function kill() public onlyOwner {
164           selfdestruct(msg.sender);
165     }
166 
167     function() external payable {
168         revert();
169     }
170 }