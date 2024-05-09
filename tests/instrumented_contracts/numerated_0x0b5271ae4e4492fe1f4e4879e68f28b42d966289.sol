1 pragma solidity ^0.4.16;
2 pragma solidity ^0.4.18;
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() public {
65     owner = msg.sender;
66   }
67 
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 contract zombieToken {
92   function mint(address to, uint256 value) public returns (bool success);
93 }
94 
95 contract zombieMain {
96   function checkAllOwner(uint256[] _tokenId, address owner) public view returns (bool);
97   function seeZombieRole(uint256 _tokenId) public view returns (uint16 roletype);
98   function seeZombieColor(uint256 _tokenId) public view returns (uint8 color);
99   function seeZombieStar(uint256 _tokenId) public view returns (uint8 star);
100   function seeZombieDna(uint256 _tokenId) public view returns (bytes32 dna);
101 }
102 
103 contract zombieInvasion is Ownable{
104     using SafeMath for uint256;
105     
106     zombieToken zombietoken = zombieToken(0x83B8C8A08938B878017fDF0Ec0A689313F75739D);
107     zombieMain zombiemain = zombieMain(0x58fd762F76D57C6fC2a480F6d26c1D03175AD64F);
108 
109     struct Zombie {
110       uint32 readyTime;//剩餘可出戰時間
111       bool notAtHome;  //是否離家
112       uint16 undeadsTime;//不死次數
113     }
114 
115     struct Area {
116       uint starLimit; 
117       uint8 TeamMemberlimitCount; // 5
118       uint8[] roletype;     //  4,4,99,99,99
119       uint TotallimitTeamCount;
120       uint TotalTeamCount;
121       string name;
122       uint ZOBRevenue;
123       bool isOpen;
124       uint32 duration;
125     }
126 
127     struct Team {
128       bool isCharge;
129       uint areaID;
130       uint[] Zombies;
131       uint32 awardTime;
132       address Owner;
133       bytes32 teamHash;
134       uint blocknumber;
135     }
136     
137     Area[] public areas;
138 
139     mapping (uint=>Zombie) public zombies;
140     mapping (bytes32=>Team) public teams;
141 
142     event StartInvasion(bytes32 indexed teamhash, uint _areaId,uint[] _zombieId);
143     event AwardInvation(bytes32 indexed teamhash, bool InvationResult, uint ZOBRevenue);
144 
145     modifier onlyOwnerOf(uint[] _zombieId) {
146       require(zombiemain.checkAllOwner(_zombieId, msg.sender));
147       _;
148     }
149 
150 
151   function startInvasion(uint _areaId, uint[] _zombieId) public onlyOwnerOf(_zombieId){
152     require(areas[_areaId].TotallimitTeamCount >= areas[_areaId].TotalTeamCount + 1);
153     require(areas[_areaId].isOpen);
154     require(areas[_areaId].TeamMemberlimitCount >= _zombieId.length);
155 
156     bytes32 teamHash = block.blockhash(block.number-1);
157 
158     for(uint16 i = 0; i<_zombieId.length; i++){
159       //確保殭屍都在家，並且可以出戰
160       require(now > zombies[_zombieId[i]].readyTime);
161       require(!zombies[_zombieId[i]].notAtHome);
162 
163       teamHash = keccak256(teamHash,now,_areaId,zombiemain.seeZombieDna(_zombieId[i]));
164 
165       zombies[_zombieId[i]].notAtHome = true;
166       zombies[_zombieId[i]].readyTime = uint32(now + areas[_areaId].duration);
167     }
168 
169     //職業都必須符合條件
170     for(uint16 a = 0; a<areas[_areaId].roletype.length; a++){
171       if(areas[_areaId].roletype[a] == 99) continue;
172       if(zombiemain.seeZombieRole(_zombieId[a]) != areas[_areaId].roletype[a]) revert();
173     }    
174 
175     areas[_areaId].TotalTeamCount ++;
176 
177     require(teams[teamHash].areaID == 0);
178     teams[teamHash] = Team(false,_areaId,_zombieId,uint32(now+areas[_areaId].duration),msg.sender,teamHash,block.number + 1);
179     
180     StartInvasion(teamHash, _areaId, _zombieId);
181   }
182 
183   function awardInvation(bytes32 _teamId) public {
184     require(teams[_teamId].Owner == msg.sender);
185     require(now >= teams[_teamId].awardTime);
186     require(!teams[_teamId].isCharge);
187     uint totalUndeadsTime;
188     uint totalStar;
189     uint dieNumber;
190 
191     uint[] memory zb =  teams[_teamId].Zombies;
192 
193     for(i=0;i<zb.length;i++){
194         totalUndeadsTime += zombies[zb[i]].undeadsTime;
195         totalStar += zombiemain.seeZombieStar(zb[i]);
196     }
197 
198     if(totalStar<areas[teams[_teamId].areaID].starLimit){
199         dieNumber = totalStar*9500/(areas[teams[_teamId].areaID].starLimit)+totalUndeadsTime*10;
200     }else{
201         dieNumber = totalStar*100/(areas[teams[_teamId].areaID].starLimit)+9500+totalUndeadsTime;
202     }
203 
204     if(dieNumber <= uint(keccak256(teams[_teamId].teamHash, now, block.blockhash(block.number-1),block.blockhash(teams[_teamId].blocknumber))) % 10000) {
205       //Lose
206       for(uint16 i = 0; i<zb.length; i++){
207         zombies[zb[ii]].readyTime = uint32(now + 7 days);
208         zombies[zb[ii]].undeadsTime = 0;
209         zombies[zb[ii]].notAtHome = false;
210       }
211       AwardInvation(_teamId, false, 0);
212     } else {
213       //Win
214       for(uint16 ii = 0; ii<zb.length; ii++){
215         zombies[zb[ii]].undeadsTime ++;
216         zombies[zb[ii]].notAtHome = false;
217       }
218       zombietoken.mint(teams[_teamId].Owner, areas[teams[_teamId].areaID].ZOBRevenue);
219       AwardInvation(_teamId, true, areas[teams[_teamId].areaID].ZOBRevenue);
220     }
221 
222     teams[_teamId].isCharge = true;
223     areas[teams[_teamId].areaID].TotalTeamCount --;
224   }
225 
226   function addArea(uint starLimit,uint8 TeamMemberlimitCount,uint8[] roletype,uint _totallimitTeamCount,string name,uint ZOBRevenue,bool isOpen,uint32 duration) public onlyOwner{
227       areas.push(Area(starLimit, TeamMemberlimitCount, roletype, _totallimitTeamCount, 0, name, ZOBRevenue, isOpen, duration));
228   }
229   
230   function closeArea(uint areaId) public onlyOwner{
231       areas[areaId].isOpen = false;
232   }
233 
234 }