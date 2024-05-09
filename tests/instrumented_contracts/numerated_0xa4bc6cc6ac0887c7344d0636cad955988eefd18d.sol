1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6     /**
7     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
8     * account.
9     */
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14 
15       /**
16        * @dev Throws if called by any account other than the owner.
17        */
18       modifier onlyOwner() {
19         require(msg.sender == owner);
20         _;
21       }
22   
23 
24   /**
25    * @dev Allows the current owner to transfer control of the contract to a newOwner.
26    * @param newOwner The address to transfer ownership to.
27    */
28   function transferOwnership(address newOwner) onlyOwner public {
29     require(newOwner != address(0));
30     owner = newOwner;
31   }
32 
33 }
34 
35 contract GuessEthEvents{
36     event drawLog(uint,uint,uint);
37 
38     event guessEvt(
39         address indexed playerAddr,
40         uint[] numbers, uint amount
41         );
42     event winnersEvt(
43         uint blockNumber,
44         address indexed playerAddr,
45         uint amount,
46         uint winAmount
47         );
48     event withdrawEvt(
49         address indexed to,
50         uint256 value
51         );
52     event drawEvt(
53         uint indexed blocknumberr,
54         uint number
55         );
56     
57     event sponseEvt(
58         address indexed addr,
59         uint amount
60         );
61 
62     event pauseGameEvt(
63         bool pause
64         );
65     event setOddsEvt(
66         uint odds
67         );
68   
69 }
70 
71 contract GuessEth is Ownable,GuessEthEvents{
72     using SafeMath for uint;
73 
74     /* Player Bets */
75 
76     struct bnumber{
77         address addr;
78         uint number;
79         uint value;
80         int8 result;
81         uint prize;
82     }
83     mapping(uint => bnumber[]) public bets;
84     mapping(uint => address) public betNumber;
85     
86     /* player address => blockNumber[]*/
87     mapping(address => uint[]) private playerBetBNumber;
88     
89     /* Awards Records */
90     struct winner{
91         bool result;
92         uint prize;
93     }
94     
95     mapping(uint => winner[]) private winners;
96     mapping(uint => uint) private winResult;
97     
98     address private wallet1;
99     address private wallet2;
100     
101     uint private predictBlockInterval=3;
102     uint public odds=45;
103     uint public minBetVal=1 finney;
104     uint public blockInterval=500;
105     uint public curOpenBNumber=0;
106     uint public numberRange=100;
107 
108     bool public gamePaused=false;
109     
110 
111     /* Sponsors */
112     mapping(address => uint) Sponsors;
113     uint public balanceOfSPS=0;
114     address[] public SponsorAddresses;
115     
116     uint reservefund=30 ether;
117    
118   
119     /**
120     * @dev prevents contracts from interacting with fomo3d
121     */
122     modifier isHuman() {
123         address _addr = msg.sender;
124         uint256 _codeLength;
125     
126         assembly {_codeLength := extcodesize(_addr)}
127         require(_codeLength == 0, "sorry humans only");
128         _;
129     }
130     
131     constructor(address _wallet1,address _wallet2) public{
132         wallet1=_wallet1;
133         wallet2=_wallet2;
134         
135         curOpenBNumber=blockInterval*(block.number.div(blockInterval));
136     }
137     
138     function pauseGame(bool _status) public onlyOwner returns(bool){
139             gamePaused=_status;
140             emit pauseGameEvt(_status);
141     }
142     
143     function setOdds(uint _odds) isHuman() public onlyOwner returns(bool){
144             odds = _odds;
145             emit setOddsEvt(_odds);
146     }
147     function setReservefund(uint _reservefund) isHuman() public onlyOwner returns(bool){
148             reservefund = _reservefund * 1 ether;
149     }
150     
151     function getTargetBNumber() view isHuman() public returns(uint){
152         uint n;
153         n=blockInterval*(predictBlockInterval + block.number/blockInterval);
154         return n;
155     }
156     
157     function guess(uint[] _numbers) payable isHuman() public returns(uint){
158         require(msg.value  >= _numbers.length.mul(minBetVal));
159 
160         uint n=blockInterval*(predictBlockInterval + block.number/blockInterval);
161         
162         for(uint _i=0;_i < _numbers.length;_i++){
163             bnumber memory b;
164             
165             b.addr=msg.sender;
166             b.number=_numbers[_i];
167             b.value=msg.value/_numbers.length;
168             b.result=-1;
169             
170             bets[n].push(b);
171         }
172         
173         
174         if(utils.inArray(playerBetBNumber[msg.sender],n)==false){
175             playerBetBNumber[msg.sender].push(n);
176         }
177         
178         emit guessEvt(msg.sender,_numbers, msg.value);
179         
180         return _numbers.length;
181     }
182     
183 
184     function getPlayerGuessNumbers() view public returns (uint[],uint[],uint256[],int8[],uint[]){
185         uint _c=0;
186         uint _i=0;
187         uint _j=0;
188         uint _bnumber;
189         uint limitRows=100;
190         
191         while(_i < playerBetBNumber[msg.sender].length){
192             _bnumber=playerBetBNumber[msg.sender][_i];
193             for(_j=0 ; _j < bets[_bnumber].length && _c < limitRows ; _j++){
194                 if(msg.sender==bets[_bnumber][_j].addr){
195                     _c++;
196                 }
197             }
198             _i++;
199         }
200 
201         uint[] memory _blockNumbers=new uint[](_c);
202         uint[] memory _numbers=new uint[](_c);
203         uint[] memory _values=new uint[](_c);
204         int8[] memory _result=new int8[](_c);
205         uint[] memory _prize=new uint[](_c);
206         
207         if(_c<=0){
208             return(_blockNumbers,_numbers,_values,_result,_prize);
209         }
210 
211         //uint[] memory _b=new uint[](bettings[_blocknumber].length);
212 
213         uint _count=0;
214         for(_i=0 ; _i < playerBetBNumber[msg.sender].length ; _i++){
215             _bnumber=playerBetBNumber[msg.sender][_i];
216             
217             for(_j=0 ; _j < bets[_bnumber].length && _count < limitRows ; _j++){
218                 if(bets[_bnumber][_j].addr == msg.sender){
219                     _blockNumbers[_count] = _bnumber;
220                     _numbers[_count] =  bets[_bnumber][_j].number;
221                     _values[_count] =  bets[_bnumber][_j].value;
222                     _result[_count] =  bets[_bnumber][_j].result;
223                     _prize[_count] =  bets[_bnumber][_j].prize;
224                     
225                     _count++;
226                 }
227             }
228         }
229 
230 
231         return(_blockNumbers,_numbers,_values,_result,_prize);
232     }
233     
234 
235     function draw(uint _blockNumber,uint _blockTimestamp) public onlyOwner returns (uint){
236         require(block.number >= curOpenBNumber + blockInterval);
237 
238         /*Set open Result*/
239         curOpenBNumber=_blockNumber;
240         uint result=_blockTimestamp % numberRange;
241         winResult[_blockNumber]=result;
242 
243         for(uint _i=0;_i < bets[_blockNumber].length;_i++){
244             //result+=1;
245             
246             
247             if(bets[_blockNumber][_i].number==result){
248                 bets[_blockNumber][_i].result = 1;
249                 bets[_blockNumber][_i].prize = bets[_blockNumber][_i].value * odds;
250                 
251                 emit winnersEvt(_blockNumber,bets[_blockNumber][_i].addr,bets[_blockNumber][_i].value,bets[_blockNumber][_i].prize);
252 
253                 withdraw(bets[_blockNumber][_i].addr,bets[_blockNumber][_i].prize);
254 
255             }else{
256                 bets[_blockNumber][_i].result = 0;
257                 bets[_blockNumber][_i].prize = 0;
258             }
259         }
260         
261         emit drawEvt(_blockNumber,curOpenBNumber);
262         
263         return result;
264     }
265     
266     function getWinners(uint _blockNumber) view public returns(address[],uint[]){
267         uint _count=winners[_blockNumber].length;
268         
269         address[] memory _addresses = new address[](_count);
270         uint[] memory _prize = new uint[](_count);
271         
272         uint _i=0;
273         for(_i=0;_i<_count;_i++){
274             //_addresses[_i] = winners[_blockNumber][_i].addr;
275             _prize[_i] = winners[_blockNumber][_i].prize;
276         }
277 
278         return (_addresses,_prize);
279     }
280 
281     function getWinResults(uint _blockNumber) view public returns(uint){
282         return winResult[_blockNumber];
283     }
284     
285     function withdraw(address _to,uint amount) public onlyOwner returns(bool){
286         require(address(this).balance.sub(amount) > 0);
287         _to.transfer(amount);
288         
289         emit withdrawEvt(_to,amount);
290         return true;
291     }
292     
293     
294     function invest() isHuman payable public returns(uint){
295         require(msg.value >= 0.1 ether,"Minima amoun:0.1 ether");
296         
297         Sponsors[msg.sender] = Sponsors[msg.sender].add(msg.value);
298         balanceOfSPS = balanceOfSPS.add(msg.value);
299         
300         if(!utils.inArray(SponsorAddresses,msg.sender)){
301             SponsorAddresses.push(msg.sender);
302             emit sponseEvt(msg.sender,msg.value);
303         }
304 
305         return Sponsors[msg.sender];
306     }
307     
308     function distribute() public onlyOwner{
309         if(address(this).balance < reservefund){
310             return;
311         }
312         
313         uint availableProfits=address(this).balance.sub(reservefund);
314         uint prft1=availableProfits.mul(3 ether).div(10 ether);
315         uint prft2=availableProfits.sub(prft1);
316         
317         uint _val=0;
318         uint _i=0;
319         
320         for(_i=0;_i<SponsorAddresses.length;_i++){
321             _val = (prft1 * Sponsors[SponsorAddresses[_i]]) / (balanceOfSPS);
322             SponsorAddresses[_i].transfer(_val);
323         }
324         
325         uint w1p=prft2.mul(3 ether).div(10 ether);
326         
327         wallet1.transfer(w1p);
328         wallet2.transfer(prft2.sub(w1p));
329     }
330     
331     function sharesOfSPS() view public returns(uint,uint){
332         return (Sponsors[msg.sender],balanceOfSPS);
333     }
334     
335     function getAllSponsors() view public returns(address[],uint[],uint){
336         uint _i=0;
337         uint _c=0;
338         for(_i=0;_i<SponsorAddresses.length;_i++){
339             _c+=1;
340         }
341         
342         address[] memory addrs=new address[](_c);
343         uint[] memory amounts=new uint[](_c);
344 
345         for(_i=0;_i<SponsorAddresses.length;_i++){
346             addrs[_i]=SponsorAddresses[_i];
347             amounts[_i]=Sponsors[SponsorAddresses[_i]];
348         }
349         
350         return(addrs,amounts,balanceOfSPS);
351     }
352 
353     function() payable isHuman() public {
354     }
355     
356   
357 }
358 
359 library SafeMath {
360   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
361     uint256 c = a * b;
362     assert(a == 0 || c / a == b);
363     return c;
364   }
365 
366   function div(uint256 a, uint256 b) internal pure returns (uint256) {
367     // assert(b > 0); // Solidity automatically throws when dividing by 0
368     uint256 c = a / b;
369     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
370     return c;
371   }
372 
373   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
374     assert(b <= a);
375     return a - b;
376   }
377 
378   function add(uint256 a, uint256 b) internal pure returns (uint256) {
379     uint256 c = a + b;
380     assert(c >= a);
381     return c;
382   }
383 }
384 
385 library utils{
386     function inArray(uint[] _arr,uint _val) internal pure returns(bool){
387         for(uint _i=0;_i< _arr.length;_i++){
388             if(_arr[_i]==_val){
389                 return true;
390                 break;
391             }
392         }
393         return false;
394     }
395     
396     function inArray(address[] _arr,address _val) internal pure returns(bool){
397         for(uint _i=0;_i< _arr.length;_i++){
398             if(_arr[_i]==_val){
399                 return true;
400                 break;
401             }
402         }
403         return false;
404     }
405 }