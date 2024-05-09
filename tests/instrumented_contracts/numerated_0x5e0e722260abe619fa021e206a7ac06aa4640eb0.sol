1 pragma solidity ^0.4.4;
2  /**
3 TrustEURO TOKENSALE
4 
5 ***TOKEN INFORMATION***
6 Name: TrustEURO
7 Symbol: TEURO 
8 Total Supply: 15,000,000
9 
10 Prices as follows
11 
12 
13 0.01 ETH = 1000
14 0.1 ETH = 10,000 + 2000 Bonus
15 0.5 ETH = 50,000 + 15,000 Bonus
16 1.0 ETH = 100,000 + 50,000 Bonus
17 
18 */
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
57  
58  
59 contract StandardToken is Token {
60  
61     function transfer(address _to, uint256 _value) returns (bool success) {
62         //Default assumes totalSupply can't be over max (2^256 - 1).
63         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
64         //Replace the if with this one instead.
65         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
66         if (balances[msg.sender] >= _value && _value > 0) {
67             balances[msg.sender] -= _value;
68             balances[_to] += _value;
69             Transfer(msg.sender, _to, _value);
70             return true;
71         } else { return false; }
72     }
73  
74     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
75         //same as above. Replace this line with the following if you want to protect against wrapping uints.
76         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
77         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
78             balances[_to] += _value;
79             balances[_from] -= _value;
80             allowed[_from][msg.sender] -= _value;
81             Transfer(_from, _to, _value);
82             return true;
83         } else { return false; }
84     }
85  
86     function balanceOf(address _owner) constant returns (uint256 balance) {
87         return balances[_owner];
88     }
89  
90     function approve(address _spender, uint256 _value) returns (bool success) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93         return true;
94     }
95  
96     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
97       return allowed[_owner][_spender];
98     }
99  
100     mapping (address => uint256) balances;
101     mapping (address => mapping (address => uint256)) allowed;
102     uint256 public totalSupply;
103 }
104  
105  
106 contract TEURO is StandardToken { // CHANGE THIS. Update the contract name.
107 
108     /* Public variables of the token */
109 
110     /*
111     NOTE:
112     The following variables are OPTIONAL vanities. One does not have to include them.
113     They allow one to customise the token contract & in no way influences the core functionality.
114     Some wallets/interfaces might not even bother to look at this information.
115     */
116     string public name;                   // Token Name
117     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
118     string public symbol;                 // An identifier: eg SBX, XPR etc..
119     string public version = 'H1.0'; 
120     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
121     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
122     address public fundsWallet;           // Where should the raised ETH go?
123 
124     // This is a constructor function 
125     // which means the following function name has to match the contract name declared above
126     function TrustEURO() {
127         balances[msg.sender] = 15000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
128         totalSupply = 15000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
129         name = "TrustEURO";                                   // Set the name for display purposes (CHANGE THIS)
130         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
131         symbol = "TEURO";                                             // Set the symbol for display purposes (CHANGE THIS)
132         unitsOneEthCanBuy = 100000;                                      // Set the price of your token for the ICO (CHANGE THIS)
133         fundsWallet = msg.sender;                                  // The owner of the contract gets ETH
134     }
135 
136     function() payable{
137         totalEthInWei = totalEthInWei + msg.value;
138         uint256 amount = msg.value * unitsOneEthCanBuy;
139         require(balances[fundsWallet] >= amount);
140 
141         balances[fundsWallet] = balances[fundsWallet] - amount;
142         balances[msg.sender] = balances[msg.sender] + amount;
143 
144         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
145 
146         //Transfer ether to fundsWallet
147         fundsWallet.transfer(msg.value);                               
148     }
149 
150     /* Approves and then calls the receiving contract */
151     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154 
155         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
156         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
157         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
158         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
159         return true;
160     }
161 }