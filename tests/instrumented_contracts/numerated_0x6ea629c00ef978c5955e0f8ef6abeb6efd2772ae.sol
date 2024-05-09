1 pragma solidity ^0.4.23;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     if (a == 0) {
5       return 0;
6     }
7     uint256 c = a * b;
8     assert(c / a == b);
9     return c;
10   }
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 contract ERC20Basic {
28   // events
29   event Transfer(address indexed from, address indexed to, uint256 value);
30   // public functions
31   function totalSupply() public view returns (uint256);
32   function balanceOf(address addr) public view returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34 }
35 contract ERC20 is ERC20Basic {
36   // events
37   event Approval(address indexed owner, address indexed agent, uint256 value);
38   // public functions
39   function allowance(address owner, address agent) public view returns (uint256);
40   function transferFrom(address from, address to, uint256 value) public returns (bool);
41   function approve(address agent, uint256 value) public returns (bool);
42 }
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45   // public variables
46   string public name;
47   string public symbol;
48   uint8 public decimals = 18;
49   // internal variables
50   uint256 _totalSupply;
51   mapping(address => uint256) _balances;
52   // events
53   // public functions
54   function totalSupply() public view returns (uint256) {
55     return _totalSupply;
56   }
57   function balanceOf(address addr) public view returns (uint256 balance) {
58     return _balances[addr];
59   }
60   function transfer(address to, uint256 value) public returns (bool) {
61     require(to != address(0));
62     require(value <= _balances[msg.sender]);
63     _balances[msg.sender] = _balances[msg.sender].sub(value);
64     _balances[to] = _balances[to].add(value);
65     emit Transfer(msg.sender, to, value);
66     return true;
67   }
68   // internal functions
69 }
70 contract StandardToken is ERC20, BasicToken {
71   // public variables
72   // internal variables
73   mapping (address => mapping (address => uint256)) _allowances;
74   // events
75   // public functions
76   function transferFrom(address from, address to, uint256 value) public returns (bool) {
77     require(to != address(0));
78     require(value <= _balances[from]);
79     require(value <= _allowances[from][msg.sender]);
80     _balances[from] = _balances[from].sub(value);
81     _balances[to] = _balances[to].add(value);
82     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
83     emit Transfer(from, to, value);
84     return true;
85   }
86   function approve(address agent, uint256 value) public returns (bool) {
87     _allowances[msg.sender][agent] = value;
88     emit Approval(msg.sender, agent, value);
89     return true;
90   }
91   function allowance(address owner, address agent) public view returns (uint256) {
92     return _allowances[owner][agent];
93   }
94   function increaseApproval(address agent, uint value) public returns (bool) {
95     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
96     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
97     return true;
98   }
99   function decreaseApproval(address agent, uint value) public returns (bool) {
100     uint allowanceValue = _allowances[msg.sender][agent];
101     if (value > allowanceValue) {
102       _allowances[msg.sender][agent] = 0;
103     } else {
104       _allowances[msg.sender][agent] = allowanceValue.sub(value);
105     }
106     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
107     return true;
108   }
109   // internal functions
110 }
111 contract BHTE is StandardToken {
112   // public variables
113   string public name = "BHTE";
114   string public symbol = "BHTE";
115   uint8 public decimals = 18;
116   // internal variables
117   // events
118   // public functions
119   constructor() public {
120     //init _totalSupply
121     _totalSupply = 1900000000 * (10 ** uint256(decimals));
122     _balances[msg.sender] = _totalSupply;
123     emit Transfer(0x0, msg.sender, _totalSupply);
124   }
125   // internal functions
126 }