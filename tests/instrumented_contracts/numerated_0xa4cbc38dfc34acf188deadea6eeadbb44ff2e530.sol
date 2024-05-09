1 pragma solidity ^0.4.8;
2 
3 // ----------------------------------------------------------------------------------------------
4 // The ETVX ETHVINEX Token contract
5 //
6 // Enjoy. (c) MobileGo, Incent Loyalty Pty Ltd and Bok Consulting Pty Ltd 2017. The MIT Licence.
7 // ----------------------------------------------------------------------------------------------
8 
9 // Contract configuration
10 contract TokenConfig {
11     string public constant symbol = "STVX";
12     string public constant name = "STHVINEX TOKEN";
13     uint8 public constant decimals = 18;  // 8 decimal places, the same as tokens on Wave
14     // TODO: Work out the totalSupply when the MobileGo crowdsale ends
15     uint256 _totalSupply = 500000000000000000000000000; // 10,000,000
16 }
17 
18 // ERC Token Standard #20 Interface
19 // https://github.com/ethereum/EIPs/issues/20
20 contract ERC20Interface {
21     // Get the total token supply
22     function totalSupply() constant returns (uint256 totalSupply);
23 
24     // Get the account balance of another account with address _owner
25     function balanceOf(address _owner) constant returns (uint256 balance);
26 
27     // Send _value amount of tokens to address _to
28     function transfer(address _to, uint256 _value) returns (bool success);
29 
30     // Send _value amount of tokens from address _from to address _to
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
32 
33     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
34     // If this function is called again it overwrites the current allowance with _value.
35     // this function is required for some DEX functionality
36     function approve(address _spender, uint256 _value) returns (bool success);
37 
38     // Returns the amount which _spender is still allowed to withdraw from _owner
39     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
40 
41     // Triggered when tokens are transferred.
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43 
44     // Triggered whenever approve(address _spender, uint256 _value) is called.
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 contract MobileGoToken is ERC20Interface, TokenConfig {
49     // Owner of this contract
50     address public owner;
51 
52     // Balances for each account
53     mapping(address => uint256) balances;
54 
55     // Owner of account approves the transfer of an amount to another account
56     mapping(address => mapping (address => uint256)) allowed;
57 
58     // Functions with this modifier can only be executed by the owner
59     modifier onlyOwner() {
60         if (msg.sender != owner) {
61             throw;
62         }
63         _;
64     }
65 
66     // Constructor
67     function MobileGoToken() {
68         owner = msg.sender;
69         balances[owner] = _totalSupply;
70     }
71 
72     function totalSupply() constant returns (uint256 totalSupply) {
73         totalSupply = _totalSupply;
74     }
75 
76     // What is the balance of a particular account?
77     function balanceOf(address _owner) constant returns (uint256 balance) {
78         return balances[_owner];
79     }
80 
81     // Transfer the balance from owner's account to another account
82     function transfer(address _to, uint256 _amount) returns (bool success) {
83         if (balances[msg.sender] >= _amount
84             && _amount > 0
85             && balances[_to] + _amount > balances[_to]) {
86             balances[msg.sender] -= _amount;
87             balances[_to] += _amount;
88             Transfer(msg.sender, _to, _amount);
89             return true;
90         } else {
91             return false;
92         }
93     }
94 
95     // Send _value amount of tokens from address _from to address _to
96     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
97     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
98     // fees in sub-currencies; the command should fail unless the _from account has
99     // deliberately authorized the sender of the message via some mechanism; we propose
100     // these standardized APIs for approval:
101     function transferFrom(
102         address _from,
103         address _to,
104         uint256 _amount
105     ) returns (bool success) {
106         if (balances[_from] >= _amount
107             && allowed[_from][msg.sender] >= _amount
108             && _amount > 0
109             && balances[_to] + _amount > balances[_to]) {
110             balances[_from] -= _amount;
111             allowed[_from][msg.sender] -= _amount;
112             balances[_to] += _amount;
113             Transfer(_from, _to, _amount);
114             return true;
115         } else {
116             return false;
117         }
118     }
119 
120     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
121     // If this function is called again it overwrites the current allowance with _value.
122     function approve(address _spender, uint256 _amount) returns (bool success) {
123         allowed[msg.sender][_spender] = _amount;
124         Approval(msg.sender, _spender, _amount);
125         return true;
126     }
127 
128     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
129         return allowed[_owner][_spender];
130     }
131 }
132 
133 contract WavesEthereumSwap is MobileGoToken {
134     event WavesTransfer(address indexed _from, string wavesAddress, uint256 amount);
135 
136     function moveToWaves(string wavesAddress, uint256 amount) {
137         if (!transfer(owner, amount)) throw;
138         WavesTransfer(msg.sender, wavesAddress, amount);
139     }
140 }