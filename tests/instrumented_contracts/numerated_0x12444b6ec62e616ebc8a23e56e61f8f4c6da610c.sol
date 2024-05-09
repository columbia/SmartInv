1 /*
2  * Ownable
3  *
4  * Base contract with an owner.
5  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
6  */
7 contract Ownable {
8   address public owner;
9 
10   function Ownable() {
11     owner = msg.sender;
12   }
13 
14   modifier onlyOwner() {
15     if (msg.sender != owner) {
16       throw;
17     }
18     _;
19   }
20 
21   function transferOwnership(address newOwner) onlyOwner {
22     if (newOwner != address(0)) {
23       owner = newOwner;
24     }
25   }
26 
27 }
28 
29 
30 /*
31  * Haltable
32  *
33  * Abstract contract that allows children to implement an
34  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
35  *
36  *
37  * Originally envisioned in FirstBlood ICO contract.
38  */
39 contract Haltable is Ownable {
40   bool public halted;
41 
42   modifier stopInEmergency {
43     if (halted) throw;
44     _;
45   }
46 
47   modifier onlyInEmergency {
48     if (!halted) throw;
49     _;
50   }
51 
52   // called by the owner on emergency, triggers stopped state
53   function halt() external onlyOwner {
54     halted = true;
55   }
56 
57   // called by the owner on end of emergency, returns to normal state
58   function unhalt() external onlyOwner onlyInEmergency {
59     halted = false;
60   }
61 
62 }
63 
64 
65 /**
66  * Forward Ethereum payments to another wallet and track them with an event.
67  *
68  * Allows to identify customers who made Ethereum payment for a central token issuance.
69  * Furthermore allow making a payment on behalf of another address.
70  *
71  * Allow pausing to signal the end of the crowdsale.
72  */
73 contract PaymentForwarder is Haltable {
74 
75   /** Who will get all ETH in the end */
76   address public teamMultisig;
77 
78   /** Total incoming money */
79   uint public totalTransferred;
80 
81   /** How many distinct customers we have that have made a payment */
82   uint public customerCount;
83 
84   /** Total incoming money per centrally tracked customer id */
85   mapping(uint128 => uint) public paymentsByCustomer;
86 
87   /** Total incoming money per benefactor address */
88   mapping(address => uint) public paymentsByBenefactor;
89 
90   /** A customer has made a payment. Benefactor is the address where the tokens will be ultimately issued.*/
91   event PaymentForwarded(address source, uint amount, uint128 customerId, address benefactor);
92 
93   function PaymentForwarder(address _owner, address _teamMultisig) {
94     teamMultisig = _teamMultisig;
95     owner = _owner;
96   }
97 
98   /**
99    * Pay on a behalf of an address.
100    *
101    * @param customerId Identifier in the central database, UUID v4
102    *
103    */
104   function pay(uint128 customerId, address benefactor) public stopInEmergency payable {
105 
106     uint weiAmount = msg.value;
107 
108     PaymentForwarded(msg.sender, weiAmount, customerId, benefactor);
109 
110     // We trust Ethereum amounts cannot overflow uint256
111     totalTransferred += weiAmount;
112 
113     if(paymentsByCustomer[customerId] == 0) {
114       customerCount++;
115     }
116 
117     paymentsByCustomer[customerId] += weiAmount;
118 
119     // We track benefactor addresses for extra safety;
120     // In the case of central ETH issuance tracking has problems we can
121     // construct ETH contributions solely based on blockchain data
122     paymentsByBenefactor[benefactor] += weiAmount;
123 
124     // May run out of gas
125     if(!teamMultisig.send(weiAmount)) throw;
126   }
127 
128   /**
129    * Pay on a behalf of the sender.
130    *
131    * @param customerId Identifier in the central database, UUID v4
132    *
133    */
134   function payForMyself(uint128 customerId) public payable {
135     pay(customerId, msg.sender);
136   }
137 
138 }