1 // File: contracts/PriceOracle.sol
2 
3 pragma solidity >=0.4.24;
4 
5 interface PriceOracle {
6     /**
7      * @dev Returns the price to register or renew a name.
8      * @param name The name being registered or renewed.
9      * @param expires When the name presently expires (0 if this is a new registration).
10      * @param duration How long the name is being registered or extended for, in seconds.
11      * @return The price of this renewal or registration, in wei.
12      */
13     function price(string calldata name, uint expires, uint duration) external view returns(uint);
14 }
15 
16 // File: contracts/SafeMath.sol
17 
18 pragma solidity >=0.4.24;
19 
20 /**
21  * @title SafeMath
22  * @dev Unsigned math operations with safety checks that revert on error
23  */
24 library SafeMath {
25     /**
26     * @dev Multiplies two unsigned integers, reverts on overflow.
27     */
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
30         // benefit is lost if 'b' is also tested.
31         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32         if (a == 0) {
33             return 0;
34         }
35 
36         uint256 c = a * b;
37         require(c / a == b);
38 
39         return c;
40     }
41 
42     /**
43     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
44     */
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Solidity only automatically asserts when dividing by 0
47         require(b > 0);
48         uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50 
51         return c;
52     }
53 
54     /**
55     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
56     */
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b <= a);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65     * @dev Adds two unsigned integers, reverts on overflow.
66     */
67     function add(uint256 a, uint256 b) internal pure returns (uint256) {
68         uint256 c = a + b;
69         require(c >= a);
70 
71         return c;
72     }
73 
74     /**
75     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
76     * reverts when dividing by zero.
77     */
78     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79         require(b != 0);
80         return a % b;
81     }
82 }
83 
84 // File: contracts/StringUtils.sol
85 
86 pragma solidity >=0.4.24;
87 
88 library StringUtils {
89     /**
90      * @dev Returns the length of a given string
91      *
92      * @param s The string to measure the length of
93      * @return The length of the input string
94      */
95     function strlen(string memory s) internal pure returns (uint) {
96         uint len;
97         uint i = 0;
98         uint bytelength = bytes(s).length;
99         for(len = 0; i < bytelength; len++) {
100             byte b = bytes(s)[i];
101             if(b < 0x80) {
102                 i += 1;
103             } else if (b < 0xE0) {
104                 i += 2;
105             } else if (b < 0xF0) {
106                 i += 3;
107             } else if (b < 0xF8) {
108                 i += 4;
109             } else if (b < 0xFC) {
110                 i += 5;
111             } else {
112                 i += 6;
113             }
114         }
115         return len;
116     }
117 }
118 
119 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
120 
121 pragma solidity ^0.5.0;
122 
123 /**
124  * @title Ownable
125  * @dev The Ownable contract has an owner address, and provides basic authorization control
126  * functions, this simplifies the implementation of "user permissions".
127  */
128 contract Ownable {
129     address private _owner;
130 
131     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
132 
133     /**
134      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
135      * account.
136      */
137     constructor () internal {
138         _owner = msg.sender;
139         emit OwnershipTransferred(address(0), _owner);
140     }
141 
142     /**
143      * @return the address of the owner.
144      */
145     function owner() public view returns (address) {
146         return _owner;
147     }
148 
149     /**
150      * @dev Throws if called by any account other than the owner.
151      */
152     modifier onlyOwner() {
153         require(isOwner());
154         _;
155     }
156 
157     /**
158      * @return true if `msg.sender` is the owner of the contract.
159      */
160     function isOwner() public view returns (bool) {
161         return msg.sender == _owner;
162     }
163 
164     /**
165      * @dev Allows the current owner to relinquish control of the contract.
166      * @notice Renouncing to ownership will leave the contract without an owner.
167      * It will not be possible to call the functions with the `onlyOwner`
168      * modifier anymore.
169      */
170     function renounceOwnership() public onlyOwner {
171         emit OwnershipTransferred(_owner, address(0));
172         _owner = address(0);
173     }
174 
175     /**
176      * @dev Allows the current owner to transfer control of the contract to a newOwner.
177      * @param newOwner The address to transfer ownership to.
178      */
179     function transferOwnership(address newOwner) public onlyOwner {
180         _transferOwnership(newOwner);
181     }
182 
183     /**
184      * @dev Transfers control of the contract to a newOwner.
185      * @param newOwner The address to transfer ownership to.
186      */
187     function _transferOwnership(address newOwner) internal {
188         require(newOwner != address(0));
189         emit OwnershipTransferred(_owner, newOwner);
190         _owner = newOwner;
191     }
192 }
193 
194 // File: contracts/StablePriceOracle.sol
195 
196 pragma solidity ^0.5.0;
197 
198 
199 
200 
201 
202 interface DSValue {
203     function read() external view returns (bytes32);
204 }
205 
206 // StablePriceOracle sets a price in USD, based on an oracle.
207 contract StablePriceOracle is Ownable, PriceOracle {
208     using SafeMath for *;
209     using StringUtils for *;
210 
211     // Oracle address
212     DSValue usdOracle;
213 
214     // Rent in attodollars (1e-18) per second
215     uint[] public rentPrices;
216 
217     event OracleChanged(address oracle);
218     event RentPriceChanged(uint[] prices);
219 
220     constructor(DSValue _usdOracle, uint[] memory _rentPrices) public {
221         setOracle(_usdOracle);
222         setPrices(_rentPrices);
223     }
224 
225     /**
226      * @dev Sets the price oracle address
227      * @param _usdOracle The address of the price oracle to use.
228      */
229     function setOracle(DSValue _usdOracle) public onlyOwner {
230         usdOracle = _usdOracle;
231         emit OracleChanged(address(_usdOracle));
232     }
233 
234     /**
235      * @dev Sets rent prices.
236      * @param _rentPrices The price array. Each element corresponds to a specific
237      *                    name length; names longer than the length of the array
238      *                    default to the price of the last element.
239      */
240     function setPrices(uint[] memory _rentPrices) public onlyOwner {
241         rentPrices = _rentPrices;
242         emit RentPriceChanged(_rentPrices);
243     }
244 
245     /**
246      * @dev Returns the price to register or renew a name.
247      * @param name The name being registered or renewed.
248      * @param duration How long the name is being registered or extended for, in seconds.
249      * @return The price of this renewal or registration, in wei.
250      */
251     function price(string calldata name, uint /*expires*/, uint duration) view external returns(uint) {
252         uint len = name.strlen();
253         if(len > rentPrices.length) {
254             len = rentPrices.length;
255         }
256         require(len > 0);
257         uint priceUSD = rentPrices[len - 1].mul(duration);
258 
259         // Price of one ether in attodollars
260         uint ethPrice = uint(usdOracle.read());
261 
262         // priceUSD and ethPrice are both fixed-point values with 18dp, so we
263         // multiply the numerator by 1e18 before dividing.
264         return priceUSD.mul(1e18).div(ethPrice);
265     }
266 }