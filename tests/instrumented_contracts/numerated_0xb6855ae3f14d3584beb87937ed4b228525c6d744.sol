1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Helps contracts guard against reentrancy attacks.
5  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
6  * @dev If you mark a function `nonReentrant`, you should also
7  * mark it `external`.
8  */
9 contract ReentrancyGuard {
10 
11   /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.
12   /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056
13   uint private constant REENTRANCY_GUARD_FREE = 1;
14 
15   /// @dev Constant for locked guard state
16   uint private constant REENTRANCY_GUARD_LOCKED = 2;
17 
18   /**
19    * @dev We use a single lock for the whole contract.
20    */
21   uint private reentrancyLock = REENTRANCY_GUARD_FREE;
22 
23   /**
24    * @dev Prevents a contract from calling itself, directly or indirectly.
25    * If you mark a function `nonReentrant`, you should also
26    * mark it `external`. Calling one `nonReentrant` function from
27    * another is not supported. Instead, you can implement a
28    * `private` function doing the actual work, and an `external`
29    * wrapper marked as `nonReentrant`.
30    */
31   modifier nonReentrant() {
32     require(reentrancyLock == REENTRANCY_GUARD_FREE);
33     reentrancyLock = REENTRANCY_GUARD_LOCKED;
34     _;
35     reentrancyLock = REENTRANCY_GUARD_FREE;
36   }
37 
38 }
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (_a == 0) {
54       return 0;
55     }
56 
57     c = _a * _b;
58     assert(c / _a == _b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     // assert(_b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = _a / _b;
68     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
69     return _a / _b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     assert(_b <= _a);
77     return _a - _b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
84     c = _a + _b;
85     assert(c >= _a);
86     return c;
87   }
88 }
89 
90 /**
91  * @title Ownable
92  * @dev The Ownable contract has an owner address, and provides basic authorization control
93  * functions, this simplifies the implementation of "user permissions".
94  */
95 contract Ownable {
96   address public owner;
97 
98   event OwnershipRenounced(address indexed previousOwner);
99   event OwnershipTransferred(
100     address indexed previousOwner,
101     address indexed newOwner
102   );
103 
104   /**
105    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
106    * account.
107    */
108   constructor() public {
109     owner = msg.sender;
110   }
111 
112   /**
113    * @dev Throws if called by any account other than the owner.
114    */
115   modifier onlyOwner() {
116     require(msg.sender == owner);
117     _;
118   }
119 
120   /**
121    * @dev Allows the current owner to relinquish control of the contract.
122    * @notice Renouncing to ownership will leave the contract without an owner.
123    * It will not be possible to call the functions with the `onlyOwner`
124    * modifier anymore.
125    */
126   function renounceOwnership() public onlyOwner {
127     emit OwnershipRenounced(owner);
128     owner = address(0);
129   }
130 
131   /**
132    * @dev Allows the current owner to transfer control of the contract to a newOwner.
133    * @param _newOwner The address to transfer ownership to.
134    */
135   function transferOwnership(address _newOwner) public onlyOwner {
136     _transferOwnership(_newOwner);
137   }
138 
139   /**
140    * @dev Transfers control of the contract to a newOwner.
141    * @param _newOwner The address to transfer ownership to.
142    */
143   function _transferOwnership(address _newOwner) internal {
144     require(_newOwner != address(0));
145     emit OwnershipTransferred(owner, _newOwner);
146     owner = _newOwner;
147   }
148 }
149 
150 interface ERC20 {
151     function totalSupply() external view returns (uint supply);
152     function balanceOf(address _owner) external view returns (uint balance);
153     function transfer(address _to, uint _value) external returns (bool success);
154     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
155     function approve(address _spender, uint _value) external returns (bool success);
156     function allowance(address _owner, address _spender) external view returns (uint remaining);
157     function decimals() external view returns(uint digits);
158     event Approval(address indexed _owner, address indexed _spender, uint _value);
159 }
160 
161 /*
162 * There are 4 entities in this contract - 
163 #1 `company` - This is the company which is going to place a bounty of tokens
164 #2 `referrer` - This is the referrer who refers a candidate that gets a job finally
165 #3 `candidate` - This is the candidate who gets a job finally
166 #4 `owner` - Indorse as a company will be the owner of this contract
167 *
168 */
169 
170 contract JobsBounty is Ownable, ReentrancyGuard {
171     using SafeMath for uint256;
172     string public companyName; //Name of the company who is putting the bounty
173     string public jobPost; //Link to the job post for this Smart Contract
174     uint public endDate; //Unix timestamp of the end date of this contract when the bounty can be released
175     
176     // On Rinkeby
177     // address public INDToken = 0x656c7da9501bB3e4A5a544546230D74c154A42eb;
178     // On Mainnet
179     // address public INDToken = 0xf8e386eda857484f5a12e4b5daa9984e06e73705;
180     
181     address public INDToken;
182     
183     constructor(string _companyName,
184                 string _jobPost,
185                 uint _endDate,
186                 address _INDToken
187                 ) public{
188         companyName = _companyName;
189         jobPost = _jobPost ;
190         endDate = _endDate;
191         INDToken = _INDToken;
192     }
193     
194     //Helper function, not really needed, but good to have for the sake of posterity
195     function ownBalance() public view returns(uint256) {
196         return SafeMath.div(ERC20(INDToken).balanceOf(this),1 ether);
197     }
198     
199     function payOutBounty(address _referrerAddress, address _candidateAddress) external onlyOwner nonReentrant returns(bool){
200         assert(block.timestamp >= endDate);
201         assert(_referrerAddress != address(0x0));
202         assert(_candidateAddress != address(0x0));
203         
204         uint256 individualAmounts = SafeMath.mul(SafeMath.div((ERC20(INDToken).balanceOf(this)),100),50);
205         
206         // Tranferring to the candidate first
207         assert(ERC20(INDToken).transfer(_candidateAddress, individualAmounts));
208         assert(ERC20(INDToken).transfer(_referrerAddress, individualAmounts));
209         return true;    
210     }
211     
212     //This function can be used in 2 instances - 
213     // 1st one if to withdraw tokens that are accidentally send to this Contract
214     // 2nd is to actually withdraw the tokens and return it to the company in case they don't find a candidate
215     function withdrawERC20Token(address anyToken) external onlyOwner nonReentrant returns(bool){
216         assert(block.timestamp >= endDate);
217         assert(ERC20(anyToken).transfer(owner, ERC20(anyToken).balanceOf(this)));        
218         return true;
219     }
220     
221     //ETH cannot get locked in this contract. If it does, this can be used to withdraw
222     //the locked ether.
223     function withdrawEther() external onlyOwner nonReentrant returns(bool){
224         if(address(this).balance > 0){
225             owner.transfer(address(this).balance);
226         }        
227         return true;
228     }
229 }