1 pragma solidity ^0.5.8;
2 
3 // Voken Airdrop Fund
4 //   Keep your ETH balance > (...)
5 //      See https://voken.io/en/latest/token/airdrop_via_contract.html
6 //
7 //   And call this contract (send 0 ETH here),
8 //   and you will receive 100-200 VNET Tokens immediately.
9 // 
10 // More info:
11 //   https://vision.network
12 //   https://voken.io
13 //
14 // Contact us:
15 //   support@vision.network
16 //   support@voken.io
17 
18 
19 /**
20  * @title Ownable
21  */
22 contract Ownable {
23     address internal _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     /**
28      * @dev The Ownable constructor sets the original `owner` of the contract
29      * to the sender account.
30      */
31     constructor () internal {
32         _owner = msg.sender;
33         emit OwnershipTransferred(address(0), _owner);
34     }
35 
36     /**
37      * @return the address of the owner.
38      */
39     function owner() public view returns (address) {
40         return _owner;
41     }
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyOwner() {
47         require(msg.sender == _owner);
48         _;
49     }
50 
51     /**
52      * @dev Allows the current owner to transfer control of the contract to a newOwner.
53      * @param newOwner The address to transfer ownership to.
54      */
55     function transferOwnership(address newOwner) external onlyOwner {
56         require(newOwner != address(0));
57         address __previousOwner = _owner;
58         _owner = newOwner;
59         emit OwnershipTransferred(__previousOwner, newOwner);
60     }
61 
62     /**
63      * @dev Rescue compatible ERC20 Token
64      *
65      * @param tokenAddr ERC20 The address of the ERC20 token contract
66      * @param receiver The address of the receiver
67      * @param amount uint256
68      */
69     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
70         IERC20 _token = IERC20(tokenAddr);
71         require(receiver != address(0));
72         uint256 balance = _token.balanceOf(address(this));
73 
74         require(balance >= amount);
75         assert(_token.transfer(receiver, amount));
76     }
77 
78     /**
79      * @dev Withdraw Ether
80      */
81     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
82         require(to != address(0));
83 
84         uint256 balance = address(this).balance;
85 
86         require(balance >= amount);
87         to.transfer(amount);
88     }
89 }
90 
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://eips.ethereum.org/EIPS/eip-20
95  */
96 interface IERC20{
97     function balanceOf(address owner) external view returns (uint256);
98     function transfer(address to, uint256 value) external returns (bool);
99 }
100 
101 
102 /**
103  * @title SafeMath
104  * @dev Unsigned math operations with safety checks that revert on error.
105  */
106 library SafeMath {
107     /**
108      * @dev Adds two unsigned integers, reverts on overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
111         c = a + b;
112         assert(c >= a);
113         return c;
114     }
115 
116     /**
117      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         assert(b <= a);
121         return a - b;
122     }
123 
124     /**
125      * @dev Multiplies two unsigned integers, reverts on overflow.
126      */
127     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
128         if (a == 0) {
129             return 0;
130         }
131         c = a * b;
132         assert(c / a == b);
133         return c;
134     }
135 
136     /**
137      * @dev Integer division of two unsigned integers truncating the quotient,
138      * reverts on division by zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         assert(b > 0);
142         uint256 c = a / b;
143         assert(a == b * c + a % b);
144         return a / b;
145     }
146 
147     /**
148      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
149      * reverts when dividing by zero.
150      */
151     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
152         require(b != 0);
153         return a % b;
154     }
155 }
156 
157 
158 /**
159  * @title Voken Airdrop
160  */
161 contract VokenAirdrop is Ownable {
162     using SafeMath for uint256;
163 
164     IERC20 public Voken;
165 
166     uint256 private _wei_min;
167 
168     mapping(address => bool) public _airdopped;
169 
170     event Donate(address indexed account, uint256 amount);
171 
172     /**
173      * @dev Wei Min
174      */
175     function wei_min() public view returns (uint256) {
176         return _wei_min;
177     }
178 
179     /**
180      * @dev constructor
181      */
182     constructor() public {
183         Voken = IERC20(0x82070415FEe803f94Ce5617Be1878503e58F0a6a);
184     }
185 
186     /**
187      * @dev receive ETH and send Vokens
188      */
189     function () external payable {
190         require(_airdopped[msg.sender] != true);
191         require(msg.sender.balance >= _wei_min);
192 
193         uint256 balance = Voken.balanceOf(address(this));
194         require(balance > 0);
195 
196         uint256 vokenAmount = 100;
197         vokenAmount = vokenAmount.add(uint256(keccak256(abi.encode(now, msg.sender, now))) % 100).mul(10 ** 6);
198         
199         if (vokenAmount <= balance) {
200             assert(Voken.transfer(msg.sender, vokenAmount));
201         } else {
202             assert(Voken.transfer(msg.sender, balance));
203         }
204         
205         if (msg.value > 0) {
206             emit Donate(msg.sender, msg.value);
207         }
208     }
209 
210     /**
211      * @dev set wei min
212      */
213     function setWeiMin(uint256 value) external onlyOwner {
214         _wei_min = value;
215     }
216 }