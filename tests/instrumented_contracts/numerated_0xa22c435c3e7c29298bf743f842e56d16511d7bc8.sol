1 pragma solidity ^0.4.18;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
46 
47 /**
48  * @title Contracts that should not own Ether
49  * @author Remco Bloemen <remco@2π.com>
50  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
51  * in the contract, it will allow the owner to reclaim this ether.
52  * @notice Ether can still be send to this contract by:
53  * calling functions labeled `payable`
54  * `selfdestruct(contract_address)`
55  * mining directly to the contract address
56 */
57 contract HasNoEther is Ownable {
58 
59   /**
60   * @dev Constructor that rejects incoming Ether
61   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
62   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
63   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
64   * we could use assembly to access msg.value.
65   */
66   function HasNoEther() public payable {
67     require(msg.value == 0);
68   }
69 
70   /**
71    * @dev Disallows direct send by settings a default function without the `payable` flag.
72    */
73   function() external {
74   }
75 
76   /**
77    * @dev Transfer all Ether held by the contract to the owner.
78    */
79   function reclaimEther() external onlyOwner {
80     assert(owner.send(this.balance));
81   }
82 }
83 
84 // File: contracts/TweedentityRegistry.sol
85 
86 interface ManagerInterface {
87 
88   function paused()
89   public
90   constant returns (bool);
91 
92 
93   function claimer()
94   public
95   constant returns (address);
96 
97   function totalStores()
98   public
99   constant returns (uint);
100 
101 
102   function getStoreAddress(
103     string _appNickname
104   )
105   external
106   constant returns (address);
107 
108 
109   function getStoreAddressById(
110     uint _appId
111   )
112   external
113   constant returns (address);
114 
115 
116   function isStoreActive(
117     uint _appId
118   )
119   public
120   constant returns (bool);
121 
122 }
123 
124 interface ClaimerInterface {
125 
126   function manager()
127   public
128   constant returns (address);
129 }
130 
131 
132 interface StoreInterface {
133 
134   function appSet()
135   public
136   constant returns (bool);
137 
138 
139   function manager()
140   public
141   constant returns (address);
142 
143 }
144 
145 
146 /**
147  * @title TweedentityRegistry
148  * @author Francesco Sullo <francesco@sullo.co>
149  * @dev It store the tweedentities contracts addresses to allows dapp to be updated
150  */
151 
152 
153 contract TweedentityRegistry
154 is HasNoEther
155 {
156 
157   string public fromVersion = "1.0.0";
158 
159   address public manager;
160   address public claimer;
161 
162   event ContractRegistered(
163     bytes32 indexed key,
164     string spec,
165     address addr
166   );
167 
168 
169   function setManager(
170     address _manager
171   )
172   public
173   onlyOwner
174   {
175     require(_manager != address(0));
176     manager = _manager;
177     ContractRegistered(keccak256("manager"), "", _manager);
178   }
179 
180 
181   function setClaimer(
182     address _claimer
183   )
184   public
185   onlyOwner
186   {
187     require(_claimer != address(0));
188     claimer = _claimer;
189     ContractRegistered(keccak256("claimer"), "", _claimer);
190   }
191 
192 
193   function setManagerAndClaimer(
194     address _manager,
195     address _claimer
196   )
197   external
198   onlyOwner
199   {
200     setManager(_manager);
201     setClaimer(_claimer);
202   }
203 
204 
205   /**
206    * @dev Gets the store managing the specified app
207    * @param _appNickname The nickname of the app
208    */
209   function getStore(
210     string _appNickname
211   )
212   public
213   constant returns (address)
214   {
215     ManagerInterface theManager = ManagerInterface(manager);
216     return theManager.getStoreAddress(_appNickname);
217   }
218 
219 
220   // error codes
221 
222   uint public allSet = 0;
223   uint public managerUnset = 10;
224   uint public claimerUnset = 20;
225   uint public wrongClaimerOrUnsetInManager = 30;
226   uint public wrongManagerOrUnsetInClaimer = 40;
227   uint public noStoresSet = 50;
228   uint public noStoreIsActive = 60;
229   uint public managerIsPaused = 70;
230   uint public managerNotSetInApp = 1000;
231 
232   /**
233    * @dev Returns true if the registry looks ready
234    */
235   function isReady()
236   external
237   constant returns (uint)
238   {
239     if (manager == address(0)) {
240       return managerUnset;
241     }
242     if (claimer == address(0)) {
243       return claimerUnset;
244     }
245     ManagerInterface theManager = ManagerInterface(manager);
246     ClaimerInterface theClaimer = ClaimerInterface(claimer);
247     if (theManager.claimer() != claimer) {
248       return wrongClaimerOrUnsetInManager;
249     }
250     if (theClaimer.manager() != manager) {
251       return wrongManagerOrUnsetInClaimer;
252     }
253     uint totalStores = theManager.totalStores();
254     if (totalStores == 0) {
255       return noStoresSet;
256     }
257     bool atLeastOneIsActive;
258     for (uint i = 1; i <= totalStores; i++) {
259       StoreInterface theStore = StoreInterface(theManager.getStoreAddressById(i));
260       if (theManager.isStoreActive(i)) {
261         atLeastOneIsActive = true;
262       }
263       if (theManager.isStoreActive(i)) {
264         if (theStore.manager() != manager) {
265           return managerNotSetInApp + i;
266         }
267       }
268     }
269     if (atLeastOneIsActive == false) {
270       return noStoreIsActive;
271     }
272     if (theManager.paused() == true) {
273       return managerIsPaused;
274     }
275     return allSet;
276   }
277 
278 }