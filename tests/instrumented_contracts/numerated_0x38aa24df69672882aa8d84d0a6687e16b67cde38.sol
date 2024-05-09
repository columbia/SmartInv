1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         require(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b > 0);
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b <= a);
22         uint256 c = a - b;
23         return c;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a);
29         return c;
30     }
31 
32     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b != 0);
34         return a % b;
35     }
36 }
37 
38 contract BaseToken {
39     using SafeMath for uint256;
40 
41     string constant public name = 'Timedeposit';
42     string constant public symbol = 'TMD';
43     uint8 constant public decimals = 18;
44     uint256 public totalSupply = 5.256e26;
45     uint256 constant public _totalLimit = 1e32;
46 
47     mapping (address => uint256) public balanceOf;
48     mapping (address => mapping (address => uint256)) public allowance;
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 
53     function _transfer(address from, address to, uint value) internal {
54         require(to != address(0));
55         balanceOf[from] = balanceOf[from].sub(value);
56         balanceOf[to] = balanceOf[to].add(value);
57         emit Transfer(from, to, value);
58     }
59 
60     function _mint(address account, uint256 value) internal {
61         require(account != address(0));
62         totalSupply = totalSupply.add(value);
63         require(_totalLimit >= totalSupply);
64         balanceOf[account] = balanceOf[account].add(value);
65         emit Transfer(address(0), account, value);
66     }
67 
68     function transfer(address to, uint256 value) public returns (bool) {
69         _transfer(msg.sender, to, value);
70         return true;
71     }
72 
73     function transferFrom(address from, address to, uint256 value) public returns (bool) {
74         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
75         _transfer(from, to, value);
76         return true;
77     }
78 
79     function approve(address spender, uint256 value) public returns (bool) {
80         require(spender != address(0));
81         allowance[msg.sender][spender] = value;
82         emit Approval(msg.sender, spender, value);
83         return true;
84     }
85 
86     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
87         require(spender != address(0));
88         allowance[msg.sender][spender] = allowance[msg.sender][spender].add(addedValue);
89         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
90         return true;
91     }
92 
93     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
94         require(spender != address(0));
95         allowance[msg.sender][spender] = allowance[msg.sender][spender].sub(subtractedValue);
96         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
97         return true;
98     }
99 }
100 
101 contract CustomToken is BaseToken {
102     constructor() public {
103         balanceOf[0x58cBC34576EFC4f2591fbC6258f89961e7e34D48] = totalSupply;
104         emit Transfer(address(0), 0x58cBC34576EFC4f2591fbC6258f89961e7e34D48, totalSupply);
105     }
106 }