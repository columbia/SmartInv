1 /**
2  * This smart contract code is Copyright 2018 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 // EtherScan verify workaround test
8 // pragma solidity ^0.4.18;
9 
10 
11 /**
12  * @dev Split ether between parties.
13  * @author TokenMarket Ltd. /  Ville Sundell <ville at tokenmarket.net>
14  *
15  * Allows splitting payments between parties.
16  * Ethers are split to parties, each party has slices they are entitled to.
17  * Ethers of this smart contract are divided into slices upon split().
18  */
19 
20 /**
21  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
22  *
23  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
24  */
25 
26 
27 
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   function Ownable() public {
46     owner = msg.sender;
47   }
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 
70 
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/179
75  */
76 contract ERC20Basic {
77   function totalSupply() public view returns (uint256);
78   function balanceOf(address who) public view returns (uint256);
79   function transfer(address to, uint256 value) public returns (bool);
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 
84 contract Recoverable is Ownable {
85 
86   /// @dev Empty constructor (for now)
87   function Recoverable() {
88   }
89 
90   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
91   /// @param token Token which will we rescue to the owner from the contract
92   function recoverTokens(ERC20Basic token) onlyOwner public {
93     token.transfer(owner, tokensToBeReturned(token));
94   }
95 
96   /// @dev Interface function, can be overwritten by the superclass
97   /// @param token Token which balance we will check and return
98   /// @return The amount of tokens (in smallest denominator) the contract owns
99   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
100     return token.balanceOf(this);
101   }
102 }
103 
104 
105 
106 /**
107  * @title SafeMath
108  * @dev Math operations with safety checks that throw on error
109  */
110 library SafeMath {
111 
112   /**
113   * @dev Multiplies two numbers, throws on overflow.
114   */
115   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116     if (a == 0) {
117       return 0;
118     }
119     uint256 c = a * b;
120     assert(c / a == b);
121     return c;
122   }
123 
124   /**
125   * @dev Integer division of two numbers, truncating the quotient.
126   */
127   function div(uint256 a, uint256 b) internal pure returns (uint256) {
128     // assert(b > 0); // Solidity automatically throws when dividing by 0
129     uint256 c = a / b;
130     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131     return c;
132   }
133 
134   /**
135   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
136   */
137   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138     assert(b <= a);
139     return a - b;
140   }
141 
142   /**
143   * @dev Adds two numbers, throws on overflow.
144   */
145   function add(uint256 a, uint256 b) internal pure returns (uint256) {
146     uint256 c = a + b;
147     assert(c >= a);
148     return c;
149   }
150 }
151 
152 
153 contract PaymentSplitter is Recoverable {
154   using SafeMath for uint256; // We use only uint256 for safety reasons (no boxing)
155 
156   /// @dev Describes a party (address and amount of slices the party is entitled to)
157   struct Party {
158     address addr;
159     uint256 slices;
160   }
161 
162   /// @dev This is just a failsafe, so we can't initialize a contract where
163   ///      splitting would not be succesful in the future (for example because
164   ///      of decreased block gas limit):
165   uint256 constant MAX_PARTIES = 100;
166   /// @dev How many slices there are in total:
167   uint256 public totalSlices;
168   /// @dev Array of "Party"s for each party's address and amount of slices:
169   Party[] public parties;
170 
171   /// @dev This event is emitted when someone makes a payment:
172   ///      (Gnosis MultiSigWallet compatible event)
173   event Deposit(address indexed sender, uint256 value);
174   /// @dev This event is emitted when someone splits the ethers between parties:
175   ///      (emitted once per call)
176   event Split(address indexed who, uint256 value);
177   /// @dev This event is emitted for every party we send ethers to:
178   event SplitTo(address indexed to, uint256 value);
179 
180   /// @dev Constructor: takes list of parties and their slices.
181   /// @param addresses List of addresses of the parties
182   /// @param slices Slices of the parties. Will be added to totalSlices.
183   function PaymentSplitter(address[] addresses, uint[] slices) public {
184     require(addresses.length == slices.length, "addresses and slices must be equal length.");
185     require(addresses.length > 0 && addresses.length < MAX_PARTIES, "Amount of parties is either too many, or zero.");
186 
187     for(uint i=0; i<addresses.length; i++) {
188       parties.push(Party(addresses[i], slices[i]));
189       totalSlices = totalSlices.add(slices[i]);
190     }
191   }
192 
193   /// @dev Split the ethers, and send to parties according to slices.
194   ///      This can be intentionally invoked by anyone: if some random person
195   ///      wants to pay for the gas, that's good for us.
196   function split() external {
197     uint256 totalBalance = this.balance;
198     uint256 slice = totalBalance.div(totalSlices);
199 
200     for(uint i=0; i<parties.length; i++) {
201       uint256 amount = slice.mul(parties[i].slices);
202 
203       parties[i].addr.send(amount);
204       emit SplitTo(parties[i].addr, amount);
205     }
206 
207     emit Split(msg.sender, totalBalance);
208   }
209 
210   /// @dev Fallback function, intentionally designed to fit to the gas stipend.
211   function() public payable {
212     emit Deposit(msg.sender, msg.value);
213   }
214 }