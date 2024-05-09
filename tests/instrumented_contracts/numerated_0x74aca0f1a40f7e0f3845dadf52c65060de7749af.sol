1 pragma solidity ^0.4.8;
2 
3 // ----------------------------------------------------------------------------------------------
4 // The Ripto Bux smart contract - to find out more, join the Incent Slack; http://incentinvites.herokuapp.com/
5 // A collaboration between Incent and Bok :)
6 // Enjoy. (c) Incent Loyalty Pty Ltd and Bok Consulting Pty Ltd 2017. The MIT Licence.
7 // ----------------------------------------------------------------------------------------------
8 
9 // Contract configuration
10 contract TokenConfig {
11     string public constant symbol = "RBX";
12     string public constant name = "Ripto Bux";
13     uint8 public constant decimals = 8;  // 8 decimal places, the same as tokens on Wave
14     uint256 _totalSupply = 100000000000000000;
15 }
16 
17 // ERC Token Standard #20 Interface
18 // https://github.com/ethereum/EIPs/issues/20
19 contract ERC20Interface {
20     // Get the total token supply
21     function totalSupply() constant returns (uint256 totalSupply);
22 
23     // Get the account balance of another account with address _owner
24     function balanceOf(address _owner) constant returns (uint256 balance);
25 
26     // Send _value amount of tokens to address _to
27     function transfer(address _to, uint256 _value) returns (bool success);
28 
29     // Send _value amount of tokens from address _from to address _to
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
31 
32     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
33     // If this function is called again it overwrites the current allowance with _value.
34     // this function is required for some DEX functionality
35     function approve(address _spender, uint256 _value) returns (bool success);
36 
37     // Returns the amount which _spender is still allowed to withdraw from _owner
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
39 
40     // Triggered when tokens are transferred.
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42 
43     // Triggered whenever approve(address _spender, uint256 _value) is called.
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 contract RiptoBuxToken is ERC20Interface, TokenConfig {
48     // Owner of this contract
49     address public owner;
50 
51     // Balances for each account
52     mapping(address => uint256) balances;
53 
54     // Owner of account approves the transfer of an amount to another account
55     mapping(address => mapping (address => uint256)) allowed;
56 
57     // Functions with this modifier can only be executed by the owner
58     modifier onlyOwner() {
59         if (msg.sender != owner) {
60             throw;
61         }
62         _;
63     }
64 
65     // Constructor
66     function RiptoBuxToken() {
67         owner = msg.sender;
68         balances[owner] = _totalSupply;
69     }
70 
71     function totalSupply() constant returns (uint256 totalSupply) {
72         totalSupply = _totalSupply;
73     }
74 
75     // What is the balance of a particular account?
76     function balanceOf(address _owner) constant returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80     // Transfer the balance from owner's account to another account
81     function transfer(address _to, uint256 _amount) returns (bool success) {
82         if (balances[msg.sender] >= _amount
83             && _amount > 0
84             && balances[_to] + _amount > balances[_to]) {
85             balances[msg.sender] -= _amount;
86             balances[_to] += _amount;
87             Transfer(msg.sender, _to, _amount);
88             return true;
89         } else {
90             return false;
91         }
92     }
93 
94     // Send _value amount of tokens from address _from to address _to
95     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
96     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
97     // fees in sub-currencies; the command should fail unless the _from account has
98     // deliberately authorized the sender of the message via some mechanism; we propose
99     // these standardized APIs for approval:
100     function transferFrom(
101         address _from,
102         address _to,
103         uint256 _amount
104 ) returns (bool success) {
105         if (balances[_from] >= _amount
106             && allowed[_from][msg.sender] >= _amount
107             && _amount > 0
108             && balances[_to] + _amount > balances[_to]) {
109             balances[_from] -= _amount;
110             allowed[_from][msg.sender] -= _amount;
111             balances[_to] += _amount;
112             Transfer(_from, _to, _amount);
113             return true;
114         } else {
115             return false;
116         }
117     }
118 
119     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
120     // If this function is called again it overwrites the current allowance with _value.
121     function approve(address _spender, uint256 _amount) returns (bool success) {
122         allowed[msg.sender][_spender] = _amount;
123         Approval(msg.sender, _spender, _amount);
124         return true;
125     }
126 
127     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
128         return allowed[_owner][_spender];
129     }
130 }
131 
132 contract WavesEthereumSwap is RiptoBuxToken {
133     event WavesTransfer(address indexed _from, string wavesAddress, uint256 amount);
134 
135     function moveToWaves(string wavesAddress, uint256 amount) {
136         if (!transfer(owner, amount)) throw;
137         WavesTransfer(msg.sender, wavesAddress, amount);
138     }
139 }