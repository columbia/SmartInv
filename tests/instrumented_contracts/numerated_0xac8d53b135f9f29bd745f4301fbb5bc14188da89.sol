1 pragma solidity ^0.4.18;
2 
3 /* --------------CHELTOKEN  Token----------------------
4 2018.11.07 CHELTOKEN
5 ISSUED BY COINCHEL.COM
6 This is coinchel.com TOKEN 
7 -------------------------------------------------*/
8 
9 contract Token {
10 
11     /// @return total amount of tokens
12     function totalSupply() constant returns (uint256 supply) {}
13 
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) constant returns (uint256 balance) {}
17 
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) returns (bool success) {}
23 
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
30 
31     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of wei to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) returns (bool success) {}
36 
37     /// @param _owner The address of the account owning tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @return Amount of remaining tokens allowed to spent
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 
45 }
46 
47 contract StandardToken is Token {
48 
49     function transfer(address _to, uint256 _value) returns (bool success) {
50         //Default assumes totalSupply can't be over max (2^256 - 1).
51         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
52         //Replace the if with this one instead.
53         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
54         if (balances[msg.sender] >= _value && _value > 0) {
55             balances[msg.sender] -= _value;
56             balances[_to] += _value;
57             Transfer(msg.sender, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         //same as above. Replace this line with the following if you want to protect against wrapping uints.
64         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
65         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
66             balances[_to] += _value;
67             balances[_from] -= _value;
68             allowed[_from][msg.sender] -= _value;
69             Transfer(_from, _to, _value);
70             return true;
71         } else { return false; }
72     }
73 
74     function balanceOf(address _owner) constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     function approve(address _spender, uint256 _value) returns (bool success) {
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
85       return allowed[_owner][_spender];
86     }
87 
88     mapping (address => uint256) balances;
89     mapping (address => mapping (address => uint256)) allowed;
90     uint256 public totalSupply;
91 }
92 
93 contract CHELTOKEN  is StandardToken { // CHANGE THIS. Update the contract name.
94 
95     /* Public variables of the token */
96 
97     /*
98     NOTE:
99     The following variables are choice vanities. One does not have to include them.
100     They allow one to customise the token contract & in no way influences the core functionality.
101     Some wallets/interfaces might not even bother to look at this information.
102     */
103     string public name;                   // Token Name coinchel token issued 
104     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
105     string public symbol;                 // An identifier: eg SBX, XPR etc..
106     string public version = 'C1.0'; 
107     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
108     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
109     address public fundsWallet;           // Where should the raised ETH go?
110 
111     // This is a constructor function 
112     // which means the following function name has to match the contract name declared above
113 
114     function CHELTOKEN() {
115         balances[msg.sender] = 1000000000000000;                   // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (coinchel )
116         totalSupply = 1000000000000000;                            // Update total supply (1000 for example) ( coinchel )
117         name = "CHELTOKEN";                                         // Set the name for display purposes ( coinchel  )
118         decimals = 6;                                               // Amount of decimals for display purposes ( coinchel )
119         symbol = "CCT";                                             // Set the symbol for display purposes (coinchel )
120         unitsOneEthCanBuy = 10;                                      // Set the price of your token for the ICO (coinchel )
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