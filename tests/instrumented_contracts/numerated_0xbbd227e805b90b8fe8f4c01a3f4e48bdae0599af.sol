1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     /// @return total amount of tokens
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     /// @param _owner The address from which the balance will be retrieved
8     /// @return The balance
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
37 }
38 
39 
40 
41 contract StandardToken is Token {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         //Default assumes totalSupply can't be over max (2^256 - 1).
45         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
46         if (balances[msg.sender] >= _value && _value > 0) {
47             balances[msg.sender] -= _value;
48             balances[_to] += _value;
49             Transfer(msg.sender, _to, _value);
50             return true;
51         } else { return false; }
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
55         //same as above. Replace this line with the following if you want to protect against wrapping uints.
56         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
58             balances[_to] += _value;
59             balances[_from] -= _value;
60             allowed[_from][msg.sender] -= _value;
61             Transfer(_from, _to, _value);
62             return true;
63         } else { return false; }
64     }
65 
66     function balanceOf(address _owner) constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70     function approve(address _spender, uint256 _value) returns (bool success) {
71         allowed[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
77         return allowed[_owner][_spender];
78     }
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;
82     uint256 public totalSupply;
83 }
84 
85 contract PhoneumToken is StandardToken {
86 
87     function () {
88         //if ether is sent to this address, send it back.
89         throw;
90     }
91 
92     /* Public variables of the token */
93     string public name;                   
94     uint8 public decimals;                
95     string public symbol;                 
96     string public version = 'H1.0';
97 
98     function PhoneumToken(
99         ) {
100         balances[msg.sender] = 200000000000;               
101         totalSupply = 200000000000;                        
102         name = "Phoneum Token";                                  
103         decimals = 2;                            
104         symbol = "PHT";                               
105     }
106 
107     /* Approves and then calls the receiving contract */
108     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
109         allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111 
112         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
113         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
114         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
115         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
116         return true;
117     }
118 }