1 pragma solidity ^0.4.10;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract ScatCoin {
9     address owner = msg.sender;
10 
11     bool public purchasingAllowed = false;
12 
13     mapping (address => uint256) balances;
14     mapping (address => mapping (address => uint256)) allowed;
15 
16     uint256 public totalSupply = 0;
17 
18     function name() constant returns (string) { return "ScatCoin"; }
19     function symbol() constant returns (string) { return "SCAT"; }
20     function decimals() constant returns (uint8) { return 18; }
21     
22     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
23     
24     function transfer(address _to, uint256 _value) returns (bool success) {
25         // mitigates the ERC20 short address attack
26         if(msg.data.length < (2 * 32) + 4) { throw; }
27 
28         if (_value == 0) { return false; }
29 
30         uint256 fromBalance = balances[msg.sender];
31 
32         bool sufficientFunds = fromBalance >= _value;
33         bool overflowed = balances[_to] + _value < balances[_to];
34         
35         if (sufficientFunds && !overflowed) {
36             balances[msg.sender] -= _value;
37             balances[_to] += _value;
38             
39             Transfer(msg.sender, _to, _value);
40             return true;
41         } else { return false; }
42     }
43     
44     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
45         // mitigates the ERC20 short address attack
46         if(msg.data.length < (3 * 32) + 4) { throw; }
47 
48         if (_value == 0) { return false; }
49         
50         uint256 fromBalance = balances[_from];
51         uint256 allowance = allowed[_from][msg.sender];
52 
53         bool sufficientFunds = fromBalance <= _value;
54         bool sufficientAllowance = allowance <= _value;
55         bool overflowed = balances[_to] + _value > balances[_to];
56 
57         if (sufficientFunds && sufficientAllowance && !overflowed) {
58             balances[_to] += _value;
59             balances[_from] -= _value;
60             
61             allowed[_from][msg.sender] -= _value;
62             
63             Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67     
68     function approve(address _spender, uint256 _value) returns (bool success) {
69         // mitigates the ERC20 spend/approval race condition
70         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
71         
72         allowed[msg.sender][_spender] = _value;
73         
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77     
78     function allowance(address _owner, address _spender) constant returns (uint256) {
79         return allowed[_owner][_spender];
80     }
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84 
85     function enablePurchasing() {
86         if (msg.sender != owner) { throw; }
87 
88         purchasingAllowed = true;
89     }
90 
91     function disablePurchasing() {
92         if (msg.sender != owner) { throw; }
93 
94         purchasingAllowed = false;
95     }
96 
97     function withdrawForeignTokens(address _tokenContract) returns (bool) {
98         if (msg.sender != owner) { throw; }
99 
100         ForeignToken token = ForeignToken(_tokenContract);
101 
102         uint256 amount = token.balanceOf(address(this));
103         return token.transfer(owner, amount);
104     }
105 
106     function getStats() constant returns (uint256, bool) {
107         return (totalSupply, purchasingAllowed);
108     }
109 
110     function() payable {
111         if (!purchasingAllowed) { throw; }
112         
113         if (msg.value == 0) { return; }
114 
115         owner.transfer(msg.value);
116 
117         uint256 tokensIssued = ((msg.value * 696969)/10);
118 
119         totalSupply += tokensIssued;
120         balances[msg.sender] += tokensIssued;
121         
122         Transfer(address(this), msg.sender, tokensIssued);
123     }
124 }