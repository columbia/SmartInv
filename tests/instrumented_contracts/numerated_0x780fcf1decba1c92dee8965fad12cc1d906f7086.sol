1 pragma solidity ^0.4.16;
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
47         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
48         //Replace the if with this one instead.
49         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
50         require(balances[msg.sender] >= _value);
51         balances[msg.sender] -= _value;
52         balances[_to] += _value;
53         Transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         //same as above. Replace this line with the following if you want to protect against wrapping uints.
59         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60         require(balances[_from] >= _value);
61         require(allowed[_from][msg.sender] >= _value);
62         balances[_to] += _value;
63         balances[_from] -= _value;
64         allowed[_from][msg.sender] -= _value;
65         Transfer(_from, _to, _value);
66         return true;
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
89 contract SIGMA is StandardToken {
90 
91     function () {
92         throw;
93     }
94 
95     /* Public variables of the token */
96 
97     string public name;                   
98     uint8 public decimals;                
99     string public symbol;                 
100     string public version = 'H1.0';    
101 
102 
103     function SIGMA(
104         ) {
105         balances[msg.sender] = 1000000000000000000000000000;
106         totalSupply = 1000000000000000000000000000;
107         name = "SIGMA";
108         decimals = 18;
109         symbol = "SIG";
110         Transfer(address(0), msg.sender, balances[msg.sender]);
111     }
112 
113     /* Approves and then calls the receiving contract */
114     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
115         allowed[msg.sender][_spender] = _value;
116         Approval(msg.sender, _spender, _value);
117 
118         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
119         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
120         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
121         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
122         return true;
123     }
124 
125     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
126         allowed[msg.sender][_spender] += _addedValue;
127         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128         return true;
129     }
130 
131     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
132         uint256 oldValue = allowed[msg.sender][_spender];
133         if (_subtractedValue >= oldValue) {
134             allowed[msg.sender][_spender] = 0;
135         } else {
136             allowed[msg.sender][_spender] -= _subtractedValue;
137         }
138         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139         return true;
140     }
141 }