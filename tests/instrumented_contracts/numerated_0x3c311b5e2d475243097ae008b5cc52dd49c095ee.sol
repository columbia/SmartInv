1 pragma solidity 0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: zeppelin-solidity/contracts/math/SafeMath.sol
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77     // benefit is lost if 'b' is also tested.
78     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79     if (a == 0) {
80       return 0;
81     }
82 
83     c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return a / b;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110     c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 
116 // File: contracts/ZTXInterface.sol
117 
118 contract ZTXInterface {
119     function transferOwnership(address _newOwner) public;
120     function mint(address _to, uint256 amount) public returns (bool);
121     function balanceOf(address who) public view returns (uint256);
122     function transfer(address to, uint256 value) public returns (bool);
123     function unpause() public;
124 }
125 
126 // File: contracts/airdropper/AirDropperCore.sol
127 
128 /**
129  * @title AirDropperCore
130  * @author Gustavo Guimaraes - <gustavo@zulurepublic.io>
131  * @dev Contract for the ZTX airdrop
132  */
133 contract AirDropperCore is Ownable {
134     using SafeMath for uint256;
135 
136     mapping (address => bool) public claimedAirdropTokens;
137 
138     uint256 public numOfCitizensWhoReceivedDrops;
139     uint256 public tokenAmountPerUser;
140     uint256 public airdropReceiversLimit;
141 
142     ZTXInterface public ztx;
143 
144     event TokenDrop(address indexed receiver, uint256 amount);
145 
146     /**
147      * @dev Constructor for the airdrop contract
148      * @param _airdropReceiversLimit Cap of airdrop receivers
149      * @param _tokenAmountPerUser Number of tokens done per user
150      * @param _ztx ZTX contract address
151      */
152     constructor(uint256 _airdropReceiversLimit, uint256 _tokenAmountPerUser, ZTXInterface _ztx) public {
153         require(
154             _airdropReceiversLimit != 0 &&
155             _tokenAmountPerUser != 0 &&
156             _ztx != address(0),
157             "constructor params cannot be empty"
158         );
159         airdropReceiversLimit = _airdropReceiversLimit;
160         tokenAmountPerUser = _tokenAmountPerUser;
161         ztx = ZTXInterface(_ztx);
162     }
163 
164     function triggerAirDrops(address[] recipients)
165         external
166         onlyOwner
167     {
168         for (uint256 i = 0; i < recipients.length; i++) {
169             triggerAirDrop(recipients[i]);
170         }
171     }
172 
173     /**
174      * @dev Distributes tokens to recipient addresses
175      * @param recipient address to receive airdropped token
176      */
177     function triggerAirDrop(address recipient)
178         public
179         onlyOwner
180     {
181         numOfCitizensWhoReceivedDrops = numOfCitizensWhoReceivedDrops.add(1);
182 
183         require(
184             numOfCitizensWhoReceivedDrops <= airdropReceiversLimit &&
185             !claimedAirdropTokens[recipient],
186             "Cannot give more tokens than airdropShare and cannot airdrop to an address that already receive tokens"
187         );
188 
189         claimedAirdropTokens[recipient] = true;
190 
191         // eligible citizens for airdrop receive tokenAmountPerUser in ZTX
192         sendTokensToUser(recipient, tokenAmountPerUser);
193         emit TokenDrop(recipient, tokenAmountPerUser);
194     }
195 
196     /**
197      * @dev Can be overridden to add sendTokensToUser logic. The overriding function
198      * should call super.sendTokensToUser() to ensure the chain is
199      * executed entirely.
200      * @param recipient Address to receive airdropped tokens
201      * @param tokenAmount Number of rokens to receive
202      */
203     function sendTokensToUser(address recipient, uint256 tokenAmount) internal {
204     }
205 }
206 
207 // File: contracts/airdropper/MintableAirDropper.sol
208 
209 /**
210  * @title MintableAirDropper
211  * @author Gustavo Guimaraes - <gustavo@zulurepublic.io>
212  * @dev Airdrop contract that mints ZTX tokens
213  */
214 contract MintableAirDropper is AirDropperCore {
215     /**
216      * @dev Constructor for the airdrop contract.
217      * NOTE: airdrop must be the token owner in order to mint ZTX tokens
218      * @param _airdropReceiversLimit Cap of airdrop receivers
219      * @param _tokenAmountPerUser Number of tokens done per user
220      * @param _ztx ZTX contract address
221      */
222     constructor
223         (
224             uint256 _airdropReceiversLimit,
225             uint256 _tokenAmountPerUser,
226             ZTXInterface _ztx
227         )
228         public
229         AirDropperCore(_airdropReceiversLimit, _tokenAmountPerUser, _ztx)
230     {}
231 
232     /**
233      * @dev override sendTokensToUser logic
234      * @param recipient Address to receive airdropped tokens
235      * @param tokenAmount Number of rokens to receive
236      */
237     function sendTokensToUser(address recipient, uint256 tokenAmount) internal {
238         ztx.mint(recipient, tokenAmount);
239         super.sendTokensToUser(recipient, tokenAmount);
240     }
241 
242     /**
243      * @dev Self-destructs contract
244      */
245     function kill(address newZuluOwner) external onlyOwner {
246         require(
247             numOfCitizensWhoReceivedDrops >= airdropReceiversLimit,
248             "only able to kill contract when numOfCitizensWhoReceivedDrops equals or is higher than airdropReceiversLimit"
249         );
250 
251         ztx.unpause();
252         ztx.transferOwnership(newZuluOwner);
253         selfdestruct(owner);
254     }
255 }