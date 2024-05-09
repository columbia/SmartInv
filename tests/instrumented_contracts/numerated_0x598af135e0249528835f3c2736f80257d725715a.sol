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
32         uint256 _initialAmount,
33         string _tokenName,
34         uint8 _decimalUnits,
35         string _tokenSymbol
36     ) public {
37         balances[msg.sender] = _initialAmount;               
38         totalSupply = _initialAmount;                        
39         name = _tokenName;                                   
40         decimals = _decimalUnits;                            
41         symbol = _tokenSymbol;                               
42     }
43 
44     function transfer(address _to, uint256 _value) public returns (bool success) {
45         require(balances[msg.sender] >= _value);
46         balances[msg.sender] -= _value;
47         balances[_to] += _value;
48         emit Transfer(msg.sender, _to, _value);
49         return true;
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
53         uint256 allowance = allowed[_from][msg.sender];
54         require(balances[_from] >= _value && allowance >= _value);
55         balances[_to] += _value;
56         balances[_from] -= _value;
57         if (allowance < MAX_UINT256) {
58             allowed[_from][msg.sender] -= _value;
59         }
60         emit Transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function balanceOf(address _owner) public view returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint256 _value) public returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         emit Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
75         return allowed[_owner][_spender];
76     }   
77 }
78 
79 
80 contract EtherZaarFactory {
81 
82     mapping(address => address[]) public initialOwnerToToken;
83     mapping(address => address) public tokenToInitialOwner;
84 
85     function EtherZaarFactory() public {
86     }
87 
88     function createERC20(address _initialOwner, uint256 _initialAmount, string _name, uint8 _decimals, string _symbol) 
89         public 
90     returns (address) {
91 
92         ERC20 newToken = (new ERC20(_initialAmount, _name, _decimals, _symbol));
93         
94         initialOwnerToToken[_initialOwner].push(address(newToken));
95         tokenToInitialOwner[address(newToken)] = _initialOwner;
96         
97         newToken.transfer(_initialOwner, _initialAmount); 
98 
99         return address(newToken);
100     }
101 
102 }