1 pragma solidity ^0.4.16;
2 interface  tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
3 
4 contract Token {
5 
6     /// @return total amount of tokens
7     function totalSupply() constant returns (uint256 supply) {}
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) constant returns (uint256 balance) {}
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) returns (bool success) {}
18 
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
25 
26     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of wei to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) returns (bool success) {}
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40 }
41 
42 contract StandardToken is Token {
43 
44     function transfer(address _to, uint256 _value) public returns (bool success) {
45         //Default assumes totalSupply can't be over max (2^256 - 1).
46         
47         if (balances[msg.sender] >= _value && _value > 0) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } else { return false; }
53     }
54 
55     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
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
71     function approve(address _spender, uint256 _value) public returns (bool success)  {
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
86 contract EventRabbtToken is StandardToken { 
87 
88     /* Public variables of the token */
89 
90     /*
91     NOTE:
92     The following variables are OPTIONAL vanities. One does not have to include them.
93     They allow one to customise the token contract & in no way influences the core functionality.
94     Some wallets/interfaces might not even bother to look at this information.
95     */
96     string public name;                   // Token Name
97     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
98     string public symbol;                 
99     string public version = 'E1.0'; 
100     
101     // This is a constructor function 
102     // which means the following function name has to match the contract name declared above
103     function EventRabbtToken() public {
104         balances[msg.sender] = 1000000000000000000000000000;              
105         totalSupply = 1000000000000000000000000000;                        
106         name = "EventRabbtToken";                                   
107         decimals = 18;                                              
108         symbol = "ERT";                                             
109         
110         
111     }
112 
113   
114         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
115         public 
116         returns (bool success) {
117         tokenRecipient spender = tokenRecipient(_spender);
118         if (approve(_spender, _value)) {
119             spender.receiveApproval(msg.sender, _value, this, _extraData);
120             return true;
121         }
122     }
123 
124    
125 }