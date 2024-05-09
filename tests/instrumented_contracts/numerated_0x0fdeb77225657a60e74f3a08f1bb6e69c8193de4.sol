1 pragma solidity ^0.4.4;
2 
3     contract ERC20 {
4      function totalSupply() constant returns (uint256 totalSupply);
5      function balanceOf(address _owner) constant returns (uint256 balance);
6      function transfer(address _to, uint256 _value) returns (bool success);
7      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8      function approve(address _spender, uint256 _value) returns (bool success);
9      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10      event Transfer(address indexed _from, address indexed _to, uint256 _value);
11      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12  }
13   
14   contract CoinAndCommunity is ERC20 {
15      string public constant symbol = "CAC";
16      string public constant name = "CoinAndCommunity";
17      uint8 public constant decimals = 0;
18      uint256 _totalSupply = 21000000 * 10**8;
19      
20 
21      address public owner;
22   
23      mapping(address => uint256) balances;
24   
25      mapping(address => mapping (address => uint256)) allowed;
26      
27   
28      function CAC() {
29          owner = msg.sender;
30          balances[owner] = 21000000 * 10**8;
31      }
32      
33      
34   
35      function totalSupply() constant returns (uint256 totalSupply) {
36          totalSupply = _totalSupply;
37      }
38   
39 
40      function balanceOf(address _owner) constant returns (uint256 balance) {
41         return balances[_owner];
42      }
43  
44      function transfer(address _to, uint256 _amount) returns (bool success) {
45          if (balances[msg.sender] >= _amount 
46             && _amount > 0
47              && balances[_to] + _amount > balances[_to]) {
48              balances[msg.sender] -= _amount;
49              balances[_to] += _amount;
50              Transfer(msg.sender, _to, _amount);
51             return true;
52          } else {
53              return false;
54          }
55      }
56      
57      
58      function transferFrom(
59          address _from,
60          address _to,
61          uint256 _amount
62      ) returns (bool success) {
63          if (balances[_from] >= _amount
64              && allowed[_from][msg.sender] >= _amount
65              && _amount > 0
66              && balances[_to] + _amount > balances[_to]) {
67              balances[_from] -= _amount;
68              allowed[_from][msg.sender] -= _amount;
69              balances[_to] += _amount;
70              Transfer(_from, _to, _amount);
71              return true;
72          } else {
73             return false;
74          }
75      }
76  
77      function approve(address _spender, uint256 _amount) returns (bool success) {
78          allowed[msg.sender][_spender] = _amount;
79         Approval(msg.sender, _spender, _amount);
80          return true;
81      }
82   
83      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84          return allowed[_owner][_spender];
85     }
86 }