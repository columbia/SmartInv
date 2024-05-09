1 pragma solidity ^0.4.4;
2 
3 /**
4 *
5 * ERC20 token
6 *
7 * doc https://github.com/ethereum/EIPs/issues/20
8 *
9 */
10 contract ERC20Token {
11 
12     function totalSupply() constant returns (uint256 supply) {}
13 
14     function balanceOf(address _owner) constant returns (uint256 balance) {}
15 
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
19 
20     function approve(address _spender, uint256 _value) returns (bool success) {}
21 
22     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
23 
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 }
27 
28 
29 /**
30 *
31 * Master Coin Token
32 *
33 * author luc
34 * date 2018/6/14
35 *
36 */
37 contract MCToken is ERC20Token {
38 
39     string private _name = "Master Coin";
40     string private _symbol = "MC";
41     uint8 private _decimals = 18;
42 
43     uint256 private _totalSupply = 210000000 * (10 ** uint256(_decimals));
44 
45     mapping(address=>uint256) private _balances;
46     mapping(address=>mapping(address=>uint256)) private _allowances;
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 
51     function MCToken() {
52         _balances[msg.sender] = _totalSupply;
53     }
54 
55     function name() public view returns (string name){
56         name = _name;
57     }
58 
59     function symbol() public view returns (string symbol){
60         symbol = _symbol;
61     }
62 
63     function decimals() public view returns (uint8 decimals){
64         decimals = _decimals;
65     }
66 
67     function totalSupply() public view returns (uint256 totalSupply){
68         totalSupply = _totalSupply;
69     }
70 
71     function balanceOf(address _owner) public view returns (uint256 balance){
72         balance = _balances[_owner];
73     }
74 
75     function transfer(address _to, uint256 _value) public returns (bool success){
76         require(_balances[msg.sender] >= _value);
77         _balances[msg.sender] -= _value;
78         _balances[_to] += _value;
79         Transfer(msg.sender, _to, _value);
80         success = true;
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
84         require(_balances[_from] >= _value);
85         require(_allowances[_from][msg.sender] >= _value);
86 
87         uint256 previousBalances = _balances[_from] + _balances[_to];
88 
89         _balances[_from] -= _value;
90         _allowances[_from][msg.sender] -= _value;
91         _balances[_to] += _value;
92         Transfer(_from, _to, _value);
93 
94         assert(_balances[_from] + _balances[_to] == previousBalances);
95 
96         success = true;
97     }
98 
99     function approve(address _spender, uint256 _value) public returns (bool success){
100         _allowances[msg.sender][_spender] = _value;
101         Approval(msg.sender, _spender, _value);
102         success = true;
103     }
104 
105     function allowance(address _owner, address _spender) public view returns (uint256 remaining){
106         remaining = _allowances[_owner][_spender];
107     }
108 }