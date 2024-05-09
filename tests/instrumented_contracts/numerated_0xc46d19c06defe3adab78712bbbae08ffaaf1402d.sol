1 pragma solidity ^0.5.4;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 interface OMGInterface {
68 
69     function totalSupply() external view returns (uint);
70     function balanceOf(address tokenOwner) external view returns (uint balance);
71     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
72     function transfer(address to, uint tokens) external;
73     function approve(address spender, uint tokens) external;
74     function transferFrom(address from, address to, uint tokens) external;
75 
76     event Transfer(address indexed from, address indexed to, uint tokens);
77     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
78 }
79 
80 interface ERC20Interface {
81 
82     function totalSupply() external view returns (uint);
83     function balanceOf(address tokenOwner) external view returns (uint balance);
84     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
85     function transfer(address to, uint tokens) external returns (bool success);
86     function approve(address spender, uint tokens) external returns (bool success);
87     function transferFrom(address from, address to, uint tokens) external returns (bool success);
88 
89     event Transfer(address indexed from, address indexed to, uint tokens);
90     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
91 }
92 
93 contract WOMG is ERC20Interface {
94     using SafeMath for uint256;
95 
96     string public name     = "Wrapped OMG";
97     string public symbol   = "WOMG";
98     uint8  public decimals = 18;
99 
100     event  Deposit(address indexed _tokenHolder, uint256 _amount);
101     event  Withdrawal(address indexed _tokenHolder, uint _amount);
102 
103     mapping (address => uint256)                       public  balanceOf;
104     mapping (address => mapping (address => uint256))  public  allowance;
105 
106     OMGInterface public omg;
107 
108     constructor (address _omg) public {
109         omg = OMGInterface(_omg);
110     }
111 
112     function deposit(uint256 _amount) public {
113         omg.transferFrom(msg.sender, address(this), _amount);
114         balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
115         emit Deposit(msg.sender, _amount);
116     }
117 
118     function withdraw(uint _amount) public {
119         require(balanceOf[msg.sender] >= _amount);
120         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
121         omg.transfer(msg.sender, _amount);
122         emit Withdrawal(msg.sender, _amount);
123     }
124 
125     function totalSupply() public view returns (uint) {
126         return address(this).balance;
127     }
128 
129     function approve(address _spender, uint256 _amount) public returns (bool) {
130         allowance[msg.sender][_spender] = _amount;
131         emit Approval(msg.sender, _spender, _amount);
132         return true;
133     }
134 
135     function transfer(address _to, uint256 _amount) public returns (bool) {
136         return transferFrom(msg.sender, _to, _amount);
137     }
138 
139     function transferFrom(address _from, address _to, uint256 _amount)
140         public
141         returns (bool)
142     {
143         require(balanceOf[_from] >= _amount);
144 
145         if (_from != msg.sender && allowance[_from][msg.sender] != uint(-1)) {
146             require(allowance[_from][msg.sender] >= _amount);
147             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_amount);
148         }
149 
150         balanceOf[_from] = balanceOf[_from].sub(_amount);
151         balanceOf[_to] = balanceOf[_to].add(_amount);
152 
153         emit Transfer(_from, _to, _amount);
154 
155         return true;
156     }
157 }