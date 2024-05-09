1 pragma solidity ^0.4.10;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract LamboCoin {
9     address owner = msg.sender;
10 
11     mapping (address => uint256) balances;
12     mapping (address => mapping (address => uint256)) allowed;
13 
14 	bool public purchasingAllowed = false;
15     uint256 public totalContribution = 0;
16     uint256 public totalSupply = 0;
17 	uint256 public maxSupply = 0;
18 
19     function name() constant returns (string) { return "LamboCoin"; }
20     function symbol() constant returns (string) { return "LBC"; }
21     function decimals() constant returns (uint8) { return 18; }
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
41         } else {
42 			return false;
43 		}
44     }
45 
46     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
47         // mitigates the ERC20 short address attack
48         if(msg.data.length < (3 * 32) + 4) { throw; }
49 
50         if (_value == 0) { return false; }
51 
52         uint256 fromBalance = balances[_from];
53         uint256 allowance = allowed[_from][msg.sender];
54 
55         bool sufficientFunds = fromBalance <= _value;
56         bool sufficientAllowance = allowance <= _value;
57         bool overflowed = balances[_to] + _value > balances[_to];
58 
59         if (sufficientFunds && sufficientAllowance && !overflowed) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62 
63             allowed[_from][msg.sender] -= _value;
64 
65             Transfer(_from, _to, _value);
66             return true;
67         } else {
68 			return false;
69 		}
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         // mitigates the ERC20 spend/approval race condition
74         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
75 
76         allowed[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function allowance(address _owner, address _spender) constant returns (uint256) {
82         return allowed[_owner][_spender];
83     }
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
106     function getStats() constant returns (uint256, uint256, uint256, bool) {
107         return (totalContribution, totalSupply, maxSupply, purchasingAllowed);
108     }
109 
110     function() payable {
111         if (!purchasingAllowed) { throw; }
112         if (msg.value == 0) { return; }
113 
114 		//prevent tokens issued going over current max supply unless its the owner
115 		if (totalSupply > maxSupply && msg.sender != owner) { throw; }
116 
117         owner.transfer(msg.value);
118 
119         totalContribution += msg.value;
120         uint256 tokensIssued = (msg.value * 100);
121 		totalSupply += tokensIssued;
122 
123 		//Allow owner to increase max supply as desired
124 		if( msg.sender == owner ) {
125 			maxSupply += (msg.value * 1000000000000000000); //max supply will be value of owner sender amount x Wei
126 		}
127 
128 		balances[msg.sender] += tokensIssued;
129         Transfer(address(this), msg.sender, tokensIssued);
130     }
131 
132 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
133     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
134 }