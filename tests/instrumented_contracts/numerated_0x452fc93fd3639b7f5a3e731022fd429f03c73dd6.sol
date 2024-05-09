1 //                 GoGoPay Token 
2 // Symbol      : GoGoPay
3 // Name        : GoPay
4 // Total supply: 16,000,000,000
5 // Decimals    : 18
6 //
7 //  
8 //  GoGoPay - Technology Which Will Change The World 
9 //  
10 // GoGopay.com // GoPayForum.com
11 //  
12 //
13 
14 contract Token {
15 
16     /// @return total amount of tokens
17     function totalSupply() constant returns (uint256 supply) {}
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) constant returns (uint256 balance) {}
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) returns (bool success) {}
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
35 
36     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of wei to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) returns (bool success) {}
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 
50 }
51 
52 contract StandardToken is Token {
53 
54     function transfer(address _to, uint256 _value) returns (bool success) {
55         //Default assumes totalSupply can't be over max (2^256 - 1).
56         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
57         //Replace the if with this one instead.
58         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[msg.sender] >= _value && _value > 0) {
60             balances[msg.sender] -= _value;
61             balances[_to] += _value;
62             Transfer(msg.sender, _to, _value);
63             return true;
64         } else { return false; }
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
68         //same as above. Replace this line with the following if you want to protect against wrapping uints.
69         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
70         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
71             balances[_to] += _value;
72             balances[_from] -= _value;
73             allowed[_from][msg.sender] -= _value;
74             Transfer(_from, _to, _value);
75             return true;
76         } else { return false; }
77     }
78 
79     function balanceOf(address _owner) constant returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     function approve(address _spender, uint256 _value) returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
90       return allowed[_owner][_spender];
91     }
92 
93     mapping (address => uint256) balances;
94     mapping (address => mapping (address => uint256)) allowed;
95     uint256 public totalSupply;
96 }
97 
98 contract GoGoPay is StandardToken { // CHANGE THIS. Update the contract name.
99 
100     /* Public variables of the token */
101 
102     /*
103     NOTE:
104     The following variables are OPTIONAL vanities. One does not have to include them.
105     They allow one to customise the token contract & in no way influences the core functionality.
106     Some wallets/interfaces might not even bother to look at this information.
107     */
108     string public name;                   // Token Name
109     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
110     string public symbol;                 // An identifier: eg SBX, XPR etc..
111     string public version = 'H1.0'; 
112     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
113     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
114     address public fundsWallet;           // Where should the raised ETH go?
115 
116     // This is a constructor function 
117     // which means the following function name has to match the contract name declared above
118     function GoGoPay() {
119         balances[msg.sender] = 16000000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
120         totalSupply = 16000000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
121         name = "GoGoPay";                                   // Set the name for display purposes (CHANGE THIS)
122         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
123         symbol = "GoPay";                                             // Set the symbol for display purposes (CHANGE THIS)
124         unitsOneEthCanBuy = 20000000;                                      // Set the price of your token for the ICO (CHANGE THIS)
125         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
126     }
127 
128     function() payable{
129         totalEthInWei = totalEthInWei + msg.value;
130         uint256 amount = msg.value * unitsOneEthCanBuy;
131         require(balances[fundsWallet] >= amount);
132 
133         balances[fundsWallet] = balances[fundsWallet] - amount;
134         balances[msg.sender] = balances[msg.sender] + amount;
135 
136         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
137 
138         //Transfer ether to fundsWallet
139         fundsWallet.transfer(msg.value);                               
140     }
141 
142     /* Approves and then calls the receiving contract */
143     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
144         allowed[msg.sender][_spender] = _value;
145         Approval(msg.sender, _spender, _value);
146 
147         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
148         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
149         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
150         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
151         return true;
152     }
153 }