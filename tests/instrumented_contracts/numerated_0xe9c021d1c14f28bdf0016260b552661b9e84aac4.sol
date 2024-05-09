1 pragma solidity ^0.4.10;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract XmanToken {
9     address owner = msg.sender;
10      
11     mapping (address => uint256) balances;
12     mapping (address => mapping (address => uint256)) allowed;
13 
14     uint256 public totalContribution = 0;
15     uint256 public totalSupply = 0;
16 
17     function name() constant returns (string) { return "XmanToken"; }
18     function symbol() constant returns (string) { return "XMAN"; }
19     function decimals() constant returns (uint8) { return 18; }
20     
21     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
22     
23     function transfer(address _to, uint256 _value) returns (bool success) {
24         // mitigates the ERC20 short address attack
25         if(msg.data.length < (2 * 32) + 4) { throw; }
26 
27         if (_value == 0) { return false; }
28 
29         uint256 fromBalance = balances[msg.sender];
30 
31         bool sufficientFunds = fromBalance >= _value;
32         bool overflowed = balances[_to] + _value < balances[_to];
33         
34         if (sufficientFunds && !overflowed) {
35             balances[msg.sender] -= _value;
36             balances[_to] += _value;
37             
38             Transfer(msg.sender, _to, _value);
39             return true;
40         } else { return false; }
41     }
42     
43     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
44         // mitigates the ERC20 short address attack
45         if(msg.data.length < (3 * 32) + 4) { throw; }
46 
47         if (_value == 0) { return false; }
48         
49         uint256 fromBalance = balances[_from];
50         uint256 allowance = allowed[_from][msg.sender];
51 
52         bool sufficientFunds = fromBalance <= _value;
53         bool sufficientAllowance = allowance <= _value;
54         bool overflowed = balances[_to] + _value > balances[_to];
55 
56         if (sufficientFunds && sufficientAllowance && !overflowed) {
57             balances[_to] += _value;
58             balances[_from] -= _value;
59             
60             allowed[_from][msg.sender] -= _value;
61             
62             Transfer(_from, _to, _value);
63             return true;
64         } else { return false; }
65     }
66     
67     function approve(address _spender, uint256 _value) returns (bool success) {
68         // mitigates the ERC20 spend/approval race condition
69         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
70         
71         allowed[msg.sender][_spender] = _value;
72         
73         Approval(msg.sender, _spender, _value);
74         return true;
75     }
76     
77     function allowance(address _owner, address _spender) constant returns (uint256) {
78         return allowed[_owner][_spender];
79     }
80 
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83 
84     
85 
86     function withdrawForeignTokens(address _tokenContract) returns (bool) {
87         if (msg.sender != owner) { throw; }
88 
89         ForeignToken token = ForeignToken(_tokenContract);
90 
91         uint256 amount = token.balanceOf(address(this));
92         return token.transfer(owner, amount);
93     }
94 
95     function getStats() constant returns (uint256, uint256) {
96         return (totalContribution, totalSupply);
97     }
98 
99     function() payable {
100        
101         if (msg.value == 0) { return; }
102 
103         owner.transfer(msg.value);
104         totalContribution += msg.value;
105 
106         uint256 tokensIssued = (msg.value * 100000);
107 
108         totalSupply += tokensIssued;
109         balances[msg.sender] += tokensIssued;
110         
111         Transfer(address(this), msg.sender, tokensIssued);
112     }
113 }