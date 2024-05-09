1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20 {
72   function totalSupply() external view returns (uint256);
73 
74   function balanceOf(address who) external view returns (uint256);
75 
76   function allowance(address owner, address spender)
77     external view returns (uint256);
78 
79   function transfer(address to, uint256 value) external returns (bool);
80 
81   function approve(address spender, uint256 value)
82     external returns (bool);
83 
84   function transferFrom(address from, address to, uint256 value)
85     external returns (bool);
86 
87   event Transfer(
88     address indexed from,
89     address indexed to,
90     uint256 value
91   );
92 
93   event Approval(
94     address indexed owner,
95     address indexed spender,
96     uint256 value
97   );
98 }
99 
100 
101 interface AddressRegistry {
102     function getAddr(string name) external view returns(address);
103 }
104 
105 interface Kyber {
106     function trade(
107         address src,
108         uint srcAmount,
109         address dest,
110         address destAddress,
111         uint maxDestAmount,
112         uint minConversionRate,
113         address walletId
114     ) external payable returns (uint);
115 
116     function getExpectedRate(
117         address src,
118         address dest,
119         uint srcQty
120     ) external view returns (uint, uint);
121 }
122 
123 
124 contract Registry {
125     address public addressRegistry;
126     modifier onlyAdmin() {
127         require(
128             msg.sender == getAddress("admin"),
129             "Permission Denied"
130         );
131         _;
132     }
133     function getAddress(string name) internal view returns(address) {
134         AddressRegistry addrReg = AddressRegistry(addressRegistry);
135         return addrReg.getAddr(name);
136     }
137 
138 }
139 
140 
141 contract Trade is Registry {
142 
143     using SafeMath for uint;
144     using SafeMath for uint256;
145 
146     event KyberTrade(
147         address src,
148         uint srcAmt,
149         address dest,
150         uint destAmt,
151         address beneficiary,
152         uint minConversionRate,
153         address affiliate
154     );
155 
156     function executeTrade(
157         address src,
158         address dest,
159         uint srcAmt,
160         uint minConversionRate
161     ) public payable returns (uint destAmt)
162     {
163         address protocolAdmin = getAddress("admin");
164         uint ethQty;
165 
166         // fetch token & deduct fees
167         IERC20 tokenFunctions = IERC20(src);
168         if (src == getAddress("eth")) {
169             require(msg.value == srcAmt, "Invalid Operation");
170             ethQty = srcAmt;
171         } else {
172             tokenFunctions.transferFrom(msg.sender, address(this), srcAmt);
173         }
174 
175         Kyber kyberFunctions = Kyber(getAddress("kyber"));
176         destAmt = kyberFunctions.trade.value(ethQty)(
177             src,
178             srcAmt,
179             dest,
180             msg.sender,
181             2**256 - 1,
182             minConversionRate,
183             protocolAdmin
184         );
185 
186         emit KyberTrade(
187             src,
188             srcAmt,
189             dest,
190             destAmt,
191             msg.sender,
192             minConversionRate,
193             protocolAdmin
194         );
195 
196     }
197 
198     function getExpectedPrice(
199         address src,
200         address dest,
201         uint srcAmt
202     ) public view returns (uint, uint) 
203     {
204         Kyber kyberFunctions = Kyber(getAddress("kyber"));
205         return kyberFunctions.getExpectedRate(
206             src,
207             dest,
208             srcAmt
209         );
210     }
211 
212     function approveKyber(address[] tokenArr) public {
213         for (uint i = 0; i < tokenArr.length; i++) {
214             IERC20 tokenFunctions = IERC20(tokenArr[i]);
215             tokenFunctions.approve(getAddress("kyber"), 2**256 - 1);
216         }
217     }
218 
219 }
220 
221 
222 contract MoatKyber is Trade {
223 
224     event AssetsCollected(address name, uint addr);
225 
226     constructor(address rAddr) public {
227         addressRegistry = rAddr;
228     }
229 
230     function () public payable {}
231 
232     function collectAsset(address tokenAddress, uint amount) public onlyAdmin {
233         if (tokenAddress == getAddress("eth")) {
234             msg.sender.transfer(amount);
235         } else {
236             IERC20 tokenFunctions = IERC20(tokenAddress);
237             tokenFunctions.transfer(msg.sender, amount);
238         }
239         emit AssetsCollected(tokenAddress, amount);
240     }
241 
242 }