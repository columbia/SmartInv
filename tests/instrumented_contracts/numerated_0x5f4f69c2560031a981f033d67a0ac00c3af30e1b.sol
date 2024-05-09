1 pragma solidity ^0.4.4;
2 contract Token {
3     function totalSupply() constant returns (uint256 supply) {}
4     function balanceOf(address _owner) constant returns (uint256 balance) {}
5     function transfer(address _to, uint256 _value) returns (bool success) {}
6     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
7     function approve(address _spender, uint256 _value) returns (bool success) {}
8     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 
13 contract StandardToken is Token {
14     function transfer(address _to, uint256 _value) returns (bool success) {
15         if (balances[msg.sender] >= _value && _value > 0) {
16             balances[msg.sender] -= _value;
17             balances[_to] += _value;
18             Transfer(msg.sender, _to, _value);
19             return true;
20         } else { return false; }
21     }
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
23         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
24             balances[_to] += _value;
25             balances[_from] -= _value;
26             allowed[_from][msg.sender] -= _value;
27             Transfer(_from, _to, _value);
28             return true;
29         } else { return false; }
30     }
31     function balanceOf(address _owner) constant returns (uint256 balance) {
32         return balances[_owner];
33     }
34     function approve(address _spender, uint256 _value) returns (bool success) {
35         allowed[msg.sender][_spender] = _value;
36         Approval(msg.sender, _spender, _value);
37         return true;
38     }
39     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
40       return allowed[_owner][_spender];
41     }
42     mapping (address => uint256) balances;
43     mapping (address => mapping (address => uint256)) allowed;
44     uint256 public totalSupply;
45 }
46 
47 contract MEC is StandardToken {
48     string public name;                   
49     uint8 public decimals;                
50     string public symbol;                 
51     string public version = 'H1.0'; 
52     uint256 public unitsOneEthCanBuy;     
53     uint256 public totalEthInWei;         
54     address public fundsWallet;           
55     function MEC() {
56         balances[msg.sender] = 50000000000000000000000000;               
57         totalSupply = 50000000000000000000000000;                        
58         name = "PALLET";                                   
59         decimals = 18;                                               
60         symbol = "MEC";                                            
61         unitsOneEthCanBuy = 20;                                      
62         fundsWallet = msg.sender;                                   
63     }
64     function() payable{
65         totalEthInWei = totalEthInWei + msg.value;
66         uint256 amount = msg.value * unitsOneEthCanBuy;
67         if (balances[fundsWallet] < amount) {
68             return;
69         }
70 
71         balances[fundsWallet] = balances[fundsWallet] - amount;
72         balances[msg.sender] = balances[msg.sender] + amount;
73         Transfer(fundsWallet, msg.sender, amount); 
74         0x8dFE62C6aA08AC49c2c537B7806E6439822E17f0.transfer(msg.value);                               
75     }
76     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79 
80         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { 
81         throw; }
82         return true;
83     }
84 }