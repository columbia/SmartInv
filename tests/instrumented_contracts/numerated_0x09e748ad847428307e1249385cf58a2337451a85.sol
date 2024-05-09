1 pragma solidity ^0.4.4;
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
18 
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 }
21 
22 contract StandardToken is Token {
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {        
25         if (balances[msg.sender] >= _value && _value > 0) {
26             balances[msg.sender] -= _value;
27             balances[_to] += _value;
28             Transfer(msg.sender, _to, _value);
29             return true;
30         } else { return false; }
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
34         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
35             balances[_to] += _value;
36             balances[_from] -= _value;
37             allowed[_from][msg.sender] -= _value;
38             Transfer(_from, _to, _value);
39             return true;
40         } else { return false; }
41     }
42 
43     function balanceOf(address _owner) constant returns (uint256 balance) {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint256 _value) returns (bool success) {
48         allowed[msg.sender][_spender] = _value;
49         Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
54       return allowed[_owner][_spender];
55     }
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     uint256 public totalSupply;
60 }
61 
62 contract StrayAnimalCoin is StandardToken {
63 
64     function () {
65         throw;
66     }
67 
68     string public name;                   
69     uint8 public decimals;               
70     string public symbol;                 
71     string public version = 'H0.1';       
72 
73     function StrayAnimalCoin(
74         uint256 _initialAmount,
75         string _tokenName,
76         uint8 _decimalUnits,
77         string _tokenSymbol
78         ) {
79         balances[msg.sender] = _initialAmount;               
80         totalSupply = _initialAmount;                        
81         name = _tokenName;                                   
82         decimals = _decimalUnits;                            
83         symbol = _tokenSymbol;                               
84     }
85 
86     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);        
89         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
90         return true;
91     }
92 }