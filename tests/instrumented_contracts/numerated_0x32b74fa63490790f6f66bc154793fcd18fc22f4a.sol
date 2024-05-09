1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, reverts on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
8     // benefit is lost if 'b' is also tested.
9     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
10     if (a == 0) {
11       return 0;
12     }
13 
14     uint256 c = a * b;
15     require(c / a == b);
16 
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     require(b > 0); // Solidity only automatically asserts when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27 
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     require(b <= a);
36     uint256 c = a - b;
37 
38     return c;
39   }
40 
41   /**
42   * @dev Adds two numbers, reverts on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     require(c >= a);
47 
48     return c;
49   }
50 
51   /**
52   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
53   * reverts when dividing by zero.
54   */
55   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
56     require(b != 0);
57     return a % b;
58   }
59 }
60 contract Ownable {
61   address private _owner;
62 
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   constructor() internal {
73     _owner = msg.sender;
74     emit OwnershipTransferred(address(0), _owner);
75   }
76 
77   /**
78    * @return the address of the owner.
79    */
80   function owner() public view returns(address) {
81     return _owner;
82   }
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(isOwner());
89     _;
90   }
91 
92   /**
93    * @return true if `msg.sender` is the owner of the contract.
94    */
95   function isOwner() public view returns(bool) {
96     return msg.sender == _owner;
97   }
98 
99   /**
100    * @dev Allows the current owner to relinquish control of the contract.
101    * @notice Renouncing to ownership will leave the contract without an owner.
102    * It will not be possible to call the functions with the `onlyOwner`
103    * modifier anymore.
104    */
105   function renounceOwnership() public onlyOwner {
106     emit OwnershipTransferred(_owner, address(0));
107     _owner = address(0);
108   }
109 
110   /**
111    * @dev Allows the current owner to transfer control of the contract to a newOwner.
112    * @param newOwner The address to transfer ownership to.
113    */
114   function transferOwnership(address newOwner) public onlyOwner {
115     _transferOwnership(newOwner);
116   }
117 
118   /**
119    * @dev Transfers control of the contract to a newOwner.
120    * @param newOwner The address to transfer ownership to.
121    */
122   function _transferOwnership(address newOwner) internal {
123     require(newOwner != address(0));
124     emit OwnershipTransferred(_owner, newOwner);
125     _owner = newOwner;
126   }
127 }
128 contract GTXRecord is Ownable {
129     using SafeMath for uint256;
130 
131     // conversionRate is the multiplier to calculate the number of GTX claimable per FIN Point converted
132     // e.g., 100 = 1:1 conversion ratio
133     uint256 public conversionRate;
134 
135     // a flag for locking record changes, lockRecords is only settable by the owner
136     bool public lockRecords;
137 
138     // Maximum amount of recorded GTX able to be stored on this contract
139     uint256 public maxRecords;
140 
141     // Total number of claimable GTX converted from FIN Points
142     uint256 public totalClaimableGTX;
143 
144     // an address map used to store the per account claimable GTX
145     // as a result of converted FIN Points
146     mapping (address => uint256) public claimableGTX;
147 
148     event GTXRecordCreate(
149         address indexed _recordAddress,
150         uint256 _finPointAmount,
151         uint256 _gtxAmount
152     );
153 
154     event GTXRecordUpdate(
155         address indexed _recordAddress,
156         uint256 _finPointAmount,
157         uint256 _gtxAmount
158     );
159 
160     event GTXRecordMove(
161         address indexed _oldAddress,
162         address indexed _newAddress,
163         uint256 _gtxAmount
164     );
165 
166     event LockRecords();
167 
168     /**
169      * Throws if conversionRate is not set or if the lockRecords flag has been set to true
170     */
171     modifier canRecord() {
172         require(conversionRate > 0);
173         require(!lockRecords);
174         _;
175     }
176 
177     /**
178      * @dev GTXRecord constructor
179      * @param _maxRecords is the maximum numer of GTX records this contract can store (used for sanity checks on GTX ERC20 totalsupply)
180     */
181     constructor (uint256 _maxRecords) public {
182         maxRecords = _maxRecords;
183     }
184 
185     /**
186      * @dev sets the GTX Conversion rate
187      * @param _conversionRate is the rate applied during FIN Point to GTX conversion
188     */
189     function setConversionRate(uint256 _conversionRate) external onlyOwner{
190         require(_conversionRate <= 1000); // maximum 10x conversion rate
191         require(_conversionRate > 0); // minimum .01x conversion rate
192         conversionRate = _conversionRate;
193     }
194 
195    /**
196     * @dev Function to lock record changes on this contracts
197     * @return True if the operation was successful.
198     */
199     function lock() public onlyOwner returns (bool) {
200         lockRecords = true;
201         emit LockRecords();
202         return true;
203     }
204 
205     /**
206     * @dev Used to calculate and store the amount of claimable GTX for those exsisting FIN point holders
207     * who opt to convert FIN points for GTX
208     * @param _recordAddress - the registered address where GTX can be claimed from
209     * @param _finPointAmount - the amount of FINs to be converted for GTX, this param should always be entered as base units
210     * i.e., 1 FIN = 10**18 base units
211     * @param _applyConversionRate - flag to apply conversion rate or not, any Finterra Technologies company GTX conversion allocations
212     * are strictly covnerted at one to one and do not recive the conversion bonus applied to FIN point user balances
213     */
214     function recordCreate(address _recordAddress, uint256 _finPointAmount, bool _applyConversionRate) public onlyOwner canRecord {
215         require(_finPointAmount >= 100000, "cannot be less than 100000 FIN (in WEI)"); // minimum allowed FIN 0.000000000001 (in base units) to avoid large rounding errors
216         uint256 afterConversionGTX;
217         if(_applyConversionRate == true) {
218             afterConversionGTX = _finPointAmount.mul(conversionRate).div(100);
219         } else {
220             afterConversionGTX = _finPointAmount;
221         }
222         claimableGTX[_recordAddress] = claimableGTX[_recordAddress].add(afterConversionGTX);
223         totalClaimableGTX = totalClaimableGTX.add(afterConversionGTX);
224         require(totalClaimableGTX <= maxRecords, "total token record (contverted GTX) cannot exceed GTXRecord token limit");
225         emit GTXRecordCreate(_recordAddress, _finPointAmount, claimableGTX[_recordAddress]);
226     }
227 
228     /**
229     * @dev Used to calculate and update the amount of claimable GTX for those exsisting FIN point holders
230     * who opt to convert FIN points for GTX
231     * @param _recordAddress - the registered address where GTX can be claimed from
232     * @param _finPointAmount - the amount of FINs to be converted for GTX, this param should always be entered as base units
233     * i.e., 1 FIN = 10**18 base units
234     * @param _applyConversionRate - flag to apply conversion rate or do one for one conversion, any Finterra Technologies company FIN point allocations
235     * are strictly converted at one to one and do not recive the cnversion bonus applied to FIN point user balances
236     */
237     function recordUpdate(address _recordAddress, uint256 _finPointAmount, bool _applyConversionRate) public onlyOwner canRecord {
238         require(_finPointAmount >= 100000, "cannot be less than 100000 FIN (in WEI)"); // minimum allowed FIN 0.000000000001 (in base units) to avoid large rounding errors
239         uint256 afterConversionGTX;
240         totalClaimableGTX = totalClaimableGTX.sub(claimableGTX[_recordAddress]);
241         if(_applyConversionRate == true) {
242             afterConversionGTX  = _finPointAmount.mul(conversionRate).div(100);
243         } else {
244             afterConversionGTX  = _finPointAmount;
245         }
246         claimableGTX[_recordAddress] = afterConversionGTX;
247         totalClaimableGTX = totalClaimableGTX.add(claimableGTX[_recordAddress]);
248         require(totalClaimableGTX <= maxRecords, "total token record (contverted GTX) cannot exceed GTXRecord token limit");
249         emit GTXRecordUpdate(_recordAddress, _finPointAmount, claimableGTX[_recordAddress]);
250     }
251 
252     /**
253     * @dev Used to move GTX records from one address to another, primarily in case a user has lost access to their originally registered account
254     * @param _oldAddress - the original registered address
255     * @param _newAddress - the new registerd address
256     */
257     function recordMove(address _oldAddress, address _newAddress) public onlyOwner canRecord {
258         require(claimableGTX[_oldAddress] != 0, "cannot move a zero record");
259         require(claimableGTX[_newAddress] == 0, "destination must not already have a claimable record");
260 
261         claimableGTX[_newAddress] = claimableGTX[_oldAddress];
262         claimableGTX[_oldAddress] = 0;
263 
264         emit GTXRecordMove(_oldAddress, _newAddress, claimableGTX[_newAddress]);
265     }
266 
267 }