1 pragma solidity ^0.5.4;
2 
3 contract SafeMath {
4   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28 }
29 
30 contract BOB is SafeMath{
31     string public name;
32     string public symbol;
33     uint8 public decimals;
34     uint256 public totalSupply;
35 	address public owner;
36     mapping (address => uint256) public balanceOf;
37 	mapping (address => uint256) public freezeOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Freeze(address indexed from, uint256 value);
41     event Unfreeze(address indexed from, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43     constructor()  public  {
44         balanceOf[msg.sender] = 1000000000000000000000000000;
45         totalSupply = 1000000000000000000000000000;
46         name = "BOBO Chain";
47         symbol = "BOB";
48         decimals = 18;
49 		owner = msg.sender;
50     }
51 
52     function transfer(address _to, uint256 _value) public returns (bool) {
53         require(_to != address(0));
54 		require(_value > 0); 
55         require(balanceOf[msg.sender] >= _value);
56         require(balanceOf[_to] + _value >= balanceOf[_to]);
57 		uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];		
58         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
59         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
60         emit Transfer(msg.sender, _to, _value);
61 		assert(balanceOf[msg.sender]+balanceOf[_to]==previousBalances);
62         return true;
63     }
64 
65     function approve(address _spender, uint256 _value) public returns (bool success) {
66 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
67         allowance[msg.sender][_spender] = _value;
68         emit Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         require (_to != address(0));
74 		require (_value > 0); 
75         require (balanceOf[_from] >= _value) ;
76         require (balanceOf[_to] + _value > balanceOf[_to]);
77         require (_value <= allowance[_from][msg.sender]);
78         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
79         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
80         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
81         emit Transfer(_from, _to, _value);
82         return true;
83     }
84 	
85 	function freeze(uint256 _value) public returns (bool success) {
86         require (balanceOf[msg.sender] >= _value);
87 		require (_value > 0); 
88         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
89         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);
90         emit Freeze(msg.sender, _value);
91         return true;
92     }
93 	
94 	function unfreeze(uint256 _value) public returns (bool success) {
95         require (freezeOf[msg.sender] >= _value);
96 		require (_value > 0) ; 
97         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);
98 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
99         emit Unfreeze(msg.sender, _value);
100         return true;
101     }
102 }