1 pragma solidity ^0.4.16;
2 
3 contract ERC20 {
4 
5     uint256 public totalSupply;
6 
7     mapping (address => uint256) public balanceOf;
8 
9     mapping (address => mapping (address => uint256)) public allowance;
10 
11     function transfer(address to, uint256 value) returns (bool success);
12 
13     function transferFrom(address from, address to, uint256 value) returns (bool success);
14 
15     function approve(address spender, uint256 value) returns (bool success);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 
21 }
22 
23 contract BondkickBondToken is ERC20 {
24 
25     string public name;
26     string public symbol;
27     uint8 public decimals;
28 
29     address public owner;
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35     
36     function BondkickBondToken(string _name, string _symbol, uint8 _decimals, uint256 _initialMint) {
37         name = _name;
38         symbol = _symbol;
39         decimals = _decimals;
40         owner = msg.sender;
41         
42         if (_initialMint > 0) {
43             totalSupply += _initialMint;
44             balanceOf[msg.sender] += _initialMint;
45                         
46             Transfer(address(0), msg.sender, _initialMint);
47         }
48     }
49 
50     function transfer(address _to, uint256 _value) returns (bool success) {
51         require(_to != address(0));
52         require(balanceOf[msg.sender] >= _value);
53         
54         _transfer(msg.sender, _to, _value);
55         
56         return true;
57     }
58     
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
60         require(_to != address(0));
61         require(balanceOf[_from] >= _value);
62         require(allowance[_from][msg.sender] >= _value);
63         
64         allowance[_from][msg.sender] -= _value;
65         
66         _transfer(_from, _to, _value);
67         
68         return true;
69     }
70     
71     function approve(address _spender, uint256 _value) returns (bool success) {
72         require(_spender != address(0));
73 
74         allowance[msg.sender][_spender] = _value;
75 
76         Approval(msg.sender, _spender, _value);
77         
78         return true;
79     }
80 
81     function mint(uint256 _value) onlyOwner returns (bool success) {
82         require(_value > 0 && (totalSupply + _value) >= totalSupply);
83         
84         totalSupply += _value;
85         balanceOf[msg.sender] += _value;
86                     
87         Transfer(address(0), msg.sender, _value);
88         
89         return true;
90     }
91     
92     function mintTo (uint256 _value, address _to) onlyOwner returns (bool success) {
93         require(_value > 0 && (totalSupply + _value) >= totalSupply);
94         
95         totalSupply += _value;
96         balanceOf[_to] += _value;
97         
98         Transfer(address(0), _to, _value);
99         
100         return true;
101     }
102 
103     function unmint(uint256 _value) onlyOwner returns (bool success) {
104         require(_value > 0 && balanceOf[msg.sender] >= _value);
105 
106         totalSupply -= _value;
107         balanceOf[msg.sender] -= _value;
108 
109         Transfer(msg.sender, address(0), _value);
110 
111         return true;
112     }
113     
114     function changeOwner(address _newOwner) onlyOwner returns (bool success) {
115         require(_newOwner != address(0));
116 
117         owner = _newOwner;
118         
119         return true;
120     }
121 
122     function _transfer(address _from, address _to, uint256 _value) internal {
123         balanceOf[_from] -= _value;
124         balanceOf[_to] += _value;
125 
126         Transfer(_from, _to, _value);
127     }
128 }