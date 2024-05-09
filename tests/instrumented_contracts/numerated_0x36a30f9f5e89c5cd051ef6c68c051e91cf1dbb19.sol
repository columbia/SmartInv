1 pragma solidity ^0.4.20;
2 
3 contract Token {
4 
5     
6     function totalSupply() constant returns (uint256 supply) {}
7 
8    
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11    
12     function transfer(address _to, uint256 _value) returns (bool success) {}
13 
14     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
15 
16     
17     function approve(address _spender, uint256 _value) returns (bool success) {}
18 
19     
20     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
21 
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 
25 }
26 
27 contract StandardToken is Token {
28 
29     function transfer(address _to, uint256 _value) returns (bool success) {
30         //Default assumes totalSupply can't be over max (2^256 - 1).
31         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
32         //Replace the if with this one instead.
33         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
34         if (balances[msg.sender] >= _value && _value > 0) {
35             balances[msg.sender] -= _value;
36             balances[_to] += _value;
37             Transfer(msg.sender, _to, _value);
38             return true;
39         } else { return false; }
40     }
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
42         //same as above. Replace this line with the following if you want to protect against wrapping uints.
43         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
44       
45             balances[_to] += _value;
46             balances[_from] -= _value;
47             allowed[_from][msg.sender] -= _value;
48             Transfer(_from, _to, _value);
49             return true;
50         } else { return false; }
51     }
52 
53     function balanceOf(address _owner) constant returns (uint256 balance) {
54         return balances[_owner];
55     }
56 
57     function approve(address _spender, uint256 _value) returns (bool success) {
58         allowed[msg.sender][_spender] = _value;
59         Approval(msg.sender, _spender, _value);
60         return true;
61     }
62 
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
64       return allowed[_owner][_spender];
65     }
66 
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69     uint256 public totalSupply;
70 }
71 
72 contract DigitalPesoCoin is StandardToken { // CHANGE THIS. Update the contract name.
73 
74     
75     string public name;                   // Token Name
76     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
77     string public symbol;                 // An identifier: eg SBX, XPR etc..
78     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
79     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
80     address public fundsWallet;           // Where should the raised ETH go?
81 
82     function DigitalPesoCoin() {
83         balances[msg.sender] = 10000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
84         totalSupply = 10000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
85         name = "DigitalPesoCoin";                                   // Set the name for display purposes (CHANGE THIS)
86         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
87         symbol = "DPC";                                             // Set the symbol for display purposes (CHANGE THIS)
88         unitsOneEthCanBuy = 2300;                                      // Set the price of your token for the ICO (CHANGE THIS)
89         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
90     }
91 
92     function() payable{
93         totalEthInWei = totalEthInWei + msg.value;
94         uint256 amount = msg.value * unitsOneEthCanBuy;
95         require(balances[fundsWallet] >= amount);
96 
97         balances[fundsWallet] = balances[fundsWallet] - amount;
98         balances[msg.sender] = balances[msg.sender] + amount;
99 
100         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
101 
102         //Transfer ether to fundsWallet
103         fundsWallet.transfer(msg.value);                               
104     }
105 
106     /* Approves and then calls the receiving contract */
107     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110 
111         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
112         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
113         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
114         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
115         return true;
116     }
117 }