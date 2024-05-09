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
54 This is a King Of The Hill contract which requires Proof of Work (hashpower) to set the king
55 
56 This global non-owned contract proxy-mints 0xBTC through a personally-owned mintHelper contract (MintHelper.sol)
57 
58 */
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
71 contract ERC918Interface {
72 
73   function epochCount() public constant returns (uint);
74 
75   function totalSupply() public constant returns (uint);
76   function getMiningDifficulty() public constant returns (uint);
77   function getMiningTarget() public constant returns (uint);
78   function getMiningReward() public constant returns (uint);
79   function balanceOf(address tokenOwner) public constant returns (uint balance);
80 
81   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
82 
83   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
84 
85 }
86 
87 contract mintForwarderInterface
88 {
89   function mintForwarder(uint256 nonce, bytes32 challenge_digest, address[] proxyMintArray) public returns (bool success);
90 }
91 
92 contract proxyMinterInterface
93 {
94   function proxyMint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
95 }
96 
97 
98 contract MiningKing   {
99 
100 
101   using SafeMath for uint;
102 
103 
104    address public miningKing;
105 
106    address public minedToken;
107 
108 
109    event TransferKing(address from, address to);
110 
111    // 0xBTC is 0xb6ed7644c69416d67b522e20bc294a9a9b405b31;
112   constructor(address mintableToken) public  {
113     minedToken = mintableToken;
114   }
115 
116 
117   //do not allow ether to enter
118   function() public payable {
119       revert();
120   }
121 
122   function getKing() view public returns (address king)
123   {
124     return miningKing;
125   }
126 
127    function transferKing(address newKing) public   {
128 
129        require(msg.sender == miningKing);
130 
131        miningKing = newKing;
132 
133        emit TransferKing(msg.sender, newKing);
134 
135    }
136 
137 
138 /**
139 Set the king to the Ethereum Address which is encoded as 160 bits of the 256 bit mining nonce
140 
141 
142 **/
143 
144 //proxyMintWithKing
145    function mintForwarder(uint256 nonce, bytes32 challenge_digest, address[] proxyMintArray) public returns (bool)
146    {
147 
148       require(proxyMintArray.length > 0);
149 
150 
151       uint previousEpochCount = ERC918Interface(minedToken).epochCount();
152 
153       address proxyMinter = proxyMintArray[0];
154 
155       if(proxyMintArray.length == 1)
156       {
157         //Forward to the last proxyMint contract, typically a pool's owned  mint contract
158         require(proxyMinterInterface(proxyMinter).proxyMint(nonce, challenge_digest));
159       }else{
160         //if array length is greater than 1, pop the proxyMinter from the front of the array and keep cascading down the chain...
161         address[] memory remainingProxyMintArray = popFirstFromArray(proxyMintArray);
162 
163         require(mintForwarderInterface(proxyMinter).mintForwarder(nonce, challenge_digest,remainingProxyMintArray));
164       }
165 
166      //make sure that the minedToken really was proxy minted through the proxyMint delegate call chain
167       require( ERC918Interface(minedToken).epochCount() == previousEpochCount.add(1) );
168 
169 
170 
171 
172       // UNIQUE CONTRACT ACTION SPACE 
173       bytes memory nonceBytes = uintToBytesForAddress(nonce);
174 
175       address newKing = bytesToAddress(nonceBytes);
176       
177       miningKing = newKing;
178       // --------
179 
180       return true;
181    }
182 
183 
184   function popFirstFromArray(address[] array) pure public returns (address[] memory)
185   {
186     address[] memory newArray = new address[](array.length-1);
187 
188     for (uint i=0; i < array.length-1; i++) {
189       newArray[i] =  array[i+1]  ;
190     }
191 
192     return newArray;
193   }
194 
195  function uintToBytesForAddress(uint256 x) pure public returns (bytes b) {
196 
197       b = new bytes(20);
198       for (uint i = 0; i < 20; i++) {
199           b[i] = byte(uint8(x / (2**(8*(31 - i)))));
200       }
201 
202       return b;
203     }
204 
205 
206  function bytesToAddress (bytes b) pure public returns (address) {
207      uint result = 0;
208      for (uint i = b.length-1; i+1 > 0; i--) {
209        uint c = uint(b[i]);
210        uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
211        result += to_inc;
212      }
213      return address(result);
214  }
215 
216 
217 
218 
219 }