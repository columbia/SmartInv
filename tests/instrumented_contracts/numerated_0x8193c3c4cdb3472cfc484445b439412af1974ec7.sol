1 //sol Cryptopus
2 // @authors:
3 // Alexandr Romanov <rmnff.dev@yandex.ru>
4 // usage:
5 // use modifiers isOwner (just own owned).
6 pragma solidity ^0.4.10;
7 
8 contract checkedMathematics {
9     function checkedAddition(uint256 x, uint256 y) pure internal returns(uint256) {
10       uint256 z = x + y;
11       assert((z >= x) && (z >= y));
12       return z;
13     }
14     function checkedSubtract(uint256 x, uint256 y) pure internal returns(uint256) {
15       assert(x >= y);
16       uint256 z = x - y;
17       return z;
18     }
19     function checkedMultiplication(uint256 x, uint256 y) pure internal returns(uint256) {
20       uint256 z = x * y;
21       assert((x == 0)||(z/x == y));
22       return z;
23     }
24     function checkedDivision(uint256 a, uint256 b) pure internal returns (uint256) {
25       assert(b > 0);
26       uint c = a / b;
27       assert(a == b * c + a % b);
28       return c;
29     }
30 }
31 
32 contract ERC20Token {
33     uint256 public totalSupply;
34     function balanceOf(address _owner) public constant returns (uint256 balance);
35     function transfer(address _to, uint256 _value) public returns (bool success);
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37     function approve(address _spender, uint256 _value) public returns (bool success);
38     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 contract StandardToken is ERC20Token {
44 
45     function transfer(address _to, uint256 _value) public returns (bool success) {
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
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
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
68     function balanceOf(address _owner) public constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) public returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 }
85 
86 contract Cryptopus is checkedMathematics, StandardToken {
87 
88     string public constant name                      = "Cryptopus Token";
89     string public constant symbol                    = "CPP"; // Still unused symbol we are using now
90     uint256 public constant decimals                 = 18;
91     uint256 private constant tokenCreationCapICO025  = 10000000**decimals;
92     uint256 private constant tokenCreationCapICO030  = 10000000**decimals;
93     uint256 public  constant tokenCreationCapOverall = 20000000**decimals;
94 
95     address public owner;
96 
97     // 1 ETH = $470 USD Date: December 1st, 2017
98     uint private oneTokenInWeiSale1  = 530000000000000; // $0.25 USD
99     uint private oneTokenInWeiSale2  = 590000000000000; // $0.28 USD
100     uint private oneTokenInWeiSale3  = 640000000000000; // $0.30 USD
101     uint private oneTokenInWeiNormal = 680000000000000; // $0.32 USD
102 
103     Phase public currentPhase = Phase.ICOweek1;
104 
105     enum Phase {
106         ICOweek1,
107         ICOweek2,
108         ICOweek3,
109         NormalLife
110     }
111 
112     modifier isOwner {
113         if(owner != msg.sender) revert();
114         _;
115     }
116 
117     event CreateCPP(address indexed _to, uint256 _value);
118 
119     function Cryptopus() public {
120       owner = msg.sender;
121     }
122 
123     function () public payable {
124         createTokens();
125     }
126 
127     function createTokens() internal {
128         if (msg.value <= 0) revert();
129 
130         if (currentPhase == Phase.ICOweek1) {
131             if (totalSupply <= tokenCreationCapICO025) {
132                 generateTokens(oneTokenInWeiSale1);
133             }
134         }
135         else if (currentPhase == Phase.ICOweek2) {
136             if (totalSupply > tokenCreationCapICO025 && totalSupply <= tokenCreationCapICO030) {
137                 generateTokens(oneTokenInWeiSale2);
138             }
139         }
140         else if (currentPhase == Phase.ICOweek3) {
141             if (totalSupply > tokenCreationCapICO030 && totalSupply <= tokenCreationCapOverall) {
142                 generateTokens(oneTokenInWeiSale3);
143             }
144         } else {
145             revert();
146         }
147     }
148 
149     function generateTokens(uint _oneTokenInWei) internal {
150         uint multiplier = 10**decimals;
151         uint256 tokens = checkedDivision(msg.value, _oneTokenInWei)*multiplier;
152         uint256 checkedSupply = checkedAddition(totalSupply, tokens);
153         if (tokenCreationCapOverall <= checkedSupply) revert();
154         balances[msg.sender] += tokens;
155         totalSupply = checkedAddition(totalSupply, tokens);
156         CreateCPP(msg.sender,tokens);
157     }
158 
159     function changePhaseToICOweek2() external isOwner returns (bool){
160         currentPhase = Phase.ICOweek2;
161         return true;
162     }
163 
164     function changePhaseToICOweek3() external isOwner returns (bool){
165         currentPhase = Phase.ICOweek3;
166         return true;
167     }
168 
169     function changePhaseToNormalLife() external isOwner returns (bool){
170         currentPhase = Phase.NormalLife;
171         return true;
172     }
173 
174     function changeTokenPrice(uint tpico1, uint tpico2, uint tpico3) external isOwner returns (bool){
175         oneTokenInWeiSale1 = tpico1;
176         oneTokenInWeiSale2 = tpico2;
177         oneTokenInWeiSale3 = tpico3;
178         return true;
179     }
180 
181     function finalize() external isOwner returns (bool){
182       owner.transfer(this.balance);
183       return true;
184     }
185 }