1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4 
5     uint256 public totalSupply;
6 
7     function balanceOf(address _owner) public view returns (uint256 balance);
8 
9     function transfer(address _to, uint256 _value) public returns (bool success);
10 
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12 
13     function approve(address _spender, uint256 _value) public returns (bool success);
14 
15     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 contract ERC20 is ERC20Interface {
22 
23     uint256 constant private MAX_UINT256 = 2**256 - 1;
24     mapping (address => uint256) public balances;
25     mapping (address => mapping (address => uint256)) public allowed;
26 
27     string public name;
28     uint8 public decimals;
29     string public symbol;
30     
31     function ERC20(
32         address _initialOwner,
33         uint256 _initialAmount,
34         string _tokenName,
35         uint8 _decimalUnits,
36         string _tokenSymbol
37     ) public {
38         balances[_initialOwner] = _initialAmount;               
39         totalSupply = _initialAmount;                        
40         name = _tokenName;                                   
41         decimals = _decimalUnits;                            
42         symbol = _tokenSymbol;   
43         emit Transfer(_initialOwner, _initialOwner, _initialAmount);
44     }
45 
46     function transfer(address _to, uint256 _value) public returns (bool success) {
47         require(balances[msg.sender] >= _value);
48         balances[msg.sender] -= _value;
49         balances[_to] += _value;
50         emit Transfer(msg.sender, _to, _value);
51         return true;
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
55         uint256 allowance = allowed[_from][msg.sender];
56         require(balances[_from] >= _value && allowance >= _value);
57         balances[_to] += _value;
58         balances[_from] -= _value;
59         if (allowance < MAX_UINT256) {
60             allowed[_from][msg.sender] -= _value;
61         }
62         emit Transfer(_from, _to, _value);
63         return true;
64     }
65 
66     function balanceOf(address _owner) public view returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70     function approve(address _spender, uint256 _value) public returns (bool success) {
71         allowed[msg.sender][_spender] = _value;
72         emit Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
77         return allowed[_owner][_spender];
78     }   
79 }
80 contract EtherZaarFactory {
81 
82     function EtherZaarFactory() public {
83     }
84 
85     function createERC20(address _initialOwner, uint256 _initialAmount, string _name, uint8 _decimals, string _symbol) 
86         public 
87     returns (address) {
88 
89         ERC20 newToken = (new ERC20(_initialOwner, _initialAmount, _name, _decimals, _symbol));
90 
91         return address(newToken);
92     }
93 
94 }