1 pragma solidity ^0.5.7;
2 
3 // wesion Airdrop Fund
4 //   Keep your ETH balance > (...)
5 //      See https://wesion.io/en/latest/token/airdrop_via_contract.html
6 //
7 //   And call this contract (send 0 ETH here),
8 //   and you will receive 100-200 VNET Tokens immediately.
9 
10 /**
11  * @title Ownable
12  */
13 contract Ownable {
14     address internal _owner;
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18     /**
19      * @dev The Ownable constructor sets the original `owner` of the contract
20      * to the sender account.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @return the address of the owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(msg.sender == _owner);
39         _;
40     }
41 
42     /**
43      * @dev Allows the current owner to transfer control of the contract to a newOwner.
44      * @param newOwner The address to transfer ownership to.
45      */
46     function transferOwnership(address newOwner) external onlyOwner {
47         require(newOwner != address(0));
48         address __previousOwner = _owner;
49         _owner = newOwner;
50         emit OwnershipTransferred(__previousOwner, newOwner);
51     }
52 
53     /**
54      * @dev Rescue compatible ERC20 Token
55      *
56      * @param tokenAddr ERC20 The address of the ERC20 token contract
57      * @param receiver The address of the receiver
58      * @param amount uint256
59      */
60     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
61         IERC20 _token = IERC20(tokenAddr);
62         require(receiver != address(0));
63         uint256 balance = _token.balanceOf(address(this));
64 
65         require(balance >= amount);
66         assert(_token.transfer(receiver, amount));
67     }
68 
69     /**
70      * @dev Withdraw Ether
71      */
72     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
73         require(to != address(0));
74 
75         uint256 balance = address(this).balance;
76 
77         require(balance >= amount);
78         to.transfer(amount);
79     }
80 }
81 
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://eips.ethereum.org/EIPS/eip-20
86  */
87 interface IERC20{
88     function balanceOf(address owner) external view returns (uint256);
89     function transfer(address to, uint256 value) external returns (bool);
90 }
91 
92 
93 /**
94  * @title SafeMath
95  * @dev Unsigned math operations with safety checks that revert on error.
96  */
97 library SafeMath {
98     /**
99      * @dev Adds two unsigned integers, reverts on overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
102         c = a + b;
103         assert(c >= a);
104         return c;
105     }
106 
107     /**
108      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         assert(b <= a);
112         return a - b;
113     }
114 
115     /**
116      * @dev Multiplies two unsigned integers, reverts on overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
119         if (a == 0) {
120             return 0;
121         }
122         c = a * b;
123         assert(c / a == b);
124         return c;
125     }
126 
127     /**
128      * @dev Integer division of two unsigned integers truncating the quotient,
129      * reverts on division by zero.
130      */
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         assert(b > 0);
133         uint256 c = a / b;
134         assert(a == b * c + a % b);
135         return a / b;
136     }
137 
138     /**
139      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
140      * reverts when dividing by zero.
141      */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         require(b != 0);
144         return a % b;
145     }
146 }
147 
148 
149 /**
150  * @title wesion Airdrop
151  */
152 contract WesionAirdrop is Ownable {
153     using SafeMath for uint256;
154 
155     IERC20 public wesion;
156 
157     uint256 private _wei_min;
158 
159     mapping(address => bool) public _airdopped;
160 
161     event Donate(address indexed account, uint256 amount);
162 
163     /**
164      * @dev Wei Min
165      */
166     function wei_min() public view returns (uint256) {
167         return _wei_min;
168     }
169 
170     /**
171      * @dev constructor
172      */
173     constructor() public {
174         wesion = IERC20(0xF0921CF26f6BA21739530ccA9ba2548bB34308f1);
175     }
176 
177     /**
178      * @dev receive ETH and send wesions
179      */
180     function () external payable {
181         require(_airdopped[msg.sender] != true);
182         require(msg.sender.balance >= _wei_min);
183 
184         uint256 balance = wesion.balanceOf(address(this));
185         require(balance > 0);
186 
187         uint256 wesionAmount = 100;
188         wesionAmount = wesionAmount.add(uint256(keccak256(abi.encode(now, msg.sender, now))) % 100).mul(10 ** 6);
189 
190         if (wesionAmount <= balance) {
191             assert(wesion.transfer(msg.sender, wesionAmount));
192         } else {
193             assert(wesion.transfer(msg.sender, balance));
194         }
195 
196         if (msg.value > 0) {
197             emit Donate(msg.sender, msg.value);
198         }
199     }
200 
201     /**
202      * @dev set wei min
203      */
204     function setWeiMin(uint256 value) external onlyOwner {
205         _wei_min = value;
206     }
207 }