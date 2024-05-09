1 pragma solidity ^0.4.12;
2 
3 contract Token {
4 
5     /// functions
6     function totalSupply() constant returns (uint256 supply) {}
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8     function transfer(address _to, uint256 _value) returns (bool success) {}
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
10     function approve(address _spender, uint256 _value) returns (bool success) {}
11     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
12 
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 
16 }
17 
18 contract StandardToken is Token {
19 
20     function transfer(address _to, uint256 _value) returns (bool success) {
21         //Default assumes totalSupply can't be over max (2^256 - 1).
22         if (balances[msg.sender] >= _value && _value > 0) {
23             balances[msg.sender] -= _value;
24             balances[_to] += _value;
25             Transfer(msg.sender, _to, _value);
26             return true;
27         } else { return false; }
28     }
29 
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
31         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
32             balances[_to] += _value;
33             balances[_from] -= _value;
34             allowed[_from][msg.sender] -= _value;
35             Transfer(_from, _to, _value);
36             return true;
37         } else { return false; }
38     }
39 
40     function balanceOf(address _owner) constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43 
44     function approve(address _spender, uint256 _value) returns (bool success) {
45         allowed[msg.sender][_spender] = _value;
46         Approval(msg.sender, _spender, _value);
47         return true;
48     }
49 
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
51       return allowed[_owner][_spender];
52     }
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;
56     uint256 public totalSupply;
57 }
58 
59 contract RepublicOfKosovoCoin is StandardToken {
60 
61     /* Public variables of the token */
62 
63     string public name;                   // Token Name
64     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
65     string public symbol;                 // Identifier
66     string public version = 'v1.1'; 
67     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
68     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
69     address public fundsWallet;           // Where should the raised ETH go?
70 
71     // This is a constructor function 
72     // which means the following function name has to match the contract name declared above
73     function RepublicOfKosovoCoin() {
74         balances[msg.sender] = 10e27;               // Give the creator all initial tokens.
75         totalSupply = 10e27;                        // Total Supply
76         name = "Republic of Kosovo Coin";           // Set the name of token
77         decimals = 18;                              // Amount of decimals
78         symbol = "RKS";                             // Ticker symbol
79         unitsOneEthCanBuy = 5e8;                   // Set the price of your token
80         fundsWallet = msg.sender;                   // The owner of the contract gets ETH
81     }
82 
83     function() payable{
84         totalEthInWei = totalEthInWei + msg.value;
85         uint256 amount = msg.value * unitsOneEthCanBuy;
86         if (balances[fundsWallet] < amount) {
87             revert();
88         }
89 
90         balances[fundsWallet] = balances[fundsWallet] - amount;
91         balances[msg.sender] = balances[msg.sender] + amount;
92 
93         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
94 
95         //Transfer ether to fundsWallet
96         fundsWallet.transfer(msg.value);                               
97     }
98 
99     /* Approves and then calls the receiving contract */
100     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
101         allowed[msg.sender][_spender] = _value;
102         Approval(msg.sender, _spender, _value);
103 
104         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
105         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
106         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
107         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
108         return true;
109     }
110 }