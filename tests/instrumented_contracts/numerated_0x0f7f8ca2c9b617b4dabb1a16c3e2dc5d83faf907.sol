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
97 contract PopulStayToken is ERC20Interface, Owned {
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
109   function PopulStayToken()
110     public
111   {
112     symbol = "PPS";
113     name = "PopulStay Token";
114     decimals = 0;
115     _totalSupply = 5000000000;
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
148 
149   function approve(address spender, uint tokens)
150     public
151     returns (bool success)
152   {
153     allowed[msg.sender][spender] = tokens;
154     emit Approval(msg.sender, spender, tokens);
155     return true;
156   }
157 
158   function transferFrom(address from, address to, uint tokens)
159     public
160     returns (bool success)
161   {
162     balances[from] = balances[from].sub(tokens);
163     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
164     balances[to] = balances[to].add(tokens);
165     emit Transfer(from, to, tokens);
166     return true;
167   }
168 
169 
170   // ------------------------------------------------------------------------
171   // Returns the amount of tokens approved by the owner that can be
172   // transferred to the spender's account
173   // ------------------------------------------------------------------------
174   function allowance(address tokenOwner, address spender)
175     public
176     constant
177     returns (uint remaining)
178   {
179     return allowed[tokenOwner][spender];
180   }
181 
182 
183   // ------------------------------------------------------------------------
184   // Token owner can approve for `spender` to transferFrom(...) `tokens`
185   // from the token owner's account. The `spender` contract function
186   // `receiveApproval(...)` is then executed
187   // ------------------------------------------------------------------------
188   //"0x1439818dd11823c45fff01af0cd6c50934e27ac0",180,"0x14723a09acff6d2a60dcdf7aa4aff308fddc160c","0x7465737400000000000000000000000000000000000000000000000000000000",20,22,2
189   function approveAndCall(address spender, uint tokens, address _owneraddress, bytes32 _houseinfo, uint _from, uint _to ,uint _days)
190      public
191     returns (address _preorder)
192   {
193     allowed[msg.sender][spender] = tokens;
194     emit Approval(msg.sender, spender, tokens);
195     return HouseInfoListing(spender).preOrder(msg.sender,_owneraddress, _houseinfo, _from, _to,_days);
196   }
197 
198 
199   // ------------------------------------------------------------------------
200   // Don't accept ETH
201   // ------------------------------------------------------------------------
202   function ()
203     public
204     payable
205   {
206     revert();
207   }
208 
209 
210   // ------------------------------------------------------------------------
211   // Owner can transfer out any accidentally sent ERC20 tokens
212   // ------------------------------------------------------------------------
213   function transferAnyERC20Token(address tokenAddress, uint tokens)
214     public
215     onlyOwner
216     returns (bool success)
217   {
218     return ERC20Interface(tokenAddress).transfer(owner, tokens);
219   }
220 
221 }
222 
223 contract HouseInfoListing{
224    address public tokenAddress;//tokenAddress used to pay 
225    
226    bytes32[] private districtcode;//district code
227    address private contractowner;
228    
229    address public preOrderaddressfortest;
230    uint public transferPriceForTest;
231    
232    
233    function HouseInfoListing(address _tokenAddress)
234    payable
235    public{
236        tokenAddress   = _tokenAddress;
237        contractowner  = msg.sender; 
238    }
239    
240    
241  function setDistrictCode(bytes32 _districtcode) 
242    public 
243    returns(bool success)
244   {
245     if(msg.sender!= contractowner)
246     return false;
247     districtcode.push(_districtcode);
248     return true;
249   }
250    
251    function getDistrictCode() 
252    public 
253    view
254    returns(bytes32[] _districtcode)
255   {
256     return districtcode;
257   }
258    
259     
260     
261   struct HouseInfo {
262     string  roominfo;
263     uint    price;
264     uint    contractdatetime;
265     uint    state;//0 close , 1 open
266     address owner;
267   
268   }
269   
270   mapping ( address => bytes32[] ) private hostRoomList;//every house info has one uuid,find house info by host address
271                                                       
272   
273   
274   mapping ( bytes32 => HouseInfo ) private houseInfo;   //describ the house information
275   mapping ( bytes32 => bytes32[] ) private uuids;       //every house info has one uuid,find house info by districtcode
276                                                         //should add find house info by city street 
277                                                         
278                                                         
279   //通过房屋信息uuid确定预定合约信息                                                        
280   mapping ( bytes32 => address[] ) private PreOrders;   
281                                                         //find preorders lists by house info uuid 
282                                                         //find preOrder or order infomation from this connection 
283   //通过房客address找到合约信息
284   mapping (address => address[]) private GuestOrders;   //find guest orders by guest address
285   
286   //通过房东address找到合约信息
287   mapping (address => address[]) private HouseOwnerOrders;//find house owner orders by house owner address
288   
289   
290   
291   function preOrder( address _guestaddress,address _hostaddress, bytes32 _houseinfo, uint _from, uint _to, uint _days)
292   payable
293   public
294   returns (address _contractaddress)
295   {
296       uint transferPrice = _days * houseInfo[_houseinfo].price;
297       transferPriceForTest = transferPrice;
298       PreOrder preorder = new PreOrder( tokenAddress , _hostaddress , _guestaddress , _houseinfo , _from , _to , _days , 0 ,transferPrice );
299       preOrderaddressfortest =preorder;
300          if(Token(tokenAddress).transferFrom(_guestaddress,preorder,transferPrice))//transfer token to contract address
301          {
302              
303             PreOrders[_houseinfo].push(preorder); 
304             GuestOrders[_guestaddress].push(preorder);
305             HouseOwnerOrders[_hostaddress].push(preorder);
306             return address(preorder);
307              
308          }
309          else
310          {
311              //transfer token failure
312              return ;
313          }
314       
315       
316       return ;
317       
318   }
319   //"test",9,"roominfo","test","0x3333322d30303332000000000000000000000000000000000000000000000000"
320    function setHouseInfo(bytes32 _uuid,uint _price,string _roominfo,bytes32 _districtcode) 
321    public 
322    returns(bool success)
323   {
324     houseInfo[_uuid] = HouseInfo(
325       {
326         roominfo: _roominfo,
327         price   : _price,
328         contractdatetime:block.timestamp,
329         owner   : msg.sender,
330         state   : 1
331       });
332               
333     uuids[_districtcode].push(_uuid);
334     hostRoomList[msg.sender].push(_uuid);
335     return true;
336   }
337   
338   function getHostRoomLists(address _hostaddress)
339     view
340     public
341     returns(bytes32[] _hostRoomList)
342   {
343     return hostRoomList[_hostaddress];
344   }
345     
346     
347   function getGuestOrders(address _guestaddress)
348   view
349   public
350   returns (address[] _guestOrders)
351   {
352       return GuestOrders[_guestaddress];
353   }
354   
355   function getHostOrders(address _hostaddress)
356   view
357   public
358   returns (address[] _hostOrders)
359   {
360       return HouseOwnerOrders[_hostaddress];
361   }
362   
363   function getPreorders(bytes32 _houseinfo)
364   view
365   public
366   returns (address[] _preorders)
367   {
368       return PreOrders[_houseinfo];
369   }
370   
371   
372   
373   function getUUIDS(bytes32 _districtcode)
374     view
375     public
376     returns(bytes32[] _uuid)
377   {
378     return uuids[_districtcode];
379   }
380     
381   function getHouseInfo(bytes32 _uuid)
382     view
383     public
384     returns (uint _price, uint _contractdatetime, address _owner,uint _state,string _roominfo)
385   {
386     //check the contract list, the most important thing is that if state is 0, that means this house had been rented.
387     return (
388       houseInfo[_uuid].price,
389       houseInfo[_uuid].contractdatetime,
390       houseInfo[_uuid].owner,
391       houseInfo[_uuid].state,
392       houseInfo[_uuid].roominfo
393     );
394   }
395  
396 }
397 
398 
399 
400 
401 
402 contract PreOrder{
403     address public tokenAddress;
404     address public owneraddress;
405     address public guestaddress;
406     bytes32 public houseinfo;
407     uint public from;
408     uint public to;
409     uint public rentDays;
410     uint public status;//0:preorder 1: success  -1: cancel
411     uint public price;
412     
413     
414     function PreOrder (
415                         address _tokenAddress, 
416                         address _owneraddress,
417                         address _guestaddress,
418                         bytes32 _houseinfo,
419                         uint _from,
420                         uint _to,
421                         uint _days,
422                         uint _status,
423                         uint _price
424                     ) 
425     payable public{
426         tokenAddress = _tokenAddress;
427         owneraddress = _owneraddress;
428         guestaddress = _guestaddress;
429         houseinfo    = _houseinfo;
430         from         = _from;
431         to           = _to;
432         rentDays     = _days;
433         status       = _status;
434         price        = _price;
435         
436     }
437     
438     function getPreorderInfo()
439     view
440     public
441     returns (
442                 address _tokenAddress, 
443                 address _owneraddress,
444                 address _guestaddress,
445                 bytes32 _houseinfo,
446                 uint _from,
447                 uint _to,
448                 uint _days,
449                 uint _status,
450                 uint _price
451             ) 
452     {
453     //check the contract list, the most important thing is that if state is 0, that means this house had been rented.
454     return (
455         tokenAddress ,
456         owneraddress ,
457         guestaddress ,
458         houseinfo    ,
459         from         ,
460         to           ,
461         rentDays     ,
462         status       ,
463         price        
464     );
465     }
466     
467     
468     
469     function confirmOrder()
470     payable
471     public
472     returns(bool success)
473     {
474        if( msg.sender == guestaddress && status == 0)   
475        {
476             if(Token(tokenAddress).transfer(owneraddress,price))//transfer token to contract address
477          {
478              
479             status = 1;
480             return true;
481              
482          }
483          else
484          {
485              //transfer token failure
486              return false;
487          }
488            
489        }
490       //1 transfer token from contract address to guest address
491       //2 if step 1 successfully finished, update info of preOrder contract
492       //3 if step 1 successfully finished, remove order info from PreOrders lists
493       return true;
494    }
495     
496     bool private houseOwnerAgreeToCancel = false;
497     bool private guestAgreeToCancel      = false;
498 //     function cancelOrder()
499 //     public
500 //     returns(bool success)
501 //     {
502 //       //both of house owner and guest should be agreed to cancel this contract then the Token in this contract can send back
503 
504 //       //1 transfer token from contract address to guest address
505 //       //2 if step 1 successfully finished, update info of preOrder contract
506 //       return true;
507 //   }
508     
509     
510 }
511 
512 
513 
514 contract Token {
515 
516   event Transfer(address indexed from, address indexed to, uint tokens);
517   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
518 
519   function totalSupply() public constant returns (uint);
520   function balanceOf(address tokenOwner) public constant returns (uint balance);
521   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
522   function transfer(address to, uint tokens) public returns (bool success);
523   function approve(address spender, uint tokens) public returns (bool success);
524   function transferFrom(address from, address to, uint tokens) public returns (bool success);
525 
526 }