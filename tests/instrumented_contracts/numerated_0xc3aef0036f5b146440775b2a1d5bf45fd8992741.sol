1 pragma solidity ^0.4.18;
2 
3 
4 contract Token {
5     
6     
7     uint256 public totalSupply;
8 
9     function balanceOf(address _owner) public view returns (uint256 balance);
10 
11     function transfer(address _to, uint256 _value) public returns (bool success);
12 
13     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
14 
15     function approve(address _spender, uint256 _value) public returns (bool success);
16 
17     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
18 
19     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21 }
22 
23 contract ROICOIN is Token {
24 
25     
26     mapping (address => uint256) public balances;
27     mapping (address => mapping (address => uint256)) public allowed;
28    
29     string public name;                   
30     uint8 public decimals;               
31     string public symbol;                
32 
33     function ROICOIN(
34         uint256 _initialAmount,
35         string _tokenName,
36         uint8 _decimalUnits,
37         string _tokenSymbol
38     ) public {
39         name = _tokenName;                                   
40         decimals = _decimalUnits;                            
41         symbol = _tokenSymbol;  
42         totalSupply = _initialAmount * 10 ** uint256(decimals); 
43         balances[msg.sender] = totalSupply; 
44     }
45 
46     function transfer(address _to, uint256 _value) public returns (bool success) {
47         
48         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to] && _value > 0)
49         {
50             balances[msg.sender] -= _value;
51             balances[_to] += _value;
52             Transfer(msg.sender, _to, _value);
53             return true;
54         }
55         else
56         {
57             return false;
58         }
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
62        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value  && balances[_to] + _value > balances[_to] && _value > 0) {
63             balances[_to] += _value;
64             Transfer(_from, _to, _value);
65             balances[_from] -= _value;
66             allowed[_from][msg.sender] -= _value;
67             return true;
68         } else { return false; }
69     }
70 
71     function balanceOf(address _owner) public view returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75     function approve(address _spender, uint256 _value) public returns (bool success) {
76         
77        if (balances[msg.sender] >= _value && balances[msg.sender] >= allowed[msg.sender][_spender] + _value && _value > 0)
78         {
79              allowed[msg.sender][_spender] += _value;
80              Approval(msg.sender, _spender, _value);
81              return true;
82         }
83           else
84         {
85             return false;
86         }
87     }
88 
89     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
90             return allowed[_owner][_spender];
91     }   
92 }