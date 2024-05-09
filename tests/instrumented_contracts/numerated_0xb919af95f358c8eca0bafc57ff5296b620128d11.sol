1 // KpopArena lets users play with their Kpop cards against other
2 // players on Kpop.io
3 
4 pragma solidity ^0.4.18;
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   /**
35   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 contract ERC721 {
53   function approve(address _to, uint _itemId) public;
54   function balanceOf(address _owner) public view returns (uint balance);
55   function implementsERC721() public pure returns (bool);
56   function ownerOf(uint _itemId) public view returns (address addr);
57   function takeOwnership(uint _itemId) public;
58   function totalSupply() public view returns (uint total);
59   function transferFrom(address _from, address _to, uint _itemId) public;
60   function transfer(address _to, uint _itemId) public;
61 
62   event Transfer(address indexed from, address indexed to, uint itemId);
63   event Approval(address indexed owner, address indexed approved, uint itemId);
64 }
65 
66 contract KpopCeleb is ERC721 {
67   function ownerOf(uint _celebId) public view returns (address addr);
68   function getCeleb(uint _celebId) public view returns (
69     string name,
70     uint price,
71     address owner,
72     uint[6] traitValues,
73     uint[6] traitBoosters
74   );
75   function updateTraits(uint _celebId) public;
76 }
77 
78 contract KpopItem is ERC721 {
79   function ownerOf(uint _itemId) public view returns (address addr);
80   function getItem(uint _itemId) public view returns (
81     string name,
82     uint price,
83     address owner,
84     uint[6] traitValues,
85     uint celebId
86   );
87   function transferToWinner(address _winner, address _loser, uint _itemId) public;
88 }
89 
90 contract KpopArena {
91   using SafeMath for uint;
92 
93   address public author;
94   address public coauthor;
95 
96   string public constant NAME = "KpopArena";
97   string public constant SYMBOL = "KpopArena";
98 
99   address public KPOP_CELEB_CONTRACT_ADDRESS = 0x0;
100   address public KPOP_ITEM_CONTRACT_ADDRESS = 0x0;
101 
102   mapping(address => bool) public userToIsAcceptingChallenge;
103   mapping(address => uint) private userToActiveCelebId;
104   mapping(address => uint) private userToActiveItemId;
105   mapping(address => uint) public userToScore;
106 
107   event Enroll(address indexed user, uint celebId, uint itemId);
108   event Expel(address indexed user);
109   event Rescind(address indexed user);
110   event FightOver(
111     address indexed host,
112     address indexed challenger,
113     address indexed winner,
114     uint challengerCelebId,
115     uint challengerItemId,
116     string selectedTrait
117   );
118 
119   function KpopArena() public {
120     author = msg.sender;
121     coauthor = msg.sender;
122   }
123 
124   function enroll(uint _celebId, uint _itemId) public {
125     // User can only enroll once at a time
126     require(!userToIsAcceptingChallenge[msg.sender]);
127 
128     // Use must own the celeb and items
129     require(doesUserOwnItem(msg.sender, _itemId));
130     require(doesUserOwnCeleb(msg.sender, _celebId));
131 
132     userToIsAcceptingChallenge[msg.sender] = true;
133     userToActiveCelebId[msg.sender] = _celebId;
134     userToActiveItemId[msg.sender] = _itemId;
135 
136     Enroll(msg.sender, _celebId, _itemId);
137   }
138 
139   function rescind(address _user) public {
140     require(_user == msg.sender || _user == author || _user == coauthor);
141 
142     userToIsAcceptingChallenge[_user] = false;
143     Rescind(_user);
144   }
145 
146   function challenge(address _host, uint _celebId, uint _itemId) public {
147     address _challenger = msg.sender;
148 
149     require(!isNullAddress(_host) && !isNullAddress(_challenger));
150     require(_host != _challenger);
151     require(userToIsAcceptingChallenge[_host]);
152     require(doesUserOwnCeleb(_challenger, _celebId));
153     require(doesUserOwnItem(_challenger, _itemId));
154 
155     uint _hostCelebId = userToActiveCelebId[_host];
156     uint _hostItemId = userToActiveItemId[_host];
157 
158     // Expel user who doesn't own their celeb or items anymore
159     if (!(doesUserOwnCeleb(_host, _hostCelebId) && doesUserOwnItem(_host, _hostItemId))) {
160       userToIsAcceptingChallenge[_host] = false;
161       Expel(_host);
162       return;
163     }
164 
165     // Get winner
166     uint selectedTraitIdx = selectRandomTrait();
167     address winner = computeWinner(
168       _host, _hostCelebId, _hostItemId,
169       _challenger, _celebId, _itemId,
170       selectedTraitIdx
171     );
172 
173     // Assign scores
174     if (winner != 0x0) {
175       userToScore[winner] = userToScore[winner].add(3);
176 
177       // Level up celeb and give winner the item card
178       KpopCeleb KPOP_CELEB = KpopCeleb(KPOP_CELEB_CONTRACT_ADDRESS);
179       KpopItem KPOP_ITEM = KpopItem(KPOP_ITEM_CONTRACT_ADDRESS);
180 
181       if (winner == _host) {
182         KPOP_CELEB.updateTraits(_hostCelebId);
183         KPOP_ITEM.transferToWinner(_host, _challenger, _itemId);
184       } else {
185         KPOP_CELEB.updateTraits(_celebId);
186         KPOP_ITEM.transferToWinner(_challenger, _host, _hostItemId);
187       }
188     } else {
189       userToScore[_host] = userToScore[_host].add(1);
190       userToScore[_challenger] = userToScore[_challenger].add(1);
191     }
192 
193     // Duel is over. Host must opt into the arena again if they wish to get more challenges
194     userToIsAcceptingChallenge[_host] = false;
195     delete userToActiveCelebId[_host];
196     delete userToActiveItemId[_host];
197 
198     FightOver(
199       _host,
200       _challenger,
201       winner,
202       _celebId,
203       _itemId,
204       traitIdxToName(selectedTraitIdx)
205     );
206   }
207 
208   // _a wins if score > 0 and _b wins if score < 0. Otherwise, draw.
209   function computeWinner(
210     address _host, uint _hostCelebId, uint _hostItemId,
211     address _challenger, uint _challengerCelebId, uint _challengerItemId,
212     uint _selectedTraitIdx
213   ) private view returns(address winner)
214   {
215     uint hostTraitScore = computeTraitScore(_hostCelebId, _hostItemId, _selectedTraitIdx);
216     uint challengerTraitScore = computeTraitScore(_challengerCelebId, _challengerItemId, _selectedTraitIdx);
217 
218     if (hostTraitScore > challengerTraitScore) {
219       return _host;
220     }
221 
222     if (hostTraitScore < challengerTraitScore) {
223       return _challenger;
224     }
225 
226     return 0x0;
227   }
228 
229   function computeTraitScore(uint _celebId, uint _itemId, uint _selectedTraitIdx) private view returns (uint) {
230     KpopCeleb KPOP_CELEB = KpopCeleb(KPOP_CELEB_CONTRACT_ADDRESS);
231     KpopItem KPOP_ITEM = KpopItem(KPOP_ITEM_CONTRACT_ADDRESS);
232 
233     var ( , , ,celebTraits, ) = KPOP_CELEB.getCeleb(_celebId);
234     var ( , , ,itemTraits, ) = KPOP_ITEM.getItem(_itemId);
235 
236     return celebTraits[_selectedTraitIdx] + itemTraits[_selectedTraitIdx];
237   }
238 
239   function selectRandomTrait() private view returns (uint) {
240     return uint(block.blockhash(block.number - 1)) % 6;
241   }
242 
243   function withdraw(uint _amount, address _to) public onlyAuthors {
244     require(!isNullAddress(_to));
245     require(_amount <= this.balance);
246 
247     _to.transfer(_amount);
248   }
249 
250   function withdrawAll() public onlyAuthors {
251     require(author != 0x0);
252     require(coauthor != 0x0);
253 
254     uint halfBalance = uint(SafeMath.div(this.balance, 2));
255 
256     author.transfer(halfBalance);
257     coauthor.transfer(halfBalance);
258   }
259 
260   function doesUserOwnCeleb(address _user, uint _celebId) private view returns (bool) {
261     KpopCeleb KPOP_CELEB = KpopCeleb(KPOP_CELEB_CONTRACT_ADDRESS);
262 
263     return KPOP_CELEB.ownerOf(_celebId) == _user;
264   }
265 
266   function doesUserOwnItem(address _user, uint _itemId) private view returns (bool) {
267     KpopItem KPOP_ITEM = KpopItem(KPOP_ITEM_CONTRACT_ADDRESS);
268 
269     return KPOP_ITEM.ownerOf(_itemId) == _user;
270   }
271 
272   function setCoAuthor(address _coauthor) public onlyAuthor {
273     require(!isNullAddress(_coauthor));
274 
275     coauthor = _coauthor;
276   }
277 
278   function setKpopItemContractAddress(address _address) public onlyAuthors {
279     KPOP_ITEM_CONTRACT_ADDRESS = _address;
280   }
281 
282   function setKpopCelebContractAddress(address _address) public onlyAuthors {
283     KPOP_CELEB_CONTRACT_ADDRESS = _address;
284   }
285 
286   function traitIdxToName(uint _idx) public pure returns (string) {
287     if (_idx == 0) {
288       return "rap";
289     }
290     if (_idx == 1) {
291       return "vocal";
292     }
293     if (_idx == 2) {
294       return "dance";
295     }
296     if (_idx == 3) {
297       return "charm";
298     }
299     if (_idx == 4) {
300       return "acting";
301     }
302     if (_idx == 5) {
303       return "producing";
304     }
305   }
306 
307   /** MODIFIERS **/
308 
309   modifier onlyAuthor() {
310     require(msg.sender == author);
311     _;
312   }
313 
314   modifier onlyAuthors() {
315     require(msg.sender == author || msg.sender == coauthor);
316     _;
317   }
318 
319   function isNullAddress(address _addr) private pure returns (bool) {
320     return _addr == 0x0;
321   }
322 }