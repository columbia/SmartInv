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
16 contract ElementalToken is Token {
17     function transfer(address _to, uint256 _value) returns (bool success) {
18         if (balances[msg.sender] >= _value && _value > 0) {
19             balances[msg.sender] -= _value;
20             balances[_to] += _value;
21             Transfer(msg.sender, _to, _value);
22             return true;
23         } else { return false; }
24     }
25 
26     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
27         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
28             balances[_to] += _value;
29             balances[_from] -= _value;
30             allowed[_from][msg.sender] -= _value;
31             Transfer(_from, _to, _value);
32             return true;
33         } else { return false; }
34     }
35 
36     function balanceOf(address _owner) constant returns (uint256 balance) {
37         return balances[_owner];
38     }
39 
40     function approve(address _spender, uint256 _value) returns (bool success) {
41         allowed[msg.sender][_spender] = _value;
42         Approval(msg.sender, _spender, _value);
43         return true;
44     }
45 
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
47       return allowed[_owner][_spender];
48     }
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;
52     uint256 public totalSupply;
53 }
54 
55 contract Elemental is ElementalToken {
56     string public name = 'Elemental';                  
57     uint8 public decimals = 18;                
58     string public symbol = 'ELEM';                 
59     string public version = '1.0'; 
60     uint256 public unitsOneEthCanBuy = 1600;    
61     uint256 public totalEthInWei;         
62     address public fundsWallet;          
63     function Elemental() {
64         balances[msg.sender] = 100000000000000000;              
65         totalSupply = 100000000000000000;
66         name = "Elemental";                                  
67         decimals = 10;                                             
68         symbol = "ELEM";                                             
69         fundsWallet = msg.sender; 
70     }
71 
72     function() payable{
73         totalEthInWei = totalEthInWei + msg.value;
74         uint256 amount = msg.value * unitsOneEthCanBuy;
75         if (balances[fundsWallet] < amount) {
76             return;
77         }
78 
79         balances[fundsWallet] = balances[fundsWallet] - amount;
80         balances[msg.sender] = balances[msg.sender] + amount;
81 
82         Transfer(fundsWallet, msg.sender, amount);
83         fundsWallet.transfer(msg.value);                               
84     }
85     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
89         return true;
90     }
91 }