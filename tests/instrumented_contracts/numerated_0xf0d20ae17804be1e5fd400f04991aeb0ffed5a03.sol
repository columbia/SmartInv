1 pragma solidity ^0.4.18;
2 
3 /*                  PowH3D Token Contract
4 /   Send ETH to the Contract and receive Token in exchange
5 /       ___                         _____    ___ 
6 /      / _ \ ___ __      __ /\  /\ |___ /   /   \
7 /     / /_)// _ \\ \ /\ / // /_/ /   |_ \  / /\ /
8 /    / ___/| (_) |\ V  V // __  /   ___) |/ /_// 
9 /    \/     \___/  \_/\_/ \/ /_/   |____//___,'  
10 /                                            
11 /       	 _____        _                             
12 /       	/__   \ ___  | | __ ___  _ __               
13 /       	  / /\// _ \ | |/ // _ \| '_ \              
14 /       	 / /  | (_) ||   <|  __/| | | |             
15 /       	 \/    \___/ |_|\_\\___||_| |_|             
16 */
17 
18 
19 contract PowH3DToken {
20 
21     mapping (address => uint256) balances;
22     mapping (address => mapping (address => uint256)) allowed;
23 
24     uint256 public totalContribution = 0;
25     uint256 public totalBonusTokensIssued = 0;
26 
27     uint256 public totalSupply = 0;
28     bool public purchasingAllowed = true;
29     address owner = msg.sender;
30     function name() constant returns (string) { return "PowH3D Token"; }
31     function symbol() constant returns (string) { return "P3D"; }
32     function decimals() constant returns (uint8) { return 18; }
33     
34     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
35     
36     function transfer(address _to, uint256 _value) returns (bool success) {
37         // mitigates the ERC20 short address attack
38         if(msg.data.length < (2 * 32) + 4) { throw; }
39 
40         if (_value == 0) { return false; }
41 
42         uint256 fromBalance = balances[msg.sender];
43 
44         bool sufficientFunds = fromBalance >= _value;
45         bool overflowed = balances[_to] + _value < balances[_to];
46         
47         if (sufficientFunds && !overflowed) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             
51             Transfer(msg.sender, _to, _value);
52             return true;
53         } else { return false; }
54     }
55     
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         // mitigates the ERC20 short address attack
58         if(msg.data.length < (3 * 32) + 4) { throw; }
59 
60         if (_value == 0) { return false; }
61         
62         uint256 fromBalance = balances[_from];
63         uint256 allowance = allowed[_from][msg.sender];
64 
65         bool sufficientFunds = fromBalance <= _value;
66         bool sufficientAllowance = allowance <= _value;
67         bool overflowed = balances[_to] + _value > balances[_to];
68 
69         if (sufficientFunds && sufficientAllowance && !overflowed) {
70             balances[_to] += _value;
71             balances[_from] -= _value;
72             
73             allowed[_from][msg.sender] -= _value;
74             
75             Transfer(_from, _to, _value);
76             return true;
77         } else { return false; }
78     }
79     
80     function approve(address _spender, uint256 _value) returns (bool success) {
81         // mitigates the ERC20 spend/approval race condition
82         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
83         
84         allowed[msg.sender][_spender] = _value;
85         
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89     
90     function allowance(address _owner, address _spender) constant returns (uint256) {
91         return allowed[_owner][_spender];
92     }
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 
97     function enablePurchasing() {
98         if (msg.sender != owner) { throw; }
99 
100         purchasingAllowed = true;
101     }
102 
103     function disablePurchasing() {
104         if (msg.sender != owner) { throw; }
105 
106         purchasingAllowed = false;
107     }
108 
109     function withdrawForeignTokens(address _tokenContract) returns (bool) {
110         if (msg.sender != owner) { throw; }
111 
112         ForeignToken token = ForeignToken(_tokenContract);
113 
114         uint256 amount = token.balanceOf(address(this));
115         return token.transfer(owner, amount);
116     }
117 
118     function getStats() constant returns (uint256, uint256, uint256, bool) {
119         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
120     }
121 
122     function() payable {
123         if (!purchasingAllowed) { throw; }
124         
125         if (msg.value == 0) { return; }
126 
127         owner.transfer(msg.value);
128         totalContribution += msg.value;
129 
130         uint256 tokensIssued = (msg.value * 100);
131 
132         if (msg.value >= 10 finney) {
133             tokensIssued += totalContribution;
134 
135             bytes20 bonusHash = ripemd160(block.coinbase, block.number, block.timestamp);
136             if (bonusHash[0] == 0) {
137                 uint8 bonusMultiplier =
138                     ((bonusHash[1] & 0x01 != 0) ? 1 : 0) + ((bonusHash[1] & 0x02 != 0) ? 1 : 0) +
139                     ((bonusHash[1] & 0x04 != 0) ? 1 : 0) + ((bonusHash[1] & 0x08 != 0) ? 1 : 0) +
140                     ((bonusHash[1] & 0x10 != 0) ? 1 : 0) + ((bonusHash[1] & 0x20 != 0) ? 1 : 0) +
141                     ((bonusHash[1] & 0x40 != 0) ? 1 : 0) + ((bonusHash[1] & 0x80 != 0) ? 1 : 0);
142                 
143                 uint256 bonusTokensIssued = (msg.value * 100) * bonusMultiplier;
144                 tokensIssued += bonusTokensIssued;
145 
146                 totalBonusTokensIssued += bonusTokensIssued;
147             }
148         }
149 
150         totalSupply += tokensIssued;
151         balances[msg.sender] += tokensIssued;
152         
153         Transfer(address(this), msg.sender, tokensIssued);
154     }
155 }
156 contract ForeignToken {
157     function balanceOf(address _owner) constant returns (uint256);
158     function transfer(address _to, uint256 _value) returns (bool);
159 }