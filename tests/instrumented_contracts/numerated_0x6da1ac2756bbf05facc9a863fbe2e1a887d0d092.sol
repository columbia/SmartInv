1 pragma solidity ^0.4.10;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract CosmosToken {
9     address owner = msg.sender;
10     bool public purchasingAllowed = false;
11 
12     mapping (address => uint256) balances;
13     mapping (address => mapping (address => uint256)) allowed;
14 
15     uint256 public totalContribution = 0;
16     uint256 public totalSupply = 0;
17 
18     function name() constant returns (string) { return "CosmosToken"; }
19     function symbol() constant returns (string) { return "CST"; }
20     function decimals() constant returns (uint8) { return 18; }
21 
22     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {
25         if(msg.data.length < (2 * 32) + 4) { throw; }
26         if (_value == 0) { return false; }
27 
28         uint256 fromBalance = balances[msg.sender];
29 
30         bool sufficientFunds = fromBalance >= _value;
31         bool overflowed = balances[_to] + _value < balances[_to];
32 
33         if (sufficientFunds && !overflowed) {
34             balances[msg.sender] -= _value;
35             balances[_to] += _value;
36 
37             Transfer(msg.sender, _to, _value);
38             return true;
39         } else { return false; }
40     }
41 
42     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
43         if(msg.data.length < (3 * 32) + 4) { throw; }
44         if (_value == 0) { return false; }
45 
46         uint256 fromBalance = balances[_from];
47         uint256 allowance = allowed[_from][msg.sender];
48 
49         bool sufficientFunds = fromBalance <= _value;
50         bool sufficientAllowance = allowance <= _value;
51         bool overflowed = balances[_to] + _value > balances[_to];
52 
53         if (sufficientFunds && sufficientAllowance && !overflowed) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56 
57             allowed[_from][msg.sender] -= _value;
58 
59             Transfer(_from, _to, _value);
60             return true;
61         } else { return false; }
62     }
63 
64     function approve(address _spender, uint256 _value) returns (bool success) {
65         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
66 
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69 
70         return true;
71     }
72 
73     function allowance(address _owner, address _spender) constant returns (uint256) {
74         return allowed[_owner][_spender];
75     }
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 
80     function enablePurchasing() {
81         if (msg.sender != owner) { throw; }
82         purchasingAllowed = true;
83     }
84 
85     function disablePurchasing() {
86         if (msg.sender != owner) { throw; }
87         purchasingAllowed = false;
88     }
89 
90     function withdrawForeignTokens(address _tokenContract) returns (bool) {
91         if (msg.sender != owner) { throw; }
92 
93         ForeignToken token = ForeignToken(_tokenContract);
94 
95         uint256 amount = token.balanceOf(address(this));
96         return token.transfer(owner, amount);
97     }
98 
99     function getStats() constant returns (uint256, uint256, bool) {
100         return (totalContribution, totalSupply, purchasingAllowed);
101     }
102 
103     function() payable {
104         if (!purchasingAllowed) { throw; }
105 
106         if (msg.value == 0) { return; }
107 
108         owner.transfer(msg.value);
109         totalContribution += msg.value;
110 
111         uint256 tokensIssued = (msg.value * 1000);
112 
113         if (msg.value >= 10 finney) { tokensIssued += totalContribution; }
114 
115         totalSupply += tokensIssued;
116         balances[msg.sender] += tokensIssued;
117 
118         Transfer(address(this), msg.sender, tokensIssued);
119     }
120 }