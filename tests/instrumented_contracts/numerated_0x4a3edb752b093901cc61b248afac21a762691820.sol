1 pragma solidity ^0.4.20;
2 
3 contract Token {
4     /// @return total amount of tokens
5     function totalSupply() constant returns (uint256 supply) {}
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9     /// @notice send `_value` token to `_to` from `msg.sender`
10     /// @param _to The address of the recipient
11     /// @param _value The amount of token to be transferred
12     /// @return Whether the transfer was successful or not
13     function transfer(address _to, uint256 _value) returns (bool success) {}
14     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
15     /// @param _from The address of the sender
16     /// @param _to The address of the recipient
17     /// @param _value The amount of token to be transferred
18     /// @return Whether the transfer was successful or not
19     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
20     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
21     /// @param _spender The address of the account able to transfer the tokens
22     /// @param _value The amount of wei to be approved for transfer
23     /// @return Whether the approval was successful or not
24     function approve(address _spender, uint256 _value) returns (bool success) {}
25     /// @param _owner The address of the account owning tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @return Amount of remaining tokens allowed to spent
28     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
29     event Transfer(address indexed _from, address indexed _to, uint256 _value);
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 }
32 contract StandardToken is Token {
33     function transfer(address _to, uint256 _value) returns (bool success) {
34         //Default assumes totalSupply can't be over max (2^256 - 1).
35         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
36         //Replace the if with this one instead.
37         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
38         if (balances[msg.sender] >= _value && _value > 0) {
39             balances[msg.sender] -= _value;
40             balances[_to] += _value;
41             Transfer(msg.sender, _to, _value);
42             return true;
43         } else { return false; }
44     }
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
46         //same as above. Replace this line with the following if you want to protect against wrapping uints.
47         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
48         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
49             balances[_to] += _value;
50             balances[_from] -= _value;
51             allowed[_from][msg.sender] -= _value;
52             Transfer(_from, _to, _value);
53             return true;
54         } else { return false; }
55     }
56     function balanceOf(address _owner) constant returns (uint256 balance) {
57         return balances[_owner];
58     }
59     function approve(address _spender, uint256 _value) returns (bool success) {
60         allowed[msg.sender][_spender] = _value;
61         Approval(msg.sender, _spender, _value);
62         return true;
63     }
64     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
65       return allowed[_owner][_spender];
66     }
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69     uint256 public totalSupply;
70 }
71 //name this contract whatever you'd like
72 contract AutoBoxToken is StandardToken {
73     function () {
74         //if ether is sent to this address, send it back.
75         throw;
76     }
77      string public name;                  
78     uint8 public decimals;                
79     string public symbol;                 
80     string public version = 'H1.0';       
81 
82     function AutoBoxToken(
83         ) {
84         balances[msg.sender] = 4500000000;               // Give the creator all initial tokens (100000 for example)
85         totalSupply = 4500000000;                        // Update total supply (100000 for example)
86         name = 'AutoBox';                                   // Set the name for display purposes
87         decimals = 0;                                   // Amount of decimals for display purposes
88         symbol = 'AutoBox';                               // Set the symbol for display purposes
89     }
90     /* Approves and then calls the receiving contract */
91     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
95         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
96         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
97         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
98         return true;
99     }
100 }