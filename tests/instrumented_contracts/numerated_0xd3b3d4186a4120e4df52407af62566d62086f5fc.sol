1 pragma solidity ^0.4.11;
2  
3 contract Token {
4     string public symbol = "";
5     string public name = "";
6     uint8 public constant decimals = 18;
7     uint256 _totalSupply = 0;
8     address owner = 0;
9     bool setupDone = false;
10    
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13  
14     mapping(address => uint256) balances;
15  
16     mapping(address => mapping (address => uint256)) allowed;
17  
18     function Token(address adr) {
19         owner = adr;        
20     }
21    
22     function SetupToken(string tokenName, string tokenSymbol, uint256 tokenSupply)
23     {
24         if (msg.sender == owner && setupDone == false)
25         {
26             symbol = tokenSymbol;
27             name = tokenName;
28             _totalSupply = tokenSupply * 1000000000000000000;
29             balances[owner] = _totalSupply;
30             setupDone = true;
31         }
32     }
33  
34     function totalSupply() constant returns (uint256 totalSupply) {        
35         return _totalSupply;
36     }
37  
38     function balanceOf(address _owner) constant returns (uint256 balance) {
39         return balances[_owner];
40     }
41  
42     function transfer(address _to, uint256 _amount) returns (bool success) {
43         if (balances[msg.sender] >= _amount
44             && _amount > 0
45             && balances[_to] + _amount > balances[_to]) {
46             balances[msg.sender] -= _amount;
47             balances[_to] += _amount;
48             Transfer(msg.sender, _to, _amount);
49             return true;
50         } else {
51             return false;
52         }
53     }
54  
55     function transferFrom(
56         address _from,
57         address _to,
58         uint256 _amount
59     ) returns (bool success) {
60         if (balances[_from] >= _amount
61             && allowed[_from][msg.sender] >= _amount
62             && _amount > 0
63             && balances[_to] + _amount > balances[_to]) {
64             balances[_from] -= _amount;
65             allowed[_from][msg.sender] -= _amount;
66             balances[_to] += _amount;
67             Transfer(_from, _to, _amount);
68             return true;
69         } else {
70             return false;
71         }
72     }
73  
74     function approve(address _spender, uint256 _amount) returns (bool success) {
75         allowed[msg.sender][_spender] = _amount;
76         Approval(msg.sender, _spender, _amount);
77         return true;
78     }
79  
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
81         return allowed[_owner][_spender];
82     }
83 }