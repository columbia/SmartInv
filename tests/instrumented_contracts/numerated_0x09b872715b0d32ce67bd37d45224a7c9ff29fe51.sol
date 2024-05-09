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
57         _owner = newOwner;
58         emit OwnershipTransferred(_owner, newOwner);
59     }
60 
61     /**
62      * @dev Rescue compatible ERC20 Token
63      *
64      * @param tokenAddr ERC20 The address of the ERC20 token contract
65      * @param receiver The address of the receiver
66      * @param amount uint256
67      */
68     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
69         IERC20 _token = IERC20(tokenAddr);
70         require(receiver != address(0));
71         uint256 balance = _token.balanceOf(address(this));
72 
73         require(balance >= amount);
74         assert(_token.transfer(receiver, amount));
75     }
76 
77     /**
78      * @dev Withdraw Ether
79      */
80     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
81         require(to != address(0));
82 
83         uint256 balance = address(this).balance;
84 
85         require(balance >= amount);
86         to.transfer(amount);
87     }
88 }
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://eips.ethereum.org/EIPS/eip-20
94  */
95 interface IERC20{
96     function balanceOf(address owner) external view returns (uint256);
97     function transfer(address to, uint256 value) external returns (bool);
98 }
99 
100 
101 /**
102  * @title SafeMath
103  * @dev Unsigned math operations with safety checks that revert on error.
104  */
105 library SafeMath {
106     /**
107      * @dev Adds two unsigned integers, reverts on overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110         c = a + b;
111         assert(c >= a);
112         return c;
113     }
114 
115     /**
116      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         assert(b <= a);
120         return a - b;
121     }
122 
123     /**
124      * @dev Multiplies two unsigned integers, reverts on overflow.
125      */
126     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
127         if (a == 0) {
128             return 0;
129         }
130         c = a * b;
131         assert(c / a == b);
132         return c;
133     }
134 
135     /**
136      * @dev Integer division of two unsigned integers truncating the quotient,
137      * reverts on division by zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         assert(b > 0);
141         uint256 c = a / b;
142         assert(a == b * c + a % b);
143         return a / b;
144     }
145 
146     /**
147      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
148      * reverts when dividing by zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         require(b != 0);
152         return a % b;
153     }
154 }
155 
156 
157 /**
158  * @title Voken Airdrop
159  */
160 contract VokenAirdrop is Ownable {
161     using SafeMath for uint256;
162 
163     IERC20 public Voken;
164 
165     uint256 private _wei_min;
166 
167     mapping(address => bool) public _airdopped;
168 
169     event Donate(address indexed account, uint256 amount);
170 
171     /**
172      * @dev constructor
173      */
174     constructor() public {
175         Voken = IERC20(0x82070415FEe803f94Ce5617Be1878503e58F0a6a);
176     }
177 
178     /**
179      * @dev receive ETH and send Vokens
180      */
181     function () external payable {
182         require(_airdopped[msg.sender] != true);
183         require(msg.sender.balance >= _wei_min);
184 
185         uint256 balance = Voken.balanceOf(address(this));
186         require(balance > 0);
187 
188         uint256 vokenAmount = 100;
189         vokenAmount = vokenAmount.add(uint256(keccak256(abi.encode(now, msg.sender, now))) % 100).mul(10 ** 6);
190         
191         if (vokenAmount <= balance) {
192             assert(Voken.transfer(msg.sender, vokenAmount));
193         } else {
194             assert(Voken.transfer(msg.sender, balance));
195         }
196         
197         if (msg.value > 0) {
198             emit Donate(msg.sender, msg.value);
199         }
200     }
201 
202     /**
203      * @dev set wei min
204      */
205     function setWeiMin(uint256 value) external onlyOwner {
206         _wei_min = value;
207     }
208 }