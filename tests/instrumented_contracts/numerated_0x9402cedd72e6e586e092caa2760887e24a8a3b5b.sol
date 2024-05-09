1 pragma solidity ^0.4.8;
2 
3 // Confirms to ERC Token Standard #20 Interface
4 // https://github.com/ethereum/EIPs/issues/20
5 // Created for demonstration purposes, but... who knows!?
6 // Brian Fioca 6/23/17
7 contract Fiocoin {
8     string public constant symbol = "FIOCOIN";
9     string public constant name = "Fiocoin";
10     uint8 public constant decimals = 0;
11     uint256 _totalSupply = 514; // starting supply
12 
13     // Owner of this contract
14     address public owner;
15 
16     // Balances for each account
17     mapping(address => uint256) balances;
18 
19     // Owner of account approves the transfer of an amount to another account
20     mapping(address => mapping (address => uint256)) allowed;
21 
22     // Enables the owner to freeze or unfreeze assets
23     mapping (address => bool) public frozenAccount;
24 
25     // Triggered when tokens are transferred
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27 
28     // Triggered whenever approve(address _spender, uint256 _value) is called
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 
31     // Used to freeze funds of an account
32     event FrozenFunds(address target, bool frozen);
33 
34     // ============================
35     // Ownership-related functions
36     // ============================
37     // Functions with this modifier can only be executed by the owner
38     modifier onlyOwner() {
39         if (msg.sender != owner) {
40             throw;
41         }
42         _;
43     }
44 
45     function owned() {
46         owner = msg.sender;
47     }
48 
49     function transferOwnership(address newOwner) onlyOwner {
50         owner = newOwner;
51     }
52     // ============================
53 
54 
55     // Constructor
56     function Fiocoin() {
57         owner = msg.sender;
58         balances[owner] = _totalSupply;
59     }
60 
61     // What is the current totalSupply?
62     function totalSupply() constant returns (uint256 totalSupply) {
63         return _totalSupply;
64     }
65 
66     // What is the balance of a particular account?
67     function balanceOf(address _owner) constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71     // Transfer the balance from owner's account to another account
72     function transfer(address _to, uint256 _amount) returns (bool success) {
73         if (frozenAccount[msg.sender]) throw;
74         if (balances[msg.sender] >= _amount
75             && _amount > 0
76             && balances[_to] + _amount > balances[_to]) {
77             balances[msg.sender] -= _amount;
78             balances[_to] += _amount;
79             Transfer(msg.sender, _to, _amount);
80             return true;
81         } else {
82             return false;
83         }
84     }
85 
86     // Send _value amount of tokens from address _from to address _to
87     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
88     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
89     // fees in sub-currencies; the command should fail unless the _from account has
90     // deliberately authorized the sender of the message via some mechanism; we propose
91     // these standardized APIs for approval:
92     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
93         if (balances[_from] >= _amount
94             && allowed[_from][msg.sender] >= _amount
95             && _amount > 0
96             && balances[_to] + _amount > balances[_to]) {
97             balances[_from] -= _amount;
98             allowed[_from][msg.sender] -= _amount;
99             balances[_to] += _amount;
100             Transfer(_from, _to, _amount);
101             return true;
102         } else {
103             return false;
104         }
105     }
106 
107     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
108     // If this function is called again it overwrites the current allowance with _value.
109     function approve(address _spender, uint256 _amount) returns (bool success) {
110         allowed[msg.sender][_spender] = _amount;
111         Approval(msg.sender, _spender, _amount);
112         return true;
113     }
114 
115     // Fetch the current allowance of a spender
116     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
117         return allowed[_owner][_spender];
118     }
119 
120     // allows owner to add tokens to the total supply
121     function mintToken(address target, uint256 mintedAmount) onlyOwner {
122         balances[target] += mintedAmount;
123         _totalSupply += mintedAmount;
124         Transfer(0, owner, mintedAmount);
125         Transfer(owner, target, mintedAmount);
126     }
127 }