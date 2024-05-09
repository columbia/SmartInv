1 contract Token {
2     /// total amount of tokens
3     uint256 public totalSupply;
4 
5     /// @param _owner The address from which the balance will be retrieved
6     /// @return The balance
7     function balanceOf(address _owner) constant returns (uint256 balance);
8 
9     /// @notice send `_value` token to `_to` from `msg.sender`
10     /// @param _to The address of the recipient
11     /// @param _value The amount of token to be transferred
12     /// @return Whether the transfer was successful or not
13     function transfer(address _to, uint256 _value) returns (bool success);
14 
15     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
16     /// @param _from The address of the sender
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
21 
22     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
23     /// @param _spender The address of the account able to transfer the tokens
24     /// @param _value The amount of wei to be approved for transfer
25     /// @return Whether the approval was successful or not
26     function approve(address _spender, uint256 _value) returns (bool success);
27 
28     /// @param _owner The address of the account owning tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @return Amount of remaining tokens allowed to spent
31     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
32 
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 contract StandardToken is Token {
38 
39     function transfer(address _to, uint256 _value) returns (bool success) {
40         //Default assumes totalSupply can't be over max (2^256 - 1).
41         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
42         //Replace the if with this one instead.
43         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
44         if (balances[msg.sender] >= _value && _value > 0) {
45             balances[msg.sender] -= _value;
46             balances[_to] += _value;
47             Transfer(msg.sender, _to, _value);
48             return true;
49         } else { return false; }
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53         //same as above. Replace this line with the following if you want to protect against wrapping uints.
54         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
55         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
56             balances[_to] += _value;
57             balances[_from] -= _value;
58             allowed[_from][msg.sender] -= _value;
59             Transfer(_from, _to, _value);
60             return true;
61         } else { return false; }
62     }
63 
64     function balanceOf(address _owner) constant returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint256 _value) returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
75       return allowed[_owner][_spender];
76     }
77 
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;
80 }
81 
82 contract SPPSeriesB is StandardToken {
83 
84     function () {
85         //if ether is sent to this address, send it back.
86         throw;
87     }
88 
89     string public name;                   //fancy name: eg Simon Bucks
90     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
91     string public symbol;                 //An identifier: eg SBX
92     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
93 
94     function SPPSeriesB(
95         uint256 _initialAmount,
96         string _tokenName,
97         uint8 _decimalUnits,
98         string _tokenSymbol
99         ) {
100         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
101         totalSupply = _initialAmount;                        // Update total supply
102         name = _tokenName;                                   // Set the name for display purposes
103         decimals = _decimalUnits;                            // Amount of decimals for display purposes
104         symbol = _tokenSymbol;                               // Set the symbol for display purposes
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