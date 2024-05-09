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
104 // ----------------------------------------------------------------------------
105 
106 // Owned contract
107 
108 // ----------------------------------------------------------------------------
109 
110 contract Owned {
111 
112     address public owner;
113 
114     address public newOwner;
115 
116 
117     event OwnershipTransferred(address indexed _from, address indexed _to);
118 
119 
120     function Owned() public {
121 
122         owner = msg.sender;
123 
124     }
125 
126 
127     modifier onlyOwner {
128 
129         require(msg.sender == owner);
130 
131         _;
132 
133     }
134 
135 
136     function transferOwnership(address _newOwner) public onlyOwner {
137 
138         newOwner = _newOwner;
139 
140     }
141 
142     function acceptOwnership() public {
143 
144         require(msg.sender == newOwner);
145 
146         OwnershipTransferred(owner, newOwner);
147 
148         owner = newOwner;
149 
150         newOwner = address(0);
151 
152     }
153 
154 }
155 
156 
157 
158 
159 contract DoubleKingsReward is Owned
160 {
161 
162 
163   using SafeMath for uint;
164 
165 
166    address public kingContract;
167 
168    address public minedToken;
169 
170 
171 
172    // 0xBTC is 0xb6ed7644c69416d67b522e20bc294a9a9b405b31;
173   constructor(address mToken, address mkContract) public  {
174     minedToken = mToken;
175     kingContract = mkContract;
176   }
177 
178 
179   function getBalance() view public returns (uint)
180   {
181     return ERC20Interface(minedToken).balanceOf(this);
182   }
183 
184   //do not allow ether to enter
185   function() public payable {
186       revert();
187   }
188 
189 
190 
191 
192 
193 
194 /**
195  Pay out the token balance if the king becomes the king twice in a row
196 **/
197 
198 //proxyMintWithKing
199    function mintForwarder(uint256 nonce, bytes32 challenge_digest, address[] proxyMintArray) public returns (bool)
200    {
201 
202        require(proxyMintArray.length > 0);
203 
204 
205        uint previousEpochCount = ERC918Interface(minedToken).epochCount();
206 
207        address proxyMinter = proxyMintArray[0];
208 
209        if(proxyMintArray.length == 1)
210        {
211          //Forward to the last proxyMint contract, typically a pool's owned  mint contract
212          require(proxyMinterInterface(proxyMinter).proxyMint(nonce, challenge_digest));
213        }else{
214          //if array length is greater than 1, pop the proxyMinter from the front of the array and keep cascading down the chain...
215          address[] memory remainingProxyMintArray = popFirstFromArray(proxyMintArray);
216 
217          require(mintForwarderInterface(proxyMinter).mintForwarder(nonce, challenge_digest,remainingProxyMintArray));
218        }
219 
220       //make sure that the minedToken really was proxy minted through the proxyMint delegate call chain
221        require( ERC918Interface(minedToken).epochCount() == previousEpochCount.add(1) );
222 
223 
224 
225 
226        // UNIQUE CONTRACT ACTION SPACE
227        address miningKing = miningKingContract(kingContract).getKing();
228 
229        bytes memory nonceBytes = uintToBytesForAddress(nonce);
230 
231        address newKing = bytesToAddress(nonceBytes);
232 
233        if(miningKing == newKing)
234        {
235          uint balance = ERC20Interface(minedToken).balanceOf(this);
236          require(ERC20Interface(minedToken).transfer(newKing,balance));
237        }
238        // --------
239 
240        return true;
241    }
242 
243 
244   function popFirstFromArray(address[] array) pure public returns (address[] memory)
245   {
246     address[] memory newArray = new address[](array.length-1);
247 
248     for (uint i=0; i < array.length-1; i++) {
249       newArray[i] =  array[i+1]  ;
250     }
251 
252     return newArray;
253   }
254 
255  function uintToBytesForAddress(uint256 x) pure public returns (bytes b) {
256 
257       b = new bytes(20);
258       for (uint i = 0; i < 20; i++) {
259           b[i] = byte(uint8(x / (2**(8*(31 - i)))));
260       }
261 
262       return b;
263     }
264 
265 
266  function bytesToAddress (bytes b) pure public returns (address) {
267      uint result = 0;
268      for (uint i = b.length-1; i+1 > 0; i--) {
269        uint c = uint(b[i]);
270        uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
271        result += to_inc;
272      }
273      return address(result);
274  }
275 
276  // ------------------------------------------------------------------------
277 
278  // Owner can transfer out any accidentally sent ERC20 tokens
279 
280  // ------------------------------------------------------------------------
281 
282  function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
283 
284      return ERC20Interface(tokenAddress).transfer(owner, tokens);
285 
286  }
287 
288 
289 }