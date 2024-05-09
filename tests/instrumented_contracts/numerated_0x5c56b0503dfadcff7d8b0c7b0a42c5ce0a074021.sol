1 pragma solidity ^0.5.7;
2 
3 // Wesion Early Investors Fund
4 //   Freezed till 2020-06-30 23:59:59, (timestamp 1593532799).
5 
6 
7 /**
8  * @title SafeMath
9  * @dev Unsigned math operations with safety checks that revert on error.
10  */
11 library SafeMath {
12     /**
13      * @dev Adds two unsigned integers, reverts on overflow.
14      */
15     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         c = a + b;
17         assert(c >= a);
18         return c;
19     }
20 
21     /**
22      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
23      */
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     /**
30      * @dev Multiplies two unsigned integers, reverts on overflow.
31      */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33         if (a == 0) {
34             return 0;
35         }
36         c = a * b;
37         assert(c / a == b);
38         return c;
39     }
40 
41     /**
42      * @dev Integer division of two unsigned integers truncating the quotient,
43      * reverts on division by zero.
44      */
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         assert(b > 0);
47         uint256 c = a / b;
48         assert(a == b * c + a % b);
49         return a / b;
50     }
51 
52     /**
53      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
54      * reverts when dividing by zero.
55      */
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b != 0);
58         return a % b;
59     }
60 }
61 
62 
63 /**
64  * @title Ownable
65  */
66 contract Ownable {
67     address internal _owner;
68 
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     /**
72      * @dev The Ownable constructor sets the original `owner` of the contract
73      * to the sender account.
74      */
75     constructor () internal {
76         _owner = msg.sender;
77         emit OwnershipTransferred(address(0), _owner);
78     }
79 
80     /**
81      * @return the address of the owner.
82      */
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     /**
88      * @dev Throws if called by any account other than the owner.
89      */
90     modifier onlyOwner() {
91         require(msg.sender == _owner);
92         _;
93     }
94 
95     /**
96      * @dev Allows the current owner to transfer control of the contract to a newOwner.
97      * @param newOwner The address to transfer ownership to.
98      */
99     function transferOwnership(address newOwner) external onlyOwner {
100         require(newOwner != address(0));
101         _owner = newOwner;
102         emit OwnershipTransferred(_owner, newOwner);
103     }
104 
105     /**
106      * @dev Withdraw Ether
107      */
108     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
109         require(to != address(0));
110 
111         uint256 balance = address(this).balance;
112 
113         require(balance >= amount);
114         to.transfer(amount);
115     }
116 }
117 
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://eips.ethereum.org/EIPS/eip-20
122  */
123 interface IERC20{
124     function balanceOf(address owner) external view returns (uint256);
125     function transfer(address to, uint256 value) external returns (bool);
126 }
127 
128 
129 /**
130  * @title Wesion Early Investors Fund
131  */
132 contract WesionEarlyInvestorsFund is Ownable{
133     using SafeMath for uint256;
134 
135     IERC20 public Wesion;
136 
137     uint32 private _till = 1592722800;
138     uint256 private _holdings;
139 
140     mapping (address => uint256) private _investors;
141 
142     event InvestorRegistered(address indexed account, uint256 amount);
143     event Donate(address indexed account, uint256 amount);
144 
145 
146     /**
147      * @dev constructor
148      */
149     constructor() public {
150         Wesion = IERC20(0x2c1564A74F07757765642ACef62a583B38d5A213);
151     }
152 
153     /**
154      * @dev Withdraw or Donate by any amount
155      */
156     function () external payable {
157         if (now > _till && _investors[msg.sender] > 0) {
158             assert(Wesion.transfer(msg.sender, _investors[msg.sender]));
159             _investors[msg.sender] = 0;
160         }
161 
162         if (msg.value > 0) {
163             emit Donate(msg.sender, msg.value);
164         }
165     }
166 
167     /**
168      * @dev holdings amount
169      */
170     function holdings() public view returns (uint256) {
171         return _holdings;
172     }
173 
174     /**
175      * @dev balance of the owner
176      */
177     function investor(address owner) public view returns (uint256) {
178         return _investors[owner];
179     }
180 
181     /**
182      * @dev register an investor
183      */
184     function registerInvestor(address to, uint256 amount) external onlyOwner {
185         _holdings = _holdings.add(amount);
186         require(_holdings <= Wesion.balanceOf(address(this)));
187         _investors[to] = _investors[to].add(amount);
188         emit InvestorRegistered(to, amount);
189     }
190 
191     /**
192      * @dev Rescue compatible ERC20 Token, except "Wesion"
193      *
194      * @param tokenAddr ERC20 The address of the ERC20 token contract
195      * @param receiver The address of the receiver
196      * @param amount uint256
197      */
198     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
199         IERC20 _token = IERC20(tokenAddr);
200         require(Wesion != _token);
201         require(receiver != address(0));
202 
203         uint256 balance = _token.balanceOf(address(this));
204         require(balance >= amount);
205         assert(_token.transfer(receiver, amount));
206     }
207 
208     /**
209      * @dev set Wesion Address
210      */
211     function setWesionAddress(address _WesionAddr) public onlyOwner {
212         Wesion = IERC20(_WesionAddr);
213     }
214 }