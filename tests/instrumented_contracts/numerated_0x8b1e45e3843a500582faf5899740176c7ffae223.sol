1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     //Basic Functions all ERC20 Tokens must adopt.
5     function totalSupply() constant returns (uint256 supply) {}
6     function balanceOf(address _owner) constant returns (uint256 balance) {}
7     function transfer(address _to, uint256 _value) returns (bool success) {}
8     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
9     function approve(address _spender, uint256 _value) returns (bool success) {}
10     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 
15 }
16 
17 contract StandardToken is Token {
18 
19     function transfer(address _to, uint256 _value) returns (bool success) {
20         if (balances[msg.sender] >= _value && _value > 0) {
21             balances[msg.sender] -= _value;
22             balances[_to] += _value;
23             Transfer(msg.sender, _to, _value);
24             return true;
25         } else{
26             return false;
27         }
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
59 contract BitMamaShares is StandardToken {
60     string public name;
61     uint8 public decimals;
62     string public symbol;
63     string public version = "BM1.0";
64     uint256 public unitsOneEthCanBuy;
65     uint256 public totalEthInWei;
66     address public fundsWallet;
67 
68     
69     function BitMamaShares() {
70         balances[msg.sender] = 1000000000000000000000000;
71         totalSupply = 1000000000000000000000000;
72         name = "BitMamaShares";
73         decimals = 18;
74         symbol = "BMS";
75         unitsOneEthCanBuy = 1000;
76         fundsWallet = msg.sender;
77     }
78 
79     function() payable {
80         totalEthInWei = totalEthInWei + msg.value;
81         uint256 amount = msg.value * unitsOneEthCanBuy;
82         if (balances[fundsWallet] < amount) {
83             return;
84         }
85 
86         balances[fundsWallet] = balances[fundsWallet] - amount;
87         balances[msg.sender] = balances[msg.sender] + amount;
88 
89         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
90 
91         //Transfer ether to fundsWallet
92         fundsWallet.transfer(msg.value);                               
93     }
94 
95     
96     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
97         allowed[msg.sender][_spender] = _value;
98         Approval(msg.sender, _spender, _value);
99         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
100         return true;
101     }
102 
103     //Developed by Umar Mash
104 }