1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
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
43 /**
44  * @title Destructible
45  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
46  */
47 contract Destructible is Ownable {
48 
49   function Destructible() public payable { }
50 
51   /**
52    * @dev Transfers the current balance to the owner and terminates the contract.
53    */
54   function destroy() onlyOwner public {
55     selfdestruct(owner);
56   }
57 
58   function destroyAndSend(address _recipient) onlyOwner public {
59     selfdestruct(_recipient);
60   }
61 }
62 
63 /**
64  * @title SafeMath
65  * @dev Math operations with safety checks that throw on error
66  */
67 library SafeMath {
68 
69   /**
70   * @dev Multiplies two numbers, throws on overflow.
71   */
72   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73     if (a == 0) {
74       return 0;
75     }
76     uint256 c = a * b;
77     assert(c / a == b);
78     return c;
79   }
80 
81   /**
82   * @dev Integer division of two numbers, truncating the quotient.
83   */
84   function div(uint256 a, uint256 b) internal pure returns (uint256) {
85     // assert(b > 0); // Solidity automatically throws when dividing by 0
86     uint256 c = a / b;
87     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88     return c;
89   }
90 
91   /**
92   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
93   */
94   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   /**
100   * @dev Adds two numbers, throws on overflow.
101   */
102   function add(uint256 a, uint256 b) internal pure returns (uint256) {
103     uint256 c = a + b;
104     assert(c >= a);
105     return c;
106   }
107 }
108 
109 contract BallerToken is Ownable, Destructible {
110     using SafeMath for uint;
111     /*** EVENTS ***/
112 
113     // @dev Fired whenever a new Baller token is created for the first time.
114     event BallerCreated(uint256 tokenId, string name, address owner);
115 
116     // @dev Fired whenever a Baller token is sold.
117     event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address newOwner, string name);
118 
119     // @dev Fired whenever a team is transfered from one owner to another
120     event Transfer(address from, address to, uint256 tokenId);
121 
122     /*** CONSTANTS ***/
123 
124     uint constant private DEFAULT_START_PRICE = 0.01 ether;
125     uint constant private FIRST_PRICE_LIMIT =  0.5 ether;
126     uint constant private SECOND_PRICE_LIMIT =  2 ether;
127     uint constant private THIRD_PRICE_LIMIT =  5 ether;
128     uint constant private FIRST_COMMISSION_LEVEL = 5;
129     uint constant private SECOND_COMMISSION_LEVEL = 4;
130     uint constant private THIRD_COMMISSION_LEVEL = 3;
131     uint constant private FOURTH_COMMISSION_LEVEL = 2;
132     uint constant private FIRST_LEVEL_INCREASE = 200;
133     uint constant private SECOND_LEVEL_INCREASE = 135;
134     uint constant private THIRD_LEVEL_INCREASE = 125;
135     uint constant private FOURTH_LEVEL_INCREASE = 115;
136 
137     /*** STORAGE ***/
138 
139     // @dev maps team id to address of who owns it
140     mapping (uint => address) public teamIndexToOwner;
141 
142     // @dev maps team id to a price
143     mapping (uint => uint) private teamIndexToPrice;
144 
145     // @dev maps address to how many tokens they own
146     mapping (address => uint) private ownershipTokenCount;
147 
148 
149     /*** DATATYPES ***/
150     //@dev struct for a baller team
151     struct Team {
152       string name;
153     }
154 
155     //@dev array which holds each team
156     Team[] private ballerTeams;
157 
158     /*** PUBLIC FUNCTIONS ***/
159 
160     /**
161     * @dev public function to create team, can only be called by owner of smart contract
162     * @param _name the name of the team
163     */
164 
165     function createTeam(string _name, uint _price) public onlyOwner {
166       _createTeam(_name, this, _price);
167     }
168 
169     /**
170     * @dev Returns all the relevant information about a specific team.
171     * @param _tokenId The ID of the team.
172     * @return teamName the name of the team.
173     * @return currPrice what the team is currently worth.
174     * @return owner address of whoever owns the team
175     */
176     function getTeam(uint _tokenId) public view returns(string teamName, uint currPrice, address owner) {
177         Team storage currTeam = ballerTeams[_tokenId];
178         teamName = currTeam.name;
179         currPrice = teamIndexToPrice[_tokenId];
180         owner = ownerOf(_tokenId);
181     }
182 
183     /**
184     * @dev changes the name of a specific team.
185     * @param _tokenId The id of the team which you want to change.
186     * @param _newName The name you want to set the team to be.
187     */
188     function changeTeamName(uint _tokenId, string _newName) public onlyOwner {
189       require(_tokenId < ballerTeams.length);
190       ballerTeams[_tokenId].name = _newName;
191     }
192 
193     /**
194     * @dev sends all ethereum in this contract to the address specified
195     * @param _to address you want the eth to be sent to
196     */
197 
198     function payout(address _to) public onlyOwner {
199       _withdrawAmount(_to, this.balance);
200     }
201 
202     /**
203     * @dev Function to send some amount of ethereum out of the contract to an address
204     * @param _to address the eth will be sent to
205     * @param _amount amount you want to withdraw
206     */
207     function withdrawAmount(address _to, uint _amount) public onlyOwner {
208       _withdrawAmount(_to, _amount);
209     }
210 
211     /**
212     * @dev Function to get price of a team
213     * @param _teamId of team
214     * @return price price of team
215     */
216     function priceOfTeam(uint _teamId) public view returns (uint price, uint teamId) {
217       price = teamIndexToPrice[_teamId];
218       teamId = _teamId;
219     }
220 
221     /**
222     * @dev Gets list of teams owned by a person.
223     * @dev note: don't want to call this in the smart contract, expensive op.
224     * @param _owner address of the owner
225     * @return ownedTeams list of the teams owned by the owner
226     */
227     function getTeamsOfOwner(address _owner) public view returns (uint[] ownedTeams) {
228       uint tokenCount = balanceOf(_owner);
229       ownedTeams = new uint[](tokenCount);
230       uint totalTeams = totalSupply();
231       uint resultIndex = 0;
232       if (tokenCount != 0) {
233         for (uint pos = 0; pos < totalTeams; pos++) {
234           address currOwner = ownerOf(pos);
235           if (currOwner == _owner) {
236             ownedTeams[resultIndex] = pos;
237             resultIndex++;
238           }
239         }
240       }
241     }
242 
243     /*
244      * @dev gets the address of owner of the team
245      * @param _tokenId is id of the team
246      * @return owner the owner of the team's address
247     */
248     function ownerOf(uint _tokenId) public view returns (address owner) {
249       owner = teamIndexToOwner[_tokenId];
250       require(owner != address(0));
251     }
252 
253     /*
254      * @dev gets how many tokens an address owners
255      * @param _owner is address of owner
256      * @return numTeamsOwned how much teams he has
257     */
258     function balanceOf(address _owner) public view returns (uint numTeamsOwned) {
259       numTeamsOwned = ownershipTokenCount[_owner];
260     }
261 
262     /*
263      * @dev gets total number of teams
264      * @return totalNumTeams which is the number of teams
265     */
266     function totalSupply() public view returns (uint totalNumTeams) {
267       totalNumTeams = ballerTeams.length;
268     }
269 
270     /**
271     * @dev Allows user to buy a team from the old owner.
272     * @dev Pays old owner minus commission, updates price.
273     * @param _teamId id of the team they're trying to buy
274     */
275     function purchase(uint _teamId) public payable {
276       address oldOwner = ownerOf(_teamId);
277       address newOwner = msg.sender;
278 
279       uint sellingPrice = teamIndexToPrice[_teamId];
280 
281       // Making sure token owner is not sending to self
282       require(oldOwner != newOwner);
283 
284       // Safety check to prevent against an unexpected 0x0 default.
285       require(_addressNotNull(newOwner));
286 
287       // Making sure sent amount is greater than or equal to the sellingPrice
288       require(msg.value >= sellingPrice);
289 
290       uint payment =  _calculatePaymentToOwner(sellingPrice);
291       uint excessPayment = msg.value.sub(sellingPrice);
292       uint newPrice = _calculateNewPrice(sellingPrice);
293       teamIndexToPrice[_teamId] = newPrice;
294 
295       _transfer(oldOwner, newOwner, _teamId);
296       // Pay old tokenOwner, unless it's the smart contract
297       if (oldOwner != address(this)) {
298         oldOwner.transfer(payment);
299       }
300 
301       newOwner.transfer(excessPayment);
302       string memory teamName = ballerTeams[_teamId].name;
303       TokenSold(_teamId, sellingPrice, newPrice, oldOwner, newOwner, teamName);
304     }
305 
306 
307     /// Safety check on _to address to prevent against an unexpected 0x0 default.
308     function _addressNotNull(address _to) private pure returns (bool) {
309       return _to != address(0);
310     }
311 
312     /**
313     * @dev Internal function to send some amount of ethereum out of the contract to an address
314     * @param _to address the eth will be sent to
315     * @param _amount amount you want to withdraw
316     */
317     function _withdrawAmount(address _to, uint _amount) private {
318       require(this.balance >= _amount);
319       if (_to == address(0)) {
320         owner.transfer(_amount);
321       } else {
322         _to.transfer(_amount);
323       }
324     }
325 
326     /**
327     * @dev internal function to create team
328     * @param _name the name of the team
329     * @param _owner the owner of the team
330     * @param _startingPrice the price of the team at the beginning
331     */
332     function _createTeam(string _name, address _owner, uint _startingPrice) private {
333       Team memory currTeam = Team(_name);
334       uint newTeamId = ballerTeams.push(currTeam) - 1;
335 
336       // make sure we never overflow amount of tokens possible to be created
337       // 4 billion tokens...shouldn't happen.
338       require(newTeamId == uint256(uint32(newTeamId)));
339 
340       BallerCreated(newTeamId, _name, _owner);
341       teamIndexToPrice[newTeamId] = _startingPrice;
342       _transfer(address(0), _owner, newTeamId);
343     }
344 
345     /**
346     * @dev internal function to transfer ownership of team
347     * @param _from original owner of token
348     * @param _to the new owner
349     * @param _teamId id of the team
350     */
351     function _transfer(address _from, address _to, uint _teamId) private {
352       ownershipTokenCount[_to]++;
353       teamIndexToOwner[_teamId] = _to;
354 
355       // Creation of new team causes _from to be 0
356       if (_from != address(0)) {
357         ownershipTokenCount[_from]--;
358       }
359 
360       Transfer(_from, _to, _teamId);
361     }
362 
363     /**
364     * @dev internal function to calculate how much to give to owner of contract
365     * @param _sellingPrice the current price of the team
366     * @return payment amount the owner gets after commission.
367     */
368     function _calculatePaymentToOwner(uint _sellingPrice) private pure returns (uint payment) {
369       if (_sellingPrice < FIRST_PRICE_LIMIT) {
370         payment = uint256(_sellingPrice.mul(100-FIRST_COMMISSION_LEVEL).div(100));
371       }
372       else if (_sellingPrice < SECOND_PRICE_LIMIT) {
373         payment = uint256(_sellingPrice.mul(100-SECOND_COMMISSION_LEVEL).div(100));
374       }
375       else if (_sellingPrice < THIRD_PRICE_LIMIT) {
376         payment = uint256(_sellingPrice.mul(100-THIRD_COMMISSION_LEVEL).div(100));
377       }
378       else {
379         payment = uint256(_sellingPrice.mul(100-FOURTH_COMMISSION_LEVEL).div(100));
380       }
381     }
382 
383     /**
384     * @dev internal function to calculate how much the new price is
385     * @param _sellingPrice the current price of the team.
386     * @return newPrice price the team will be worth after being bought.
387     */
388     function _calculateNewPrice(uint _sellingPrice) private pure returns (uint newPrice) {
389       if (_sellingPrice < FIRST_PRICE_LIMIT) {
390         newPrice = uint256(_sellingPrice.mul(FIRST_LEVEL_INCREASE).div(100));
391       }
392       else if (_sellingPrice < SECOND_PRICE_LIMIT) {
393         newPrice = uint256(_sellingPrice.mul(SECOND_LEVEL_INCREASE).div(100));
394       }
395       else if (_sellingPrice < THIRD_PRICE_LIMIT) {
396         newPrice = uint256(_sellingPrice.mul(THIRD_LEVEL_INCREASE).div(100));
397       }
398       else {
399         newPrice = uint256(_sellingPrice.mul(FOURTH_LEVEL_INCREASE).div(100));
400       }
401     }
402 }