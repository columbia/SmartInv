1 pragma solidity 0.4.23;
2 
3 // File: contracts/interfaces/EthPriceFeedI.sol
4 
5 interface EthPriceFeedI {
6     function updateRate(uint256 _weiPerUnitRate) external;
7     function getRate() external view returns(uint256);
8     function getLastTimeUpdated() external view returns(uint256); 
9 }
10 
11 // File: contracts/interfaces/ReadableI.sol
12 
13 // https://github.com/makerdao/feeds/blob/master/src/abi/readable.json
14 
15 pragma solidity 0.4.23;
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
39     if (a == 0) {
40       return 0;
41     }
42     c = a * b;
43     assert(c / a == b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     // uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return a / b;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
69     c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
76 
77 /**
78  * @title Ownable
79  * @dev The Ownable contract has an owner address, and provides basic authorization control
80  * functions, this simplifies the implementation of "user permissions".
81  */
82 contract Ownable {
83   address public owner;
84 
85 
86   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88 
89   /**
90    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
91    * account.
92    */
93   function Ownable() public {
94     owner = msg.sender;
95   }
96 
97   /**
98    * @dev Throws if called by any account other than the owner.
99    */
100   modifier onlyOwner() {
101     require(msg.sender == owner);
102     _;
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * @param newOwner The address to transfer ownership to.
108    */
109   function transferOwnership(address newOwner) public onlyOwner {
110     require(newOwner != address(0));
111     emit OwnershipTransferred(owner, newOwner);
112     owner = newOwner;
113   }
114 
115 }
116 
117 // File: contracts/MakerDAOPriceFeed.sol
118 
119 contract MakerDAOPriceFeed is Ownable, EthPriceFeedI {
120     using SafeMath for uint256;
121     
122     uint256 public constant RATE_THRESHOLD_PERCENTAGE = 10;
123     uint256 public constant MAKERDAO_FEED_MULTIPLIER = 10**36;
124 
125     ReadableI public makerDAOMedianizer;
126 
127     uint256 private weiPerUnitRate;
128 
129     uint256 private lastTimeUpdated; 
130     
131     event RateUpdated(uint256 _newRate, uint256 _timeUpdated);
132 
133     modifier isValidRate(uint256 _weiPerUnitRate) {
134         require(validRate(_weiPerUnitRate));
135         _;
136     }
137 
138     constructor(ReadableI _makerDAOMedianizer) {
139         require(_makerDAOMedianizer != address(0));
140         makerDAOMedianizer = _makerDAOMedianizer;
141 
142         weiPerUnitRate = convertToRate(_makerDAOMedianizer.read());
143         lastTimeUpdated = now;
144     }
145     
146     /// @dev Receives rate from outside oracle
147     /// @param _weiPerUnitRate calculated off chain and received to the contract
148     function updateRate(uint256 _weiPerUnitRate) 
149         external 
150         onlyOwner
151         isValidRate(_weiPerUnitRate)
152     {
153         weiPerUnitRate = _weiPerUnitRate;
154 
155         lastTimeUpdated = now; 
156 
157         emit RateUpdated(_weiPerUnitRate, now);
158     }
159 
160     /// @dev View function to see the rate stored in the contract.
161     function getRate() 
162         public 
163         view 
164         returns(uint256)
165     {
166         return weiPerUnitRate; 
167     }
168 
169     /// @dev View function to see that last time that the rate was updated. 
170     function getLastTimeUpdated()
171         public
172         view
173         returns(uint256)
174     {
175         return lastTimeUpdated;
176     }
177 
178     function validRate(uint256 _weiPerUnitRate) public view returns(bool) {
179         if (_weiPerUnitRate == 0) return false;
180         bytes32 value;
181         bool valid;
182         (value, valid) = makerDAOMedianizer.peek();
183 
184         // If the value from the medianizer is not valid, use the current rate as reference
185         uint256 currentRate = valid ? convertToRate(value) : weiPerUnitRate;
186 
187         // Get the difference
188         uint256 diff = _weiPerUnitRate < currentRate ?  currentRate.sub(_weiPerUnitRate) : _weiPerUnitRate.sub(currentRate);
189 
190         return diff <= currentRate.mul(RATE_THRESHOLD_PERCENTAGE).div(100);
191     }
192 
193     function convertToRate(bytes32 _fromMedianizer) internal pure returns(uint256) {
194         uint256 value = uint256(_fromMedianizer);
195         return MAKERDAO_FEED_MULTIPLIER.div(value);
196     }
197 }