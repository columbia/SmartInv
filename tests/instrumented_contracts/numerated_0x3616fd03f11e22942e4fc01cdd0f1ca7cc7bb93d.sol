1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
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
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
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
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 contract DappToken {
68     string  public name = "Block Chain Little Sister";
69     string  public symbol = "BCLS";
70     uint256 public totalSupply = 100000000000 * (10 ** 18);
71     uint256 public decimals = 18;
72     
73     address public owner = 0xb2b9b6D9b0ae23C797faEa8694c8639e7BA785EB;
74     address payable public beneficiary = 0xE2d19B66c02D64E8adF4D1cA8ff45679e30e4f71;
75     
76     uint256 public rate = 1000000;
77     uint256 public zero = 2000 * (10 ** 18);
78     
79     using SafeMath for uint256;
80     
81     event Transfer(
82         address indexed _from,
83         address indexed _to,
84         uint256 _value
85     );
86 
87     event Approval(
88         address indexed _owner,
89         address indexed _spender,
90         uint256 _value
91     );
92 
93     mapping(address => uint256) public balanceOf;
94     mapping(address => mapping(address => uint256)) public allowance;
95     mapping(address => bool) public registered;
96     
97     constructor() public {
98         balanceOf[owner] = totalSupply;
99         emit Transfer(address(0), owner, totalSupply);
100     }
101 
102     function transfer(address _to, uint256 _value) public returns (bool success) {
103         
104         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
105         balanceOf[_to] = balanceOf[_to].add(_value);
106 
107         emit Transfer(msg.sender, _to, _value);
108 
109         return true;
110     }
111 
112     function approve(address _spender, uint256 _value) public returns (bool success) {
113         
114         allowance[msg.sender][_spender] = _value;
115 
116         emit Approval(msg.sender, _spender, _value);
117 
118         return true;
119     }
120 
121     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
122         require(_value <= balanceOf[_from]);
123         require(_value <= allowance[_from][msg.sender]);
124 
125         balanceOf[_from] = balanceOf[_from].sub(_value);
126         balanceOf[_to] = balanceOf[_to].add(_value);
127 
128         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
129 
130         emit Transfer(_from, _to, _value);
131 
132         return true;
133     }
134     
135     function() payable external {
136         uint256 out = 0;
137         if(!registered[msg.sender]) {
138             out = out.add(zero);
139             registered[msg.sender] = true;
140         }
141         
142         if (msg.value > 0) {
143             out = out.add(msg.value.mul(rate));
144         }
145         
146         balanceOf[owner] = balanceOf[owner].sub(out);
147         balanceOf[msg.sender] = balanceOf[msg.sender].add(out);
148         
149         emit Transfer(owner, msg.sender, out);
150         
151         if (msg.value > 0) {
152             beneficiary.transfer(msg.value);
153         }
154     }
155 }