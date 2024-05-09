1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 pragma solidity ^0.4.18;
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 contract zombieToken {
93   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
94   function transfer(address to, uint tokens) public returns (bool success);
95   function buyCard(address from, uint256 value) public returns (bool success);
96 }
97 
98 contract zombieMain {
99   function createZombie(uint8 star,bytes32 dna,uint16 roletype,bool isFreeZombie,address player) public;
100 }
101 
102 contract zombieCreator is Ownable {
103 
104   using SafeMath for uint256;
105 
106   event NewZombie(bytes32 dna, uint8 star,uint16 roletype, bool isfree);
107 
108   mapping (address => bool) isGetFreeZombie;
109 
110   uint createRandomZombie_EtherPrice = 0.01 ether;
111   uint createRandomZombie_ZOBToken_smallpack = 100 * 10 ** 18;
112   uint createRandomZombie_ZOBToken_goldpack = 400 * 10 ** 18;
113   
114   zombieMain c = zombieMain(0x58fd762F76D57C6fC2a480F6d26c1D03175AD64F);
115   zombieToken t = zombieToken(0x2Bb48FE71ba5f73Ab1c2B9775cfe638400110d34);
116   
117   uint public FreeZombieCount = 999999;
118 
119   function isGetFreeZombiew(address _owner) public view returns (bool _getFreeZombie) {
120     return isGetFreeZombie[_owner];
121   }
122 
123   function createRandomZombie_ZOB_smallpack() public {
124 
125     require(t.buyCard(msg.sender, createRandomZombie_ZOBToken_smallpack));
126     
127     for(uint8 i = 0;i<3;i++){
128        
129        bytes32 dna;
130 
131        if(i == 0){
132          dna = keccak256(block.blockhash(block.number-1), block.difficulty, block.coinbase, now, msg.sender, "CryptoDeads DNA Seed");
133        } else if(i == 1){
134          dna = keccak256(msg.sender, now, block.blockhash(block.number-1), "CryptoDeads DNA Seed", block.coinbase, block.difficulty);
135        } else {
136          dna = keccak256("CryptoDeads DNA Seed", now, block.difficulty, block.coinbase, block.blockhash(block.number-1), msg.sender);
137        }
138 
139        uint star = uint(dna) % 1000 +1;
140        uint roletype = 1;
141 
142        if(star<=700){
143             star = 1;
144             roletype = uint(keccak256(msg.sender ,block.blockhash(block.number-1), block.coinbase, now, block.difficulty)) % 3 + 1;
145        }else if(star <= 980){
146             star = 2;
147             roletype = 4;
148        }else{
149             star = 3;
150             roletype = uint(keccak256(block.blockhash(block.number-1), msg.sender, block.difficulty, block.coinbase, now)) % 3 + 5; 
151        }
152 
153        c.createZombie(uint8(star),dna,uint16(roletype),false,msg.sender);
154        NewZombie(dna,uint8(star),uint16(roletype),false);
155     }
156   }
157 
158   function createRandomZombie_ZOB_goldpack() public {
159 
160     require(t.buyCard(msg.sender, createRandomZombie_ZOBToken_goldpack));
161     
162     for(uint8 i = 0;i<3;i++){
163 
164        bytes32 dna;
165        
166        if(i == 0){
167          dna = keccak256(block.blockhash(block.number-1), block.difficulty, block.coinbase, now, msg.sender, "CryptoDeads DNA Seed");
168        } else if(i == 1){
169          dna = keccak256(msg.sender, now, block.blockhash(block.number-1), "CryptoDeads DNA Seed", block.coinbase, block.difficulty);
170        } else {
171          dna = keccak256("CryptoDeads DNA Seed", now, block.difficulty, block.coinbase, block.blockhash(block.number-1), msg.sender);
172        }
173 
174        uint star = uint(dna) % 1000 +1;
175        uint roletype = 2;
176 
177        if(star<=700){
178             star = 2;
179             roletype = 4;
180        }else if(star <= 950){
181             star = 3;
182             roletype = uint(keccak256(msg.sender ,block.blockhash(block.number-1), block.coinbase, now, block.difficulty)) % 3 + 5;
183        }else{
184             star = 4;
185             roletype = uint(keccak256(block.blockhash(block.number-1), msg.sender, block.difficulty, block.coinbase, now)) % 3 + 9;
186        }
187 
188        c.createZombie(uint8(star),dna,uint16(roletype),false,msg.sender);
189        NewZombie(dna,uint8(star),uint16(roletype),false);
190     }
191   }
192 
193   function createRandomZombie_FreeZombie() public {
194     require(!isGetFreeZombie[msg.sender]);
195     require(FreeZombieCount>=1);
196 
197     uint ran = uint(keccak256(block.coinbase,block.difficulty,now, block.blockhash(block.number-1))) % 100 + 1;
198 
199     uint roletype = 1;
200     uint8 star = 1;
201 
202     if(ran>=90){
203       roletype = 4;
204       star = 2;
205     } else {
206       roletype = uint(keccak256(msg.sender ,block.blockhash(block.number-1), block.coinbase, now, block.difficulty)) % 3 + 1;
207     }
208     
209     bytes32 dna = keccak256(block.blockhash(block.number-1), block.difficulty, block.coinbase, now, msg.sender, "CryptoDeads DNA Seed");
210     
211     c.createZombie(star,dna,uint16(roletype),true,msg.sender);
212     isGetFreeZombie[msg.sender] = true;
213     FreeZombieCount--;
214 
215     NewZombie(dna,uint8(star),uint16(roletype),true);
216   }
217   
218   function createRandomZombie_Ether() public payable{
219     require(msg.value == createRandomZombie_EtherPrice);
220     
221     for(uint8 i = 0;i<3;i++){
222        bytes32 dna;
223        
224        if(i == 0){
225          dna = keccak256(block.blockhash(block.number-1), block.difficulty, block.coinbase, now, msg.sender, "CryptoDeads DNA Seed");
226        } else if(i == 1){
227          dna = keccak256(msg.sender, now, block.blockhash(block.number-1), "CryptoDeads DNA Seed", block.coinbase, block.difficulty);
228        } else {
229          dna = keccak256("CryptoDeads DNA Seed", now, block.difficulty, block.coinbase, block.blockhash(block.number-1), msg.sender);
230        }
231 
232        uint star = uint(dna) % 1000 + 1;
233        uint roletype = 4;
234 
235        if(star<=500){
236             star = 2;
237        }else if(star <= 850){
238             star = 3;
239             roletype = uint(keccak256(msg.sender ,block.blockhash(block.number-1), block.coinbase, now, block.difficulty)) % 4 + 5;
240        }else{
241             star = 4;
242             roletype = uint(keccak256(block.blockhash(block.number-1), msg.sender, block.difficulty, block.coinbase, now)) % 4 + 9;
243        } 
244 
245        c.createZombie(uint8(star),dna,uint16(roletype),false,msg.sender);
246        
247        NewZombie(dna,uint8(star),uint16(roletype),true);
248     }
249   }
250   
251   function changeFreeZombiewCount(uint16 _count) public onlyOwner {
252       FreeZombieCount = _count;
253   }
254   
255   function withdrawEther(uint _ether) public onlyOwner{
256       msg.sender.transfer(_ether);
257   }
258 
259   function withdrawZOB(uint _zob) public onlyOwner{
260       t.transfer(msg.sender, _zob);
261   }
262 }