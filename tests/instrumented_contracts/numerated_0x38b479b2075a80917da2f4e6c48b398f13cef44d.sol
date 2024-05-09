1 pragma solidity ^0.4.21;
2 
3 contract KittyRace {
4     struct Race {
5         uint32 blockJoinedFirstRacer;
6         uint32 blockJoinedLastRacer;
7         Racer[] racers;
8     }
9 
10     struct Racer {
11         address kittyOwner;
12         uint256 kittyId;
13     }
14 
15     event RegisterEvent(
16         uint32 raceId,
17         address kittyAddress,
18         uint256 kittyId,
19         uint256 position
20     );
21 
22     event RaceEvent(
23         uint32 raceId,
24         uint256 numRacers,
25         uint256 winnerKittyId
26     );
27 
28     event PayoutEvent(
29         uint32 raceId,
30         address winnerKittyAddress,
31         uint256 winnerAmount,
32         bool winnerTxError,
33         address processingAddress,
34         uint256 processingAmount,
35         bool processingTxError
36     );
37 
38     // Contract owner
39     address public owner;
40 
41     // KittyCore contract reference
42     address public kittyCoreAddress;
43     KittyCoreI kittyCore;
44 
45     // Pause button
46     bool gameOn = true;
47 
48     // Precise payment value required to registerForRace(). This can be
49     // updated by the owner role as the gas or fiat prices adjust.
50     uint256 public entryFee = 0.005 ether;
51     uint256 public processingFee = 0.0005 ether; // paid from each entry fee to whoever successfully calls race() function
52     uint8 public registrationPeriod = 25; // number of blocks after race creation others can join
53     uint8 public maxRacers = 10; // maximum number of racers allowed for single race
54 
55     uint32 public raceId = 0;
56     mapping (uint256 => Race) public races;
57     mapping (uint256 => bool) public activeRacers;
58     mapping (uint256 => bool) public completedRaces;
59 
60     // Slight advantage for Kitties with the following genes
61     uint256[][] geneMasks = [
62         [ uint256(0x0000000000000000000000000000000000000000000000000000000000b00000), uint256(2) ], // jaguar (D) - pattern
63         [ uint256(0x0000000000000000000000000000000000000000000000000000000016000000), uint256(1) ], // jaguar (R1) - pattern
64         [ uint256(0x0000000000000000000000000000000000000000000000000000000000900000), uint256(2) ], // luckystripe (D) - pattern
65         [ uint256(0x0000000000000000000000000000000000000000000000000000000012000000), uint256(1) ], // luckystripe (R1) - pattern
66         [ uint256(0x0000000000000000000000000000000000000000000000019000000000000000), uint256(2) ], // wingtips (D) - eyes
67         [ uint256(0x0000000000000000000000000000000000000000000000320000000000000000), uint256(1) ], // wingtips (R1) - eyes
68         [ uint256(0x0000000000000000000000000000000000000000000500000000000000000000), uint256(2) ], // mauveover (D) - colorbody
69         [ uint256(0x000000000000000000000000000000000000000000a000000000000000000000), uint256(1) ], // mauveover (R1) - colorbody
70         [ uint256(0x00000000000000000000000000000000000000c0000000000000000000000000), uint256(2) ], // coffee (D) - color
71         [ uint256(0x0000000000000000000000000000000000001800000000000000000000000000), uint256(1) ]  // coffee (R1) - color
72     ];
73 
74     modifier onlyOwner() { require(msg.sender == owner); _; }
75 
76     function KittyRace(address _kittyCoreAddress) public {
77         owner = msg.sender;
78         kittyCoreAddress = _kittyCoreAddress;
79         kittyCore = KittyCoreI(kittyCoreAddress);
80     }
81 
82     function kill() public onlyOwner {
83         // Contract cannot be killed after midnight, April 1, 2018 (Pacific)
84         require(now < 1522566000);
85 
86         selfdestruct(owner);
87     }
88 
89     function setEntryFee(uint256 _entryFee) public onlyOwner { entryFee = _entryFee; }
90     function setProcessingFee(uint256 _processingFee) public onlyOwner { processingFee = _processingFee; }
91     function setRegistrationPeriod(uint8 _registrationPeriod) public onlyOwner { registrationPeriod = _registrationPeriod; }
92     function setMaxRacers(uint8 _maxRacers) public onlyOwner { maxRacers = _maxRacers; }
93     function setGameOn(bool _gameOn) public onlyOwner { gameOn = _gameOn; }
94 
95     function setKittyCoreAddress(address _kittyCoreAddress)
96         public
97         onlyOwner
98     {
99         kittyCoreAddress = _kittyCoreAddress;
100         kittyCore = KittyCoreI(kittyCoreAddress);
101     }
102 
103     function getRace(uint32 _raceId)
104         public
105         view
106         returns (uint256 blockJoinedFirstRacer, uint256 blockJoinedLastRacer, uint256 numRacers)
107     {
108         return (races[_raceId].blockJoinedFirstRacer, races[_raceId].blockJoinedLastRacer, races[_raceId].racers.length);
109     }
110 
111     function getRacer(uint32 _raceId, uint256 _racerIndex)
112         public
113         view
114         returns (address kittyOwner, uint256 kittyId)
115     {
116         Racer storage racer = races[_raceId].racers[_racerIndex];
117         return (racer.kittyOwner, racer.kittyId);
118     }
119 
120     function registerForRace(uint256 _kittyId)
121         external
122         payable
123         returns (uint256)
124     {
125         require(gameOn);
126 
127         // Confirm precise entry fee was provided
128         require(msg.value == entryFee);
129 
130         // Confirm sender owns the Kitty
131         require(msg.sender == kittyCore.ownerOf(_kittyId));
132 
133         // Confirm Kitty is not currently in another race
134         require(activeRacers[_kittyId] != true);
135 
136         Race storage race = races[raceId];
137 
138         // Create new race if current race is completed or full
139         if (completedRaces[raceId] || race.racers.length >= maxRacers) {
140             raceId += 1;
141             race = races[raceId];
142         }
143 
144         // Separated from statement above to function for first racer of first race
145         if (race.racers.length == 0) {
146             race.blockJoinedFirstRacer = uint32(block.number);
147         }
148         race.blockJoinedLastRacer = uint32(block.number);
149 
150         Racer memory racer = Racer({
151             kittyOwner: msg.sender,
152             kittyId: _kittyId
153         });
154 
155         race.racers.push(racer);
156 
157         activeRacers[_kittyId] = true;
158 
159         emit RegisterEvent(
160             raceId,
161             racer.kittyOwner,
162             racer.kittyId,
163             race.racers.length - 1 // Race position
164         );
165 
166         return raceId;
167     }
168 
169     function race(uint32 _raceId)
170         external
171         returns (uint256)
172     {
173         uint256 numRacers = races[_raceId].racers.length;
174 
175         // Is race full, if not, have racers had enough time to join?
176         require(numRacers >= maxRacers || block.number > races[_raceId].blockJoinedFirstRacer + registrationPeriod);
177 
178         // Enough unique block hashes to provide random roll for each racer?
179         require(block.number > races[_raceId].blockJoinedLastRacer + numRacers);
180 
181         Racer memory racer;
182         Racer memory winner = races[_raceId].racers[0];
183         uint8 raceScore;
184         uint8 highScore = 0;
185 
186         // Calc finishing order
187         for(uint i = 0; i < numRacers; i++) {
188             racer = races[_raceId].racers[i];
189             // Genetic skill score
190             raceScore = getKittySkillScore(racer.kittyId);
191             // Random chance score
192             raceScore += uint8(block.blockhash(races[_raceId].blockJoinedLastRacer + numRacers - i)) % 20;
193             // First and second entry incentives
194             if (i == 0) { raceScore += 2; } // First to join
195             if (i == 1) { raceScore += 1; } // Second to join
196 
197             if (raceScore > highScore) {
198                 winner = racer;
199                 highScore = raceScore;
200             }
201 
202             delete activeRacers[racer.kittyId];
203         }
204 
205         emit RaceEvent(
206             _raceId,
207             numRacers,
208             winner.kittyId
209         );
210 
211         emit PayoutEvent(
212             _raceId,
213             winner.kittyOwner,
214             (entryFee * numRacers) - (processingFee * numRacers),
215             !winner.kittyOwner.send((entryFee * numRacers) - (processingFee * numRacers)),
216             msg.sender,
217             processingFee * numRacers,
218             !msg.sender.send(processingFee * numRacers)
219         );
220 
221         completedRaces[_raceId] = true;
222         delete races[_raceId];
223 
224         return winner.kittyId;
225     }
226 
227     function getKittySkillScore(uint256 _kittyId)
228         private
229         view
230         returns (uint8)
231     {
232         uint256 genes;
233         ( , , , , , , , , , genes) = kittyCore.getKitty(_kittyId);
234 
235         uint8 skillScore;
236         for(uint8 i = 0; i < geneMasks.length; i++) {
237             if (genes & geneMasks[i][0] == geneMasks[i][0]) {
238                 skillScore += uint8(geneMasks[i][1]);
239             }
240         }
241 
242         return skillScore;
243     }
244 }
245 
246 // Barebones interface to CryptoKitties contract
247 contract KittyCoreI {
248     function getKitty(uint _id) public returns (
249         bool isGestating,
250         bool isReady,
251         uint256 cooldownIndex,
252         uint256 nextActionAt,
253         uint256 siringWithId,
254         uint256 birthTime,
255         uint256 matronId,
256         uint256 sireId,
257         uint256 generation,
258         uint256 genes
259     );
260 
261     function ownerOf(uint256 _tokenId) public view returns (address owner);
262 }