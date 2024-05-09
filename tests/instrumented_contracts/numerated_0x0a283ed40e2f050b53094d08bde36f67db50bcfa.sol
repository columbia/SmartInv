1 pragma solidity ^0.4.8;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256 supply);
5     function balance() public constant returns (uint256);
6     function balanceOf(address _owner) public constant returns (uint256);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 contract FreeCoin is ERC20Interface {
17     string public constant symbol = "FREE";
18     string public constant name = "FreeCoin";
19     uint8 public constant decimals = 1;
20 
21     uint256 _totalSupply = 900000000000;
22     uint256 _airdropAmount = 1001;
23     uint256 _cutoff = _airdropAmount * 10000000;
24 
25     mapping(address => uint256) balances;
26     mapping(address => bool) initialized;
27 
28     mapping(address => mapping (address => uint256)) allowed;
29 
30     function FreeCoin() {
31         initialized[msg.sender] = true;
32         balances[msg.sender] = _airdropAmount * 1;
33         _totalSupply = balances[msg.sender];
34     }
35 
36     function totalSupply() constant returns (uint256 supply) {
37         return _totalSupply;
38     }
39 
40     // What's my balance?
41     function balance() constant returns (uint256) {
42         return getBalance(msg.sender);
43     }
44 
45     // What is the balance of a particular account?
46     function balanceOf(address _address) constant returns (uint256) {
47         return getBalance(_address);
48     }
49     
50     function transfer(address _to, uint256 _amount) public returns (bool success) {
51         initialize(msg.sender);
52 
53         if (balances[msg.sender] >= _amount
54             && _amount > 0) {
55             initialize(_to);
56             if (balances[_to] + _amount > balances[_to]) {
57 
58                 balances[msg.sender] -= _amount;
59                 balances[_to] += _amount;
60 
61                 Transfer(msg.sender, _to, _amount);
62 
63                 return true;
64             } else {
65                 return false;
66             }
67         } else {
68             return false;
69         }
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
73         initialize(_from);
74 
75         if (balances[_from] >= _amount
76             && allowed[_from][msg.sender] >= _amount
77             && _amount > 0) {
78             initialize(_to);
79             if (balances[_to] + _amount > balances[_to]) {
80 
81                 balances[_from] -= _amount;
82                 allowed[_from][msg.sender] -= _amount;
83                 balances[_to] += _amount;
84 
85                 Transfer(_from, _to, _amount);
86 
87                 return true;
88             } else {
89                 return false;
90             }
91         } else {
92             return false;
93         }
94     }
95     
96     function approve(address _spender, uint256 _amount) public returns (bool success) {
97         allowed[msg.sender][_spender] = _amount;
98         Approval(msg.sender, _spender, _amount);
99         return true;
100     }
101 
102     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
103         return allowed[_owner][_spender];
104     }
105 
106     function initialize(address _address) internal returns (bool success) {
107         if (_totalSupply < _cutoff && !initialized[_address]) {
108             initialized[_address] = true;
109             balances[_address] = _airdropAmount;
110             _totalSupply += _airdropAmount;
111         }
112         return true;
113     }
114 
115     function getBalance(address _address) internal returns (uint256) {
116         if (_totalSupply < _cutoff && !initialized[_address]) {
117             return balances[_address] + _airdropAmount;
118         }
119         else {
120             return balances[_address];
121         }
122     }
123 }