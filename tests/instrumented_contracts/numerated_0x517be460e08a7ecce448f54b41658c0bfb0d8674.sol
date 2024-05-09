1 pragma solidity ^0.4.24;
2 
3 contract ExchangeAdmin {
4     address public owner;
5     address public newOwner;
6 
7     event OwnershipTransferred(address indexed _from, address indexed _to);
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyAdmin {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address _newOwner) public onlyAdmin {
19         newOwner = _newOwner;
20     }
21     function acceptOwnership() public {
22         require(msg.sender == newOwner);
23         emit OwnershipTransferred(owner, newOwner);
24         owner = newOwner;
25         newOwner = address(0);
26     }
27 }
28 library StringYokes {
29     function zint_bytes32ToString(bytes32 x) public pure returns (string) {
30         bytes memory bytesString = new bytes(32);
31         uint charCount = 0;
32         for (uint j = 0; j < 32; j++) {
33             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
34             if (char != 0) {
35                 bytesString[charCount] = char;
36                 charCount++;
37             }
38         }
39         bytes memory bytesStringTrimmed = new bytes(charCount);
40         for (j = 0; j < charCount; j++) {
41             bytesStringTrimmed[j] = bytesString[j];
42         }
43         return string(bytesStringTrimmed);
44     }
45     function zint_convert(string key) public pure returns (bytes32 ret) {
46         if (bytes(key).length > 32) revert();
47         assembly {
48           ret := mload(add(key, 32))
49         }
50     }
51 }
52 contract Game is ExchangeAdmin {
53     bool expired;
54     struct Better {
55         bool used;
56         address betterAddress;
57         uint contribAmount;
58     }
59     struct Side {
60         bool isValidSide;
61         uint totalPledged;
62         bytes32 sideName;
63         address[] usedAddresses;
64         mapping (address => Better) contribDb;
65     }
66     string gName;
67     address gameMaker;
68     address mainContract;
69     bytes32[] sides;
70     uint allSidesPledged;
71     uint expiry;
72     mapping (bytes32 => Side) public sideData;
73     mapping (bytes32 => uint) public idToNameRef;
74     constructor (string gameName, uint gameExpiry, bytes32[] gameSides,address maker, address mainContractAdd) public {
75         require(now<gameExpiry);
76         gName = gameName;
77         gameMaker = maker;
78         expiry = gameExpiry;
79         mainContract = mainContractAdd;
80         for (uint i = 0; i<gameSides.length; i++) {
81             sideData[gameSides[i]].sideName=gameSides[i];
82             sideData[gameSides[i]].isValidSide=true;
83             idToNameRef[gameSides[i]]=i;
84             sides.push(gameSides[i]);
85         }
86         expired = false;
87         allSidesPledged = 0;
88     }
89     function getGameName() view public returns (string) {
90         return gName;
91     }
92     function getGameMaker() view public returns(address){
93       return gameMaker;
94     }
95     function getGameSides() view public returns (bytes32[]) {
96         return sides;
97     }
98     function isNotExpired() view public returns (bool) {
99         return ((now < expiry) && !expired);
100     }
101     function isExpired() view public returns(bool){
102         return expired;
103     }
104     function getNumSides() view public returns (uint) {
105         return sides.length;
106     }
107     function getExpiryTime() view public returns(uint){
108       return expiry;
109     }
110     function getStrFromId(uint toConv) view public returns (string) {
111         return StringYokes.zint_bytes32ToString(sides[toConv]);
112     }
113     function getIdFromStr(string toConv) view public returns (uint) {
114         return idToNameRef[StringYokes.zint_convert(toConv)];
115     }
116     function placeBet(address a, uint value, string betSide) public payable {
117         require(isNotExpired() && value!=0 && msg.sender==mainContract && sideData[StringYokes.zint_convert(betSide)].isValidSide);
118         bytes32 index = StringYokes.zint_convert(betSide);
119         sideData[index].totalPledged+=value;
120         allSidesPledged+=value;
121         if (!sideData[index].contribDb[a].used) {
122             sideData[index].usedAddresses.push(a);
123             sideData[index].contribDb[a].used=true;
124         }
125         sideData[index].contribDb[a].contribAmount+=value;
126     }
127     function allSidesPledgedAmount() public view returns (uint) {
128         return allSidesPledged;
129     }
130     function checkSidePledge(uint i) public view returns (uint) {
131         return sideData[sides[i]].totalPledged;
132     }
133     function dish(string winner, address profit) public payable {
134         require((!expired) && (mainContract==msg.sender));
135         expired = true;
136         bytes32 winByte = StringYokes.zint_convert(winner);
137         uint totalGameContrib = allSidesPledged;
138         uint totalSideContrib = (sideData[winByte].totalPledged);
139         for (uint i = 0; i<sideData[winByte].usedAddresses.length; i++) {
140             address recip = sideData[winByte].usedAddresses[i];
141             uint contribAmount = sideData[winByte].contribDb[recip].contribAmount;
142             uint winAddition = (950*1000*contribAmount*(totalGameContrib-totalSideContrib))/(1000000*totalSideContrib);
143             recip.transfer(contribAmount+winAddition);
144         }
145         profit.transfer(2*(address(this).balance/5));
146         gameMaker.transfer(address(this).balance);
147     }
148     function refund(address sentBy) public payable {
149         require(!expired && (mainContract==msg.sender) && ((sentBy==gameMaker) || now > getExpiryTime() + 259200));
150         for (uint i = 0; i<sides.length; i++) {
151             for (uint j = 0; j<sideData[sides[i]].usedAddresses.length; j++) {
152                 address recip = sideData[sides[i]].usedAddresses[j];
153                 uint contribAmount = sideData[sides[i]].contribDb[recip].contribAmount;
154                 recip.transfer(contribAmount);
155             }
156         }
157     }
158 }
159 
160 contract MUBet is ExchangeAdmin {
161     Game[] current;
162     constructor () public {    }
163 
164     function numGames() view public returns (uint nGames) {
165         return current.length;
166     }
167     function getName(uint i) view public returns (string gameName, bool isNotExpired, uint totalPledgedETH, bool wasFinalised, uint gameEndTime, address gameMakerAddress, uint gameNumSides, uint gameId) {
168        return (current[i].getGameName(), current[i].isNotExpired(), current[i].allSidesPledgedAmount(),current[i].isExpired(),current[i].getExpiryTime(), current[i].getGameMaker(), current[i].getNumSides(), i);
169     }
170     function getSidesArray(uint i) view public returns (bytes32[] sideNameBytes) {
171         return current[i].getGameSides();
172     }
173     function getSidesById(uint i, uint j) view public returns (string sideName, uint sidePledgedETH) {
174         return (StringYokes.zint_bytes32ToString(current[i].getGameSides()[j]), current[i].checkSidePledge(j));
175     }
176     function getGameNumSides(uint i) view public returns (uint gameNumSides) {
177         return current[i].getNumSides();
178     }
179     function getContractBal() public view returns (uint invalidBalanceETH) {
180         return address(this).balance;
181     }
182 
183     function () public payable {    }
184     function emergency(uint amount, address recipient) public onlyAdmin payable {
185         recipient.transfer(amount);
186     }
187     function addGame(string gameName, uint gameExpiry, bytes32[] gameSides) public {
188         require(gameSides.length > 1);
189         current.push(new Game(gameName, gameExpiry, gameSides, msg.sender, address(this)));
190     }
191     function endGame(uint gameId, string winningSide) public  {
192         require(current[gameId].getGameMaker() == msg.sender);
193         current[gameId].dish(winningSide,owner);
194     }
195     function refund(uint gameId) public {
196         current[gameId].refund(msg.sender);
197     }
198     function placeBet(uint gameId, string betSide) payable public {
199         current[gameId].placeBet.value(msg.value)(msg.sender, msg.value, betSide);
200     }
201 }