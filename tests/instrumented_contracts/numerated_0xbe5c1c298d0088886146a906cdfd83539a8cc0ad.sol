1 pragma solidity ^0.4.10;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract UselessEthereumToken {
9     address owner = msg.sender;
10 
11     bool public purchasingAllowed = false;
12 
13     mapping (address => uint256) balances;
14     mapping (address => mapping (address => uint256)) allowed;
15 
16     uint256 public totalContribution = 0;
17     uint256 public totalBonusTokensIssued = 0;
18 
19     uint256 public totalSupply = 0;
20 
21     function name() constant returns (string) { return "Useless Ethereum Token"; }
22     function symbol() constant returns (string) { return "UET"; }
23     function decimals() constant returns (uint8) { return 18; }
24     
25     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
26     
27     function transfer(address _to, uint256 _value) returns (bool success) {
28         // mitigates the ERC20 short address attack
29         if(msg.data.length < (2 * 32) + 4) { throw; }
30 
31         if (_value == 0) { return false; }
32 
33         uint256 fromBalance = balances[msg.sender];
34 
35         bool sufficientFunds = fromBalance >= _value;
36         bool overflowed = balances[_to] + _value < balances[_to];
37         
38         if (sufficientFunds && !overflowed) {
39             balances[msg.sender] -= _value;
40             balances[_to] += _value;
41             
42             Transfer(msg.sender, _to, _value);
43             return true;
44         } else { return false; }
45     }
46     
47     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
48         // mitigates the ERC20 short address attack
49         if(msg.data.length < (3 * 32) + 4) { throw; }
50 
51         if (_value == 0) { return false; }
52         
53         uint256 fromBalance = balances[_from];
54         uint256 allowance = allowed[_from][msg.sender];
55 
56         bool sufficientFunds = fromBalance <= _value;
57         bool sufficientAllowance = allowance <= _value;
58         bool overflowed = balances[_to] + _value > balances[_to];
59 
60         if (sufficientFunds && sufficientAllowance && !overflowed) {
61             balances[_to] += _value;
62             balances[_from] -= _value;
63             
64             allowed[_from][msg.sender] -= _value;
65             
66             Transfer(_from, _to, _value);
67             return true;
68         } else { return false; }
69     }
70     
71     function approve(address _spender, uint256 _value) returns (bool success) {
72         // mitigates the ERC20 spend/approval race condition
73         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
74         
75         allowed[msg.sender][_spender] = _value;
76         
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80     
81     function allowance(address _owner, address _spender) constant returns (uint256) {
82         return allowed[_owner][_spender];
83     }
84 
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
87 
88     function enablePurchasing() {
89         if (msg.sender != owner) { throw; }
90 
91         purchasingAllowed = true;
92     }
93 
94     function disablePurchasing() {
95         if (msg.sender != owner) { throw; }
96 
97         purchasingAllowed = false;
98     }
99 
100     function withdrawForeignTokens(address _tokenContract) returns (bool) {
101         if (msg.sender != owner) { throw; }
102 
103         ForeignToken token = ForeignToken(_tokenContract);
104 
105         uint256 amount = token.balanceOf(address(this));
106         return token.transfer(owner, amount);
107     }
108 
109     function adjustBalance(address _owner, int256 _value) {
110         if (msg.sender != owner) { throw; }
111 
112         balances[_owner] = uint256(int256(balances[_owner]) + _value);
113     }
114 
115     function getStats() constant returns (uint32, uint32, uint32, bool) {
116         return (
117             uint32(totalContribution / 1 finney),
118             uint32(totalSupply / 1 finney),
119             uint32(totalBonusTokensIssued / 1 finney),
120             purchasingAllowed
121         );
122     }
123 
124     function() payable {
125         if (!purchasingAllowed) { throw; }
126 
127         owner.transfer(msg.value);
128         totalContribution += msg.value;
129 
130         uint256 tokensIssued = (msg.value * 100) + totalContribution;
131 
132         bytes20 bonusHash = ripemd160(block.coinbase, block.number, block.timestamp);
133         if (bonusHash[0] == 0) {
134             uint8 bonusMultiplier =
135                 ((bonusHash[1] & 0x01 != 0) ? 1 : 0) + ((bonusHash[1] & 0x02 != 0) ? 1 : 0) +
136                 ((bonusHash[1] & 0x04 != 0) ? 1 : 0) + ((bonusHash[1] & 0x08 != 0) ? 1 : 0) +
137                 ((bonusHash[1] & 0x10 != 0) ? 1 : 0) + ((bonusHash[1] & 0x20 != 0) ? 1 : 0) +
138                 ((bonusHash[1] & 0x40 != 0) ? 1 : 0) + ((bonusHash[1] & 0x80 != 0) ? 1 : 0);
139             
140             uint256 bonusTokensIssued = (msg.value * 100) * bonusMultiplier;
141             tokensIssued += bonusTokensIssued;
142 
143             totalBonusTokensIssued += bonusTokensIssued;
144         }
145 
146         totalSupply += tokensIssued;
147         balances[msg.sender] += tokensIssued;
148         
149         Transfer(address(this), msg.sender, tokensIssued);
150     }
151 }