1 pragma solidity 0.6.12;
2 
3 
4 interface ERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address, uint256) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address, uint) external returns (bool);
10     function transferFrom(address, address, uint256) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 
17 library SafeMath {
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a);
21         uint256 c = a - b;
22         return c;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a);
28         return c;
29     }
30 
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         if (a == 0) {
33             return 0;
34         }
35         uint256 c = a * b;
36         require(c / a == b);
37         return c;
38     }
39 
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b > 0);
42         uint256 c = a / b;
43         return c;
44     }
45 
46     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b != 0);
48         return a % b;
49     }
50 }
51 
52 
53 contract Libera is ERC20 {
54 
55     using SafeMath for uint256;
56 
57     string public symbol;
58     string public name;
59     uint256 public decimals = 18;
60     uint256 public override totalSupply = 5000000 * (10 ** decimals);
61 
62     mapping(address => mapping(address => uint256)) public override allowance;
63     mapping(address => uint256) public override balanceOf;
64 
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     constructor() public {
69         balanceOf[msg.sender] = totalSupply;
70         symbol = "LIB";
71         name = "Libera";
72     }
73 
74     function _transfer(address _from, address _to, uint256 _value) internal {
75         require(_to != address(0));
76         require(_value <= balanceOf[_from]);
77         require(balanceOf[_to] <= balanceOf[_to].add(_value));
78 
79         balanceOf[_from] = balanceOf[_from].sub(_value);    
80         balanceOf[_to] = balanceOf[_to].add(_value);
81         emit Transfer(_from, _to, _value);           
82     }
83 
84     function approve(address spender, uint256 value) public override returns (bool success) {
85         allowance[msg.sender][spender] = value;
86         emit Approval(msg.sender, spender, value);
87         return true;
88     }
89 
90     function transfer(address to, uint256 value) public override returns (bool success) {
91         _transfer(msg.sender, to, value);
92         return true;
93     }
94 
95     function transferFrom(address from, address to, uint256 value) public override returns (bool success) {
96         require(value <= allowance[from][msg.sender]);
97         allowance[from][msg.sender] -= value;
98         _transfer(from, to, value);
99         return true;
100     }
101 }