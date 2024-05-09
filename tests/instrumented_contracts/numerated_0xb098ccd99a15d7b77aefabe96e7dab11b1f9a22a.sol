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
45         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
46  
47             if (balances[msg.sender] >= _value && _value > 0) {
48                 balances[msg.sender] -= _value;
49                 balances[_to] += _value;
50                 Transfer(msg.sender, _to, _value);
51             return true;
52         } 
53         else
54          { return false; }
55 
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
59 
60         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
61         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
62             balances[_to] += _value;
63             balances[_from] -= _value;
64             allowed[_from][msg.sender] -= _value;
65             Transfer(_from, _to, _value);
66             return true;
67         } else { return false; }
68     }
69 
70     function balanceOf(address _owner) constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
81       return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86     uint256 public totalSupply;
87 }
88 
89     
90 
91 contract erc20FOBS is StandardToken {
92 
93     function () {
94         //if ether is sent to this address, send it back.
95         throw;
96     }
97 
98 
99     string public name;                   //
100     uint8 public decimals;                //
101     string public symbol;                 //
102     string public version = 't0.1';       //
103 
104     function erc20FOBS(
105         string _tokenName,
106         uint8 _decimalUnits,
107         string _tokenSymbol
108         ) {
109         balances[msg.sender] = 200000000000000000000000000;               // Give the creator all initial tokens
110         totalSupply = 200000000000000000000000000;                        // Update total supply
111         name = _tokenName;                                   // Set the name for display purposes
112         decimals = _decimalUnits;                            // Amount of decimals for display purposes
113         symbol = _tokenSymbol;                               // Set the symbol for display purposes
114     }
115 
116 
117     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
118         allowed[msg.sender][_spender] = _value;
119         Approval(msg.sender, _spender, _value);
120 
121         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
122         return true;
123     }
124 }