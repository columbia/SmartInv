1 pragma solidity ^0.4.8;
2 
3 interface ERC20Interface {
4 
5     function totalSupply() constant returns (uint256 totalSupply) ;
6     
7     function balanceOf(address _owner) constant returns (uint256 balance);
8     
9     function transfer(address _to, uint256 _value) returns (bool success);
10     
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
12     
13     function approve(address _spender, uint256 _value) returns (bool success);
14     
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
16     
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20     
21  }
22   
23  contract ElPetro is ERC20Interface {
24       string public constant symbol = "PTRS";
25       string public constant name = "El Petro";
26       uint8 public constant decimals = 8;
27       uint256 _totalSupply = 10000000000000000;
28  
29       address public owner;
30    
31       mapping(address => uint256) balances;
32    
33  
34       mapping(address => mapping (address => uint256)) allowed;
35    
36       
37       modifier onlyOwner() {
38           if (msg.sender != owner) {
39               throw;
40           }
41           _;
42       }
43    
44       function ElPetro() {
45           owner = msg.sender;
46           balances[owner] = _totalSupply;
47       }
48    
49       function totalSupply() constant returns (uint256 totalSupply) {
50           totalSupply = _totalSupply;
51       }
52    
53       function balanceOf(address _owner) constant returns (uint256 balance) {
54           return balances[_owner];
55       }
56    
57       function transfer(address _to, uint256 _amount) returns (bool success) {
58           if (balances[msg.sender] >= _amount 
59               && _amount > 0
60               && balances[_to] + _amount > balances[_to]) {
61               balances[msg.sender] -= _amount;
62               balances[_to] += _amount;
63               Transfer(msg.sender, _to, _amount);
64               return true;
65           } else {
66               return false;
67           }
68       }
69    
70       function transferFrom(
71           address _from,
72           address _to,
73           uint256 _amount
74      ) returns (bool success) {
75          if (balances[_from] >= _amount
76              && allowed[_from][msg.sender] >= _amount
77              && _amount > 0
78              && balances[_to] + _amount > balances[_to]) {
79              balances[_from] -= _amount;
80              allowed[_from][msg.sender] -= _amount;
81              balances[_to] += _amount;
82              Transfer(_from, _to, _amount);
83              return true;
84          } else {
85              return false;
86          }
87      }
88 
89      function approve(address _spender, uint256 _amount) returns (bool success) {
90          allowed[msg.sender][_spender] = _amount;
91          Approval(msg.sender, _spender, _amount);
92          return true;
93      }
94   
95      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
96          return allowed[_owner][_spender];
97      }
98  }