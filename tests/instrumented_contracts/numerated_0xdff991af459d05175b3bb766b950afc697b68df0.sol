1 pragma solidity ^0.4.8;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256 supply);
5     function balance() public constant returns (uint256);
6     function balanceOf(address _owner) public constant returns (uint256);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 // HotLoveHotLoveHotLoveHotLove
17 // YOU get a HotLove, and YOU get a HotLove, and YOU get a HotLove!
18 contract HotLove is ERC20Interface {
19     string public constant symbol = "HL";
20     string public constant name = "HotLove";
21     uint8 public constant decimals = 18;
22 
23     uint256 _totalSupply = 0;
24     uint256 _airdropAmount = 99999880000000000000000;
25     uint256 _cutoff = _airdropAmount * 199988;
26 
27     mapping(address => uint256) balances;
28     mapping(address => bool) initialized;
29 
30     // Owner of account approves the transfer of an amount to another account
31     mapping(address => mapping (address => uint256)) allowed;
32 
33     function HotLove() {
34         initialized[msg.sender] = true;
35         balances[msg.sender] = _airdropAmount * 99988;
36         _totalSupply = balances[msg.sender];
37     }
38 
39     function totalSupply() constant returns (uint256 supply) {
40         return _totalSupply;
41     }
42 
43     // What's my balance?
44     function balance() constant returns (uint256) {
45         return getBalance(msg.sender);
46     }
47 
48     // What is the balance of a particular account?
49     function balanceOf(address _address) constant returns (uint256) {
50         return getBalance(_address);
51     }
52 
53     // Transfer the balance from owner's account to another account
54     function transfer(address _to, uint256 _amount) returns (bool success) {
55         initialize(msg.sender);
56 
57         if (balances[msg.sender] >= _amount
58             && _amount > 0) {
59             initialize(_to);
60             if (balances[_to] + _amount > balances[_to]) {
61 
62                 balances[msg.sender] -= _amount;
63                 balances[_to] += _amount;
64 
65                 Transfer(msg.sender, _to, _amount);
66 
67                 return true;
68             } else {
69                 return false;
70             }
71         } else {
72             return false;
73         }
74     }
75 
76     // Send _value amount of tokens from address _from to address _to
77     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
78     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
79     // fees in sub-currencies; the command should fail unless the _from account has
80     // deliberately authorized the sender of the message via some mechanism; we propose
81     // these standardized APIs for approval:
82     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
83         initialize(_from);
84 
85         if (balances[_from] >= _amount
86             && allowed[_from][msg.sender] >= _amount
87             && _amount > 0) {
88             initialize(_to);
89             if (balances[_to] + _amount > balances[_to]) {
90 
91                 balances[_from] -= _amount;
92                 allowed[_from][msg.sender] -= _amount;
93                 balances[_to] += _amount;
94 
95                 Transfer(_from, _to, _amount);
96 
97                 return true;
98             } else {
99                 return false;
100             }
101         } else {
102             return false;
103         }
104     }
105 
106     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
107     // If this function is called again it overwrites the current allowance with _value.
108     function approve(address _spender, uint256 _amount) returns (bool success) {
109         allowed[msg.sender][_spender] = _amount;
110         Approval(msg.sender, _spender, _amount);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
115         return allowed[_owner][_spender];
116     }
117 
118     // internal private functions
119     function initialize(address _address) internal returns (bool success) {
120         if (_totalSupply < _cutoff && !initialized[_address]) {
121             initialized[_address] = true;
122             balances[_address] = _airdropAmount;
123             _totalSupply += _airdropAmount;
124         }
125         return true;
126     }
127 
128     function getBalance(address _address) internal returns (uint256) {
129         if (_totalSupply < _cutoff && !initialized[_address]) {
130             return balances[_address] + _airdropAmount;
131         }
132         else {
133             return balances[_address];
134         }
135     }
136 }