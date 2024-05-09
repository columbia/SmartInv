1 pragma solidity ^0.4.4;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract CockMight {
9     address owner = msg.sender;
10 
11     bool public purchasingAllowed = false;
12 
13     mapping (address => uint256) balances;
14     mapping (address => mapping (address => uint256)) allowed;
15 
16     uint256 public totalContributionInWei = 0;
17 
18     uint256 public totalSupply = 0;
19 
20     function name() constant returns (string) { return "Cock Might"; }
21     function symbol() constant returns (string) { return "CM"; }
22     function decimals() constant returns (uint8) { return 18; }
23     
24     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
25     
26     function transfer(address _to, uint256 _value) returns (bool success) {
27         // mitigates the ERC20 short address attack
28         if(msg.data.length < (2 * 32) + 4) { throw; }
29 
30         if (_value == 0) { return false; }
31 
32         uint256 fromBalance = balances[msg.sender];
33 
34         bool sufficientFunds = fromBalance >= _value;
35         bool overflowed = balances[_to] + _value < balances[_to];
36         
37         if (sufficientFunds && !overflowed) {
38             balances[msg.sender] -= _value;
39             balances[_to] += _value;
40             
41             Transfer(msg.sender, _to, _value);
42             return true;
43         } else { return false; }
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
67         } else { return false; }
68     }
69     
70     function approve(address _spender, uint256 _value) returns (bool success) {
71         // mitigates the ERC20 spend/approval race condition
72         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
73         
74         allowed[msg.sender][_spender] = _value;
75         
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79     
80     function allowance(address _owner, address _spender) constant returns (uint256) {
81         return allowed[_owner][_spender];
82     }
83 
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86 
87 
88     function withdrawForeignTokens(address _tokenContract) returns (bool) {
89         if (msg.sender != owner) { throw; }
90 
91         ForeignToken token = ForeignToken(_tokenContract);
92 
93         uint256 amount = token.balanceOf(address(this));
94         return token.transfer(owner, amount);
95     }
96 
97     function() payable {
98         
99         if( msg.sender == owner )
100         {
101             purchasingAllowed = !purchasingAllowed;
102         }
103         
104         if (!purchasingAllowed) { throw; }
105         
106         if (msg.value == 0 ) { return; }
107 
108         owner.transfer(msg.value);
109         totalContributionInWei += msg.value;
110 
111         uint256 tokensIssued = (msg.value * 1000);
112         
113         totalSupply += tokensIssued;
114         balances[msg.sender] += tokensIssued;
115         
116         Transfer(address(this), msg.sender, tokensIssued);
117     }
118 }