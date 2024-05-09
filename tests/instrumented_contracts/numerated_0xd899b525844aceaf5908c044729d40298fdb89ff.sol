1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   function add(uint a, uint b)
6     internal
7     pure
8     returns (uint c)
9   {
10     c = a + b;
11     require(c >= a);
12   }
13 
14   function sub(uint a, uint b)
15     internal
16     pure
17     returns (uint c)
18   {
19     require(b <= a);
20     c = a - b;
21   }
22 
23   function mul(uint a, uint b)
24     internal
25     pure
26     returns (uint c)
27   {
28     c = a * b;
29     require(a == 0 || c / a == b);
30   }
31 
32   function div(uint a, uint b)
33     internal
34     pure
35     returns (uint c)
36   {
37     require(b > 0);
38     c = a / b;
39   }
40 
41 }
42 
43 
44 contract ERC20Interface {
45 
46   event Transfer(address indexed from, address indexed to, uint tokens);
47   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 
49   function totalSupply() public constant returns (uint);
50   function balanceOf(address tokenOwner) public constant returns (uint balance);
51   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
52   function transfer(address to, uint tokens) public returns (bool success);
53   function approve(address spender, uint tokens) public returns (bool success);
54   function transferFrom(address from, address to, uint tokens) public returns (bool success);
55 
56 }
57 
58 
59 
60 
61 contract Owned {
62 
63   event OwnershipTransferred(address indexed _from, address indexed _to);
64 
65   address public owner;
66   address public newOwner;
67 
68   modifier onlyOwner {
69     require(msg.sender == owner);
70     _;
71   }
72 
73   function Owned()
74     public
75   {
76     owner = msg.sender;
77   }
78 
79   function transferOwnership(address _newOwner)
80     public
81     onlyOwner
82   {
83     newOwner = _newOwner;
84   }
85 
86   function acceptOwnership()
87     public
88   {
89     require(msg.sender == newOwner);
90     emit OwnershipTransferred(owner, newOwner);
91     owner = newOwner;
92     newOwner = address(0);
93   }
94 
95 }
96 
97 contract ELOT is ERC20Interface, Owned {
98 
99   using SafeMath for uint;
100 
101   string public symbol;
102   string public  name;
103   uint8 public decimals;
104   uint public _totalSupply;
105 
106   mapping(address => uint) balances;
107   mapping(address => mapping(address => uint)) allowed;
108 
109   function ELOT()
110     public
111   {
112     symbol = "ELOT";
113     name = "ELOT COIN";
114     decimals = 0;
115     _totalSupply = 5000000000 ;
116     balances[owner] = _totalSupply;
117     emit Transfer(address(0), owner, _totalSupply);
118   }
119 
120   function totalSupply()
121     public
122     constant
123     returns (uint)
124   {
125     return _totalSupply  - balances[address(0)];
126   }
127 
128   function balanceOf(address tokenOwner)
129     public
130     constant
131     returns (uint balance)
132   {
133     return balances[tokenOwner];
134   }
135 
136 
137   function transfer(address to, uint tokens)
138     public
139     returns (bool success)
140   {
141     balances[msg.sender] = balances[msg.sender].sub(tokens);
142     balances[to] = balances[to].add(tokens);
143     emit Transfer(msg.sender, to, tokens);
144     return true;
145   }
146 
147 
148   function approve(address spender, uint tokens)
149     public
150     returns (bool success)
151   {
152     allowed[msg.sender][spender] = tokens;
153     emit Approval(msg.sender, spender, tokens);
154     return true;
155   }
156 
157   function transferFrom(address from, address to, uint tokens)
158     public
159     returns (bool success)
160   {
161     balances[from] = balances[from].sub(tokens);
162     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
163     balances[to] = balances[to].add(tokens);
164     emit Transfer(from, to, tokens);
165     return true;
166   }
167 
168   function allowance(address tokenOwner, address spender)
169     public
170     constant
171     returns (uint remaining)
172   {
173     return allowed[tokenOwner][spender];
174   }
175 
176 
177   
178    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
179         allowed[msg.sender][spender] = tokens;
180         emit Approval(msg.sender, spender, tokens);
181         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
182         return true;
183     }
184 
185   function ApproveAndDo(address spender, uint tokens,bytes32 id, string data) public returns (bool success) {
186         allowed[msg.sender][spender] = tokens;
187         emit Approval(msg.sender, spender, tokens);
188         ApproveAndCallFallBack(spender).approveAndDo(msg.sender,tokens,this,id,data);
189         return true;
190         
191   }
192 
193 
194   function ()
195     public
196     payable
197   {
198     revert();
199   }
200 
201   function transferAnyERC20Token(address tokenAddress, uint tokens)
202     public
203     onlyOwner
204     returns (bool success)
205   {
206     return ERC20Interface(tokenAddress).transfer(owner, tokens);
207   }
208 }
209 
210 contract ApproveAndCallFallBack {
211     function approveAndDo(address from, uint256 tokens, address token,bytes32 id, string data) public;
212     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
213 }
214 
215 
216 contract LOTTERY{
217     
218     using SafeMath for uint;
219     
220     uint256 private randomnumber1 = 0;
221     uint256 private randomnumber2 = 0;
222     uint256 private randomnumber3 = 0;
223     uint256 private randomnumber4 = 0;
224     uint256 private randomnumber5 = 0;
225     
226     uint public round=0;
227     address private owner;
228     
229     mapping ( bytes32 => Note ) private Notes; //mapping id to note information
230     mapping ( address=> bytes32[]) private GuestBetList;
231     mapping ( uint => uint[]) winNumbers;//mapping round to win numbers  
232     
233     struct Note{
234         uint round;
235         uint[] betNumbers; 
236         uint tokens;
237         address client;
238         uint state;//0 inactive , 1 active
239         uint star;
240     }
241     
242     function LOTTERY() payable public{
243        owner  = msg.sender; 
244    }
245    //"0xff63212fa36420c22c6dac761a3f60d29fc1f32378a6451b291fdb540b152600","0xAfC28904Fc9fFbA207181e60a183716af4e5bce2"
246     function retrieve(bytes32 _id,address _tokenAddress)
247     payable
248     public
249     returns (bool success)
250     {
251         if( Notes[_id].state == 0 )
252         {
253             return false;
254         }
255         
256         if( Notes[_id].round > round )
257         {
258             return false;
259         }
260         
261         if(msg.sender != Notes[_id].client )
262         {
263             return false;
264         }
265         
266         
267         
268         if(        1 == Notes[_id].star 
269                 && msg.sender == Notes[_id].client
270                 && 1 == Notes[_id].state
271                 && winNumbers[Notes[_id].round][4] == Notes[_id].betNumbers[4]
272           )
273         {
274             
275             if(ERC20Interface(_tokenAddress).transfer(Notes[_id].client,Notes[_id].tokens * 6))
276             { 
277                 Notes[_id].state = 0;
278                 return true;
279             }
280          }else if( 2 == Notes[_id].star 
281                 && msg.sender == Notes[_id].client 
282                 && 1 == Notes[_id].state
283                 && winNumbers[Notes[_id].round][4] == Notes[_id].betNumbers[4] 
284                 && winNumbers[Notes[_id].round][3] == Notes[_id].betNumbers[3]
285           )
286         {
287             
288             if(ERC20Interface(_tokenAddress).transfer(Notes[_id].client,Notes[_id].tokens * 60))
289             { 
290                 Notes[_id].state = 0;
291                 return true;
292             }
293          }
294         else if(   3 == Notes[_id].star
295                 && msg.sender == Notes[_id].client 
296                 && 1 == Notes[_id].state
297                 && winNumbers[Notes[_id].round][4] == Notes[_id].betNumbers[4] 
298                 && winNumbers[Notes[_id].round][3] == Notes[_id].betNumbers[3]
299                 && winNumbers[Notes[_id].round][2] == Notes[_id].betNumbers[2]
300             
301           )
302         {
303             
304             if(ERC20Interface(_tokenAddress).transfer(Notes[_id].client,Notes[_id].tokens * 600))
305             { 
306                 Notes[_id].state = 0;
307                 return true;
308             }
309          }
310          else if(   4 == Notes[_id].star
311                 && msg.sender == Notes[_id].client 
312                 && 1 == Notes[_id].state
313                 && winNumbers[Notes[_id].round][4] == Notes[_id].betNumbers[4] 
314                 && winNumbers[Notes[_id].round][3] == Notes[_id].betNumbers[3]
315                 && winNumbers[Notes[_id].round][2] == Notes[_id].betNumbers[2]
316                 && winNumbers[Notes[_id].round][1] == Notes[_id].betNumbers[1]
317             
318           )
319         {
320             
321             if(ERC20Interface(_tokenAddress).transfer(Notes[_id].client,Notes[_id].tokens * 6000))
322             { 
323                 Notes[_id].state = 0;
324                 return true;
325             }
326          }
327         else if(   5 == Notes[_id].star
328                 && msg.sender == Notes[_id].client 
329                 && 1 == Notes[_id].state
330                 && winNumbers[Notes[_id].round][4] == Notes[_id].betNumbers[4] 
331                 && winNumbers[Notes[_id].round][3] == Notes[_id].betNumbers[3]
332                 && winNumbers[Notes[_id].round][2] == Notes[_id].betNumbers[2]
333                 && winNumbers[Notes[_id].round][1] == Notes[_id].betNumbers[1]
334                 && winNumbers[Notes[_id].round][0] == Notes[_id].betNumbers[0]
335             
336           )
337         {
338             
339             if(ERC20Interface(_tokenAddress).transfer(Notes[_id].client,Notes[_id].tokens * 60000))
340             { 
341                 Notes[_id].state = 0;
342                 return true;
343             }
344          }
345          
346          
347           
348     }
349     
350     function approveAndDo(address from, uint256 tokens, address token, bytes32 id,string data) 
351     payable
352     public{
353         
354          //betting round bigger than current round , return;
355          string memory roundstring = substring(data,0,10);
356          
357          uint betround = parseInt(roundstring,5);
358        
359          if(round >= betround)
360          {
361              return ;
362          }
363         
364          if(ERC20Interface(token).transferFrom(from,this,tokens))//transfer token to contract address
365          {
366           
367              uint[] memory numbers = new uint[](5);
368              numbers[0] = parseInt(substring(data,10,11),1);
369              numbers[1] = parseInt(substring(data,11,12),1);
370              numbers[2] = parseInt(substring(data,12,13),1);
371              numbers[3] = parseInt(substring(data,13,14),1);
372              numbers[4] = parseInt(substring(data,14,15),1);
373              randomnumber1 = randomnumber1 + numbers[0];
374              randomnumber2 = randomnumber2 + numbers[1];
375              randomnumber3 = randomnumber3 + numbers[2];
376              randomnumber4 = randomnumber4 + numbers[3];
377              randomnumber5 = randomnumber5 + numbers[4];
378              
379              
380             Notes[id]=Note({
381                                round:betround,
382                                betNumbers:numbers,
383                                tokens:tokens,
384                                client:from,
385                                state:1,
386                                star:parseInt(substring(data,15,16),1)
387                                
388                              });
389             GuestBetList[from].push(id);                 
390              
391              
392          }
393         
394         
395     }
396     
397 
398     function getGuestNotesInfo(bytes32 _id)
399     view
400     public
401     returns (uint _round,uint[] _guessNumber,uint _tokens,uint _state,uint _star)
402     {
403       return (
404                 Notes[_id].round,
405                 Notes[_id].betNumbers,
406                 Notes[_id].tokens,
407                 Notes[_id].state,
408                 Notes[_id].star
409                 
410             );
411     }
412     
413     function getGuestNotes(address _clientaddress)
414     view
415     public
416     returns (bytes32[] _ids)
417     {
418       return GuestBetList[_clientaddress];
419     }
420     
421     function getWinNumbers(uint _round)
422     view
423     public
424     returns (uint[] _winnumbers)
425     {
426       return winNumbers[_round];
427     }
428 
429 
430     function generateWinNumber() public returns (bool){
431         if(msg.sender != owner)
432         {
433             return false;
434         }
435         
436         uint winnumber1= uint8((uint256(keccak256(block.timestamp, block.difficulty))+randomnumber1)%10);
437         uint winnumber2= uint8((uint256(keccak256(block.timestamp, block.difficulty))+randomnumber2)%10);
438         uint winnumber3= uint8((uint256(keccak256(block.timestamp, block.difficulty))+randomnumber3)%10);
439         uint winnumber4= uint8((uint256(keccak256(block.timestamp, block.difficulty))+randomnumber4)%10);
440         uint winnumber5= uint8((uint256(keccak256(block.timestamp, block.difficulty))+randomnumber5)%10);
441         
442          round = round.add(1);
443         
444         winNumbers[round].push(winnumber1);
445         winNumbers[round].push(winnumber2);
446         winNumbers[round].push(winnumber3);
447         winNumbers[round].push(winnumber4);
448         winNumbers[round].push(winnumber5);
449         return true;
450     }
451     
452      function generateWinNumberTest(uint winnumber1,uint winnumber2,uint winnumber3,uint winnumber4,uint winnumber5) public returns (bool){
453         if(msg.sender != owner)
454         {
455             return false;
456         }
457         
458          round = round.add(1);
459         
460         winNumbers[round].push(winnumber1);
461         winNumbers[round].push(winnumber2);
462         winNumbers[round].push(winnumber3);
463         winNumbers[round].push(winnumber4);
464         winNumbers[round].push(winnumber5);
465         return true;
466     }
467 
468     function substring(string str, uint startIndex, uint endIndex) internal pure returns (string) {
469     bytes memory strBytes = bytes(str);
470     bytes memory result = new bytes(endIndex-startIndex);
471     for(uint i = startIndex; i < endIndex; i++) {
472         result[i-startIndex] = strBytes[i];
473     }
474     return string(result);
475     }
476 
477    function parseInt(string _a, uint _b) internal pure returns (uint) {
478           bytes memory bresult = bytes(_a);
479           uint mint = 0;
480           bool decimals = false;
481           for (uint i = 0; i < bresult.length; i++) {
482             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
483               if (decimals) {
484                 if (_b == 0) break;
485                   else _b--;
486               }
487               mint *= 10;
488               mint += uint(bresult[i]) - 48;
489             } else if (bresult[i] == 46) decimals = true;
490           }
491           return mint;
492 }
493 
494 }