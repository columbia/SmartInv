1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 contract BuildingStatus is Ownable {
45   /* Observer contract  */
46   address public observer;
47 
48   /* Crowdsale contract */
49   address public crowdsale;
50 
51   enum statusEnum {
52       crowdsale,
53       refund,
54       preparation_works,
55       building_permit,
56       design_technical_documentation,
57       utilities_outsite,
58       construction_residential,
59       frame20,
60       frame40,
61       frame60,
62       frame80,
63       frame100,
64       stage1,
65       stage2,
66       stage3,
67       stage4,
68       stage5,
69       facades20,
70       facades40,
71       facades60,
72       facades80,
73       facades100,
74       engineering,
75       finishing,
76       construction_parking,
77       civil_works,
78       engineering_further,
79       commisioning_project,
80       completed
81   }
82 
83   modifier notCompleted() {
84       require(status != statusEnum.completed);
85       _;
86   }
87 
88   modifier onlyObserver() {
89     require(msg.sender == observer || msg.sender == owner || msg.sender == address(this));
90     _;
91   }
92 
93   modifier onlyCrowdsale() {
94     require(msg.sender == crowdsale || msg.sender == owner || msg.sender == address(this));
95     _;
96   }
97 
98   statusEnum public status;
99 
100   event StatusChanged(statusEnum newStatus);
101 
102   function setStatus(statusEnum newStatus) onlyCrowdsale  public {
103       status = newStatus;
104       StatusChanged(newStatus);
105   }
106 
107   function changeStage(uint8 stage) public onlyObserver {
108       if (stage==1) status = statusEnum.stage1;
109       if (stage==2) status = statusEnum.stage2;
110       if (stage==3) status = statusEnum.stage3;
111       if (stage==4) status = statusEnum.stage4;
112       if (stage==5) status = statusEnum.stage5;
113   }
114  
115 }
116 
117 /*
118  * Manager that stores permitted addresses 
119  */
120 contract PermissionManager is Ownable {
121     mapping (address => bool) permittedAddresses;
122 
123     function addAddress(address newAddress) public onlyOwner {
124         permittedAddresses[newAddress] = true;
125     }
126 
127     function removeAddress(address remAddress) public onlyOwner {
128         permittedAddresses[remAddress] = false;
129     }
130 
131     function isPermitted(address pAddress) public view returns(bool) {
132         if (permittedAddresses[pAddress]) {
133             return true;
134         }
135         return false;
136     }
137 }
138 
139 contract ERC223Interface {
140   uint public totalSupply;
141   function balanceOf(address who) public view returns (uint);
142   function allowedAddressesOf(address who) public view returns (bool);
143   function getTotalSupply() public view returns (uint);
144 
145   function transfer(address to, uint value) public returns (bool ok);
146   function transfer(address to, uint value, bytes data) public returns (bool ok);
147   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
148 
149   event Transfer(address indexed from, address indexed to, uint value, bytes data);
150   event TransferContract(address indexed from, address indexed to, uint value, bytes data);
151 }
152 
153 /**
154  * @title Building Object contract.
155  * @author Vladimir Kovalchuk
156  */
157 contract Object is BuildingStatus {
158 
159   /* Name of an object */
160   string public name;
161 
162   /* Gross building area */
163   uint32 public gba;
164 
165   /* Gress sale area */
166   uint32 public gla;
167 
168   /* Parking space */
169   uint32 public parking;
170 
171   /* Type of the building */
172   enum unitEnum {appartment, residential}
173 
174   unitEnum public unit;
175 
176   /* Developer of an object */
177   string public developer;
178 
179   /* Leed */
180   string public leed;
181 
182   /* Location of an object */
183   string public location;
184 
185   /* start date of a project */
186   uint public constructionStart;
187 
188   /* end of construction of an object */
189   uint public constructionEnd;
190   // unt sqm
191   uint public untsqm;
192 
193   /* report of completion */
194   string public report;
195 
196   event ConstructionDateChanged(uint constructStart, uint constructEnd);
197   event PropertyChanged(uint32 gba, uint32 gla, uint32 parking, unitEnum unit, string developer,
198     string leed, string location, uint constructionStart, uint constructionEnd);
199 
200   event HoldChanged(address newHold);
201   event ObserverChanged(address newObserver);
202   event CrowdsaleChanged(address newCrowdsale);
203   event TokenChanged(address newCrowdsale);
204 
205   /* ERC223 Unity token */
206   ERC223Interface public token;
207 
208   /* Hold contract */
209   address public hold;
210 
211   /* Permission manager contract */
212   PermissionManager public permissionManager;
213 
214   modifier onlyPermitted() {
215     require(permissionManager.isPermitted(msg.sender) || msg.sender == owner || msg.sender == address(this));
216     _;
217   }
218 
219   event Completed(string report);
220 
221   /* Constructor of an object */
222   function Object(string iName, uint32 iGBA, uint32 iGSA, uint32 iParking, unitEnum iUnit,
223     string iDeveloper, string iLeed, string iLocation, uint iStartDate, uint iEndDate, uint UNTSQM,
224     address iToken, address iCrowdsale, address iObserver, address iHold, address pManager) public {
225       name = iName;
226       gba = iGBA;
227       gla = iGSA;
228       parking = iParking;
229       unit = iUnit;
230       developer = iDeveloper;
231       leed = iLeed;
232       location = iLocation;
233       untsqm = UNTSQM;
234       constructionStart = iStartDate;
235       constructionEnd = iEndDate;
236 
237       token = ERC223Interface(iToken);
238       crowdsale = iCrowdsale;
239       observer = iObserver;
240       hold = iHold;
241       permissionManager = PermissionManager(pManager);
242   }
243 
244   function setPermissionManager(address _permadr) public onlyOwner {
245     require(_permadr != 0x0);
246     permissionManager = PermissionManager(_permadr);
247   }
248 
249   /*
250    * Public setters area
251    */
252   function setGBA(uint32 newGBA) public onlyPermitted notCompleted {
253     gba = newGBA;
254     PropertyChanged(gba, gla, parking, unit, developer, leed, location, constructionStart, constructionEnd);
255   }
256 
257   function setGLA(uint32 newGLA) public onlyPermitted notCompleted {
258     gla = newGLA;
259     PropertyChanged(gba, gla, parking, unit, developer, leed, location, constructionStart, constructionEnd);
260   }
261 
262   function setParking(uint32 newParking) public onlyPermitted notCompleted {
263     parking = newParking;
264     PropertyChanged(gba, gla, parking, unit, developer, leed, location, constructionStart, constructionEnd);
265   }
266 
267   function setUnit(unitEnum newUnit) public onlyPermitted notCompleted {
268     unit = newUnit;
269     PropertyChanged(gba, gla, parking, unit, developer, leed, location, constructionStart, constructionEnd);
270   }
271 
272   function setDeveloper(string newDeveloper) public onlyPermitted notCompleted {
273     developer = newDeveloper;
274     PropertyChanged(gba, gla, parking, unit, developer, leed, location, constructionStart, constructionEnd);
275   }
276 
277   function setLeed(string newLeed) public onlyPermitted notCompleted {
278     leed = newLeed;
279     PropertyChanged(gba, gla, parking, unit, developer, leed, location, constructionStart, constructionEnd);
280   }
281 
282   function setLocation(string newLocation) public onlyPermitted notCompleted {
283     location = newLocation;
284     PropertyChanged(gba, gla, parking, unit, developer, leed, location, constructionStart, constructionEnd);
285   }
286 
287   function setStartDate(uint newStartDate) public onlyPermitted notCompleted {
288     constructionStart = newStartDate;
289     PropertyChanged(gba, gla, parking, unit, developer, leed, location, constructionStart, constructionEnd);
290   }
291 
292   function setEndDate(uint newEndDate) public onlyPermitted notCompleted {
293     constructionEnd = newEndDate;
294     PropertyChanged(gba, gla, parking, unit, developer, leed, location, constructionStart, constructionEnd);
295   }
296 
297 
298   function setName(string _name) public onlyPermitted notCompleted {
299     name = _name;
300     PropertyChanged(gba, gla, parking, unit, developer, leed, location, constructionStart, constructionEnd);
301   }
302   
303   function setUntsqm(uint _untsqm) public onlyPermitted notCompleted {
304     untsqm = _untsqm;
305     PropertyChanged(gba, gla, parking, unit, developer, leed, location, constructionStart, constructionEnd);
306   }
307 
308   function setObserver(address _observer) public onlyOwner {
309     require(_observer != 0x0);
310     observer = _observer;
311     ObserverChanged(_observer);
312   }
313 
314   function setToken(address _token) public onlyOwner {
315     require(_token != 0x0);
316     token = ERC223Interface(_token);
317     TokenChanged(_token);
318   }
319 
320   function setHold(address _hold) public onlyOwner {
321     require(_hold != 0x0);
322     hold = _hold;
323     HoldChanged(_hold);
324   }
325 
326   function setCrowdsale(address _crowdsale) public onlyOwner {
327     require(_crowdsale != 0x0);
328     crowdsale = _crowdsale;
329     CrowdsaleChanged(_crowdsale);
330   }
331 
332   function getTotalSupply() public view returns (uint) {
333     return token.getTotalSupply();
334   }
335 
336   function getUNTSQM() public view returns (uint) {
337     return untsqm;
338   }
339 
340   function setProperty(string property, string typeArg, uint intVal, string strVal) public onlyObserver {
341     string memory set = "set";
342     string memory s = "(";
343     string memory s2 = ")";
344     bytes memory _ba = bytes(set);
345     bytes memory _bb = bytes(property);
346     bytes memory _t = bytes(typeArg);
347     bytes memory _s = bytes(s);
348     bytes memory _s2 = bytes(s2);
349     string memory ab = new string(_ba.length + _bb.length + 1 + _t.length + 1);
350     bytes memory babcde = bytes(ab);
351     uint k = 0;
352 
353     for (uint i = 0; i < _ba.length; i++) {
354       babcde[k++] = _ba[i];
355     }
356     for (i = 0; i < _bb.length; i++) {
357       babcde[k++] = _bb[i];
358     }
359     babcde[k++] = _s[0];
360 
361     for (i = 0; i < _t.length; i++) {
362       babcde[k++] = _t[i];
363     }
364 
365     babcde[k++] = _s2[0];
366     if (intVal == 0) {
367       assert(this.call(bytes4(keccak256(string(babcde))), strVal));
368     } else {
369       assert(this.call(bytes4(keccak256(string(babcde))), intVal));
370     }
371   }
372 
373   function completeStatus(string newReport) public onlyOwner notCompleted {
374     status = statusEnum.completed;
375     report = newReport;
376     Completed(report);
377   }
378 
379 
380 }