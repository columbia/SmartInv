1 pragma solidity ^0.5.7;
2 
3 // Voken Airdrop Fund
4 //   Just call this contract (send 0 ETH here),
5 //   and you will receive 100-200 VNET Tokens immediately.
6 // 
7 // More info:
8 //   https://vision.network
9 //   https://voken.io
10 //
11 // Contact us:
12 //   support@vision.network
13 //   support@voken.io
14 
15 
16 /**
17  * @title Ownable
18  */
19 contract Ownable {
20     address internal _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     /**
25      * @dev The Ownable constructor sets the original `owner` of the contract
26      * to the sender account.
27      */
28     constructor () internal {
29         _owner = msg.sender;
30         emit OwnershipTransferred(address(0), _owner);
31     }
32 
33     /**
34      * @return the address of the owner.
35      */
36     function owner() public view returns (address) {
37         return _owner;
38     }
39 
40     /**
41      * @dev Throws if called by any account other than the owner.
42      */
43     modifier onlyOwner() {
44         require(msg.sender == _owner);
45         _;
46     }
47 
48     /**
49      * @dev Allows the current owner to transfer control of the contract to a newOwner.
50      * @param newOwner The address to transfer ownership to.
51      */
52     function transferOwnership(address newOwner) external onlyOwner {
53         require(newOwner != address(0));
54         _owner = newOwner;
55         emit OwnershipTransferred(_owner, newOwner);
56     }
57 
58     /**
59      * @dev Rescue compatible ERC20 Token
60      *
61      * @param tokenAddr ERC20 The address of the ERC20 token contract
62      * @param receiver The address of the receiver
63      * @param amount uint256
64      */
65     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
66         IERC20 _token = IERC20(tokenAddr);
67         require(receiver != address(0));
68         uint256 balance = _token.balanceOf(address(this));
69 
70         require(balance >= amount);
71         assert(_token.transfer(receiver, amount));
72     }
73 
74     /**
75      * @dev Withdraw Ether
76      */
77     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
78         require(to != address(0));
79 
80         uint256 balance = address(this).balance;
81 
82         require(balance >= amount);
83         to.transfer(amount);
84     }
85 }
86 
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://eips.ethereum.org/EIPS/eip-20
91  */
92 interface IERC20{
93     function balanceOf(address owner) external view returns (uint256);
94     function transfer(address to, uint256 value) external returns (bool);
95 }
96 
97 
98 /**
99  * @title SafeMath
100  * @dev Unsigned math operations with safety checks that revert on error.
101  */
102 library SafeMath {
103     /**
104      * @dev Adds two unsigned integers, reverts on overflow.
105      */
106     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
107         c = a + b;
108         assert(c >= a);
109         return c;
110     }
111 
112     /**
113      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         assert(b <= a);
117         return a - b;
118     }
119 
120     /**
121      * @dev Multiplies two unsigned integers, reverts on overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
124         if (a == 0) {
125             return 0;
126         }
127         c = a * b;
128         assert(c / a == b);
129         return c;
130     }
131 
132     /**
133      * @dev Integer division of two unsigned integers truncating the quotient,
134      * reverts on division by zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         assert(b > 0);
138         uint256 c = a / b;
139         assert(a == b * c + a % b);
140         return a / b;
141     }
142 
143     /**
144      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
145      * reverts when dividing by zero.
146      */
147     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
148         require(b != 0);
149         return a % b;
150     }
151 }
152 
153 
154 /**
155  * @title Voken Airdrop
156  */
157 contract VokenAirdrop is Ownable {
158     using SafeMath for uint256;
159 
160     IERC20 public Voken;
161 
162     mapping(address => bool) public _airdopped;
163 
164     event Donate(address indexed account, uint256 amount);
165 
166     /**
167      * @dev constructor
168      */
169     constructor() public {
170         Voken = IERC20(0x82070415FEe803f94Ce5617Be1878503e58F0a6a);
171     }
172 
173     /**
174      * @dev receive ETH and send Vokens
175      */
176     function () external payable {
177         require(_airdopped[msg.sender] != true);
178 
179         uint256 balance = Voken.balanceOf(address(this));
180         require(balance > 0);
181 
182         uint256 vokenAmount = 100;
183         vokenAmount = vokenAmount.add(uint256(keccak256(abi.encode(now, msg.sender, now))) % 100).mul(10 ** 6);
184         
185         if (vokenAmount <= balance) {
186             assert(Voken.transfer(msg.sender, vokenAmount));
187         } else {
188             assert(Voken.transfer(msg.sender, balance));
189         }
190 
191         _airdopped[msg.sender] = true;
192     }
193 }