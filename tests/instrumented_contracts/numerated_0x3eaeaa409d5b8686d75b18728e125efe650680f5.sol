1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract MakroCoin is SafeMath {
23     string public name;
24     string public symbol;
25     uint8 public decimals;
26     uint256 public totalSupply;
27 	address public owner;
28 
29     mapping (address => uint256) public balanceOf;
30 	mapping (address => uint256) public freezeOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Burn(address indexed from, uint256 value);
35     event Freeze(address indexed from, uint256 value);
36     event Unfreeze(address indexed from, uint256 value);
37 
38     constructor(
39         uint256 initialSupply,
40         string tokenName,
41         uint8 decimalUnits,
42         string tokenSymbol
43         ) public {
44         balanceOf[msg.sender] = initialSupply;
45         totalSupply = initialSupply;
46         name = tokenName;
47         symbol = tokenSymbol;
48         decimals = decimalUnits;
49 		owner = msg.sender;
50     }
51 
52     function transfer(address _to, uint256 _value) public {
53         require(_to != 0x0);
54 		require(_value > 0); 
55         require(balanceOf[msg.sender] >= _value);
56         require(balanceOf[_to] + _value >= balanceOf[_to]);
57         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
58         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
59         emit Transfer(msg.sender, _to, _value);
60     }
61 
62     function approve(address _spender, uint256 _value) public returns (bool success) {
63 		require(_value > 0); 
64         allowance[msg.sender][_spender] = _value;
65         return true;
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         require(_to != 0x0);
70 		require(_value > 0);
71         require(balanceOf[_from] >= _value);
72         require(balanceOf[_to] + _value >= balanceOf[_to]);
73         require(_value <= allowance[_from][msg.sender]);
74         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
75         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
76         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
77         emit Transfer(_from, _to, _value);
78         return true;
79     }
80 
81     function multiPartyTransfer(address[] _toAddresses, uint256[] _amounts) public {
82         require(_toAddresses.length <= 255);
83         require(_toAddresses.length == _amounts.length);
84         for (uint8 i = 0; i < _toAddresses.length; i++) {
85             transfer(_toAddresses[i], _amounts[i]);
86         }
87     }
88 
89     function multiPartyTransferFrom(address _from, address[] _toAddresses, uint256[] _amounts) public {
90         require(_toAddresses.length <= 255);
91         require(_toAddresses.length == _amounts.length);
92         for (uint8 i = 0; i < _toAddresses.length; i++) {
93             transferFrom(_from, _toAddresses[i], _amounts[i]);
94         }
95     }	
96 
97     function burn(uint256 _value) public returns (bool success) {
98         require(balanceOf[msg.sender] >= _value);
99 		require(_value > 0);
100         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
101         totalSupply = SafeMath.safeSub(totalSupply,_value);
102         emit Burn(msg.sender, _value);
103         return true;
104     }
105 
106 	function freeze(uint256 _value) public returns (bool success) {
107         require(balanceOf[msg.sender] >= _value);
108 		require(_value > 0);
109         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
110         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);
111         emit Freeze(msg.sender, _value);
112         return true;
113     }
114 
115 	function unfreeze(uint256 _value) public returns (bool success) {
116         require(freezeOf[msg.sender] >= _value);
117 		require(_value > 0); 
118         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);
119 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
120         emit Unfreeze(msg.sender, _value);
121         return true;
122     }
123 
124 	function withdrawEther(uint256 amount) public {
125 		require(msg.sender == owner);
126 		owner.transfer(amount);
127 	}
128 
129 	function() payable public {
130     }
131 }