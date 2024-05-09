1 // Modified by jjv360 for ProWallet
2 //
3 // ----------------------------------------------------------------------------------------------
4 // Sample fixed supply token contract
5 // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
6 // ----------------------------------------------------------------------------------------------
7 
8 // ERC Token Standard #20 Interface
9 // https://github.com/ethereum/EIPs/issues/20
10 contract ERC20Interface {
11 
12     // Get the total token supply
13     function totalSupply() constant returns (uint256 totalSupply);
14 
15     // Get the account balance of another account with address _owner
16     function balanceOf(address _owner) constant returns (uint256 balance);
17 
18     // Send _value amount of tokens to address _to
19     function transfer(address _to, uint256 _value) returns (bool success);
20 
21     // Send _value amount of tokens from address _from to address _to
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
23 
24     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
25     // If this function is called again it overwrites the current allowance with _value.
26     // this function is required for some DEX functionality
27     function approve(address _spender, uint256 _value) returns (bool success);
28 
29     // Returns the amount which _spender is still allowed to withdraw from _owner
30     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
31 
32     // Triggered when tokens are transferred.
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34 
35     // Triggered whenever approve(address _spender, uint256 _value) is called.
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38 }
39 
40 contract ProWalletToken is ERC20Interface {
41 
42     // Variables
43     string public constant symbol = "TST";
44     string public constant name = "Test";
45     uint8 public constant decimals = 18;
46     uint256 _totalSupply = 100000000000000000000;
47 
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
65     // Constructor. Sends all the initial tokens to the owner's account.
66     function ProWalletToken() {
67         owner = msg.sender;
68         balances[owner] = _totalSupply;
69     }
70 
71     // Returns the count of all tokens in existence
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
83 
84         // Check if user hs enough tokens && amount to send is bigger than 0 && no buffer overflow in target account
85         if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
86 
87             // Success, remove tokens from sender account and add to recipient account
88             balances[msg.sender] -= _amount;
89             balances[_to] += _amount;
90 
91             // Trigger the transfer event
92             Transfer(msg.sender, _to, _amount);
93 
94             // Return success
95             return true;
96 
97         } else {
98 
99             // Conditions failed
100             return false;
101 
102         }
103 
104     }
105 
106     // Send _value amount of tokens from address _from to address _to
107     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
108     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
109     // fees in sub-currencies; the command should fail unless the _from account has
110     // deliberately authorized the sender of the message via some mechanism; we propose
111     // these standardized APIs for approval:
112     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
113 
114         // Check if sender has enough tokens && recipient is allowed to take these tokens from the sender && amount > 0 && no buffer overflow
115         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
116 
117             // Success, update account balances, remove from allowed balance as well
118             balances[_from] -= _amount;
119             allowed[_from][msg.sender] -= _amount;
120             balances[_to] += _amount;
121 
122             // Trigger transfer event
123             Transfer(_from, _to, _amount);
124 
125             // Return success
126             return true;
127 
128         } else {
129 
130             // Conditions failed
131             return false;
132         }
133 
134     }
135 
136     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
137     // If this function is called again it overwrites the current allowance with _value.
138     function approve(address _spender, uint256 _amount) returns (bool success) {
139 
140         // Set the amount that _spender is allowed to take from our account
141         allowed[msg.sender][_spender] = _amount;
142 
143         // Trigger approval event
144         Approval(msg.sender, _spender, _amount);
145 
146         // Done
147         return true;
148 
149     }
150 
151     // Returns the amount that _spender is allowed to withdraw from _owner's account
152     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
153         return allowed[_owner][_spender];
154     }
155 
156 }