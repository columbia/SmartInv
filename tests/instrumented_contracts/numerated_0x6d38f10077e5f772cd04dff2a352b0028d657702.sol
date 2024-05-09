1 pragma solidity 0.4.24;
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() public onlyOwner whenNotPaused {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() public onlyOwner whenPaused {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: contracts/tokensale.sol
114 
115 contract TokenSale is Pausable {
116 
117   // Flag indicating if contract was finalized
118   bool public isFinalized = false;
119 
120   // Flag indicating if contract was started
121   bool public isStarted = false;
122 
123   // Event that is emited once contract was finalized
124   event Finalized();
125 
126   // Event that is emited once contract was started
127   event Started();
128 
129   // Event that is emited once invested
130   event Invested(address purchaser, address beneficiary, uint256 amount);
131 
132   modifier whenStarted() {
133     require(isStarted);
134     _;
135   }
136 
137   modifier whenNotFinalized() {
138     require(!isFinalized);
139     _;
140   }
141 
142   constructor() public  {
143   }
144 
145   // Method for starting token sale
146   function start() public onlyOwner {
147     require(!isStarted);
148     require(!isFinalized);
149     emit Started();
150     isStarted = true;
151   }
152 
153   // Method for pausing token sale
154   function pause() public onlyOwner whenStarted whenNotFinalized whenNotPaused {
155     super.pause();
156   }
157 
158   // Method for unpausing token sale
159   function unpause() public onlyOwner whenStarted whenNotFinalized whenPaused {
160     super.unpause();
161   }
162 
163   // Method for finalizing token sale
164   function finalize() public onlyOwner {
165     require(isStarted);
166     require(!isFinalized);
167     emit Finalized();
168     isFinalized = true;
169   }
170 
171   function () external payable {
172     invest(msg.sender);
173   }
174 
175   // Method handling investment and forwarding ethereum to owners wallet
176   function invest(address _beneficiary)
177     public
178     whenStarted
179     whenNotPaused
180     whenNotFinalized
181     payable {
182 
183     uint256 _weiAmount = msg.value;
184     require(_beneficiary != address(0));
185     require(_weiAmount != 0);
186 
187     emit Invested(msg.sender, _beneficiary, _weiAmount);
188 
189     owner.transfer(_weiAmount);
190   }
191 }