1 pragma solidity ^0.4.8;
2 // ----------------------------------------------------------------------------------------------
3 //
4 // ----------------------------------------------------------------------------------------------
5 contract ERC23Interface {
6     // Get the total token supply
7     function totalSupply() constant returns (uint256 totalSupply);
8  
9     // Get the account balance of another account with address _owner
10     function balanceOf(address _owner) constant returns (uint256 balance);
11  
12     // Send _value amount of tokens to address _to
13     function transfer(address _to, uint256 _value) returns (bool success);
14  
15     // Send value amount to address, with data
16     function transfer(address to, uint256 _value, bytes data) returns (bool success);
17  
18     // Send _value amount of tokens from address _from to address _to
19     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
20  
21     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
22     // If this function is called again it overwrites the current allowance with _value.
23     // this function is required for some DEX functionality
24     function approve(address _spender, uint256 _value) returns (bool success);
25  
26     // Returns the amount which _spender is still allowed to withdraw from _owner
27     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
28  
29     // Triggered when tokens are transferred.
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31     
32     // Triggered when tokens are transferred with data
33     event Transfer(address indexed _from, address indexed _to, uint _value, bytes data); 
34     
35     // Triggered whenever approve(address _spender, uint256 _value) is called.
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38  
39 contract DecentToken is ERC23Interface {
40     string public constant symbol = "DCNT";
41     string public constant name = "Decent Token";
42     uint8 public constant decimals = 1;
43     uint256 _totalSupply = 10000000000;
44     
45     // Owner of this contract
46     address public owner;
47  
48     // Balances for each account
49     mapping(address => uint256) balances;
50  
51     // Owner of account approves the transfer of an amount to another account
52     mapping(address => mapping (address => uint256)) allowed;
53  
54     // Functions with this modifier can only be executed by the owner
55     modifier onlyOwner() {
56         if (msg.sender != owner) {
57             throw;
58         }
59         _;
60     }
61  
62     // Constructor
63     function DecentToken() {
64         owner = msg.sender;
65         balances[owner] = _totalSupply;
66     }
67  
68     function totalSupply() constant returns (uint256 totalSupply) {
69         totalSupply = _totalSupply;
70     }
71  
72     // What is the balance of a particular account?
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76  
77     // Transfer the balance from owner's account to another account
78     function transfer(address _to, uint256 _amount) returns (bool success) {
79         if (balances[msg.sender] >= _amount 
80             && _amount > 0
81             && balances[_to] + _amount > balances[_to]) {
82             balances[msg.sender] -= _amount;
83             balances[_to] += _amount;
84             Transfer(msg.sender, _to, _amount);
85             return true;
86         } else {
87             return false;
88         }
89     }
90 
91     // Transfer the balance from owner's account to another account
92     function transfer(address _to, uint256 _amount, bytes _data) returns (bool success) {
93         if (balances[msg.sender] >= _amount 
94             && _amount > 0
95             && balances[_to] + _amount > balances[_to]) {
96             balances[msg.sender] -= _amount;
97             balances[_to] += _amount;
98             Transfer(msg.sender, _to, _amount, _data);
99             return true;
100         } else {
101             return false;
102         }
103     }
104  
105     // Send _value amount of tokens from address _from to address _to
106     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
107     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
108     // fees in sub-currencies; the command should fail unless the _from account has
109     // deliberately authorized the sender of the message via some mechanism; we propose
110     // these standardized APIs for approval:
111     function transferFrom(
112         address _from,
113         address _to,
114         uint256 _amount
115     ) returns (bool success) {
116         if (balances[_from] >= _amount
117             && allowed[_from][msg.sender] >= _amount
118             && _amount > 0
119             && balances[_to] + _amount > balances[_to]) {
120             balances[_from] -= _amount;
121             allowed[_from][msg.sender] -= _amount;
122             balances[_to] += _amount;
123             Transfer(_from, _to, _amount);
124             return true;
125         } else {
126             return false;
127         }
128     }
129  
130     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
131     // If this function is called again it overwrites the current allowance with _value.
132     function approve(address _spender, uint256 _amount) returns (bool success) {
133         allowed[msg.sender][_spender] = _amount;
134         Approval(msg.sender, _spender, _amount);
135         return true;
136     }
137  
138     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
139         return allowed[_owner][_spender];
140     }
141 }