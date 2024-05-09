1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /// @title Role based access control mixin for Rasmart Platform
54 /// @author Mai Abha <maiabha82@gmail.com>
55 /// @dev Ignore DRY approach to achieve readability
56 contract RBACMixin {
57   /// @notice Constant string message to throw on lack of access
58   string constant FORBIDDEN = "Haven't enough right to access";
59   /// @notice Public map of owners
60   mapping (address => bool) public owners;
61   /// @notice Public map of minters
62   mapping (address => bool) public minters;
63 
64   /// @notice The event indicates the addition of a new owner
65   /// @param who is address of added owner
66   event AddOwner(address indexed who);
67   /// @notice The event indicates the deletion of an owner
68   /// @param who is address of deleted owner
69   event DeleteOwner(address indexed who);
70 
71   /// @notice The event indicates the addition of a new minter
72   /// @param who is address of added minter
73   event AddMinter(address indexed who);
74   /// @notice The event indicates the deletion of a minter
75   /// @param who is address of deleted minter
76   event DeleteMinter(address indexed who);
77 
78   constructor () public {
79     _setOwner(msg.sender, true);
80   }
81 
82   /// @notice The functional modifier rejects the interaction of senders who are not owners
83   modifier onlyOwner() {
84     require(isOwner(msg.sender), FORBIDDEN);
85     _;
86   }
87 
88   /// @notice Functional modifier for rejecting the interaction of senders that are not minters
89   modifier onlyMinter() {
90     require(isMinter(msg.sender), FORBIDDEN);
91     _;
92   }
93 
94   /// @notice Look up for the owner role on providen address
95   /// @param _who is address to look up
96   /// @return A boolean of owner role
97   function isOwner(address _who) public view returns (bool) {
98     return owners[_who];
99   }
100 
101   /// @notice Look up for the minter role on providen address
102   /// @param _who is address to look up
103   /// @return A boolean of minter role
104   function isMinter(address _who) public view returns (bool) {
105     return minters[_who];
106   }
107 
108   /// @notice Adds the owner role to provided address
109   /// @dev Requires owner role to interact
110   /// @param _who is address to add role
111   /// @return A boolean that indicates if the operation was successful.
112   function addOwner(address _who) public onlyOwner returns (bool) {
113     _setOwner(_who, true);
114   }
115 
116   /// @notice Deletes the owner role to provided address
117   /// @dev Requires owner role to interact
118   /// @param _who is address to delete role
119   /// @return A boolean that indicates if the operation was successful.
120   function deleteOwner(address _who) public onlyOwner returns (bool) {
121     _setOwner(_who, false);
122   }
123 
124   /// @notice Adds the minter role to provided address
125   /// @dev Requires owner role to interact
126   /// @param _who is address to add role
127   /// @return A boolean that indicates if the operation was successful.
128   function addMinter(address _who) public onlyOwner returns (bool) {
129     _setMinter(_who, true);
130   }
131 
132   /// @notice Deletes the minter role to provided address
133   /// @dev Requires owner role to interact
134   /// @param _who is address to delete role
135   /// @return A boolean that indicates if the operation was successful.
136   function deleteMinter(address _who) public onlyOwner returns (bool) {
137     _setMinter(_who, false);
138   }
139 
140   /// @notice Changes the owner role to provided address
141   /// @param _who is address to change role
142   /// @param _flag is next role status after success
143   /// @return A boolean that indicates if the operation was successful.
144   function _setOwner(address _who, bool _flag) private returns (bool) {
145     require(owners[_who] != _flag);
146     owners[_who] = _flag;
147     if (_flag) {
148       emit AddOwner(_who);
149     } else {
150       emit DeleteOwner(_who);
151     }
152     return true;
153   }
154 
155   /// @notice Changes the minter role to provided address
156   /// @param _who is address to change role
157   /// @param _flag is next role status after success
158   /// @return A boolean that indicates if the operation was successful.
159   function _setMinter(address _who, bool _flag) private returns (bool) {
160     require(minters[_who] != _flag);
161     minters[_who] = _flag;
162     if (_flag) {
163       emit AddMinter(_who);
164     } else {
165       emit DeleteMinter(_who);
166     }
167     return true;
168   }
169 }
170 
171 interface IMintableToken {
172   function mint(address _to, uint256 _amount) external returns (bool);
173 }
174 
175 
176 /// @title Very simplified implementation of Token Bucket Algorithm to secure token minting
177 /// @author Mai Abha <maiabha82@gmail.com>
178 /// @notice Works with tokens implemented Mintable interface
179 /// @dev Transfer ownership/minting role to contract and execute mint over AdvisorsBucket proxy to secure
180 contract AdvisorsBucket is RBACMixin, IMintableToken {
181   using SafeMath for uint;
182 
183   /// @notice Limit maximum amount of available for minting tokens when bucket is full
184   /// @dev Should be enough to mint tokens with proper speed but less enough to prevent overminting in case of losing pkey
185   uint256 public size;
186   /// @notice Bucket refill rate
187   /// @dev Tokens per second (based on block.timestamp). Amount without decimals (in smallest part of token)
188   uint256 public rate;
189   /// @notice Stored time of latest minting
190   /// @dev Each successful call of minting function will update field with call timestamp
191   uint256 public lastMintTime;
192   /// @notice Left tokens in bucket on time of latest minting
193   uint256 public leftOnLastMint;
194 
195   /// @notice Reference of Mintable token
196   /// @dev Setup in contructor phase and never change in future
197   IMintableToken public token;
198 
199   /// @notice Token Bucket leak event fires on each minting
200   /// @param to is address of target tokens holder
201   /// @param left is amount of tokens available in bucket after leak
202   event Leak(address indexed to, uint256 left);
203 
204   /// @param _token is address of Mintable token
205   /// @param _size initial size of token bucket
206   /// @param _rate initial refill rate (tokens/sec)
207   constructor (address _token, uint256 _size, uint256 _rate) public {
208     token = IMintableToken(_token);
209     size = _size;
210     rate = _rate;
211     leftOnLastMint = _size;
212   }
213 
214   /// @notice Change size of bucket
215   /// @dev Require owner role to call
216   /// @param _size is new size of bucket
217   /// @return A boolean that indicates if the operation was successful.
218   function setSize(uint256 _size) public onlyOwner returns (bool) {
219     size = _size;
220     return true;
221   }
222 
223   /// @notice Change refill rate of bucket
224   /// @dev Require owner role to call
225   /// @param _rate is new refill rate of bucket
226   /// @return A boolean that indicates if the operation was successful.
227   function setRate(uint256 _rate) public onlyOwner returns (bool) {
228     rate = _rate;
229     return true;
230   }
231 
232   /// @notice Change size and refill rate of bucket
233   /// @dev Require owner role to call
234   /// @param _size is new size of bucket
235   /// @param _rate is new refill rate of bucket
236   /// @return A boolean that indicates if the operation was successful.
237   function setSizeAndRate(uint256 _size, uint256 _rate) public onlyOwner returns (bool) {
238     return setSize(_size) && setRate(_rate);
239   }
240 
241   /// @notice Function to mint tokens
242   /// @param _to The address that will receive the minted tokens.
243   /// @param _amount The amount of tokens to mint.
244   /// @return A boolean that indicates if the operation was successful.
245   function mint(address _to, uint256 _amount) public onlyMinter returns (bool) {
246     uint256 available = availableTokens();
247     require(_amount <= available);
248     leftOnLastMint = available.sub(_amount);
249     lastMintTime = now; // solium-disable-line security/no-block-members
250     require(token.mint(_to, _amount));
251     return true;
252   }
253 
254   /// @notice Function to calculate and get available in bucket tokens
255   /// @return An amount of available tokens in bucket
256   function availableTokens() public view returns (uint) {
257      // solium-disable-next-line security/no-block-members
258     uint256 timeAfterMint = now.sub(lastMintTime);
259     uint256 refillAmount = rate.mul(timeAfterMint).add(leftOnLastMint);
260     return size < refillAmount ? size : refillAmount;
261   }
262 }