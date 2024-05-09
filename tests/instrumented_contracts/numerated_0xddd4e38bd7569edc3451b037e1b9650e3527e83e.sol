1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal pure returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal pure returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal pure returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal pure returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 contract Ownable {
29   address public owner;
30   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   constructor() public {
37     owner = msg.sender;
38   }
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     emit OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 contract CryptocurrencyRaz is Ownable {
60     
61     using SafeMath for uint256;
62     
63     uint public numberOfRazzes = 3;
64     uint idCounter = 1;
65     struct RazInformation
66     {
67         uint razInstance;
68         uint winningBet;
69         address winningAddress;
70         address[] allLosers;
71         uint timestamp;
72         uint id;
73     }
74     
75     struct previousBets
76     {
77         uint timestamp;
78         uint[] bets;
79     }
80     mapping(uint=>mapping(uint=>RazInformation)) public RazInstanceInformation;
81     mapping(uint=>mapping(uint=>mapping(address=>previousBets))) public userBetsInEachRazInstance;
82     
83     mapping(uint=>uint) public runningRazInstance;
84    
85     mapping(uint=>bool) public razCompletion;
86     mapping(uint=>mapping(uint=>address)) public numbersTaken;
87     mapping(uint=>uint) public maxBetsForEachRaz;
88     mapping(uint=>uint256) public participationFeeForEachRaz;
89     mapping(uint=>uint256) public winnerPrizeMoneyForEachRaz;
90     mapping(uint=>uint256) public ownerPrizeMoneyForEachRaz;
91     mapping(uint=>string) public razName;
92     mapping (address=>uint[]) public pastWinnings;
93     mapping (address=>uint[]) public pastLosings;
94     
95     
96     uint[] razList;
97     uint[] empty;
98     
99     uint[] winOrLoseArray;
100     uint WinOrLoseNumber;
101     previousBets aBet;
102     address[] losers;
103     
104     RazInformation information;
105     
106     event BetPlaced(address gambler, string razName, uint[] bets);
107     event BetWon(address gambler, string razName, uint betNum, uint razNumber, uint razInstance);
108     event allBetsPlaced(uint[] b);
109     uint[] bb;
110     
111     constructor(address _owner) public 
112     {
113         owner = _owner;
114         Setup();
115     }
116     
117     function Setup() internal {
118         maxBetsForEachRaz[1] = 10;
119         maxBetsForEachRaz[2] = 20;
120         maxBetsForEachRaz[3] = 10;
121         
122         razName[1] = "Mighty genesis";
123         razName[2] = "Second titan";
124         razName[3] = "Trinity affair";
125         
126         participationFeeForEachRaz[1] = 3 * 10 ** 16;
127         participationFeeForEachRaz[2] = 1 * 10 ** 16;
128         participationFeeForEachRaz[3] = 1 * 10 ** 16;
129         
130         winnerPrizeMoneyForEachRaz[1] = 21 * 10 ** 16;
131         winnerPrizeMoneyForEachRaz[2] = 15 * 10 ** 16;
132         winnerPrizeMoneyForEachRaz[3] = 7 * 10 ** 16;
133         
134         ownerPrizeMoneyForEachRaz[1] = 9 * 10 ** 16;
135         ownerPrizeMoneyForEachRaz[2] = 5 * 10 ** 16;
136         ownerPrizeMoneyForEachRaz[3] = 3 * 10 ** 16;
137         
138         runningRazInstance[1] = 1;
139         runningRazInstance[2] = 1;
140         runningRazInstance[3] = 1;
141     }
142     
143     function EnterBetsForRaz(uint razNumber, uint[] bets) public payable
144     {
145         require(razNumber>=1 && razNumber<=numberOfRazzes);
146         uint numBets = bets.length;     //finding the numbers of bets the user has placed
147         require(msg.value>=participationFeeForEachRaz[razNumber].mul(numBets));    //user has to pay according to the number of bets placed
148         require(razCompletion[razNumber] == false);
149         uint instance = runningRazInstance[razNumber];
150         bb = userBetsInEachRazInstance[razNumber][instance][msg.sender].bets;
151         for (uint i=0;i<numBets;i++)
152         {
153             require(numbersTaken[razNumber][bets[i]] == 0);
154             require(bets[i]>=1 && bets[i]<=maxBetsForEachRaz[razNumber]);
155             numbersTaken[razNumber][bets[i]] = msg.sender;
156             bb.push(bets[i]);
157         }
158         aBet.bets = bb;
159         aBet.timestamp = now;
160         userBetsInEachRazInstance[razNumber][instance][msg.sender] = aBet;
161         MarkRazAsComplete(razNumber);
162        
163         emit BetPlaced(msg.sender,razName[razNumber],bets);
164     }
165     
166     function MarkRazAsComplete(uint razNumber) internal returns (bool)
167     {
168         require(razNumber>=1 && razNumber<=numberOfRazzes);
169         for (uint i=1;i<=maxBetsForEachRaz[razNumber];i++)
170         {
171             if (numbersTaken[razNumber][i] == 0)
172             return false;
173         }
174         razCompletion[razNumber] = true;
175         uint randomNumber = uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%maxBetsForEachRaz[razNumber]);
176         randomNumber = randomNumber.add(1);
177         declareWinnerForRaz(razNumber,randomNumber);
178         return true;
179     }
180    
181     function getAvailableNumbersForRaz (uint razNumber) public returns (uint[])
182     {
183         require(razNumber>=1 && razNumber<=numberOfRazzes);
184         razList = empty;
185         for (uint i=1;i<=maxBetsForEachRaz[razNumber];i++)
186         {
187             if (numbersTaken[razNumber][i] == 0)
188                 razList.push(i);
189         }
190         return razList;
191     }
192     
193     function resetRaz(uint razNumber,address winningAddress, uint winningNumber) internal 
194     {
195         delete losers;
196         
197         bool isRepeat;
198         for (uint i=1;i<=maxBetsForEachRaz[razNumber];i++)
199         {
200             isRepeat = false;
201             if (numbersTaken[razNumber][i] == winningAddress && i == winningNumber)
202             {
203                 winOrLoseArray = pastWinnings[numbersTaken[razNumber][i]];
204                 winOrLoseArray.push(razNumber);
205                 pastWinnings[numbersTaken[razNumber][i]] = winOrLoseArray;
206             }
207             else
208             {
209                 if (numbersTaken[razNumber][i] != winningAddress)
210                 {
211                     for (uint j=0;j<losers.length;j++)
212                     {
213                         if (numbersTaken[razNumber][i] == losers[j])
214                             isRepeat = true;
215                     }
216                     if (!isRepeat)
217                     {
218                         winOrLoseArray = pastLosings[numbersTaken[razNumber][i]];
219                         winOrLoseArray.push(razNumber);
220                         pastLosings[numbersTaken[razNumber][i]] = winOrLoseArray;
221                         losers.push(numbersTaken[razNumber][i]);
222                     }
223                 }
224             }
225             numbersTaken[razNumber][i]=0;
226         }   
227         razCompletion[razNumber] = false;
228         uint thisInstance = runningRazInstance[razNumber];
229         information = RazInformation({razInstance:thisInstance, winningBet: winningNumber, winningAddress: winningAddress,allLosers: losers, timestamp:now, id:idCounter});
230         idCounter = idCounter.add(1);
231         RazInstanceInformation[razNumber][thisInstance] = information;
232         runningRazInstance[razNumber] = runningRazInstance[razNumber].add(1);
233     }
234     
235     function declareWinnerForRaz(uint razNumber,uint winningNumber) internal
236     {
237         require(razNumber>=1 && razNumber<=numberOfRazzes);
238         require(razCompletion[razNumber] == true);   
239         address winningAddress =  numbersTaken[razNumber][winningNumber];
240         winningAddress.transfer(winnerPrizeMoneyForEachRaz[razNumber]);
241         owner.transfer(ownerPrizeMoneyForEachRaz[razNumber]);
242         emit BetWon(winningAddress,razName[razNumber],winningNumber,razNumber,runningRazInstance[razNumber]);
243         resetRaz(razNumber,winningAddress,winningNumber);
244     }
245     
246     function GetUserBetsInRaz(address userAddress, uint razNumber) public returns (uint[])
247     {
248         require(razNumber>=1 && razNumber<=numberOfRazzes);
249         razList = empty;
250         for (uint i=1;i<=maxBetsForEachRaz[razNumber];i++)
251         {
252             if (numbersTaken[razNumber][i]==userAddress)
253                 razList.push(i);
254         }   
255         return razList;
256     }
257     function changeParticipationFeeForRaz(uint razNumber,uint participationFee) public onlyOwner 
258     {
259         require(razNumber>=1 && razNumber<=numberOfRazzes);
260         participationFeeForEachRaz[razNumber] = participationFee;
261     }
262     
263      function changeWinnerPrizeMoneyForRaz(uint razNumber,uint prizeMoney) public onlyOwner 
264      {
265         require(razNumber>=1 && razNumber<=numberOfRazzes);
266         winnerPrizeMoneyForEachRaz[razNumber] = prizeMoney;
267     }
268     
269     function addNewRaz(uint maxBets, uint winningAmount, uint ownerAmount, uint particFee, string name) public onlyOwner returns (uint) 
270     {
271         require(maxBets.mul(particFee) == winningAmount.add(ownerAmount));
272         numberOfRazzes = numberOfRazzes.add(1);
273         maxBetsForEachRaz[numberOfRazzes] = maxBets;
274         participationFeeForEachRaz[numberOfRazzes] = particFee;
275         winnerPrizeMoneyForEachRaz[numberOfRazzes] = winningAmount;
276         ownerPrizeMoneyForEachRaz[numberOfRazzes] = ownerAmount;    
277         razName[numberOfRazzes] = name;
278         runningRazInstance[numberOfRazzes] = 1;
279         return numberOfRazzes;
280     }
281     
282     function updateExistingRaz(uint razNumber, uint maxBets, uint winningAmount, uint ownerAmount, uint particFee, string name) public onlyOwner returns (uint) 
283     {
284         require (razNumber<=numberOfRazzes);
285         require(!IsRazRunning(razNumber));
286         require(maxBets.mul(particFee) == winningAmount.add(ownerAmount));
287         maxBetsForEachRaz[razNumber] = maxBets;
288         participationFeeForEachRaz[razNumber] = particFee;
289         winnerPrizeMoneyForEachRaz[razNumber] = winningAmount;
290         ownerPrizeMoneyForEachRaz[razNumber] = ownerAmount;   
291         razName[razNumber] = name;
292     }
293     function getMyPastWins(address addr) public constant returns (uint[])
294     {
295         return pastWinnings[addr];
296     }
297     function getMyPastLosses(address addr) public constant returns (uint[]) 
298     {
299         return pastLosings[addr];
300     }
301     
302     function getRazInstanceInformation(uint razNumber, uint instanceNumber) public constant returns (uint, address, address[],uint,uint)
303     {
304         return (RazInstanceInformation[razNumber][instanceNumber].winningBet, 
305                 RazInstanceInformation[razNumber][instanceNumber].winningAddress,
306                 RazInstanceInformation[razNumber][instanceNumber].allLosers,
307                 RazInstanceInformation[razNumber][instanceNumber].timestamp,
308                 RazInstanceInformation[razNumber][instanceNumber].id);
309     }
310     function getRunningRazInstance(uint razNumber) public constant returns (uint)
311     {
312         return runningRazInstance[razNumber];
313     }
314     
315     function getUserBetsInARazInstance(uint razNumber, uint instanceNumber) public constant returns(uint[])
316     {
317         return (userBetsInEachRazInstance[razNumber][instanceNumber][msg.sender].bets);
318     }
319     function getUserBetsTimeStampInARazInstance(uint razNumber, uint instanceNumber) public constant returns(uint)
320     {
321         return (userBetsInEachRazInstance[razNumber][instanceNumber][msg.sender].timestamp);
322     }
323     
324     function IsRazRunning(uint razNumber) constant public returns (bool)
325     {
326         require(razNumber>=1 && razNumber<=numberOfRazzes);
327         for (uint i=1;i<=maxBetsForEachRaz[razNumber];i++)
328         {
329             if (numbersTaken[razNumber][i] != 0)
330                 return true;
331         }
332         return false;
333     }
334 }