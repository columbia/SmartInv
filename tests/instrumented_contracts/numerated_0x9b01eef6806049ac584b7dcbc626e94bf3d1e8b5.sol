1 pragma solidity ^0.4.4;
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
38     
39 }
40 
41 
42 
43 contract StandardToken is Token {
44 
45     function transfer(address _to, uint256 _value) returns (bool success) {
46         //Default assumes totalSupply can't be over max (2^256 - 1).
47         if (balances[msg.sender] >= _value && _value > 0) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } else { return false; }
53     }
54 
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
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
84 
85 //name of contract
86 contract GhostGold is StandardToken {
87 
88     function () {
89         //if ether is sent to this address, send it back.
90         throw;
91     }
92 
93     /* Public variables of the token */
94 
95     string public name;                   //fancy name
96     uint8 public decimals;                //How many decimals to show
97     string public symbol;                 //An identifier
98     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
99 
100 //
101 //
102 
103 //function name must match the contract name above
104 
105     function GhostGold(
106         ) {
107         balances[msg.sender] = 1000000;               // Give the creator all initial tokens
108         totalSupply = 1000000;                        // Update total supply
109         name = "GhostGold";                           // Set the name for display purposes
110         decimals = 0;                                 // Amount of decimals for display purposes
111         symbol = "GXG";                               // Set the symbol for display purposes
112     }
113 
114     /* Approves and then calls the receiving contract */
115     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
116         allowed[msg.sender][_spender] = _value;
117         Approval(msg.sender, _spender, _value);
118 
119         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
120         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
121         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
122         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
123         return true;
124     }
125 }