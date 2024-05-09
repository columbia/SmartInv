1 pragma solidity ^0.4.24;
2 
3 /**
4  * luck100.win - Fair Ethereum game platform
5  * 
6  * OutLuck100
7  * More exciting game than Fomo3D
8  * 
9  * 1. One out of every three new coupons will be awarded 180% of the proceeds;
10  * 
11  * 2. Inviting others to buy lottery tickets can permanently earn 10% of the proceeds;
12  * 
13  * 3. 1% income per day sign-in
14  */
15  
16 contract Ownable {
17   address public owner;
18   address public admin;
19   uint256 public lockedIn;
20   uint256 public OWNER_AMOUNT;
21   uint256 public OWNER_PERCENT = 2;
22   uint256 public OWNER_MIN = 0.0001 ether;
23 
24   event OwnershipRenounced(address indexed previousOwner);
25   event OwnershipTransferred(
26     address indexed previousOwner,
27     address indexed newOwner
28   );
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   constructor(address addr, uint256 percent, uint256 min) public {
36     require(addr != address(0), 'invalid addr');
37     owner = msg.sender;
38     admin = addr;
39     OWNER_PERCENT = percent;
40     OWNER_MIN = min;
41   }
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(msg.sender==owner || msg.sender==admin);
48     _;
49   }
50 
51   /**
52    * @dev Allows the current owner to relinquish control of the contract.
53    * @notice Renouncing to ownership will leave the contract without an owner.
54    * It will not be possible to call the functions with the `onlyOwner`
55    * modifier anymore.
56    */
57   function renounceOwnership() public onlyOwner {
58     emit OwnershipRenounced(owner);
59     owner = address(0);
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param _newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address _newOwner) public onlyOwner {
67     _transferOwnership(_newOwner);
68   }
69 
70   /**
71    * @dev Transfers control of the contract to a newOwner.
72    * @param _newOwner The address to transfer ownership to.
73    */
74   function _transferOwnership(address _newOwner) internal {
75     require(_newOwner != address(0));
76     emit OwnershipTransferred(owner, _newOwner);
77     owner = _newOwner;
78   }
79 
80   function _cash() public view returns(uint256){
81       return address(this).balance;
82   }
83 
84   /*function kill() onlyOwner public{
85     require(lockedIn == 0, "invalid lockedIn");
86     selfdestruct(owner);
87   }*/
88 
89   function setAdmin(address addr) onlyOwner public{
90       require(addr != address(0), 'invalid addr');
91       admin = addr;
92   }
93 
94   function setOwnerPercent(uint256 percent) onlyOwner public{
95       OWNER_PERCENT = percent;
96   }
97 
98   function setOwnerMin(uint256 min) onlyOwner public{
99       OWNER_MIN = min;
100   }
101 
102   function _fee() internal returns(uint256){
103       uint256 fe = msg.value*OWNER_PERCENT/100;
104       if(fe < OWNER_MIN){
105           fe = OWNER_MIN;
106       }
107       OWNER_AMOUNT += fe;
108       return fe;
109   }
110 
111   function cashOut() onlyOwner public{
112     require(OWNER_AMOUNT > 0, 'invalid OWNER_AMOUNT');
113     owner.send(OWNER_AMOUNT);
114   }
115 
116   modifier isHuman() {
117       address _addr = msg.sender;
118       uint256 _codeLength;
119       assembly {_codeLength := extcodesize(_addr)}
120       require(_codeLength == 0, "sorry humans only");
121       _;
122   }
123 
124   modifier isContract() {
125       address _addr = msg.sender;
126       uint256 _codeLength;
127       assembly {_codeLength := extcodesize(_addr)}
128       require(_codeLength > 0, "sorry contract only");
129       _;
130   }
131 }
132 
133 contract OutLuck100 is Ownable{
134   event recEvent(address indexed addr, uint256 amount, uint8 tn, uint256 ts);
135 
136   struct CardType{
137       uint256 price;
138       uint256 signCount;
139       uint8 signRate;
140       uint8 outRate;
141   }
142   struct Card{
143       address holder;
144       uint256 blockNumber;
145       uint256 signCount;
146       uint256 sn;
147       uint8 typeId;
148       bool isOut;
149   }
150   struct User{
151       address parentAddr;
152       uint256 balance;
153       uint256[] cids;
154       address[] subs;
155   }
156 
157   User _u;
158   CardType[4] public cts;
159   Card[] public cardList;
160   uint256[] cardIds1;
161   uint256[] cardIds2;
162   uint256[] cardIds3;
163   mapping(address=>User) public userList;
164   mapping(address=>bool) public userExists;
165   mapping(bytes6=>address) public codeList;
166   uint256 pool_sign = 0;
167   uint256 constant public PAY_LIMIT = 0.1 ether;
168   uint256 constant public DAY_STEP = 5900;
169   uint8 constant public MOD = 3;
170   uint8 constant public inviteRate = 10;
171   uint8 constant public signRate = 38;
172 
173   constructor(address addr, uint256 percent, uint256 min) Ownable(addr, percent, min) public{
174       cts[0] = CardType({price:0, signCount:0, signRate:0, outRate:0});
175       cts[1] = CardType({price:0.5 ether, signCount:100, signRate:1, outRate:120});
176       cts[2] = CardType({price:1 ether, signCount:130, signRate:1, outRate:150});
177       cts[3] = CardType({price:2 ether, signCount:150, signRate:1, outRate:180});
178   }
179 
180   function() public payable{
181 
182   }
183 
184   function buyCode(bytes6 mcode) onlyOwner public payable{
185       require(codeList[mcode]==address(0), 'code is Exists');
186       codeList[mcode] = msg.sender;
187   }
188 
189   function buyCard(bytes6 pcode, bytes6 mcode) public payable{
190       require(pcode!=mcode, 'code is invalid');
191       uint256 amount = msg.value;
192       uint8 typeId = 0;
193       for(uint8 i=1;i<cts.length;i++){
194           if(amount==cts[i].price){
195               typeId = i;
196               break;
197           }
198       }
199       require(typeId>0, 'pay amount is valid');
200 
201       _fee();
202       pool_sign += amount*signRate/100;
203       emit recEvent(msg.sender, amount, 1, now);
204 
205       if(!userExists[msg.sender]){//创建用户
206           userExists[msg.sender] = true;
207           userList[msg.sender] = _u;
208           address parentAddr = codeList[pcode];
209           if(parentAddr!=address(0)){
210               if(!userExists[parentAddr]){
211                   userExists[parentAddr] = true;
212                   userList[parentAddr] = _u;
213               }
214               userList[msg.sender].parentAddr = parentAddr;
215               userList[parentAddr].subs.push(msg.sender);
216           }
217       }
218 
219       User storage me = userList[msg.sender];
220       uint256 cid = cardList.length;
221       me.cids.push(cid);
222       if(me.parentAddr!=address(0)){
223           uint256 e = amount*inviteRate/100;
224           userList[me.parentAddr].balance += e;
225           emit recEvent(me.parentAddr, e, 2, now);
226           payment(me.parentAddr);
227       }
228 
229       cardList.push(Card({
230           holder:msg.sender,
231           blockNumber:block.number,
232           signCount:0,
233           sn:0,
234           typeId:typeId,
235           isOut:false
236       }));
237 
238       if(typeId==1){
239           cardIds1.push(cid);
240           out(cardIds1);
241       }else if(typeId==2){
242           cardIds2.push(cid);
243           out(cardIds2);
244       }else if(typeId==3){
245           cardIds3.push(cid);
246           out(cardIds3);
247       }
248 
249       if(codeList[mcode]==address(0) && typeId>1){
250          codeList[mcode] = msg.sender;
251          emit recEvent(msg.sender, 0, 6, now);
252       }
253   }
254 
255   function sign() public payable{
256       User storage me = userList[msg.sender];
257       CardType memory ct = cts[0];
258       uint256[] memory cids = me.cids;
259       uint256 e = 0;
260       uint256 s = 0;
261       uint256 n = 0;
262       for(uint256 i=0;i<cids.length;i++){
263           Card storage c = cardList[cids[i]];
264           ct = cts[c.typeId];
265           if(c.signCount>=ct.signCount || c.blockNumber+DAY_STEP>block.number) continue;
266           n = (block.number-c.blockNumber)/DAY_STEP;
267           if(c.signCount+n>=ct.signCount){
268               c.signCount = ct.signCount;
269           }else{
270               c.signCount += n;
271           }
272           c.sn++;
273           c.blockNumber = block.number;
274           e = ct.price*ct.signRate/100;
275           s += e;
276       }
277       if(s==0) return ;
278       emit recEvent(msg.sender, s, 4, now);
279       if(pool_sign<s) return ;
280       me.balance += s;
281       pool_sign -= s;
282       payment(msg.sender);
283   }
284 
285   function out(uint256[] cids) private{
286       uint256 len = cids.length;
287       if(len<MOD) return ;
288       uint256 outIdx = len-1;
289       if(outIdx%MOD!=0) return ;
290       outIdx = cids[outIdx/MOD-1];
291       Card storage outCard = cardList[outIdx];
292       if(outCard.isOut) return ;
293       outCard.isOut = true;
294       CardType memory ct = cts[outCard.typeId];
295       uint256 e = ct.price*ct.outRate/100;
296       userList[outCard.holder].balance += e;
297       emit recEvent(outCard.holder, e, 3, now);
298       payment(outCard.holder);
299   }
300 
301   function payment(address addr) private{
302       User storage me = userList[addr];
303       uint256 ba = me.balance;
304       if(ba >= PAY_LIMIT){
305           me.balance = 0;
306           addr.send(ba);
307           emit recEvent(addr, ba, 5, now);
308       }
309   }
310   
311   function getUserInfo(address addr, bytes6 mcode) public view returns(
312     address parentAddr,
313     address codeAddr,
314     uint256 balance,
315     address[] subs,
316     uint256[] cids
317     ){
318       User memory me = userList[addr];
319       parentAddr = me.parentAddr;
320       codeAddr = codeList[mcode];
321       balance = me.balance;
322       subs = me.subs;
323       cids = me.cids;
324     }
325 
326   function getUser(address addr) public view returns(
327     uint256 balance,
328     address[] subs,
329     uint256[] cids,
330     uint256[] bns,
331     uint256[] scs,
332     uint256[] sns,
333     uint8[] ts,
334     bool[] os
335   ){
336       User memory me = userList[addr];
337       balance = me.balance;
338       subs = me.subs;
339       cids = me.cids;
340       uint256 len = cids.length;
341       if(len==0) return ;
342       bns = new uint256[](len);
343       scs = new uint256[](len);
344       sns = new uint256[](len);
345       ts = new uint8[](len);
346       os = new bool[](len);
347       for(uint256 i=0;i<len;i++){
348           Card memory c = cardList[cids[i]];
349           bns[i] = c.blockNumber;
350           scs[i] = c.signCount;
351           sns[i] = c.sn;
352           ts[i] = c.typeId;
353           os[i] = c.isOut;
354       }
355   }
356 }