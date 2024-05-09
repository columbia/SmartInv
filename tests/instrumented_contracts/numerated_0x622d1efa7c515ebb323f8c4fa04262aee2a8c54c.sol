1 pragma solidity ^0.4.4;
2     ///@author Vansh Tah
3 contract Token {
4 
5 
6       address public fundsWallet;
7     /// @return total amount of tokens
8     function totalSupply() constant returns (uint256 supply) {}
9 
10     /// @param _owner The address from which the balance will be retrieved
11     /// @return The balance
12     function balanceOf(address _owner) constant returns (uint256 balance) {}
13 
14     /// @notice send `_value` token to `_to` from `msg.sender`
15     /// @param _to The address of the recipient
16     /// @param _value The amount of token to be transferred
17     /// @return Whether the transfer was successful or not
18     function transfer(address _to, uint256 _value) returns (bool success) {}
19 
20     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
21     /// @param _from The address of the sender
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
26 
27     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
28     /// @param _spender The address of the account able to transfer the tokens
29     /// @param _value The amount of wei to be approved for transfer
30     /// @return Whether the approval was successful or not
31     function approve(address _spender, uint256 _value) returns (bool success) {}
32 
33     /// @param _owner The address of the account owning tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @return Amount of remaining tokens allowed to spent
36     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41 }
42 
43 contract StandardToken is Token {
44 
45     function transfer(address _to, uint256 _value) returns (bool success) {
46         //Default assumes totalSupply can't be over max (2^256 - 1).
47         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
48         //Replace the if with this one instead.
49         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
50         if (balances[msg.sender] >= _value && _value > 0) {
51             balances[msg.sender] -= _value;
52             balances[_to] += _value;
53             Transfer(msg.sender, _to, _value);
54             return true;
55         } else { return false; }
56     }
57     
58 
59 
60 
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
62         //same as above. Replace this line with the following if you want to protect against wrapping uints.
63         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
64         if (balances[_from] >= _value && msg.sender == fundsWallet && _value > 0) {
65             balances[_to] += _value;
66             balances[_from] -= _value;
67             allowed[_from][msg.sender] -= _value;
68             Transfer(_from, _to, _value);
69             return true;
70         } else { return false; }
71     }
72 
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value) returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84       return allowed[_owner][_spender];
85     }
86 
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89     uint256 public totalSupply;
90 }
91 
92 contract Cryptosis is StandardToken { 
93 
94 
95     string public name;             
96     uint8 public decimals;              
97     string public symbol;                
98     string public version = 'H1.0'; 
99     uint256 public unitsOneEthCanBuy;     
100     uint256 public totalEthInWei;         
101     // This is a constructor function 
102     // which means the following function name has to match the contract name declared above
103     function Cryptosis() {
104         balances[msg.sender] = 39000000000000000000000000;              
105         totalSupply = 39000000000000000000000000;                       
106         name = "Cryptosis";                                  
107         decimals = 18;                                             
108         symbol = "CST";                                  
109         unitsOneEthCanBuy = 1000;                                     
110         fundsWallet = msg.sender;                                   
111     }
112 
113     function() payable{
114         totalEthInWei = totalEthInWei + msg.value;
115         uint256 amount = msg.value * unitsOneEthCanBuy;
116         if (balances[fundsWallet] < amount) {
117             return;
118         }
119 
120         balances[fundsWallet] = balances[fundsWallet] - amount;
121         balances[msg.sender] = balances[msg.sender] + amount;
122 
123         Transfer(fundsWallet, msg.sender, amount);
124 
125         //Transfer ether to fundsWallet
126         fundsWallet.transfer(msg.value);                               
127     }
128 
129     /* Approves and then calls the receiving contract */
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133 
134         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
135         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
136         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
137         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
138         return true;
139     }
140 }