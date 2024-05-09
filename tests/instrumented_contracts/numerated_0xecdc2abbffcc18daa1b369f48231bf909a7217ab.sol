1 pragma solidity ^0.4.8;
2 
3 // ----------------------------------------------------------------------------------------------
4 // It's a lovely day to be solidity coding.
5 // This contract adapted from work by Bok, originally working with Incent Coffee Tokens.
6 // Adapted and extended by Peter, for the Hut34 Project - www.hut34.io
7 //
8 // Thanks and appreciation to bokconsulting.com.au
9 // no rights reserved, other than those required by Bok's MIT license. Don't be evil.
10 // ----------------------------------------------------------------------------------------------
11 
12 // Contract configuration
13 contract TokenConfig {
14     string public constant symbol = "ETX";
15     string public constant name = "Entropy Test Token";
16     uint8 public constant decimals = 18;
17     uint256 _totalSupply = 100000000000000000000000000;
18 }
19 
20 // ERC Token Standard #20 Interface
21 // https://github.com/ethereum/EIPs/issues/20
22 contract ERC20Interface {
23     // Get the total token supply
24     function totalSupply() constant returns (uint256 totalSupply);
25 
26     // Get the account balance of another account with address _owner
27     function balanceOf(address _owner) constant returns (uint256 balance);
28 
29     // Send _value amount of tokens to address _to
30     function transfer(address _to, uint256 _value) returns (bool success);
31 
32     // Send _value amount of tokens from address _from to address _to
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34 
35     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
36     // If this function is called again it overwrites the current allowance with _value.
37     // this function is required for some DEX functionality
38     function approve(address _spender, uint256 _value) returns (bool success);
39 
40     // Returns the amount which _spender is still allowed to withdraw from _owner
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
42 
43     // Triggered when tokens are transferred.
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45 
46     // Triggered whenever approve(address _spender, uint256 _value) is called.
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 contract EntropyTestToken is ERC20Interface, TokenConfig {
51     // Owner of this contract
52     address public owner;
53 
54     // Balances for each account
55     mapping(address => uint256) balances;
56 
57     // Owner of account approves the transfer of an amount to another account
58     mapping(address => mapping (address => uint256)) allowed;
59 
60     // Functions with this modifier can only be executed by the owner
61     modifier onlyOwner() {
62         if (msg.sender != owner) {
63             revert();
64         }
65         _;
66     }
67 
68     // Constructor
69     function EntropyTestToken() {
70         owner = msg.sender;
71         balances[owner] = _totalSupply;
72     }
73 
74     function totalSupply() constant returns (uint256 totalSupply) {
75         totalSupply = _totalSupply;
76     }
77 
78     // What is the balance of a particular account?
79     function balanceOf(address _owner) constant returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     // Transfer the balance from owner's account to another account
84     function transfer(address _to, uint256 _amount) returns (bool success) {
85         if (balances[msg.sender] >= _amount
86             && _amount > 0
87             && balances[_to] + _amount > balances[_to]) {
88             balances[msg.sender] -= _amount;
89             balances[_to] += _amount;
90             Transfer(msg.sender, _to, _amount);
91             return true;
92         } else {
93             return false;
94         }
95     }
96 
97     // Send _value amount of tokens from address _from to address _to
98     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
99     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
100     // fees in sub-currencies; the command should fail unless the _from account has
101     // deliberately authorized the sender of the message via some mechanism; we propose
102     // these standardized APIs for approval:
103     function transferFrom(
104         address _from,
105         address _to,
106         uint256 _amount
107 ) returns (bool success) {
108         if (balances[_from] >= _amount
109             && allowed[_from][msg.sender] >= _amount
110             && _amount > 0
111             && balances[_to] + _amount > balances[_to]) {
112             balances[_from] -= _amount;
113             allowed[_from][msg.sender] -= _amount;
114             balances[_to] += _amount;
115             Transfer(_from, _to, _amount);
116             return true;
117         } else {
118             return false;
119         }
120     }
121 
122     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
123     // If this function is called again it overwrites the current allowance with _value.
124     function approve(address _spender, uint256 _amount) returns (bool success) {
125         allowed[msg.sender][_spender] = _amount;
126         Approval(msg.sender, _spender, _amount);
127         return true;
128     }
129 
130     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
131         return allowed[_owner][_spender];
132     }
133 }
134 
135 contract EntropyTxWithMeta is EntropyTestToken {
136     event EntropyTxDetails(address indexed _from, string entropyTxDetail, uint256 amount);
137 
138     function logEntropyTxDetails(string entropyTxDetail, uint256 amount) {
139         if (!transfer(owner, amount)) revert();
140         EntropyTxDetails(msg.sender, entropyTxDetail, amount);
141     }
142 }