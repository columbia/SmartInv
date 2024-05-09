1 /**
2  * This smart contract code is Copyright 2018 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * @dev Split ether between parties.
10  * @author TokenMarket Ltd. /  Ville Sundell <ville at tokenmarket.net>
11  *
12  * Allows splitting payments between parties.
13  * Ethers are split to parties, each party has slices they are entitled to.
14  * Ethers of this smart contract are divided into slices upon split().
15  */
16 
17 /**
18  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
19  *
20  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
21  */
22 
23 
24 
25 
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32   address public owner;
33 
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() public {
43     owner = msg.sender;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 
67 
68 /**
69  * @title ERC20Basic
70  * @dev Simpler version of ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/179
72  */
73 contract ERC20Basic {
74   function totalSupply() public view returns (uint256);
75   function balanceOf(address who) public view returns (uint256);
76   function transfer(address to, uint256 value) public returns (bool);
77   event Transfer(address indexed from, address indexed to, uint256 value);
78 }
79 
80 
81 contract Recoverable is Ownable {
82 
83   /// @dev Empty constructor (for now)
84   function Recoverable() {
85   }
86 
87   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
88   /// @param token Token which will we rescue to the owner from the contract
89   function recoverTokens(ERC20Basic token) onlyOwner public {
90     token.transfer(owner, tokensToBeReturned(token));
91   }
92 
93   /// @dev Interface function, can be overwritten by the superclass
94   /// @param token Token which balance we will check and return
95   /// @return The amount of tokens (in smallest denominator) the contract owns
96   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
97     return token.balanceOf(this);
98   }
99 }
100 
101 
102 
103 /**
104  * @title SafeMath
105  * @dev Math operations with safety checks that throw on error
106  */
107 library SafeMath {
108 
109   /**
110   * @dev Multiplies two numbers, throws on overflow.
111   */
112   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113     if (a == 0) {
114       return 0;
115     }
116     uint256 c = a * b;
117     assert(c / a == b);
118     return c;
119   }
120 
121   /**
122   * @dev Integer division of two numbers, truncating the quotient.
123   */
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return c;
129   }
130 
131   /**
132   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
133   */
134   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139   /**
140   * @dev Adds two numbers, throws on overflow.
141   */
142   function add(uint256 a, uint256 b) internal pure returns (uint256) {
143     uint256 c = a + b;
144     assert(c >= a);
145     return c;
146   }
147 }
148 
149 
150 contract PaymentSplitter is Recoverable {
151   using SafeMath for uint256; // We use only uint256 for safety reasons (no boxing)
152 
153   /// @dev Describes a party (address and amount of slices the party is entitled to)
154   struct Party {
155     address addr;
156     uint256 slices;
157   }
158 
159   /// @dev This is just a failsafe, so we can't initialize a contract where
160   ///      splitting would not be succesful in the future (for example because
161   ///      of decreased block gas limit):
162   uint256 constant MAX_PARTIES = 100;
163   /// @dev How many slices there are in total:
164   uint256 public totalSlices;
165   /// @dev Array of "Party"s for each party's address and amount of slices:
166   Party[] public parties;
167 
168   /// @dev This event is emitted when someone makes a payment:
169   ///      (Gnosis MultiSigWallet compatible event)
170   event Deposit(address indexed sender, uint256 value);
171   /// @dev This event is emitted when someone splits the ethers between parties:
172   ///      (emitted once per call)
173   event Split(address indexed who, uint256 value);
174   /// @dev This event is emitted for every party we send ethers to:
175   event SplitTo(address indexed to, uint256 value);
176 
177   /// @dev Constructor: takes list of parties and their slices.
178   /// @param addresses List of addresses of the parties
179   /// @param slices Slices of the parties. Will be added to totalSlices.
180   function PaymentSplitter(address[] addresses, uint[] slices) public {
181     require(addresses.length == slices.length, "addresses and slices must be equal length.");
182     require(addresses.length > 0 && addresses.length < MAX_PARTIES, "Amount of parties is either too many, or zero.");
183 
184     for(uint i=0; i<addresses.length; i++) {
185       parties.push(Party(addresses[i], slices[i]));
186       totalSlices = totalSlices.add(slices[i]);
187     }
188   }
189 
190   /// @dev Split the ethers, and send to parties according to slices.
191   ///      This can be intentionally invoked by anyone: if some random person
192   ///      wants to pay for the gas, that's good for us.
193   function split() external {
194     uint256 totalBalance = this.balance;
195     uint256 slice = totalBalance.div(totalSlices);
196 
197     for(uint i=0; i<parties.length; i++) {
198       uint256 amount = slice.mul(parties[i].slices);
199 
200       parties[i].addr.send(amount);
201       emit SplitTo(parties[i].addr, amount);
202     }
203 
204     emit Split(msg.sender, totalBalance);
205   }
206 
207   /// @dev Fallback function, intentionally designed to fit to the gas stipend.
208   function() public payable {
209     emit Deposit(msg.sender, msg.value);
210   }
211 }