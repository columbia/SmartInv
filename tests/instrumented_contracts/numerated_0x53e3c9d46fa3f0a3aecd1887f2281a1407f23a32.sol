1 pragma solidity ^0.4.16;
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
14   contract PayBits is ERC20 {
15      string public constant symbol = "PYB";
16      string public constant name = "PayBits";
17      uint8 public constant decimals = 18;
18      uint256 _totalSupply = 21000000 * 10**18;
19      
20 
21      address public owner;
22   
23      mapping(address => uint256) balances;
24   
25      mapping(address => mapping (address => uint256)) allowed;
26      
27   
28      function PayBits() {
29          owner = msg.sender;
30          balances[owner] = 21000000 * 10**18;
31      }
32      
33      modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37      
38   
39      function totalSupply() constant returns (uint256 totalSupply) {
40          totalSupply = _totalSupply;
41      }
42   
43 
44      function balanceOf(address _owner) constant returns (uint256 balance) {
45         return balances[_owner];
46      }
47  
48      function transfer(address _to, uint256 _amount) returns (bool success) {
49          if (balances[msg.sender] >= _amount 
50             && _amount > 0
51              && balances[_to] + _amount > balances[_to]) {
52              balances[msg.sender] -= _amount;
53              balances[_to] += _amount;
54              Transfer(msg.sender, _to, _amount);
55             return true;
56          } else {
57              return false;
58          }
59      }
60      
61      
62      function transferFrom(
63          address _from,
64          address _to,
65          uint256 _amount
66      ) returns (bool success) {
67          if (balances[_from] >= _amount
68              && allowed[_from][msg.sender] >= _amount
69              && _amount > 0
70              && balances[_to] + _amount > balances[_to]) {
71              balances[_from] -= _amount;
72              allowed[_from][msg.sender] -= _amount;
73              balances[_to] += _amount;
74              Transfer(_from, _to, _amount);
75              return true;
76          } else {
77             return false;
78          }
79      }
80  
81      function approve(address _spender, uint256 _amount) returns (bool success) {
82          allowed[msg.sender][_spender] = _amount;
83         Approval(msg.sender, _spender, _amount);
84          return true;
85      }
86   
87      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
88          return allowed[_owner][_spender];
89     }
90 }