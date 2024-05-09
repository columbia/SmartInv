1 pragma solidity ^0.4.8;
2 
3 contract ERC20_Interface {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) constant returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 /*
49 You should inherit from StandardToken or, for a token like you would want to
50 deploy in something like Mist, see HumanStandardToken.sol.
51 (This implements ONLY the standard functions and NOTHING else.
52 If you deploy this, you won't have anything useful.)
53 
54 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
55 .*/
56 
57 contract StandardToken is ERC20_Interface {
58 
59     function transfer(address _to, uint256 _value) returns (bool success) {
60         //Default assumes totalSupply can't be over max (2^256 - 1).
61         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
62         //Replace the if with this one instead.
63         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
64         if (balances[msg.sender] >= _value) {
65             balances[msg.sender] -= _value;
66             balances[_to] += _value;
67             Transfer(msg.sender, _to, _value);
68             return true;
69         } else { return false; }
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
73         //same as above. Replace this line with the following if you want to protect against wrapping uints.
74         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
75         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
76             balances[_to] += _value;
77             balances[_from] -= _value;
78             allowed[_from][msg.sender] -= _value;
79             Transfer(_from, _to, _value);
80             return true;
81         } else { return false; }
82     }
83 
84     function balanceOf(address _owner) constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
95       return allowed[_owner][_spender];
96     }
97 
98     mapping (address => uint256) balances;
99     mapping (address => mapping (address => uint256)) allowed;
100 }
101 
102 contract R_Token is StandardToken {
103 
104     function () {
105         //if ether is sent to this address, send it back.
106         revert();
107     }
108 
109     /* Public variables of the token */
110 
111     /*
112     The following variables are OPTIONAL vanities. One does not have to include them.
113     They allow one to customise the token contract & in no way influences the core functionality.
114     Some wallets/interfaces might not even bother to look at this information.
115     */
116     string public name;       //fancy name: eg Simon Bucks
117     uint8 public decimals;    //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
118     string public symbol;     //An identifier: eg SBX
119     string public version;    //human 0.1 standard. Just an arbitrary versioning scheme.
120 
121     function R_Token(
122         uint256 _initialAmount,
123         string _tokenName,
124         uint8 _decimalUnits,
125         string _tokenSymbol
126         ) public {
127         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
128         totalSupply = _initialAmount;                        // Update total supply
129         name = _tokenName;                                   // Set the name for display purposes
130         decimals = _decimalUnits;                            // Amount of decimals for display purposes
131         symbol = _tokenSymbol;                               // Set the symbol for display purposes
132     }
133 
134     /* Approves and then calls the receiving contract */
135     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
136         allowed[msg.sender][_spender] = _value;
137         Approval(msg.sender, _spender, _value);
138 
139         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
140         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
141         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
142         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
143         return true;
144     }
145 }