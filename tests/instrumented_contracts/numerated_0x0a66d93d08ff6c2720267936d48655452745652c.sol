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
86 contract Pausable {
87 
88   bool public paused;
89 }
90 
91 
92 /**
93  * @title TweedentityRegistry
94  * @author Francesco Sullo <francesco@sullo.co>
95  * @dev It store the tweedentities contracts addresses to allows dapp to be updated
96  */
97 
98 
99 contract TweedentityRegistry
100 is HasNoEther
101 {
102 
103   string public version = "1.3.0";
104 
105   uint public totalStores;
106   mapping (bytes32 => address) public stores;
107 
108   address public manager;
109   address public claimer;
110 
111   bytes32 public managerKey = keccak256("manager");
112   bytes32 public claimerKey = keccak256("claimer");
113   bytes32 public storeKey = keccak256("store");
114 
115   event ContractRegistered(
116     bytes32 indexed key,
117     string spec,
118     address addr
119   );
120 
121 
122   function setManager(
123     address _manager
124   )
125   external
126   onlyOwner
127   {
128     require(_manager != address(0));
129     manager = _manager;
130     ContractRegistered(managerKey, "", _manager);
131   }
132 
133 
134   function setClaimer(
135     address _claimer
136   )
137   external
138   onlyOwner
139   {
140     require(_claimer != address(0));
141     claimer = _claimer;
142     ContractRegistered(claimerKey, "", _claimer);
143   }
144 
145 
146   function setManagerAndClaimer(
147     address _manager,
148     address _claimer
149   )
150   external
151   onlyOwner
152   {
153     require(_manager != address(0));
154     require(_claimer != address(0));
155     manager = _manager;
156     claimer = _claimer;
157     ContractRegistered(managerKey, "", _manager);
158     ContractRegistered(claimerKey, "", _claimer);
159   }
160 
161 
162   function setAStore(
163     string _appNickname,
164     address _store
165   )
166   external
167   onlyOwner
168   {
169     require(_store != address(0));
170     if (getStore(_appNickname) == address(0)) {
171       totalStores++;
172     }
173     stores[keccak256(_appNickname)] = _store;
174     ContractRegistered(storeKey, _appNickname, _store);
175   }
176 
177 
178   /**
179    * @dev Gets the store managing the specified app
180    * @param _appNickname The nickname of the app
181    */
182   function getStore(
183     string _appNickname
184   )
185   public
186   constant returns(address)
187   {
188     return stores[keccak256(_appNickname)];
189   }
190 
191 
192   /**
193    * @dev Returns true if the registry looks ready
194    */
195   function isReady()
196   external
197   constant returns(bool)
198   {
199     Pausable pausable = Pausable(manager);
200     return totalStores > 0 && manager != address(0) && claimer != address(0) && pausable.paused() == false;
201   }
202 
203 }