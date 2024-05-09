1 pragma solidity ^0.4.10;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract SMContract {
9     address owner = msg.sender;
10 
11     mapping (address => uint256) balances;
12     mapping (address => mapping (address => uint256)) allowed;
13 
14     uint256 public totalSupply = 0;
15 
16     uint256 constant public price = 100;
17     uint256 constant public maxAmount = 1000000000000000000000;
18 
19     function name() constant returns (string) { return "Surprise Motherfucker"; }
20     function symbol() constant returns (string) { return "SM"; }
21     function decimals() constant returns (uint8) { return 18; }
22     
23     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
24     
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         // mitigates the ERC20 short address attack
27         if(msg.data.length < (2 * 32) + 4) { throw; }
28 
29         if (_value == 0) { return false; }
30 
31         uint256 fromBalance = balances[msg.sender];
32 
33         bool sufficientFunds = fromBalance >= _value;
34         bool overflowed = balances[_to] + _value < balances[_to];
35         
36         if (sufficientFunds && !overflowed) {
37             balances[msg.sender] -= _value;
38             balances[_to] += _value;
39             
40             Transfer(msg.sender, _to, _value);
41             return true;
42         } else { return false; }
43     }
44     
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
46         // mitigates the ERC20 short address attack
47         if(msg.data.length < (3 * 32) + 4) { throw; }
48 
49         if (_value == 0) { return false; }
50         
51         uint256 fromBalance = balances[_from];
52         uint256 allowance = allowed[_from][msg.sender];
53 
54         bool sufficientFunds = fromBalance <= _value;
55         bool sufficientAllowance = allowance <= _value;
56         bool overflowed = balances[_to] + _value > balances[_to];
57 
58         if (sufficientFunds && sufficientAllowance && !overflowed) {
59             balances[_to] += _value;
60             balances[_from] -= _value;
61             
62             allowed[_from][msg.sender] -= _value;
63             
64             Transfer(_from, _to, _value);
65             return true;
66         } else { return false; }
67     }
68     
69     function approve(address _spender, uint256 _value) returns (bool success) {
70         // mitigates the ERC20 spend/approval race condition
71         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
72         
73         allowed[msg.sender][_spender] = _value;
74         
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78     
79     function allowance(address _owner, address _spender) constant returns (uint256) {
80         return allowed[_owner][_spender];
81     }
82 
83     event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
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
95     function getStats() constant returns (uint256) {
96         return (totalSupply);
97     }
98 
99     function() payable {
100         if (msg.value == 0) { throw; }
101         if (totalSupply >= maxAmount) { throw; }
102 
103         uint256 tokensIssued = (msg.value * price);
104         if (totalSupply + tokensIssued >= maxAmount) {
105             tokensIssued = maxAmount - totalSupply;
106             uint256 cost = tokensIssued / price;
107             msg.sender.transfer(msg.value - cost);
108             owner.transfer(cost);
109         } else {
110 	    owner.transfer(msg.value);
111         }
112 
113 	
114         
115 	totalSupply += tokensIssued;
116         balances[msg.sender] += tokensIssued;
117         
118         Transfer(address(this), msg.sender, tokensIssued);
119     }
120 }