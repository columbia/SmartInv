1 pragma solidity ^0.4.8;
2 
3 contract Token {
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
48 contract StandardToken is Token {
49 
50     function transfer(address _to, uint256 _value) returns (bool success) {
51         //Default assumes totalSupply can't be over max (2^256 - 1).
52         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
53         //Replace the if with this one instead.
54         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
55         require(balances[msg.sender] >= _value);
56         balances[msg.sender] -= _value;
57         balances[_to] += _value;
58         Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         //same as above. Replace this line with the following if you want to protect against wrapping uints.
64         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
65         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
66         balances[_to] += _value;
67         balances[_from] -= _value;
68         allowed[_from][msg.sender] -= _value;
69         Transfer(_from, _to, _value);
70         return true;
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
90 contract HumanStandardToken is StandardToken {
91 
92     /* Public variables of the token */
93 
94     /*
95     NOTE:
96     The following variables are OPTIONAL vanities. One does not have to include them.
97     They allow one to customise the token contract & in no way influences the core functionality.
98     Some wallets/interfaces might not even bother to look at this information.
99     */
100     string public name;                   //fancy name: eg Simon Bucks
101     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
102     string public symbol;                 //An identifier: eg SBX
103     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
104 
105     function HumanStandardToken(
106         uint256 _initialAmount,
107         string _tokenName,
108         uint8 _decimalUnits,
109         string _tokenSymbol
110         ) {
111         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
112         totalSupply = _initialAmount;                        // Update total supply
113         name = _tokenName;                                   // Set the name for display purposes
114         decimals = _decimalUnits;                            // Amount of decimals for display purposes
115         symbol = _tokenSymbol;                               // Set the symbol for display purposes
116     }
117 
118     /* Approves and then calls the receiving contract */
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122 
123         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
124         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
125         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
126         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
127         return true;
128     }
129 }