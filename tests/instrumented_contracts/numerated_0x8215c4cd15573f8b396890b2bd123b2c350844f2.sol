1 pragma solidity ^0.4.8;
2 contract Token {
3 
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
49     function transfer(address _to, uint256 _value) returns (bool success) {
50        
51         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
52         if (balances[msg.sender] >= _value && _value > 0) {
53             balances[msg.sender] -= _value;
54             balances[_to] += _value;
55             Transfer(msg.sender, _to, _value);
56             return true;
57         } else { return false; }
58         
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) returns 
62     (bool success) {
63         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
64         // _value && balances[_to] + _value > balances[_to]);
65         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
66             balances[_to] += _value;
67             balances[_from] -= _value;
68             allowed[_from][msg.sender] -= _value;
69             Transfer(_from, _to, _value);
70             return true;
71         } else { return false; }
72     }
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77 
78     function approve(address _spender, uint256 _value) returns (bool success)   
79     {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85 
86     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
87         return allowed[_owner][_spender];
88     }
89     mapping (address => uint256) balances;
90     mapping (address => mapping (address => uint256)) allowed;
91 }
92 
93 contract ThanosXToken is StandardToken { 
94     
95     
96     function () {
97         //if ether is sent to this address, send it back.
98         throw;
99     }
100 
101         /* Public variables of the token */
102     /*
103     NOTE:
104     The following variables are OPTIONAL vanities. One does not have to include them.
105     They allow one to customise the token contract & in no way influences the core functionality.
106     Some wallets/interfaces might not even bother to look at this information.
107     */
108     string public   name;                   //fancy name: eg ThanosX Token
109     uint8 public    decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 TNSX = 980 base units. It's like comparing 1 wei to 1 ether.
110     string public   symbol;                 //An identifier: eg TNSX
111     string public   version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme. 
112 
113     function ThanosXToken(
114         uint256 _initialAmount,
115         string _tokenName,
116         uint8 _decimalUnits,
117         string _tokenSymbol
118         ) {
119         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);
120         balances[msg.sender] = totalSupply;                         // Give the creator all initial tokens
121         name = _tokenName;                                          // Set the name for display purposes
122         decimals = _decimalUnits;                                   // Amount of decimals for display purposes
123         symbol = _tokenSymbol;                                      // Set the symbol for display purposes
124     }
125 
126     /* Approves and then calls the receiving contract */
127     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
128         allowed[msg.sender][_spender] = _value;
129         Approval(msg.sender, _spender, _value);
130         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
131         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
132         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
133         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
134         return true;
135     }
136 
137 }