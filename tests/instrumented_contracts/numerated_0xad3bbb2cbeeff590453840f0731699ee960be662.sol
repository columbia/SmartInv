1 pragma solidity ^0.4.13;
2 
3 // ERC20 Standard
4 contract ERC20Interface {
5 
6     function totalSupply() constant returns (uint256 totalSupply);
7 
8     function balanceOf(address _owner) constant returns (uint256 balance);
9 
10     function transfer(address _to, uint256 _value) returns (bool success);
11 
12     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
13 
14     function approve(address _spender, uint256 _value) returns (bool success);
15 
16     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19 
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21 }
22 
23 // contract
24 contract EXOSO is ERC20Interface {
25     string public constant symbol = "ESO";
26     string public constant name = "EXOSO";
27     uint8 public constant decimals = 4;
28     uint256 _totalSupply = 690000000000;
29 
30     address public owner;
31 
32     mapping(address => uint256) balances;
33 
34     mapping(address => mapping (address => uint256)) allowed;
35 
36     mapping (address => bool) public frozenAccount;
37 
38     modifier onlyOwner {
39         require (msg.sender == owner);
40         _;
41     }
42 
43     event FrozenFunds(address target, bool frozen);
44 
45     // constructor
46     function EXOSO() {
47         owner = msg.sender;
48         balances[owner] = _totalSupply;
49     }
50 
51     function totalSupply() constant returns (uint256 totalSupply) {
52         totalSupply = _totalSupply;
53     }
54 
55     function balanceOf(address _owner) constant returns (uint256 balance) {
56         return balances[_owner];
57     }
58 
59     function transfer(address _to, uint256 _amount) returns (bool success) {
60         if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
61             balances[msg.sender] -= _amount;
62             balances[_to] += _amount;
63             Transfer(msg.sender, _to, _amount);
64             return true;
65         }
66         else {
67             return false;
68         }
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
72         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
73             balances[_from] -= _amount;
74             allowed[_from][msg.sender] -= _amount;
75             balances[_to] += _amount;
76             Transfer(_from, _to, _amount);
77             return true;
78         }
79         else {
80             return false;
81         }
82     }
83 
84     function approve(address _spender, uint256 _amount) returns (bool success) {
85         allowed[msg.sender][_spender] = _amount;
86         Approval(msg.sender, _spender, _amount);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91         return allowed[_owner][_spender];
92     }
93 
94     function transferOwnership(address newOwner) onlyOwner {
95         owner = newOwner;
96     }
97 
98     function freezeAccount(address target, bool freeze) onlyOwner {
99         require (target != owner);
100         frozenAccount[target] = freeze;
101         FrozenFunds(target, freeze);
102     }
103 
104 }