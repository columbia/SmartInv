1 pragma solidity ^0.4.24;
2 
3 
4 /// @title Role based access control mixin for MUST Platform
5 /// @author Aler Denisov <aler.zampillo@gmail.com>
6 /// @dev Ignore DRY approach to achieve readability
7 contract RBACMixin {
8   /// @notice Constant string message to throw on lack of access
9   string constant FORBIDDEN = "Haven't enough right to access";
10   /// @notice Public map of owners
11   mapping (address => bool) public owners;
12   /// @notice Public map of minters
13   mapping (address => bool) public minters;
14 
15   /// @notice The event indicates the addition of a new owner
16   /// @param who is address of added owner
17   event AddOwner(address indexed who);
18   /// @notice The event indicates the deletion of an owner
19   /// @param who is address of deleted owner
20   event DeleteOwner(address indexed who);
21 
22   /// @notice The event indicates the addition of a new minter
23   /// @param who is address of added minter
24   event AddMinter(address indexed who);
25   /// @notice The event indicates the deletion of a minter
26   /// @param who is address of deleted minter
27   event DeleteMinter(address indexed who);
28 
29   constructor () public {
30     _setOwner(msg.sender, true);
31   }
32 
33   /// @notice The functional modifier rejects the interaction of senders who are not owners
34   modifier onlyOwner() {
35     require(isOwner(msg.sender), FORBIDDEN);
36     _;
37   }
38 
39   /// @notice Functional modifier for rejecting the interaction of senders that are not minters
40   modifier onlyMinter() {
41     require(isMinter(msg.sender), FORBIDDEN);
42     _;
43   }
44 
45   /// @notice Look up for the owner role on providen address
46   /// @param _who is address to look up
47   /// @return A boolean of owner role
48   function isOwner(address _who) public view returns (bool) {
49     return owners[_who];
50   }
51 
52   /// @notice Look up for the minter role on providen address
53   /// @param _who is address to look up
54   /// @return A boolean of minter role
55   function isMinter(address _who) public view returns (bool) {
56     return minters[_who];
57   }
58 
59   /// @notice Adds the owner role to provided address
60   /// @dev Requires owner role to interact
61   /// @param _who is address to add role
62   /// @return A boolean that indicates if the operation was successful.
63   function addOwner(address _who) public onlyOwner returns (bool) {
64     _setOwner(_who, true);
65   }
66 
67   /// @notice Deletes the owner role to provided address
68   /// @dev Requires owner role to interact
69   /// @param _who is address to delete role
70   /// @return A boolean that indicates if the operation was successful.
71   function deleteOwner(address _who) public onlyOwner returns (bool) {
72     _setOwner(_who, false);
73   }
74 
75   /// @notice Adds the minter role to provided address
76   /// @dev Requires owner role to interact
77   /// @param _who is address to add role
78   /// @return A boolean that indicates if the operation was successful.
79   function addMinter(address _who) public onlyOwner returns (bool) {
80     _setMinter(_who, true);
81   }
82 
83   /// @notice Deletes the minter role to provided address
84   /// @dev Requires owner role to interact
85   /// @param _who is address to delete role
86   /// @return A boolean that indicates if the operation was successful.
87   function deleteMinter(address _who) public onlyOwner returns (bool) {
88     _setMinter(_who, false);
89   }
90 
91   /// @notice Changes the owner role to provided address
92   /// @param _who is address to change role
93   /// @param _flag is next role status after success
94   /// @return A boolean that indicates if the operation was successful.
95   function _setOwner(address _who, bool _flag) private returns (bool) {
96     require(owners[_who] != _flag);
97     owners[_who] = _flag;
98     if (_flag) {
99       emit AddOwner(_who);
100     } else {
101       emit DeleteOwner(_who);
102     }
103     return true;
104   }
105 
106   /// @notice Changes the minter role to provided address
107   /// @param _who is address to change role
108   /// @param _flag is next role status after success
109   /// @return A boolean that indicates if the operation was successful.
110   function _setMinter(address _who, bool _flag) private returns (bool) {
111     require(minters[_who] != _flag);
112     minters[_who] = _flag;
113     if (_flag) {
114       emit AddMinter(_who);
115     } else {
116       emit DeleteMinter(_who);
117     }
118     return true;
119   }
120 }
121 
122 
123 /**
124  * @title SafeMath
125  * @dev Math operations with safety checks that throw on error
126  */
127 library SafeMath {
128 
129   /**
130   * @dev Multiplies two numbers, throws on overflow.
131   */
132   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
133     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
134     // benefit is lost if 'b' is also tested.
135     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
136     if (a == 0) {
137       return 0;
138     }
139 
140     c = a * b;
141     assert(c / a == b);
142     return c;
143   }
144 
145   /**
146   * @dev Integer division of two numbers, truncating the quotient.
147   */
148   function div(uint256 a, uint256 b) internal pure returns (uint256) {
149     // assert(b > 0); // Solidity automatically throws when dividing by 0
150     // uint256 c = a / b;
151     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152     return a / b;
153   }
154 
155   /**
156   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
157   */
158   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159     assert(b <= a);
160     return a - b;
161   }
162 
163   /**
164   * @dev Adds two numbers, throws on overflow.
165   */
166   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
167     c = a + b;
168     assert(c >= a);
169     return c;
170   }
171 }
172 
173 
174 interface IMintableToken {
175   function mint(address _to, uint256 _amount) external returns (bool);
176 }
177 
178 
179 /// @title Very simplified implementation of Token Bucket Algorithm to secure token minting
180 /// @author Aler Denisov <aler.zampillo@gmail.com>
181 /// @notice Works with tokens implemented Mintable interface
182 /// @dev Transfer ownership/minting role to contract and execute mint over TokenBucket proxy to secure
183 contract TokenBucket is RBACMixin, IMintableToken {
184   using SafeMath for uint;
185   
186   /// @notice Limit maximum amount of available for minting tokens when bucket is full
187   /// @dev Should be enough to mint tokens with proper speed but less enough to prevent overminting in case of losing pkey
188   uint256 public size;
189   /// @notice Bucket refill rate
190   /// @dev Tokens per second (based on block.timestamp). Amount without decimals (in smallest part of token)
191   uint256 public rate;
192   /// @notice Stored time of latest minting
193   /// @dev Each successful call of minting function will update field with call timestamp
194   uint256 public lastMintTime;
195   /// @notice Left tokens in bucket on time of latest minting
196   uint256 public leftOnLastMint;
197 
198   /// @notice Reference of Mintable token
199   /// @dev Setup in contructor phase and never change in future
200   IMintableToken public token;
201 
202   /// @notice Token Bucket leak event fires on each minting
203   /// @param to is address of target tokens holder
204   /// @param left is amount of tokens available in bucket after leak
205   event Leak(address indexed to, uint256 left);
206 
207   /// @param _token is address of Mintable token
208   /// @param _size initial size of token bucket
209   /// @param _rate initial refill rate (tokens/sec)
210   constructor (address _token, uint256 _size, uint256 _rate) public {
211     token = IMintableToken(_token);
212     size = _size;
213     rate = _rate;
214     leftOnLastMint = _size;
215   }
216 
217   /// @notice Change size of bucket
218   /// @dev Require owner role to call
219   /// @param _size is new size of bucket
220   /// @return A boolean that indicates if the operation was successful.
221   function setSize(uint256 _size) public onlyOwner returns (bool) {
222     size = _size;
223     return true;
224   }
225 
226   /// @notice Change refill rate of bucket
227   /// @dev Require owner role to call
228   /// @param _rate is new refill rate of bucket
229   /// @return A boolean that indicates if the operation was successful.
230   function setRate(uint256 _rate) public onlyOwner returns (bool) {
231     rate = _rate;
232     return true;
233   }
234 
235   /// @notice Change size and refill rate of bucket
236   /// @dev Require owner role to call
237   /// @param _size is new size of bucket
238   /// @param _rate is new refill rate of bucket
239   /// @return A boolean that indicates if the operation was successful.
240   function setSizeAndRate(uint256 _size, uint256 _rate) public onlyOwner returns (bool) {
241     return setSize(_size) && setRate(_rate);
242   }
243 
244   /// @notice Function to mint tokens
245   /// @param _to The address that will receive the minted tokens.
246   /// @param _amount The amount of tokens to mint.
247   /// @return A boolean that indicates if the operation was successful.
248   function mint(address _to, uint256 _amount) public onlyMinter returns (bool) {
249     uint256 available = availableTokens();
250     require(_amount <= available);
251     leftOnLastMint = available.sub(_amount);
252     lastMintTime = now; // solium-disable-line security/no-block-members
253     require(token.mint(_to, _amount));
254     return true;
255   }
256 
257   /// @notice Function to calculate and get available in bucket tokens
258   /// @return An amount of available tokens in bucket
259   function availableTokens() public view returns (uint) {
260      // solium-disable-next-line security/no-block-members
261     uint256 timeAfterMint = now.sub(lastMintTime);
262     uint256 refillAmount = rate.mul(timeAfterMint).add(leftOnLastMint);
263     return size < refillAmount ? size : refillAmount;
264   }
265 }