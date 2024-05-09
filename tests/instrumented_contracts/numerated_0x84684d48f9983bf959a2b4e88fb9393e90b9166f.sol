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
44         //Default assumes totalSupply can't be over max (2^256 - 1).
45         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
46         //Replace the if with this one instead.
47         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
48         if (balances[msg.sender] >= _value && _value > 0) {
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             Transfer(msg.sender, _to, _value);
52             return true;
53         } else { return false; }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         //same as above. Replace this line with the following if you want to protect against wrapping uints.
58         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84     uint256 public totalSupply;
85 }
86 
87 contract PiecesofEight is StandardToken {
88 
89     /* Public variables of the token */
90     
91     string public name;                   
92     uint8 public decimals;                
93     string public symbol;                 
94     string public version = 'H1.0'; 
95     uint256 public EthperPoe;     
96     uint256 public totalEthInWei;          
97     address public fundsWallet;           
98 
99     // This is a constructor function 
100     // which means the following function name has to match the contract name declared above
101     function PiecesofEight() {
102         balances[msg.sender] = 90000000000000000;               
103         totalSupply = 90000000000000000;                        
104         name = "Pieces of Eight";                                        
105         decimals = 16;                                              
106         symbol = "PSOE";                                             
107         EthperPoe = 1;                                     
108         fundsWallet = msg.sender;                                    
109     }
110 
111     function() payable{
112         totalEthInWei = totalEthInWei + msg.value;
113         uint256 amount = msg.value * EthperPoe;
114         if (balances[fundsWallet] < amount) {
115             return;
116         }
117 
118         balances[fundsWallet] = balances[fundsWallet] - amount;
119         balances[msg.sender] = balances[msg.sender] + amount;
120 
121         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
122 
123         //Transfer ether to fundsWallet
124         fundsWallet.transfer(msg.value);                               
125     }
126 
127     /* Approves and then calls the receiving contract */
128     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
129         allowed[msg.sender][_spender] = _value;
130         Approval(msg.sender, _spender, _value);
131 
132         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
133         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
134         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
135         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
136         return true;
137     }
138 }