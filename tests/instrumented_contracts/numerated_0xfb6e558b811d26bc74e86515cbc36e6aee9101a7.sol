1 pragma solidity ^0.4.18;
2 
3 contract EtherZaarFactory {
4 
5     function EtherZaarFactory() public {
6     }
7 
8     function createERC20(address _initialOwner, uint256 _initialAmount, string _name, uint8 _decimals, string _symbol) 
9         public 
10     returns (address) {
11 
12         ERC20 newToken = (new ERC20(_initialOwner, _initialAmount, _name, _decimals, _symbol));
13 
14         return address(newToken);
15     }
16 
17 }
18 
19 contract ERC20Interface {
20 
21     uint256 public totalSupply;
22 
23     function balanceOf(address _owner) public view returns (uint256 balance);
24 
25     function transfer(address _to, uint256 _value) public returns (bool success);
26 
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28 
29     function approve(address _spender, uint256 _value) public returns (bool success);
30 
31     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
32 
33     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 pragma solidity ^0.4.18;
38 
39 contract ERC20 is ERC20Interface {
40 
41     uint256 constant private MAX_UINT256 = 2**256 - 1;
42     mapping (address => uint256) public balances;
43     mapping (address => mapping (address => uint256)) public allowed;
44 
45     string public name;
46     uint8 public decimals;
47     string public symbol;
48     
49     function ERC20(
50         address _initialOwner,
51         uint256 _initialAmount,
52         string _tokenName,
53         uint8 _decimalUnits,
54         string _tokenSymbol
55     ) public {
56         balances[_initialOwner] = _initialAmount;               
57         totalSupply = _initialAmount;                        
58         name = _tokenName;                                   
59         decimals = _decimalUnits;                            
60         symbol = _tokenSymbol;   
61         emit Transfer(_initialOwner, _initialOwner, _initialAmount);
62     }
63 
64     function transfer(address _to, uint256 _value) public returns (bool success) {
65         require(balances[msg.sender] >= _value);
66         balances[msg.sender] -= _value;
67         balances[_to] += _value;
68         emit Transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         uint256 allowance = allowed[_from][msg.sender];
74         require(balances[_from] >= _value && allowance >= _value);
75         balances[_to] += _value;
76         balances[_from] -= _value;
77         if (allowance < MAX_UINT256) {
78             allowed[_from][msg.sender] -= _value;
79         }
80         emit Transfer(_from, _to, _value);
81         return true;
82     }
83 
84     function balanceOf(address _owner) public view returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         emit Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
95         return allowed[_owner][_spender];
96     }   
97 }