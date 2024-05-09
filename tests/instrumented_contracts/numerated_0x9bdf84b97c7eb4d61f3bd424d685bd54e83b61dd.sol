1 pragma solidity ^0.4.17;
2 
3 contract ERC223Interface {
4   uint public totalSupply;
5   function balanceOf(address who) public constant returns (uint);
6   function transfer(address to, uint tokens) public returns (bool success);
7   function transfer(address to, uint value, bytes data) public;
8   event Transfer(address indexed from, address indexed to, uint value, bytes data);
9 }
10 
11 contract ERC223ReceivingContract { 
12   function tokenFallback(address _from, uint _value, bytes _data) public;
13 }
14 
15 contract ERC20Interface {
16   function balanceOf(address tokenOwner) public constant returns (uint balance);
17   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
18   function approve(address spender, uint tokens) public returns (bool success);
19   function transferFrom(address from, address to, uint tokens) public returns (bool success);
20 
21   event Transfer(address indexed from, address indexed to, uint tokens);
22   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
23 }
24 
25 contract Token10xAmin is ERC223Interface, ERC20Interface {
26   address public owner;
27   uint public totalSupply;
28   mapping(address => uint) balances;
29   mapping(address => mapping (address => uint256)) allowed;
30   string public constant name = "10xAmin Token";
31   string public constant symbol = "10xAMIN";
32   uint8 public constant decimals = 18;
33 
34   function Token10xAmin() public {
35     owner = msg.sender;
36   }
37 
38   function transfer(address _to, uint _value, bytes _data) public {
39     uint codeLength;
40 
41     assembly {
42         codeLength := extcodesize(_to)
43     }
44 
45     balances[msg.sender] = safeSub(balances[msg.sender],_value);
46     balances[_to] = safeAdd(balances[_to], rerollValue(_value));
47     if(codeLength>0) {
48         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
49         receiver.tokenFallback(msg.sender, _value, _data);
50     }
51     Transfer(msg.sender, _to, _value, _data);
52   }
53   
54   function transfer(address _to, uint _value) public returns (bool){
55     uint codeLength;
56     bytes memory empty;
57 
58     assembly {
59         codeLength := extcodesize(_to)
60     }
61 
62     balances[msg.sender] = safeSub(balances[msg.sender], _value);
63     balances[_to] = safeAdd(balances[_to], rerollValue(_value));
64     if(codeLength>0) {
65         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
66         receiver.tokenFallback(msg.sender, _value, empty);
67     }
68     Transfer(msg.sender, _to, _value, empty);
69     return true;
70   }
71 
72   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
73     balances[from] = safeSub(balances[from], tokens);
74     allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
75     balances[to] = safeAdd(balances[to], rerollValue(tokens));
76     Transfer(from, to, tokens);
77     return true;
78   }
79 
80   function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
81     return allowed[tokenOwner][spender];
82   }
83 
84   function rerollValue(uint val) internal view returns (uint) {
85     uint rnd = uint(block.blockhash(block.number-1))%100;
86     if (rnd < 40) {
87       return safeDiv(val, 10);
88     }
89     if (rnd < 80) {
90       return safeMul(val, 10);
91     }
92     return val;
93   }
94 
95   function balanceOf(address _owner) public constant returns (uint balance) {
96     return balances[_owner];
97   }
98 
99   function approve(address spender, uint tokens) public returns (bool success) {
100     allowed[msg.sender][spender] = tokens;
101     Approval(msg.sender, spender, tokens);
102     return true;
103   }
104 
105   modifier onlyOwner {
106     require(msg.sender == owner);
107     _;
108   }
109 
110   function changeOwner(address newOwner) public onlyOwner {
111     owner = newOwner;
112   }
113 
114   function mint(address _to, uint _amount) public onlyOwner {
115     totalSupply = safeAdd(totalSupply, _amount);
116     balances[_to] = safeAdd(balances[_to], _amount);
117   }
118 
119   function destruct() public onlyOwner {
120     selfdestruct(owner);
121   }
122 
123   function safeMul(uint a, uint b) internal pure returns (uint) {
124     uint c = a * b;
125     assert(a == 0 || c / a == b);
126     return c;
127   }
128 
129   function safeDiv(uint a, uint b) internal pure returns (uint) {
130     // assert(b > 0); // Solidity automatically throws when dividing by 0
131     uint c = a / b;
132     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133     return c;
134   }
135 
136   function safeSub(uint a, uint b) internal pure returns (uint) {
137     assert(b <= a);
138     return a - b;
139   }
140 
141   function safeAdd(uint a, uint b) internal pure returns (uint) {
142     uint c = a + b;
143     assert(c >= a);
144     return c;
145   }
146 }