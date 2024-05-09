1 //Source code for custom Smart Contract for Ethereum Network (test or main)
2 //To modify the values, change the values of variables where 'CHANGE THIS' is commented beside them
3 
4 pragma solidity ^0.4.4;
5 
6 contract Token {
7 
8     /// @return total amount of tokens
9     function totalSupply() constant returns (uint256 supply) {}
10 
11     /// @param _owner The address from which the balance will be retrieved
12     /// @return The balance
13     function balanceOf(address _owner) constant returns (uint256 balance) {}
14 
15     /// @notice send `_value` token to `_to` from `msg.sender`
16     /// @param _to The address of the recipient
17     /// @param _value The amount of token to be transferred
18     /// @return Whether the transfer was successful or not
19     function transfer(address _to, uint256 _value) returns (bool success) {}
20 
21     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
22     /// @param _from The address of the sender
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
27 
28     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @param _value The amount of wei to be approved for transfer
31     /// @return Whether the approval was successful or not
32     function approve(address _spender, uint256 _value) returns (bool success) {}
33 
34     /// @param _owner The address of the account owning tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @return Amount of remaining tokens allowed to spent
37     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
38 
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 
42 }
43 
44 contract StandardToken is Token {
45 
46     function transfer(address _to, uint256 _value) returns (bool success) {
47         //Default assumes totalSupply can't be over max (2^256 - 1).
48         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
49         //Replace the if with this one instead.
50         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
51         if (balances[msg.sender] >= _value && _value > 0) {
52             balances[msg.sender] -= _value;
53             balances[_to] += _value;
54             Transfer(msg.sender, _to, _value);
55             return true;
56         } else { return false; }
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
60         //same as above. Replace this line with the following if you want to protect against wrapping uints.
61         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
62         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
63             balances[_to] += _value;
64             balances[_from] -= _value;
65             allowed[_from][msg.sender] -= _value;
66             Transfer(_from, _to, _value);
67             return true;
68         } else { return false; }
69     }
70 
71     function balanceOf(address _owner) constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75     function approve(address _spender, uint256 _value) returns (bool success) {
76         allowed[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
82       return allowed[_owner][_spender];
83     }
84 
85     mapping (address => uint256) balances;
86     mapping (address => mapping (address => uint256)) allowed;
87     uint256 public totalSupply;
88 }
89 
90 contract DINAR is StandardToken {    // CHANGE THIS. Update the contract name.
91 
92     /* Public variables of the token */
93 
94     /*
95     NOTE:
96     The following variables are OPTIONAL vanities. One does not have to include them.
97     They allow one to customise the token contract & in no way influences the core functionality.
98     Some wallets/interfaces might not even bother to look at this information.
99     */
100     string public name;                   // Token Name
101     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
102     string public symbol;                 // An identifier: eg SBX, XPR etc..
103     string public version = "H1.0"; 
104     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
105     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
106     address public fundsWallet;           // Where should the raised ETH go?
107 
108     // This is a constructor function 
109     // which means the following function name has to match the contract name declared above
110     function DINAR() {
111         balances[msg.sender] = 3500000000*1000000000000000000;               // Give the creator all initial tokens. This is set to 1000000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
112         totalSupply = 3500000000*1000000000000000000;                        // Update total supply (CHANGE THIS)
113         name = "DINAR";                                          // Set the name for display purposes (CHANGE THIS)
114         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
115         symbol = "DINAR";                                             // Set the symbol for display purposes (CHANGE THIS)
116         unitsOneEthCanBuy = 80000;                                      // Set the price of your token for the ICO (CHANGE THIS)
117         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
118     }
119     
120     function changePrice(uint p) returns (uint) {
121         address trusted = fundsWallet;   //trust only the creator
122         if (msg.sender != trusted ) 
123             throw;
124 
125         unitsOneEthCanBuy = p;
126 
127         return unitsOneEthCanBuy;
128     }
129 
130    function changeSupply(uint supp) returns (uint) {
131         address trusted = fundsWallet;   //trust only the creator 
132         if (msg.sender != trusted ) 
133             throw;
134 
135         totalSupply = supp*1000000000000000000;
136 
137         return totalSupply;
138     }
139 
140     function() payable{
141         totalEthInWei = totalEthInWei + msg.value;
142         uint256 amount = msg.value * unitsOneEthCanBuy;
143         if (balances[fundsWallet] < amount) {
144             return;
145         }
146 
147         balances[fundsWallet] = balances[fundsWallet] - amount;
148         balances[msg.sender] = balances[msg.sender] + amount;
149 
150         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
151 
152         //Transfer ether to fundsWallet
153         fundsWallet.transfer(msg.value);                               
154     }
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