1 pragma solidity ^0.4.13;
2 
3 //Bitcoin Green official / bitcoinred.io for official contracts
4 
5 contract ERC20 {
6      function totalSupply() constant returns (uint256 totalSupply);
7      function balanceOf(address _owner) constant returns (uint256 balance);
8      function transfer(address _to, uint256 _value) returns (bool success);
9      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
10      function approve(address _spender, uint256 _value) returns (bool success);
11      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
12      event Transfer(address indexed _from, address indexed _to, uint256 _value);
13      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14  }
15   
16   contract BitcoinGreen is ERC20 {
17      string public constant symbol = "BTCG";
18      string public constant name = "Bitcoin Green";
19      uint8 public constant decimals = 8;
20      uint256 _totalSupply = 10000000 * 10**8;
21      
22 
23      address public owner;
24   
25      mapping(address => uint256) balances;
26   
27      mapping(address => mapping (address => uint256)) allowed;
28      
29   
30      function BitcoinGreen() {
31          owner = msg.sender;
32          balances[owner] = _totalSupply;
33      }
34      
35      modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39      
40      
41      function distributeBTCG(uint256 _amount, address[] addresses) onlyOwner {
42          for (uint i = 0; i < addresses.length; i++) {
43              balances[owner] -= _amount * 10**8;
44              balances[addresses[i]] += _amount * 10**8;
45              Transfer(owner, addresses[i], _amount * 10**8);
46          }
47      }
48      
49   
50      function totalSupply() constant returns (uint256 totalSupply) {
51          totalSupply = _totalSupply;
52      }
53   
54 
55      function balanceOf(address _owner) constant returns (uint256 balance) {
56         return balances[_owner];
57      }
58  
59      function transfer(address _to, uint256 _amount) returns (bool success) {
60          if (balances[msg.sender] >= _amount 
61             && _amount > 0
62              && balances[_to] + _amount > balances[_to]) {
63              balances[msg.sender] -= _amount;
64              balances[_to] += _amount;
65              Transfer(msg.sender, _to, _amount);
66             return true;
67          } else {
68              return false;
69          }
70      }
71      
72      
73      function transferFrom(
74          address _from,
75          address _to,
76          uint256 _amount
77      ) returns (bool success) {
78          if (balances[_from] >= _amount
79              && allowed[_from][msg.sender] >= _amount
80              && _amount > 0
81              && balances[_to] + _amount > balances[_to]) {
82              balances[_from] -= _amount;
83              allowed[_from][msg.sender] -= _amount;
84              balances[_to] += _amount;
85              Transfer(_from, _to, _amount);
86              return true;
87          } else {
88             return false;
89          }
90      }
91  
92      function approve(address _spender, uint256 _amount) returns (bool success) {
93          allowed[msg.sender][_spender] = _amount;
94         Approval(msg.sender, _spender, _amount);
95          return true;
96      }
97   
98      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99          return allowed[_owner][_spender];
100     }
101 }