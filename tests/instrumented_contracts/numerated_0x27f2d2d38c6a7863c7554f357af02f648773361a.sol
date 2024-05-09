1 pragma solidity 0.4.18;
2 
3 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: contracts/FxRates.sol
83 
84 /**
85  * @title FxRates
86  * @dev Store the historic fx rates for conversion ETHEUR and BTCEUR
87  */
88 contract FxRates is Ownable {
89     using SafeMath for uint256;
90 
91     struct Rate {
92         string rate;
93         string timestamp;
94     }
95 
96     /**
97      * @dev Event for logging an update of the exchange rates
98      * @param symbol one of ["ETH", "BTC"]
99      * @param updateNumber an incremental number giving the number of update
100      * @param timestamp human readable timestamp of the earliest validity time
101      * @param rate a string containing the rate value
102      */
103     event RateUpdate(string symbol, uint256 updateNumber, string timestamp, string rate);
104 
105     uint256 public numberBtcUpdates = 0;
106 
107     mapping(uint256 => Rate) public btcUpdates;
108 
109     uint256 public numberEthUpdates = 0;
110 
111     mapping(uint256 => Rate) public ethUpdates;
112 
113     /**
114      * @dev Adds the latest Ether Euro rate to the history. Only the crontract owner can execute this.
115      * @param _rate the exchange rate
116      * @param _timestamp human readable earliest point in time where the rate is valid
117      */
118     function updateEthRate(string _rate, string _timestamp) public onlyOwner {
119         numberEthUpdates = numberEthUpdates.add(1);
120         ethUpdates[numberEthUpdates] = Rate({
121             rate: _rate,
122             timestamp: _timestamp
123         });
124         RateUpdate("ETH", numberEthUpdates, _timestamp, _rate);
125     }
126 
127     /**
128      * @dev Adds the latest Btc Euro rate to the history. . Only the crontract owner can execute this.
129      * @param _rate the exchange rate
130      * @param _timestamp human readable earliest point in time where the rate is valid
131      */
132     function updateBtcRate(string _rate, string _timestamp) public onlyOwner {
133         numberBtcUpdates = numberBtcUpdates.add(1);
134         btcUpdates[numberBtcUpdates] = Rate({
135             rate: _rate,
136             timestamp: _timestamp
137         });
138         RateUpdate("BTC", numberBtcUpdates, _timestamp, _rate);
139     }
140 
141     /**
142      * @dev Gets the latest Eth Euro rate
143      * @return a tuple containing the rate and the timestamp in human readable format
144      */
145     function getEthRate() public view returns(Rate) {
146         /* require(numberEthUpdates > 0); */
147         return ethUpdates[numberEthUpdates];
148             /* ethUpdates[numberEthUpdates].rate, */
149             /* ethUpdates[numberEthUpdates].timestamp */
150         /* ); */
151     }
152 
153     /**
154      * @dev Gets the latest Btc Euro rate
155      * @return a tuple containing the rate and the timestamp in human readable format
156      */
157     function getBtcRate() public view returns(string, string) {
158         /* require(numberBtcUpdates > 0); */
159         return (
160             btcUpdates[numberBtcUpdates].rate,
161             btcUpdates[numberBtcUpdates].timestamp
162         );
163     }
164 
165     /**
166      * @dev Gets the historic Eth Euro rate
167      * @param _updateNumber the number of the update the rate corresponds to.
168      * @return a tuple containing the rate and the timestamp in human readable format
169      */
170     function getHistEthRate(uint256 _updateNumber) public view returns(string, string) {
171         require(_updateNumber <= numberEthUpdates);
172         return (
173             ethUpdates[_updateNumber].rate,
174             ethUpdates[_updateNumber].timestamp
175         );
176     }
177 
178     /**
179      * @dev Gets the historic Btc Euro rate
180      * @param _updateNumber the number of the update the rate corresponds to.
181      * @return a tuple containing the rate and the timestamp in human readable format
182      */
183     function getHistBtcRate(uint256 _updateNumber) public view returns(string, string) {
184         require(_updateNumber <= numberBtcUpdates);
185         return (
186             btcUpdates[_updateNumber].rate,
187             btcUpdates[_updateNumber].timestamp
188         );
189     }
190 }