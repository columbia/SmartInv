1 pragma solidity =0.6.5;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address who) external view returns (uint256);
6     function allowance(address owner, address spender) external view returns (uint256);
7     function transfer(address to, uint256 value) external returns (bool);
8     function approve(address spender, uint256 value) external returns (bool);
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15 
16     /**
17     * @dev Multiplies two numbers, reverts on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b > 0); // Solidity only automatically asserts when dividing by 0
34         uint256 c = a / b;
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65 
66         return a % b;
67     }
68 }
69 
70 contract Ownable {
71     address private _owner;
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () internal {
75         _owner = 0x0B4509F330Ff558090571861a723F71657a26f78;
76         emit OwnershipTransferred(address(0), _owner);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == msg.sender, "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 contract ZyroToken is IERC20, Ownable {
101     using SafeMath for uint256;
102 
103     string  public name;
104     string  public symbol;
105     uint8   public decimals;
106     mapping (address => uint256) private _balances;
107     mapping (address => mapping (address => uint256)) private _allowed;
108     uint256 private _totalSupply;
109 
110     constructor() public {
111         symbol = "ZYRO";
112         name = "zyro";
113         decimals = 8;
114         uint _totalTokenAmount = (3*10 ** 8) * (10 ** 8); // 300million
115         _totalSupply = _totalTokenAmount;
116         _balances[owner()] = _totalTokenAmount;
117         emit Transfer(address(0x0), owner(), _totalTokenAmount);
118     }
119 
120     function totalSupply() override public view returns (uint256) {
121         return _totalSupply;
122     }
123 
124     function balanceOf(address owner) override public view returns (uint256) {
125         return _balances[owner];
126     }
127 
128     function allowance(address owner, address spender) override public view returns (uint256)
129     {
130         return _allowed[owner][spender];
131     }
132 
133     function transfer(address to, uint256 value) override public returns (bool) {
134         require(value <= _balances[msg.sender]);
135         require(to != address(0));
136 
137         _balances[msg.sender] = _balances[msg.sender].sub(value);
138         _balances[to] = _balances[to].add(value);
139         emit Transfer(msg.sender, to, value);
140         return true;
141     }
142 
143     function approve(address spender, uint256 value) override public returns (bool)
144     {
145         require(spender != address(0));
146 
147         _allowed[msg.sender][spender] = value;
148         emit Approval(msg.sender, spender, value);
149         return true;
150     }
151 
152     function transferFrom(address from, address to, uint256 value) override public returns (bool)
153     {
154         require(value <= _balances[from]);
155         require(value <= _allowed[from][msg.sender]);
156         require(to != address(0));
157 
158         _balances[from] = _balances[from].sub(value);
159         _balances[to] = _balances[to].add(value);
160         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
161         emit Transfer(from, to, value);
162         return true;
163     }
164 
165 }