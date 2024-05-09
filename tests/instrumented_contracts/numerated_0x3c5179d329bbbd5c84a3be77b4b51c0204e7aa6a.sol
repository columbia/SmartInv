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
41 contract StandardToken is Token {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44        
45         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
46         if (balances[msg.sender] >= _value && _value > 0) {
47             balances[msg.sender] -= _value;
48             balances[_to] += _value;
49             Transfer(msg.sender, _to, _value);
50             return true;
51         } else { return false; }
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
55                 //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
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
84 contract Rozium is StandardToken { 
85 
86     /* Public variables of the token */
87 
88     
89     string public name;                  	
90     uint8 public decimals;                            	
91     string public symbol;                 
92     string public version = 'H1.0'; 
93     uint256 public unitsOneEthCanBuy;    	
94     uint256 public totalEthInWei;          
95     address public fundsWallet; 		
96 
97    
98     function Rozium() {
99         balances[msg.sender] = 150000000000000000000000000;              
100         totalSupply = 150000000000000000000000000;                      
101         name = "Rozium";                                   
102         decimals = 18;                                               
103         symbol = "RZM";                                            
104         unitsOneEthCanBuy = 27000;                                      
105         fundsWallet = msg.sender;                                    
106     }
107 
108     function() payable{
109         totalEthInWei = totalEthInWei + msg.value;
110         uint256 amount = msg.value * unitsOneEthCanBuy;
111         if (balances[fundsWallet] < amount) {
112             return;
113         }
114 
115         balances[fundsWallet] = balances[fundsWallet] - amount;
116         balances[msg.sender] = balances[msg.sender] + amount;
117 
118         Transfer(fundsWallet, msg.sender, amount); 
119 
120         
121         fundsWallet.transfer(msg.value);                               
122     }
123 
124     /* Approves and then calls the receiving contract */
125     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
126         allowed[msg.sender][_spender] = _value;
127         Approval(msg.sender, _spender, _value);
128 
129 
130         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
131         return true;
132     }
133 }