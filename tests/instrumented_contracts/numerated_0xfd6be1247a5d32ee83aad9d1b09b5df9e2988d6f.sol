1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 /*
53 
54 When executed after the Kings contract, the entire token balance inside the contract will be transferred to the minter if they becomes the king which they are already the king.
55 
56 
57 */
58 
59 
60 contract ERC20Interface {
61     function totalSupply() public constant returns (uint);
62     function balanceOf(address tokenOwner) public constant returns (uint balance);
63     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
64     function transfer(address to, uint tokens) public returns (bool success);
65     function approve(address spender, uint tokens) public returns (bool success);
66     function transferFrom(address from, address to, uint tokens) public returns (bool success);
67 
68     event Transfer(address indexed from, address indexed to, uint tokens);
69     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
70 }
71 
72 contract ERC918Interface {
73 
74   function epochCount() public constant returns (uint);
75 
76   function totalSupply() public constant returns (uint);
77   function getMiningDifficulty() public constant returns (uint);
78   function getMiningTarget() public constant returns (uint);
79   function getMiningReward() public constant returns (uint);
80   function balanceOf(address tokenOwner) public constant returns (uint balance);
81 
82   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
83 
84   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
85 
86 }
87 
88 contract mintForwarderInterface
89 {
90   function mintForwarder(uint256 nonce, bytes32 challenge_digest, address[] proxyMintArray) public returns (bool success);
91 }
92 
93 contract proxyMinterInterface
94 {
95   function proxyMint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
96 }
97 
98 contract miningKingContract
99 {
100   function getKing() public returns (address king);
101 }
102 
103 
104 contract ownedContractInterface
105 {
106   address public owner;
107 
108 }
109 
110 // ----------------------------------------------------------------------------
111 
112 // Owned contract
113 
114 // ----------------------------------------------------------------------------
115 
116 contract Owned {
117 
118     address public owner;
119 
120     address public newOwner;
121 
122 
123     event OwnershipTransferred(address indexed _from, address indexed _to);
124 
125 
126     function Owned() public {
127 
128         owner = msg.sender;
129 
130     }
131 
132 
133     modifier onlyOwner {
134 
135         require(msg.sender == owner);
136 
137         _;
138 
139     }
140 
141 
142     function transferOwnership(address _newOwner) public onlyOwner {
143 
144         newOwner = _newOwner;
145 
146     }
147 
148     function acceptOwnership() public {
149 
150         require(msg.sender == newOwner);
151 
152         OwnershipTransferred(owner, newOwner);
153 
154         owner = newOwner;
155 
156         newOwner = address(0);
157 
158     }
159 
160 }
161 
162 
163 
164 
165 contract DoubleKingsReward is Owned
166 {
167 
168 
169   using SafeMath for uint;
170 
171 
172    address public kingContract;
173 
174    address public minedToken;
175 
176 
177 
178    // 0xBTC is 0xb6ed7644c69416d67b522e20bc294a9a9b405b31;
179   constructor(address mToken, address mkContract) public  {
180     minedToken = mToken;
181     kingContract = mkContract;
182   }
183 
184 
185   function getBalance() view public returns (uint)
186   {
187     return ERC20Interface(minedToken).balanceOf(this);
188   }
189 
190   //do not allow ether to enter
191   function() public payable {
192       revert();
193   }
194 
195 
196 
197 
198 
199 
200 /**
201  Pay out the token balance if the king becomes the king twice in a row
202 **/
203 
204 //proxyMintWithKing
205    function mintForwarder(uint256 nonce, bytes32 challenge_digest, address[] proxyMintArray) public returns (bool)
206    {
207 
208        require(proxyMintArray.length > 0);
209 
210 
211        uint previousEpochCount = ERC918Interface(minedToken).epochCount();
212 
213        address proxyMinter = proxyMintArray[0];
214 
215        if(proxyMintArray.length == 1)
216        {
217          //Forward to the last proxyMint contract, typically a pool's owned  mint contract
218          require(proxyMinterInterface(proxyMinter).proxyMint(nonce, challenge_digest));
219        }else{
220          //if array length is greater than 1, pop the proxyMinter from the front of the array and keep cascading down the chain...
221          address[] memory remainingProxyMintArray = popFirstFromArray(proxyMintArray);
222 
223          require(mintForwarderInterface(proxyMinter).mintForwarder(nonce, challenge_digest,remainingProxyMintArray));
224        }
225 
226       //make sure that the minedToken really was proxy minted through the proxyMint delegate call chain
227        require( ERC918Interface(minedToken).epochCount() == previousEpochCount.add(1) );
228 
229 
230 
231 
232        // UNIQUE CONTRACT ACTION SPACE
233        address proxyMinterAddress = ownedContractInterface(proxyMinter).owner();
234        require(proxyMinterAddress == owner);
235 
236        address miningKing = miningKingContract(kingContract).getKing();
237 
238        bytes memory nonceBytes = uintToBytesForAddress(nonce);
239 
240        address newKing = bytesToAddress(nonceBytes);
241 
242        if(miningKing == newKing)
243        {
244          uint balance = ERC20Interface(minedToken).balanceOf(this);
245          require(ERC20Interface(minedToken).transfer(newKing,balance));
246        }
247        // --------
248 
249        return true;
250    }
251 
252 
253   function popFirstFromArray(address[] array) pure public returns (address[] memory)
254   {
255     address[] memory newArray = new address[](array.length-1);
256 
257     for (uint i=0; i < array.length-1; i++) {
258       newArray[i] =  array[i+1]  ;
259     }
260 
261     return newArray;
262   }
263 
264  function uintToBytesForAddress(uint256 x) pure public returns (bytes b) {
265 
266       b = new bytes(20);
267       for (uint i = 0; i < 20; i++) {
268           b[i] = byte(uint8(x / (2**(8*(31 - i)))));
269       }
270 
271       return b;
272     }
273 
274 
275  function bytesToAddress (bytes b) pure public returns (address) {
276      uint result = 0;
277      for (uint i = b.length-1; i+1 > 0; i--) {
278        uint c = uint(b[i]);
279        uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
280        result += to_inc;
281      }
282      return address(result);
283  }
284 
285  // ------------------------------------------------------------------------
286 
287  // Owner can transfer out any accidentally sent ERC20 tokens
288 
289  // ------------------------------------------------------------------------
290 
291  function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
292 
293      return ERC20Interface(tokenAddress).transfer(owner, tokens);
294 
295  }
296 
297 
298 }