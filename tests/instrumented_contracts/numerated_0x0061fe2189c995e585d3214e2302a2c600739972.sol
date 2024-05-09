1 pragma solidity ^0.4.23;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
12 
13     function approve(address _spender, uint256 _value) returns (bool success) {}
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20 }
21 
22 contract StandardToken is Token {
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {
25         
26         if (balances[msg.sender] >= _value && _value > 0) {
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             Transfer(msg.sender, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
35        
36         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
37             balances[_to] += _value;
38             balances[_from] -= _value;
39             allowed[_from][msg.sender] -= _value;
40             Transfer(_from, _to, _value);
41             return true;
42         } else { return false; }
43     }
44 
45     function balanceOf(address _owner) constant returns (uint256 balance) {
46         return balances[_owner];
47     }
48 
49     function approve(address _spender, uint256 _value) returns (bool success) {
50         allowed[msg.sender][_spender] = _value;
51         Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
56       return allowed[_owner][_spender];
57     }
58 
59     mapping (address => uint256) balances;
60     mapping (address => mapping (address => uint256)) allowed;
61     uint256 public totalSupply;
62 }
63 
64 contract Rafatar is StandardToken { 
65 
66     /* Public variables of the token */
67 
68     /*
69     NOTE:
70     The following variables are OPTIONAL vanities. One does not have to include them.
71     They allow one to customise the token contract & in no way influences the core functionality.
72     Some wallets/interfaces might not even bother to look at this information.
73     */
74     string public name;                   // Token Name
75     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
76     string public symbol;                 // An identifier: eg SBX, XPR etc..
77     string public version = 'H1.0';
78     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
79     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.
80     address public fundsWallet;           // Where should the raised ETH go?
81 
82     function Rafatar() {
83         balances[msg.sender] = 11000000000000000000000000; 
84 		totalSupply = 11000000000000000000000000;
85         name = "Rafatar";
86         decimals = 18;
87         symbol = "RFTC";
88         unitsOneEthCanBuy = 32800;
89         fundsWallet = msg.sender; 
90     }
91 
92     function() public payable{
93         totalEthInWei = totalEthInWei + msg.value;
94         uint256 amount = msg.value * unitsOneEthCanBuy;
95         require(balances[fundsWallet] >= amount);
96 
97         balances[fundsWallet] = balances[fundsWallet] - amount;
98         balances[msg.sender] = balances[msg.sender] + amount;
99 
100         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
101 
102        fundsWallet.transfer(msg.value);                             
103     }
104 
105     /* Approves and then calls the receiving contract */
106     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109 
110         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
111         return true;
112     }
113 }