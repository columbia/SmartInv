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
16 contract HuoNiu is ERC20Interface {
17     string public constant symbol = "HUN";
18     string public constant name = "HuoNiu";
19     uint8 public constant decimals = 4;
20 
21     uint256 _totalSupply = 0;
22     uint256 _airdropAmount = 69998989;
23     uint256 _cutoff = _airdropAmount * 142700;
24 
25     mapping(address => uint256) balances;
26     mapping(address => bool) initialized;
27 
28     // Owner of account approves the transfer of an amount to another account
29     mapping(address => mapping (address => uint256)) allowed;
30 
31     function HuoNiu() {
32         initialized[msg.sender] = true;
33         balances[msg.sender] = _airdropAmount * 128557;
34         _totalSupply = balances[msg.sender];
35     }
36 
37     function totalSupply() constant returns (uint256 supply) {
38         return _totalSupply;
39     }
40 
41     // What's my balance?
42     function balance() constant returns (uint256) {
43         return getBalance(msg.sender);
44     }
45 
46     // What is the balance of a particular account?
47     function balanceOf(address _address) constant returns (uint256) {
48         return getBalance(_address);
49     }
50 
51     // Transfer the balance from owner's account to another account
52     function transfer(address _to, uint256 _amount) returns (bool success) {
53         initialize(msg.sender);
54 
55         if (balances[msg.sender] >= _amount
56             && _amount > 0) {
57             initialize(_to);
58             if (balances[_to] + _amount > balances[_to]) {
59 
60                 balances[msg.sender] -= _amount;
61                 balances[_to] += _amount;
62 
63                 Transfer(msg.sender, _to, _amount);
64 
65                 return true;
66             } else {
67                 return false;
68             }
69         } else {
70             return false;
71         }
72     }
73 
74     // Send _value amount of tokens from address _from to address _to
75     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
76     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
77     // fees in sub-currencies; the command should fail unless the _from account has
78     // deliberately authorized the sender of the message via some mechanism; we propose
79     // these standardized APIs for approval:
80     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
81         initialize(_from);
82 
83         if (balances[_from] >= _amount
84             && allowed[_from][msg.sender] >= _amount
85             && _amount > 0) {
86             initialize(_to);
87             if (balances[_to] + _amount > balances[_to]) {
88 
89                 balances[_from] -= _amount;
90                 allowed[_from][msg.sender] -= _amount;
91                 balances[_to] += _amount;
92 
93                 Transfer(_from, _to, _amount);
94 
95                 return true;
96             } else {
97                 return false;
98             }
99         } else {
100             return false;
101         }
102     }
103 
104     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
105     // If this function is called again it overwrites the current allowance with _value.
106     function approve(address _spender, uint256 _amount) returns (bool success) {
107         allowed[msg.sender][_spender] = _amount;
108         Approval(msg.sender, _spender, _amount);
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
113         return allowed[_owner][_spender];
114     }
115 
116     // internal private functions
117     function initialize(address _address) internal returns (bool success) {
118         if (_totalSupply < _cutoff && !initialized[_address]) {
119             initialized[_address] = true;
120             balances[_address] = _airdropAmount;
121             _totalSupply += _airdropAmount;
122         }
123         return true;
124     }
125 
126     function getBalance(address _address) internal returns (uint256) {
127         if (_totalSupply < _cutoff && !initialized[_address]) {
128             return balances[_address] + _airdropAmount;
129         }
130         else {
131             return balances[_address];
132         }
133     }
134 }