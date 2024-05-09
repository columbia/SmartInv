1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 
31 contract BasicToken  {
32   using SafeMath for uint256;
33 
34   string public name;
35   string public symbol;
36   uint8 public decimals = 18;
37 
38   uint256 _totalSupply;
39   mapping(address => uint256) _balances;
40   event Transfer(address indexed from, address indexed to, uint256 value);
41 
42   function totalSupply() public view returns (uint256) {
43     return _totalSupply;
44   }
45 
46   function balanceOf(address addr) public view returns (uint256 balance) {
47     return _balances[addr];
48   }
49 
50   function transfer(address to, uint256 value) public returns (bool) {
51     require(to != address(0));
52     require(value <= _balances[msg.sender]);
53 
54     _balances[msg.sender] = _balances[msg.sender].sub(value);
55     _balances[to] = _balances[to].add(value);
56     emit Transfer(msg.sender, to, value);
57     return true;
58   }
59 
60 
61 }
62 
63 contract StandardToken is BasicToken {
64 
65   mapping (address => mapping (address => uint256)) _allowances;
66   event Approval(address indexed owner, address indexed agent, uint256 value);
67 
68   function transferFrom(address from, address to, uint256 value) public returns (bool) {
69     require(to != address(0));
70     require(value <= _balances[from]);
71     require(value <= _allowances[from][msg.sender]);
72 
73     _balances[from] = _balances[from].sub(value);
74     _balances[to] = _balances[to].add(value);
75     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
76     emit Transfer(from, to, value);
77     return true;
78   }
79 
80   function approve(address agent, uint256 value) public returns (bool) {
81     _allowances[msg.sender][agent] = value;
82     emit Approval(msg.sender, agent, value);
83     return true;
84   }
85 
86   function allowance(address owner, address agent) public view returns (uint256) {
87     return _allowances[owner][agent];
88   }
89 
90   function increaseApproval(address agent, uint value) public returns (bool) {
91     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
92     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
93     return true;
94   }
95 
96   function decreaseApproval(address agent, uint value) public returns (bool) {
97     uint allowanceValue = _allowances[msg.sender][agent];
98     if (value > allowanceValue) {
99       _allowances[msg.sender][agent] = 0;
100     } else {
101       _allowances[msg.sender][agent] = allowanceValue.sub(value);
102     }
103     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
104     return true;
105   }
106 }
107 
108 
109 contract DSFToken is StandardToken {
110   string public name = "DSF Token";
111   string public symbol = "DSF";
112   uint8 public decimals = 18;
113 
114   constructor() public {
115     _totalSupply = 1 * (10 ** 10) * (10 ** uint256(decimals));
116 
117     _balances[msg.sender] = _totalSupply;
118     emit Transfer(0x0, msg.sender, _totalSupply);
119   }
120 
121 }