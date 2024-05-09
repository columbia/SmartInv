1 pragma solidity ^0.5.7;
2 
3 // Wesion Team Fund
4 //   Freezed till 2021-06-30 23:59:59, (timestamp 1625039999).
5 //   Release 10% per 3 months.
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Unsigned math operations with safety checks that revert on error.
11  */
12 library SafeMath {
13     /**
14      * @dev Adds two unsigned integers, reverts on overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         c = a + b;
18         assert(c >= a);
19         return c;
20     }
21 
22     /**
23      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
24      */
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     /**
31      * @dev Multiplies two unsigned integers, reverts on overflow.
32      */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
34         if (a == 0) {
35             return 0;
36         }
37         c = a * b;
38         assert(c / a == b);
39         return c;
40     }
41 
42     /**
43      * @dev Integer division of two unsigned integers truncating the quotient,
44      * reverts on division by zero.
45      */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         assert(b > 0);
48         uint256 c = a / b;
49         assert(a == b * c + a % b);
50         return a / b;
51     }
52 
53     /**
54      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55      * reverts when dividing by zero.
56      */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 
64 /**
65  * @title Ownable
66  */
67 contract Ownable {
68     address internal _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     /**
73      * @dev The Ownable constructor sets the original `owner` of the contract
74      * to the sender account.
75      */
76     constructor () internal {
77         _owner = msg.sender;
78         emit OwnershipTransferred(address(0), _owner);
79     }
80 
81     /**
82      * @return the address of the owner.
83      */
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      */
91     modifier onlyOwner() {
92         require(msg.sender == _owner);
93         _;
94     }
95 
96     /**
97      * @dev Allows the current owner to transfer control of the contract to a newOwner.
98      * @param newOwner The address to transfer ownership to.
99      */
100     function transferOwnership(address newOwner) external onlyOwner {
101         require(newOwner != address(0));
102         _owner = newOwner;
103         emit OwnershipTransferred(_owner, newOwner);
104     }
105 
106     /**
107      * @dev Withdraw Ether
108      */
109     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
110         require(to != address(0));
111 
112         uint256 balance = address(this).balance;
113 
114         require(balance >= amount);
115         to.transfer(amount);
116     }
117 }
118 
119 
120 /**
121  * @title ERC20 interface
122  * @dev see https://eips.ethereum.org/EIPS/eip-20
123  */
124 interface IERC20{
125     function balanceOf(address owner) external view returns (uint256);
126     function transfer(address to, uint256 value) external returns (bool);
127 }
128 
129 
130 /**
131  * @title Wesion Team Fund
132  */
133 contract WesionTeamFund is Ownable{
134     using SafeMath for uint256;
135 
136     IERC20 public Wesion;
137 
138     uint256 private _till = 1671606000;
139     uint256 private _WesionAmount = 4200000000000000; // 4.2 billion
140     uint256 private _3mo = 2592000; // Three months: 2,592,000 seconds
141 
142     uint256[10] private _freezedPct = [
143         100,    // 100%
144         90,     // 90%
145         80,     // 80%
146         70,     // 70%
147         60,     // 60%
148         50,     // 50%
149         40,     // 40%
150         30,     // 30%
151         20,     // 20%
152         10      // 10%
153     ];
154 
155     event Donate(address indexed account, uint256 amount);
156 
157 
158     /**
159      * @dev constructor
160      */
161     constructor() public {
162         Wesion = IERC20(0x2c1564A74F07757765642ACef62a583B38d5A213);
163     }
164 
165     /**
166      * @dev Wesion freezed amount.
167      */
168     function WesionFreezed() public view returns (uint256) {
169         uint256 __freezed;
170 
171         if (now > _till) {
172             uint256 __qrPassed = now.sub(_till).div(_3mo);
173 
174             if (__qrPassed >= 10) {
175                 __freezed = 0;
176             }
177             else {
178                 __freezed = _WesionAmount.mul(_freezedPct[__qrPassed]).div(100);
179             }
180 
181             return __freezed;
182         }
183 
184         return _WesionAmount;
185     }
186 
187     /**
188      * @dev Donate
189      */
190     function () external payable {
191         emit Donate(msg.sender, msg.value);
192     }
193 
194     /**
195      * @dev transfer Wesion
196      */
197     function transferWesion(address to, uint256 amount) external onlyOwner {
198         uint256 __freezed = WesionFreezed();
199         uint256 __released = Wesion.balanceOf(address(this)).sub(__freezed);
200 
201         require(__released >= amount);
202 
203         assert(Wesion.transfer(to, amount));
204     }
205 
206     /**
207      * @dev Rescue compatible ERC20 Token, except "Wesion"
208      *
209      * @param tokenAddr ERC20 The address of the ERC20 token contract
210      * @param receiver The address of the receiver
211      * @param amount uint256
212      */
213     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
214         IERC20 _token = IERC20(tokenAddr);
215         require(Wesion != _token);
216         require(receiver != address(0));
217 
218         uint256 balance = _token.balanceOf(address(this));
219         require(balance >= amount);
220         assert(_token.transfer(receiver, amount));
221     }
222 
223     /**
224      * @dev set Wesion Address
225      */
226     function setWesionAddress(address _WesionAddr) public onlyOwner {
227         Wesion = IERC20(_WesionAddr);
228     }
229 
230 }