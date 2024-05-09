1 /**
2  *Submitted for verification at Etherscan.io on 2017-06-19
3 */
4 
5 pragma solidity ^0.4.11;
6  
7 contract Token {
8     string public symbol = "";
9     string public name = "";
10     uint8 public constant decimals = 18;
11     uint256 _totalSupply = 0;
12     address owner = 0;
13     bool setupDone = false;
14    
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17  
18     mapping(address => uint256) balances;
19  
20     mapping(address => mapping (address => uint256)) allowed;
21  
22     function Token(address adr) {
23         owner = adr;        
24     }
25    
26     function SetupToken(string tokenName, string tokenSymbol, uint256 tokenSupply)
27     {
28         if (msg.sender == owner && setupDone == false)
29         {
30             symbol = tokenSymbol;
31             name = tokenName;
32             _totalSupply = tokenSupply * 1000000000000000000;
33             balances[owner] = _totalSupply;
34             setupDone = true;
35         }
36     }
37  
38     function totalSupply() constant returns (uint256 totalSupply) {        
39         return _totalSupply;
40     }
41  
42     function balanceOf(address _owner) constant returns (uint256 balance) {
43         return balances[_owner];
44     }
45  
46     function transfer(address _to, uint256 _amount) returns (bool success) {
47         if (balances[msg.sender] >= _amount
48             && _amount > 0
49             && balances[_to] + _amount > balances[_to]) {
50             balances[msg.sender] -= _amount;
51             balances[_to] += _amount;
52             Transfer(msg.sender, _to, _amount);
53             return true;
54         } else {
55             return false;
56         }
57     }
58  
59     function transferFrom(
60         address _from,
61         address _to,
62         uint256 _amount
63     ) returns (bool success) {
64         if (balances[_from] >= _amount
65             && allowed[_from][msg.sender] >= _amount
66             && _amount > 0
67             && balances[_to] + _amount > balances[_to]) {
68             balances[_from] -= _amount;
69             allowed[_from][msg.sender] -= _amount;
70             balances[_to] += _amount;
71             Transfer(_from, _to, _amount);
72             return true;
73         } else {
74             return false;
75         }
76     }
77  
78     function approve(address _spender, uint256 _amount) returns (bool success) {
79         allowed[msg.sender][_spender] = _amount;
80         Approval(msg.sender, _spender, _amount);
81         return true;
82     }
83  
84     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
85         return allowed[_owner][_spender];
86     }
87 }