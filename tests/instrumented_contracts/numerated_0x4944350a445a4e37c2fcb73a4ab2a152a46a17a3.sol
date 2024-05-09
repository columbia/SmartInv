1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 
4 contract Token {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) constant returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
33 
34     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of wei to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 contract StandardToken is Token {
50 
51     function transfer(address _to, uint256 _value) returns (bool success) {
52         //Default assumes totalSupply can't be over max (2^256 - 1).
53         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
54         //Replace the if with this one instead.
55         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
56         if (balances[msg.sender] >= _value && _value > 0) {
57             balances[msg.sender] -= _value;
58             balances[_to] += _value;
59             Transfer(msg.sender, _to, _value);
60             return true;
61         } else { return false; }
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
65         //same as above. Replace this line with the following if you want to protect against wrapping uints.
66         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
67         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
68             balances[_to] += _value;
69             balances[_from] -= _value;
70             allowed[_from][msg.sender] -= _value;
71             Transfer(_from, _to, _value);
72             return true;
73         } else { return false; }
74     }
75 
76     function balanceOf(address _owner) constant returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80     function approve(address _spender, uint256 _value) returns (bool success) {
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
87       return allowed[_owner][_spender];
88     }
89 
90     mapping (address => uint256) balances;
91     mapping (address => mapping (address => uint256)) allowed;
92 }
93 
94 
95 contract ATMGold is StandardToken {
96 
97     function () {
98         //if ether is sent to this address, send it back.
99         throw;
100     }
101 
102     /* Public variables of the token */
103 
104     /*
105     NOTE:
106     The following variables are OPTIONAL vanities. One does not have to include them.
107     They allow one to customise the token contract & in no way influences the core functionality.
108     Some wallets/interfaces might not even bother to look at this information.
109     */
110     string public name;                   //fancy name: eg Simon Bucks
111     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
112     string public symbol;                 //An identifier: eg SBX
113     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
114 
115     function ATMGold(
116         uint256 _initialAmount,
117         string _tokenName,
118         uint8 _decimalUnits,
119         string _tokenSymbol
120         ) {
121         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
122         totalSupply = _initialAmount;                        // Update total supply
123         name = _tokenName;                                   // Set the name for display purposes
124         decimals = _decimalUnits;                            // Amount of decimals for display purposes
125         symbol = _tokenSymbol;                               // Set the symbol for display purposes
126     }
127 
128     /* Approves and then calls the receiving contract */
129     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
130         allowed[msg.sender][_spender] = _value;
131         Approval(msg.sender, _spender, _value);
132 
133         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
134         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
135         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
136         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
137         return true;
138     }
139 }