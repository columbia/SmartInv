1 pragma solidity ^0.4.2;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Basic ERC20 Token Contract For **TESTING ONLY** on Testnet or Dev blockchain.
5 //
6 // Enjoy. (c) Bok Consulting Pty Ltd 2016. The MIT Licence.
7 // ----------------------------------------------------------------------------------------------
8 
9 // ERC Token Standard #20 Interface
10 // https://github.com/ethereum/EIPs/issues/20
11 contract ERC20Interface {
12 
13     // Get the total token supply
14     function totalSupply() constant returns (uint256 totalSupply);
15 
16     // Get the account balance of another account with address _owner
17     function balanceOf(address _owner) constant returns (uint256 balance);
18 
19     // Send _value amount of tokens to address _to
20     function transfer(address _to, uint256 _value) returns (bool success);
21 
22     // Send _value amount of tokens from address _from to address _to
23     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
24     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
25     // fees in sub-currencies; the command should fail unless the _from account has
26     // deliberately authorized the sender of the message via some mechanism; we propose
27     // these standardized APIs for approval:
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
29 
30     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
31     // If this function is called again it overwrites the current allowance with _value.
32     function approve(address _spender, uint256 _value) returns (bool success);
33 
34     // Returns the amount which _spender is still allowed to withdraw from _owner
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
36 
37     // Triggered when tokens are transferred.
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39 
40     // Triggered whenever approve(address _spender, uint256 _value) is called.
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 }
43 
44 contract IncentCoffeeToken is ERC20Interface {
45 
46     /* copied from Bok's github - https://github.com/bokkypoobah/TokenTrader/wiki/GNT-%E2%80%90-Golem-Network-Token */
47     string public constant name = "Incent Coffee Token";
48     string public constant symbol = "INCOF";
49     uint8 public constant decimals = 0;  // 0 decimal places, the same as tokens on Wave
50 
51     // Owner of this contract
52     address public owner;
53 
54     // Balances for each account
55     mapping(address => uint256) balances;
56 
57     // Owner of account approves the transfer of an amount to another account
58     mapping(address => mapping (address => uint256)) allowed;
59 
60     // Total supply
61     uint256 _totalSupply;
62 
63     // Functions with this modifier can only be executed by the owner
64     modifier onlyOwner() {
65         if (msg.sender != owner) {
66             throw;
67         }
68         _;
69     }
70 
71     // Constructor
72     function IncentCoffeeToken() {
73 
74         _totalSupply = 824;
75         owner = msg.sender;
76         balances[owner] = _totalSupply;
77     }
78 
79     function totalSupply() constant returns (uint256 totalSupply) {
80         totalSupply = _totalSupply;
81     }
82 
83     // What is the balance of a particular account?
84     function balanceOf(address _owner) constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     // Transfer the balance from owner's account to another account
89     function transfer(address _to, uint256 _amount) returns (bool success) {
90         if (balances[msg.sender] >= _amount && _amount > 0) {
91             balances[msg.sender] -= _amount;
92             balances[_to] += _amount;
93             Transfer(msg.sender, _to, _amount);
94             return true;
95         } else {
96            return false;
97         }
98     }
99 
100     // Send _value amount of tokens from address _from to address _to
101     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
102     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
103     // fees in sub-currencies; the command should fail unless the _from account has
104     // deliberately authorized the sender of the message via some mechanism; we propose
105     // these standardized APIs for approval:
106     function transferFrom(
107         address _from,
108         address _to,
109         uint256 _amount
110     ) returns (bool success) {
111 
112         if (balances[_from] >= _amount
113             && allowed[_from][msg.sender] >= _amount
114             && _amount > 0) {
115 
116             balances[_to] += _amount;
117             balances[_from] -= _amount;
118             allowed[_from][msg.sender] -= _amount;
119             Transfer(_from, _to, _amount);
120             return true;
121         } else {
122             return false;
123         }
124     }
125 
126     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
127     // If this function is called again it overwrites the current allowance with _value.
128     function approve(address _spender, uint256 _amount) returns (bool success) {
129         allowed[msg.sender][_spender] = _amount;
130         Approval(msg.sender, _spender, _amount);
131         return true;
132     }
133 
134     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
135         return allowed[_owner][_spender];
136     }
137 
138 
139 }
140 
141 contract WavesEthereumSwap is IncentCoffeeToken {
142 
143  event WavesTransfer(address indexed _from, string wavesAddress, uint256 amount);
144 
145  function moveToWaves(string wavesAddress, uint256 amount) {
146 
147      if (!transfer(owner, amount)) throw;
148      WavesTransfer(msg.sender, wavesAddress, amount);
149 
150  }
151 
152 }