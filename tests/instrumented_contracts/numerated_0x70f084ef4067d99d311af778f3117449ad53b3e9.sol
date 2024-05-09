1 pragma solidity ^0.4.20;
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
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56         //same as above. Replace this line with the following if you want to protect against wrapping uints.
57         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
58       
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
71     function approve(address _spender, uint256 _value) returns (bool success) {
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
86 contract LAMP is StandardToken { // CHANGE THIS. Update the contract name.
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
98     string public symbol;                 // An identifier: eg SBX, XPR etc..
99     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
100     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
101     address public fundsWallet;           // Where should the raised ETH go?
102 
103     // This is a constructor function 
104     // which means the following function name has to match the contract name declared above
105     function LAMP() {
106         balances[msg.sender] = 10000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
107         totalSupply = 10000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
108         name = "LAMP";                                   // Set the name for display purposes (CHANGE THIS)
109         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
110         symbol = "LAMP";                                             // Set the symbol for display purposes (CHANGE THIS)
111         unitsOneEthCanBuy = 2300;                                      // Set the price of your token for the ICO (CHANGE THIS)
112         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
113     }
114 
115     function() payable{
116         totalEthInWei = totalEthInWei + msg.value;
117         uint256 amount = msg.value * unitsOneEthCanBuy;
118         require(balances[fundsWallet] >= amount);
119 
120         balances[fundsWallet] = balances[fundsWallet] - amount;
121         balances[msg.sender] = balances[msg.sender] + amount;
122 
123         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
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