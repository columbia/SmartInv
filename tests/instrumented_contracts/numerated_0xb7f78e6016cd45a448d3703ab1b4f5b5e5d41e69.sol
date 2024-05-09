1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.10;
7 
8 /*************************************************************************
9  * import "./FloorInvestRestrictions.sol" : start
10  *************************************************************************/
11 
12 /*************************************************************************
13  * import "./IInvestRestrictions.sol" : start
14  *************************************************************************/
15 
16 /*************************************************************************
17  * import "../common/Manageable.sol" : start
18  *************************************************************************/
19 
20 /*************************************************************************
21  * import "../common/Owned.sol" : start
22  *************************************************************************/
23 
24 
25 contract Owned {
26     address public owner;        
27 
28     function Owned() {
29         owner = msg.sender;
30     }
31 
32     // allows execution by the owner only
33     modifier ownerOnly {
34         assert(msg.sender == owner);
35         _;
36     }
37 
38     /**@dev allows transferring the contract ownership. */
39     function transferOwnership(address _newOwner) public ownerOnly {
40         require(_newOwner != owner);
41         owner = _newOwner;
42     }
43 }
44 /*************************************************************************
45  * import "../common/Owned.sol" : end
46  *************************************************************************/
47 
48 ///A token that have an owner and a list of managers that can perform some operations
49 ///Owner is always a manager too
50 contract Manageable is Owned {
51 
52     event ManagerSet(address manager, bool state);
53 
54     mapping (address => bool) public managers;
55 
56     function Manageable() Owned() {
57         managers[owner] = true;
58     }
59 
60     /**@dev Allows execution by managers only */
61     modifier managerOnly {
62         assert(managers[msg.sender]);
63         _;
64     }
65 
66     function transferOwnership(address _newOwner) public ownerOnly {
67         super.transferOwnership(_newOwner);
68 
69         managers[_newOwner] = true;
70         managers[msg.sender] = false;
71     }
72 
73     function setManager(address manager, bool state) ownerOnly {
74         managers[manager] = state;
75         ManagerSet(manager, state);
76     }
77 }/*************************************************************************
78  * import "../common/Manageable.sol" : end
79  *************************************************************************/
80 
81 /** @dev Restrictions on investment */
82 contract IInvestRestrictions is Manageable {
83     /**@dev Returns true if investmet is allowed */
84     function canInvest(address investor, uint amount, uint tokensLeft) constant returns (bool result) {
85         investor; amount; result; tokensLeft;
86     }
87 
88     /**@dev Called when investment was made */
89     function investHappened(address investor, uint amount) managerOnly {}    
90 }/*************************************************************************
91  * import "./IInvestRestrictions.sol" : end
92  *************************************************************************/
93 
94 /**@dev Allows only investments with large enough amount only  */
95 contract FloorInvestRestrictions is IInvestRestrictions {
96 
97     /**@dev The smallest acceptible ether amount */
98     uint256 public floor;
99 
100     /**@dev True if address already invested */
101     mapping (address => bool) public investors;
102 
103 
104     function FloorInvestRestrictions(uint256 _floor) {
105         floor = _floor;
106     }
107 
108     /**@dev IInvestRestrictions implementation */
109     function canInvest(address investor, uint amount, uint tokensLeft) constant returns (bool result) {
110         
111         //allow investment if it isn't the first one 
112         if (investors[investor]) {
113             result = true;
114         } else {
115             //otherwise check the floor
116             result = (amount >= floor);
117         }
118     }
119 
120     /**@dev IInvestRestrictions implementation */
121     function investHappened(address investor, uint amount) managerOnly {
122         investors[investor] = true;
123     }
124 
125     /**@dev Changes investment low cap */
126     function changeFloor(uint256 newFloor) managerOnly {
127         floor = newFloor;
128     }
129 }/*************************************************************************
130  * import "./FloorInvestRestrictions.sol" : end
131  *************************************************************************/
132 /*************************************************************************
133  * import "./ICrowdsaleFormula.sol" : start
134  *************************************************************************/
135 
136 /**@dev Abstraction of crowdsale token calculation function */
137 contract ICrowdsaleFormula {
138 
139     /**@dev Returns amount of tokens that can be bought with given weiAmount */
140     function howManyTokensForEther(uint256 weiAmount) constant returns(uint256 tokens, uint256 excess) {
141         weiAmount; tokens; excess;
142     }
143 
144     /**@dev Returns how many tokens left for sale */
145     function tokensLeft() constant returns(uint256 _left) { _left;}    
146 }/*************************************************************************
147  * import "./ICrowdsaleFormula.sol" : end
148  *************************************************************************/
149 
150 /**@dev In addition to 'floor' behavior restricts investments if there are already too many investors. 
151 Contract owner can reserve some places for future investments:
152 1. It is possible to reserve a place for unknown address using 'reserve' function. 
153     When invest happens you should 'unreserve' that place manually
154 2. It is also possible to reserve a certain address using 'reserveFor'. 
155     When such investor invests, the place becomes unreserved  */
156 contract ParticipantInvestRestrictions is FloorInvestRestrictions {
157 
158     struct ReservedInvestor {
159         bool reserved;        
160         uint256 tokens;
161     }
162 
163     event ReserveKnown(bool state, address investor, uint256 weiAmount, uint256 tokens);
164     event ReserveUnknown(bool state, uint32 index, uint256 weiAmount, uint256 tokens);
165 
166     /**@dev Array of unknown investors */
167     ReservedInvestor[] public unknownInvestors;
168 
169     /**@dev Formula to calculate amount of tokens to buy*/
170     ICrowdsaleFormula public formula;
171 
172     /**@dev Maximum number of allowed investors */
173     uint32 public maxInvestors;    
174 
175     /**@dev Current number of investors */
176     uint32 public investorsCount;
177 
178     /**@dev Current number of known reserved investors */
179     uint32 public knownReserved;
180 
181     /**@dev Current number of unknown reserved investors */
182     uint32 public unknownReserved;
183 
184     /**@dev If address is reserved, shows how much tokens reserved for him */
185     mapping (address => uint256) public reservedInvestors;
186 
187     /**@dev How much tokens reserved */
188     uint256 public tokensReserved;
189 
190     function ParticipantInvestRestrictions(uint256 _floor, uint32 _maxTotalInvestors)
191         FloorInvestRestrictions(_floor)
192     {
193         maxInvestors = _maxTotalInvestors;
194     }
195 
196     /**@dev Sets formula */
197     function setFormula(ICrowdsaleFormula _formula) managerOnly {
198         formula = _formula;        
199     }
200 
201     /**@dev Returns true if there are still free places for investors */
202     function hasFreePlaces() constant returns (bool) {
203         return getInvestorCount() < maxInvestors;
204     }
205 
206     /**@dev Returns number of investors, including reserved */
207     function getInvestorCount() constant returns(uint32) {
208         return investorsCount + knownReserved + unknownReserved;
209     }
210 
211     /**@dev IInvestRestrictions override */
212     function canInvest(address investor, uint amount, uint tokensLeft) constant returns (bool result) {
213         //First check ancestor's restriction. 
214         //Allow only if it is reserved investor or it invested earlier or there is still room for new investors
215         if (super.canInvest(investor, amount, tokensLeft)) {
216             if (reservedInvestors[investor] > 0) {
217                 return true;
218             } else {
219                 var (tokens, excess) = formula.howManyTokensForEther(amount);
220                 if (tokensLeft >= tokensReserved + tokens) {
221                     return investors[investor] || hasFreePlaces();
222                 }
223             }
224         }
225 
226         return false;
227     }
228  
229     /**@dev IInvestRestrictions override */
230     function investHappened(address investor, uint amount) managerOnly {
231         if (!investors[investor]) {
232             investors[investor] = true;
233             investorsCount++;
234             
235             //if that investor was already reserved, unreserve the place
236             if (reservedInvestors[investor] > 0) {
237                 unreserveFor(investor);
238             }
239         }
240     }
241 
242     /**@dev Reserves a place for investor */
243     function reserveFor(address investor, uint256 weiAmount) managerOnly {
244         require(!investors[investor] && hasFreePlaces());
245 
246         if(reservedInvestors[investor] == 0) {
247             knownReserved++;
248         }
249 
250         reservedInvestors[investor] += reserveTokens(weiAmount);
251         ReserveKnown(true, investor, weiAmount, reservedInvestors[investor]);
252     }
253 
254     /**@dev Unreserves special address. For example if investor haven't sent ether */
255     function unreserveFor(address investor) managerOnly {
256         require(reservedInvestors[investor] != 0);
257 
258         knownReserved--;
259         unreserveTokens(reservedInvestors[investor]);
260         reservedInvestors[investor] = 0;
261 
262         ReserveKnown(false, investor, 0, 0);
263     }
264 
265     /**@dev Reserves place for unknown address */
266     function reserve(uint256 weiAmount) managerOnly {
267         require(hasFreePlaces());
268         unknownReserved++;
269         uint32 id = uint32(unknownInvestors.length++);
270         unknownInvestors[id].reserved = true;        
271         unknownInvestors[id].tokens = reserveTokens(weiAmount);
272 
273         ReserveUnknown(true, id, weiAmount, unknownInvestors[id].tokens);
274     }
275 
276     /**@dev Unreserves place for unknown address specified by an index in array */
277     function unreserve(uint32 index) managerOnly {
278         require(index < unknownInvestors.length && unknownInvestors[index].reserved);
279         
280         assert(unknownReserved > 0);
281         unknownReserved--;
282         unreserveTokens(unknownInvestors[index].tokens);        
283         unknownInvestors[index].reserved = false;
284 
285         ReserveUnknown(false, index, 0, 0);
286     }
287 
288     /**@dev Reserved tokens for given amount of ether, returns reserved amount */
289     function reserveTokens(uint256 weiAmount) 
290         internal 
291         managerOnly 
292         returns(uint256) 
293     {
294         uint256 tokens;
295         uint256 excess;
296         (tokens, excess) = formula.howManyTokensForEther(weiAmount);
297         
298         if (tokensReserved + tokens > formula.tokensLeft()) {
299             tokens = formula.tokensLeft() - tokensReserved;
300         }
301         tokensReserved += tokens;
302 
303         return tokens;
304     }
305 
306     /**@dev Unreserves specified amount of tokens */
307     function unreserveTokens(uint256 tokenAmount) 
308         internal 
309         managerOnly 
310     {
311         if (tokenAmount > tokensReserved) {
312             tokensReserved = 0;
313         } else {
314             tokensReserved = tokensReserved - tokenAmount;
315         }
316     }
317 }