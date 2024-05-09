1 /*
2 You should inherit from StandardToken or, for a token like you would want to
3 deploy in something like Mist, see HumanStandardToken.sol.
4 (This implements ONLY the standard functions and NOTHING else.
5 If you deploy this, you won't have anything useful.)
6 
7 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
8 
9 Update: Working with Solidity 0.4.20> added public keyword Friday 8th December 2017 ~tom
10 .*/
11 pragma solidity ^0.4.9;
12 
13 
14 contract Token {
15     /* This is a slight change to the ERC20 base standard.
16     function totalSupply() constant returns (uint256 supply);
17     is replaced with:
18     uint256 public totalSupply;
19     This automatically creates a getter function for the totalSupply.
20     This is moved to the base contract since public getter functions are not
21     currently recognised as an implementation of the matching abstract
22     function by the compiler.
23     */
24     /// total amount of tokens
25     uint256 public totalSupply;
26 
27     /// @param _owner The address from which the balance will be retrieved
28     /// @return The balance
29     function balanceOf(address _owner) public constant returns (uint256 balance);
30 
31     /// @notice send `_value` token to `_to` from `msg.sender`
32     /// @param _to The address of the recipient
33     /// @param _value The amount of token to be transferred
34     /// @return Whether the transfer was successful or not
35     function transfer(address _to, uint256 _value) public returns (bool success);
36 
37     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
38     /// @param _from The address of the sender
39     /// @param _to The address of the recipient
40     /// @param _value The amount of token to be transferred
41     /// @return Whether the transfer was successful or not
42     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
43 
44     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @param _value The amount of tokens to be approved for transfer
47     /// @return Whether the approval was successful or not
48     function approve(address _spender, uint256 _value) public returns (bool success);
49 
50     /// @param _owner The address of the account owning tokens
51     /// @param _spender The address of the account able to transfer the tokens
52     /// @return Amount of remaining tokens allowed to spent
53     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
54 
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57 }
58 
59 contract StandardToken is Token {
60 
61     function transfer(address _to, uint256 _value) public returns (bool success) {
62         //Default assumes totalSupply can't be over max (2^256 - 1).
63         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
64         //Replace the if with this one instead.
65         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
66         if (balances[msg.sender] >= _value) {
67             balances[msg.sender] -= _value;
68             balances[_to] += _value;
69             Transfer(msg.sender, _to, _value);
70             return true;
71         } else { return false; }
72     }
73 
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75         //same as above. Replace this line with the following if you want to protect against wrapping uints.
76         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
77         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
78             balances[_to] += _value;
79             balances[_from] -= _value;
80             allowed[_from][msg.sender] -= _value;
81             Transfer(_from, _to, _value);
82             return true;
83         } else { return false; }
84     }
85 
86     function balanceOf(address _owner) public constant returns (uint256 balance) {
87         return balances[_owner];
88     }
89 
90     function approve(address _spender, uint256 _value) public returns (bool success) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
97       return allowed[_owner][_spender];
98     }
99 
100     mapping (address => uint256) balances;
101     mapping (address => mapping (address => uint256)) allowed;
102 }
103 
104 
105 contract EVR is StandardToken {
106 
107     function () public {
108         //if ether is sent to this address, send it back.
109         revert();
110     }
111 
112     /* Public variables of the token */
113 
114     /*
115     NOTE:
116     The following variables are OPTIONAL vanities. One does not have to include them.
117     They allow one to customise the token contract & in no way influences the core functionality.
118     Some wallets/interfaces might not even bother to look at this information.
119     */
120     string public name;                   //fancy name: eg Simon Bucks
121     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
122     string public symbol;                 //An identifier: eg SBX
123     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
124 
125     function EVR(
126         uint256 _initialAmount,
127         string _tokenName,
128         uint8 _decimalUnits,
129         string _tokenSymbol
130         ) public {
131         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
132         totalSupply = _initialAmount;                        // Update total supply
133         name = _tokenName;                                   // Set the name for display purposes
134         decimals = _decimalUnits;                            // Amount of decimals for display purposes
135         symbol = _tokenSymbol;                               // Set the symbol for display purposes
136     }
137 
138     /* Approves and then calls the receiving contract */
139     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
140         allowed[msg.sender][_spender] = _value;
141         Approval(msg.sender, _spender, _value);
142 
143         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
144         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
145         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
146         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
147         return true;
148     }
149 }