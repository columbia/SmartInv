1 pragma solidity ^0.5.1;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract COB {
33 
34     using SafeMath for uint256;
35 
36     uint256 constant private MAX_UINT256 = 2**256 - 1;
37 
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42     address public owner;
43 
44     mapping (address => uint256) public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     // event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49     event Burn(address indexed _from, uint256 value);
50 
51     constructor(uint256 _initialSupply, string memory _tokenName, uint8 _decimalUnits, string memory _tokenSymbol) public {
52         name = _tokenName;
53         symbol = _tokenSymbol;
54         decimals = _decimalUnits;
55         totalSupply = _initialSupply;
56         balanceOf[msg.sender] = _initialSupply;
57         owner = msg.sender;
58     }
59 
60     function transfer(address _to, uint256 _value) public returns (bool success) {
61             // Test validity of the address '_to':
62         require(_to != address(0x0));
63             // Test positiveness of '_value':
64         require(_value > 0);
65             // Check the balance of the sender:
66         require(balanceOf[msg.sender] >= _value);
67             // Check for overflows:
68         require(balanceOf[_to] + _value >= balanceOf[_to]);
69             // Update balances of msg.sender and _to:
70         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);
71         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
72         emit Transfer(msg.sender, _to, _value);
73         return true;
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77             // Test validity of the address '_to':
78         require(_to != address(0x0));
79             // Test positiveness of '_value':
80         require(_value > 0);
81             // Check the balance of the sender:
82         require(balanceOf[msg.sender] >= _value);
83             // Check for overflows:
84         require(balanceOf[_to] + _value >= balanceOf[_to]);
85             // Update balances of msg.sender and _to:
86             // Check allowance's sufficiency:
87         require(_value <= allowance[_from][msg.sender]);
88             // Update balances of _from and _to:
89         balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);
90         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
91             // Update allowance:
92         require(allowance[_from][msg.sender]  < MAX_UINT256);
93         allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);
94         emit Transfer(_from, _to, _value);
95         return true;
96     }
97 
98     function approve(address _spender, uint256 _value) public returns (bool success) {
99             // Test positiveness of '_value':
100         require(_value > 0);
101         allowance[msg.sender][_spender] = _value;
102         return true;
103     }
104 
105     function burn(uint256 _value) public returns (bool success) {
106             // Check msg.sender's balance sufficiency:
107         require(balanceOf[msg.sender] >= _value);
108             // Test positiveness of '_value':
109         require(_value > 0);
110         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);
111         totalSupply = SafeMath.sub(totalSupply,_value);
112         emit Burn(msg.sender, _value);
113         return true;
114     }
115 
116 }