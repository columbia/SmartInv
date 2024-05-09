1 pragma solidity ^0.4.4;
2 
3 
4 contract NFToken {
5 
6     function totalSupply() constant returns (uint256 supply) {}
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8     function transfer(address _to, uint256 _value) returns (bool success) {}
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
10     function approve(address _spender, uint256 _value) returns (bool success) {}
11     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 
15 }
16 
17 contract NewFinanceToken is NFToken {
18 
19     function transfer(address _to, uint256 _value) returns (bool success) {
20 
21         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
22             balances[msg.sender] -= _value;
23             balances[_to] += _value;
24             Transfer(msg.sender, _to, _value);
25             return true;
26         } else {return false;}
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
30 
31         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
32             balances[_to] += _value;
33             balances[_from] -= _value;
34             allowed[_from][msg.sender] -= _value;
35             Transfer(_from, _to, _value);
36             return true;
37         } else {return false;}
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
59 contract NFT is NewFinanceToken { 
60 
61 
62     string public name;                
63     uint8 public decimals;           
64     string public symbol;                
65     string public version = "1.0"; 
66     uint256 public unitsOneEthCanBuy;    
67     uint256 public totalEthInWei;         
68     address public fundsWallet;           
69 
70  
71     function NFT() {
72         balances[msg.sender] = 10000000000000000;               
73         totalSupply = 10000000000000000;                        
74         name = "NewFinanceToken";                                              
75         decimals = 8;                                               
76         symbol = "NFT";                                            
77                                             
78         fundsWallet = msg.sender;                                   
79                           
80     }
81     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84 
85         if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {throw;}
86         return true;
87     }
88 }