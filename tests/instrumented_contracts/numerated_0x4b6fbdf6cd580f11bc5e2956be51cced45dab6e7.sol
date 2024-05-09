1 pragma solidity ^0.4.18;
2 
3 /* -------------- LESanta  심볼 LES ,10억개 ISSUE ----------
4 createdate : 2019.02.08 
5 Token name : LESanta
6 Symbol name : LES
7 Decimal : 8 
8 ISSUED BY https://www.ibitgene.com/  
9 This is LESanta 
10 ----------------------------------------------------------*/
11 
12 contract Token {
13 
14     /// @return total amount of tokens
15     function totalSupply() constant returns (uint256 supply) {}
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) constant returns (uint256 balance) {}
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) returns (bool success) {}
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
33 
34     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of wei to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) returns (bool success) {}
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 
48 }
49 
50 contract StandardToken is Token {
51 
52     function transfer(address _to, uint256 _value) returns (bool success) {
53         //Default assumes totalSupply can't be over max (2^256 - 1).
54         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
55         //Replace the if with this one instead.
56         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57         if (balances[msg.sender] >= _value && _value > 0) {
58             balances[msg.sender] -= _value;
59             balances[_to] += _value;
60             Transfer(msg.sender, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
66         //same as above. Replace this line with the following if you want to protect against wrapping uints.
67         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
69             balances[_to] += _value;
70             balances[_from] -= _value;
71             allowed[_from][msg.sender] -= _value;
72             Transfer(_from, _to, _value);
73             return true;
74         } else { return false; }
75     }
76 
77     function balanceOf(address _owner) constant returns (uint256 balance) {
78         return balances[_owner];
79     }
80 
81     function approve(address _spender, uint256 _value) returns (bool success) {
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
88       return allowed[_owner][_spender];
89     }
90 
91     mapping (address => uint256) balances;
92     mapping (address => mapping (address => uint256)) allowed;
93     uint256 public totalSupply;
94 }
95 
96 contract LESanta  is StandardToken { //  **the contract name.
97 
98     /* Public variables of the token */
99 
100     /*
101     NOTE:
102     The following variables are choice vanities. One does not have to include them.
103     They allow one to customise the token contract & in no way influences the core functionality.
104     Some wallets/interfaces might not even bother to look at this information.
105     */
106     string public name;                   // Token Name https://www.ibitgene.com/ token issued 
107     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
108     string public symbol;                 // An identifier: eg SBX, XPR etc..
109     string public version = 'C1.0'; 
110     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
111     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
112     address public fundsWallet;           // Where should the raised ETH go?
113 
114     // This is a constructor function 
115     // which means the following function name has to match the contract name declared above
116 
117     function LESanta() {                                //** funtion name **/
118         balances[msg.sender] = 100000000000000000;      //** Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (coinchel )
119         totalSupply = 100000000000000000;               //** Update total supply (1000 for example) ( https://www.ibitgene.com/ )
120         name = "LESanta";                             //** Set the name for display purposes ( https://www.ibitgene.com/  )
121         decimals = 8;                                  //***  Amount of decimals for display purposes ( https://www.ibitgene.com/ )
122         symbol = "LES";                               // Set the symbol for display purposes ( https://www.ibitgene.com/)
123         unitsOneEthCanBuy = 100;                         // Set the price of your token for the ICO ( https://www.ibitgene.com/)
124         fundsWallet = msg.sender;                       // The owner of the contract gets ETH
125     }
126 
127     function() payable{
128         totalEthInWei = totalEthInWei + msg.value;
129         uint256 amount = msg.value * unitsOneEthCanBuy;
130         require(balances[fundsWallet] >= amount);
131 
132         balances[fundsWallet] = balances[fundsWallet] - amount;
133         balances[msg.sender] = balances[msg.sender] + amount;
134 
135         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
136 
137         //Transfer ether to fundsWallet
138         fundsWallet.transfer(msg.value);                               
139     }
140 
141     /* Approves and then calls the receiving contract */
142     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
143         allowed[msg.sender][_spender] = _value;
144         Approval(msg.sender, _spender, _value);
145 
146         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
147         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
148         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
149         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
150         return true;
151     }
152 }