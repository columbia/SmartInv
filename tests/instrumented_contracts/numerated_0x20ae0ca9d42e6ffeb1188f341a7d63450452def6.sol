1 pragma solidity ^0.4.13;
2 
3 
4 contract ERC20Interface {
5      
6     function totalSupply() constant returns (uint256 totalSupply);
7     function balanceOf(address _owner) constant returns (uint256 balance);  
8     function transfer(address _to, uint256 _value) returns (bool success);  
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
10     function approve(address _spender, uint256 _value) returns (bool success);
11     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14  }
15   
16  contract Cipher is ERC20Interface {
17     string public constant symbol = "CPR";
18     string public constant name = "Cipher";
19     uint8 public constant decimals = 18;
20     uint256 _totalSupply = 1080000000000000000000000000;
21     address public owner;
22     mapping(address => uint256) balances;
23     mapping(address => mapping (address => uint256)) allowed;
24     modifier onlyOwner() {
25         require(msg.sender != owner); {
26              
27         }
28           _;
29     }
30    
31     function Cipher() {
32         owner = msg.sender;
33         balances[owner] = _totalSupply;
34     }
35   
36     function totalSupply() constant returns (uint256 totalSupply) {
37         totalSupply = _totalSupply;
38     }
39   
40     function balanceOf(address _owner) constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43    
44     function transfer(address _to, uint256 _amount) returns (bool success) {
45         if (balances[msg.sender] >= _amount 
46             && _amount > 0
47             && balances[_to] + _amount > balances[_to]) {
48             balances[msg.sender] -= _amount;
49             balances[_to] += _amount;
50             Transfer(msg.sender, _to, _amount);
51             return true;
52         } else {
53             return false;
54             }
55       }
56    
57       function transferFrom(
58         address _from,
59         address _to,
60         uint256 _amount
61     ) returns (bool success) {
62        if (balances[_from] >= _amount
63             && allowed[_from][msg.sender] >= _amount
64             && _amount > 0
65             && balances[_to] + _amount > balances[_to]) {
66             balances[_from] -= _amount;
67             allowed[_from][msg.sender] -= _amount;
68             balances[_to] += _amount;
69              Transfer(_from, _to, _amount);
70              return true;
71         } else {
72             return false;
73          }
74      }
75   
76      function approve(address _spender, uint256 _amount) returns (bool success) {
77          allowed[msg.sender][_spender] = _amount;
78          Approval(msg.sender, _spender, _amount);
79          return true;
80      }
81   
82      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83          return allowed[_owner][_spender];
84      }
85 }