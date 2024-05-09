1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.8;
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
16     uint256 public totalSupply;
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
50 contract StandardToken is Token {
51 
52     function transfer(address _to, uint256 _value) returns (bool success) {
53         //Default assumes totalSupply can't be over max (2^256 - 1).
54         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
55         //Replace the if with this one instead.
56         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
57         require(balances[msg.sender] >= _value);
58         balances[msg.sender] -= _value;
59         balances[_to] += _value;
60         Transfer(msg.sender, _to, _value);
61         return true;
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
65         //same as above. Replace this line with the following if you want to protect against wrapping uints.
66         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
67         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
68         balances[_to] += _value;
69         balances[_from] -= _value;
70         allowed[_from][msg.sender] -= _value;
71         Transfer(_from, _to, _value);
72         return true;
73     }
74 
75     function balanceOf(address _owner) constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88 
89     mapping (address => uint256) balances;
90     mapping (address => mapping (address => uint256)) allowed;
91 }
92 
93 
94 
95 contract IssueSSSStandardToken is StandardToken {
96 
97     /* Public variables of the token */
98 
99     /*
100     NOTE:
101     The following variables are OPTIONAL vanities. One does not have to include them.
102     They allow one to customise the token contract & in no way influences the core functionality.
103     Some wallets/interfaces might not even bother to look at this information.
104     */
105     string public name;                   //fancy name: eg Simon Bucks
106     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
107     string public symbol;                 //An identifier: eg SBX
108     string public version = 'S0.1';       //IssueSSS 0.1 standard. Just an arbitrary versioning scheme.
109 
110     function IssueSSSStandardToken(
111         uint256 _initialAmount,
112         string _tokenName,
113         uint8 _decimalUnits,
114         string _tokenSymbol
115         ) {
116         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
117         totalSupply = _initialAmount;                        // Update total supply
118         name = _tokenName;                                   // Set the name for display purposes
119         decimals = _decimalUnits;                            // Amount of decimals for display purposes
120         symbol = _tokenSymbol;                               // Set the symbol for display purposes
121     }
122 
123     /* Approves and then calls the receiving contract */
124     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
125         allowed[msg.sender][_spender] = _value;
126         Approval(msg.sender, _spender, _value);
127 
128         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
129         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
130         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
131         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
132         return true;
133     }
134 }