1 pragma solidity ^0.4.21;
2 contract ERC721 {
3   // Required methods
4   function approve(address _to, uint256 _tokenId) public;
5   function balanceOf(address _owner) public view returns (uint256 balance);
6   function implementsERC721() public pure returns (bool);
7   function ownerOf(uint256 _tokenId) public view returns (address addr);
8   function takeOwnership(uint256 _tokenId) public;
9   function totalSupply() public view returns (uint256 total);
10   function transferFrom(address _from, address _to, uint256 _tokenId) public;
11   function transfer(address _to, uint256 _tokenId) public;
12   event Transfer(address indexed from, address indexed to, uint256 tokenId);
13   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
14   // Optional
15   // function name() public view returns (string name);
16   // function symbol() public view returns (string symbol);
17   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
18   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
19 }
20 contract WorldCupToken is ERC721 {
21   event Birth(uint256 tokenId, string name, address owner);
22   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
23   event Transfer(address from, address to, uint256 tokenId);
24  
25   /*** CONSTANTS ***/
26   string public constant NAME = "WorldCupToken";
27   string public constant SYMBOL = "WorldCupToken";
28   uint256 private startingPrice = 0.1 ether;
29   mapping (uint256 => address) private teamIndexToOwner;
30   mapping (address => uint256) private ownershipTokenCount;
31   mapping (uint256 => address) private teamIndexToApproved;
32   mapping (uint256 => uint256) private teamIndexToPrice;
33   mapping (string => uint256) private nameIndexToTeam;   // eg: Egypt => 0
34   mapping (string => string) private teamIndexToName;    // eg: 0 => Egypt
35   
36   
37   address private ceoAddress;
38   bool private isStop;
39   
40   struct Team {
41     string name;
42   }
43   Team[] private teams;
44   
45   modifier onlyCEO() {
46     require(msg.sender == ceoAddress);
47     _;
48   }
49   modifier onlyStart() {
50     require(isStop == false);
51     _;
52   }
53   
54    function setStop() public onlyCEO {
55     
56     isStop = true;
57   }
58   function setStart() public onlyCEO {
59     
60     isStop = false;
61   }
62   
63   /*** CONSTRUCTOR ***/
64   function WorldCupToken() public {
65     ceoAddress = msg.sender;
66     isStop=false;
67     _createTeam("Egypt", msg.sender, startingPrice);
68     teamIndexToName["0"]="Egypt";
69     
70     _createTeam("Morocco", msg.sender, startingPrice);
71     teamIndexToName["1"]="Morocco";
72     
73     _createTeam("Nigeria", msg.sender, startingPrice);
74     teamIndexToName["2"]="Nigeria";
75     
76     _createTeam("Senegal", msg.sender, startingPrice);
77     teamIndexToName["3"]="Senegal";
78     
79     _createTeam("Tunisia", msg.sender, startingPrice);
80     teamIndexToName["4"]="Tunisia";
81     
82     _createTeam("Australia", msg.sender, startingPrice);
83     teamIndexToName["5"]="Australia";
84     
85     _createTeam("IR Iran", msg.sender, startingPrice);
86     teamIndexToName["6"]="IR Iran";
87     
88     _createTeam("Japan", msg.sender, startingPrice);
89    teamIndexToName["7"]="Japan";
90     
91     _createTeam("Korea Republic", msg.sender, startingPrice);
92    teamIndexToName["8"]="Korea Republic";
93     
94     _createTeam("Saudi Arabia", msg.sender, startingPrice);
95     teamIndexToName["9"]="Saudi Arabia";
96     
97     _createTeam("Belgium", msg.sender, startingPrice);
98     teamIndexToName["10"]="Belgium";
99     
100     _createTeam("Croatia", msg.sender, startingPrice);
101     teamIndexToName["11"]="Croatia";
102     
103     
104     _createTeam("Denmark", msg.sender, startingPrice);
105     teamIndexToName["12"]="Denmark";
106     
107     
108     _createTeam("England", msg.sender, startingPrice);
109     teamIndexToName["13"]="England";
110     
111     
112     _createTeam("France", msg.sender, startingPrice);
113     teamIndexToName["14"]="France";
114     
115     
116     _createTeam("Germany", msg.sender, startingPrice);
117     teamIndexToName["15"]="Germany";
118     
119     
120     _createTeam("Iceland", msg.sender, startingPrice);
121     teamIndexToName["16"]="Iceland";
122     
123     
124     _createTeam("Poland", msg.sender, startingPrice);
125     teamIndexToName["17"]="Poland";
126     
127     
128     _createTeam("Portugal", msg.sender, startingPrice);
129     teamIndexToName["18"]="Portugal";
130     
131     
132     _createTeam("Russia", msg.sender, startingPrice);
133     teamIndexToName["19"]="Russia";
134     
135     
136     _createTeam("Serbia", msg.sender, startingPrice);
137     teamIndexToName["20"]="Serbia";
138     
139     
140     _createTeam("Spain", msg.sender, startingPrice);
141     teamIndexToName["21"]="Spain";
142     
143     
144     _createTeam("Sweden", msg.sender, startingPrice);
145     teamIndexToName["22"]="Sweden";
146     
147     
148     _createTeam("Switzerland", msg.sender, startingPrice);
149     teamIndexToName["23"]="Switzerland";
150     
151     
152     _createTeam("Costa Rica", msg.sender, startingPrice);
153     teamIndexToName["24"]="Costa Rica";
154     
155     
156     _createTeam("Mexico", msg.sender, startingPrice);
157     teamIndexToName["25"]="Mexico";
158     
159     
160     
161     _createTeam("Panama", msg.sender, startingPrice);
162     teamIndexToName["26"]="Panama";
163     
164     
165     _createTeam("Argentina", msg.sender, startingPrice);
166     teamIndexToName["27"]="Argentina";
167     
168     _createTeam("Brazil", msg.sender, startingPrice);
169     teamIndexToName["28"]="Brazil";
170     
171     _createTeam("Colombia", msg.sender, startingPrice);
172     teamIndexToName["29"]="Colombia";
173     
174     _createTeam("Peru", msg.sender, startingPrice);
175     teamIndexToName["30"]="Peru";
176     
177     _createTeam("Uruguay", msg.sender, startingPrice);
178     teamIndexToName["31"]="Uruguay";
179       
180   }
181   
182   function approve(
183     address _to,
184     uint256 _tokenId
185   ) public  onlyStart {
186     require(_owns(msg.sender, _tokenId));
187     teamIndexToApproved[_tokenId] = _to;
188     Approval(msg.sender, _to, _tokenId);
189   }
190   function balanceOf(address _owner) public view returns (uint256 balance) {
191     return ownershipTokenCount[_owner];
192   }
193   
194    function getTeamId(string _name) public view returns (uint256 id) {
195     return nameIndexToTeam[_name];
196   }
197   
198   function getTeam(uint256 _tokenId) public view returns (
199     string teamName,
200     uint256 sellingPrice,
201     address owner
202   ) {
203     Team storage team = teams[_tokenId];
204     teamName = team.name;
205     sellingPrice = teamIndexToPrice[_tokenId];
206     owner = teamIndexToOwner[_tokenId];
207   }
208   
209   function getTeam4name(string _name) public view returns (
210     string teamName,
211     uint256 sellingPrice,
212     address owner
213   ) {
214     uint256 _tokenId = nameIndexToTeam[_name];
215     Team storage team = teams[_tokenId];
216     require(SafeMath.diffString(_name,team.name)==true);
217     teamName = team.name;
218     sellingPrice = teamIndexToPrice[_tokenId];
219     owner = teamIndexToOwner[_tokenId];
220   }
221   
222   
223   function implementsERC721() public pure returns (bool) {
224     return true;
225   }
226   function name() public pure returns (string) {
227     return NAME;
228   }
229   function ownerOf(uint256 _tokenId)
230     public
231     view
232     returns (address owner)
233   {
234     owner = teamIndexToOwner[_tokenId];
235     require(owner != address(0));
236   }
237   
238   function payout(address _to) public onlyCEO {
239     _payout(_to);
240   }
241   
242    function () public payable onlyStart {
243       
244        string memory data=string(msg.data);
245        require(SafeMath.diffString(data,"")==false);    //data is not empty
246        
247        string memory _name=teamIndexToName[data];
248        require(SafeMath.diffString(_name,"")==false);   //name is not empty
249        
250        if(nameIndexToTeam[_name]==0){
251            require(SafeMath.diffString(_name,teams[0].name)==true);
252        }
253        
254        purchase(nameIndexToTeam[_name]);
255    }
256   
257   
258   function purchase(uint256 _tokenId) public payable onlyStart {
259     address oldOwner = teamIndexToOwner[_tokenId];
260     address newOwner = msg.sender;
261     uint256 sellingPrice = teamIndexToPrice[_tokenId];
262     // Making sure token owner is not sending to self
263     require(oldOwner != newOwner);
264     // Safety check to prevent against an unexpected 0x0 default.
265     require(_addressNotNull(newOwner));
266     // Making sure sent amount is greater than or equal to the sellingPrice
267     require(msg.value >= sellingPrice);
268     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
269     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
270     teamIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 130),100);
271     
272     _transfer(oldOwner, newOwner, _tokenId);
273     if (oldOwner != address(this)) {
274       oldOwner.send(payment); //oldOwner take 92% of the sellingPrice
275     }
276     TokenSold(_tokenId, sellingPrice, teamIndexToPrice[_tokenId], oldOwner, newOwner, teams[_tokenId].name);
277     msg.sender.send(purchaseExcess);
278   }
279   
280   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
281     return teamIndexToPrice[_tokenId];
282   }
283   
284   function symbol() public pure returns (string) {
285     return SYMBOL;
286   }
287   
288   function takeOwnership(uint256 _tokenId) public onlyStart{
289     address newOwner = msg.sender;
290     address oldOwner = teamIndexToOwner[_tokenId];
291     // Safety check to prevent against an unexpected 0x0 default.
292     require(_addressNotNull(newOwner));
293     // Making sure transfer is approved
294     require(_approved(newOwner, _tokenId));
295     _transfer(oldOwner, newOwner, _tokenId);
296   }
297   
298   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
299     uint256 tokenCount = balanceOf(_owner);
300     if (tokenCount == 0) {
301         // Return an empty array
302       return new uint256[](0);
303     } else {
304       uint256[] memory result = new uint256[](tokenCount);
305       uint256 totalPersons = totalSupply();
306       uint256 resultIndex = 0;
307       uint256 teamId;
308       for (teamId = 0; teamId <= totalPersons; teamId++) {
309         if (teamIndexToOwner[teamId] == _owner) {
310           result[resultIndex] = teamId;
311           resultIndex++;
312         }
313       }
314       return result;
315     }
316   }
317   
318   
319   function totalSupply() public view returns (uint256 total) {
320     return teams.length;
321   }
322   
323   
324   function transfer(
325     address _to,
326     uint256 _tokenId
327   ) public onlyStart {
328     require(_owns(msg.sender, _tokenId));
329     require(_addressNotNull(_to));
330     _transfer(msg.sender, _to, _tokenId);
331   }
332   function transferFrom(
333     address _from,
334     address _to,
335     uint256 _tokenId
336   ) public onlyStart{
337     require(_owns(_from, _tokenId));
338     require(_approved(_to, _tokenId));
339     require(_addressNotNull(_to));
340     _transfer(_from, _to, _tokenId);
341   }
342   function _addressNotNull(address _to) private pure returns (bool) {
343     return _to != address(0);
344   }
345   
346   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
347     return teamIndexToApproved[_tokenId] == _to;
348   }
349   
350   
351   function _createTeam(string _name, address _owner, uint256 _price) private {
352     
353     Team memory _team = Team({
354       name: _name
355     });
356     uint256 newTeamId = teams.push(_team) - 1;
357     nameIndexToTeam[_name]=newTeamId;
358     Birth(newTeamId, _name, _owner);
359     teamIndexToPrice[newTeamId] = _price;
360     _transfer(address(0), _owner, newTeamId);
361   }
362   
363   
364   /// Check for token ownership
365   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
366     return claimant == teamIndexToOwner[_tokenId];
367   }
368   /// For paying out balance on contract
369   function _payout(address _to) private {
370     if (_to == address(0)) {
371       ceoAddress.send(this.balance);
372     } else {
373       _to.send(this.balance);
374     }
375   }
376   function _transfer(address _from, address _to, uint256 _tokenId) private {
377     ownershipTokenCount[_to]++;
378     teamIndexToOwner[_tokenId] = _to;
379     if (_from != address(0)) {
380       ownershipTokenCount[_from]--;
381       delete teamIndexToApproved[_tokenId];
382     }
383     Transfer(_from, _to, _tokenId);
384   }
385 }
386 library SafeMath {
387   /**
388   * @dev Multiplies two numbers, throws on overflow.
389   */
390   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
391     if (a == 0) {
392       return 0;
393     }
394     uint256 c = a * b;
395     assert(c / a == b);
396     return c;
397   }
398   /**
399   * @dev Integer division of two numbers, truncating the quotient.
400   */
401   function div(uint256 a, uint256 b) internal pure returns (uint256) {
402     // assert(b > 0); // Solidity automatically throws when dividing by 0
403     uint256 c = a / b;
404     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
405     return c;
406   }
407   /**
408   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
409   */
410   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
411     assert(b <= a);
412     return a - b;
413   }
414   /**
415   * @dev Adds two numbers, throws on overflow.
416   */
417   function add(uint256 a, uint256 b) internal pure returns (uint256) {
418     uint256 c = a + b;
419     assert(c >= a);
420     return c;
421   }
422   
423 function diffString(string a, string b) internal pure returns (bool) {
424     bytes memory ab=bytes(a);
425     bytes memory bb=bytes(b);
426     if(ab.length!=bb.length){
427         return false;
428     }
429     uint len=ab.length;
430     for(uint i=0;i<len;i++){
431         if(ab[i]!=bb[i]){
432             return false;
433         }
434     }
435     return true;
436   }
437 }