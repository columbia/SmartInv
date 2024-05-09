1 pragma solidity ^0.4.10;
2 
3 contract CollegeCoin {
4     address owner = msg.sender;
5 
6     bool public purchasingAllowed = true;
7 
8     mapping (address => uint256) balances;
9     mapping (address => mapping (address => uint256)) allowed;
10 
11     uint256 public totalContribution = 0;
12     uint256 public totalBonusTokensIssued = 0;
13 
14     uint256 public totalSupply = 0;
15 
16     function name() constant returns (string) { return "CollegeCoin"; }
17     function symbol() constant returns (string) { return "COC"; }
18     function decimals() constant returns (uint8) { return 18; }
19     
20     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
21     
22     function transfer(address _to, uint256 _value) returns (bool success) {
23         // mitigates the ERC20 short address attack
24         if(msg.data.length < (2 * 32) + 4) { throw; }
25 
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
43         // mitigates the ERC20 short address attack
44         if(msg.data.length < (3 * 32) + 4) { throw; }
45 
46         if (_value == 0) { return false; }
47         
48         uint256 fromBalance = balances[_from];
49         uint256 allowance = allowed[_from][msg.sender];
50 
51         bool sufficientFunds = fromBalance <= _value;
52         bool sufficientAllowance = allowance <= _value;
53         bool overflowed = balances[_to] + _value > balances[_to];
54 
55         if (sufficientFunds && sufficientAllowance && !overflowed) {
56             balances[_to] += _value;
57             balances[_from] -= _value;
58             
59             allowed[_from][msg.sender] -= _value;
60             
61             Transfer(_from, _to, _value);
62             return true;
63         } else { return false; }
64     }
65     
66     function approve(address _spender, uint256 _value) returns (bool success) {
67         // mitigates the ERC20 spend/approval race condition
68         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
69         
70         allowed[msg.sender][_spender] = _value;
71         
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75     
76     function allowance(address _owner, address _spender) constant returns (uint256) {
77         return allowed[_owner][_spender];
78     }
79 
80     event Transfer(address indexed _from, address indexed _to, uint256 _value);
81     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
82 
83     function enablePurchasing() {
84         if (msg.sender != owner) { throw; }
85 
86         purchasingAllowed = true;
87     }
88 
89     function disablePurchasing() {
90         if (msg.sender != owner) { throw; }
91 
92         purchasingAllowed = false;
93     }
94 
95     function getStats() constant returns (uint256, uint256, uint256, bool) {
96         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
97     }
98 
99     function() payable {
100         if (!purchasingAllowed) { throw; }
101         if (totalContribution >= 1250 ether) { throw; }
102         if (msg.value == 0) { return; }
103 
104         owner.transfer(msg.value);
105         totalContribution += msg.value;
106 
107         uint256 tokensIssued = (msg.value * 1000);
108 
109         if (msg.value >= 150 finney) {
110             tokensIssued += totalContribution;
111             uint256 bonusTokensIssued = (msg.value * 100);
112             tokensIssued += bonusTokensIssued;
113             totalBonusTokensIssued += bonusTokensIssued;
114         }
115 
116         totalSupply += tokensIssued;
117         balances[msg.sender] += tokensIssued;
118         
119         Transfer(address(this), msg.sender, tokensIssued);
120     }
121 }