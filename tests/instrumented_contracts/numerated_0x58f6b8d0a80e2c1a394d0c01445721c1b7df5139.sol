1 pragma solidity ^0.4.15;
2 
3 /*
4   https://cryptogs.io
5   --Austin Thomas Griffith for ETHDenver
6   PizzaParlor -- a new venue for cryptogs games
7   less transactions than original Cryptogs.sol assuming some
8   centralization and a single commit reveal for randomness
9 */
10 
11 
12 
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20 
21 
22   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   function Ownable() public {
30     owner = msg.sender;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) public onlyOwner {
46     require(newOwner != address(0));
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 
54 contract PizzaParlor {
55 
56   uint8 public constant FLIPPINESS = 64;
57   uint8 public constant FLIPPINESSROUNDBONUS = 16;
58   uint8 public constant MAXROUNDS = 12; //must be greater than (255-FLIPPINESS)/FLIPPINESSROUNDBONUS
59   uint32 public constant BLOCKTIMEOUT = 40;// a few hours?
60 
61   address public cryptogsAddress;
62   function PizzaParlor(address _cryptogsAddress) public {
63     cryptogsAddress=_cryptogsAddress;
64   }
65 
66   //to make less transactions on-chain, game creation will happen off-chain
67   //at this point, two players have agreed upon the ten cryptogs that will
68   //be in the game, five from each player
69   // the server will generate a secret, reveal, and commit
70   // this commit is used as the game id and both players share it
71   // the server will pick one user at random to be the game master
72   // this player will get the reveal and be in charge of generating the game
73   // technically either player can generate the game with the reveal
74   // (and either player can drain the stack with the secret)
75 
76     //     commit      ->      player  -> stack hash
77   mapping (bytes32 => mapping (address => bytes32)) public commitReceipt;
78 
79     //     commit      ->      player  -> block number
80   mapping (bytes32 => mapping (address => uint32)) public commitBlock;
81 
82   mapping (bytes32 => uint8) public stacksTransferred;
83 
84   //tx1&2: players submit to a particular commit hash their stack of pogs (the two txs can happen on the same block, no one is waiting)
85   //these go to the Cryptogs contract and it is transferStackAndCall'ed to here
86   function onTransferStack(address _sender, uint _token1, uint _token2, uint _token3, uint _token4, uint _token5, bytes32 _commit){
87 
88     //make sure this came from the Cryptogs contract
89     require(msg.sender == cryptogsAddress);
90 
91     //make sure this commit is unique / doesn't already exist
92     require(commitReceipt[_commit][_sender] == 0);
93 
94     //make sure there aren't already two stacks submitted
95     require(stacksTransferred[_commit]<2);
96     stacksTransferred[_commit]++;
97 
98     //make sure this contract now owns these tokens
99     NFT cryptogsContract = NFT(cryptogsAddress);
100     require(cryptogsContract.tokenIndexToOwner(_token1)==address(this));
101     require(cryptogsContract.tokenIndexToOwner(_token2)==address(this));
102     require(cryptogsContract.tokenIndexToOwner(_token3)==address(this));
103     require(cryptogsContract.tokenIndexToOwner(_token4)==address(this));
104     require(cryptogsContract.tokenIndexToOwner(_token5)==address(this));
105 
106     //generate a receipt for the transfer
107     bytes32 receipt = keccak256(_commit,_sender,_token1,_token2,_token3,_token4,_token5);
108     commitReceipt[_commit][_sender] = receipt;
109     commitBlock[_commit][_sender] = uint32(block.number);
110 
111     //fire an event for the frontend
112     TransferStack(_commit,_sender,receipt,now,_token1,_token2,_token3,_token4,_token5);
113   }
114   event TransferStack(bytes32 indexed _commit,address indexed _sender,bytes32 indexed _receipt,uint _timestamp,uint256 _token1,uint256 _token2,uint256 _token3,uint256 _token4,uint256 _token5);
115 
116   //tx3: either player, knowing the reveal, can generate the game
117   //this tx calculates random, generates game events, and transfers
118   // tokens back to winners
119   //in order to make game costs fair, the frontend should randomly select
120   // one of the two players and give them the reveal to generate the game
121   // in a bit you could give it to the other player too .... then after the
122   // timeout, they would get the secret to drain the stack
123   function generateGame(bytes32 _commit,bytes32 _reveal,address _opponent,uint _token1, uint _token2, uint _token3, uint _token4, uint _token5,uint _token6, uint _token7, uint _token8, uint _token9, uint _token10){
124     //verify that receipts are valid
125     require( commitReceipt[_commit][msg.sender] == keccak256(_commit,msg.sender,_token1,_token2,_token3,_token4,_token5) );
126     require( commitReceipt[_commit][_opponent] == keccak256(_commit,_opponent,_token6,_token7,_token8,_token9,_token10) );
127 
128     //verify we are on a later block so random will work
129     require( uint32(block.number) > commitBlock[_commit][msg.sender]);
130     require( uint32(block.number) > commitBlock[_commit][_opponent]);
131 
132     //verify that the reveal is correct
133     require(_commit == keccak256(_reveal));
134 
135     //make sure there are exactly two stacks submitted
136     require(stacksTransferred[_commit]==2);
137 
138     _generateGame(_commit,_reveal,_opponent,[_token1,_token2,_token3,_token4,_token5,_token6,_token7,_token8,_token9,_token10]);
139   }
140 
141   function _generateGame(bytes32 _commit,bytes32 _reveal,address _opponent,uint[10] _tokens) internal {
142     //create Cryptogs contract for transfers
143     NFT cryptogsContract = NFT(cryptogsAddress);
144 
145     //generate the random using commit / reveal and blockhash from future (now past) block
146     bytes32[4] memory pseudoRandoms = _generateRandom(_reveal,commitBlock[_commit][msg.sender],commitBlock[_commit][_opponent]);
147 
148     bool whosTurn = uint8(pseudoRandoms[0][0])%2==0;
149     CoinFlip(_commit,whosTurn,whosTurn ? msg.sender : _opponent);
150     for(uint8 round=1;round<=MAXROUNDS;round++){
151       for(uint8 i=1;i<=10;i++){
152         //first check and see if this token has flipped yet
153         if(_tokens[i-1]>0){
154 
155           //get the random byte between 0-255 from our pseudoRandoms array of bytes32
156           uint8 rand = _getRandom(pseudoRandoms,(round-1)*10 + i);
157 
158           uint8 threshold = (FLIPPINESS+round*FLIPPINESSROUNDBONUS);
159           if( rand < threshold || round==MAXROUNDS ){
160             _flip(_commit,round,cryptogsContract,_tokens,i-1,_opponent,whosTurn);
161           }
162         }
163       }
164       whosTurn = !whosTurn;
165     }
166 
167 
168     delete commitReceipt[_commit][msg.sender];
169     delete commitReceipt[_commit][_opponent];
170 
171     GenerateGame(_commit,msg.sender);
172   }
173   event CoinFlip(bytes32 indexed _commit,bool _result,address _winner);
174   event GenerateGame(bytes32 indexed _commit,address indexed _sender);
175 
176   function _getRandom(bytes32[4] pseudoRandoms,uint8 randIndex) internal returns (uint8 rand){
177     if(randIndex<32){
178       rand = uint8(pseudoRandoms[0][randIndex]);
179     }else if(randIndex<64){
180       rand = uint8(pseudoRandoms[1][randIndex-32]);
181     }else if(randIndex<96){
182       rand = uint8(pseudoRandoms[1][randIndex-64]);
183     }else{
184       rand = uint8(pseudoRandoms[1][randIndex-96]);
185     }
186     return rand;
187   }
188 
189   function _generateRandom(bytes32 _reveal, uint32 block1,uint32 block2) internal returns(bytes32[4] pseudoRandoms){
190     pseudoRandoms[0] = keccak256(_reveal,block.blockhash(max(block1,block2)));
191     pseudoRandoms[1] = keccak256(pseudoRandoms[0]);
192     pseudoRandoms[2] = keccak256(pseudoRandoms[1]);
193     pseudoRandoms[3] = keccak256(pseudoRandoms[2]);
194     return pseudoRandoms;
195   }
196 
197   function max(uint32 a, uint32 b) private pure returns (uint32) {
198       return a > b ? a : b;
199   }
200 
201   function _flip(bytes32 _commit,uint8 round,NFT cryptogsContract,uint[10] _tokens,uint8 tokenIndex,address _opponent,bool whosTurn) internal {
202     address flipper;
203     if(whosTurn) {
204       flipper=msg.sender;
205     }else{
206       flipper=_opponent;
207     }
208     cryptogsContract.transfer(flipper,_tokens[tokenIndex]);
209     Flip(_commit,round,flipper,_tokens[tokenIndex]);
210     _tokens[tokenIndex]=0;
211   }
212   event Flip(bytes32 indexed _commit,uint8 _round,address indexed _flipper,uint indexed _token);
213 
214   //if the game times out without either player generating the game,
215   // (the frontend should have selected one of the players randomly to generate the game)
216   //the frontend should give the other player the secret to drain the game
217   // secret -> reveal -> commit
218   function drainGame(bytes32 _commit,bytes32 _secret,address _opponent,uint _token1, uint _token2, uint _token3, uint _token4, uint _token5,uint _token6, uint _token7, uint _token8, uint _token9, uint _token10){
219     //verify that receipts are valid
220     require( commitReceipt[_commit][msg.sender] == keccak256(_commit,msg.sender,_token1,_token2,_token3,_token4,_token5) );
221     require( commitReceipt[_commit][_opponent] == keccak256(_commit,_opponent,_token6,_token7,_token8,_token9,_token10) );
222 
223     //verify we are on a later block so random will work
224     require( uint32(block.number) > commitBlock[_commit][msg.sender]+BLOCKTIMEOUT);
225     require( uint32(block.number) > commitBlock[_commit][_opponent]+BLOCKTIMEOUT);
226 
227     //make sure the commit is the doublehash of the secret
228     require(_commit == keccak256(keccak256(_secret)));
229 
230     //make sure there are exactly two stacks submitted
231     require(stacksTransferred[_commit]==2);
232 
233     _drainGame(_commit,_opponent,[_token1,_token2,_token3,_token4,_token5,_token6,_token7,_token8,_token9,_token10]);
234   }
235 
236   function _drainGame(bytes32 _commit,address _opponent, uint[10] _tokens) internal {
237     //create Cryptogs contract for transfers
238     NFT cryptogsContract = NFT(cryptogsAddress);
239 
240     cryptogsContract.transfer(msg.sender,_tokens[0]);
241     cryptogsContract.transfer(msg.sender,_tokens[1]);
242     cryptogsContract.transfer(msg.sender,_tokens[2]);
243     cryptogsContract.transfer(msg.sender,_tokens[3]);
244     cryptogsContract.transfer(msg.sender,_tokens[4]);
245     cryptogsContract.transfer(msg.sender,_tokens[5]);
246     cryptogsContract.transfer(msg.sender,_tokens[6]);
247     cryptogsContract.transfer(msg.sender,_tokens[7]);
248     cryptogsContract.transfer(msg.sender,_tokens[8]);
249     cryptogsContract.transfer(msg.sender,_tokens[9]);
250 
251     Flip(_commit,1,msg.sender,_tokens[0]);
252     Flip(_commit,1,msg.sender,_tokens[1]);
253     Flip(_commit,1,msg.sender,_tokens[2]);
254     Flip(_commit,1,msg.sender,_tokens[3]);
255     Flip(_commit,1,msg.sender,_tokens[4]);
256     Flip(_commit,1,msg.sender,_tokens[5]);
257     Flip(_commit,1,msg.sender,_tokens[6]);
258     Flip(_commit,1,msg.sender,_tokens[7]);
259     Flip(_commit,1,msg.sender,_tokens[8]);
260     Flip(_commit,1,msg.sender,_tokens[9]);
261 
262     delete commitReceipt[_commit][msg.sender];
263     delete commitReceipt[_commit][_opponent];
264     DrainGame(_commit,msg.sender);
265   }
266   event DrainGame(bytes32 indexed _commit,address indexed _sender);
267 
268   //if only one player ever ends up submitting a stack, they need to be able
269   //to pull thier tokens back
270   function revokeStack(bytes32 _commit,uint _token1, uint _token2, uint _token3, uint _token4, uint _token5){
271     //verify that receipt is valid
272     require( commitReceipt[_commit][msg.sender] == keccak256(_commit,msg.sender,_token1,_token2,_token3,_token4,_token5) );
273 
274     //make sure there is exactly one stacks submitted
275     require(stacksTransferred[_commit]==1);
276 
277     stacksTransferred[_commit]=0;
278 
279     NFT cryptogsContract = NFT(cryptogsAddress);
280 
281     cryptogsContract.transfer(msg.sender,_token1);
282     cryptogsContract.transfer(msg.sender,_token2);
283     cryptogsContract.transfer(msg.sender,_token3);
284     cryptogsContract.transfer(msg.sender,_token4);
285     cryptogsContract.transfer(msg.sender,_token5);
286 
287 
288     bytes32 previousReceipt = commitReceipt[_commit][msg.sender];
289 
290     delete commitReceipt[_commit][msg.sender];
291     //fire an event for the frontend
292     RevokeStack(_commit,msg.sender,now,_token1,_token2,_token3,_token4,_token5,previousReceipt);
293   }
294   event RevokeStack(bytes32 indexed _commit,address indexed _sender,uint _timestamp,uint256 _token1,uint256 _token2,uint256 _token3,uint256 _token4,uint256 _token5,bytes32 _receipt);
295 
296 }
297 
298 contract NFT {
299   function approve(address _to,uint256 _tokenId) public returns (bool) { }
300   function transfer(address _to,uint256 _tokenId) external { }
301   mapping (uint256 => address) public tokenIndexToOwner;
302 }