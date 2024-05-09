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
169   function allowance(address tokenOwner, address spender)
170     public
171     constant
172     returns (uint remaining)
173   {
174     return allowed[tokenOwner][spender];
175   }
176 
177 
178  function approveAndCall(address spender, uint tokens, address _owneraddress, bytes32 _houseinfo, uint _from, uint _to ,uint _days)
179      public
180     returns (address _preorder)
181   {
182     allowed[msg.sender][spender] = tokens;
183     emit Approval(msg.sender, spender, tokens);
184     return HouseInfoListing(spender).preOrder(msg.sender,_owneraddress, _houseinfo, _from, _to,_days);
185   }
186 
187 
188 
189   function ()
190     public
191     payable
192   {
193     revert();
194   }
195 
196 
197   function transferAnyERC20Token(address tokenAddress, uint tokens)
198     public
199     onlyOwner
200     returns (bool success)
201   {
202     return ERC20Interface(tokenAddress).transfer(owner, tokens);
203   }
204   
205   function approveAndCall1(address spender, uint tokens, bytes data) public returns (bool success) {
206         allowed[msg.sender][spender] = tokens;
207         emit Approval(msg.sender, spender, tokens);
208         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
209         return true;
210 }
211 
212 }
213 
214 contract ApproveAndCallFallBack {
215     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
216 }
217 
218 contract HouseInfoListing{
219    address public tokenAddress;//tokenAddress used to pay 
220    
221    bytes32[] private districtcode;//district code
222    address private contractowner;
223    
224    address public preOrderaddressfortest;
225    uint public transferPriceForTest;
226    
227    
228    function HouseInfoListing(address _tokenAddress)
229    payable
230    public{
231        tokenAddress   = _tokenAddress;
232        contractowner  = msg.sender; 
233    }
234    
235    
236  function setDistrictCode(bytes32 _districtcode) 
237    public 
238    returns(bool success)
239   {
240     if(msg.sender!= contractowner)
241     return false;
242     districtcode.push(_districtcode);
243     return true;
244   }
245    
246    function getDistrictCode() 
247    public 
248    view
249    returns(bytes32[] _districtcode)
250   {
251     return districtcode;
252   }
253    
254     
255     
256   struct HouseInfo {
257     string  roominfo;
258     uint    price;
259     uint    contractdatetime;
260     uint    state;//0 close , 1 open
261     address owner;
262   
263   }
264   
265   mapping ( address => bytes32[] ) private hostRoomList;//every house info has one uuid,find house info by host address
266                                                       
267   
268   
269   mapping ( bytes32 => HouseInfo ) private houseInfo;   //describ the house information
270   mapping ( bytes32 => bytes32[] ) private uuids;       //every house info has one uuid,find house info by districtcode
271                                                         //should add find house info by city street 
272                                                         
273                                                         
274   //通过房屋信息uuid确定预定合约信息                                                        
275   mapping ( bytes32 => address[] ) private PreOrders;   
276                                                         //find preorders lists by house info uuid 
277                                                         //find preOrder or order infomation from this connection 
278   //通过房客address找到合约信息
279   mapping (address => address[]) private GuestOrders;   //find guest orders by guest address
280   
281   //通过房东address找到合约信息
282   mapping (address => address[]) private HouseOwnerOrders;//find house owner orders by house owner address
283   
284   
285   
286   function preOrder( address _guestaddress,address _hostaddress, bytes32 _houseinfo, uint _from, uint _to, uint _days)
287   payable
288   public
289   returns (address _contractaddress)
290   {
291       uint transferPrice = _days * houseInfo[_houseinfo].price;
292       transferPriceForTest = transferPrice;
293       PreOrder preorder = new PreOrder( tokenAddress , _hostaddress , _guestaddress , _houseinfo , _from , _to , _days , 0 ,transferPrice );
294       preOrderaddressfortest =preorder;
295          if(Token(tokenAddress).transferFrom(_guestaddress,preorder,transferPrice))//transfer token to contract address
296          {
297              
298             PreOrders[_houseinfo].push(preorder); 
299             GuestOrders[_guestaddress].push(preorder);
300             HouseOwnerOrders[_hostaddress].push(preorder);
301             return address(preorder);
302              
303          }
304          else
305          {
306              //transfer token failure
307              return ;
308          }
309       
310       
311       return ;
312       
313   }
314   //"test",9,"roominfo","test","0x3333322d30303332000000000000000000000000000000000000000000000000"
315    function setHouseInfo(bytes32 _uuid,uint _price,string _roominfo,bytes32 _districtcode) 
316    public 
317    returns(bool success)
318   {
319     houseInfo[_uuid] = HouseInfo(
320       {
321         roominfo: _roominfo,
322         price   : _price,
323         contractdatetime:block.timestamp,
324         owner   : msg.sender,
325         state   : 1
326       });
327               
328     uuids[_districtcode].push(_uuid);
329     hostRoomList[msg.sender].push(_uuid);
330     return true;
331   }
332   
333   function getHostRoomLists(address _hostaddress)
334     view
335     public
336     returns(bytes32[] _hostRoomList)
337   {
338     return hostRoomList[_hostaddress];
339   }
340     
341     
342   function getGuestOrders(address _guestaddress)
343   view
344   public
345   returns (address[] _guestOrders)
346   {
347       return GuestOrders[_guestaddress];
348   }
349   
350   function getHostOrders(address _hostaddress)
351   view
352   public
353   returns (address[] _hostOrders)
354   {
355       return HouseOwnerOrders[_hostaddress];
356   }
357   
358   function getPreorders(bytes32 _houseinfo)
359   view
360   public
361   returns (address[] _preorders)
362   {
363       return PreOrders[_houseinfo];
364   }
365   
366   
367   
368   function getUUIDS(bytes32 _districtcode)
369     view
370     public
371     returns(bytes32[] _uuid)
372   {
373     return uuids[_districtcode];
374   }
375     
376   function getHouseInfo(bytes32 _uuid)
377     view
378     public
379     returns (uint _price, uint _contractdatetime, address _owner,uint _state,string _roominfo)
380   {
381     //check the contract list, the most important thing is that if state is 0, that means this house had been rented.
382     return (
383       houseInfo[_uuid].price,
384       houseInfo[_uuid].contractdatetime,
385       houseInfo[_uuid].owner,
386       houseInfo[_uuid].state,
387       houseInfo[_uuid].roominfo
388     );
389   }
390  
391 }
392 
393 
394 
395 
396 
397 contract PreOrder{
398     address public tokenAddress;
399     address public owneraddress;
400     address public guestaddress;
401     bytes32 public houseinfo;
402     uint public from;
403     uint public to;
404     uint public rentDays;
405     uint public status;//0:preorder 1: success  -1: cancel
406     uint public price;
407     
408     
409     function PreOrder (
410                         address _tokenAddress, 
411                         address _owneraddress,
412                         address _guestaddress,
413                         bytes32 _houseinfo,
414                         uint _from,
415                         uint _to,
416                         uint _days,
417                         uint _status,
418                         uint _price
419                     ) 
420     payable public{
421         tokenAddress = _tokenAddress;
422         owneraddress = _owneraddress;
423         guestaddress = _guestaddress;
424         houseinfo    = _houseinfo;
425         from         = _from;
426         to           = _to;
427         rentDays     = _days;
428         status       = _status;
429         price        = _price;
430         
431     }
432     
433     function getPreorderInfo()
434     view
435     public
436     returns (
437                 address _tokenAddress, 
438                 address _owneraddress,
439                 address _guestaddress,
440                 bytes32 _houseinfo,
441                 uint _from,
442                 uint _to,
443                 uint _days,
444                 uint _status,
445                 uint _price
446             ) 
447     {
448     //check the contract list, the most important thing is that if state is 0, that means this house had been rented.
449     return (
450         tokenAddress ,
451         owneraddress ,
452         guestaddress ,
453         houseinfo    ,
454         from         ,
455         to           ,
456         rentDays     ,
457         status       ,
458         price        
459     );
460     }
461     
462     
463     
464     function confirmOrder()
465     payable
466     public
467     returns(bool success)
468     {
469        if( msg.sender == guestaddress && status == 0)   
470        {
471             if(Token(tokenAddress).transfer(owneraddress,price))//transfer token to contract address
472          {
473              
474             status = 1;
475             return true;
476              
477          }
478          else
479          {
480              //transfer token failure
481              return false;
482          }
483            
484        }
485       //1 transfer token from contract address to guest address
486       //2 if step 1 successfully finished, update info of preOrder contract
487       //3 if step 1 successfully finished, remove order info from PreOrders lists
488       return true;
489    }
490     
491     bool private houseOwnerAgreeToCancel = false;
492     bool private guestAgreeToCancel      = false;
493 //     function cancelOrder()
494 //     public
495 //     returns(bool success)
496 //     {
497 //       //both of house owner and guest should be agreed to cancel this contract then the Token in this contract can send back
498 
499 //       //1 transfer token from contract address to guest address
500 //       //2 if step 1 successfully finished, update info of preOrder contract
501 //       return true;
502 //   }
503     
504     
505 }
506 
507 
508 
509 contract Token {
510 
511   event Transfer(address indexed from, address indexed to, uint tokens);
512   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
513 
514   function totalSupply() public constant returns (uint);
515   function balanceOf(address tokenOwner) public constant returns (uint balance);
516   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
517   function transfer(address to, uint tokens) public returns (bool success);
518   function approve(address spender, uint tokens) public returns (bool success);
519   function transferFrom(address from, address to, uint tokens) public returns (bool success);
520 
521 }