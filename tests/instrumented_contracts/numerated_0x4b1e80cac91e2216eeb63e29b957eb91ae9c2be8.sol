1 pragma solidity ^0.6.0;
2 //
3 // SPDX-License-Identifier: MIT
4 //
5 
6 contract Jupiter {
7 
8     string public constant name = "Jupiter";
9     string public constant symbol = "JUP";
10     uint8 public constant decimals = 18;  
11 
12 
13     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
14     event Transfer(address indexed from, address indexed to, uint tokens);
15 
16 
17     mapping(address => uint256) balances;
18 
19     mapping(address => mapping (address => uint256)) allowed;
20     
21     uint256 totalSupply_;
22 
23     using SafeMath for uint256;
24 
25 
26    constructor(uint256 total) public {  
27 	totalSupply_ = total;
28 	balances[msg.sender] = totalSupply_;
29     }  
30 
31     function totalSupply() public view returns (uint256) {
32 	return totalSupply_;
33     }
34     
35     function balanceOf(address tokenOwner) public view returns (uint) {
36         return balances[tokenOwner];
37     }
38 
39     function transfer(address receiver, uint numTokens) public returns (bool) {
40         require(numTokens <= balances[msg.sender]);
41         balances[msg.sender] = balances[msg.sender].sub(numTokens);
42         balances[receiver] = balances[receiver].add(numTokens);
43         emit Transfer(msg.sender, receiver, numTokens);
44         return true;
45     }
46 
47     function approve(address delegate, uint numTokens) public returns (bool) {
48         allowed[msg.sender][delegate] = numTokens;
49         Approval(msg.sender, delegate, numTokens);
50         return true;
51     }
52 
53     function allowance(address owner, address delegate) public view returns (uint) {
54         return allowed[owner][delegate];
55     }
56 
57     function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
58         require(numTokens <= balances[owner]);    
59         require(numTokens <= allowed[owner][msg.sender]);
60     
61         balances[owner] = balances[owner].sub(numTokens);
62         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
63         balances[buyer] = balances[buyer].add(numTokens);
64         Transfer(owner, buyer, numTokens);
65         return true;
66     }
67 }
68 
69 // 
70 /**
71  * @dev Wrappers over Solidity's arithmetic operations with added overflow
72  * checks.
73  *
74  * Arithmetic operations in Solidity wrap on overflow. This can easily result
75  * in bugs, because programmers usually assume that an overflow raises an
76  * error, which is the standard behavior in high level programming languages.
77  * `SafeMath` restores this intuition by reverting the transaction when an
78  * operation overflows.
79  *
80  * Using this library instead of the unchecked operations eliminates an entire
81  * class of bugs, so it's recommended to use it always.
82  */
83 library SafeMath {
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         uint256 c = a + b;
96         require(c >= a, "SafeMath: addition overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return sub(a, b, "SafeMath: subtraction overflow");
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
126         require(b <= a, errorMessage);
127         uint256 c = a - b;
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the multiplication of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `*` operator.
137      *
138      * Requirements:
139      *
140      * - Multiplication cannot overflow.
141      */
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
144         // benefit is lost if 'b' is also tested.
145         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
146         if (a == 0) {
147             return 0;
148         }
149 
150         uint256 c = a * b;
151         require(c / a == b, "SafeMath: multiplication overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the integer division of two unsigned integers. Reverts on
158      * division by zero. The result is rounded towards zero.
159      *
160      * Counterpart to Solidity's `/` operator. Note: this function uses a
161      * `revert` opcode (which leaves remaining gas untouched) while Solidity
162      * uses an invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      *
166      * - The divisor cannot be zero.
167      */
168     function div(uint256 a, uint256 b) internal pure returns (uint256) {
169         return div(a, b, "SafeMath: division by zero");
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b > 0, errorMessage);
186         uint256 c = a / b;
187         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
194      * Reverts when dividing by zero.
195      *
196      * Counterpart to Solidity's `%` operator. This function uses a `revert`
197      * opcode (which leaves remaining gas untouched) while Solidity uses an
198      * invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
205         return mod(a, b, "SafeMath: modulo by zero");
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts with custom message when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b != 0, errorMessage);
222         return a % b;
223     }
224 }
225 
226 // library SafeMath { 
227 //     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
228 //       assert(b <= a);
229 //       return a - b;
230 //     }
231     
232 //     function add(uint256 a, uint256 b) internal pure returns (uint256) {
233 //       uint256 c = a + b;
234 //       assert(c >= a);
235 //       return c;
236 //     }
237 // }