1 /**
2  * Source Code first verified at https://etherscan.io on Friday, March 8, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.12;
6 
7 contract Token {
8 
9     /// @return total amount of tokens
10     function totalSupply() constant returns (uint256 supply) {}
11 
12     /// @param _owner The address from which the balance will be retrieved
13     
14     /// @return The balance
15     function balanceOf(address _owner) constant returns (uint256 balance) {}
16 
17     /// @notice send `_value` token to `_to` from `msg.sender`
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transfer(address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
29 
30     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @param _value The amount of wei to be approved for transfer
33     /// @return Whether the approval was successful or not
34     function approve(address _spender, uint256 _value) returns (bool success) {}
35 
36     /// @param _owner The address of the account owning tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @return Amount of remaining tokens allowed to spent
39     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44 }
45 
46 contract StandardToken is Token {
47 
48     function transfer(address _to, uint256 _value) returns (bool success) {
49         //Default assumes totalSupply can't be over max (2^256 - 1).
50         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
51         //Replace the if with this one instead.
52         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
53         if (balances[msg.sender] >= _value && _value > 0) {
54             balances[msg.sender] -= _value;
55             balances[_to] += _value;
56             Transfer(msg.sender, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
62         //same as above. Replace this line with the following if you want to protect against wrapping uints.
63         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
64         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
65             balances[_to] += _value;
66             balances[_from] -= _value;
67             allowed[_from][msg.sender] -= _value;
68             Transfer(_from, _to, _value);
69             return true;
70         } else { return false; }
71     }
72 
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value) returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84       return allowed[_owner][_spender];
85     }
86 
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89     uint256 public totalSupply;
90 }
91 
92 contract HungaryFiller is StandardToken { // CHANGE THIS. Update the contract name.
93 
94     /* Public variables of the token */
95 
96     /*
97     NOTE:
98     The following variables are OPTIONAL vanities. One does not have to include them.
99     They allow one to customise the token contract & in no way influences the core functionality.
100     Some wallets/interfaces might not even bother to look at this information.
101     */
102     string public name;                   // Token Name
103     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
104     string public symbol;                 // An identifier: eg SBX, XPR etc..
105     string public version = 'H1.0'; 
106     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
107     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
108     address public fundsWallet;           // Where should the raised ETH go?
109 
110     // This is a constructor function 
111     // which means the following function name has to match the contract name declared above
112     function HungaryFiller() {
113         balances[msg.sender] = 99999999999999999999999999999;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
114         totalSupply =          99999999999999999999999999999;                        // Update total supply (1000 for example) (CHANGE THIS)
115         name = "HungaryFiller";                                   // Set the name for display purposes (CHANGE THIS)
116         decimals = 2;                                               // Amount of decimals for display purposes (CHANGE THIS)
117         symbol = "HUF";                                             // Set the symbol for display purposes (CHANGE THIS)
118         unitsOneEthCanBuy = 10;                                      // Set the price of your token for the ICO (CHANGE THIS)
119         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
120     }
121 
122     function() payable{
123         totalEthInWei = totalEthInWei + msg.value;
124         uint256 amount = msg.value * unitsOneEthCanBuy;
125         (balances[fundsWallet] >= amount);
126 
127         balances[fundsWallet] = balances[fundsWallet] - amount;
128         balances[msg.sender] = balances[msg.sender] + amount;
129 
130         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
131 
132         //Transfer ether to fundsWallet
133                                       
134     }
135 
136     /* Approves and then calls the receiving contract */
137     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140 
141         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
142         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
143         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
144         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
145         return true;
146     }
147 }