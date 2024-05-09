1 pragma solidity ^0.4.21;
2 
3 contract ERC20Template {
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
21 contract ERC20 is ERC20Template {
22 
23     uint256 constant private MAX_UINT256 = 2**256 - 1;
24     mapping (address => uint256) public balances;
25     mapping (address => mapping (address => uint256)) public allowed;
26     
27     
28     string public name;                   
29     uint8 public decimals;                
30     string public symbol;                 
31 
32     function ERC20(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
33         balances[msg.sender] = _initialAmount;               
34         totalSupply = _initialAmount;                        
35         name = _tokenName;                                   
36         decimals = _decimalUnits;                            
37         symbol = _tokenSymbol;                               
38     }
39 
40     function transfer(address _to, uint256 _value) public returns (bool success) {
41         require(balances[msg.sender] >= _value);
42         balances[msg.sender] -= _value;
43         balances[_to] += _value;
44         emit Transfer(msg.sender, _to, _value); 
45         return true;
46     }
47 
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
49         uint256 allowance = allowed[_from][msg.sender];
50         require(balances[_from] >= _value && allowance >= _value);
51         balances[_to] += _value;
52         balances[_from] -= _value;
53         if (allowance < MAX_UINT256) {
54             allowed[_from][msg.sender] -= _value;
55         }
56         emit Transfer(_from, _to, _value); 
57         return true;
58     }
59 
60     function balanceOf(address _owner) public view returns (uint256 balance) {
61         return balances[_owner];
62     }
63 
64     function approve(address _spender, uint256 _value) public returns (bool success) {
65         allowed[msg.sender][_spender] = _value;
66         emit Approval(msg.sender, _spender, _value); 
67         return true;
68     }
69 
70     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
71         return allowed[_owner][_spender];
72     }
73 }
74 contract UbiatarPlay is ERC20 {
75     
76     /* ERC20 */
77     string public name = 'UbiatarPlay';
78     string public symbol = 'UAC';
79     uint8 public decimals = 8;
80     
81     /* UACToken */
82     address owner; 
83     address public crowdsale;
84     string public version = 'v0.8';
85     uint256 public totalSupply = 1000000000 * 10**uint(decimals);
86 
87     modifier onlyBy(address _account) {
88         require(msg.sender == _account);
89         _;
90     }
91     
92     constructor() ERC20 (totalSupply, name, decimals, symbol) public {
93         owner = msg.sender;
94         crowdsale = address(0);
95     }
96 
97     event Burn(address indexed burner, uint256 value);
98 
99     function burn(uint256 _value) public returns (bool success) {
100         require(_value > 0);
101         require(balances[msg.sender] >= _value);
102         balances[msg.sender] -= _value;
103         totalSupply -= _value;
104         emit Transfer(msg.sender, address(0), _value);
105         emit Burn(msg.sender, _value);
106         return true;
107     }
108 
109 }