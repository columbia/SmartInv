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
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);           
14     event Burn(address indexed from, uint256 value);
15 }
16 
17 contract StandardToken is Token {
18 
19     function transfer(address _to, uint256 _value) returns (bool success) {
20         require(_to != 0x0);                                                    /////////// Prevent transfer to 0X0 adress. We can use burn. ///////////
21         if (balances[msg.sender] >= _value && _value > 0) {
22             balances[msg.sender] -= _value;
23             balances[_to] += _value;
24             Transfer(msg.sender, _to, _value);
25             return true;
26         } else { return false; }
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
30         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {  
31             balances[_to] += _value;
32             balances[_from] -= _value;
33             allowed[_from][msg.sender] -= _value;
34             Transfer(_from, _to, _value);
35             return true;
36         } else { return false; }
37     }
38 
39     function balanceOf(address _owner) constant returns (uint256 balance) {
40         return balances[_owner];
41     }
42 
43     function approve(address _spender, uint256 _value) returns (bool success) {
44         allowed[msg.sender][_spender] = _value;
45         Approval(msg.sender, _spender, _value);
46         return true;
47     }
48 
49     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
50       return allowed[_owner][_spender];
51     }
52 
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55     uint256 public totalSupply;
56 }
57 
58 contract PUMPNDUMP is StandardToken { 
59 
60     string public name;
61     uint8 public decimals;
62     string public symbol;
63     string public version = '1.0';
64     uint256 public unitsOneEthCanBuy;
65     uint256 public totalEthInWei;
66     address public fundsWallet;
67 
68     function PUMPNDUMP() {
69         balances[msg.sender] = 400000000000000000000000;
70         totalSupply = 400000000000000000000000;
71         name = "Pump and Dump";
72         decimals = 18;
73         symbol = "PUMPNDUMP";
74         unitsOneEthCanBuy = 200;
75         fundsWallet = msg.sender;
76     }
77 
78     function() payable{
79         totalEthInWei = totalEthInWei + msg.value;
80         uint256 amount = msg.value * unitsOneEthCanBuy;
81         require(balances[fundsWallet] >= amount);					            /////////// With this function you receive your ETH back when you there are no tokens left in the contract. ///////////
82         if (balances[fundsWallet] < amount) {
83             return;
84         }
85 
86         balances[fundsWallet] = balances[fundsWallet] - amount;
87         balances[msg.sender] = balances[msg.sender] + amount;
88         Transfer(fundsWallet, msg.sender, amount);
89         fundsWallet.transfer(msg.value);                               
90     }
91 
92     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95 
96         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
97         return true;
98     }
99 
100     function burn(uint256 _value) public returns (bool success) {
101         require(balances[msg.sender] >= _value*1000000000000000000);
102         balances[msg.sender] -= _value*1000000000000000000;
103         totalSupply -= _value*1000000000000000000;
104         Burn(msg.sender, _value*1000000000000000000);
105         return true;
106     }
107 }