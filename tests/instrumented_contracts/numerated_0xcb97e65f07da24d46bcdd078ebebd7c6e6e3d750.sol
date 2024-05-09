1 contract Token {
2     /* This is a slight change to the ERC20 base standard.
3     function totalSupply() constant returns (uint256 supply);
4     is replaced with:
5     uint256 public totalSupply;
6     This automatically creates a getter function for the totalSupply.
7     This is moved to the base contract since public getter functions are not
8     currently recognised as an implementation of the matching abstract
9     function by the compiler.
10     */
11     /// total amount of tokens
12     uint256 public totalSupply;
13 
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) constant returns (uint256 balance);
17 
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) returns (bool success);
23 
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
30 
31     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of tokens to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) returns (bool success);
36 
37     /// @param _owner The address of the account owning tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @return Amount of remaining tokens allowed to spent
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 /*
47 You should inherit from StandardToken or, for a token like you would want to
48 deploy in something like Mist, see HumanStandardToken.sol.
49 (This implements ONLY the standard functions and NOTHING else.
50 If you deploy this, you won't have anything useful.)
51 
52 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
53 .*/
54 
55 contract StandardToken is Token {
56 
57     function transfer(address _to, uint256 _value) returns (bool success) {
58         //Default assumes totalSupply can't be over max (2^256 - 1).
59         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
60         //Replace the if with this one instead.
61         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
62         if (balances[msg.sender] >= _value && _value > 0) {
63             balances[msg.sender] -= _value;
64             balances[_to] += _value;
65             Transfer(msg.sender, _to, _value);
66             return true;
67         } else { return false; }
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
71         //same as above. Replace this line with the following if you want to protect against wrapping uints.
72         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
73         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
74             balances[_to] += _value;
75             balances[_from] -= _value;
76             allowed[_from][msg.sender] -= _value;
77             Transfer(_from, _to, _value);
78             return true;
79         } else { return false; }
80     }
81 
82     function balanceOf(address _owner) constant returns (uint256 balance) {
83         return balances[_owner];
84     }
85 
86     function approve(address _spender, uint256 _value) returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
93       return allowed[_owner][_spender];
94     }
95 
96     mapping (address => uint256) balances;
97     mapping (address => mapping (address => uint256)) allowed;
98 }
99 
100 contract HumanStandardToken is StandardToken {
101 
102     function () {
103         //if ether is sent to this address, send it back.
104         throw;
105     }
106 
107     /* Public variables of the token */
108 
109     /*
110     NOTE:
111     The following variables are OPTIONAL vanities. One does not have to include them.
112     They allow one to customise the token contract & in no way influences the core functionality.
113     Some wallets/interfaces might not even bother to look at this information.
114     */
115     string public name;                   //fancy name: eg Simon Bucks
116     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
117     string public symbol;                 //An identifier: eg SBX
118     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
119 
120     function HumanStandardToken(
121         uint256 _initialAmount,
122         string _tokenName,
123         uint8 _decimalUnits,
124         string _tokenSymbol
125         ) {
126         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
127         totalSupply = _initialAmount;                        // Update total supply
128         name = _tokenName;                                   // Set the name for display purposes
129         decimals = _decimalUnits;                            // Amount of decimals for display purposes
130         symbol = _tokenSymbol;                               // Set the symbol for display purposes
131     }
132 
133     /* Approves and then calls the receiving contract */
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
135         allowed[msg.sender][_spender] = _value;
136         Approval(msg.sender, _spender, _value);
137 
138         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
139         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
140         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
141         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
142         return true;
143     }
144 }