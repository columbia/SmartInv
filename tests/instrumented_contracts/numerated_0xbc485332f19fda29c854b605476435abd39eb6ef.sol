1 pragma solidity ^0.4.11;
2 
3 contract NGToken {
4 
5     function NGToken() {}
6     
7     address public niceguy1 = 0x589A1E14208433647863c63fE2C736Ce930B956b;
8     address public niceguy2 = 0x583f354B6Fff4b11b399Fad8b3C2a73C16dF02e2;
9     address public niceguy3 = 0x6609867F516A15273678d268460B864D882156b6;
10     address public niceguy4 = 0xA4CA81EcE0d3230c6f8CCD0ad94f5a5393f76Af8;
11     address public owner = msg.sender;
12     mapping (address => uint256) balances;
13     mapping (address => mapping (address => uint256)) allowed;
14     uint256 public totalContribution = 0;
15     uint256 public totalBonusTokensIssued = 0;
16     uint256 public totalSupply = 0;
17     bool public purchasingAllowed = true;
18 
19     function name() constant returns (string) { return "Nice Guy Token"; }
20     function symbol() constant returns (string) { return "NGT"; }
21     function decimals() constant returns (uint256) { return 18; }
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
46         if (_value == 0) { return false; }
47 
48         uint256 fromBalance = balances[_from];
49         uint256 allowance = allowed[_from][msg.sender];
50 
51         bool sufficientFunds = fromBalance >= _value;
52         bool sufficientAllowance = allowance >= _value;
53         bool overflowed = balances[_to] + _value < balances[_to];
54 
55         if (sufficientFunds && sufficientAllowance && !overflowed) {
56             balances[_to] += _value;
57             balances[_from] -= _value;
58             
59             allowed[_from][msg.sender] -= _value;
60             
61             Transfer(_from, _to, _value);
62             return true;
63         } else { 
64             return false; 
65         }
66     }
67     
68     function approve(address _spender, uint256 _value) returns (bool success) {
69         allowed[msg.sender][_spender] = _value;        
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73     
74     function allowance(address _owner, address _spender) constant returns (uint256) {
75         return allowed[_owner][_spender];
76     }
77 
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80 
81     function enablePurchasing() {
82         if (msg.sender != owner) { throw; }
83 
84         purchasingAllowed = true;
85     }
86 
87     function disablePurchasing() {
88         if (msg.sender != owner) { throw; }
89 
90         purchasingAllowed = false;
91     }
92 
93     function() payable {
94         if (!purchasingAllowed) { throw; }
95         
96         if (msg.value == 0) { return; }
97 
98         niceguy4.transfer(msg.value/4.0);
99         niceguy3.transfer(msg.value/4.0);
100         niceguy2.transfer(msg.value/4.0);
101         niceguy1.transfer(msg.value/4.0);
102 
103         totalContribution += msg.value;
104         uint256 precision = 10 ** decimals();
105         uint256 tokenConversionRate = 10**24 * precision / (totalSupply + 10**22); 
106         uint256 tokensIssued = tokenConversionRate * msg.value / precision;
107         totalSupply += tokensIssued;
108         balances[msg.sender] += tokensIssued;
109         Transfer(address(this), msg.sender, tokensIssued);
110     }
111 }