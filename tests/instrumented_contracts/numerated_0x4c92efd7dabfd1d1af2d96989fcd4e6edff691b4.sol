1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     /// @return total amount of tokens
5     function totalSupply() public constant returns (uint256) {}
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
39 contract StandardToken is Token {
40     function transfer(address _to, uint256 _value) returns (bool success) {
41         //Default assumes totalSupply can't be over max (2^256 - 1).
42         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
43         //Replace the if with this one instead.
44         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
45         if (balances[msg.sender] >= _value && _value > 0) {
46             balances[msg.sender] -= _value;
47             balances[_to] += _value;
48             Transfer(msg.sender, _to, _value);
49             return true;
50         } else { return false; }
51     }
52 
53     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
54         //same as above. Replace this line with the following if you want to protect against wrapping uints.
55         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
56         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
57             balances[_to] += _value;
58             balances[_from] -= _value;
59             allowed[_from][msg.sender] -= _value;
60             Transfer(_from, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function balanceOf(address _owner) constant returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69     function approve(address _spender, uint256 _value) returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
76       return allowed[_owner][_spender];
77     }
78 
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;
81     uint256 public totalSupply;
82 }
83 
84 contract HeatDeathToken is StandardToken {
85     function () {
86         //if ether is sent to this address, send it back.
87         throw;
88     }
89 
90     string public name;
91     uint8 public decimals;
92     string public symbol;
93     string public version = 'H1.0';
94 
95     function HeatDeathToken() {
96         balances[msg.sender] = 1000;               // Give the creator all initial tokens (100000 for example)
97         totalSupply = 1000;                        // Update total supply (100000 for example)
98         name = "Heat Death Coin";                                   // Set the name for display purposes
99         decimals = 2;                            // Amount of decimals for display purposes
100         symbol = "DETH";                               // Set the symbol for display purposes
101     }
102 
103     /* Approves and then calls the receiving contract */
104     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
105         allowed[msg.sender][_spender] = _value;
106         Approval(msg.sender, _spender, _value);
107 
108         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
109         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
110         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
111         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
112         return true;
113     }
114 }