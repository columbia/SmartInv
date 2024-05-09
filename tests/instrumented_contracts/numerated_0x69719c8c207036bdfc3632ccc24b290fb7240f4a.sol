1 pragma solidity ^0.4.2;
2 
3 contract ERC20Interface {
4 
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13     
14 }
15 
16 contract BitPayToken is ERC20Interface {
17 
18     string  public name;
19     string  public symbol;
20     uint8   public decimals;
21     uint256 public totalSupply;
22     
23     mapping(address => uint256) balances;
24     mapping(address => mapping (address => uint256)) allowed;
25     
26     function BitPayToken(uint256 initial_supply, string _name, string _symbol, uint8 _decimal) {
27 
28         balances[msg.sender]  = initial_supply;
29         name                  = _name;
30         symbol                = _symbol;
31         decimals              = _decimal;
32         totalSupply           = initial_supply;
33 
34     }
35 
36     function balanceOf(address _owner) constant returns (uint256 balance) {
37         return balances[_owner];
38     }
39 
40     function transfer(address to, uint value) returns (bool success) {
41         if(balances[msg.sender] < value) return false;
42         if(balances[to] + value < balances[to]) return false;
43         
44         balances[msg.sender] -= value;
45         balances[to] += value;
46         
47         Transfer(msg.sender, to, value);
48 
49         return true;
50 
51     }
52 
53 
54     function transferFrom(address from, address to, uint value) returns (bool success) {
55 
56         if(balances[from] < value) return false;
57         if( allowed[from][msg.sender] < value ) return false;
58         if(balances[to] + value < balances[to]) return false;
59         
60         balances[from] -= value;
61         allowed[from][msg.sender] -= value;
62         balances[to] += value;
63         
64         Transfer(from, to, value);
65 
66         return true;
67 
68     }
69 
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
71 
72         return allowed[_owner][_spender];
73 
74     }
75 
76     function approve(address _spender, uint256 _amount) returns (bool success) {
77 
78         allowed[msg.sender][_spender] = _amount;
79         Approval(msg.sender, _spender, _amount);
80         return true;
81 
82     }
83 
84 }