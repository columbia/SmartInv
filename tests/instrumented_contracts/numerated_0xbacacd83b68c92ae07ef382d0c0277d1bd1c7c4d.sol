1 pragma solidity 0.5.8;
2 
3 /**
4  *
5  * $PRESALE
6  * 
7  * On-chain memetic experience
8  *
9  * If you have a question please send an on-chain message so everyone can see answer :)
10  *
11  */
12 
13 
14 interface ERC20 {
15   function totalSupply() external view returns (uint256);
16   function balanceOf(address who) external view returns (uint256);
17   function allowance(address owner, address spender) external view returns (uint256);
18   function transfer(address to, uint256 value) external returns (bool);
19   function approve(address spender, uint256 value) external returns (bool);
20   function transferFrom(address from, address to, uint256 value) external returns (bool);
21 
22   event Transfer(address indexed from, address indexed to, uint256 value);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract PRESALE is ERC20 {
27     using SafeMath for uint256;
28 
29     mapping (address => uint256) private balances;
30     mapping (address => mapping (address => uint256)) private allowed;
31 
32     string public constant name  = "PRESALE";
33     string public constant symbol = "PSALE";
34     uint8 public constant decimals = 18;
35     uint256 constant MAX_SUPPLY = 69420000000 * (10 ** 18);
36 
37     constructor() public {
38         balances[msg.sender] = MAX_SUPPLY;
39         emit Transfer(address(0), msg.sender, MAX_SUPPLY);
40     }
41 
42     function totalSupply() public view returns (uint256) {
43         return MAX_SUPPLY;
44     }
45 
46     function balanceOf(address player) public view returns (uint256) {
47         return balances[player];
48     }
49 
50     function allowance(address player, address spender) public view returns (uint256) {
51         return allowed[player][spender];
52     }
53 
54     function transfer(address to, uint256 amount) public returns (bool) {
55         require(to != address(0));
56         transferInternal(msg.sender, to, amount);
57         return true;
58     }
59 
60     function transferFrom(address from, address to, uint256 amount) public returns (bool) {
61         require(to != address(0));
62         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
63         transferInternal(from, to, amount);
64         return true;
65     }
66 
67     function transferInternal(address from, address to, uint256 amount) internal {
68         balances[from] = balances[from].sub(amount);
69         balances[to] = balances[to].add(amount);
70         emit Transfer(from, to, amount);
71     }
72 
73     function approve(address spender, uint256 value) public returns (bool) {
74         require(spender != address(0));
75         allowed[msg.sender][spender] = value;
76         emit Approval(msg.sender, spender, value);
77         return true;
78     }
79 
80 }
81 
82 
83 library SafeMath {
84   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85     if (a == 0) {
86       return 0;
87     }
88     uint256 c = a * b;
89     require(c / a == b);
90     return c;
91   }
92 
93   function div(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a / b;
95     return c;
96   }
97 
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b <= a);
100     return a - b;
101   }
102 
103   function add(uint256 a, uint256 b) internal pure returns (uint256) {
104     uint256 c = a + b;
105     require(c >= a);
106     return c;
107   }
108 
109   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
110     uint256 c = add(a,m);
111     uint256 d = sub(c,1);
112     return mul(div(d,m),m);
113   }
114 }