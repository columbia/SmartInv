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
86 contract Gmt is SafeMath, StandardToken {
87 
88     string public constant name = "Gold Mine Token";
89     string public constant symbol = "GMT";
90     uint256 public constant decimals = 18;
91 
92     uint256 private constant tokenBountyCap = 60000*10**decimals;
93     uint256 private constant tokenCreationCapPreICO =  460000*10**decimals;
94     uint256 public constant tokenCreationCap = 1200000*10**decimals;
95 
96     address public constant owner = 0x02baFcF3e3C183103Aa94A248CC512d4DCf10cfa;
97 
98     // 1 ETH = 250 USD
99     uint private oneTokenInWeiSale = 5000000000000000; // 0,005 ETH
100     uint private oneTokenInWei = 10000000000000000; // 0,01 ETH
101 
102     Phase public currentPhase = Phase.PreICO;
103 
104     enum Phase {
105         PreICO,
106         ICO
107     }
108 
109     modifier onlyOwner {
110         if(owner != msg.sender) revert();
111         _;
112     }
113 
114     event CreateGMT(address indexed _to, uint256 _value);
115     event Mint(address indexed to, uint256 amount);
116 
117     function Gmt() {}
118 
119     function () payable {
120         createTokens();
121     }
122 
123     function createTokens() internal {
124         if (msg.value <= 0) revert();
125 
126         if (currentPhase == Phase.PreICO) {
127             if (totalSupply <= tokenCreationCapPreICO) {
128                 generateTokens(oneTokenInWeiSale);
129             }
130         }
131         else if (currentPhase == Phase.PreICO) {
132             if (totalSupply > tokenCreationCapPreICO && totalSupply <= tokenCreationCap) {
133                 generateTokens(oneTokenInWei);
134             }
135         }
136         else if (currentPhase == Phase.ICO) {
137             if (totalSupply > tokenCreationCapPreICO && totalSupply <= tokenCreationCap) {
138                 generateTokens(oneTokenInWei);
139             }
140         } else {
141             revert();
142         }
143     }
144 
145     function generateTokens(uint _oneTokenInWei) internal {
146         uint multiplier = 10 ** decimals;
147         uint256 tokens = safeDiv(msg.value, _oneTokenInWei)*multiplier;
148         uint256 checkedSupply = safeAdd(totalSupply, tokens);
149         if (tokenCreationCap <= checkedSupply) revert();
150         balances[msg.sender] += tokens;
151         totalSupply = safeAdd(totalSupply, tokens);
152         CreateGMT(msg.sender,tokens);
153         owner.transfer(msg.value);
154     }
155 
156 
157     function changePhaseToICO() external onlyOwner returns (bool){
158         currentPhase = Phase.ICO;
159         return true;
160     }
161 
162     function createBountyTokens() external onlyOwner returns (bool){
163         uint256 tokens = tokenBountyCap;
164         balances[owner] += tokens;
165         totalSupply = safeAdd(totalSupply, tokens);
166         CreateGMT(owner, tokens);
167     }
168 
169 
170     function changeTokenPrice(uint tpico1, uint tpico) external onlyOwner returns (bool){
171         oneTokenInWeiSale = tpico1;
172         oneTokenInWei = tpico;
173         return true;
174     }
175 
176 
177 }