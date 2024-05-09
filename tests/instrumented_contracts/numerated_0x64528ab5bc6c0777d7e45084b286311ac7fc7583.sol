1 pragma solidity ^0.5.4;
2 
3 
4 contract Ownable {
5     address private _owner;
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7     constructor () internal {
8         _owner = msg.sender;
9         emit OwnershipTransferred(address(0), _owner);
10     }
11     function owner() public view returns (address) {
12         return _owner;
13     }
14     
15     modifier onlyOwner() {
16         require(isOwner());
17         _;
18     }
19     
20     function isOwner() public view returns (bool) {
21         return msg.sender == _owner;
22     }
23     
24     function renounceOwnership() public onlyOwner {
25         emit OwnershipTransferred(_owner, address(0));
26         _owner = address(0);
27     }
28     
29     function transferOwnership(address newOwner) public onlyOwner {
30         _transferOwnership(newOwner);
31     }
32    
33     function _transferOwnership(address newOwner) internal {
34         require(newOwner != address(0));
35         emit OwnershipTransferred(_owner, newOwner);
36         _owner = newOwner;
37     }
38 }
39 
40 
41 contract SafeMath {
42   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b > 0);
50     uint256 c = a / b;
51     assert(a == b * c + a % b);
52     return c;
53   }
54 
55   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c>=a && c>=b);
63     return c;
64   }
65 
66 }
67 
68 contract VinterCapital is Ownable, SafeMath{
69     string public name;
70     string public symbol;
71     uint8 public decimals;
72     uint256 public totalSupply;
73 
74     mapping (address => uint256) public balanceOf;
75     mapping (address => mapping (address => uint256)) public allowance;
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78     constructor()  public  {
79         balanceOf[msg.sender] = 21000000000000000000000000;
80         totalSupply = 21000000000000000000000000;
81         name = "Vinter Capital Block Chain";
82         symbol = "VCBC";
83         decimals = 18;
84 		
85     }
86 
87     function transfer(address _to, uint256 _value) public returns (bool) {
88         require(_to != address(0));
89 		require(_value > 0); 
90         require(balanceOf[msg.sender] >= _value);
91         require(balanceOf[_to] + _value >= balanceOf[_to]);
92 		uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];		
93         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
94         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
95         emit Transfer(msg.sender, _to, _value);
96 		assert(balanceOf[msg.sender]+balanceOf[_to]==previousBalances);
97         return true;
98     }
99 
100     function approve(address _spender, uint256 _value) public returns (bool success) {
101 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
102         allowance[msg.sender][_spender] = _value;
103         emit Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
108         require (_to != address(0));
109 		require (_value > 0); 
110         require (balanceOf[_from] >= _value) ;
111         require (balanceOf[_to] + _value > balanceOf[_to]);
112         require (_value <= allowance[_from][msg.sender]);
113         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
114         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
115         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
116         emit Transfer(_from, _to, _value);
117         return true;
118     }
119 }