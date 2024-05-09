1 pragma solidity ^0.4.18;
2 
3 contract Mobilink {
4 
5     function Mobilink() public {
6     }
7 
8     function createERC20(address _initialOwner, uint256 _initialAmount, 
9 string _name, uint8 _decimals, string _symbol)
10         public
11     returns (address) {
12 
13         ERC20 newToken = (new ERC20(_initialOwner, _initialAmount, 
14 _name, _decimals, _symbol));
15 
16         return address(newToken);
17     }
18 
19 }
20 
21 contract ERC20Interface {
22 
23     uint256 public totalSupply = 9000000000000000000000000000;
24 
25     function balanceOf(address _owner) public view returns (uint256 
26 balance);
27 
28     function transfer(address _to, uint256 _value) public returns (bool 
29 success);
30 
31     function transferFrom(address _from, address _to, uint256 _value) 
32 public returns (bool success);
33 
34     function approve(address _spender, uint256 _value) public returns 
35 (bool success);
36 
37     function allowance(address _owner, address _spender) public view 
38 returns (uint256 remaining);
39 
40     event Transfer(address indexed _from, address indexed _to, uint256 
41 _value);
42     event Approval(address indexed _owner, address indexed _spender, 
43 uint256 _value);
44 }
45 
46 pragma solidity ^0.4.18;
47 
48 contract ERC20 is ERC20Interface {
49 
50     uint256 constant private MAX_UINT256 = 2**256 - 1;
51     mapping (address => uint256) public balances;
52     mapping (address => mapping (address => uint256)) public allowed;
53 
54     string public name ="MobilinkToken";
55     uint8 public decimals = 18;
56     string public symbol = "MOLK";
57 
58     function ERC20(
59         address _initialOwner,
60         uint256 _initialAmount,
61         string _tokenName,
62         uint8 _decimalUnits,
63         string _tokenSymbol
64     ) public {
65         balances[_initialOwner] = _initialAmount;
66         totalSupply = _initialAmount;
67         name = _tokenName;
68         decimals = _decimalUnits;
69         symbol = _tokenSymbol;
70         emit Transfer(_initialOwner, _initialOwner, _initialAmount);
71     }
72 
73     function transfer(address _to, uint256 _value) public returns (bool 
74 success) {
75         require(balances[msg.sender] >= _value);
76         balances[msg.sender] -= _value;
77         balances[_to] += _value;
78         emit Transfer(msg.sender, _to, _value);
79         return true;
80     }
81 
82     function transferFrom(address _from, address _to, uint256 _value) 
83 public returns (bool success) {
84         uint256 allowance = allowed[_from][msg.sender];
85         require(balances[_from] >= _value && allowance >= _value);
86         balances[_to] += _value;
87         balances[_from] -= _value;
88         if (allowance < MAX_UINT256) {
89             allowed[_from][msg.sender] -= _value;
90         }
91         emit Transfer(_from, _to, _value);
92         return true;
93     }
94 
95     function balanceOf(address _owner) public view returns (uint256 
96 balance) {
97         return balances[_owner];
98     }
99 
100     function approve(address _spender, uint256 _value) public returns 
101 (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         emit Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) public view 
108 returns (uint256 remaining) {
109         return allowed[_owner][_spender];
110     }
111 }