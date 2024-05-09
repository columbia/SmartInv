1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6     function balanceOf(address _owner) constant returns (uint256 balance) {}
7     function transfer(address _to, uint256 _value) returns (bool success) {}
8     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
9     function approve(address _spender, uint256 _value) returns (bool success) {}
10     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 
14 }
15 
16 contract StandardToken is Token {
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {
19 	
20         if (balances[msg.sender] >= _value && _value > 0) {
21 		
22             balances[msg.sender] -= _value;
23             balances[_to] += _value;
24             Transfer(msg.sender, _to, _value);
25             return true;
26 
27         } else { return false; }
28     }
29 
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
31 	
32         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
33 		
34             balances[_to] += _value;
35             balances[_from] -= _value;
36             allowed[_from][msg.sender] -= _value;
37             Transfer(_from, _to, _value);
38             return true;
39 			
40         } else { return false; }
41     }
42 
43     function balanceOf(address _owner) constant returns (uint256 balance) {
44 	
45         return balances[_owner];
46     }
47 
48     function approve(address _spender, uint256 _value) returns (bool success) {
49 	
50         allowed[msg.sender][_spender] = _value;
51         Approval(msg.sender, _spender, _value);
52         return true;
53 		
54     }
55 
56     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
57 	
58       return allowed[_owner][_spender];
59 	  
60     }
61 
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64     uint256 public totalSupply;
65 }
66 
67 contract DazzioCoin is StandardToken {
68 
69     /* Public variables of the token */
70 
71     string public name;
72     uint8 public decimals;
73     string public symbol;
74     string public version = 'H1.0'; 
75     uint256 public unitsOneEthCanBuy;
76     uint256 public totalEthInWei;
77     address public fundsWallet;
78 
79     function DazzioCoin() {
80 	
81         balances[msg.sender] = 5000000000000000000000000;        // Total supply goes to the contract creator
82         totalSupply = 5000000000000000000000000;                 // Total token supply
83         name = "DazzioCoin";                                     // Token display name
84         decimals = 18;
85         symbol = "DAZZ";                                         // Token symbol
86         unitsOneEthCanBuy = 1000;                                // Tokens per ETH
87         fundsWallet = msg.sender;                                // ETH goes to the contract address
88 		
89     }
90 
91     function() payable{
92         
93 		totalEthInWei = totalEthInWei + msg.value;
94         uint256 amount = msg.value * unitsOneEthCanBuy;
95         require(balances[fundsWallet] >= amount);
96         balances[fundsWallet] = balances[fundsWallet] - amount;
97         balances[msg.sender] = balances[msg.sender] + amount;
98         Transfer(fundsWallet, msg.sender, amount);
99         fundsWallet.transfer(msg.value);
100 		
101     }
102 
103     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
104 	
105         allowed[msg.sender][_spender] = _value;
106         Approval(msg.sender, _spender, _value);
107 
108         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
109         return true;
110     }
111 }