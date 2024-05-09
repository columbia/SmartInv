1 pragma solidity ^0.4.19;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
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
86 contract AAA is StandardToken {
87 
88     function () {
89         //if ether is sent to this address, send it back.
90         throw;
91     }
92 
93     /*
94     NOTE:
95     The following variables are OPTIONAL vanities. One does not have to include them.
96     They allow one to customise the token contract & in no way influences the core functionality.
97     Some wallets/interfaces might not even bother to look at this information.
98     */
99     string public name;                   //token name
100     uint8 public decimals;                //Decimals
101     string public symbol;                 //Identifier of token
102     string public version = 'A1.0';       //Version of AAA
103 
104     function AAA() {
105         balances[msg.sender] = 210000000000000000000;  // Give the creator all initial tokens
106         totalSupply = 210000000000000000000;  // Total supply
107         name = 'App Advertising Alliance';  // Set the name for display purposes
108         decimals = 10;   // Amount of decimals for display purposes
109         symbol = 'AAA';  // Set the symbol for display purposes
110     }
111 
112     /* Approves and then calls the receiving contract */
113     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
114         allowed[msg.sender][_spender] = _value;
115         Approval(msg.sender, _spender, _value);
116 
117         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
118         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
119         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
120         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
121         return true;
122     }
123 }