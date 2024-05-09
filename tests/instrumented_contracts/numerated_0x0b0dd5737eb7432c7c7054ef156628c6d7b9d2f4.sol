1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 
15 
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24 
25 
26   /**
27    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28    * account.
29    */
30   function Ownable() {
31     owner = msg.sender;
32   }
33 
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address newOwner) onlyOwner {
49     require(newOwner != address(0));      
50     owner = newOwner;
51   }
52 
53 }
54 
55 
56 /*
57  * Haltable
58  *
59  * Abstract contract that allows children to implement an
60  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
61  *
62  *
63  * Originally envisioned in FirstBlood ICO contract.
64  */
65 contract Haltable is Ownable {
66   bool public halted;
67 
68   modifier stopInEmergency {
69     if (halted) throw;
70     _;
71   }
72 
73   modifier stopNonOwnersInEmergency {
74     if (halted && msg.sender != owner) throw;
75     _;
76   }
77 
78   modifier onlyInEmergency {
79     if (!halted) throw;
80     _;
81   }
82 
83   // called by the owner on emergency, triggers stopped state
84   function halt() external onlyOwner {
85     halted = true;
86   }
87 
88   // called by the owner on end of emergency, returns to normal state
89   function unhalt() external onlyOwner onlyInEmergency {
90     halted = false;
91   }
92 
93 }
94 
95 
96 /**
97  * Forward Ethereum payments to another wallet and track them with an event.
98  *
99  * Allows to identify customers who made Ethereum payment for a central token issuance.
100  * Furthermore allow making a payment on behalf of another address.
101  *
102  * Allow pausing to signal the end of the crowdsale.
103  */
104 contract PaymentForwarder is Haltable {
105 
106   /** Who will get all ETH in the end */
107   address public teamMultisig;
108 
109   /** Total incoming money */
110   uint public totalTransferred;
111 
112   /** How many distinct customers we have that have made a payment */
113   uint public customerCount;
114 
115   /** Total incoming money per centrally tracked customer id */
116   mapping(uint128 => uint) public paymentsByCustomer;
117 
118   /** Total incoming money per benefactor address */
119   mapping(address => uint) public paymentsByBenefactor;
120 
121   /** A customer has made a payment. Benefactor is the address where the tokens will be ultimately issued.*/
122   event PaymentForwarded(address source, uint amount, uint128 customerId, address benefactor);
123 
124   function PaymentForwarder(address _owner, address _teamMultisig) {
125     teamMultisig = _teamMultisig;
126     owner = _owner;
127   }
128 
129   /**
130    * Pay on a behalf of an address.
131    *
132    * @param customerId Identifier in the central database, UUID v4
133    *
134    */
135   function pay(uint128 customerId, address benefactor) public stopInEmergency payable {
136 
137     uint weiAmount = msg.value;
138 
139     PaymentForwarded(msg.sender, weiAmount, customerId, benefactor);
140 
141     // We trust Ethereum amounts cannot overflow uint256
142     totalTransferred += weiAmount;
143 
144     if(paymentsByCustomer[customerId] == 0) {
145       customerCount++;
146     }
147 
148     paymentsByCustomer[customerId] += weiAmount;
149 
150     // We track benefactor addresses for extra safety;
151     // In the case of central ETH issuance tracking has problems we can
152     // construct ETH contributions solely based on blockchain data
153     paymentsByBenefactor[benefactor] += weiAmount;
154 
155     // May run out of gas
156     if(!teamMultisig.send(weiAmount)) throw;
157   }
158 
159   /**
160    * Pay on a behalf of the sender.
161    *
162    * @param customerId Identifier in the central database, UUID v4
163    *
164    */
165   function payForMyself(uint128 customerId) public payable {
166     pay(customerId, msg.sender);
167   }
168 
169 }