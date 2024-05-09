1 pragma solidity ^0.4.8;
2 contract Token{
3     
4     uint256 public totalSupply;
5     
6     function balanceOf(address _owner) constant returns (uint256 balance);
7 
8     function transfer(address _to, uint256 _value) returns (bool success);
9     
10     function transferFrom(address _from, address _to, uint256 _value) returns   
11     (bool success);
12 
13     function approve(address _spender, uint256 _value) returns (bool success);
14 
15     function allowance(address _owner, address _spender) constant returns 
16     (uint256 remaining);
17     
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19 
20     event Approval(address indexed _owner, address indexed _spender, uint256 
21     _value);
22 }
23 
24 contract StandardToken is Token {
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         require(balances[msg.sender] >= _value);
27         balances[msg.sender] -= _value;
28         balances[_to] += _value;
29         Transfer(msg.sender, _to, _value);
30         return true;
31     }
32     function transferFrom(address _from, address _to, uint256 _value) returns 
33     (bool success) {
34         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
35         balances[_to] += _value;
36         balances[_from] -= _value;
37         allowed[_from][msg.sender] -= _value;
38         Transfer(_from, _to, _value);
39         return true;
40     }
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44     function approve(address _spender, uint256 _value) returns (bool success)   
45     {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
51         return allowed[_owner][_spender];
52     }
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55 }
56 
57 contract HumanStandardToken is StandardToken { 
58     string public name;                   
59     uint8 public decimals;              
60     string public symbol;           
61     string public version = 'H0.1'; 
62 
63     function HumanStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
64         balances[msg.sender] = _initialAmount; 
65         totalSupply = _initialAmount;         
66         name = _tokenName;                   
67         decimals = _decimalUnits;           
68         symbol = _tokenSymbol;             
69     }
70     
71     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
72         allowed[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
75         return true;
76     }
77 
78 }