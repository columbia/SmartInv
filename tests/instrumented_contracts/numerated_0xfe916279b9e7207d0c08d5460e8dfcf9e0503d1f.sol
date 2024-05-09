1 pragma solidity ^0.4.18;
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
21 contract StandardToken is Token {
22 
23     function transfer(address _to, uint256 _value) returns (bool success) {        
24         if (balances[msg.sender] >= _value && _value > 0) {
25             balances[msg.sender] -= _value;
26             balances[_to] += _value;
27             Transfer(msg.sender, _to, _value);
28             return true;
29         } else { return false; }
30     }
31 
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
33         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
34             balances[_to] += _value;
35             balances[_from] -= _value;
36             allowed[_from][msg.sender] -= _value;
37             Transfer(_from, _to, _value);
38             return true;
39         } else { return false; }
40     }
41 
42     function balanceOf(address _owner) constant returns (uint256 balance) {
43         return balances[_owner];
44     }
45 
46     function approve(address _spender, uint256 _value) returns (bool success) {
47         allowed[msg.sender][_spender] = _value;
48         Approval(msg.sender, _spender, _value);
49         return true;
50     }
51 
52     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
53       return allowed[_owner][_spender];
54     }
55 
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;
58     uint256 public totalSupply;
59 }
60 contract GoldenLightChainToken is StandardToken {
61 
62     function () {
63         throw;
64     }
65 
66     string public name;                   
67     uint8 public decimals;               
68     string public symbol;                 
69     string public version = 'H0.1';       
70 
71     function GoldenLightChainToken(
72         uint256 _initialAmount,
73         string _tokenName,
74         uint8 _decimalUnits,
75         string _tokenSymbol
76         ) {
77         balances[msg.sender] = _initialAmount;               
78         totalSupply = _initialAmount;                        
79         name = _tokenName;                                   
80         decimals = _decimalUnits;                            
81         symbol = _tokenSymbol;                               
82     }
83 
84     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);        
87         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
88         return true;
89     }
90 }