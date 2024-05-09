1 // (C) 2017 TokenMarket Ltd. (https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt) Commit: d9e308ff22556a8f40909b1f89ec0f759d1337e0
2 /**
3  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
4  *
5  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
6  */
7 
8 
9 /**
10  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
11  *
12  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
13  */
14 
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   function Ownable() {
32     owner = msg.sender;
33   }
34 
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) onlyOwner {
50     require(newOwner != address(0));      
51     owner = newOwner;
52   }
53 
54 }
55 
56 
57 /*
58  * Haltable
59  *
60  * Abstract contract that allows children to implement an
61  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
62  *
63  *
64  * Originally envisioned in FirstBlood ICO contract.
65  */
66 contract Haltable is Ownable {
67   bool public halted;
68 
69   modifier stopInEmergency {
70     if (halted) throw;
71     _;
72   }
73 
74   modifier stopNonOwnersInEmergency {
75     if (halted && msg.sender != owner) throw;
76     _;
77   }
78 
79   modifier onlyInEmergency {
80     if (!halted) throw;
81     _;
82   }
83 
84   // called by the owner on emergency, triggers stopped state
85   function halt() external onlyOwner {
86     halted = true;
87   }
88 
89   // called by the owner on end of emergency, returns to normal state
90   function unhalt() external onlyOwner onlyInEmergency {
91     halted = false;
92   }
93 
94 }
95 
96 
97 /**
98  * Forward Ethereum payments to another wallet and track them with an event.
99  *
100  * Allows to identify customers who made Ethereum payment for a central token issuance.
101  * Furthermore allow making a payment on behalf of another address.
102  *
103  * Allow pausing to signal the end of the crowdsale.
104  */
105 contract PaymentForwarder is Haltable {
106 
107   /** Who will get all ETH in the end */
108   address public teamMultisig;
109 
110   /** Total incoming money */
111   uint public totalTransferred;
112 
113   /** How many distinct customers we have that have made a payment */
114   uint public customerCount;
115 
116   /** Total incoming money per centrally tracked customer id */
117   mapping(uint128 => uint) public paymentsByCustomer;
118 
119   /** Total incoming money per benefactor address */
120   mapping(address => uint) public paymentsByBenefactor;
121 
122   /** A customer has made a payment. Benefactor is the address where the tokens will be ultimately issued.*/
123   event PaymentForwarded(address source, uint amount, uint128 customerId, address benefactor);
124 
125   function PaymentForwarder(address _owner, address _teamMultisig) {
126     teamMultisig = _teamMultisig;
127     owner = _owner;
128   }
129 
130   /**
131    * Pay on a behalf of an address.
132    *
133    * @param customerId Identifier in the central database, UUID v4
134    *
135    */
136   function pay(uint128 customerId, address benefactor) public stopInEmergency payable {
137 
138     uint weiAmount = msg.value;
139 
140     PaymentForwarded(msg.sender, weiAmount, customerId, benefactor);
141 
142     // We trust Ethereum amounts cannot overflow uint256
143     totalTransferred += weiAmount;
144 
145     if(paymentsByCustomer[customerId] == 0) {
146       customerCount++;
147     }
148 
149     paymentsByCustomer[customerId] += weiAmount;
150 
151     // We track benefactor addresses for extra safety;
152     // In the case of central ETH issuance tracking has problems we can
153     // construct ETH contributions solely based on blockchain data
154     paymentsByBenefactor[benefactor] += weiAmount;
155 
156     // May run out of gas
157     if(!teamMultisig.send(weiAmount)) throw;
158   }
159 
160   /**
161    * Pay on a behalf of the sender.
162    *
163    * @param customerId Identifier in the central database, UUID v4
164    *
165    */
166   function payForMyself(uint128 customerId) public payable {
167     pay(customerId, msg.sender);
168   }
169 
170 }