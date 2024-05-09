1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-29
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-05-02
7 */
8 
9 pragma solidity ^0.4.4;
10 
11 contract Token {
12 
13     /// @return total amount of tokens
14     function totalSupply() constant returns (uint256 supply) {}
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) constant returns (uint256 balance) {}
19 
20     /// @notice send _value token to _to from msg.sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) returns (bool success) {}
25 
26     /// @notice send _value token to _to from _from on the condition it is approved by _from
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
32 
33     /// @notice msg.sender approves _addr to spend _value tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of wei to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) returns (bool success) {}
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 
47 }
48 
49 contract StandardToken is Token {
50 
51     function transfer(address _to, uint256 _value) returns (bool success) {
52         //Default assumes totalSupply can't be over max (2^256 - 1).
53         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
54         //Replace the if with this one instead.
55         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
56         if (balances[msg.sender] >= _value && _value > 0) {
57             balances[msg.sender] -= _value;
58             balances[_to] += _value;
59             Transfer(msg.sender, _to, _value);
60             return true;
61         } else { return false; }
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
65         //same as above. Replace this line with the following if you want to protect against wrapping uints.
66         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
67         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
68             balances[_to] += _value;
69             balances[_from] -= _value;
70             allowed[_from][msg.sender] -= _value;
71             Transfer(_from, _to, _value);
72             return true;
73         } else { return false; }
74     }
75 
76     function balanceOf(address _owner) constant returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80     function approve(address _spender, uint256 _value) returns (bool success) {
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
87       return allowed[_owner][_spender];
88     }
89 
90     mapping (address => uint256) balances;
91     mapping (address => mapping (address => uint256)) allowed;
92     uint256 public totalSupply;
93 }
94 
95 contract Dain
96 
97  is StandardToken { 
98 
99     /* Public variables of the token */
100 
101     /*
102     NOTE:
103     The following variables are OPTIONAL vanities. One does not have to include them.
104 
105 
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
117 
118     // which means the following function name has to match the contract name declared above
119     function Dain
120 
121  () {
122         balances[msg.sender] = 1000000000000000000000000000;
123         totalSupply = 1000000000000000000000000000;
124         name = "Dain ";
125         decimals = 18;
126             symbol = "DNC";
127         unitsOneEthCanBuy = 1000;
128         fundsWallet = msg.sender;
129     }
130 
131     function() payable{
132         totalEthInWei = totalEthInWei + msg.value;
133         uint256 amount = msg.value * unitsOneEthCanBuy;
134         require(balances[fundsWallet] >= amount);
135 
136         balances[fundsWallet] = balances[fundsWallet] - amount;
137         balances[msg.sender] = balances[msg.sender] + amount;
138 
139         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
140 
141         //Transfer ether to fundsWallet
142         fundsWallet.transfer(msg.value);                               
143     }
144 
145     /* Approves and then calls the receiving contract */
146     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149 
150         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
151         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
152         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
153         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
154         return true;
155     }
156 }