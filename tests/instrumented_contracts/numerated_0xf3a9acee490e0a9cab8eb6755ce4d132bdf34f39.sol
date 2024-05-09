1 pragma solidity ^0.4.23;
2 /*
3 * giff
4 * giff
5 * giff
6 * giff
7 * giff
8 * giff
9 * giff
10 * giff
11 * giff
12 *
13 * Author:  Konstantin G...
14 * Telegram: @bunnygame (en)
15 * talk : https://bitcointalk.org/index.php?topic=5025885.0
16 * discord : https://discordapp.com/invite/G2jt4Fw
17 * email: info@bunnycoin.co
18 * site : http://bunnycoin.co 
19 */
20 contract Ownable {
21     address owner;        
22     constructor() public {
23         owner = msg.sender; 
24     }
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29     function transferOwner(address _add) public onlyOwner {
30         if (_add != address(0)) {
31             owner = _add;
32         }
33     }  
34 }
35  
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that throw on error
39  */
40 library SafeMath {
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint c = a * b;
47         assert(c / a == b);
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // assert(b > 0); // Solidity automatically throws when dividing by 0
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55         return c;
56     }
57 
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         assert(b <= a);
60         return a - b;
61     }
62 
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         assert(c >= a);
66         return c;
67     }
68   
69 }
70 
71 
72 contract PublicInterface { 
73     function transferFrom(address _from, address _to, uint32 _tokenId) public returns (bool);
74     function ownerOf(uint32 _tokenId) public view returns (address owner);
75     function isUIntPublic() public view returns(bool);
76     //function setAllowedChangeSex( uint32 _bunny, bool canBunny) public;
77     //function ownerOf(uint32 _tokenId) public view returns (address owner);
78 
79     function getAllowedChangeSex(uint32 _bunny) public view returns(bool);
80     function getBirthCount(uint32 _bunny) public view returns(uint);
81     function getBirthLastTime(uint32 _bunny) public view returns(uint);
82     function getRabbitSirePrice(uint32 _bunny) public view returns(uint);
83     function setAllowedChangeSex( uint32 _bunny, bool canBunny) public;
84     function setRabbitSirePrice( uint32 _bunny, uint count) external;
85 }
86 
87 contract Gift  is Ownable { 
88     event SendGift(address from, address to, uint32 bunnyId);
89     event ChengeSex(uint32 bunnyId, bool sex, uint256 price);
90 
91 
92 
93     using SafeMath for uint256;
94 
95     uint256 bigPrice = 0.003 ether;
96     function setBigPrice(uint _bigPrice) public onlyOwner() {
97         bigPrice = _bigPrice;
98     }
99     uint32[12] public cooldowns = [
100         uint32(1 minutes),
101         uint32(2 minutes),
102         uint32(4 minutes),
103         uint32(8 minutes),
104         uint32(16 minutes),
105         uint32(32 minutes),
106         uint32(1 hours),
107         uint32(2 hours),
108         uint32(4 hours),
109         uint32(8 hours),
110         uint32(16 hours),
111         uint32(1 days)
112     ];
113 
114 
115     bool public pause = false; 
116     uint public totalGift = 0; 
117     uint public lastGiftTime = 0; 
118   
119     uint public commission_system = 5;
120     
121     address public lastGift; 
122     address public pubAddress; 
123 
124     PublicInterface publicContract; 
125  
126     constructor() public { 
127         transferContract(0x2Ed020b084F7a58Ce7AC5d86496dC4ef48413a24);
128     }
129     function transferContract(address _pubAddress) public onlyOwner {
130         require(_pubAddress != address(0)); 
131         pubAddress = _pubAddress;
132         publicContract = PublicInterface(_pubAddress);
133     } 
134     function setPause() public onlyOwner {
135         pause = !pause;
136     }
137     function isPauseSave() public  view returns(bool){
138         return !pause;
139     } 
140      
141     function getSirePrice(uint32 _tokenId) public view returns(uint) {
142         if(publicContract.getRabbitSirePrice(_tokenId) != 0){
143             uint procent = (publicContract.getRabbitSirePrice(_tokenId) / 100);
144             uint res = procent.mul(25);
145             uint system  = procent.mul(commission_system);
146             res = res.add( publicContract.getRabbitSirePrice(_tokenId));
147             return res.add(system); 
148         } else {
149             return 0;
150         }
151 
152     }
153 
154 
155 
156 
157     
158     function setRabbitSirePrice(uint32 _rabbitid, uint price) public {
159         require(isPauseSave());
160         require(publicContract.ownerOf(_rabbitid) == msg.sender);
161         require(price > bigPrice);
162         require(publicContract.getAllowedChangeSex(_rabbitid));
163         require(publicContract.getRabbitSirePrice(_rabbitid) != price);
164         uint lastTime;
165         (lastTime,,) = getcoolduwn(_rabbitid);
166         require(now >= lastTime);
167         publicContract.setRabbitSirePrice(_rabbitid, price);
168         emit ChengeSex(_rabbitid, true, getSirePrice(_rabbitid));
169 
170     }
171     function setSireStop(uint32 _rabbitid) public returns(bool) {
172         require(isPauseSave());
173         require(publicContract.getRabbitSirePrice(_rabbitid) !=0);
174 
175         require(publicContract.ownerOf(_rabbitid) == msg.sender);
176      //   require(rabbits[(_rabbitid-1)].role == 0);
177         publicContract.setRabbitSirePrice( _rabbitid, 0);
178      //   deleteSire(_rabbitid);
179         emit ChengeSex(_rabbitid, false, 0);
180         return true;
181     }
182 
183 
184 
185     function sendGift(uint32 _bunnyId, address _to) public {
186         require(isPauseSave());
187         require(checkContract());
188         require(ownerOf(_bunnyId) == msg.sender);
189         require(_to != address(0)); 
190         publicContract.transferFrom(msg.sender, _to, _bunnyId); 
191         publicContract.setAllowedChangeSex( _bunnyId, true);
192         lastGift = msg.sender; 
193         totalGift = totalGift + 1;
194         lastGiftTime = block.timestamp;
195         emit SendGift(msg.sender, _to, _bunnyId);
196     }  
197 
198 
199 
200     function ownerOf(uint32 _bunnyId) public  view returns(address) {
201         return publicContract.ownerOf(_bunnyId);
202     } 
203     function checkContract() public view returns(bool) {
204         return publicContract.isUIntPublic(); 
205     }
206     function isUIntPublic() public view returns(bool) {
207         require(isPauseSave());
208         return true;
209     }
210     /**
211      *  we get cooldown
212      */
213     function getcoolduwn(uint32 _mother) public view returns(uint lastTime, uint cd, uint lefttime) {
214         cd = publicContract.getBirthCount(_mother);
215         if(cd > 11) {
216             cd = 11;
217         }
218         // time when I can give birth
219         lastTime = (cooldowns[cd] + publicContract.getBirthLastTime(_mother));
220         if(lastTime > now) {
221             // I can not give birth, it remains until delivery
222             lefttime = lastTime.sub(now);
223         }
224     }
225 }