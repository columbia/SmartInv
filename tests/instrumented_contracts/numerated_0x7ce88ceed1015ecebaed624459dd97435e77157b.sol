1 pragma solidity ^0.4.11;
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
14 contract ATCToken is ERC20Interface{
15     string public standard = 'Token 1.0';
16     string public constant name="ATC";
17     string public constant symbol="ATC";
18     uint8 public constant decimals=10;
19     uint256 constant _totalSupply=3000000000000000000;
20     mapping(address => mapping (address => uint256)) allowed;
21     mapping(address => uint256) balances;
22     address public owner;
23     
24     function ATCToken() {
25         owner = msg.sender;
26         balances[owner] = _totalSupply; 
27     }
28     
29     function totalSupply() constant returns (uint256 totalSupply) {
30           return _totalSupply;
31     }
32     
33     function balanceOf(address _owner) constant returns (uint256 balance){
34         return balances[_owner]; 
35     }
36 
37     function transfer(address _to, uint256 _amount) returns (bool success)  {
38        if (balances[msg.sender] >= _amount 
39               && _amount > 0
40               && balances[_to] + _amount > balances[_to]) {
41               balances[msg.sender] -= _amount;
42               balances[_to] += _amount;
43               Transfer(msg.sender, _to, _amount);
44               return true;
45           } else {
46               return false;
47           }
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success){
51         if (balances[_from] >= _amount
52              && _amount > 0
53              && balances[_to] + _amount > balances[_to]  && _amount <= allowed[_from][msg.sender]) 
54         {
55              balances[_from] -= _amount;
56              balances[_to] += _amount;
57              allowed[_from][msg.sender] -= _amount;
58              Transfer(_from, _to, _amount);
59              return true;
60         } else {
61              return false;
62         }
63     }
64 
65     function approve(address _spender, uint256 _value) returns (bool success){
66          allowed[msg.sender][_spender] = _value;
67          Approval(msg.sender, _spender, _value);
68          return true;
69     }
70 
71     function allowance(address _owner, address _spender) constant returns (uint256 remaining)
72     {
73         return allowed[_owner][_spender];
74     }
75 }