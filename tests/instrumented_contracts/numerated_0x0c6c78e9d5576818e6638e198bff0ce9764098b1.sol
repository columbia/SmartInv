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
86 contract Mondo is SafeMath, StandardToken {
87 
88     string public constant name = "Mondo Token";
89     string public constant symbol = "MND";
90     uint256 public constant decimals = 18;
91 
92     uint256 private constant tokenCreationCapPreICO02 =  5000000*10**decimals;
93     uint256 private constant tokenCreationCapPreICO15 =  11000000*10**decimals;
94     uint256 public constant tokenCreationCap = 23500000*10**decimals;
95 
96     address public constant owner = 0x0077DA9DF6507655CDb3aB9277A347EDe759F93F;
97 
98     // 1 ETH = 280 USD Date: 11.08.2017
99     uint private oneTokenInWeiSale1 = 70175438596491; // 0,02 $
100     uint private oneTokenInWei1Sale2 = 526315789473684; // 0,15 $
101     uint private oneTokenInWei = 5473684210526320; // 1,56 $
102 
103     Phase public currentPhase = Phase.PreICO1;
104 
105     enum Phase {
106         PreICO1,
107         PreICO2,
108         ICO
109     }
110 
111     modifier onlyOwner {
112         if(owner != msg.sender) revert();
113         _;
114     }
115 
116     event CreateMND(address indexed _to, uint256 _value);
117 
118     function Mondo() {}
119 
120     function () payable {
121         createTokens();
122     }
123 
124     function createTokens() internal {
125         if (msg.value <= 0) revert();
126 
127         if (currentPhase == Phase.PreICO1) {
128             if (totalSupply <= tokenCreationCapPreICO02) {
129                 generateTokens(oneTokenInWeiSale1);
130             }
131         }
132         else if (currentPhase == Phase.PreICO2) {
133             if (totalSupply > tokenCreationCapPreICO02 && totalSupply <= tokenCreationCapPreICO15) {
134                 generateTokens(oneTokenInWei1Sale2);
135             }
136         }
137         else if (currentPhase == Phase.ICO) {
138             if (totalSupply > tokenCreationCapPreICO15 && totalSupply <= tokenCreationCap) {
139                 generateTokens(oneTokenInWei);
140             }
141         } else {
142             revert();
143         }
144     }
145 
146     function generateTokens(uint _oneTokenInWei) internal {
147         uint multiplier = 10 ** decimals;
148         uint256 tokens = safeDiv(msg.value, _oneTokenInWei)*multiplier;
149         uint256 checkedSupply = safeAdd(totalSupply, tokens);
150         if (tokenCreationCap <= checkedSupply) revert();
151         balances[msg.sender] += tokens;
152         totalSupply = safeAdd(totalSupply, tokens);
153         CreateMND(msg.sender,tokens);
154     }
155 
156     function changePhaseToPreICO2() external onlyOwner returns (bool){
157         currentPhase = Phase.PreICO2;
158         return true;
159     }
160 
161     function changePhaseToICO() external onlyOwner returns (bool){
162         currentPhase = Phase.ICO;
163         return true;
164     }
165 
166     function changeTokenPrice(uint tpico1, uint tpico2, uint tpico) external onlyOwner returns (bool){
167         oneTokenInWeiSale1 = tpico1;
168         oneTokenInWei1Sale2 = tpico2;
169         oneTokenInWei = tpico;
170         return true;
171     }
172 
173     function finalize() external onlyOwner returns (bool){
174       owner.transfer(this.balance);
175       return true;
176     }
177 }