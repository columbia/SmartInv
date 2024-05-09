1 pragma solidity ^0.8.0;
2 
3 interface ERC20Interface {
4 
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 contract ERC20Base is ERC20Interface {
23 
24     mapping (address => uint256) public _balances;
25     mapping (address => mapping (address => uint256)) public _allowances;
26     uint256 public _totalSupply;
27 
28     function transfer(address _to, uint256 _value) public returns (bool success) {
29 
30         if (_balances[msg.sender] >= _value && _value > 0) {
31             _balances[msg.sender] -= _value;
32             _balances[_to] += _value;
33             emit Transfer(msg.sender, _to, _value);
34             return true;
35         } else { 
36             return false;
37         }
38     }
39 
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
41        
42         if (_balances[_from] >= _value && _allowances[_from][msg.sender] >= _value && _value > 0) {
43             _balances[_to] += _value;
44             _balances[_from] -= _value;
45             _allowances[_from][msg.sender] -= _value;
46             emit Transfer(_from, _to, _value);
47             return true;
48         } else {
49             return false;
50         }
51     }
52 
53     function balanceOf(address _owner) public view returns (uint256 balance) {
54         return _balances[_owner];
55     }
56 
57     function approve(address _spender, uint256 _value) public returns (bool success) {
58         _allowances[msg.sender][_spender] = _value;
59         emit Approval(msg.sender, _spender, _value);
60         return true;
61     }
62 
63     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
64       return _allowances[_owner][_spender];
65     }
66     
67     function totalSupply() public view returns (uint256 total) {
68         return _totalSupply;
69     }
70 }
71 
72 contract WXO is ERC20Base {
73 
74     string private _name;
75     string private _symbol;
76     uint8 private _decimals;
77     
78     constructor (string memory name, string memory symbol, uint8 decimals, uint256 initialSupply) public payable {
79         _name = name;
80         _symbol = symbol;
81         _decimals = decimals;
82         _totalSupply = initialSupply;
83         _balances[msg.sender] = initialSupply;
84     }
85 
86     function name() public view returns (string memory) {
87         return _name;
88     }
89 
90     function symbol() public view returns (string memory) {
91         return _symbol;
92     }
93 
94     function decimals() public view returns (uint8) {
95         return _decimals;
96     }
97 
98 }