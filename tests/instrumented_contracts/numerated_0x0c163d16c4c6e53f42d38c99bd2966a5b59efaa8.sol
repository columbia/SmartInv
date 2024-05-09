1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-26
3 */
4 
5 pragma solidity >=0.4.22 <0.6.0;
6 
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 contract Ownable {
26     address private _owner;
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28     constructor () internal {
29         _owner = msg.sender;
30         emit OwnershipTransferred(address(0), _owner);
31     }
32     function owner() public view returns (address) {
33         return _owner;
34     }
35     
36     modifier onlyOwner() {
37         require(isOwner());
38         _;
39     }
40     
41     function isOwner() public view returns (bool) {
42         return msg.sender == _owner;
43     }
44     
45     function renounceOwnership() public onlyOwner {
46         emit OwnershipTransferred(_owner, address(0));
47         _owner = address(0);
48     }
49     
50     function transferOwnership(address newOwner) public onlyOwner {
51         _transferOwnership(newOwner);
52     }
53    
54     function _transferOwnership(address newOwner) internal {
55         require(newOwner != address(0));
56         emit OwnershipTransferred(_owner, newOwner);
57         _owner = newOwner;
58     }
59 }
60 
61 
62 contract SafeMath {
63   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a * b;
65     assert(a == 0 || c / a == b);
66     return c;
67   }
68 
69   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b > 0);
71     uint256 c = a / b;
72     assert(a == b * c + a % b);
73     return c;
74   }
75 
76   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
82     uint256 c = a + b;
83     assert(c>=a && c>=b);
84     return c;
85   }
86 
87 }
88 
89 contract AarsChain is Ownable, SafeMath, IERC20{
90     string public name;
91     string public symbol;
92     uint8 public decimals;
93     uint256 public totalSupply;
94 
95     mapping (address => uint256) public balanceOf;
96     mapping (address => mapping (address => uint256)) public allowance;
97     event Transfer(address indexed from, address indexed to, uint256 value);
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99     constructor()  public  {
100         balanceOf[msg.sender] = 120000000000000000000000000;
101         totalSupply =120000000000000000000000000;
102         name = "Aars Chain";
103         symbol = "ARS";
104         decimals = 18;
105 		
106     }
107 
108     function transfer(address _to, uint256 _value) public returns (bool) {
109         require(_to != address(0));
110 		require(_value > 0); 
111         require(balanceOf[msg.sender] >= _value);
112         require(balanceOf[_to] + _value >= balanceOf[_to]);
113 		uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];		
114         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
115         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
116         emit Transfer(msg.sender, _to, _value);
117 		assert(balanceOf[msg.sender]+balanceOf[_to]==previousBalances);
118         return true;
119     }
120 
121     function approve(address _spender, uint256 _value) public returns (bool success) {
122 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
123         allowance[msg.sender][_spender] = _value;
124         emit Approval(msg.sender, _spender, _value);
125         return true;
126     }
127 
128     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
129         require (_to != address(0));
130 		require (_value > 0); 
131         require (balanceOf[_from] >= _value) ;
132         require (balanceOf[_to] + _value > balanceOf[_to]);
133         require (_value <= allowance[_from][msg.sender]);
134         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
135         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
136         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
137         emit Transfer(_from, _to, _value);
138         return true;
139     }
140 }