1 contract Token {
2 
3     /// @return total amount of tokens
4     function totalSupply() constant returns (uint256 supply) {}
5 
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not
14     function transfer(address _to, uint256 _value) returns (bool success) {}
15 
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokens
25     /// @param _value The amount of wei to be approved for transfer
26     /// @return Whether the approval was successful or not
27     function approve(address _spender, uint256 _value) returns (bool success) {}
28 
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 
37 }
38 
39 contract StandardToken is Token {
40 
41     function transfer(address _to, uint256 _value) returns (bool success) {
42         //Default assumes totalSupply can't be over max (2^256 - 1).
43         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
44         //Replace the if with this one instead.
45         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
46         if (balances[msg.sender] >= _value && _value > 0) {
47             balances[msg.sender] -= _value;
48             balances[_to] += _value;
49             Transfer(msg.sender, _to, _value);
50             return true;
51         } else { return false; }
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
55         //same as above. Replace this line with the following if you want to protect against wrapping uints.
56         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
58             balances[_to] += _value;
59             balances[_from] -= _value;
60             allowed[_from][msg.sender] -= _value;
61             Transfer(_from, _to, _value);
62             return true;
63         } else { return false; }
64     }
65 
66     function balanceOf(address _owner) constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70     function approve(address _spender, uint256 _value) returns (bool success) {
71         allowed[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
77       return allowed[_owner][_spender];
78     }
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;
82     uint256 public totalSupply;
83 }
84 
85 contract TheKitCoin is StandardToken { // CHANGE THIS. Update the contract name.
86 
87     /* Public variables of the token */
88 
89     /*
90     NOTE:
91     The following variables are OPTIONAL vanities. One does not have to include them.
92     They allow one to customise the token contract & in no way influences the core functionality.
93     Some wallets/interfaces might not even bother to look at this information.
94     */
95     string public name;                   // Token Name
96     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
97     string public symbol;                 // An identifier: eg SBX, XPR etc..
98     string public version = 'TKC1.0'; 
99     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
100     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
101     address public fundsWallet;           // Where should the raised ETH go?
102 
103     // This is a constructor function 
104     // which means the following function name has to match the contract name declared above
105     function TheKitCoin() {
106         balances[msg.sender] = 39500000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
107         totalSupply = 39500000;                        // Update total supply (1000 for example) (CHANGE THIS)
108         name = "TheKitCoin";                                   // Set the name for display purposes (CHANGE THIS)
109         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
110         symbol = "TKC";                                             // Set the symbol for display purposes (CHANGE THIS)
111         unitsOneEthCanBuy = 3437;                                      // Set the price of your token for the ICO (CHANGE THIS)
112         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
113     }
114 
115     function() payable{
116         totalEthInWei = totalEthInWei + msg.value;
117         uint256 amount = msg.value * unitsOneEthCanBuy;
118         if (balances[fundsWallet] < amount) {
119             return;
120         }
121 
122         balances[fundsWallet] = balances[fundsWallet] - amount;
123         balances[msg.sender] = balances[msg.sender] + amount;
124 
125         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
126 
127         //Transfer ether to fundsWallet
128         fundsWallet.transfer(msg.value);                               
129     }
130 
131     /* Approves and then calls the receiving contract */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135 
136         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
137         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
138         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
139         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
140         return true;
141     }
142 }