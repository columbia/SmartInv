1 pragma solidity 0.4.24;
2 
3 // File: contracts/interfaces/EthPriceFeedI.sol
4 
5 interface EthPriceFeedI {
6     function getUnit() external view returns(string);
7     function getRate() external view returns(uint256);
8     function getLastTimeUpdated() external view returns(uint256); 
9 }
10 
11 // File: contracts/interfaces/ReadableI.sol
12 
13 // https://github.com/makerdao/feeds/blob/master/src/abi/readable.json
14 
15 pragma solidity 0.4.24;
16 
17 interface ReadableI {
18 
19     // We only care about these functions
20     function peek() external view returns(bytes32, bool);
21     function read() external view returns(bytes32);
22 
23     // function owner() external view returns(address);
24     // function zzz() external view returns(uint256);
25 }
26 
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, throws on overflow.
37   */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
40     // benefit is lost if 'b' is also tested.
41     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
42     if (a == 0) {
43       return 0;
44     }
45 
46     c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers, truncating the quotient.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     // uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return a / b;
59   }
60 
61   /**
62   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
63   */
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   /**
70   * @dev Adds two numbers, throws on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
73     c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
80 
81 /**
82  * @title Ownable
83  * @dev The Ownable contract has an owner address, and provides basic authorization control
84  * functions, this simplifies the implementation of "user permissions".
85  */
86 contract Ownable {
87   address public owner;
88 
89 
90   event OwnershipRenounced(address indexed previousOwner);
91   event OwnershipTransferred(
92     address indexed previousOwner,
93     address indexed newOwner
94   );
95 
96 
97   /**
98    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99    * account.
100    */
101   constructor() public {
102     owner = msg.sender;
103   }
104 
105   /**
106    * @dev Throws if called by any account other than the owner.
107    */
108   modifier onlyOwner() {
109     require(msg.sender == owner);
110     _;
111   }
112 
113   /**
114    * @dev Allows the current owner to relinquish control of the contract.
115    */
116   function renounceOwnership() public onlyOwner {
117     emit OwnershipRenounced(owner);
118     owner = address(0);
119   }
120 
121   /**
122    * @dev Allows the current owner to transfer control of the contract to a newOwner.
123    * @param _newOwner The address to transfer ownership to.
124    */
125   function transferOwnership(address _newOwner) public onlyOwner {
126     _transferOwnership(_newOwner);
127   }
128 
129   /**
130    * @dev Transfers control of the contract to a newOwner.
131    * @param _newOwner The address to transfer ownership to.
132    */
133   function _transferOwnership(address _newOwner) internal {
134     require(_newOwner != address(0));
135     emit OwnershipTransferred(owner, _newOwner);
136     owner = _newOwner;
137   }
138 }
139 
140 // File: contracts/MakerDAOPriceFeed.sol
141 
142 contract MakerDAOPriceFeed is Ownable, EthPriceFeedI {
143     using SafeMath for uint256;
144     
145     uint256 public constant RATE_THRESHOLD_PERCENTAGE = 10;
146     uint256 public constant MAKERDAO_FEED_MULTIPLIER = 10**36;
147 
148     ReadableI public makerDAOMedianizer;
149 
150     uint256 private weiPerUnitRate;
151 
152     uint256 private lastTimeUpdated; 
153     
154     event RateUpdated(uint256 _newRate, uint256 _timeUpdated);
155 
156     modifier isValidRate(uint256 _weiPerUnitRate) {
157         require(validRate(_weiPerUnitRate));
158         _;
159     }
160 
161     constructor(ReadableI _makerDAOMedianizer) public {
162         require(_makerDAOMedianizer != address(0));
163         makerDAOMedianizer = _makerDAOMedianizer;
164 
165         weiPerUnitRate = convertToRate(_makerDAOMedianizer.read());
166         lastTimeUpdated = now;
167     }
168     
169     /// @dev Receives rate from outside oracle
170     /// @param _weiPerUnitRate calculated off chain and received in the contract
171     function updateRate(uint256 _weiPerUnitRate) 
172         external 
173         onlyOwner
174         isValidRate(_weiPerUnitRate)
175     {
176         weiPerUnitRate = _weiPerUnitRate;
177 
178         lastTimeUpdated = now; 
179 
180         emit RateUpdated(_weiPerUnitRate, now);
181     }
182 
183     function getUnit()
184         external
185         view 
186         returns(string)
187     {
188         return "USD";
189     }
190 
191     /// @dev View function to see the rate stored in the contract.
192     function getRate() 
193         public 
194         view 
195         returns(uint256)
196     {
197         return weiPerUnitRate; 
198     }
199 
200     /// @dev View function to see that last time that the rate was updated. 
201     function getLastTimeUpdated()
202         public
203         view
204         returns(uint256)
205     {
206         return lastTimeUpdated;
207     }
208 
209     /// @dev Checks that a rate is valid.
210     /// @param _weiPerUnitRate The rate to check
211     /// @return True iff the rate is valid
212     function validRate(uint256 _weiPerUnitRate) public view returns(bool) {
213         if (_weiPerUnitRate == 0) return false;
214 
215         (bytes32 value, bool valid) = makerDAOMedianizer.peek();
216 
217         // If the value from the medianizer is not valid, use the current rate as reference
218         uint256 currentRate = valid ? convertToRate(value) : weiPerUnitRate;
219 
220         // Get the difference
221         uint256 diff = _weiPerUnitRate < currentRate ?  currentRate.sub(_weiPerUnitRate) : _weiPerUnitRate.sub(currentRate);
222 
223         return diff <= currentRate.mul(RATE_THRESHOLD_PERCENTAGE).div(100);
224     }
225 
226     /// @dev Transforms a bytes32 value taken from MakerDAO's Medianizer contract into wei per usd rate
227     /// @param _fromMedianizer Value taken from MakerDAO's Medianizer contract
228     /// @return The wei per usd rate
229     function convertToRate(bytes32 _fromMedianizer) internal pure returns(uint256) {
230         uint256 value = uint256(_fromMedianizer);
231         return MAKERDAO_FEED_MULTIPLIER.div(value);
232     }
233 }