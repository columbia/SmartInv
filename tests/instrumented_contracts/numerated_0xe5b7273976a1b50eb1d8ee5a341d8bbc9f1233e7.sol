1 pragma solidity ^0.5.7;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract Ownable {
22     address private _owner;
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24     constructor () internal {
25         _owner = msg.sender;
26         emit OwnershipTransferred(address(0), _owner);
27     }
28     function owner() public view returns (address) {
29         return _owner;
30     }
31     
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36     
37     function isOwner() public view returns (bool) {
38         return msg.sender == _owner;
39     }
40     
41     function renounceOwnership() public onlyOwner {
42         emit OwnershipTransferred(_owner, address(0));
43         _owner = address(0);
44     }
45     
46     function transferOwnership(address newOwner) public onlyOwner {
47         _transferOwnership(newOwner);
48     }
49    
50     function _transferOwnership(address newOwner) internal {
51         require(newOwner != address(0));
52         emit OwnershipTransferred(_owner, newOwner);
53         _owner = newOwner;
54     }
55 }
56 
57 
58 contract SafeMath {
59   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
60     uint256 c = a * b;
61     assert(a == 0 || c / a == b);
62     return c;
63   }
64 
65   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b > 0);
67     uint256 c = a / b;
68     assert(a == b * c + a % b);
69     return c;
70   }
71 
72   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
73     assert(b <= a);
74     return a - b;
75   }
76 
77   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a + b;
79     assert(c>=a && c>=b);
80     return c;
81   }
82 
83 }
84 
85 contract ERC20TOKEN is Ownable, SafeMath, IERC20{
86     string public name;
87     string public symbol;
88     uint8 public decimals;
89     uint256 public totalSupply;
90 
91     mapping (address => uint256) public balanceOf;
92     mapping (address => mapping (address => uint256)) public allowance;
93     event Transfer(address indexed from, address indexed to, uint256 value);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95     constructor()  public  {
96         balanceOf[msg.sender] = 1000000000000000000000000000;
97         totalSupply = 1000000000000000000000000000;
98         name = "DU";
99         symbol = "DU";
100         decimals = 18;
101 		
102     }
103 
104     function transfer(address _to, uint256 _value) public returns (bool) {
105         require(_to != address(0));
106 		require(_value > 0); 
107         require(balanceOf[msg.sender] >= _value);
108         require(balanceOf[_to] + _value >= balanceOf[_to]);
109 		uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];		
110         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
111         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
112         emit Transfer(msg.sender, _to, _value);
113 		assert(balanceOf[msg.sender]+balanceOf[_to]==previousBalances);
114         return true;
115     }
116 
117     function approve(address _spender, uint256 _value) public returns (bool success) {
118 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
119         allowance[msg.sender][_spender] = _value;
120         emit Approval(msg.sender, _spender, _value);
121         return true;
122     }
123 
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
125         require (_to != address(0));
126 		require (_value > 0); 
127         require (balanceOf[_from] >= _value) ;
128         require (balanceOf[_to] + _value > balanceOf[_to]);
129         require (_value <= allowance[_from][msg.sender]);
130         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
131         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
132         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
133         emit Transfer(_from, _to, _value);
134         return true;
135     }
136 }