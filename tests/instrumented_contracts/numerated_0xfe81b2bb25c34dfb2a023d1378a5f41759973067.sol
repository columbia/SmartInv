1 pragma solidity ^0.4.14;
2 
3 contract ValueToken {
4     string public symbol;
5     string public name;
6     uint8 public decimals;
7     uint256 _totalSupply;
8     uint256 _value;
9 
10     // Owner of this contract
11     address public owner;
12     address public centralBank;
13 
14     // Balances for each account
15     mapping(address => uint256) balances;
16 
17     // Owner of account approves the transfer of an amount to another account
18     mapping(address => mapping (address => uint256)) allowed;
19 
20     // Constructor
21     function ValueToken() {
22         name = "Cyber Turtle Token";
23         symbol = "CTT";
24         decimals = 2;
25         _totalSupply = 164500;
26         _value = 1118;
27         centralBank = 0x77E370640B43a8A8Bf68C21fD068E312c89321eE;
28         owner = msg.sender;
29         balances[owner] = _totalSupply;
30     }
31 
32     function totalSupply() constant returns (uint256 supply) {
33         return _totalSupply;
34     }
35 
36     function value() constant returns (uint256 returnValue) {
37         return _value;
38     }
39 
40     // What is the balance of a particular account?
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     // Transfer the balance from owner's account to another account
46     function transfer(address _to, uint256 _amount) returns (bool success) {
47         if (balances[msg.sender] >= _amount
48             && _amount > 0
49             && balances[_to] + _amount > balances[_to]) {
50             balances[msg.sender] -= _amount;
51             balances[_to] += _amount;
52             Transfer(msg.sender, _to, _amount);
53             return true;
54         } else {
55             return false;
56         }
57     }
58 
59     // Send _value amount of tokens from address _from to address _to
60     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
61     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
62     // fees in sub-currencies; the command should fail unless the _from account has
63     // deliberately authorized the sender of the message via some mechanism; we propose
64     // these standardized APIs for approval:
65     function transferFrom(
66         address _from,
67         address _to,
68         uint256 _amount
69     ) returns (bool success) {
70         if (balances[_from] >= _amount
71             && allowed[_from][msg.sender] >= _amount
72             && _amount > 0
73             && balances[_to] + _amount > balances[_to]) {
74             balances[_from] -= _amount;
75             allowed[_from][msg.sender] -= _amount;
76             balances[_to] += _amount;
77             Transfer(_from, _to, _amount);
78             return true;
79         } else {
80             return false;
81         }
82     }
83 
84     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
85     // If this function is called again it overwrites the current allowance with _value.
86     function approve(address _spender, uint256 _amount) returns (bool success) {
87         allowed[msg.sender][_spender] = _amount;
88         Approval(msg.sender, _spender, _amount);
89         return true;
90     }
91 
92     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
93         return allowed[_owner][_spender];
94     }
95 
96     // Ownership
97     modifier onlyOwner {
98         require(msg.sender == owner);
99         _;
100     }
101 
102     function transferOwnership(address _newOwner) onlyOwner {
103         owner = _newOwner;
104     }
105 
106     function transferCentralBanking(address _newCentralBank) onlyOwner {
107         centralBank = _newCentralBank;
108     }
109 
110     // Central bank functions
111     modifier onlyCentralBank {
112         require(msg.sender == centralBank);
113         _;
114     }
115 
116     function mint(uint256 _amount) onlyCentralBank {
117         balances[owner] += _amount;
118         _totalSupply += _amount;
119         Transfer(0, this, _amount);
120         Transfer(this, owner, _amount);
121     }
122 
123     function burn(uint256 _amount) onlyCentralBank {
124         require (balances[owner] >= _amount);
125         balances[owner] -= _amount;
126         _totalSupply -= _amount;
127         Transfer(owner, this, _amount);
128         Transfer(this, 0, _amount);
129     }
130 
131     function updateValue(uint256 _newValue) onlyCentralBank {
132         require(_newValue >= 0);
133         _value = _newValue;
134     }
135 
136     function updateValueAndMint(uint256 _newValue, uint256 _toMint) onlyCentralBank {
137         require(_newValue >= 0);
138         _value = _newValue;
139         mint(_toMint);
140     }
141 
142     function updateValueAndBurn(uint256 _newValue, uint256 _toBurn) onlyCentralBank {
143         require(_newValue >= 0);
144         _value = _newValue;
145         burn(_toBurn);
146     }
147 
148     // Events
149     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
150     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
151 }