1 pragma solidity ^ 0.4.24; 
2 
3 /***
4  *     __   __   ___      ___    ___   
5  *     \ \ / /  / _ \    | _ \  / _ \  
6  *      \ V /  | (_) |   |  _/ | (_) | 
7  *      _|_|_   \___/   _|_|_   \___/  
8  *    _| """ |_|"""""|_| """ |_|"""""| 
9  *    "`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-' 
10  *   
11  *   https://a21.app
12  */
13 
14 interface IGameBuilder{
15     function buildGame (address _manager, string _name, string _title, uint256 _price, uint256 _timespan,
16         uint8 _profitOfManager, uint8 _profitOfFirstPlayer, uint8 _profitOfWinner) payable external returns(address);
17 } 
18 contract IGame {
19      
20     address public owner; 
21     address public creator;
22     address public manager;
23 	uint256 public poolValue = 0;
24 	uint256 public round = 0;
25 	uint256 public totalBets = 0;
26 	uint256 public startTime = now;
27     bytes32 public name;
28     string public title;
29 	uint256 public price;
30 	uint256 public timespan;
31 	uint32 public gameType;
32 
33     /* profit divisions */
34 	uint256 public profitOfSociety = 5;  
35 	uint256 public profitOfManager = 1; 
36 	uint256 public profitOfFirstPlayer = 15;
37 	uint256 public profitOfWinner = 40;
38 	
39 	function getGame() view public returns(
40         address, uint256, address, uint256, 
41         uint256, uint256, uint256, 
42         uint256, uint256, uint256, uint256);
43 } 
44 /***
45  *       ___     ___      _    
46  *      /   \   |_  )    / |   
47  *      | - |    / /     | |   
48  *      |_|_|   /___|   _|_|_  
49  *    _|"""""|_|"""""|_|"""""| 
50  *    "`-0-0-'"`-0-0-'"`-0-0-' 
51  */
52 contract Owned {
53     modifier isActivated {
54         require(activated == true, "its not ready yet."); 
55         _;
56     }
57     
58     modifier isHuman {
59         address _addr = msg.sender;
60         uint256 _codeLength;
61         
62         assembly {_codeLength := extcodesize(_addr)}
63         require(_codeLength == 0, "sorry humans only");
64         _;
65     }
66  
67     modifier limits(uint256 _eth) {
68         require(_eth >= 1000000000, "pocket lint: not a valid currency");
69         require(_eth <= 100000000000000000000000, "no vitalik, no");
70         _;    
71     }
72  
73     modifier onlyOwner {
74         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
75         _;
76     }
77 
78     address public owner;
79 	bool public activated = true;
80 
81     constructor() public{
82         owner = msg.sender;
83     }
84 
85 	function terminate() public onlyOwner {
86 		selfdestruct(owner);
87 	}
88 
89 	function setIsActivated(bool _activated) public onlyOwner {
90 		activated = _activated;
91 	}
92 } 
93  
94 /**
95  * @title NameFilter
96  * @dev filter string
97  */
98 library NameFilter {
99     /**
100      * @dev filters name strings
101      * -converts uppercase to lower case.  
102      * -makes sure it does not start/end with a space
103      * -makes sure it does not contain multiple spaces in a row
104      * -cannot be only numbers
105      * -cannot start with 0x 
106      * -restricts characters to A-Z, a-z, 0-9, and space.
107      * @return reprocessed string in bytes32 format
108      */
109     function nameFilter(string _input)
110         internal
111         pure
112         returns(bytes32)
113     {
114         bytes memory _temp = bytes(_input);
115         uint256 _length = _temp.length;
116         
117         //sorry limited to 32 characters
118         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
119         // make sure it doesnt start with or end with space
120         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
121         // make sure first two characters are not 0x
122         if (_temp[0] == 0x30)
123         {
124             require(_temp[1] != 0x78, "string cannot start with 0x");
125             require(_temp[1] != 0x58, "string cannot start with 0X");
126         }
127         
128         // create a bool to track if we have a non number character
129         bool _hasNonNumber;
130         
131         // convert & check
132         for (uint256 i = 0; i < _length; i++)
133         {
134             // if its uppercase A-Z
135             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
136             {
137                 // convert to lower case a-z
138                 _temp[i] = byte(uint(_temp[i]) + 32);
139                 
140                 // we have a non number
141                 if (_hasNonNumber == false)
142                     _hasNonNumber = true;
143             } else {
144                 require
145                 (
146                     // require character is a space
147                     _temp[i] == 0x20 || 
148                     // OR lowercase a-z
149                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
150                     // or 0-9
151                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
152                     "string contains invalid characters"
153                 );
154                 // make sure theres not 2x spaces in a row
155                 if (_temp[i] == 0x20)
156                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
157                 
158                 // see if we have a character other than a number
159                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
160                     _hasNonNumber = true;    
161             }
162         }
163         
164         require(_hasNonNumber == true, "string cannot be only numbers");
165         
166         bytes32 _ret;
167         assembly {
168             _ret := mload(add(_temp, 32))
169         }
170         return (_ret);
171     }
172 }
173 
174 
175 
176 contract GameFactory is Owned {
177 	uint256 private constant MINIMUM_PRICE = 0.01 ether;
178 	uint256 private constant MAXIMUM_PRICE = 100 ether;
179 	uint256 private constant MINIMUM_TIMESPAN = 1 minutes;  
180 	uint256 private constant MAXIMUM_TIMESPAN = 24 hours;  
181 
182     using NameFilter for string;
183 	mapping(bytes32 => address) public games; 
184 	mapping(uint256 => address) public builders; 
185     bytes32[] public names;
186     address[] public addresses;
187     address[] public approved;
188     address[] public offlines;
189     uint256 public fee = 0.2 ether;
190     uint8 public numberOfEarlybirds = 10;
191     uint256 public numberOfGames = 0;
192 
193     event onNewGame (address sender, bytes32 gameName, address gameAddress, uint256 fee, uint256 timestamp);
194 
195     function newGame (address _manager, string _name, string _title, uint256 _price, uint256 _timespan,
196         uint8 _profitOfManager, uint8 _profitOfFirstPlayer, uint8 _profitOfWinner, uint256 _gameType) 
197         limits(msg.value) isActivated payable public 
198     {
199 		require(address(_manager)!=0x0, "invaild address");
200 		require(_price >= MINIMUM_PRICE && _price <= MAXIMUM_PRICE, "price not in range (MINIMUM_PRICE, MAXIMUM_PRICE)");
201 		require(_timespan >= MINIMUM_TIMESPAN && _timespan <= MAXIMUM_TIMESPAN, "timespan not in range(MINIMUM_TIMESPAN, MAXIMUM_TIMESPAN)");
202 		bytes32 name = _name.nameFilter();
203         require(name[0] != 0, "invaild name");
204         require(checkName(name), "duplicate name");
205         require(_profitOfManager <=20, "[profitOfManager] don't take too much commission :)");
206         require(_profitOfFirstPlayer <=50, "[profitOfFirstPlayer] don't take too much commission :)");
207         require(_profitOfWinner <=100 && (_profitOfManager + _profitOfWinner + _profitOfFirstPlayer) <=100, "[profitOfWinner] don't take too much commission :)");
208         require(msg.value >= getTicketPrice(_profitOfManager), "fee is not enough");
209 
210         address builderAddress = builders[_gameType];
211 		require(address(builderAddress)!=0x0, "invaild game type");
212         
213         IGameBuilder builder = IGameBuilder(builderAddress);
214         address game = builder.buildGame(_manager, _name, _title, _price, _timespan, _profitOfManager, _profitOfFirstPlayer, _profitOfWinner);
215         games[name] = game; 
216         names.push(name);
217         addresses.push(game);
218         numberOfGames ++;
219         owner.transfer(msg.value); 
220 
221         if(numberOfGames > numberOfEarlybirds){
222             // plus 10% fee everytime    
223             // might overflow? I wish as well, however, at that time no one can afford the fee.
224             fee +=  (fee/10);        
225         }
226 
227         emit onNewGame(msg.sender, name, game, fee, now);
228     } 
229 
230     function checkName(bytes32 _name) view public returns(bool){
231         return address(games[_name]) == 0x0;
232     }
233 
234 	function addGame(address _addr) public payable onlyOwner {
235 	    IGame game = IGame(_addr);  
236         require(checkName(game.name()), "duplicate name");
237         
238 	    games[game.name()] = _addr;
239         names.push(game.name());
240 	    addresses.push(_addr);
241         approved.push(_addr);
242         numberOfGames ++;
243 	}
244 	
245 	function addBuilder(uint256 _gameType, address _builderAddress) public payable onlyOwner {
246         builders[_gameType] = _builderAddress;
247 	}
248 	
249 	function approveGame(address _addr) public payable onlyOwner {
250         approved.push(_addr);
251 	}
252 	
253 	function offlineGame(address _addr) public payable onlyOwner {
254         offlines.push(_addr);
255 	}
256 	
257 	function setFee(uint256 _fee) public payable onlyOwner {
258         fee = _fee;
259 	}
260 
261     function getTicketPrice(uint8 _profitOfManager) view public returns(uint256){
262         // might overflow? I wish as well, however, at that time no one can afford the fee.
263         return fee * _profitOfManager; 
264     }
265 
266     function getNames() view public returns(bytes32[]){
267         return names;
268     }
269 
270     function getAddresses() view public returns(address[]){
271         return addresses;
272     }
273 
274     function getGame(bytes32 _name) view public returns(
275         address, uint256, address, uint256, 
276         uint256, uint256, uint256, 
277         uint256, uint256, uint256, uint256) {
278         require(!checkName(_name), "name not found!");
279         address gameAddress = games[_name];
280         IGame game = IGame(gameAddress);  
281         return game.getGame();
282     }
283 
284 	function withdraw() public onlyOwner {
285         owner.transfer(address(this).balance);
286 	}
287 }