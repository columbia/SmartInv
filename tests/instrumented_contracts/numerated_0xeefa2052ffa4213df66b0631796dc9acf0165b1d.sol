1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title Ownable
27  * @dev The Ownable contract has an owner address, and provides basic authorization control
28  * functions, this simplifies the implementation of "user permissions".
29  */
30 contract Ownable {
31     address private _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     /**
36      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37      * account.
38      */
39     constructor () internal {
40         _owner = msg.sender;
41         emit OwnershipTransferred(address(0), _owner);
42     }
43 
44     /**
45      * @return the address of the owner.
46      */
47     function owner() public view returns (address) {
48         return _owner;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(isOwner());
56         _;
57     }
58 
59     /**
60      * @return true if `msg.sender` is the owner of the contract.
61      */
62     function isOwner() public view returns (bool) {
63         return msg.sender == _owner;
64     }
65 
66     /**
67      * @dev Allows the current owner to relinquish control of the contract.
68      * @notice Renouncing to ownership will leave the contract without an owner.
69      * It will not be possible to call the functions with the `onlyOwner`
70      * modifier anymore.
71      */
72     function renounceOwnership() public onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76 
77     /**
78      * @dev Allows the current owner to transfer control of the contract to a newOwner.
79      * @param newOwner The address to transfer ownership to.
80      */
81     function transferOwnership(address newOwner) public onlyOwner {
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers control of the contract to a newOwner.
87      * @param newOwner The address to transfer ownership to.
88      */
89     function _transferOwnership(address newOwner) internal {
90         require(newOwner != address(0));
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 /**
97  * @title SafeMath
98  * @dev Unsigned math operations with safety checks that revert on error
99  */
100 library SafeMath {
101     /**
102     * @dev Multiplies two unsigned integers, reverts on overflow.
103     */
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
106         // benefit is lost if 'b' is also tested.
107         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
108         if (a == 0) {
109             return 0;
110         }
111 
112         uint256 c = a * b;
113         require(c / a == b);
114 
115         return c;
116     }
117 
118     /**
119     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
120     */
121     function div(uint256 a, uint256 b) internal pure returns (uint256) {
122         // Solidity only automatically asserts when dividing by 0
123         require(b > 0);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
132     */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b <= a);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141     * @dev Adds two unsigned integers, reverts on overflow.
142     */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a);
146 
147         return c;
148     }
149 
150     /**
151     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
152     * reverts when dividing by zero.
153     */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b != 0);
156         return a % b;
157     }
158 }
159 
160 // This interface allows contracts to query unverified prices.
161 interface PriceFeedInterface {
162     // Whether this PriceFeeds provides prices for the given identifier.
163     function isIdentifierSupported(bytes32 identifier) external view returns (bool isSupported);
164 
165     // Gets the latest time-price pair at which a price was published. The transaction will revert if no prices have
166     // been published for this identifier.
167     function latestPrice(bytes32 identifier) external view returns (uint publishTime, int price);
168 
169     // An event fired when a price is published.
170     event PriceUpdated(bytes32 indexed identifier, uint indexed time, int price);
171 }
172 
173 contract Withdrawable is Ownable {
174     // Withdraws ETH from the contract.
175     function withdraw(uint amount) external onlyOwner {
176         msg.sender.transfer(amount);
177     }
178 
179     // Withdraws ERC20 tokens from the contract.
180     function withdrawErc20(address erc20Address, uint amount) external onlyOwner {
181         IERC20 erc20 = IERC20(erc20Address);
182         require(erc20.transfer(msg.sender, amount));
183     }
184 }
185 
186 contract Testable is Ownable {
187 
188     // Is the contract being run on the test network. Note: this variable should be set on construction and never
189     // modified.
190     bool public isTest;
191 
192     uint private currentTime;
193 
194     constructor(bool _isTest) internal {
195         isTest = _isTest;
196         if (_isTest) {
197             currentTime = now; // solhint-disable-line not-rely-on-time
198         }
199     }
200 
201     modifier onlyIfTest {
202         require(isTest);
203         _;
204     }
205 
206     function setCurrentTime(uint _time) external onlyOwner onlyIfTest {
207         currentTime = _time;
208     }
209 
210     function getCurrentTime() public view returns (uint) {
211         if (isTest) {
212             return currentTime;
213         } else {
214             return now; // solhint-disable-line not-rely-on-time
215         }
216     }
217 }
218 
219 // Implementation of PriceFeedInterface with the ability to push prices.
220 contract ManualPriceFeed is PriceFeedInterface, Withdrawable, Testable {
221 
222     using SafeMath for uint;
223 
224     // A single price update.
225     struct PriceTick {
226         uint timestamp;
227         int price;
228     }
229 
230     // Mapping from identifier to the latest price for that identifier.
231     mapping(bytes32 => PriceTick) private prices;
232 
233     // Ethereum timestamp tolerance.
234     // Note: this is technically the amount of time that a block timestamp can be *ahead* of the current time. However,
235     // we are assuming that blocks will never get more than this amount *behind* the current time. The only requirement
236     // limiting how early the timestamp can be is that it must have a later timestamp than its parent. However,
237     // this bound will probably work reasonably well in both directions.
238     uint constant private BLOCK_TIMESTAMP_TOLERANCE = 900;
239 
240     constructor(bool _isTest) public Testable(_isTest) {} // solhint-disable-line no-empty-blocks
241 
242     // Adds a new price to the series for a given identifier. The pushed publishTime must be later than the last time
243     // pushed so far.
244     function pushLatestPrice(bytes32 identifier, uint publishTime, int newPrice) external onlyOwner {
245         require(publishTime <= getCurrentTime().add(BLOCK_TIMESTAMP_TOLERANCE));
246         require(publishTime > prices[identifier].timestamp);
247         prices[identifier] = PriceTick(publishTime, newPrice);
248         emit PriceUpdated(identifier, publishTime, newPrice);
249     }
250 
251     // Whether this feed has ever published any prices for this identifier.
252     function isIdentifierSupported(bytes32 identifier) external view returns (bool isSupported) {
253         isSupported = _isIdentifierSupported(identifier);
254     }
255 
256     function latestPrice(bytes32 identifier) external view returns (uint publishTime, int price) {
257         require(_isIdentifierSupported(identifier));
258         publishTime = prices[identifier].timestamp;
259         price = prices[identifier].price;
260     }
261 
262     function _isIdentifierSupported(bytes32 identifier) private view returns (bool isSupported) {
263         isSupported = prices[identifier].timestamp > 0;
264     }
265 }