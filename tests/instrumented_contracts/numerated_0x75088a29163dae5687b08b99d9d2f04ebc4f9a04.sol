1 pragma solidity ^0.4.10;
2 
3 contract SafeMath {
4 
5     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
6       uint256 z = x + y;
7       assert((z >= x) && (z >= y));
8       return z;
9     }
10 
11     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
12       assert(x >= y);
13       uint256 z = x - y;
14       return z;
15     }
16 
17     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
18       uint256 z = x * y;
19       assert((x == 0)||(z/x == y));
20       return z;
21     }
22 
23     function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
24       assert(b > 0);
25       uint c = a / b;
26       assert(a == b * c + a % b);
27       return c;
28     }
29 
30 }
31 
32 contract Token {
33     uint256 public totalSupply;
34     function balanceOf(address _owner) constant returns (uint256 balance);
35     function transfer(address _to, uint256 _value) returns (bool success);
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
37     function approve(address _spender, uint256 _value) returns (bool success);
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 contract StandardToken is Token {
44 
45     function transfer(address _to, uint256 _value) returns (bool success) {
46       if (balances[msg.sender] >= _value && _value > 0) {
47         balances[msg.sender] -= _value;
48         balances[_to] += _value;
49         Transfer(msg.sender, _to, _value);
50         return true;
51       } else {
52         return false;
53       }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
58         balances[_to] += _value;
59         balances[_from] -= _value;
60         allowed[_from][msg.sender] -= _value;
61         Transfer(_from, _to, _value);
62         return true;
63       } else {
64         return false;
65       }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 }
85 
86 contract TUBE is SafeMath, StandardToken {
87 
88     string public constant name = "MaxiTube preICO Token";
89     string public constant symbol = "TUBE";
90     uint256 public constant decimals = 18;
91     uint256 public constant tokenCreationCap =  40000*10**decimals;
92 
93     address public owner;
94 
95     //~10usd
96     uint public oneTokenInWei = 32786885245901600;
97     
98 
99     modifier onlyOwner {
100         if(owner!=msg.sender) revert();
101         _;
102     }
103 
104     event CreateTUBE(address indexed _to, uint256 _value);
105 
106     function TUBE() {
107         owner = msg.sender;
108 
109     }
110 
111     function () payable {
112         createTokens();
113     }
114 
115     function createTokens() internal {
116         if (msg.value <= 0) revert();
117 
118         uint multiplier = 10 ** decimals;
119         uint256 tokens = safeMult(msg.value, multiplier) / oneTokenInWei;
120 
121         uint256 checkedSupply = safeAdd(totalSupply, tokens);
122         if (tokenCreationCap < checkedSupply) revert();
123 
124         balances[msg.sender] += tokens;
125         totalSupply = safeAdd(totalSupply, tokens);
126     }
127 
128     function finalize() external onlyOwner {
129         owner.transfer(this.balance);
130     }
131 
132     function setEthPrice(uint _etherPrice) onlyOwner {
133         oneTokenInWei = _etherPrice;
134     }
135 
136     function transferRoot(address _newOwner) onlyOwner {
137         owner = _newOwner;
138     }
139 
140     function mint(address _to, uint256 _tokens) onlyOwner {
141         uint256 checkedSupply = safeAdd(totalSupply, _tokens);
142         if (tokenCreationCap < checkedSupply) revert();
143         balances[_to] += _tokens;
144         totalSupply = safeAdd(totalSupply, _tokens);
145     }
146 
147 }