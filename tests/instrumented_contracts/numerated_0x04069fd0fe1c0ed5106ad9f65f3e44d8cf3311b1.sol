1 pragma solidity ^0.4.18;
2 
3 /* --------------EMSToken-----------------------
4 2018.11.05 EMS Token
5 ISSUED BY COINCHEL.COM
6 -------------------------------------------------*/
7 
8 
9 contract Token {
10 
11 
12     /// @return total amount of tokens
13     function totalSupply() constant returns (uint256 supply) {}
14 
15     /// @param _owner The address from which the balance will be retrieved
16     /// @return The balance
17     function balanceOf(address _owner) constant returns (uint256 balance) {}
18 
19     /// @notice send `_value` token to `_to` from `msg.sender`
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transfer(address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
26     /// @param _from The address of the sender
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
31 
32     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @param _value The amount of wei to be approved for transfer
35     /// @return Whether the approval was successful or not
36     function approve(address _spender, uint256 _value) returns (bool success) {}
37 
38     /// @param _owner The address of the account owning tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @return Amount of remaining tokens allowed to spent
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
42 
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 
46 }
47 
48 contract StandardToken is Token {
49 
50     function transfer(address _to, uint256 _value) returns (bool success) {
51         //Default assumes totalSupply can't be over max (2^256 - 1).
52         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
53         //Replace the if with this one instead.
54         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
55         if (balances[msg.sender] >= _value && _value > 0) {
56             balances[msg.sender] -= _value;
57             balances[_to] += _value;
58             Transfer(msg.sender, _to, _value);
59             return true;
60         } else { return false; }
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
64         //same as above. Replace this line with the following if you want to protect against wrapping uints.
65         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
66         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
67             balances[_to] += _value;
68             balances[_from] -= _value;
69             allowed[_from][msg.sender] -= _value;
70             Transfer(_from, _to, _value);
71             return true;
72         } else { return false; }
73     }
74 
75     function balanceOf(address _owner) constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88 
89     mapping (address => uint256) balances;
90     mapping (address => mapping (address => uint256)) allowed;
91     uint256 public totalSupply;
92 }
93 
94 contract EMSToken is StandardToken { // CHANGE THIS. Update the contract name.
95 
96     /* Public variables of the token */
97 
98     /*
99     NOTE:
100     The following variables are  vanities. One does not have to include them.
101     They allow one to customise the token contract & in no way influences the core functionality.
102     Some wallets/interfaces might not even bother to look at this information.
103     */
104     string public name;                   // Token Name
105     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
106     string public symbol;                 // An identifier: eg SBX, XPR etc..
107     string public version = 'E1.0'; 
108     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
109     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
110     address public fundsWallet;           // Where should the raised ETH go
111 
112     // This is a constructor function 
113     // which means the following function name has to match the contract name declared above
114     function EMSToken() {
115         balances[msg.sender] = 500000000000000;                   // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. 
116         totalSupply = 500000000000000;                            // Update total supply (1000 for example) 
117         name = "EMSToken";                                       // Set the name for display purposes 
118         decimals = 6;                                               // Amount of decimals for display purposes 
119         symbol = "EMS";                                             // Set the symbol for display purposes 
120         unitsOneEthCanBuy = 10;                                      // Set the price of your token for the ICO 
121         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
122     }
123 
124     function() payable{
125         totalEthInWei = totalEthInWei + msg.value;
126         uint256 amount = msg.value * unitsOneEthCanBuy;
127         require(balances[fundsWallet] >= amount);
128 
129         balances[fundsWallet] = balances[fundsWallet] - amount;
130         balances[msg.sender] = balances[msg.sender] + amount;
131 
132         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
133 
134         //Transfer ether to fundsWallet
135         fundsWallet.transfer(msg.value);                               
136     }
137 
138     /* Approves and then calls the receiving contract */
139     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
140         allowed[msg.sender][_spender] = _value;
141         Approval(msg.sender, _spender, _value);
142 
143         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
144         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
145         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
146         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
147         return true;
148     }
149 }