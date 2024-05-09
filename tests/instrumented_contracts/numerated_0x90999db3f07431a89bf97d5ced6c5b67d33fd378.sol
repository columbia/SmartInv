1 // ---------------------------VerixChain-------------------------------------------------
2 //
3 // Symbol      : Verix
4 // Name        : VerixChain
5 // Total supply: 33333333333
6 // Decimals    : 
7 //
8 //   a Decentralized monetary powered by Ethereum. 
9 //     Our future is here! 
10 // 
11 //  (c) VerixChain 2018  
12 
13 
14 
15 contract Token {
16 
17     /// @return total amount of tokens
18     function totalSupply() constant returns (uint256 supply) {}
19 
20     /// @param _owner The address from which the balance will be retrieved
21     /// @return The balance
22     function balanceOf(address _owner) constant returns (uint256 balance) {}
23 
24     /// @notice send `_value` token to `_to` from `msg.sender`
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transfer(address _to, uint256 _value) returns (bool success) {}
29 
30     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
31     /// @param _from The address of the sender
32     /// @param _to The address of the recipient
33     /// @param _value The amount of token to be transferred
34     /// @return Whether the transfer was successful or not
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
36 
37     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @param _value The amount of wei to be approved for transfer
40     /// @return Whether the approval was successful or not
41     function approve(address _spender, uint256 _value) returns (bool success) {}
42 
43     /// @param _owner The address of the account owning tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @return Amount of remaining tokens allowed to spent
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 
51 }
52 
53 contract StandardToken is Token {
54 
55     function transfer(address _to, uint256 _value) returns (bool success) {
56         //Default assumes totalSupply can't be over max (2^256 - 1).
57         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
58         //Replace the if with this one instead.
59         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60         if (balances[msg.sender] >= _value && _value > 0) {
61             balances[msg.sender] -= _value;
62             balances[_to] += _value;
63             Transfer(msg.sender, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
69         //same as above. Replace this line with the following if you want to protect against wrapping uints.
70         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
71         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
72             balances[_to] += _value;
73             balances[_from] -= _value;
74             allowed[_from][msg.sender] -= _value;
75             Transfer(_from, _to, _value);
76             return true;
77         } else { return false; }
78     }
79 
80     function balanceOf(address _owner) constant returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint256 _value) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93 
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96     uint256 public totalSupply;
97 }
98 
99 contract VerixChain is StandardToken { // CHANGE THIS. Update the contract name.
100 
101     /* Public variables of the token */
102 
103     /*
104     NOTE:
105     The following variables are OPTIONAL vanities. One does not have to include them.
106     They allow one to customise the token contract & in no way influences the core functionality.
107     Some wallets/interfaces might not even bother to look at this information.
108     */
109     string public name;                   // Token Name
110     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
111     string public symbol;                 // An identifier: eg SBX, XPR etc..
112     string public version = 'H1.0'; 
113     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
114     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
115     address public fundsWallet;           // Where should the raised ETH go?
116 
117     // This is a constructor function 
118     // which means the following function name has to match the contract name declared above
119     function VerixChain() {
120         balances[msg.sender] = 33333333333e8;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
121         totalSupply = 33333333333e8;                        // Update total supply (1000 for example) (CHANGE THIS)
122         name = "VerixChain";                                   // Set the name for display purposes (CHANGE THIS)
123         decimals = 8;                                               // Amount of decimals for display purposes (CHANGE THIS)
124         symbol = "Verix";                                             // Set the symbol for display purposes (CHANGE THIS)
125         unitsOneEthCanBuy = 50000000;                                      // Set the price of your token for the ICO (CHANGE THIS)
126         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
127     }
128 
129     function() payable{
130         totalEthInWei = totalEthInWei + msg.value;
131         uint256 amount = msg.value * unitsOneEthCanBuy;
132         require(balances[fundsWallet] >= amount);
133 
134         balances[fundsWallet] = balances[fundsWallet] - amount;
135         balances[msg.sender] = balances[msg.sender] + amount;
136 
137         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
138 
139         //Transfer ether to fundsWallet
140         fundsWallet.transfer(msg.value);                               
141     }
142 
143     /* Approves and then calls the receiving contract */
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
145         allowed[msg.sender][_spender] = _value;
146         Approval(msg.sender, _spender, _value);
147 
148         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
149         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
150         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
151         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
152         return true;
153     }
154 }