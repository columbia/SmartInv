1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b > 0); 
15         uint256 c = a / b;
16         assert(a == b * c + a % b); 
17         return a / b;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 contract ASIToken {
34     using SafeMath for uint256;
35     string public name = "ASICoin";
36     string public symbol = "ASI";
37     uint8 public decimals = 18;
38     uint256 public totalSupply = 12 * 10 ** 8 * 10 ** 18;
39 
40     mapping (address => uint256) public balanceOf;
41     mapping (address => uint256) public freezeOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 
46     event Freeze(address indexed from, uint256 value);
47 	
48     event Unfreeze(address indexed from, uint256 value);
49 
50     constructor() public{
51         balanceOf[msg.sender] = totalSupply;
52     }
53 
54     function transfer(address _to, uint256 _value) public returns (bool success){
55         if (_to == 0x0) revert(); 
56         if (_value <= 0) revert(); 
57         if (balanceOf[msg.sender] < _value) revert();
58         if (balanceOf[_to] + _value < balanceOf[_to]) revert();
59         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
60         balanceOf[_to] = balanceOf[_to].add(_value);
61         emit Transfer(msg.sender, _to, _value);
62         return true;
63     }
64 
65     function approve(address _spender, uint256 _value) public returns (bool success) {
66         if (_value <= 0) revert();
67         allowance[msg.sender][_spender] = _value;
68         return true;
69     }
70        
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         if (_to == 0x0) revert(); 
74         if (_value <= 0) revert();
75         if (balanceOf[_from] < _value) revert();  
76         if (balanceOf[_to] + _value < balanceOf[_to]) revert();
77         if (_value > allowance[_from][msg.sender]) revert(); 
78         balanceOf[_from] = balanceOf[_from].sub(_value); 
79         balanceOf[_to] = balanceOf[_to].add(_value);
80         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
81         emit Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     function freeze(uint256 _value) public returns (bool success) {
86         if (balanceOf[msg.sender] < _value) revert(); 
87         if (_value <= 0) revert(); 
88         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value); 
89         freezeOf[msg.sender] = freezeOf[msg.sender].add(_value); 
90         emit Freeze(msg.sender, _value);
91         return true;
92     }
93 
94     function unfreeze(uint256 _value) public returns (bool success) {
95         if (freezeOf[msg.sender] < _value) revert();
96         if (_value <= 0) revert();
97         freezeOf[msg.sender] = freezeOf[msg.sender].sub(_value); 
98         balanceOf[msg.sender] = balanceOf[msg.sender].add(_value);
99         emit Unfreeze(msg.sender, _value);
100         return true;
101     }
102 }