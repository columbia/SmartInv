1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipRenounced(address indexed previousOwner);
62   event OwnershipTransferred(
63     address indexed previousOwner,
64     address indexed newOwner
65   );
66 
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   constructor() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to relinquish control of the contract.
86    */
87   function renounceOwnership() public onlyOwner {
88     emit OwnershipRenounced(owner);
89     owner = address(0);
90   }
91 
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address _newOwner) public onlyOwner {
97     _transferOwnership(_newOwner);
98   }
99 
100   /**
101    * @dev Transfers control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function _transferOwnership(address _newOwner) internal {
105     require(_newOwner != address(0));
106     emit OwnershipTransferred(owner, _newOwner);
107     owner = _newOwner;
108   }
109 }
110 
111 /**
112  * @title ERC20
113  * @dev ERC20 token interface
114  */
115  contract ERC20 {
116     string public name;
117     string public symbol;
118     uint8 public decimals;
119     function totalSupply() public constant returns (uint);
120     function balanceOf(address tokenOwner) public constant returns (uint balance);
121     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
122     function transfer(address to, uint tokens) public returns (bool success);
123     function approve(address spender, uint tokens) public returns (bool success);
124     function transferFrom(address from, address to, uint tokens) public returns (bool success);
125 
126     event Transfer(address indexed from, address indexed to, uint tokens);
127     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
128  }
129 
130 /**
131  * @title OptionsEscrow
132  * @dev Escrow that holds tokens for a beneficiary with various vesting schedules and strike prices
133  * The contract owner may grant options and reclaim tokens from expired options.
134  */
135 
136 contract OptionsEscrow is Ownable {
137     using SafeMath for uint;
138 
139     struct Option {
140         address beneficiary;
141         uint tokenAmount;
142         uint strikeMultiple;
143         uint128 vestUntil;
144         uint128 expiration;
145     }
146 
147     address public token;
148     uint public issuedTokens;
149     uint64 public optionsCount;
150     mapping (address => Option) public grantedOptions;
151 
152     event GrantOption(address indexed beneficiary, uint tokenAmount, uint strikeMultiple, uint128 vestUntil, uint128 expiration);
153     event ExerciseOption(address indexed beneficiary, uint exercisedAmount, uint strikeMultiple);
154     event ReclaimOption(address indexed beneficiary);
155 
156     /**
157      * @dev Constructor.
158      * @param _token The token for which options are being granted.
159      */
160     constructor(address _token) public {
161         /* require(token != address(0)); */
162 
163         token = _token;
164         issuedTokens = 0;
165         optionsCount = 0;
166     }
167 
168     /**
169      * @dev Issue an option for a beneficiary with a custom amount, strike price, and vesting schedule
170      *      NOTE: the use of a strike multiple means that the token-to-wei ration must always be positive
171      *            this can be worked around be also adding a strikeDenomination
172      * @param _beneficiary The recipient of the option,
173      * @param _tokenAmount The amount of tokens available to be claimed
174      * @param _strikeMultiple The amount of tokens for each wei provided
175      * @param _vestUntil The timestamp (epoch in seconds) that the option becomes exercisable
176      * @param _expiration The timestamp (epoch in seconds) that the option is no longer exercisable
177      */
178     function issueOption(address _beneficiary,
179                             uint _tokenAmount,
180                             uint _strikeMultiple,
181                          uint128 _vestUntil,
182                          uint128 _expiration) onlyOwner public {
183         uint _issuedTokens = issuedTokens.add(_tokenAmount);
184 
185         require(_tokenAmount > 0 &&
186                 _expiration > _vestUntil &&
187                 _vestUntil > block.timestamp &&
188                 ERC20(token).balanceOf(this) > _issuedTokens);
189 
190         Option memory option = Option(_beneficiary, _tokenAmount, _strikeMultiple, _vestUntil, _expiration);
191 
192         grantedOptions[_beneficiary] = option;
193         optionsCount++;
194         issuedTokens = _issuedTokens;
195 
196         emit GrantOption(_beneficiary, _tokenAmount, _strikeMultiple, _vestUntil, _expiration);
197     }
198 
199     /**
200      * @dev Allows the beneficiary to exercise a vested option.
201      *      The option can be partially exercised.
202      */
203     function () public payable {
204         Option storage option = grantedOptions[msg.sender];
205 
206         require(option.beneficiary == msg.sender &&
207                 option.vestUntil <= block.timestamp &&
208                 option.expiration > block.timestamp &&
209                 option.tokenAmount > 0);
210 
211         uint amountExercised = msg.value.mul(option.strikeMultiple);
212         if(amountExercised > option.tokenAmount) {
213             amountExercised = option.tokenAmount;
214         }
215 
216         option.tokenAmount = option.tokenAmount.sub(amountExercised);
217         issuedTokens = issuedTokens.sub(amountExercised);
218         require(ERC20(token).transfer(msg.sender, amountExercised));
219 
220         emit ExerciseOption(msg.sender, amountExercised, option.strikeMultiple);
221     }
222 
223     /**
224      * @dev Allows the owner to reclaim tokens from a list of options that have expired
225      * @param beneficiaries An array of beneficiary addresses
226      */
227     function reclaimExpiredOptionTokens(address[] beneficiaries) public onlyOwner returns (uint reclaimedTokenAmount) {
228         reclaimedTokenAmount = 0;
229         for (uint i=0; i<beneficiaries.length; i++) {
230             Option storage option = grantedOptions[beneficiaries[i]];
231             if (option.expiration <= block.timestamp) {
232                 reclaimedTokenAmount = reclaimedTokenAmount.add(option.tokenAmount);
233                 option.tokenAmount = 0;
234 
235                 emit ReclaimOption(beneficiaries[i]);
236             }
237         }
238         issuedTokens = issuedTokens.sub(reclaimedTokenAmount);
239         require(ERC20(token).transfer(owner, reclaimedTokenAmount));
240     }
241 
242     /**
243      * @dev Allows the owner to reclaim tokens that have not been issued
244      */
245     function reclaimUnissuedTokens() public onlyOwner returns (uint reclaimedTokenAmount) {
246         reclaimedTokenAmount = ERC20(token).balanceOf(this) - issuedTokens;
247         require(ERC20(token).transfer(owner, reclaimedTokenAmount));
248     }
249 
250     /**
251      * @dev Allows the owner to withdraw eth from exercised options
252      */
253     function withdrawEth() public onlyOwner {
254         owner.transfer(address(this).balance);
255     }
256 
257     /**
258      * @dev Constant getter to see details of an option
259      * @param _beneficiary The address of beneficiary
260      */
261     function getOption(address _beneficiary) public constant returns(address beneficiary,
262                                                           uint tokenAmount,
263                                                           uint strikeMultiple,
264                                                           uint128 vestUntil,
265                                                           uint128 expiration) {
266         Option memory option = grantedOptions[_beneficiary];
267         beneficiary = option.beneficiary;
268         tokenAmount = option.tokenAmount;
269         strikeMultiple = option.strikeMultiple;
270         vestUntil = option.vestUntil;
271         expiration = option.expiration;
272     }
273 }