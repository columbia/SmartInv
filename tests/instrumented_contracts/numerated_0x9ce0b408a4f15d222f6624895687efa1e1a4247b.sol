1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4 
5   /**0
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 /**
46  * @title SafeMath32
47  * @dev SafeMath library implemented for uint32
48  */
49 library SafeMath32 {
50 
51   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
52     if (a == 0) {
53       return 0;
54     }
55     uint32 c = a * b;
56     assert(c / a == b);
57     return c;
58   }
59 
60   function div(uint32 a, uint32 b) internal pure returns (uint32) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint32 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   function add(uint32 a, uint32 b) internal pure returns (uint32) {
73     uint32 c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 /**
80  * @title SafeMath16
81  * @dev SafeMath library implemented for uint16
82  */
83 library SafeMath16 {
84 
85   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
86     if (a == 0) {
87       return 0;
88     }
89     uint16 c = a * b;
90     assert(c / a == b);
91     return c;
92   }
93 
94   function div(uint16 a, uint16 b) internal pure returns (uint16) {
95     // assert(b > 0); // Solidity automatically throws when dividing by 0
96     uint16 c = a / b;
97     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98     return c;
99   }
100 
101   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   function add(uint16 a, uint16 b) internal pure returns (uint16) {
107     uint16 c = a + b;
108     assert(c >= a);
109     return c;
110   }
111 }
112 
113 contract ETHERKUN {
114   address public owner;
115 
116   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
117 
118   /**
119    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
120    * account.
121    */
122  function ETHERKUN() public {
123     owner = msg.sender;
124  }
125 
126 
127   /**
128    * @dev Throws if called by any account other than the owner.
129    */
130   modifier onlyOwner() {
131     require(msg.sender == owner);
132     _;
133   }
134 
135 
136   /**
137    * @dev Allows the current owner to transfer control of the contract to a newOwner.
138    * @param newOwner The address to transfer ownership to.
139    */
140   function transferOwnership(address newOwner) public onlyOwner {
141     require(newOwner != address(0));
142     OwnershipTransferred(owner, newOwner);
143     owner = newOwner;
144   }
145     
146     using SafeMath for uint256;
147     uint cooldownTime = 10 minutes;
148     
149     struct kun {
150         uint price;
151         uint atk;
152         uint readyTime;
153     }
154     
155     kun[] public kuns;
156     
157     mapping (uint => address) public kunToOwner;
158     
159     function getKun() external {
160         uint id = kuns.push(kun(0, 0, now)) - 1;
161         kunToOwner[id] = msg.sender;
162     }
163     
164     //查询拥有的kun
165   function getKunsByOwner(address _owner) external view returns(uint[]) {
166     uint[] memory result = new uint[](kuns.length);
167     uint counter = 0;
168     for (uint i = 0; i < kuns.length; i++) {
169       if (kunToOwner[i] == _owner) {
170         result[counter] = i;
171         counter++;
172       }
173     }
174     return result;
175   }
176   
177   function getKunsNum() external view returns(uint) {
178     return kuns.length;
179   }
180   
181   //
182   function getBattleKuns(uint _price) external view returns(uint[]) {
183     uint[] memory result = new uint[](kuns.length);
184     uint counter = 0;
185     for (uint i = 0; i < kuns.length; i++) {
186       if (kuns[i].price > _price && kunToOwner[i] != msg.sender) {
187         result[counter] = i;
188         counter++;
189       }
190     }
191     return result;
192   }
193   
194   uint randNonce = 0;
195     //Evolution price
196     uint public testFee = 0.001 ether;
197   
198   event Evolution(address indexed owner, uint kunId,uint newAtk, uint oldAtk);
199   event KunSell(address indexed owner, uint kunId,uint price);
200   
201   function randMod() internal returns(uint) {
202     randNonce = randNonce.add(1);
203     return uint(keccak256(now, randNonce, block.blockhash(block.number - 1), block.coinbase)) % 100;
204   }
205   
206   //owner可以调整费率
207   function setTestFee(uint _fee) external onlyOwner {
208     testFee = _fee;
209   }
210   //检查必须是拥有者
211   modifier onlyOwnerOf(uint _kunId) {
212     require(msg.sender == kunToOwner[_kunId]);
213     _;
214   }
215   
216     //进入冷却 change to uint
217   function _triggerCooldown(kun storage _kun) internal {
218     _kun.readyTime = uint(now + cooldownTime);
219   }
220 
221   //test逻辑
222   function feed1(uint _kunId) external onlyOwnerOf(_kunId) payable {
223     require(msg.value == testFee);
224     kun storage mykun = kuns[_kunId];
225     uint oldAtk = mykun.atk;
226     uint random = randMod();
227     if (random < 20) {
228         mykun.atk = mykun.atk.add(50);
229     } else if (random < 70) {
230         mykun.atk = mykun.atk.add(100);
231     } else if (random < 90) {
232         mykun.atk = mykun.atk.add(200);
233     } else {
234          mykun.atk = mykun.atk.add(500);
235     }
236     mykun.price = mykun.price.add(msg.value);
237     _triggerCooldown(mykun);
238     Evolution(msg.sender, _kunId, mykun.atk, oldAtk);
239   }
240   
241   function feed10(uint _kunId) external onlyOwnerOf(_kunId) payable {
242     require(msg.value == testFee * 10);
243     kun storage mykun = kuns[_kunId];
244     uint oldAtk = mykun.atk;
245     uint random = randMod();
246     if (random < 20) {
247         mykun.atk = mykun.atk.add(550);
248     } else if (random < 70) {
249         mykun.atk = mykun.atk.add(1100);
250     } else if (random < 90) {
251         mykun.atk = mykun.atk.add(2200);
252     } else {
253          mykun.atk = mykun.atk.add(5500);
254     }
255     mykun.price = mykun.price.add(msg.value);
256     _triggerCooldown(mykun);
257     Evolution(msg.sender, _kunId, mykun.atk, oldAtk);
258   }
259   
260   function feed50(uint _kunId) external onlyOwnerOf(_kunId) payable {
261     require(msg.value == testFee * 50);
262     kun storage mykun = kuns[_kunId];
263     uint oldAtk = mykun.atk;
264     uint random = randMod();
265     if (random < 20) {
266         mykun.atk = mykun.atk.add(2750);
267     } else if (random < 70) {
268         mykun.atk = mykun.atk.add(5500);
269     } else if (random < 90) {
270         mykun.atk = mykun.atk.add(11000);
271     } else {
272          mykun.atk = mykun.atk.add(27500);
273     }
274     mykun.price = mykun.price.add(msg.value);
275     _triggerCooldown(mykun);
276     Evolution(msg.sender, _kunId, mykun.atk, oldAtk);
277   }
278   
279   function feed100(uint _kunId) external onlyOwnerOf(_kunId) payable {
280     require(msg.value == testFee * 100);
281     kun storage mykun = kuns[_kunId];
282     uint oldAtk = mykun.atk;
283     uint random = randMod();
284     if (random < 20) {
285         mykun.atk = mykun.atk.add(6000);
286     } else if (random < 70) {
287         mykun.atk = mykun.atk.add(12000);
288     } else if (random < 90) {
289         mykun.atk = mykun.atk.add(24000);
290     } else {
291          mykun.atk = mykun.atk.add(60000);
292     }
293     mykun.price = mykun.price.add(msg.value);
294     _triggerCooldown(mykun);
295     Evolution(msg.sender, _kunId, mykun.atk, oldAtk);
296   }
297   
298   function feed100AndPay(uint _kunId) external onlyOwnerOf(_kunId) payable {
299     require(msg.value == testFee * 110);
300     kun storage mykun = kuns[_kunId];
301     uint oldAtk = mykun.atk;
302     mykun.atk = mykun.atk.add(60000);
303     mykun.price = mykun.price.add(testFee * 100);
304     owner.transfer(testFee * 10);
305     _triggerCooldown(mykun);
306     Evolution(msg.sender, _kunId, mykun.atk, oldAtk);
307   }
308     
309     //sellKun
310     function sellKun(uint _kunId) external onlyOwnerOf(_kunId) {
311         kun storage mykun = kuns[_kunId];
312         if(now > mykun.readyTime) {
313             msg.sender.transfer(mykun.price);
314              KunSell( msg.sender, _kunId, mykun.price);
315         } else{
316             uint award = mykun.price * 19 / 20;
317             msg.sender.transfer(award);
318             owner.transfer(mykun.price - award);
319              KunSell( msg.sender, _kunId, mykun.price * 19 / 20);
320         }
321         mykun.price = 0;
322         mykun.atk = 0;
323         kunToOwner[_kunId] = 0;
324     }
325     
326     event kunAttackResult(address indexed _from,uint atk1, address _to, uint atk2, uint random, uint price);
327   
328   //判断是否ready
329   function _isReady(kun storage _kun) internal view returns (bool) {
330       return (_kun.readyTime <= now);
331   }
332   
333   //attack
334   function attack(uint _kunId, uint _targetId) external onlyOwnerOf(_kunId) {
335     kun storage mykun = kuns[_kunId];
336     kun storage enemykun = kuns[_targetId]; 
337     require(_isReady(enemykun));
338     require(enemykun.atk > 299 && mykun.atk > 0);
339     uint rand = randMod();
340     uint probability = mykun.atk * 100 /(mykun.atk + enemykun.atk) ;
341     
342     if (rand < probability) {
343         //win
344         msg.sender.transfer(enemykun.price);
345         kunAttackResult(msg.sender, mykun.atk, kunToOwner[_targetId], enemykun.atk, rand, enemykun.price);
346         enemykun.price = 0;
347         enemykun.atk = 0;
348         mykun.readyTime = now;
349     } else {
350         //loss
351         uint award1 = mykun.price*9/10;
352         kunToOwner[_targetId].transfer(award1);
353         owner.transfer(mykun.price - award1);
354         kunAttackResult(msg.sender, mykun.atk, kunToOwner[_targetId], enemykun.atk, rand, mykun.price*9/10);
355         mykun.price = 0;
356         mykun.atk = 0;
357     }
358   }
359 }