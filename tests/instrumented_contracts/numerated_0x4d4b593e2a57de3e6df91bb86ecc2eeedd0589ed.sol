1 pragma solidity ^0.4.4;
2     contract owned {
3         address public owner;
4 
5         function owned() {
6             owner = msg.sender;
7         }
8 
9         modifier onlyOwner {
10             require(msg.sender == owner);
11             _;
12         }
13 
14         function transferOwnership(address newOwner) onlyOwner {
15             owner = newOwner;
16             
17         }
18     }
19     
20 contract Token is owned{
21 
22     /// @return total amount of tokens
23     function totalSupply() constant returns (uint256 supply) {}
24 
25     /// @param _owner The address from which the balance will be retrieved
26     /// @return The balance
27     function balanceOf(address _owner) constant returns (uint256 balance) {}
28 
29     /// @notice send `_value` token to `_to` from `msg.sender`
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transfer(address _to, uint256 _value) returns (bool success) {}
34 
35     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
36     /// @param _from The address of the sender
37     /// @param _to The address of the recipient
38     /// @param _value The amount of token to be transferred
39     /// @return Whether the transfer was successful or not
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
41 
42     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @param _value The amount of wei to be approved for transfer
45     /// @return Whether the approval was successful or not
46     function approve(address _spender, uint256 _value) returns (bool success) {}
47 
48     /// @param _owner The address of the account owning tokens
49     /// @param _spender The address of the account able to transfer the tokens
50     /// @return Amount of remaining tokens allowed to spent
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
52     
53 
54     event Transfer(address indexed _from, address indexed _to, uint256 _value);
55     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56     
57 
58 }
59 
60 contract StandardToken is Token {
61     
62 
63     function transfer(address _to, uint256 _value) returns (bool success) {
64         //Default assumes totalSupply can't be over max (2^256 - 1).
65         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
66         //Replace the if with this one instead.
67         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68         if (balances[msg.sender] >= _value && _value > 0) {
69             balances[msg.sender] -= _value;
70             balances[_to] += _value;
71             Transfer(msg.sender, _to, _value);
72             return true;
73         } else { return false; }
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77         //same as above. Replace this line with the following if you want to protect against wrapping uints.
78         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
79         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
80             balances[_to] += _value;
81             balances[_from] -= _value;
82             allowed[_from][msg.sender] -= _value;
83             Transfer(_from, _to, _value);
84             return true;
85         } else { return false; }
86     }
87 
88 
89     function balanceOf(address _owner) constant returns (uint256 balance) {
90         return balances[_owner];
91     }
92 
93     function approve(address _spender, uint256 _value) returns (bool success) {
94         allowed[msg.sender][_spender] = _value;
95         Approval(msg.sender, _spender, _value);
96         return true;
97     }
98 
99     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
100       return allowed[_owner][_spender];
101     }
102 
103     mapping (address => uint256) balances;
104     mapping (address => mapping (address => uint256)) allowed;
105     uint256 public totalSupply;
106 }
107 
108 contract StoicToken is StandardToken { // CHANGE THIS. Update the contract name.
109 
110     /* Public variables of the token */
111 
112     /*
113     NOTE:
114     The following variables are OPTIONAL vanities. One does not have to include them.
115     They allow one to customise the token contract & in no way influences the core functionality.
116     Some wallets/interfaces might not even bother to look at this information.
117     */
118     string public name;                   // Token Name
119     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
120     string public symbol;                 // An identifier: eg SBX, XPR etc..
121     string public version = 'H1.0'; 
122     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
123     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
124     address public fundsWallet;           // Where should the raised ETH go?
125 
126     // This is a constructor function 
127     // which means the following function name has to match the contract name declared above
128     function StoicToken() {
129         balances[msg.sender] = 8202370300000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
130         totalSupply = 8202370300000000;                        // Update total supply (1000 for example) (CHANGE THIS)
131         name = "Stoic";                                   // Set the name for display purposes (CHANGE THIS)
132         decimals = 8;                                               // Amount of decimals for display purposes (CHANGE THIS)
133         symbol = "SOX";                                             // Set the symbol for display purposes (CHANGE THIS)
134         unitsOneEthCanBuy = 1000;                                      // Set the price of your token for the ICO (CHANGE THIS)
135         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
136     }
137 
138     function() payable{
139         totalEthInWei = totalEthInWei + msg.value;
140         uint256 amount = msg.value * unitsOneEthCanBuy;
141         if (balances[fundsWallet] < amount) {
142             return;
143         }
144 
145         balances[fundsWallet] = balances[fundsWallet] - amount;
146         balances[msg.sender] = balances[msg.sender] + amount;
147 
148         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
149 
150         //Transfer ether to fundsWallet
151         fundsWallet.transfer(msg.value);                               
152     }
153     
154     
155 
156     /* Approves and then calls the receiving contract */
157     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
158         allowed[msg.sender][_spender] = _value;
159         Approval(msg.sender, _spender, _value);
160 
161         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
162         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
163         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
164         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
165         return true;
166     }
167 }