1 pragma solidity ^0.4.4;
2 
3 /*
4    MAKER DAO CLASSIC
5    
6    The Public Ethereum-based Financial Technology for Make Payments Anywhere
7    
8    Copyright ©2019 All rights reserved
9    London, United Kingdom
10    
11    Token Name : Maker Dao CLASSIC
12    Token Ticker : MKRC
13    Decimal : 8
14    Per Token Price : $0.5 USD
15    Supply : 12,000,000 MKRC
16    Exchanges : 20+ (ForkDelta, EtherDelta, TokenJar, TokenStore and others)
17    */
18    
19 contract Token {
20 
21     /// @return total amount of tokens
22     function totalSupply() constant returns (uint256 supply) {}
23 
24     /// @param _owner The address from which the balance will be retrieved
25     /// @return The balance
26     function balanceOf(address _owner) constant returns (uint256 balance) {}
27 
28     /// @notice send `_value` token to `_to` from `msg.sender`
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transfer(address _to, uint256 _value) returns (bool success) {}
33 
34     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
35     /// @param _from The address of the sender
36     /// @param _to The address of the recipient
37     /// @param _value The amount of token to be transferred
38     /// @return Whether the transfer was successful or not
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
40 
41     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @param _value The amount of wei to be approved for transfer
44     /// @return Whether the approval was successful or not
45     function approve(address _spender, uint256 _value) returns (bool success) {}
46 
47     /// @param _owner The address of the account owning tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @return Amount of remaining tokens allowed to spent
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 
55 }
56 
57 contract StandardToken is Token {
58 
59     function transfer(address _to, uint256 _value) returns (bool success) {
60         //Default assumes totalSupply can't be over max (2^256 - 1).
61         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
62         //Replace the if with this one instead.
63         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
64         if (balances[msg.sender] >= _value && _value > 0) {
65             balances[msg.sender] -= _value;
66             balances[_to] += _value;
67             Transfer(msg.sender, _to, _value);
68             return true;
69         } else { return false; }
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
73         //same as above. Replace this line with the following if you want to protect against wrapping uints.
74         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
75         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
76             balances[_to] += _value;
77             balances[_from] -= _value;
78             allowed[_from][msg.sender] -= _value;
79             Transfer(_from, _to, _value);
80             return true;
81         } else { return false; }
82     }
83 
84     function balanceOf(address _owner) constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
95       return allowed[_owner][_spender];
96     }
97 
98     mapping (address => uint256) balances;
99     mapping (address => mapping (address => uint256)) allowed;
100     uint256 public totalSupply;
101 }
102 
103  contract MakerDaoClassic is StandardToken { // CHANGE THIS. Update the contract name.
104 
105     /* Public variables of the token */
106 
107     /*
108     NOTE:
109     The following variables are OPTIONAL vanities. One does not have to include them.
110     They allow one to customise the token contract & in no way influences the core functionality.
111     Some wallets/interfaces might not even bother to look at this information.
112     */
113     string public name;                   // Token Name
114     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
115     string public symbol;                 // An identifier: eg SBX, XPR etc..
116     string public version = 'Copyright ©2019 All rights reserved.'; 
117     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
118     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
119     address public fundsWallet;           // Where should the raised ETH go?
120 
121     // This is a constructor function 
122     // which means the following function name has to match the contract name declared above
123     function MakerDaoClassic() {
124         balances[msg.sender] = 1200000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
125         totalSupply = 1200000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
126         name = "Maker Dao Classic";                                   // Set the name for display purposes (CHANGE THIS)
127         decimals = 8;                                               // Amount of decimals for display purposes (CHANGE THIS)
128         symbol = "MKRC";                                             // Set the symbol for display purposes (CHANGE THIS)
129         fundsWallet = 0x78863E62856D8C2047061F447C7E55c5838b7064;                                    // The owner of the contract gets ETH
130     }
131     
132 
133     function() payable{
134         totalEthInWei = totalEthInWei + msg.value;
135         uint256 amount = msg.value * unitsOneEthCanBuy;
136         if (balances[fundsWallet] < amount) {
137             return;
138         }
139 
140         balances[fundsWallet] = balances[fundsWallet] - amount;
141         balances[msg.sender] = balances[msg.sender] + amount;
142 
143         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
144 
145         //Transfer ether to fundsWallet
146         fundsWallet.transfer(msg.value);                               
147     }
148 
149     /* Approves and then calls the receiving contract */
150     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
151         allowed[msg.sender][_spender] = _value;
152         Approval(msg.sender, _spender, _value);
153 
154         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
155         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
156         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
157         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
158         return true;
159     }
160     
161 }