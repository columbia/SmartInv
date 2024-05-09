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
29         function zint_bytes32ToString(bytes32 x) public pure returns (string) {
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
53     
54     bool expired;
55     
56     struct Better {
57         bool used;
58         address betterAddress;
59         uint contribAmount;
60     }
61     
62     struct Side {
63         uint totalPledged;
64         bytes32 sideName;
65         address[] usedAddresses;
66         mapping (address => Better) contribDb;
67     }
68     string gName;
69     bytes32[] sides;
70     uint allSidesPledged;
71     uint expiry;
72     mapping (bytes32 => Side) public sideData;
73     mapping (bytes32 => uint) public idToNameRef;
74     
75     constructor (string gameName, uint gameExpiry, bytes32[] gameSides) public {
76         gName = gameName;
77         expiry = gameExpiry;
78         for (uint i = 0; i<gameSides.length; i++) {
79             sideData[gameSides[i]].sideName=gameSides[i];
80             idToNameRef[gameSides[i]]=i;
81             sides.push(gameSides[i]);
82         }
83         expired = false;
84         allSidesPledged = 0;
85     }
86     
87     function getGameName() view public returns (string) {
88         return gName;
89     }
90     function getGameSides() view public returns (bytes32[]) {
91         return sides;
92     }
93     function isNotExpired() view public returns (bool) {
94         return ((now < expiry) && !expired);
95     }
96     function getNumSides() view public returns (uint) {
97         return sides.length;
98     }
99     function getStrFromId(uint toConv) view public returns (string) {
100         return StringYokes.zint_bytes32ToString(sides[toConv]);
101     }
102     function getIdFromStr(string toConv) view public returns (uint) {
103         return idToNameRef[StringYokes.zint_convert(toConv)];
104     }
105     
106     function placeBet(address a, uint value, string betSide) public payable {
107         require(isNotExpired());
108         bytes32 index = StringYokes.zint_convert(betSide);
109         sideData[index].totalPledged+=value;
110         allSidesPledged+=value;
111         if (sideData[index].contribDb[a].used) {
112             value+=sideData[index].contribDb[a].contribAmount;
113         }
114         else {
115             sideData[index].usedAddresses.push(a);
116             sideData[index].contribDb[a].used=true;
117         }
118         sideData[index].contribDb[a].contribAmount+=value;
119     }
120     
121     function allSidesPledgedAmount() public view returns (uint) {
122         return allSidesPledged;
123     }
124     
125     function checkSidePledge(uint i) public view returns (uint) {
126         return sideData[sides[i]].totalPledged;
127     }
128     function dish(string winner, address profit) public onlyAdmin payable {
129         require(!expired);
130         expired = true;
131         bytes32 winByte = StringYokes.zint_convert(winner);
132         uint totalGameContrib = allSidesPledged;
133         uint totalSideContrib = (sideData[winByte].totalPledged);
134         for (uint i = 0; i<sideData[winByte].usedAddresses.length; i++) {
135             address recip = sideData[winByte].usedAddresses[i];
136             uint contribAmount = sideData[winByte].contribDb[recip].contribAmount;
137             uint winAddition = (925*1000*contribAmount*(totalGameContrib-totalSideContrib))/(1000000*totalSideContrib);
138             recip.transfer(contribAmount+winAddition);
139         }
140         profit.transfer(address(this).balance);
141     }
142     function refund() public onlyAdmin payable {
143         for (uint i = 0; i<sides.length; i++) {
144             for (uint j = 0; j<sideData[sides[i]].usedAddresses.length; j++) {
145             address recip = sideData[sides[i]].usedAddresses[j];
146             uint contribAmount = sideData[sides[i]].contribDb[recip].contribAmount;
147             recip.transfer(contribAmount);
148             }
149         }
150     }
151     
152 }
153 
154 contract BEthy is ExchangeAdmin {
155     Game[] current;
156     uint etherBalance;
157     
158     mapping (bytes32 => uint) public references;
159     
160     constructor () public {
161     }
162     
163     function addGame(string gameName, uint gameExpiry, bytes32[] gameSides) onlyAdmin public {
164         current.push(new Game(gameName, gameExpiry, gameSides));
165         references[StringYokes.zint_convert(gameName)]=current.length-1;
166     }
167     
168     function numGames() view public returns (uint) {
169         return current.length;
170     }
171     
172     function getName(uint i) view public returns (string, bool, uint) {
173        return (current[i].getGameName(), current[i].isNotExpired(), current[i].allSidesPledgedAmount());
174     }
175     
176     function getSidesById(uint i, uint j) view public returns (string, uint) {
177         return (StringYokes.zint_bytes32ToString(current[i].getGameSides()[j]), current[i].checkSidePledge(j));
178     }
179     
180     function getSides(string str, uint j) view public returns (string, uint) {
181         return getSidesById(references[StringYokes.zint_convert(str)], j);
182     }
183     
184     function getGameNumSides(uint i) view public returns (uint) {
185         return current[i].getNumSides();
186     }
187     function _byteToString(bytes32 x) public pure returns (string) {
188         return StringYokes.zint_bytes32ToString(x);
189     }
190     function _stringToByte(string x) public pure returns (bytes32) {
191         return StringYokes.zint_convert(x);
192     }
193     
194     function () public payable {
195         etherBalance+=msg.value;
196     }
197     
198     function getBalance() public view returns (uint) {
199         return etherBalance;
200     }
201     function getAddBal() public view returns (uint) {
202         return address(this).balance;
203     }
204     
205     function placeBet(uint gameId, string betSide) payable public {
206         require(msg.value!=0);
207         etherBalance+=msg.value;
208         current[gameId].placeBet.value(msg.value)(msg.sender, msg.value, betSide);
209     }
210     
211     function placeBet(string gameId, string betSide) payable public {
212         placeBet(references[StringYokes.zint_convert(gameId)], betSide);
213     }
214     
215     function checkGameAmount(uint gameId) public view returns (uint) {
216         return current[gameId].allSidesPledgedAmount();
217     }
218     function checkGameSideAmount(uint gameId, uint sideNum) public view returns (uint) {
219         return current[gameId].checkSidePledge(sideNum);
220     }
221     
222     function endGame(uint gameId, string winningSide, address beneficiary) public onlyAdmin {//returns (address[10], uint[10]) {
223         current[gameId].dish(winningSide, beneficiary);
224     }
225     function endGame(uint gameId, uint winningId, address profit) public onlyAdmin {
226         endGame(gameId, current[gameId].getStrFromId(winningId), profit);
227     }
228 }