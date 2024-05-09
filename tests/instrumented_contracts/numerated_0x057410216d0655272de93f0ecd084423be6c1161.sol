1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 library utils{
30     function inArray(uint[] _arr,uint _val) internal pure returns(bool){
31         for(uint _i=0;_i< _arr.length;_i++){
32             if(_arr[_i]==_val){
33                 return true;
34                 break;
35             }
36         }
37         return false;
38     }
39     
40     function inArray(address[] _arr,address _val) internal pure returns(bool){
41         for(uint _i=0;_i< _arr.length;_i++){
42             if(_arr[_i]==_val){
43                 return true;
44                 break;
45             }
46         }
47         return false;
48     }
49 }
50 
51 
52 contract Ownable {
53   address public owner;
54 
55     /**
56     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57     * account.
58     */
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63 
64       /**
65        * @dev Throws if called by any account other than the owner.
66        */
67       modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70       }
71   
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) onlyOwner public {
78     require(newOwner != address(0));
79     owner = newOwner;
80   }
81 
82 }
83 
84 contract GuessEthEvents{
85     event drawLog(uint,uint,uint);
86 
87     event guessEvt(
88         address indexed playerAddr,
89         uint[] numbers, uint amount
90         );
91     event winnersEvt(
92         uint blockNumber,
93         address indexed playerAddr,
94         uint amount,
95         uint winAmount
96         );
97     event withdrawEvt(
98         address indexed to,
99         uint256 value
100         );
101     event drawEvt(
102         uint indexed blocknumberr,
103         uint number
104         );
105     
106     event sponseEvt(
107         address indexed addr,
108         uint amount
109         );
110 
111     event pauseGameEvt(
112         bool pause
113         );
114     event setOddsEvt(
115         uint odds
116         );
117   
118 }
119 
120 contract GuessEth is Ownable,GuessEthEvents{
121     using SafeMath for uint;
122 
123     /* Player Bets */
124 
125     struct bnumber{
126         address addr;
127         uint number;
128         uint value;
129         int8 result;
130         uint prize;
131     }
132     mapping(uint => bnumber[]) public bets;
133     mapping(uint => address) public betNumber;
134     
135     /* player address => blockNumber[]*/
136     mapping(address => uint[]) private playerBetBNumber;
137     
138     /* Awards Records */
139     struct winner{
140         bool result;
141         uint prize;
142     }
143     
144     mapping(uint => winner[]) private winners;
145     mapping(uint => uint) private winResult;
146     
147     address private wallet1;
148     address private wallet2;
149     
150     uint private predictBlockInterval=3;
151     uint public odds=30;
152     uint public blockInterval=500;
153     uint public curOpenBNumber=0;
154     uint public numberRange=100;
155 
156     bool public gamePaused=false;
157     
158 
159     /* Sponsors */
160     mapping(address => uint) Sponsors;
161     uint public balanceOfSPS=0;
162     address[] public SponsorAddresses;
163     
164     uint reservefund=30 ether;
165    
166   
167     /**
168     * @dev prevents contracts from interacting with fomo3d
169     */
170     modifier isHuman() {
171         address _addr = msg.sender;
172         uint256 _codeLength;
173     
174         assembly {_codeLength := extcodesize(_addr)}
175         require(_codeLength == 0, "sorry humans only");
176         _;
177     }
178     
179     constructor(address _wallet1,address _wallet2) public{
180         wallet1=_wallet1;
181         wallet2=_wallet2;
182         
183         curOpenBNumber=blockInterval*(block.number.div(blockInterval));
184     }
185     
186     function pauseGame(bool _status) public onlyOwner returns(bool){
187             gamePaused=_status;
188             emit pauseGameEvt(_status);
189     }
190     
191     function setOdds(uint _odds) isHuman() public onlyOwner returns(bool){
192             odds = _odds;
193             emit setOddsEvt(_odds);
194     }
195     function setReservefund(uint _reservefund) isHuman() public onlyOwner returns(bool){
196             reservefund = _reservefund * 1 ether;
197     }
198     
199     function getTargetBNumber() view isHuman() public returns(uint){
200         uint n;
201         n=blockInterval*(predictBlockInterval + block.number/blockInterval);
202         return n;
203     }
204     
205     function guess(uint[] _numbers) payable isHuman() public returns(uint){
206         require(msg.value  >= _numbers.length * 0.05 ether);
207 
208         uint n=blockInterval*(predictBlockInterval + block.number/blockInterval);
209         
210         for(uint _i=0;_i < _numbers.length;_i++){
211             bnumber memory b;
212             
213             b.addr=msg.sender;
214             b.number=_numbers[_i];
215             b.value=msg.value/_numbers.length;
216             b.result=-1;
217             
218             bets[n].push(b);
219         }
220         
221         
222         if(utils.inArray(playerBetBNumber[msg.sender],n)==false){
223             playerBetBNumber[msg.sender].push(n);
224         }
225         
226         emit guessEvt(msg.sender,_numbers, msg.value);
227         
228         return _numbers.length;
229     }
230     
231 
232     function getPlayerGuessNumbers() view public returns (uint[],uint[],uint256[],int8[],uint[]){
233         uint _c=0;
234         uint _i=0;
235         uint _j=0;
236         uint _bnumber;
237         uint limitRows=100;
238         
239         while(_i < playerBetBNumber[msg.sender].length){
240             _bnumber=playerBetBNumber[msg.sender][_i];
241             for(_j=0 ; _j < bets[_bnumber].length && _c < limitRows ; _j++){
242                 if(msg.sender==bets[_bnumber][_j].addr){
243                     _c++;
244                 }
245             }
246             _i++;
247         }
248 
249         uint[] memory _blockNumbers=new uint[](_c);
250         uint[] memory _numbers=new uint[](_c);
251         uint[] memory _values=new uint[](_c);
252         int8[] memory _result=new int8[](_c);
253         uint[] memory _prize=new uint[](_c);
254         
255         if(_c<=0){
256             return(_blockNumbers,_numbers,_values,_result,_prize);
257         }
258 
259         //uint[] memory _b=new uint[](bettings[_blocknumber].length);
260 
261         uint _count=0;
262         for(_i=0 ; _i < playerBetBNumber[msg.sender].length ; _i++){
263             _bnumber=playerBetBNumber[msg.sender][_i];
264             
265             for(_j=0 ; _j < bets[_bnumber].length && _count < limitRows ; _j++){
266                 if(bets[_bnumber][_j].addr == msg.sender){
267                     _blockNumbers[_count] = _bnumber;
268                     _numbers[_count] =  bets[_bnumber][_j].number;
269                     _values[_count] =  bets[_bnumber][_j].value;
270                     _result[_count] =  bets[_bnumber][_j].result;
271                     _prize[_count] =  bets[_bnumber][_j].prize;
272                     
273                     _count++;
274                 }
275             }
276         }
277 
278 
279         return(_blockNumbers,_numbers,_values,_result,_prize);
280     }
281     
282 
283     function draw(uint _blockNumber,uint _blockTimestamp) public onlyOwner returns (uint){
284         require(block.number >= curOpenBNumber + blockInterval);
285 
286         /*Set open Result*/
287         curOpenBNumber=_blockNumber;
288         uint result=_blockTimestamp % numberRange;
289         winResult[_blockNumber]=result;
290 
291         for(uint _i=0;_i < bets[_blockNumber].length;_i++){
292             //result+=1;
293             
294             
295             if(bets[_blockNumber][_i].number==result){
296                 bets[_blockNumber][_i].result = 1;
297                 bets[_blockNumber][_i].prize = bets[_blockNumber][_i].value * odds;
298                 
299                 emit winnersEvt(_blockNumber,bets[_blockNumber][_i].addr,bets[_blockNumber][_i].value,bets[_blockNumber][_i].prize);
300 
301                 withdraw(bets[_blockNumber][_i].addr,bets[_blockNumber][_i].prize);
302 
303             }else{
304                 bets[_blockNumber][_i].result = 0;
305                 bets[_blockNumber][_i].prize = 0;
306             }
307         }
308         
309         emit drawEvt(_blockNumber,curOpenBNumber);
310         
311         return result;
312     }
313     
314     function getWinners(uint _blockNumber) view public returns(address[],uint[]){
315         uint _count=winners[_blockNumber].length;
316         
317         address[] memory _addresses = new address[](_count);
318         uint[] memory _prize = new uint[](_count);
319         
320         uint _i=0;
321         for(_i=0;_i<_count;_i++){
322             //_addresses[_i] = winners[_blockNumber][_i].addr;
323             _prize[_i] = winners[_blockNumber][_i].prize;
324         }
325 
326         return (_addresses,_prize);
327     }
328 
329     function getWinResults(uint _blockNumber) view public returns(uint){
330         return winResult[_blockNumber];
331     }
332     
333     function withdraw(address _to,uint amount) public onlyOwner returns(bool){
334         require(address(this).balance.sub(amount) > 0);
335         _to.transfer(amount);
336         
337         emit withdrawEvt(_to,amount);
338         return true;
339     }
340     
341     
342     function invest() isHuman payable public returns(uint){
343         require(msg.value >= 1 ether,"Minima amoun:1 ether");
344         
345         Sponsors[msg.sender] = Sponsors[msg.sender].add(msg.value);
346         balanceOfSPS = balanceOfSPS.add(msg.value);
347         
348         if(!utils.inArray(SponsorAddresses,msg.sender)){
349             SponsorAddresses.push(msg.sender);
350             emit sponseEvt(msg.sender,msg.value);
351         }
352 
353         return Sponsors[msg.sender];
354     }
355     
356     function distribute() public onlyOwner{
357         if(address(this).balance < reservefund){
358             return;
359         }
360         
361         uint availableProfits=address(this).balance.sub(reservefund);
362         uint prft1=availableProfits.mul(3 ether).div(10 ether);
363         uint prft2=availableProfits.sub(prft1);
364         
365         uint _val=0;
366         uint _i=0;
367         
368         for(_i=0;_i<SponsorAddresses.length;_i++){
369             _val = (prft1 * Sponsors[SponsorAddresses[_i]]) / (balanceOfSPS);
370             SponsorAddresses[_i].transfer(_val);
371         }
372         
373         uint w1p=prft2.mul(3 ether).div(10 ether);
374         
375         wallet1.transfer(w1p);
376         wallet2.transfer(prft2.sub(w1p));
377     }
378     
379     function sharesOfSPS() view public returns(uint,uint){
380         return (Sponsors[msg.sender],balanceOfSPS);
381     }
382     
383     function getAllSponsors() view public returns(address[],uint[],uint){
384         uint _i=0;
385         uint _c=0;
386         for(_i=0;_i<SponsorAddresses.length;_i++){
387             _c+=1;
388         }
389         
390         address[] memory addrs=new address[](_c);
391         uint[] memory amounts=new uint[](_c);
392 
393         for(_i=0;_i<SponsorAddresses.length;_i++){
394             addrs[_i]=SponsorAddresses[_i];
395             amounts[_i]=Sponsors[SponsorAddresses[_i]];
396         }
397         
398         return(addrs,amounts,balanceOfSPS);
399     }
400 
401     function() payable isHuman() public {
402     }
403     
404   
405 }