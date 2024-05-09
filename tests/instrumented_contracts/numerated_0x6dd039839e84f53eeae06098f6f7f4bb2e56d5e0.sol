1 pragma solidity ^0.4.4;
2 
3 // IDENetwork
4 // IDEN
5 // 
6 
7 contract Token {
8 
9     /// @return total amount of tokens
10     function totalSupply() constant returns (uint256 supply) {}
11 
12     /// @param _owner The address from which the balance will be retrieved
13     /// @return The balance
14     function balanceOf(address _owner) constant returns (uint256 balance) {}
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transfer(address _to, uint256 _value) returns (bool success) {}
21 
22     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
23     /// @param _from The address of the sender
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
28 
29     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @param _value The amount of wei to be approved for transfer
32     /// @return Whether the approval was successful or not
33     function approve(address _spender, uint256 _value) returns (bool success) {}
34 
35     /// @param _owner The address of the account owning tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @return Amount of remaining tokens allowed to spent
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
39 
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 
43 }
44 
45 contract StandardToken is Token {
46 
47     function transfer(address _to, uint256 _value) returns (bool success) {
48         //Default assumes totalSupply can't be over max (2^256 - 1).
49         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
50         //Replace the if with this one instead.
51         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
52         if (balances[msg.sender] >= _value && _value > 0) {
53             balances[msg.sender] -= _value;
54             balances[_to] += _value;
55             Transfer(msg.sender, _to, _value);
56             return true;
57         } else { return false; }
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
61         //same as above. Replace this line with the following if you want to protect against wrapping uints.
62         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
63         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
64             balances[_to] += _value;
65             balances[_from] -= _value;
66             allowed[_from][msg.sender] -= _value;
67             Transfer(_from, _to, _value);
68             return true;
69         } else { return false; }
70     }
71 
72     function balanceOf(address _owner) constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender, uint256 _value) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83       return allowed[_owner][_spender];
84     }
85 
86     mapping (address => uint256) balances;
87     mapping (address => mapping (address => uint256)) allowed;
88     uint256 public totalSupply;
89 }
90 
91 contract IDENetwork is StandardToken { // CHANGE THIS. Update the contract name.
92     /* Public variables of the token */
93 
94     /*
95     NOTE:
96     The following variables are OPTIONAL vanities. One does not have to include them.
97     They allow one to customise the token contract & in no way influences the core functionality.
98     Some wallets/interfaces might not even bother to look at this information.
99     */
100     string public name;                   // Token Name
101     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
102     string public symbol;                 // An identifier: eg SBX, XPR etc..
103     string public version = 'H1.0'; 
104     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
105     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
106     address public fundsWallet;           // Where should the raised ETH go?
107 
108     // This is a constructor function 
109     // which means the following function name has to match the contract name declared above
110     function IDENetwork() {
111         balances[msg.sender] = 500000000000000000000000000;               // Give the creator all initial tokens. This is set to 150000000000000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 1000000000000. (10000000000000)
112         totalSupply = 500000000000000000000000000;                        // Update total supply (1500000000000 for example) (15000000000000)
113         name = "IDENetwork";                                   // Set the name for display purposes (IDENetwork)
114         decimals = 18;                                               // Amount of decimals for display purposes (18)
115         symbol = "IDEN";                                             // Set the symbol for display purposes (IDEN)
116         unitsOneEthCanBuy = 1000000;                                      // Set the price of your token for the ICO (900000000)
117         fundsWallet = msg.sender;                                  // The owner of the contract gets ETH
118     }
119 
120     function() payable{
121         totalEthInWei = totalEthInWei + msg.value;
122         uint256 amount = msg.value * unitsOneEthCanBuy;
123         if (balances[fundsWallet] < amount) {
124             return;
125         }
126 
127         balances[fundsWallet] = balances[fundsWallet] - amount;
128         balances[msg.sender] = balances[msg.sender] + amount;
129 
130         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
131 
132         //Transfer ether to fundsWallet
133         fundsWallet.transfer(msg.value);                               
134     }
135 
136     /* Approves and then calls the receiving contract */
137     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140 
141         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
142         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
143         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
144         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
145         return true;
146     }
147 }