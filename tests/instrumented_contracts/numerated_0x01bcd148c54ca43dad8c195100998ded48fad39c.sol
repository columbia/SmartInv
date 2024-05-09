1 pragma solidity 0.4.25;
2 
3 contract IERC20 {
4     function transfer(address to, uint256 value) public returns (bool);
5 
6     function approve(address spender, uint256 value) public returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) public returns (bool);
9 
10     function balanceOf(address who) public view returns (uint256);
11 
12     function allowance(address owner, address spender) public view returns (uint256);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 
20 library SafeMath {
21   
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
24     // benefit is lost if 'b' is also tested.
25     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
26     if (a == 0) {
27       return 0;
28     }
29 
30     uint256 c = a * b;
31     require(c / a == b);
32 
33     return c;
34   }
35 
36  
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // Solidity only automatically asserts when dividing by 0
39     require(b > 0);
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42 
43     return c;
44   }
45 
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     require(b <= a);
49     uint256 c = a - b;
50 
51     return c;
52   }
53 
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     require(c >= a);
57 
58     return c;
59   }
60 
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 contract ERC20 is IERC20 {
69     using SafeMath for uint256;
70 
71     mapping (address => uint256) internal _balances;
72 
73     mapping (address => mapping (address => uint256)) private _allowed;
74 
75 
76     function balanceOf(address owner) public view returns (uint256) {
77         return _balances[owner];
78     }
79 
80 
81     function allowance(address owner, address spender) public view returns (uint256) {
82         return _allowed[owner][spender];
83     }
84 
85 
86     function transfer(address to, uint256 value) public returns (bool) {
87         _transfer(msg.sender, to, value);
88         return true;
89     }
90 
91 
92     function approve(address spender, uint256 value) public returns (bool) {
93         _approve(msg.sender, spender, value);
94         return true;
95     }
96 
97 
98     function transferFrom(address from, address to, uint256 value) public returns (bool) {
99         _transfer(from, to, value);
100         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
101         return true;
102     }
103 
104 
105     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
106         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
107         return true;
108     }
109 
110 
111     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
112         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
113         return true;
114     }
115 
116     function _transfer(address from, address to, uint256 value) internal {
117         require(to != address(0));
118 
119         _balances[from] = _balances[from].sub(value);
120         _balances[to] = _balances[to].add(value);
121         emit Transfer(from, to, value);
122     }
123 
124     function _approve(address owner, address spender, uint256 value) internal {
125         require(spender != address(0));
126         require(owner != address(0));
127 
128         _allowed[owner][spender] = value;
129         emit Approval(owner, spender, value);
130     }
131 
132 }
133 
134 contract RAN is ERC20 {
135   string public constant name = 'RACECOIN';
136   string public constant symbol = 'RAN';
137   uint8 public constant decimals = 18;
138   uint256 public constant totalSupply = (90 * 1e6) * (10 ** uint256(decimals));
139 
140   constructor(address _RAN) public {
141     _balances[_RAN] = totalSupply;
142     emit Transfer(address(0x0), _RAN, totalSupply);
143   }
144 }