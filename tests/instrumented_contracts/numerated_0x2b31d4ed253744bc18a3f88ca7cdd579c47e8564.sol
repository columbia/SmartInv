1 pragma solidity ^0.4.23;
2 
3 //* This is the Main Contract For Mjolnir Token
4 //* All of the function have been tested by Mjolnir Devs
5 
6 // contract Token Loaded from .../localdata/Mjolnir.sol
7 // contract StandardToken Loaded from .../localdata/StandardToken.sol
8 // approveAndCall Loaded from .../localdata/approveAndCall.sol
9 
10 contract Token {
11 
12     function totalSupply() constant returns (uint256 supply) {}
13 
14     function balanceOf(address _owner) constant returns (uint256 balance) {}
15 
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
19 
20     function approve(address _spender, uint256 _value) returns (bool success) {}
21 
22     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
23 
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 
27 }
28 
29 contract StandardToken is Token {
30 
31     function transfer(address _to, uint256 _value) returns (bool success) {
32         
33         if (balances[msg.sender] >= _value && _value > 0) {
34             balances[msg.sender] -= _value;
35             balances[_to] += _value;
36             Transfer(msg.sender, _to, _value);
37             return true;
38         } else { return false; }
39     }
40 
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
42         
43         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
44             balances[_to] += _value;
45             balances[_from] -= _value;
46             allowed[_from][msg.sender] -= _value;
47             Transfer(_from, _to, _value);
48             return true;
49         } else { return false; }
50     }
51 
52     function balanceOf(address _owner) constant returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56     function approve(address _spender, uint256 _value) returns (bool success) {
57         allowed[msg.sender][_spender] = _value;
58         Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
63       return allowed[_owner][_spender];
64     }
65 
66     mapping (address => uint256) balances;
67     mapping (address => mapping (address => uint256)) allowed;
68     uint256 public totalSupply;
69 }
70 
71 contract Mjolnir is StandardToken { 
72     
73     string public name;                   
74     uint8 public decimals;                
75     string public symbol;                 
76     string public version = 'H1.0'; 
77     uint256 public unitsOneEthCanBuy;     
78     uint256 public totalEthInWei;          
79     address public fundsWallet;          
80 
81     function Mjolnir() {
82         balances[msg.sender] = 128192000000000000000000;              
83         totalSupply = 128192000000000000000000;                 
84         name = "Mjolnir";                                  
85         decimals = 18;                          
86         symbol = "MJG";                                 
87         unitsOneEthCanBuy = 2000;                            
88         fundsWallet = msg.sender;                    
89     }
90 
91     function() public payable{
92         totalEthInWei = totalEthInWei + msg.value;
93         uint256 amount = msg.value * unitsOneEthCanBuy;
94         require(balances[fundsWallet] >= amount);
95 
96         balances[fundsWallet] = balances[fundsWallet] - amount;
97         balances[msg.sender] = balances[msg.sender] + amount;
98 
99         Transfer(fundsWallet, msg.sender, amount);
100 
101         fundsWallet.transfer(msg.value);                               
102     }
103     
104     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
105         allowed[msg.sender][_spender] = _value;
106         Approval(msg.sender, _spender, _value);
107 
108         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
109         return true;
110     }
111 }
112 
113 //* All the Git Code was provided by Ethereum.org and modified by Mjolnir Developer