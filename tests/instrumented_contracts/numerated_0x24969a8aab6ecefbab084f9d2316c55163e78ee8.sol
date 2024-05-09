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
36 }
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
80     uint256 public totalSupply;
81 }
82 
83 contract HumanStandardToken is StandardToken {
84 
85     function () {
86         //if ether is sent to this address, send it back.
87         throw;
88     }
89 
90     /* Public variables of the token */
91 
92     /*
93     NOTE:
94     The following variables are OPTIONAL vanities. One does not have to include them.
95     They allow one to customise the token contract & in no way influences the core functionality.
96     Some wallets/interfaces might not even bother to look at this information.
97     */
98     string public name;                   //fancy name: eg Simon Bucks
99     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
100     string public symbol;                 //An identifier: eg SBX
101     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
102 
103     function HumanStandardToken(
104         ) {
105         balances[msg.sender] = 500e6 ether;               // Give the creator all initial tokens
106         totalSupply = 300e6 ether;                        // Update total supply
107         name = 	"easycoin temp";                                   // Set the name for display purposes
108         decimals = 18;                            // Amount of decimals for display purposes
109         symbol = "ESCT";                               // Set the symbol for display purposes
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