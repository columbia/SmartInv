1 pragma solidity ^0.4.11; 
2 
3 
4 
5 contract Zerk {
6     
7     uint public constant _totalSupply = 20000000;
8     
9     string public constant symbol ="ZRK";
10     string public constant name ="Zerk";
11     uint8 public constant decimals =0;
12     
13         
14     mapping(address => uint256) balances;
15     mapping(address => mapping(address => uint256)) allowed;
16     
17     
18         
19         
20     function Zerk() {
21         balances[msg.sender] = _totalSupply;
22     }
23     function totalSupply() constant returns (uint256 totalSupply) {
24         return _totalSupply;
25     }
26     
27     function balanceOf(address _owner) constant returns (uint256 balance) {
28         return balances[_owner];
29         
30         
31     }
32     
33     function transfer(address _to, uint256 _value) returns (bool success) {
34         require(
35             balances[msg.sender] >= _value
36             && _value > 0);
37         balances[msg.sender] -= _value;
38         balances[_to] += _value;
39         Transfer(msg.sender, _to,  _value);
40         return true;
41         
42         }
43 
44     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
45         require (
46              allowed[_from][msg.sender] >= _value
47              && balances [_from] >= _value
48              && _value >0
49              );
50              balances[_from] -= _value;
51              balances[_to] += _value;
52              allowed[_from][msg.sender] -= _value;
53              Transfer(_from, _to, _value);
54              return true;
55              
56     }
57     function approve(address _spender, uint256 _value) returns (bool success) {
58         allowed[msg.sender][_spender] = _value;
59         Approval(msg.sender, _spender, _value);
60         return true;
61     }
62     function allowance(address _owner, address _spender) constant returns (uint256 remaining)
63 {
64     return allowed[_owner][_spender];
65     
66 }    
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69     
70 }
71 
72 interface IERC20 {
73     function totalSupply() constant returns (uint256 totalSupply);
74     function balanceOf(address _owner) constant returns (uint256 balance);
75     function transfer(address _to, uint256 _value) returns (bool success);
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
77     function approve(address _spender, uint256 _value) returns (bool success);
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80 }