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
49     string public constant wavesAssetId = "4rmhfoscYcjz1imNDvtz45doouvrQqDpbX7xdfLB4guF";
50     uint8 public constant decimals = 0;  // 0 decimal places, the same as tokens on Wave
51 
52     // Owner of this contract
53     address public owner;
54 
55     // Balances for each account
56     mapping(address => uint256) balances;
57 
58     // Owner of account approves the transfer of an amount to another account
59     mapping(address => mapping (address => uint256)) allowed;
60 
61     // Total supply
62     uint256 _totalSupply;
63 
64     // Functions with this modifier can only be executed by the owner
65     modifier onlyOwner() {
66         if (msg.sender != owner) {
67             throw;
68         }
69         _;
70     }
71 
72     // Constructor
73     function IncentCoffeeToken() {
74 
75         _totalSupply = 824;
76         owner = msg.sender;
77         balances[owner] = _totalSupply;
78     }
79 
80     function totalSupply() constant returns (uint256 totalSupply) {
81         totalSupply = _totalSupply;
82     }
83 
84     // What is the balance of a particular account?
85     function balanceOf(address _owner) constant returns (uint256 balance) {
86         return balances[_owner];
87     }
88 
89     // Transfer the balance from owner's account to another account
90     function transfer(address _to, uint256 _amount) returns (bool success) {
91         if (balances[msg.sender] >= _amount && _amount > 0) {
92             balances[msg.sender] -= _amount;
93             balances[_to] += _amount;
94             Transfer(msg.sender, _to, _amount);
95             return true;
96         } else {
97            return false;
98         }
99     }
100 
101     // Send _value amount of tokens from address _from to address _to
102     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
103     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
104     // fees in sub-currencies; the command should fail unless the _from account has
105     // deliberately authorized the sender of the message via some mechanism; we propose
106     // these standardized APIs for approval:
107     function transferFrom(
108         address _from,
109         address _to,
110         uint256 _amount
111     ) returns (bool success) {
112 
113         if (balances[_from] >= _amount
114             && allowed[_from][msg.sender] >= _amount
115             && _amount > 0) {
116 
117             balances[_to] += _amount;
118             balances[_from] -= _amount;
119             allowed[_from][msg.sender] -= _amount;
120             Transfer(_from, _to, _amount);
121             return true;
122         } else {
123             return false;
124         }
125     }
126 
127     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
128     // If this function is called again it overwrites the current allowance with _value.
129     function approve(address _spender, uint256 _amount) returns (bool success) {
130         allowed[msg.sender][_spender] = _amount;
131         Approval(msg.sender, _spender, _amount);
132         return true;
133     }
134 
135     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
136         return allowed[_owner][_spender];
137     }
138 
139 
140 }
141 
142 contract WavesEthereumSwap is IncentCoffeeToken {
143 
144  event WavesTransfer(address indexed _from, string indexed wavesAddress, uint256 amount);
145 
146  function moveToWaves(string wavesAddress, uint256 amount) {
147 
148      if (!transfer(owner, amount)) throw;
149      WavesTransfer(msg.sender, wavesAddress, amount);
150 
151  }
152 
153 }