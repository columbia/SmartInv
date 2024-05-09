1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.11;
4 
5 contract Token {
6     
7 /* This is a slight change to the ERC20 base standard.
8     function totalSupply() constant returns (uint256 supply);
9     is replaced with:
10     uint256 public totalSupply;
11     This automatically creates a getter function for the totalSupply.
12     This is moved to the base contract since public getter functions are not
13     currently recognised as an implementation of the matching abstract
14     function by the compiler.
15     */
16     /// total amount of tokens
17     uint256 public totalSupply;
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) constant returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35 
36     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of tokens to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 /*
52 You should inherit from StandardToken or, for a token like you would want to
53 deploy in something like Mist, see HumanStandardToken.sol.
54 (This implements ONLY the standard functions and NOTHING else.
55 If you deploy this, you won't have anything useful.)
56 
57 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
58 .*/
59 
60 contract StandardToken is Token {
61 
62     function transfer(address _to, uint256 _value) returns (bool success) {
63         //Default assumes totalSupply can't be over max (2^256 - 1).
64         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
65         //Replace the if with this one instead.
66         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
67         if (balances[msg.sender] >= _value && _value > 0) {
68             balances[msg.sender] -= _value;
69             balances[_to] += _value;
70             Transfer(msg.sender, _to, _value);
71             return true;
72         } else { return false; }
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
76         //same as above. Replace this line with the following if you want to protect against wrapping uints.
77         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
78         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
79             balances[_to] += _value;
80             balances[_from] -= _value;
81             allowed[_from][msg.sender] -= _value;
82             Transfer(_from, _to, _value);
83             return true;
84         } else { return false; }
85     }
86 
87     function balanceOf(address _owner) constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     function approve(address _spender, uint256 _value) returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
98       return allowed[_owner][_spender];
99     }
100 
101     mapping (address => uint256) balances;
102     mapping (address => mapping (address => uint256)) allowed;
103 }
104 
105 contract BACToken is StandardToken {
106 
107     function () {
108         //if ether is sent to this address, send it back.
109         throw;
110     }
111 
112     /* Public variables of the token */
113 
114     
115 /*
116     NOTE:
117     The following variables are OPTIONAL vanities. One does not have to include them.
118     They allow one to customise the token contract & in no way influences the core functionality.
119     Some wallets/interfaces might not even bother to look at this information.
120     */
121     string public name;                   //fancy name: eg Simon Bucks
122     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
123     string public symbol;                 //An identifier: eg SBX
124     string public version = 'B0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
125 
126     
127 function BACToken
128 (
129         uint256 _initialAmount,
130         string _tokenName,
131         uint8 _decimalUnits,
132         string _tokenSymbol
133         )
134  
135 {
136         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
137         totalSupply = _initialAmount;                        // Update total supply
138         name = _tokenName;                                   // Set the name for display purposes
139         decimals = _decimalUnits;                            // Amount of decimals for display purposes
140         symbol = _tokenSymbol;                               // Set the symbol for display purposes
141     }
142 
143     /* Approves and then calls the receiving contract */
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
145         allowed[msg.sender][_spender] = _value;
146         Approval(msg.sender, _spender, _value);
147 
148         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
149         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
150         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
151         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
152         return true;
153     }
154 
155     /* This notifies clients about the amount burnt */
156     event Burn(address indexed from, uint256 value);
157 
158     function burn(uint256 _value) returns (bool success) {
159         if (balances[msg.sender] < _value) throw;            // Check if the sender has enough
160         balances[msg.sender] -= _value;                      // Subtract from the sender
161         totalSupply -= _value;                                // Updates totalSupply
162         Burn(msg.sender, _value);
163         return true;
164     }
165 
166     function burnFrom(address _from, uint256 _value) returns (bool success) {
167         if (balances[_from] < _value) throw;                // Check if the sender has enough
168         if (_value > allowed[_from][msg.sender]) throw;    // Check allowance
169         balances[_from] -= _value;                          // Subtract from the sender
170         totalSupply -= _value;                               // Updates totalSupply
171         Burn(_from, _value);
172         return true;
173     }
174 }