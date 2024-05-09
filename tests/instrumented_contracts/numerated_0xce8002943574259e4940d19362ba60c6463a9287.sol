1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-25
3 */
4 
5 pragma solidity ^0.4.22;
6 contract Token {
7 
8     function totalSupply() constant returns (uint256 supply) {}
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10     function transfer(address _to, uint256 _value) returns (bool success) {}
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
12     function approve(address _spender, uint256 _value) returns (bool success) {}
13     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 
18 }
19 
20 contract StandardToken is Token {
21 
22     function transfer(address _to, uint256 _value) returns (bool success) {
23         if (balances[msg.sender] >= _value && _value > 0) {
24             balances[msg.sender] -= _value;
25             balances[_to] += _value;
26             Transfer(msg.sender, _to, _value);
27             return true;
28         } else { return false; }
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
32         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
33             balances[_to] += _value;
34             balances[_from] -= _value;
35             allowed[_from][msg.sender] -= _value;
36             Transfer(_from, _to, _value);
37             return true;
38         } else { return false; }
39     }
40 
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57     uint256 public totalSupply;
58 }
59 
60 contract yfkk is StandardToken { 
61     string public name;                  
62     uint8 public decimals;                
63     string public symbol;                 
64     string public version = 'H1.0';
65     uint256 public unitsOneEthCanBuy;     
66     uint256 public totalEthInWei;         
67     address public fundsWallet;           
68 
69     function yfkk () {
70         balances[msg.sender] = 10000000000000000000000;            
71         totalSupply = 10000000000000000000000 ;                     
72         name = "yearn finance kit";                                  
73         decimals = 18;                                               
74         symbol = "YFK";                                             
75         unitsOneEthCanBuy = 35;                                  
76         fundsWallet = msg.sender;                                   
77     }
78 
79     function() public payable{
80         totalEthInWei = totalEthInWei + msg.value;
81         uint256 amount = msg.value * unitsOneEthCanBuy;
82         require(balances[fundsWallet] >= amount);
83 
84         balances[fundsWallet] = balances[fundsWallet] - amount;
85         balances[msg.sender] = balances[msg.sender] + amount;
86 
87         Transfer(fundsWallet, msg.sender, amount); 
88         fundsWallet.transfer(msg.value);                             
89     }
90 
91     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94 
95         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
96         return true;
97     }
98 }