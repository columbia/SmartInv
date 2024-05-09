1 pragma solidity ^0.4.23;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 
32 contract BasicToken  {
33     using SafeMath for uint256;
34 
35     string public name;
36     string public symbol;
37     uint8 public decimals = 18;
38 
39     uint256 _totalSupply;
40     mapping(address => uint256) _balances;
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     function totalSupply() public view returns (uint256) {
43         return _totalSupply;
44     }
45 
46     function balanceOf(address addr) public view returns (uint256 balance) {
47         return _balances[addr];
48     }
49 
50     function transfer(address to, uint256 value) public returns (bool) {
51         require(to != address(0));
52         require(value <= _balances[msg.sender]);
53 
54         _balances[msg.sender] = _balances[msg.sender].sub(value);
55         _balances[to] = _balances[to].add(value);
56         emit Transfer(msg.sender, to, value);
57         return true;
58     }
59 }
60 
61 
62 contract StandardToken is BasicToken {
63     mapping (address => mapping (address => uint256)) _allowances;
64     event Approval(address indexed owner, address indexed agent, uint256 value);
65 
66     function transferFrom(address from, address to, uint256 value) public returns (bool) {
67         require(to != address(0));
68         require(value <= _balances[from]);
69         require(value <= _allowances[from][msg.sender]);
70 
71         _balances[from] = _balances[from].sub(value);
72         _balances[to] = _balances[to].add(value);
73         _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
74         emit Transfer(from, to, value);
75         return true;
76     }
77 
78     function approve(address agent, uint256 value) public returns (bool) {
79         _allowances[msg.sender][agent] = value;
80         emit Approval(msg.sender, agent, value);
81         return true;
82     }
83 
84     function allowance(address owner, address agent) public view returns (uint256) {
85         return _allowances[owner][agent];
86     }
87 
88     function increaseApproval(address agent, uint value) public returns (bool) {
89         _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
90         emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
91         return true;
92     }
93 
94     function decreaseApproval(address agent, uint value) public returns (bool) {
95         uint allowanceValue = _allowances[msg.sender][agent];
96         if (value > allowanceValue) {
97             _allowances[msg.sender][agent] = 0;
98         } else {
99             _allowances[msg.sender][agent] = allowanceValue.sub(value);
100         }
101         emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
102         return true;
103     }
104 }
105 
106 
107 contract UWTCToken is StandardToken {
108     string public name = "UP WALLET COIN";
109     string public symbol = "UWTC";
110     uint8 public decimals = 6;
111 
112     constructor(
113         address _tokenReceiver
114     )
115     public
116     {
117         // 10 billion
118         _totalSupply = 10 * (10 ** 9) * (10 ** uint256(decimals));
119         _balances[_tokenReceiver] = _totalSupply;
120         emit Transfer(0x0, _tokenReceiver, _totalSupply);
121     }
122 }