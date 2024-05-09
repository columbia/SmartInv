1 pragma solidity ^0.4.23;
2 
3 contract Token  {
4     /// @return total amount of tokens
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     /// @param _owner The address from which the balance will be retrieved
8     /// @return The balance
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11     /// @notice send `_value` token to `_to` from `msg.sender`
12     /// @param _to The address of the recipient
13     /// @param _value The amount of token to be transferred
14     /// @return Whether the transfer was successful or not
15     function transfer(address _to, uint256 _value) returns (bool success) {}
16 
17     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
18     /// @param _from The address of the sender
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
23 
24     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
25     /// @param _spender The address of the account able to transfer the tokens
26     /// @param _value The amount of wei to be approved for transfer
27     /// @return Whether the approval was successful or not
28     function approve(address _spender, uint256 _value) returns (bool success) {}
29 
30     /// @param _owner The address of the account owning tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @return Amount of remaining tokens allowed to spent
33     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38 }
39 
40 contract StandardToken is Token {
41 
42     function transfer(address _to, uint256 _value) returns (bool success) {
43         //Default assumes totalSupply can't be over max (2^256 - 1).
44         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
45         //Replace the if with this one instead.
46         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
47         if (balances[msg.sender] >= _value && _value > 0) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } else { return false; }
53     }
54 
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56         //same as above. Replace this line with the following if you want to protect against wrapping uints.
57         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
58         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
59             balances[_to] += _value;
60             balances[_from] -= _value;
61             allowed[_from][msg.sender] -= _value;
62             Transfer(_from, _to, _value);
63             return true;
64         } else { return false; }
65     }
66 
67     function balanceOf(address _owner) constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71     function approve(address _spender, uint256 _value) returns (bool success) {
72         allowed[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         return true;
75     }
76 
77     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
78       return allowed[_owner][_spender];
79     }
80 
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;
83     uint256 public totalSupply;
84 }
85 
86 contract FTFNExchangeToken is StandardToken { // CHANGE THIS. Update the contract name.
87 
88     /* Public variables of the token */
89 
90     /*
91     NOTE:
92     The following variables are OPTIONAL vanities. One does not have to include them.
93     They allow one to customise the token contract & in no way influences the core functionality.
94     Some wallets/interfaces might not even bother to look at this information.
95     */
96     string public name;                   // Token Name
97     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
98     string public symbol;                 // An identifier: eg SBX, XPR etc..
99     string public version = 'H1FTFN.2018';
100     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
101     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.
102     address public fundsWallet;           // Where should the raised ETH go?
103 
104     // This is a constructor function
105     // which means the following function name has to match the contract name declared above
106     function FTFNExchangeToken() {
107         balances[msg.sender] = 901000000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
108         totalSupply = 701000000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
109         name = "FTFNExchangeToken";                                   // Set the name for display purposes (CHANGE THIS)
110         decimals = 8;                                               // Amount of decimals for display purposes (CHANGE THIS)
111         symbol = "FTFN";                                             // Set the symbol for display purposes (CHANGE THIS)
112         unitsOneEthCanBuy = 15000000;                                      // Set the price of your token for the ICO (CHANGE THIS)
113         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
114     }
115 
116     function() public payable{
117         totalEthInWei = totalEthInWei + msg.value;
118         uint256 amount = msg.value * unitsOneEthCanBuy;
119         require(balances[fundsWallet] >= amount);
120 
121         balances[fundsWallet] = balances[fundsWallet] - amount;
122         balances[msg.sender] = balances[msg.sender] + amount;
123 
124         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
125 
126         //Transfer ether to fundsWallet
127         fundsWallet.transfer(msg.value);                             
128     }
129 
130     /* Approves and then calls the receiving contract */
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134 
135         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
136         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
137         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
138         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
139         return true;
140     }
141 }