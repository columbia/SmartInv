1 pragma solidity ^0.4.19;
2 
3 contract ERC721 {
4   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
5   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
6 
7   function balanceOf(address _owner) public view returns (uint256 _balance);
8   function ownerOf(uint256 _tokenId) public view returns (address _owner);
9   function transfer(address _to, uint256 _tokenId) public;
10   function approve(address _to, uint256 _tokenId) public;
11   function takeOwnership(uint256 _tokenId) public;
12 }
13 
14 pragma solidity ^0.4.18;
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     if (a == 0) {
27       return 0;
28     }
29     uint256 c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   /**
45   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 /**
63  * @title Ownable
64  * @dev The Ownable contract has an owner address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 contract Ownable {
68   address public owner;
69 
70   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72   /**
73    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
74    * account.
75    */
76   function Ownable() public {
77     owner = msg.sender;
78   }
79 
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89 
90   /**
91    * @dev Allows the current owner to transfer control of the contract to a newOwner.
92    * @param newOwner The address to transfer ownership to.
93    */
94   function transferOwnership(address newOwner) public onlyOwner {
95     require(newOwner != address(0));
96     OwnershipTransferred(owner, newOwner);
97     owner = newOwner;
98   }
99 
100 }
101 
102 
103 
104 contract zombieMain is  ERC721,Ownable {
105 
106   using SafeMath for uint256;
107 
108   struct Zombie {
109     bytes32 dna;
110     uint8 star;
111     uint16 roletype;
112     bool isFreeZombie;
113   }
114 
115   Zombie[] public zombies;
116   
117   address public ZombiewCreator;
118 
119   mapping (uint => address) public zombieToOwner;
120   mapping (address => uint) ownerZombieCount;
121   mapping (uint => address) zombieApprovals;
122 
123   event Transfer(address _from, address _to,uint _tokenId);
124   event Approval(address _from, address _to,uint _tokenId);
125   event Take(address _to, address _from,uint _tokenId);
126   event Create(uint _tokenId, bytes32 dna,uint8 star, uint16 roletype);
127 
128   function balanceOf(address _owner) public view returns (uint256 _balance) {
129     return ownerZombieCount[_owner];
130   }
131 
132   function ownerOf(uint256 _tokenId) public view returns (address _owner) {
133     return zombieToOwner[_tokenId];
134   }
135 
136   function checkAllOwner(uint256[] _tokenId, address owner) public view returns (bool) {
137     for(uint i=0;i<_tokenId.length;i++){
138         if(owner != zombieToOwner[_tokenId[i]]){
139             return false;
140         }
141     }
142     
143     return true;
144   }
145 
146   function seeZombieDna(uint256 _tokenId) public view returns (bytes32 dna) {
147     return zombies[_tokenId].dna;
148   }
149 
150   function seeZombieStar(uint256 _tokenId) public view returns (uint8 star) {
151     return zombies[_tokenId].star;
152   }
153   
154   function seeZombieRole(uint256 _tokenId) public view returns (uint16 roletype) {
155     return zombies[_tokenId].roletype;
156   }
157 
158   function getZombiesByOwner(address _owner) external view returns(uint[]) {
159     uint[] memory result = new uint[](ownerZombieCount[_owner]);
160     uint counter = 0;
161     for (uint i = 0; i < zombies.length; i++) {
162       if (zombieToOwner[i] == _owner) {
163         result[counter] = i;
164         counter++;
165       }
166     }
167     return result;
168   }
169 
170   function transfer(address _to, uint256 _tokenId) public {
171     require(zombieToOwner[_tokenId] == msg.sender);
172     require(!zombies[_tokenId].isFreeZombie);
173     
174     ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
175     ownerZombieCount[msg.sender] =  ownerZombieCount[msg.sender].sub(1);
176     zombieToOwner[_tokenId] = _to;
177     
178     Transfer(msg.sender, _to, _tokenId);
179   }
180 
181   function approve(address _to, uint256 _tokenId) public {
182     require(zombieToOwner[_tokenId] == msg.sender);
183     require(!zombies[_tokenId].isFreeZombie);
184     
185     zombieApprovals[_tokenId] = _to;
186     
187     Approval(msg.sender, _to, _tokenId);
188   }
189 
190   function takeOwnership(uint256 _tokenId) public {
191     require(zombieApprovals[_tokenId] == msg.sender);
192     require(!zombies[_tokenId].isFreeZombie);
193     
194     address owner = ownerOf(_tokenId);
195 
196     ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
197     ownerZombieCount[owner] = ownerZombieCount[owner].sub(1);
198     zombieToOwner[_tokenId] = msg.sender;
199     
200     Take(msg.sender, owner, _tokenId);
201   }
202   
203   function createZombie(uint8 star,bytes32 dna,uint16 roletype,bool isFreeZombie,address player) public {
204       require(msg.sender == ZombiewCreator); // only creator can call
205  
206       uint id = zombies.push(Zombie(dna, star, roletype, isFreeZombie)) - 1;
207       zombieToOwner[id] = player;
208       ownerZombieCount[player]++;
209       
210       Create(id, dna, star, roletype);
211   }
212   
213   function changeZombieCreator(address _zombiewCreator) public onlyOwner{
214     ZombiewCreator = _zombiewCreator;
215   }
216 
217   function getZombiesFullInfoByOwner(address _owner) external view returns(uint[] id,bytes32[] dna, uint8[] star,uint16[] roletype,bool[] isFreeZombie) {
218    uint[]  memory idb = new uint[](ownerZombieCount[_owner]);
219    bytes32[]  memory dnab = new bytes32[](ownerZombieCount[_owner]);
220    uint8[]  memory starb = new uint8[](ownerZombieCount[_owner]);
221    uint16[]  memory roletypeb = new uint16[](ownerZombieCount[_owner]);
222    bool[]  memory isFreeZombieb = new bool[](ownerZombieCount[_owner]);
223    uint counter = 0;
224    for (uint i = 0; i < zombies.length; i++) {
225      if (zombieToOwner[i] == _owner) {
226        idb[counter] = i;
227        dnab[counter] = zombies[i].dna;
228        starb[counter] = zombies[i].star;
229        roletypeb[counter] = zombies[i].roletype;
230        isFreeZombieb[counter] = zombies[i].isFreeZombie;
231        counter++;
232      }
233    }
234    return (idb,dnab,starb,roletypeb,isFreeZombieb);
235   }
236 }