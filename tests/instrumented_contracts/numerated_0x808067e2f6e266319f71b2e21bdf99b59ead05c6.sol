1 pragma solidity ^0.4.14;
2 
3 // Modified by jjv360 for ProWallet
4 //
5 // ----------------------------------------------------------------------------------------------
6 // Sample fixed supply token contract
7 // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
8 // ----------------------------------------------------------------------------------------------
9 
10 // ERC Token Standard #20 Interface
11 // https://github.com/ethereum/EIPs/issues/20
12 contract ERC20Interface {
13 
14     // Get the total token supply
15     function totalSupply() constant returns (uint256 totalSupply);
16 
17     // Get the account balance of another account with address _owner
18     function balanceOf(address _owner) constant returns (uint256 balance);
19 
20     // Send _value amount of tokens to address _to
21     function transfer(address _to, uint256 _value) returns (bool success);
22 
23     // Send _value amount of tokens from address _from to address _to
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
25 
26     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
27     // If this function is called again it overwrites the current allowance with _value.
28     // this function is required for some DEX functionality
29     function approve(address _spender, uint256 _value) returns (bool success);
30 
31     // Returns the amount which _spender is still allowed to withdraw from _owner
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
33 
34     // Triggered when tokens are transferred or generated.
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36 
37     // Triggered whenever approve(address _spender, uint256 _value) is called.
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40 }
41 
42 contract ProWalletToken is ERC20Interface {
43 
44     // Variables
45     string public constant symbol = "TST";
46     string public constant name = "TestFlex";
47     uint8 public constant decimals = 18;
48     uint256 _totalSupply = 120000000000000000000;
49 
50     // Owner of this contract
51     address public owner;
52 
53     // Balances for each account
54     mapping(address => uint256) balances;
55 
56     // Owner of account approves the transfer of an amount to another account
57     mapping(address => mapping (address => uint256)) allowed;
58 
59     // Functions with this modifier can only be executed by the owner
60     modifier onlyOwner() {
61         if (msg.sender != owner) {
62             throw;
63         }
64         _;
65     }
66 
67     // Constructor. Sends all the initial tokens to the owner's account.
68     function ProWalletToken() {
69         owner = msg.sender;
70         balances[owner] = _totalSupply;
71     }
72 
73     // Creates more tokens and sends them to the owner's account
74     function generate(uint256 _amount) onlyOwner returns (bool success) {
75 
76         // Check conditions
77         if (_amount > 0 && balances[owner] + _amount > balances[owner]) {
78 
79             // Success, add tokens to owner account
80             balances[owner] += _amount;
81 
82             // Trigger the transfer event
83             Transfer(0, owner, _amount);
84 
85             // Return success
86             return true;
87 
88         } else {
89 
90             // Conditions failed
91             return false;
92 
93         }
94 
95     }
96 
97     // Returns the count of all tokens in existence
98     function totalSupply() constant returns (uint256 totalSupply) {
99         totalSupply = _totalSupply;
100     }
101 
102     // What is the balance of a particular account?
103     function balanceOf(address _owner) constant returns (uint256 balance) {
104         return balances[_owner];
105     }
106 
107     // Transfer the balance from owner's account to another account
108     function transfer(address _to, uint256 _amount) returns (bool success) {
109 
110         // Check if user hs enough tokens && amount to send is bigger than 0 && no buffer overflow in target account
111         if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
112 
113             // Success, remove tokens from sender account and add to recipient account
114             balances[msg.sender] -= _amount;
115             balances[_to] += _amount;
116 
117             // Trigger the transfer event
118             Transfer(msg.sender, _to, _amount);
119 
120             // Return success
121             return true;
122 
123         } else {
124 
125             // Conditions failed
126             return false;
127 
128         }
129 
130     }
131 
132     // Send _value amount of tokens from address _from to address _to
133     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
134     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
135     // fees in sub-currencies; the command should fail unless the _from account has
136     // deliberately authorized the sender of the message via some mechanism; we propose
137     // these standardized APIs for approval:
138     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
139 
140         // Check if sender has enough tokens && recipient is allowed to take these tokens from the sender && amount > 0 && no buffer overflow
141         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
142 
143             // Success, update account balances, remove from allowed balance as well
144             balances[_from] -= _amount;
145             allowed[_from][msg.sender] -= _amount;
146             balances[_to] += _amount;
147 
148             // Trigger transfer event
149             Transfer(_from, _to, _amount);
150 
151             // Return success
152             return true;
153 
154         } else {
155 
156             // Conditions failed
157             return false;
158 
159         }
160 
161     }
162 
163     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
164     // If this function is called again it overwrites the current allowance with _value.
165     function approve(address _spender, uint256 _amount) returns (bool success) {
166 
167         // Set the amount that _spender is allowed to take from our account
168         allowed[msg.sender][_spender] = _amount;
169 
170         // Trigger approval event
171         Approval(msg.sender, _spender, _amount);
172 
173         // Done
174         return true;
175 
176     }
177 
178     // Returns the amount that _spender is allowed to withdraw from _owner's account
179     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
180         return allowed[_owner][_spender];
181     }
182 
183 }