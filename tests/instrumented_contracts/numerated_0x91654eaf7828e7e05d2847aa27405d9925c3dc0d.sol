1 pragma solidity ^0.4.8;
2 
3 contract ERC20Interface {    
4     function totalSupply() constant returns (uint256 totalSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 
15 contract UBCToken is ERC20Interface{
16     /* 合约初始参数*/
17     string public standard = 'Token 1.0.8';
18     string public constant name="Ubiquitous Business Credit 2.0";
19     string public constant symbol="UBC";
20     uint8 public constant decimals=10;
21     uint256 public constant _totalSupply=10000000000000000000;
22     /*相关规则交由社区监督*/
23     mapping(address => mapping (address => uint256)) allowed;
24 
25     //mapping (address => uint256) public balanceOf;
26     mapping(address => uint256) balances;
27     //mapping (address => mapping (address => uint256)) public allowance;
28     address public owner;
29     /* 全部*/
30     function UBCToken() {
31         owner = msg.sender;
32         balances[owner] = _totalSupply; 
33     }
34     
35     function totalSupply() constant returns (uint256 totalSupply) {
36           totalSupply = _totalSupply;
37     }
38     
39     /*balanceOf*/
40     function balanceOf(address _owner) constant returns (uint256 balance){
41         return balances[_owner]; 
42     }
43 
44     /* transfer */
45     function transfer(address _to, uint256 _amount) returns (bool success)  {
46        if (balances[msg.sender] >= _amount 
47               && _amount > 0
48               && balances[_to] + _amount > balances[_to]) {
49               balances[msg.sender] -= _amount;
50               balances[_to] += _amount;
51               Transfer(msg.sender, _to, _amount);
52               return true;
53           } else {
54               return false;
55           }
56     }
57 
58     /*transferFrom*/
59     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success){
60         if (balances[_from] >= _amount
61              && _amount > 0
62              && balances[_to] + _amount > balances[_to]  && _amount <= allowed[_from][msg.sender]) {
63              balances[_from] -= _amount;
64              balances[_to] += _amount;
65              allowed[_from][msg.sender] -= _amount;
66              Transfer(_from, _to, _amount);
67              return true;
68          } else {
69              return false;
70          }
71     }
72 
73     /**/
74     function approve(address _spender, uint256 _value) 
75         returns (bool success){
76          allowed[msg.sender][_spender] = _value;
77          Approval(msg.sender, _spender, _value);
78          return true;
79     }
80     /**/
81     function allowance(address _owner, address _spender) constant returns (uint256 remaining)
82     {
83         return allowed[_owner][_spender];
84     }
85     
86 }