1 contract Token {
2 
3     /// @return total amount of tokens
4     function totalSupply() constant returns (uint256 supply) {}
5 
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not
14     function transfer(address _to, uint256 _value) returns (bool success) {}
15 
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokens
25     /// @param _value The amount of wei to be approved for transfer
26     /// @return Whether the approval was successful or not
27     function approve(address _spender, uint256 _value) returns (bool success) {}
28 
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 
37 }
38 
39 
40 
41 contract StandardToken is Token {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44 
45  
46             if (balances[msg.sender] >= _value && _value > 0) {
47                 balances[msg.sender] -= _value;
48                 balances[_to] += _value;
49                 Transfer(msg.sender, _to, _value);
50             return true;
51         } 
52         else
53          { return false; }
54 
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58 
59 
60         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
61             balances[_to] += _value;
62             balances[_from] -= _value;
63             allowed[_from][msg.sender] -= _value;
64             Transfer(_from, _to, _value);
65             return true;
66         } else { return false; }
67     }
68 
69     function balanceOf(address _owner) constant returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint256 _value) returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
80       return allowed[_owner][_spender];
81     }
82 
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;
85     uint256 public totalSupply;
86 }
87 
88 
89 
90 contract erc20MRL is StandardToken {
91 
92     function () {
93         //if ether is sent to this address, send it back.
94         throw;
95     }
96 
97 
98     string public name;                   //
99     uint8 public decimals;                //
100     string public symbol;                 //
101     string public version = 'x0.01';       //
102 
103     function erc20MRL(
104         uint8 _decimalUnits 
105         ) {
106         balances[msg.sender] = 1000000000000000000000000;               // Give the creator all initial tokens
107         totalSupply = 1000000000000000000000000;                        // Update total supply
108         name = "MIRACLE TOKEN";                                   // Set the name for display purposes
109         decimals = _decimalUnits;                            // Amount of decimals for display purposes
110         symbol = "MRL";                               // Set the symbol for display purposes
111     }
112 
113 
114     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
115         allowed[msg.sender][_spender] = _value;
116         Approval(msg.sender, _spender, _value);
117 
118         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
119         return true;
120     }
121 }