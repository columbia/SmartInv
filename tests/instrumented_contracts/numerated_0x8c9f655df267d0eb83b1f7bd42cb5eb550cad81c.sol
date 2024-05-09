1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-02
3 */
4 
5 pragma solidity ^0.4.4;
6 
7 contract Token {
8 
9     /// @return total amount of tokens
10     function totalSupply() constant returns (uint256 supply) {}
11 
12     /// @param _owner The address from which the balance will be retrieved
13     /// @return The balance
14     function balanceOf(address _owner) constant returns (uint256 balance) {}
15 
16     /// @notice send _value token to _to from msg.sender
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transfer(address _to, uint256 _value) returns (bool success) {}
21 
22     /// @notice send _value token to _to from _from on the condition it is approved by _from
23     /// @param _from The address of the sender
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
28 
29     /// @notice msg.sender approves _addr to spend _value tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @param _value The amount of wei to be approved for transfer
32     /// @return Whether the approval was successful or not
33     function approve(address _spender, uint256 _value) returns (bool success) {}
34 
35     /// @param _owner The address of the account owning tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @return Amount of remaining tokens allowed to spent
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
39 
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 
43 }
44 
45 contract StandardToken is Token {
46 
47     function transfer(address _to, uint256 _value) returns (bool success) {
48         //Default assumes totalSupply can't be over max (2^256 - 1).
49         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
50         //Replace the if with this one instead.
51         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
52         if (balances[msg.sender] >= _value && _value > 0) {
53             balances[msg.sender] -= _value;
54             balances[_to] += _value;
55             Transfer(msg.sender, _to, _value);
56             return true;
57         } else { return false; }
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
61         //same as above. Replace this line with the following if you want to protect against wrapping uints.
62         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
63         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
64             balances[_to] += _value;
65             balances[_from] -= _value;
66             allowed[_from][msg.sender] -= _value;
67             Transfer(_from, _to, _value);
68             return true;
69         } else { return false; }
70     }
71 
72     function balanceOf(address _owner) constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender, uint256 _value) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83       return allowed[_owner][_spender];
84     }
85 
86     mapping (address => uint256) balances;
87     mapping (address => mapping (address => uint256)) allowed;
88     uint256 public totalSupply;
89 }
90 
91 contract Evolution
92 
93  is StandardToken { 
94 
95     /* Public variables of the token */
96 
97     /*
98     NOTE:
99     The following variables are OPTIONAL vanities. One does not have to include them.
100 
101 
102     They allow one to customise the token contract & in no way influences the core functionality.
103     Some wallets/interfaces might not even bother to look at this information.
104     */
105     string public name;                   // Token Name
106     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
107     string public symbol;                 // An identifier: eg SBX, XPR etc..
108     string public version = 'H1.0'; 
109     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
110     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
111     address public fundsWallet;           // Where should the raised ETH go?
112 
113 
114     // which means the following function name has to match the contract name declared above
115     function Evolution
116 
117  () {
118         balances[msg.sender] = 10000000000000000;
119         totalSupply = 10000000000000000;
120         name = "Evolution ";
121         decimals = 10;
122             symbol = "EVT";
123         unitsOneEthCanBuy = 300;
124         fundsWallet = msg.sender;
125     }
126 
127     function() payable{
128         totalEthInWei = totalEthInWei + msg.value;
129         uint256 amount = msg.value * unitsOneEthCanBuy;
130         require(balances[fundsWallet] >= amount);
131 
132         balances[fundsWallet] = balances[fundsWallet] - amount;
133         balances[msg.sender] = balances[msg.sender] + amount;
134 
135         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
136 
137         //Transfer ether to fundsWallet
138         fundsWallet.transfer(msg.value);                               
139     }
140 
141     /* Approves and then calls the receiving contract */
142     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
143         allowed[msg.sender][_spender] = _value;
144         Approval(msg.sender, _spender, _value);
145 
146         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
147         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
148         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
149         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
150         return true;
151     }
152 }