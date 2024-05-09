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
20 contract SPORT is Token {
21     
22     string public name;                  
23     uint8 public decimals;            
24     string public symbol;             
25     
26     function SPORT(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
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
40         
41         emit Transfer(msg.sender, _to, _value);
42         return true;
43     }
44 
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns 
47     (bool success) {
48         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
49         balances[_to] += _value;
50         balances[_from] -= _value;
51         allowed[_from][msg.sender] -= _value;
52         emit Transfer(_from, _to, _value);
53         return true;
54     }
55     function balanceOf(address _owner) public constant returns (uint256 balance) {
56         return balances[_owner];
57     }
58 
59 
60     function approve(address _spender, uint256 _value) public returns (bool success)   
61     { 
62         allowed[msg.sender][_spender] = _value;
63         emit Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
68         return allowed[_owner][_spender];
69     }
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72 }