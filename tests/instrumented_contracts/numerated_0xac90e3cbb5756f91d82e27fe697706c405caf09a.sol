1 pragma solidity ^0.4.16;
2 contract Token{
3     uint256 public totalSupply;
4 
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns   
8     (bool success);
9 
10     function approve(address _spender, uint256 _value) public returns (bool success);
11 
12     function allowance(address _owner, address _spender) public constant returns 
13     (uint256 remaining);
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 
17     _value);
18 }
19 
20 contract TokenXxg is Token {
21 
22     string public name;        
23     uint8 public decimals;     
24     string public symbol;      
25 
26     function TokenXxg(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
27         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);  
28         balances[msg.sender] = totalSupply; 
29 
30         name = _tokenName;                   
31         decimals = _decimalUnits;          
32         symbol = _tokenSymbol;
33     }
34 
35     function transfer(address _to, uint256 _value) public returns (bool success) {
36         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
37         require(_to != 0x0);
38         balances[msg.sender] -= _value;   
39         balances[_to] += _value;          
40         Transfer(msg.sender, _to, _value);
41         return true;
42     }
43 
44 
45     function transferFrom(address _from, address _to, uint256 _value) public returns 
46     (bool success) {
47         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
48         balances[_to] += _value;              
49         balances[_from] -= _value;            
50         allowed[_from][msg.sender] -= _value; 
51         Transfer(_from, _to, _value);         
52         return true;
53     }
54     function balanceOf(address _owner) public constant returns (uint256 balance) {
55         return balances[_owner];
56     }
57 
58 
59     function approve(address _spender, uint256 _value) public returns (bool success)   
60     { 
61         allowed[msg.sender][_spender] = _value;
62         Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
67         return allowed[_owner][_spender];       
68     }
69     mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;
71 }