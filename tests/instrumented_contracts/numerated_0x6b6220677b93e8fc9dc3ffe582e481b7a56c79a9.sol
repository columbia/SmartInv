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
61     // Array of arrays: [ gene mask, gene value, skill value ]
62     uint256[][] geneMasks = [
63         [ uint256(0x0000000000000000000000000000000000000000001f00000000000000000000), uint256(0x0000000000000000000000000000000000000000000500000000000000000000), uint256(2) ], // mauveover (D) - colorprimary
64         [ uint256(0x000000000000000000000000000000000000000003e000000000000000000000), uint256(0x000000000000000000000000000000000000000000a000000000000000000000), uint256(1) ], // mauveover (R1) - colorprimary
65         [ uint256(0x000000000000000000000000000000000000000000000001f000000000000000), uint256(0x0000000000000000000000000000000000000000000000019000000000000000), uint256(2) ], // wingtips (D) - eyes
66         [ uint256(0x00000000000000000000000000000000000000000000003e0000000000000000), uint256(0x0000000000000000000000000000000000000000000000320000000000000000), uint256(1) ], // wingtips (R1) - eyes
67         [ uint256(0x00000000000000000000000000000000000001f0000000000000000000000000), uint256(0x00000000000000000000000000000000000000c0000000000000000000000000), uint256(2) ], // coffee (D) - colorsecondary
68         [ uint256(0x0000000000000000000000000000000000003e00000000000000000000000000), uint256(0x0000000000000000000000000000000000001800000000000000000000000000), uint256(1) ], // coffee (R1) - colorsecondary
69         [ uint256(0x0000000000000000000000000000000000000000000000000000000001f00000), uint256(0x0000000000000000000000000000000000000000000000000000000000900000), uint256(2) ], // luckystripe (D) - pattern
70         [ uint256(0x000000000000000000000000000000000000000000000000000000003e000000), uint256(0x0000000000000000000000000000000000000000000000000000000012000000), uint256(1) ], // luckystripe (R1) - pattern
71         [ uint256(0x0000000000000000000000000000000000000000000000000000000001f00000), uint256(0x0000000000000000000000000000000000000000000000000000000000b00000), uint256(2) ], // jaguar (D) - pattern
72         [ uint256(0x000000000000000000000000000000000000000000000000000000003e000000), uint256(0x0000000000000000000000000000000000000000000000000000000016000000), uint256(1) ]  // jaguar (R1) - pattern
73     ];
74 
75     modifier onlyOwner() { require(msg.sender == owner); _; }
76 
77     function KittyRace(address _kittyCoreAddress) public {
78         owner = msg.sender;
79         kittyCoreAddress = _kittyCoreAddress;
80         kittyCore = KittyCoreI(kittyCoreAddress);
81     }
82 
83     function kill() public onlyOwner {
84         // Contract cannot be killed after midnight, April 1, 2018 (Pacific)
85         require(now < 1522566000);
86 
87         selfdestruct(owner);
88     }
89 
90     function setEntryFee(uint256 _entryFee) public onlyOwner { entryFee = _entryFee; }
91     function setProcessingFee(uint256 _processingFee) public onlyOwner { processingFee = _processingFee; }
92     function setRegistrationPeriod(uint8 _registrationPeriod) public onlyOwner { registrationPeriod = _registrationPeriod; }
93     function setMaxRacers(uint8 _maxRacers) public onlyOwner { maxRacers = _maxRacers; }
94     function setGameOn(bool _gameOn) public onlyOwner { gameOn = _gameOn; }
95 
96     function setKittyCoreAddress(address _kittyCoreAddress)
97         public
98         onlyOwner
99     {
100         kittyCoreAddress = _kittyCoreAddress;
101         kittyCore = KittyCoreI(kittyCoreAddress);
102     }
103 
104     function getRace(uint32 _raceId)
105         public
106         view
107         returns (uint256 blockJoinedFirstRacer, uint256 blockJoinedLastRacer, uint256 numRacers)
108     {
109         return (races[_raceId].blockJoinedFirstRacer, races[_raceId].blockJoinedLastRacer, races[_raceId].racers.length);
110     }
111 
112     function getRacer(uint32 _raceId, uint256 _racerIndex)
113         public
114         view
115         returns (address kittyOwner, uint256 kittyId)
116     {
117         Racer storage racer = races[_raceId].racers[_racerIndex];
118         return (racer.kittyOwner, racer.kittyId);
119     }
120 
121     function registerForRace(uint256 _kittyId)
122         external
123         payable
124         returns (uint256)
125     {
126         require(gameOn);
127 
128         // Confirm precise entry fee was provided
129         require(msg.value == entryFee);
130 
131         // Confirm sender owns the Kitty
132         require(msg.sender == kittyCore.ownerOf(_kittyId));
133 
134         // Confirm Kitty is not currently in another race
135         require(activeRacers[_kittyId] != true);
136 
137         Race storage race = races[raceId];
138 
139         // Create new race if current race is completed or full
140         if (completedRaces[raceId] || race.racers.length >= maxRacers) {
141             raceId += 1;
142             race = races[raceId];
143         }
144 
145         // Separated from statement above to function for first racer of first race
146         if (race.racers.length == 0) {
147             race.blockJoinedFirstRacer = uint32(block.number);
148         }
149         race.blockJoinedLastRacer = uint32(block.number);
150 
151         Racer memory racer = Racer({
152             kittyOwner: msg.sender,
153             kittyId: _kittyId
154         });
155 
156         race.racers.push(racer);
157 
158         activeRacers[_kittyId] = true;
159 
160         emit RegisterEvent(
161             raceId,
162             racer.kittyOwner,
163             racer.kittyId,
164             race.racers.length - 1 // Race position
165         );
166 
167         return raceId;
168     }
169 
170     function race(uint32 _raceId)
171         external
172         returns (uint256)
173     {
174         uint256 numRacers = races[_raceId].racers.length;
175 
176         // Is race full, if not, have racers had enough time to join?
177         require(numRacers >= maxRacers || block.number > races[_raceId].blockJoinedFirstRacer + registrationPeriod);
178 
179         // Enough unique block hashes to provide random roll for each racer?
180         require(block.number > races[_raceId].blockJoinedLastRacer + numRacers);
181 
182         Racer memory racer;
183         Racer memory winner = races[_raceId].racers[0];
184         uint8 raceScore;
185         uint8 highScore = 0;
186 
187         // Calc finishing order
188         for(uint i = 0; i < numRacers; i++) {
189             racer = races[_raceId].racers[i];
190             // Genetic skill score
191             raceScore = getKittySkillScore(racer.kittyId);
192             // Random chance score
193             raceScore += uint8(block.blockhash(races[_raceId].blockJoinedLastRacer + numRacers - i)) % 20;
194             // First and second entry incentives
195             if (i == 0) { raceScore += 2; } // First to join
196             if (i == 1) { raceScore += 1; } // Second to join
197 
198             if (raceScore > highScore) {
199                 winner = racer;
200                 highScore = raceScore;
201             }
202 
203             delete activeRacers[racer.kittyId];
204         }
205 
206         emit RaceEvent(
207             _raceId,
208             numRacers,
209             winner.kittyId
210         );
211 
212         emit PayoutEvent(
213             _raceId,
214             winner.kittyOwner,
215             (entryFee * numRacers) - (processingFee * numRacers),
216             !winner.kittyOwner.send((entryFee * numRacers) - (processingFee * numRacers)),
217             msg.sender,
218             processingFee * numRacers,
219             !msg.sender.send(processingFee * numRacers)
220         );
221 
222         completedRaces[_raceId] = true;
223         delete races[_raceId];
224 
225         return winner.kittyId;
226     }
227 
228     function getKittySkillScore(uint256 _kittyId)
229         private
230         view
231         returns (uint8)
232     {
233         uint256 genes;
234         ( , , , , , , , , , genes) = kittyCore.getKitty(_kittyId);
235 
236         uint8 skillScore;
237         for(uint8 i = 0; i < geneMasks.length; i++) {
238             if (genes & geneMasks[i][0] == geneMasks[i][1]) {
239                 skillScore += uint8(geneMasks[i][2]);
240             }
241         }
242 
243         return skillScore;
244     }
245 }
246 
247 // Barebones interface to CryptoKitties contract
248 contract KittyCoreI {
249     function getKitty(uint _id) public returns (
250         bool isGestating,
251         bool isReady,
252         uint256 cooldownIndex,
253         uint256 nextActionAt,
254         uint256 siringWithId,
255         uint256 birthTime,
256         uint256 matronId,
257         uint256 sireId,
258         uint256 generation,
259         uint256 genes
260     );
261 
262     function ownerOf(uint256 _tokenId) public view returns (address owner);
263 }