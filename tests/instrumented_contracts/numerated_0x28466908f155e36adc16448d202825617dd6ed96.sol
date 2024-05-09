1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// This function will return the total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// Calling balanceOf and passing in an address with paramater _owner will return the token balance. 
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11     /// @notice send `_value` token to `_to` from `msg.sender`
12     /// @param _to The address of the recipient
13     /// @param _value The amount of token to be transferred
14     /// @return Whether the transfer was successful or not
15     function transfer(address _to, uint256 _value) returns (bool success) {}
16 
17     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
18     /// @param _from The address of the sender
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
23 
24     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
25     /// @param _spender The address of the account able to transfer the tokens
26     /// @param _value The amount of wei to be approved for transfer
27     /// @return Whether the approval was successful or not
28     function approve(address _spender, uint256 _value) returns (bool success) {}
29 
30     /// @param _owner The address of the account owning tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @return Amount of remaining tokens allowed to spent
33     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37     
38 }
39 
40 contract StandardToken is Token {
41 
42     function transfer(address _to, uint256 _value) returns (bool success) {
43         //Default assumes totalSupply can't be over max (2^256 - 1).
44         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
45         //Replace the if with this one instead.
46         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
47         if (balances[msg.sender] >= _value && _value > 0) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } else { return false; }
53     }
54 
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56         //same as above. Replace this line with the following if you want to protect against wrapping uints.
57         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
58         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
59             balances[_to] += _value;
60             balances[_from] -= _value;
61             allowed[_from][msg.sender] -= _value;
62             Transfer(_from, _to, _value);
63             return true;
64         } else { return false; }
65     }
66 
67     function balanceOf(address _owner) constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71     function approve(address _spender, uint256 _value) returns (bool success) {
72         allowed[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         return true;
75     }
76 
77     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
78       return allowed[_owner][_spender];
79     }
80 
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;
83     uint256 public totalSupply;
84 }
85 
86 
87 //name this contract whatever you'd like
88 contract FAIZACOIN is StandardToken {
89 
90     function () {
91         //if ether is sent to this address, send it back.
92         throw;
93     }
94 
95     /* Public variables of the token */
96 
97     /*
98     NOTE:
99     The following variables are OPTIONAL vanities. One does not have to include them.
100     They allow one to customise the token contract & in no way influences the core functionality.
101     Some wallets/interfaces might not even bother to look at this information.
102     */
103     string public name = 'FAIZACOIN';                   //fancy name: eg Simon Bucks
104     uint8 public decimals = 0;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
105     string public symbol = 'FZC';                 //An identifier: eg SBX
106     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
107 
108 //
109 // CHANGE THESE VALUES FOR YOUR TOKEN
110 //
111 
112 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
113 
114     function FAIZACOIN(
115         ) {
116         balances[msg.sender] = 100000000;           // Give the creator all initial tokens (100000 for example)
117         totalSupply = 100000000;                        // Update total supply (100000 for example)
118         name = "FAIZA Coin";                            // Set the name for display purposes
119         decimals = 0;                                 // Amount of decimals for display purposes
120         symbol = "FZC";                               // Set the symbol for display purposes
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
131         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
132         return true;
133     }
134 }