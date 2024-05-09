1 /* 
2 
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣴⡶⠶⠿⠿⠟⠻⠿⠿⠶⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⠟⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠿⠋⠀⠀⠀⠀⠀⠀⣀⣀⣤⠤⢤⣀⡀⠀⠀⠀⠀⠀⠀⠈⠻⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⠁⠀⠀⠀⠀⠀⢀⡴⠛⣡⡀⠀⠀⣠⣄⠉⠳⣄⠀⠀⠀⠀⠀⠀⠀⠙⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡿⠃⠀⠀⠀⠀⠀⠀⢠⠋⠀⣸⣿⣿⣆⣰⣿⣿⣧⠀⠙⡆⠀⠀⠀⠀⠀⠀⠀⠀⠻⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠟⠀⠀⠀⠀⠀⠀⠀⠀⡏⠀⢰⣿⣿⠻⣿⣿⠿⣿⣿⣧⠀⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⠀⣿⣿⡟⠀⠘⠋⠀⢸⣿⣿⡇⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢦⣙⣛⣁⣠⡤⠤⠤⠤⣭⣥⣠⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⣸⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠶⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠓⠦⣤⡀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⠀⢀⡤⠞⠉⠀⠀⠀⢀⣀⣀⣀⣤⣤⣤⣤⣀⣀⣀⡀⠀⠀⠀⠀⠉⠳⢦⡀⠀⠀⠀⠀⠀⢹⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⢠⣿⠀⠀⠀⠀⠀⢀⡴⠋⠀⢀⣠⠴⠚⠋⠉⢁⣀⣤⣤⣤⣤⣤⣤⣤⣬⣍⣙⠓⠶⢤⡀⠀⠀⠙⣦⡀⠀⠀⠀⠈⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⣰⠏⠀⣠⠖⠉⣠⣶⣶⣾⣿⠋⠉⠀⠀⠀⠀⠀⠀⢀⣽⣿⣿⣿⣷⣦⣌⡓⠄⠀⠈⢷⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⢿⡆⠀⠀⠀⡏⠀⠘⠁⣠⣾⣿⠿⠿⠿⢿⣷⡀⠀⠀⠀⠀⠀⢀⣿⠿⠛⠛⠛⠿⣧⠈⠻⣦⡀⠀⠸⡇⠀⠀⢀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡀⠀⠀⣇⢀⣴⠟⠉⠽⠁⠀⣀⠤⠤⢌⠳⠀⠀⠀⠀⠀⠚⣡⠴⠦⣤⡀⠀⠙⠀⠀⠈⠻⣦⣠⡇⠀⠀⣸⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣦⡀⠹⠻⡇⠀⠀⠀⠀⣰⠁⣠⡶⢦⣀⠀⠀⠀⠀⠀⢰⣵⢶⣦⡀⠹⡄⠀⠀⠀⠀⠀⢸⠉⢀⣤⣾⣯⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠋⠈⠛⡆⠀⢇⠀⠀⠀⠀⡇⠀⣿⣄⣀⣿⡇⠀⠀⠀⠀⣿⣅⣀⣿⣧⠀⡇⠀⠀⠀⠀⢀⡏⠀⡟⠁⠀⠙⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⢸⡟⠒⠙⢶⣧⠀⢸⡄⠀⠀⠀⢣⠀⣿⣿⣿⡿⠛⠋⠉⠉⠑⠻⢿⣿⣿⡟⠀⠃⠀⠀⠀⠀⡼⠀⠀⣧⡞⠉⠁⢹⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⠀⢀⡤⣿⡀⣀⣷⠀⠀⠀⠀⠣⠘⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⠁⠀⠀⠀⠀⠀⠀⠙⢶⠀⣿⠤⠄⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 ⠀⠀⣠⣤⣤⣤⣀⠀⠀⢻⣆⠀⠀⠘⣷⠟⠉⠀⣾⣦⣄⡀⢀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡄⢀⣠⣴⣾⣧⠀⠀⠈⢶⠇⠀⠀⢀⣿⢃⣶⠿⠛⠻⣶⡄⠀⠀⠀
22 ⠀⣰⡟⠁⠀⠈⢻⣧⠀⠀⢻⣦⡀⠀⣀⠀⠀⠈⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⠄⠀⠀⢀⠀⠀⣠⣾⠃⣾⠇⠀⠀⠀⠈⣿⠀⠀⠀
23 ⠀⢻⡇⠀⠀⠀⠀⢿⡆⠀⠀⠙⠻⣶⣿⡆⠀⠀⠘⠿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⡿⠛⠁⠀⠀⠀⣿⣶⡾⠛⠁⢠⣿⠀⠀⠀⠀⠀⣿⠃⠀⠀
24 ⠀⠸⣷⠀⠀⠀⠀⢸⣧⠀⠀⠀⠀⠀⠘⣷⡀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣦⣤⣤⣀⣤⣤⣾⣿⣿⣿⡿⠟⠁⠀⠀⠀⠀⣼⡟⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⢠⣿⠀⠀⠀
25 ⠀⠀⣿⡆⠀⠀⠀⠘⣿⠀⠀⠀⠀⠀⠀⠘⢿⣦⡀⠀⠀⠀⠀⠀⠀⠸⡟⠛⠛⠿⠿⠿⠟⠛⠁⠀⠀⠀⠀⠀⠀⣠⣾⠟⠀⠀⠀⠀⠀⠸⣿⠀⠀⠀⠀⢸⡇⠀⠀⠀
26 ⠀⠀⢸⣧⠀⠀⠀⠀⣿⣴⣶⣶⣤⠀⠀⠀⠀⠉⣻⣷⣦⣄⡀⠀⠀⠀⠈⠛⠲⠶⠶⠒⢋⡄⠀⠀⠀⢀⣠⣴⡾⠛⠁⠀⠀⢠⡾⠟⠛⢿⣿⠀⠀⠀⠀⣿⣧⡀⠀⠀
27 ⢀⣶⠟⠛⠀⠀⠀⠀⡟⠁⠀⠀⢹⣷⣦⣤⣶⠟⠛⡟⠉⠉⠛⢶⣤⡀⠀⠉⠒⠒⠒⠊⠁⠀⠀⣠⡾⠟⢻⡟⠻⠷⣦⣴⠿⢿⡇⠀⠀⠀⠹⠀⠀⠀⠀⠋⠉⠻⣦⠀
28 ⣾⠇⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠘⠁⠈⠻⡀⠀⠀⡇⠀⠀⠀⢸⠀⠙⠓⠦⢤⣀⣀⣤⠤⠶⣟⠁⠀⠀⠀⣇⠀⠀⢸⠏⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡇
29 ⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⢀⠃⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠀⠀⠀⠀⢸⠀⠀⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇
30 ⠸⣷⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⢸⠀⢸⠀⣀⣀⡀⠀⠧⠤⢀⣀⣀⣀⣀⣀⡀⠤⠿⠀⢀⣤⣄⡀⣇⠀⢻⠀⠀⠀⠀⠀⠀⠀⢀⠀⣀⠀⠀⠀⠀⢀⣿⠃
31 ⠀⠹⣷⡀⠀⢲⡀⢷⠘⣆⠀⠀⠀⠀⠀⠀⣾⠀⢸⣾⠉⠉⠙⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⠋⠉⠻⣿⠀⠸⣆⠀⠀⠀⠀⠀⢀⡞⢀⡟⢠⠏⠀⢀⣾⠏⠀
32 ⠀⠀⠘⠿⣦⣀⠁⠀⠁⠈⠀⠀⠀⠀⣠⢾⣏⣠⡿⢿⣄⣀⣼⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣄⣀⣰⣿⢷⣄⣿⡓⠄⡀⠀⠀⠈⠀⠈⠀⢀⣠⣴⠟⠁⠀⠀
33 ⠀⠀⠀⠀⠈⠙⠻⠷⣶⣤⣄⣀⣀⣩⣴⠿⢻⡿⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠋⠁⠀⢻⣏⠻⣶⣤⣤⣤⣤⣴⡶⠿⠛⠋⠁⠀⠀⠀⠀
34 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠀⢠⣿⢧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⡀⠀⠈⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
35 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠊⢹⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
36 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
37 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢷⣦⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⡾⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
38 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠛⠿⠷⠶⠶⣶⣶⣶⣶⣶⣶⣶⣶⡶⠶⠿⠟⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
39 
40 It's a me, maaariooo
41 
42 $MARIO Twitter: https://twitter.com/0xMarioCoin
43 $MARIO Telegram: https://t.me/mariocoinfun
44 $MARIO Website: https://mariocoin.fun/
45 
46 */
47 
48 
49 
50 pragma solidity ^0.7.0;
51 
52 /**
53  * @dev Wrappers over Solidity's arithmetic operations with added overflow
54  * checks.
55  *
56  * Arithmetic operations in Solidity wrap on overflow. This can easily result
57  * in bugs, because programmers usually assume that an overflow raises an
58  * error, which is the standard behavior in high level programming languages.
59  * `SafeMath` restores this intuition by reverting the transaction when an
60  * operation overflows.
61  *
62  * Using this library instead of the unchecked operations eliminates an entire
63  * class of bugs, so it's recommended to use it always.
64  */
65 library SafeMath {
66     /**
67      * @dev Returns the addition of two unsigned integers, with an overflow flag.
68      *
69      * _Available since v3.4._
70      */
71     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         uint256 c = a + b;
73         if (c < a) return (false, 0);
74         return (true, c);
75     }
76 
77     /**
78      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
79      *
80      * _Available since v3.4._
81      */
82     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
83         if (b > a) return (false, 0);
84         return (true, a - b);
85     }
86 
87     /**
88      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
89      *
90      * _Available since v3.4._
91      */
92     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
93         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
94         // benefit is lost if 'b' is also tested.
95         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
96         if (a == 0) return (true, 0);
97         uint256 c = a * b;
98         if (c / a != b) return (false, 0);
99         return (true, c);
100     }
101 
102     /**
103      * @dev Returns the division of two unsigned integers, with a division by zero flag.
104      *
105      * _Available since v3.4._
106      */
107     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
108         if (b == 0) return (false, 0);
109         return (true, a / b);
110     }
111 
112     /**
113      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
114      *
115      * _Available since v3.4._
116      */
117     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
118         if (b == 0) return (false, 0);
119         return (true, a % b);
120     }
121 
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      *
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135         return c;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         require(b <= a, "SafeMath: subtraction overflow");
150         return a - b;
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `*` operator.
158      *
159      * Requirements:
160      *
161      * - Multiplication cannot overflow.
162      */
163     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164         if (a == 0) return 0;
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167         return c;
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers, reverting on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         require(b > 0, "SafeMath: division by zero");
184         return a / b;
185     }
186 
187     /**
188      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
189      * reverting when dividing by zero.
190      *
191      * Counterpart to Solidity's `%` operator. This function uses a `revert`
192      * opcode (which leaves remaining gas untouched) while Solidity uses an
193      * invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
200         require(b > 0, "SafeMath: modulo by zero");
201         return a % b;
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
206      * overflow (when the result is negative).
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {trySub}.
210      *
211      * Counterpart to Solidity's `-` operator.
212      *
213      * Requirements:
214      *
215      * - Subtraction cannot overflow.
216      */
217     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         require(b <= a, errorMessage);
219         return a - b;
220     }
221 
222     /**
223      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
224      * division by zero. The result is rounded towards zero.
225      *
226      * CAUTION: This function is deprecated because it requires allocating memory for the error
227      * message unnecessarily. For custom revert reasons use {tryDiv}.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b > 0, errorMessage);
239         return a / b;
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * reverting with custom message when dividing by zero.
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {tryMod}.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b > 0, errorMessage);
259         return a % b;
260     }
261 }
262 
263 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC20/IERC20.sol
264 
265 
266 
267 pragma solidity ^0.7.0;
268 
269 /**
270  * @dev Interface of the ERC20 standard as defined in the EIP.
271  */
272 interface IERC20 {
273     /**
274      * @dev Returns the amount of tokens in existence.
275      */
276     function totalSupply() external view returns (uint256);
277 
278     /**
279      * @dev Returns the amount of tokens owned by `account`.
280      */
281     function balanceOf(address account) external view returns (uint256);
282 
283     /**
284      * @dev Moves `amount` tokens from the caller's account to `recipient`.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * Emits a {Transfer} event.
289      */
290     function transfer(address recipient, uint256 amount) external returns (bool);
291 
292     /**
293      * @dev Returns the remaining number of tokens that `spender` will be
294      * allowed to spend on behalf of `owner` through {transferFrom}. This is
295      * zero by default.
296      *
297      * This value changes when {approve} or {transferFrom} are called.
298      */
299     function allowance(address owner, address spender) external view returns (uint256);
300 
301     /**
302      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * IMPORTANT: Beware that changing an allowance with this method brings the risk
307      * that someone may use both the old and the new allowance by unfortunate
308      * transaction ordering. One possible solution to mitigate this race
309      * condition is to first reduce the spender's allowance to 0 and set the
310      * desired value afterwards:
311      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
312      *
313      * Emits an {Approval} event.
314      */
315     function approve(address spender, uint256 amount) external returns (bool);
316 
317     /**
318      * @dev Moves `amount` tokens from `sender` to `recipient` using the
319      * allowance mechanism. `amount` is then deducted from the caller's
320      * allowance.
321      *
322      * Returns a boolean value indicating whether the operation succeeded.
323      *
324      * Emits a {Transfer} event.
325      */
326     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
327 
328     /**
329      * @dev Emitted when `value` tokens are moved from one account (`from`) to
330      * another (`to`).
331      *
332      * Note that `value` may be zero.
333      */
334     event Transfer(address indexed from, address indexed to, uint256 value);
335 
336     /**
337      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
338      * a call to {approve}. `value` is the new allowance.
339      */
340     event Approval(address indexed owner, address indexed spender, uint256 value);
341 }
342 
343 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/utils/Context.sol
344 
345 
346 
347 pragma solidity >=0.6.0 <0.8.0;
348 
349 /*
350  * @dev Provides information about the current execution context, including the
351  * sender of the transaction and its data. While these are generally available
352  * via msg.sender and msg.data, they should not be accessed in such a direct
353  * manner, since when dealing with GSN meta-transactions the account sending and
354  * paying for execution may not be the actual sender (as far as an application
355  * is concerned).
356  *
357  * This contract is only required for intermediate, library-like contracts.
358  */
359 abstract contract Context {
360     function _msgSender() internal view virtual returns (address payable) {
361         return msg.sender;
362     }
363 
364     function _msgData() internal view virtual returns (bytes memory) {
365         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
366         return msg.data;
367     }
368 }
369 
370 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/access/Ownable.sol
371 
372 
373 
374 pragma solidity ^0.7.0;
375 
376 /**
377  * @dev Contract module which provides a basic access control mechanism, where
378  * there is an account (an owner) that can be granted exclusive access to
379  * specific functions.
380  *
381  * By default, the owner account will be the one that deploys the contract. This
382  * can later be changed with {transferOwnership}.
383  *
384  * This module is used through inheritance. It will make available the modifier
385  * `onlyOwner`, which can be applied to your functions to restrict their use to
386  * the owner.
387  */
388 abstract contract Ownable is Context {
389     address private _owner;
390 
391     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
392 
393     /**
394      * @dev Initializes the contract setting the deployer as the initial owner.
395      */
396     constructor () {
397         address msgSender = _msgSender();
398         _owner = msgSender;
399         emit OwnershipTransferred(address(0), msgSender);
400     }
401 
402     /**
403      * @dev Returns the address of the current owner.
404      */
405     function owner() public view virtual returns (address) {
406         return _owner;
407     }
408 
409     /**
410      * @dev Throws if called by any account other than the owner.
411      */
412     modifier onlyOwner() {
413         require(owner() == _msgSender(), "Ownable: caller is not the owner");
414         _;
415     }
416 
417     /**
418      * @dev Leaves the contract without owner. It will not be possible to call
419      * `onlyOwner` functions anymore. Can only be called by the current owner.
420      *
421      * NOTE: Renouncing ownership will leave the contract without an owner,
422      * thereby removing any functionality that is only available to the owner.
423      */
424     function renounceOwnership() public virtual onlyOwner {
425         emit OwnershipTransferred(_owner, address(0));
426         _owner = address(0);
427     }
428 
429     /**
430      * @dev Transfers ownership of the contract to a new account (`newOwner`).
431      * Can only be called by the current owner.
432      */
433     function transferOwnership(address newOwner) public virtual onlyOwner {
434         require(newOwner != address(0), "Ownable: new owner is the zero address");
435         emit OwnershipTransferred(_owner, newOwner);
436         _owner = newOwner;
437     }
438 }
439 
440 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC20/ERC20.sol
441 
442 
443 
444 pragma solidity ^0.7.0;
445 
446 
447 
448 
449 /**
450  * @dev Implementation of the {IERC20} interface.
451  *
452  * This implementation is agnostic to the way tokens are created. This means
453  * that a supply mechanism has to be added in a derived contract using {_mint}.
454  * For a generic mechanism see {ERC20PresetMinterPauser}.
455  *
456  * TIP: For a detailed writeup see our guide
457  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
458  * to implement supply mechanisms].
459  *
460  * We have followed general OpenZeppelin guidelines: functions revert instead
461  * of returning `false` on failure. This behavior is nonetheless conventional
462  * and does not conflict with the expectations of ERC20 applications.
463  *
464  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
465  * This allows applications to reconstruct the allowance for all accounts just
466  * by listening to said events. Other implementations of the EIP may not emit
467  * these events, as it isn't required by the specification.
468  *
469  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
470  * functions have been added to mitigate the well-known issues around setting
471  * allowances. See {IERC20-approve}.
472  */
473 contract ERC20 is Context, IERC20 {
474     using SafeMath for uint256;
475 
476     mapping (address => uint256) private _balances;
477 
478     mapping (address => mapping (address => uint256)) private _allowances;
479 
480     uint256 private _totalSupply;
481 
482     string private _name;
483     string private _symbol;
484     uint8 private _decimals;
485 
486     /**
487      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
488      * a default value of 18.
489      *
490      * To select a different value for {decimals}, use {_setupDecimals}.
491      *
492      * All three of these values are immutable: they can only be set once during
493      * construction.
494      */
495     constructor (string memory name_, string memory symbol_) {
496         _name = name_;
497         _symbol = symbol_;
498         _decimals = 18;
499     }
500 
501     /**
502      * @dev Returns the name of the token.
503      */
504     function name() public view virtual returns (string memory) {
505         return _name;
506     }
507 
508     /**
509      * @dev Returns the symbol of the token, usually a shorter version of the
510      * name.
511      */
512     function symbol() public view virtual returns (string memory) {
513         return _symbol;
514     }
515 
516     /**
517      * @dev Returns the number of decimals used to get its user representation.
518      * For example, if `decimals` equals `2`, a balance of `505` tokens should
519      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
520      *
521      * Tokens usually opt for a value of 18, imitating the relationship between
522      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
523      * called.
524      *
525      * NOTE: This information is only used for _display_ purposes: it in
526      * no way affects any of the arithmetic of the contract, including
527      * {IERC20-balanceOf} and {IERC20-transfer}.
528      */
529     function decimals() public view virtual returns (uint8) {
530         return _decimals;
531     }
532 
533     /**
534      * @dev See {IERC20-totalSupply}.
535      */
536     function totalSupply() public view virtual override returns (uint256) {
537         return _totalSupply;
538     }
539 
540     /**
541      * @dev See {IERC20-balanceOf}.
542      */
543     function balanceOf(address account) public view virtual override returns (uint256) {
544         return _balances[account];
545     }
546 
547     /**
548      * @dev See {IERC20-transfer}.
549      *
550      * Requirements:
551      *
552      * - `recipient` cannot be the zero address.
553      * - the caller must have a balance of at least `amount`.
554      */
555     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
556         _transfer(_msgSender(), recipient, amount);
557         return true;
558     }
559 
560     /**
561      * @dev See {IERC20-allowance}.
562      */
563     function allowance(address owner, address spender) public view virtual override returns (uint256) {
564         return _allowances[owner][spender];
565     }
566 
567     /**
568      * @dev See {IERC20-approve}.
569      *
570      * Requirements:
571      *
572      * - `spender` cannot be the zero address.
573      */
574     function approve(address spender, uint256 amount) public virtual override returns (bool) {
575         _approve(_msgSender(), spender, amount);
576         return true;
577     }
578 
579     /**
580      * @dev See {IERC20-transferFrom}.
581      *
582      * Emits an {Approval} event indicating the updated allowance. This is not
583      * required by the EIP. See the note at the beginning of {ERC20}.
584      *
585      * Requirements:
586      *
587      * - `sender` and `recipient` cannot be the zero address.
588      * - `sender` must have a balance of at least `amount`.
589      * - the caller must have allowance for ``sender``'s tokens of at least
590      * `amount`.
591      */
592     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
593         _transfer(sender, recipient, amount);
594         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
595         return true;
596     }
597 
598     /**
599      * @dev Atomically increases the allowance granted to `spender` by the caller.
600      *
601      * This is an alternative to {approve} that can be used as a mitigation for
602      * problems described in {IERC20-approve}.
603      *
604      * Emits an {Approval} event indicating the updated allowance.
605      *
606      * Requirements:
607      *
608      * - `spender` cannot be the zero address.
609      */
610     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
611         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
612         return true;
613     }
614 
615     /**
616      * @dev Atomically decreases the allowance granted to `spender` by the caller.
617      *
618      * This is an alternative to {approve} that can be used as a mitigation for
619      * problems described in {IERC20-approve}.
620      *
621      * Emits an {Approval} event indicating the updated allowance.
622      *
623      * Requirements:
624      *
625      * - `spender` cannot be the zero address.
626      * - `spender` must have allowance for the caller of at least
627      * `subtractedValue`.
628      */
629     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
630         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
631         return true;
632     }
633 
634     /**
635      * @dev Moves tokens `amount` from `sender` to `recipient`.
636      *
637      * This is internal function is equivalent to {transfer}, and can be used to
638      * e.g. implement automatic token fees, slashing mechanisms, etc.
639      *
640      * Emits a {Transfer} event.
641      *
642      * Requirements:
643      *
644      * - `sender` cannot be the zero address.
645      * - `recipient` cannot be the zero address.
646      * - `sender` must have a balance of at least `amount`.
647      */
648     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
649         require(sender != address(0), "ERC20: transfer from the zero address");
650         require(recipient != address(0), "ERC20: transfer to the zero address");
651 
652         _beforeTokenTransfer(sender, recipient, amount);
653 
654         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
655         _balances[recipient] = _balances[recipient].add(amount);
656         emit Transfer(sender, recipient, amount);
657     }
658 
659     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
660      * the total supply.
661      *
662      * Emits a {Transfer} event with `from` set to the zero address.
663      *
664      * Requirements:
665      *
666      * - `to` cannot be the zero address.
667      */
668     function _mint(address account, uint256 amount) internal virtual {
669         require(account != address(0), "ERC20: mint to the zero address");
670 
671         _beforeTokenTransfer(address(0), account, amount);
672 
673         _totalSupply = _totalSupply.add(amount);
674         _balances[account] = _balances[account].add(amount);
675         emit Transfer(address(0), account, amount);
676     }
677 
678     /**
679      * @dev Destroys `amount` tokens from `account`, reducing the
680      * total supply.
681      *
682      * Emits a {Transfer} event with `to` set to the zero address.
683      *
684      * Requirements:
685      *
686      * - `account` cannot be the zero address.
687      * - `account` must have at least `amount` tokens.
688      */
689     function _burn(address account, uint256 amount) internal virtual {
690         require(account != address(0), "ERC20: burn from the zero address");
691 
692         _beforeTokenTransfer(account, address(0), amount);
693 
694         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
695         _totalSupply = _totalSupply.sub(amount);
696         emit Transfer(account, address(0), amount);
697     }
698 
699     /**
700      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
701      *
702      * This internal function is equivalent to `approve`, and can be used to
703      * e.g. set automatic allowances for certain subsystems, etc.
704      *
705      * Emits an {Approval} event.
706      *
707      * Requirements:
708      *
709      * - `owner` cannot be the zero address.
710      * - `spender` cannot be the zero address.
711      */
712     function _approve(address owner, address spender, uint256 amount) internal virtual {
713         require(owner != address(0), "ERC20: approve from the zero address");
714         require(spender != address(0), "ERC20: approve to the zero address");
715 
716         _allowances[owner][spender] = amount;
717         emit Approval(owner, spender, amount);
718     }
719 
720     /**
721      * @dev Sets {decimals} to a value other than the default one of 18.
722      *
723      * WARNING: This function should only be called from the constructor. Most
724      * applications that interact with token contracts will not expect
725      * {decimals} to ever change, and may work incorrectly if it does.
726      */
727     function _setupDecimals(uint8 decimals_) internal virtual {
728         _decimals = decimals_;
729     }
730 
731     /**
732      * @dev Hook that is called before any transfer of tokens. This includes
733      * minting and burning.
734      *
735      * Calling conditions:
736      *
737      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
738      * will be to transferred to `to`.
739      * - when `from` is zero, `amount` tokens will be minted for `to`.
740      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
741      * - `from` and `to` are never both zero.
742      *
743      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
744      */
745     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
746 }
747 
748 // File: Mario.sol
749 
750 
751 pragma solidity ^0.7.0;
752 
753 
754 
755 contract Token is ERC20, Ownable {
756 
757     constructor () ERC20("Mario", "MARIO") {
758         _mint(msg.sender, 1_000_000_000 ether);
759     }
760 
761     function renounceOwnership() public override onlyOwner {
762         transferOwnership(address(0x000000000000000000000000000000000000dEaD));
763     }
764 }