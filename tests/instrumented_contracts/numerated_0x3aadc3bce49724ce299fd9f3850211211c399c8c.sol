1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.0;
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      *
8      * Counterpart to Solidity's `+` operator.
9      *
10      * Requirements:
11      *
12      * - Addition cannot overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21     /**
22      * @dev Returns the subtraction of two unsigned integers, reverting on
23      * overflow (when the result is negative).
24      *
25      * Counterpart to Solidity's `-` operator.
26      *
27      * Requirements:
28      *
29      * - Subtraction cannot overflow.
30      */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, reverting on
54      * overflow.
55      *
56      * Counterpart to Solidity's `*` operator.
57      *
58      * Requirements:
59      *
60      * - Multiplication cannot overflow.
61      */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the integer division of two unsigned integers. Reverts on
78      * division by zero. The result is rounded towards zero.
79      *
80      * Counterpart to Solidity's `/` operator. Note: this function uses a
81      * `revert` opcode (which leaves remaining gas untouched) while Solidity
82      * uses an invalid opcode to revert (consuming all remaining gas).
83      *
84      * Requirements:
85      *
86      * - The divisor cannot be zero.
87      */
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      *
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
114      * Reverts when dividing by zero.
115      *
116      * Counterpart to Solidity's `%` operator. This function uses a `revert`
117      * opcode (which leaves remaining gas untouched) while Solidity uses an
118      * invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
125         return mod(a, b, "SafeMath: modulo by zero");
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts with custom message when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b != 0, errorMessage);
142         return a % b;
143     }
144 }
145 interface IERC20 {
146     function transfer(address recipient, uint256 amount) external returns (bool);
147     function approve(address spender, uint256 amount) external returns (bool);
148     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
149 
150     event Transfer(address indexed from, address indexed to, uint256 value);
151     event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 contract CoinstoxToken is IERC20 {
155     using SafeMath for uint;
156     string  public name = "Coinstox Token";
157     string  public symbol = "CSX";
158     string  public standard = "Coinstox v1.0";
159     uint8 public decimals = 18;
160     uint256 public totalSupply;
161 
162     mapping(address => uint256) public balanceOf;
163     mapping(address => mapping(address => uint256)) public allowance;
164 
165     constructor(uint256 _initialSupply, address _software, address _marketing, address _ecosystem, address _reserve, address _founder, address _presale) public {
166         totalSupply = _initialSupply;
167         balanceOf[_software] = 8 * _initialSupply / 100;
168         balanceOf[_marketing] = 1295 * _initialSupply / 10000;
169         balanceOf[_reserve] = 7 * _initialSupply / 100;
170         balanceOf[_ecosystem] = 7 * _initialSupply / 100;
171         balanceOf[_founder] = 3 * _initialSupply / 100;
172         balanceOf[_presale] = 105 * _initialSupply / 10000;
173         _initialSupply = _initialSupply - balanceOf[_presale];
174         _initialSupply = _initialSupply - balanceOf[_ecosystem];
175         _initialSupply = _initialSupply - balanceOf[_software];
176         _initialSupply = _initialSupply - balanceOf[_marketing];
177         _initialSupply = _initialSupply - balanceOf[_reserve];
178         _initialSupply = _initialSupply - balanceOf[_founder];
179         balanceOf[msg.sender] = _initialSupply;
180     }
181 
182     function transfer(address _to, uint256 _value) public override returns (bool success) {
183         require(balanceOf[msg.sender] >= _value, 'Insufficient balance');
184         balanceOf[msg.sender] -= _value;
185         balanceOf[_to] += _value;
186 
187         emit Transfer(msg.sender, _to, _value);
188 
189         return true;
190     }
191 
192     function approve(address _spender, uint256 _value) public override returns (bool success) {
193         allowance[msg.sender][_spender] = _value;
194 
195         emit Approval(msg.sender, _spender, _value);
196 
197         return true;
198     }
199 
200     function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
201         require(_value <= balanceOf[_from], "From balance is not sufficient");
202         require(_value <= allowance[_from][msg.sender], "Sender is not allowed");
203 
204         balanceOf[_from] -= _value;
205         balanceOf[_to] += _value;
206 
207         allowance[_from][msg.sender] -= _value;
208 
209         emit Transfer(_from, _to, _value);
210 
211         return true;
212     }
213 }