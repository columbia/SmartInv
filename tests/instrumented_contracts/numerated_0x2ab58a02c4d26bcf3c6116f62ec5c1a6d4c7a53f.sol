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
103   string public version = "1.4.0";
104 
105   uint public totalStores;
106   mapping (bytes32 => address) private stores;
107 
108   address public manager;
109   address public claimer;
110 
111   event ContractRegistered(
112     bytes32 indexed key,
113     string spec,
114     address addr
115   );
116 
117 
118   function setManager(
119     address _manager
120   )
121   external
122   onlyOwner
123   {
124     require(_manager != address(0));
125     manager = _manager;
126     ContractRegistered(keccak256("manager"), "", _manager);
127   }
128 
129 
130   function setClaimer(
131     address _claimer
132   )
133   external
134   onlyOwner
135   {
136     require(_claimer != address(0));
137     claimer = _claimer;
138     ContractRegistered(keccak256("claimer"), "", _claimer);
139   }
140 
141 
142   function setManagerAndClaimer(
143     address _manager,
144     address _claimer
145   )
146   external
147   onlyOwner
148   {
149     require(_manager != address(0));
150     require(_claimer != address(0));
151     manager = _manager;
152     claimer = _claimer;
153     ContractRegistered(keccak256("manager"), "", _manager);
154     ContractRegistered(keccak256("claimer"), "", _claimer);
155   }
156 
157 
158   function setAStore(
159     string _appNickname,
160     address _store
161   )
162   external
163   onlyOwner
164   {
165     require(_store != address(0));
166     if (getStore(_appNickname) == address(0)) {
167       totalStores++;
168     }
169     stores[keccak256(_appNickname)] = _store;
170     ContractRegistered(keccak256("store"), _appNickname, _store);
171   }
172 
173 
174   /**
175    * @dev Gets the store managing the specified app
176    * @param _appNickname The nickname of the app
177    */
178   function getStore(
179     string _appNickname
180   )
181   public
182   constant returns(address)
183   {
184     return stores[keccak256(_appNickname)];
185   }
186 
187 
188   /**
189    * @dev Returns true if the registry looks ready
190    */
191   function isReady()
192   external
193   constant returns(bool)
194   {
195     Pausable pausable = Pausable(manager);
196     return totalStores > 0 && manager != address(0) && claimer != address(0) && pausable.paused() == false;
197   }
198 
199 }