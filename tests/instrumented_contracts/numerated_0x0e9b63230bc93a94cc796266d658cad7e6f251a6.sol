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
31     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of wei to be approved for transfer
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
46 contract StandardToken is Token {
47 
48     function transfer(address _to, uint256 _value) returns (bool success) {
49         //Default assumes totalSupply can't be over max (2^256 - 1).
50         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
51         //Replace the if with this one instead.
52         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
53         if (balances[msg.sender] >= _value && _value > 0) {
54             balances[msg.sender] -= _value;
55             balances[_to] += _value;
56             Transfer(msg.sender, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
62         //same as above. Replace this line with the following if you want to protect against wrapping uints.
63         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
64         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
65             balances[_to] += _value;
66             balances[_from] -= _value;
67             allowed[_from][msg.sender] -= _value;
68             Transfer(_from, _to, _value);
69             return true;
70         } else { return false; }
71     }
72 
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value) returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84       return allowed[_owner][_spender];
85     }
86 
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89 }
90 
91 
92 contract HumanStandardToken is StandardToken {
93 
94     function () {
95         //if ether is sent to this address, send it back.
96         throw;
97     }
98 
99     /* Public variables of the token */
100 
101     /*
102     NOTE:
103     The following variables are OPTIONAL vanities. One does not have to include them.
104     They allow one to customise the token contract & in no way influences the core functionality.
105     Some wallets/interfaces might not even bother to look at this information.
106     */
107     string public name;                   //fancy name: eg Simon Bucks
108     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
109     string public symbol;                 //An identifier: eg SBX
110     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
111 
112     function HumanStandardToken(
113         uint256 _initialAmount,
114         string _tokenName,
115         uint8 _decimalUnits,
116         string _tokenSymbol
117         ) {
118         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
119         totalSupply = _initialAmount;                        // Update total supply
120         name = _tokenName;                                   // Set the name for display purposes
121         decimals = _decimalUnits;                            // Amount of decimals for display purposes
122         symbol = _tokenSymbol;                               // Set the symbol for display purposes
123     }
124 
125     /* Approves and then calls the receiving contract */
126     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
127         allowed[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129 
130         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
131         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
132         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
133         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
134         return true;
135     }
136 }