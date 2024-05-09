1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
77 
78 pragma solidity ^0.5.0;
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 interface IERC20 {
85     function transfer(address to, uint256 value) external returns (bool);
86 
87     function approve(address spender, uint256 value) external returns (bool);
88 
89     function transferFrom(address from, address to, uint256 value) external returns (bool);
90 
91     function totalSupply() external view returns (uint256);
92 
93     function balanceOf(address who) external view returns (uint256);
94 
95     function allowance(address owner, address spender) external view returns (uint256);
96 
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 // File: contracts/PaymentHandler.sol
103 
104 pragma solidity ^0.5.0;
105 
106 
107 /**
108  * The payment handler is responsible for receiving payments.
109  * If the payment is in ETH, it auto forwards to its parent master's owner.
110  * If the payment is in ERC20, it holds the tokens until it is asked to sweep.
111  * It can only sweep ERC20s to the parent master's owner.
112  */
113 contract PaymentHandler {
114 
115 	// Keep track of the parent master contract - cannot be changed once set
116 	PaymentMaster public master;
117 
118 	/**
119 	 * General constructor called by the master
120 	 */
121 	constructor(PaymentMaster _master) public {
122 		master = _master;
123 	}
124 
125 	/**
126 	 * Helper function to return the parent master's address
127 	 */
128 	function getMasterAddress() public view returns (address) {
129 		return address(master);
130 	}
131 
132 	/**
133 	 * Default payable function - forwards to the owner and triggers event
134 	 */
135 	function() external payable {
136 		// Get the parent master's owner address - explicity convert to payable
137 		address payable ownerAddress = address(uint160(master.owner()));
138 
139 		// Forward the funds to the owner
140 		ownerAddress.transfer(msg.value);
141 
142 		// Trigger the event notification in the parent master
143 		master.firePaymentReceivedEvent(address(this), msg.sender, msg.value);
144 	}
145 
146 	/**
147 	 * Sweep any tokens to the owner of the master
148 	 */
149 	function sweepTokens(IERC20 token) public {
150 		// Get the owner address
151 		address ownerAddress = master.owner();
152 
153 		// Get the current balance
154 		uint balance = token.balanceOf(address(this));
155 
156 		// Transfer to the owner
157 		token.transfer(ownerAddress, balance);
158 	}
159 
160 }
161 
162 // File: contracts/PaymentMaster.sol
163 
164 pragma solidity ^0.5.0;
165 
166 
167 
168 
169 /**
170  * The PaymentMaster sits above the payment handler contracts.
171  * It deploys and keeps track of all the handlers.
172  * It can trigger events by child handlers when they receive ETH.
173  * It allows ERC20 tokens to be swept in bulk to the owner account.
174  */
175 contract PaymentMaster is Ownable {
176 
177 	// A list of handler addresses for retrieval
178   address[] public handlerList;
179 
180 	// A mapping of handler addresses for lookups
181 	mapping(address => bool) public handlerMap;
182 
183 	// Events triggered for listeners
184 	event HandlerCreated(address indexed _addr);
185 	event EthPaymentReceived(address indexed _to, address indexed _from, uint256 _amount);
186 
187 	/**
188 	 * Anyone can call the function to deploy a new payment handler.
189 	 * The new contract will be created, added to the list, and an event fired.
190 	 */
191 	function deployNewHandler() public {
192 		// Deploy the new contract
193 		PaymentHandler createdHandler = new PaymentHandler(this);
194 
195 		// Add it to the list and the mapping
196 		handlerList.push(address(createdHandler));
197 		handlerMap[address(createdHandler)] = true;
198 
199 		// Emit event to let watchers know that a new handler was created
200 		emit HandlerCreated(address(createdHandler));
201 	}
202 
203 	/**
204 	 * This is a convenience method to allow watchers to get the entire list
205 	 */
206 	function getHandlerList() public view returns (address[] memory) {
207 			// Return the entire list
208       return handlerList;
209   }
210 
211 	/**
212 	 * Allows caller to determine how long the handler list is for convenience
213 	 */
214 	function getHandlerListLength() public view returns (uint) {
215 		return handlerList.length;
216 	}
217 
218 	/**
219 	 * This function is called by handlers when they receive ETH payments.
220 	 */
221 	function firePaymentReceivedEvent(address to, address from, uint256 amount) public {
222 		// Verify the call is coming from a handler
223 		require(handlerMap[msg.sender], "Only payment handlers are allowed to trigger payment events.");
224 
225 		// Emit the event
226 		emit EthPaymentReceived(to, from, amount);
227 	}
228 
229 	/**
230 	 * Allows a caller to sweep multiple handlers in one transaction
231 	 */
232 	function multiHandlerSweep(address[] memory handlers, IERC20 tokenContract) public {
233 		for (uint i = 0; i < handlers.length; i++) {
234 
235 			// Whitelist calls to only handlers
236 			require(handlerMap[handlers[i]], "Only payment handlers are valid sweep targets.");
237 
238 			// Trigger sweep
239 			PaymentHandler(address(uint160(handlers[i]))).sweepTokens(tokenContract);
240 		}
241 	}
242 
243 	/**
244 	 * Safety function to allow sweep of ERC20s if accidentally sent to this contract
245 	 */
246 	function sweepTokens(IERC20 token) public {
247 		// Get the current balance
248 		uint balance = token.balanceOf(address(this));
249 
250 		// Transfer to the owner
251 		token.transfer(this.owner(), balance);
252 	}
253 }