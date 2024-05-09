1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
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
32 contract Ownable {
33     address public owner;
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address newOwner) public onlyOwner {
46         require(newOwner != address(0));
47         emit OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49     }
50 }
51 
52 contract WCCToken is SafeMath, Ownable{
53     string public name = "WCCCoin";
54     string public symbol = "WCC";
55     uint8 public decimals = 18;
56     uint256 public totalSupply = 12 * 10 ** 8 * 10 ** 18;
57 
58     mapping (address => uint256) public balanceOf;
59     mapping (address => uint256) public freezeOf;
60     mapping (address => mapping (address => uint256)) public allowance;
61 
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 
64     event Freeze(address indexed from, uint256 value);
65 	
66     event Unfreeze(address indexed from, uint256 value);
67 
68     constructor() public{
69         balanceOf[msg.sender] = totalSupply;
70     }
71 
72     function transfer(address _to, uint256 _value) public returns (bool success){
73         if (_to == 0x0) revert(); 
74         if (_value <= 0) revert(); 
75         if (balanceOf[msg.sender] < _value) revert();
76         if (balanceOf[_to] + _value < balanceOf[_to]) revert();
77         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);
78         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
79         emit Transfer(msg.sender, _to, _value);
80         return true;
81     }
82 
83     function approve(address _spender, uint256 _value) public returns (bool success) {
84         if (_value <= 0) revert();
85         allowance[msg.sender][_spender] = _value;
86         return true;
87     }
88        
89 
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         if (_to == 0x0) revert(); 
92         if (_value <= 0) revert();
93         if (balanceOf[_from] < _value) revert();  
94         if (balanceOf[_to] + _value < balanceOf[_to]) revert();
95         if (_value > allowance[_from][msg.sender]) revert(); 
96         balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value); 
97         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
98         allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);
99         emit Transfer(_from, _to, _value);
100         return true;
101     }
102 
103     function freeze(uint256 _value) onlyOwner public returns (bool success) {
104         if (balanceOf[msg.sender] < _value) revert(); 
105         if (_value <= 0) revert(); 
106         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value); 
107         freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value); 
108         emit Freeze(msg.sender, _value);
109         return true;
110     }
111 
112     function unfreeze(uint256 _value) onlyOwner public returns (bool success) {
113         if (freezeOf[msg.sender] < _value) revert();
114         if (_value <= 0) revert();
115         freezeOf[msg.sender] = SafeMath.sub(freezeOf[msg.sender], _value); 
116         balanceOf[msg.sender] = SafeMath.add(balanceOf[msg.sender], _value);
117         emit Unfreeze(msg.sender, _value);
118         return true;
119     }
120 }