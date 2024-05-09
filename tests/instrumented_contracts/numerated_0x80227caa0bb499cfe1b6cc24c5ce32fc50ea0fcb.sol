1 pragma solidity ^0.4.19;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8   address public owner;
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   constructor() public {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     emit OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40 }
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, throws on overflow.
49   */
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     if (a == 0) {
52       return 0;
53     }
54     uint256 c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers, truncating the quotient.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   /**
70   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
71   */
72   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73     assert(b <= a);
74     return a - b;
75   }
76 
77   /**
78   * @dev Adds two numbers, throws on overflow.
79   */
80   function add(uint256 a, uint256 b) internal pure returns (uint256) {
81     uint256 c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 
87 /**
88  * @title SafeMath32
89  * @dev SafeMath library implemented for uint32
90  */
91 library SafeMath32 {
92 
93   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
94     if (a == 0) {
95       return 0;
96     }
97     uint32 c = a * b;
98     assert(c / a == b);
99     return c;
100   }
101 
102   function div(uint32 a, uint32 b) internal pure returns (uint32) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     uint32 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return c;
107   }
108 
109   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   function add(uint32 a, uint32 b) internal pure returns (uint32) {
115     uint32 c = a + b;
116     assert(c >= a);
117     return c;
118   }
119 }
120 
121 /**
122  * @title SafeMath16
123  * @dev SafeMath library implemented for uint16
124  */
125 library SafeMath16 {
126 
127   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
128     if (a == 0) {
129       return 0;
130     }
131     uint16 c = a * b;
132     assert(c / a == b);
133     return c;
134   }
135 
136   function div(uint16 a, uint16 b) internal pure returns (uint16) {
137     // assert(b > 0); // Solidity automatically throws when dividing by 0
138     uint16 c = a / b;
139     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
140     return c;
141   }
142 
143   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
144     assert(b <= a);
145     return a - b;
146   }
147 
148   function add(uint16 a, uint16 b) internal pure returns (uint16) {
149     uint16 c = a + b;
150     assert(c >= a);
151     return c;
152   }
153 }
154 contract ERC721 {
155   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
156   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
157 
158   function balanceOf(address _owner) public view returns (uint256 _balance);
159   function ownerOf(uint256 _tokenId) public view returns (address _owner);
160   function transfer(address _to, uint256 _tokenId) public;
161   function approve(address _to, uint256 _tokenId) public;
162   function takeOwnership(uint256 _tokenId) public;
163 }
164 contract FootBall is Ownable,ERC721{
165     using SafeMath for uint256;
166     uint public drawFee = 0.05 ether;
167     uint public defendFee = 0.01 ether;
168     uint public inviteRate = 5;
169     uint coolDownTime = 24 hours;
170     uint public playerInDraw = 0;
171     uint backFee = 75;
172     event newPlayer(uint _id,uint16 _attack);
173     event drawedPlayer(uint _id,address indexed _to,uint _time);
174     event battleLog(uint _playerA,uint _playerB,uint _result,uint _rdId,address indexed _addressA,address indexed _addressB);
175     event playerDefend(uint _id,uint _time);
176     event playerBack(uint _id , address indexed _address);
177     event purChase(uint _id, address _newowner, address _oldowner);
178     event inviteBack(address _from,address _to, uint _fee);
179     //name&pic store in db;
180     struct Player{
181         uint256 sellPrice;
182         uint256 readytime;
183         uint16 attack;
184         uint16 winCount;
185         uint16 lossCount;
186         uint8 isSell;
187         uint8 isDraw;
188     }
189     Player[] public players; 
190     mapping(uint=>address) playerToOwner;
191     mapping(address=>uint) ownerPlayerCount;
192     mapping (uint => address) playerApprovals;
193     //modifier
194     modifier onlyOwnerOf(uint _id) {
195         require(msg.sender == playerToOwner[_id]);
196         _;
197     }
198     //owner draw _money
199     function withdraw() external onlyOwner {
200         owner.transfer(address(this).balance);
201     }
202     function() payable public{}
203     //change fee
204     function changeDrawFee(uint _money)public onlyOwner{ 
205         drawFee = _money;
206     }
207     function changeDefendFee(uint _money) public onlyOwner{
208         defendFee = _money;
209     }
210     function changeCoolDownTime(uint _time) public onlyOwner{
211         coolDownTime = _time;
212     }
213     function changeInviteRate(uint _rate) public onlyOwner{
214         inviteRate = _rate;
215     }
216     //create player;
217     function createPlayer(uint16 _attack) public onlyOwner{ 
218       uint id = players.push (Player(0 ether,0,_attack,0,0,0,0)) - 1;
219       playerInDraw = playerInDraw.add(1);
220       emit newPlayer(id,_attack);
221     }
222     //draw card
223     function drawPlayer(address _address) public payable returns (uint playerId){
224         require(msg.value == drawFee && playerInDraw > 0);
225         for(uint i =0;i < players.length;i++){ 
226             if(players[i].isDraw == 0){ 
227                 players[i].isDraw = 1;
228                 playerInDraw  = playerInDraw.sub(1);
229                 playerToOwner[i] = msg.sender;
230                 ownerPlayerCount[msg.sender] = ownerPlayerCount[msg.sender].add(1);
231                 if(_address != 0){ 
232                  uint inviteFee = msg.value * 5 / 100;
233                  _address.transfer(inviteFee);
234                  emit inviteBack(msg.sender,_address,inviteFee);
235                 }
236                 emit drawedPlayer(i,msg.sender,now);
237                 return i;
238             }
239         }
240     }
241     //battle 
242     function playerAttack(uint _playerA,uint _playerB) external{
243         require(playerToOwner[_playerA] == msg.sender && players[_playerB].isDraw == 1 && playerToOwner[_playerA] != playerToOwner[_playerB]);
244         require(now >= players[_playerB].readytime);
245         uint rdId = uint256(keccak256(block.difficulty,now))%1000;
246         uint attackA;
247         uint attackB;
248         address ownerOfB = playerToOwner[_playerB];
249         if(rdId >= players[_playerA].attack){
250             attackA = rdId -  players[_playerA].attack;
251         }else{ 
252             attackA =  players[_playerA].attack - rdId;
253         }
254         if(rdId >= players[_playerB].attack){
255             attackB =  rdId -  players[_playerB].attack;
256         }else{
257             attackB =  players[_playerA].attack - rdId;
258         }
259         uint8 result= 0;
260         if(attackA < attackB){
261             result = 1;
262             playerToOwner[_playerB] = msg.sender;
263             ownerPlayerCount[msg.sender] = ownerPlayerCount[msg.sender].add(1);
264             ownerPlayerCount[playerToOwner[_playerB]] = ownerPlayerCount[playerToOwner[_playerB]].sub(1);
265         }else{ 
266             result = 2;
267             playerToOwner[_playerA] = playerToOwner[_playerB];
268             ownerPlayerCount[msg.sender] = ownerPlayerCount[msg.sender].sub(1);
269             ownerPlayerCount[playerToOwner[_playerB]] = ownerPlayerCount[playerToOwner[_playerB]].add(1);
270         }
271         emit battleLog(_playerA,_playerB,result,rdId,msg.sender,ownerOfB);
272     }
273     //defend
274     function getPlayerDefend(uint _id) public payable{
275         require(msg.value == defendFee && msg.sender == playerToOwner[_id]);
276         players[_id].readytime = uint256(now + coolDownTime);
277         emit playerDefend(_id,players[_id].readytime);
278     }
279     //sendback
280     function sendPlayerBack(uint[] _id) public {
281         for(uint i=0;i<_id.length;i++){ 
282             uint256 id = _id[i];
283             require(playerToOwner[id] == msg.sender);
284             uint fee = drawFee * backFee/100;
285             //init player info 
286             players[id].isDraw = 0;
287             players[id].isSell = 0;
288             players[id].readytime = 0;
289             players[id].sellPrice = 0 ether;
290             playerToOwner[id] = 0;
291             ownerPlayerCount[msg.sender] = ownerPlayerCount[msg.sender].sub(1);
292             playerInDraw  = playerInDraw.add(1);
293             if(address(this).balance >= fee){ 
294                 msg.sender.transfer(fee);    
295             }  
296             emit playerBack(id,msg.sender);
297         }
298 
299     }
300     //ERC721 functions;
301     function balanceOf(address _owner) public view returns (uint256 _balance) {
302         return ownerPlayerCount[_owner];
303     }
304 
305     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
306         return playerToOwner[_tokenId];
307     }
308     function _transfer(address _from, address _to, uint256 _tokenId) private {
309         require(_from != _to);
310         ownerPlayerCount[_to] = ownerPlayerCount[_to].add(1) ;
311         ownerPlayerCount[_from] = ownerPlayerCount[_from].sub(1);
312         playerToOwner[_tokenId] = _to;
313         emit Transfer(_from, _to, _tokenId);
314     }
315     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
316         _transfer(msg.sender, _to, _tokenId);
317     }
318 
319     function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
320         playerApprovals[_tokenId] = _to;
321         emit Approval(msg.sender, _to, _tokenId);
322     }
323     function takeOwnership(uint256 _tokenId) public {
324         require(playerApprovals[_tokenId] == msg.sender && playerToOwner[_tokenId] != msg.sender);
325         address owner = ownerOf(_tokenId);
326         _transfer(owner, msg.sender, _tokenId);
327     }
328     //market functions
329     function setPlayerPrice(uint _id,uint _price) public payable onlyOwnerOf(_id){ 
330         require(msg.value == defendFee);
331         players[_id].isSell = 1;
332         players[_id].sellPrice = _price;
333         players[_id].readytime = uint256(now + coolDownTime);
334     }
335     function playerTakeOff(uint _id) public onlyOwnerOf(_id){
336         players[_id].isSell = 0;
337     }
338     function purchase(uint _id) public payable{
339         require(players[_id].isSell == 1 && msg.value == players[_id].sellPrice &&msg.sender != playerToOwner[_id]);
340         address owner = playerToOwner[_id];
341         ownerPlayerCount[owner] = ownerPlayerCount[owner].sub(1) ;
342         ownerPlayerCount[msg.sender] = ownerPlayerCount[msg.sender].add(1);
343         playerToOwner[_id] = msg.sender;
344         owner.transfer(msg.value);
345         emit purChase(_id,msg.sender,owner);
346     }
347 }