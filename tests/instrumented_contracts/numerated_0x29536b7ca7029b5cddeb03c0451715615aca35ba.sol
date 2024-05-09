1 pragma solidity ^0.4.8;
2 
3 
4   contract ToutiaoERC20 {
5       function totalSupply() constant returns (uint256 totalSupply);
6 
7       function balanceOf(address _owner) constant returns (uint256 balance);
8 
9       function transfer(address _to, uint256 _value) returns (bool success);
10 
11       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
12 
13       function approve(address _spender, uint256 _value) returns (bool success);
14 
15       function allowance(address _owner, address _spender) constant returns (uint256 remaining);
16 
17       event Transfer(address indexed _from, address indexed _to, uint256 _value);
18 
19       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20   }
21 
22    contract NewOSToken is ToutiaoERC20 {
23       string public constant symbol = "NEWOS"; 
24       string public constant name = "NewOS Token"; 
25       uint8 public constant decimals = 8; 
26       uint256 _totalSupply = 10000000000e8; 
27 
28       address public owner;
29 
30       mapping(address => uint256) balances;
31 
32       mapping(address => mapping (address => uint256)) allowed;
33 
34       modifier onlyOwner() {
35           assert (msg.sender == owner);
36           _;
37       }
38 
39       constructor() {
40           owner = msg.sender;
41           balances[owner] = _totalSupply;
42       }
43 
44       function totalSupply() constant returns (uint256 totalSupply) {
45           totalSupply = _totalSupply;
46       }
47 
48       function balanceOf(address _owner) constant returns (uint256 balance) {
49           return balances[_owner];
50       }
51 
52       function transfer(address _to, uint256 _amount) returns (bool success) {
53           if (balances[msg.sender] >= _amount 
54               && _amount > 0
55               && balances[_to] + _amount > balances[_to]) {
56               balances[msg.sender] -= _amount;
57               balances[_to] += _amount;
58               Transfer(msg.sender, _to, _amount);
59               return true;
60           } else {
61               return false;
62           }
63       }
64 
65       function transferFrom(
66           address _from,
67           address _to,
68           uint256 _amount
69       ) returns (bool success) {
70           if (balances[_from] >= _amount 
71               && allowed[_from][msg.sender] >= _amount
72               && _amount > 0
73               && balances[_to] + _amount > balances[_to]) {
74               balances[_from] -= _amount;
75               allowed[_from][msg.sender] -= _amount;
76               balances[_to] += _amount;
77               Transfer(_from, _to, _amount);
78               return true;
79           } else {
80               return false;
81           }
82       }
83 
84       function approve(address _spender, uint256 _amount) returns (bool success) {
85           allowed[msg.sender][_spender] = _amount;
86           Approval(msg.sender, _spender, _amount);
87           return true;
88       }
89 
90       function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91           return allowed[_owner][_spender];
92       }
93   }