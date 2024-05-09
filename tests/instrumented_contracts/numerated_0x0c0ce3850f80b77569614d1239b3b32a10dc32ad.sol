1 pragma solidity ^0.4.23;
2 
3 contract Token {
4     
5    
6     /// @return total amount of tokens
7     function totalSupply() constant returns (uint256 supply) {}
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) constant returns (uint256 balance) {}
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) returns (bool success) {}
18 
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
25 
26     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of wei to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) returns (bool success) {}
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40 }
41 
42 contract StandardToken is Token {
43 
44     function transfer(address _to, uint256 _value) returns (bool success) {
45         //Default assumes totalSupply can't be over max (2^256 - 1).
46         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
47         //Replace the if with this one instead.
48         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
49         if (balances[msg.sender] >= _value && _value > 0) {
50             balances[msg.sender] -= _value;
51             balances[_to] += _value;
52             Transfer(msg.sender, _to, _value);
53             return true;
54         } else { return false; }
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         //same as above. Replace this line with the following if you want to protect against wrapping uints.
59         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
61             balances[_to] += _value;
62             balances[_from] -= _value;
63             allowed[_from][msg.sender] -= _value;
64             Transfer(_from, _to, _value);
65             return true;
66         } else { return false; }
67     }
68 
69     function balanceOf(address _owner) constant returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint256 _value) returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
80       return allowed[_owner][_spender];
81     }
82 
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;
85     uint256 public totalSupply;
86 }
87 
88 contract KOINTRADE is StandardToken { // CHANGE THIS. Update the contract name.
89 
90     /* Public variables of the token */
91 
92     /*
93     NOTE:
94     The following variables are OPTIONAL vanities. One does not have to include them.
95     They allow one to customise the token contract & in no way influences the core functionality.
96     Some wallets/interfaces might not even bother to look at this information.
97     */
98     string public name;                   // Token Name
99     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
100     string public symbol;                 // An identifier: eg SBX, XPR etc..
101     string public version = 'H1.0';
102     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
103     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.
104     address public fundsWallet;           // Where should the raised ETH go?
105 
106     // This is a constructor function
107     // which means the following function name has to match the contract name declared above
108     function KOINTRADE() {
109         balances[msg.sender] = 900000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
110         totalSupply = 900000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
111         name = "KOINTRADE";                                   // Set the name for display purposes (CHANGE THIS)
112         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
113         symbol = "KTE";                                             // Set the symbol for display purposes (CHANGE THIS)
114         unitsOneEthCanBuy = 7000000;                                      // Set the price of your token for the ICO (CHANGE THIS)
115         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
116     }
117 
118     function() public payable{
119         totalEthInWei = totalEthInWei + msg.value;
120         uint256 amount = msg.value * unitsOneEthCanBuy;
121         require(balances[fundsWallet] >= amount);
122 
123         balances[fundsWallet] = balances[fundsWallet] - amount;
124         balances[msg.sender] = balances[msg.sender] + amount;
125 
126         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
127 
128         //Transfer ether to fundsWallet
129         fundsWallet.transfer(msg.value);                             
130     }
131     
132     /**
133     * @dev Batch transfer some tokens to some addresses, address and value is one-on-one.
134     * @param _dests Array of addresses
135     * @param _values Array of transfer tokens number
136     */
137     function batchTransfer(address[] _dests, uint256[] _values) public {
138         require(_dests.length == _values.length);
139         uint256 i = 0;
140         while (i < _dests.length) {
141             transfer(_dests[i], _values[i]);
142             i += 1;
143         }
144     }
145 
146     /**
147     * @dev Batch transfer equal tokens amout to some addresses
148     * @param _dests Array of addresses
149     * @param _value Number of transfer tokens amount
150     */
151     function batchTransferSingleValue(address[] _dests, uint256 _value) public {
152         uint256 i = 0;
153         while (i < _dests.length) {
154             transfer(_dests[i], _value);
155             i += 1;
156         }
157     }
158 
159     /* Approves and then calls the receiving contract */
160     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
161         allowed[msg.sender][_spender] = _value;
162         Approval(msg.sender, _spender, _value);
163 
164         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
165         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
166         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
167         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
168         return true;
169     }
170 }