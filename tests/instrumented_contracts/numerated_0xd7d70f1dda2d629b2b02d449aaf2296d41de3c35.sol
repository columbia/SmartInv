1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.18;
4 
5 contract Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply = 100000000;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 /*
51 You should inherit from Bittle, for a token like you would want to
52 deploy in something like Mist, see HumanStandardToken.sol.
53 (This implements ONLY the standard functions and NOTHING else.
54 If you deploy this, you won't have anything useful.)
55 
56 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
57 .*/
58 
59 contract Bittle is Token {
60 
61     function transfer(address _to, uint256 _value) returns (bool success) {
62         //Default assumes totalSupply can't be over max (2^256 - 1).
63         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
64         //Replace the if with this one instead.
65         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
66         if (balances[msg.sender] >= _value && _value > 0) {
67             balances[msg.sender] -= _value;
68             balances[_to] += _value;
69             Transfer(msg.sender, _to, _value);
70             return true;
71         } else { return false; }
72     }
73 
74     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
75         //same as above. Replace this line with the following if you want to protect against wrapping uints.
76         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
77         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
78             balances[_to] += _value;
79             balances[_from] -= _value;
80             allowed[_from][msg.sender] -= _value;
81             Transfer(_from, _to, _value);
82             return true;
83         } else { return false; }
84     }
85 
86     function balanceOf(address _owner) constant returns (uint256 balance) {
87         return balances[_owner];
88     }
89 
90     function approve(address _spender, uint256 _value) returns (bool success) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
97       return allowed[_owner][_spender];
98     }
99 
100     mapping (address => uint256) balances;
101     mapping (address => mapping (address => uint256)) allowed;
102 }
103 
104 contract   HumanStandardToken is Bittle {
105 
106     function () {
107         //if ether is sent to this address, send it back.
108         throw;
109     }
110 
111     /* Public variables of the token */
112 
113     /*
114     NOTE:
115     The following variables are OPTIONAL vanities. One does not have to include them.
116     They allow one to customise the token contract & in no way influences the core functionality.
117     Some wallets/interfaces might not even bother to look at this information.
118     */
119     string public name;                   //fancy name: Bittle Solutions
120     uint8 public decimals = 18;           //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
121     string public symbol;                 //An identifier: BTT
122     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary version.
123 
124     function HumanStandardToken(
125         uint256 _initialAmount ,
126         string _tokenName ,
127         uint8 _decimalUnits,
128         string _tokenSymbol  
129         ) {
130         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
131         totalSupply = _initialAmount;                        // Update total supply
132         name = _tokenName;                                   // Set the name for display purposes
133         decimals = _decimalUnits;                            // Amount of decimals for display purposes
134         symbol = _tokenSymbol;                               // Set the symbol for display purposes
135     }
136 
137     /* Approves and then calls the receiving contract */
138     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
139         allowed[msg.sender][_spender] = _value;
140         Approval(msg.sender, _spender, _value);
141 
142         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
143         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
144         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
145         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
146         return true;
147     }
148 }