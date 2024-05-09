1 pragma solidity 0.4.25;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract CloneFactory {
6 
7   event CloneCreated(address indexed target, address clone);
8 
9   function createClone(address target) internal returns (address result) {
10     bytes memory clone = hex"3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3";
11     bytes20 targetBytes = bytes20(target);
12     for (uint i = 0; i < 20; i++) {
13       clone[20 + i] = targetBytes[i];
14     }
15     assembly {
16       let len := mload(clone)
17       let data := add(clone, 0x20)
18       result := create(0, data, len)
19     }
20   }
21 }
22 
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 contract DeconetPaymentsSplitting {
70     using SafeMath for uint;
71 
72     // Logged on this distribution set up completion.
73     event DistributionCreated (
74         address[] destinations,
75         uint[] sharesMantissa,
76         uint sharesExponent
77     );
78 
79     // Logged when funds landed to or been sent out from this contract balance.
80     event FundsOperation (
81         address indexed senderOrAddressee,
82         uint amount,
83         FundsOperationType indexed operationType
84     );
85 
86     // Enumeration of possible funds operations.
87     enum FundsOperationType { Incoming, Outgoing }
88 
89     // Describes Distribution destination and its share of all incoming funds.
90     struct Distribution {
91         // Destination address of the distribution.
92         address destination;
93 
94         // Floating-point number mantissa of a share allotted for a destination address.
95         uint mantissa;
96     }
97 
98     // Stores exponent of a power term of a floating-point number.
99     uint public sharesExponent;
100 
101     // Stores list of distributions.
102     Distribution[] public distributions;
103 
104     /**
105      * @dev Payable fallback that tries to send over incoming funds to the distribution destinations splitted
106      * by pre-configured shares. In case when there is not enough gas sent for the transaction to complete
107      * distribution, all funds will be kept in contract untill somebody calls `withdrawFullContractBalance` to
108      * run postponed distribution and withdraw contract's balance funds.
109      */
110     function () public payable {
111         emit FundsOperation(msg.sender, msg.value, FundsOperationType.Incoming);
112         distributeFunds();
113     }
114 
115     /**
116      * @dev Set up distribution for the current clone, can be called only once.
117      * @param _destinations Destination addresses of the current payments splitting contract clone.
118      * @param _sharesMantissa Mantissa values for destinations shares ordered respectively with `_destinations`.
119      * @param _sharesExponent Exponent of a power term that forms shares floating-point numbers, expected to
120      * be the same for all values in `_sharesMantissa`.
121      */
122     function setUpDistribution(
123         address[] _destinations,
124         uint[] _sharesMantissa,
125         uint _sharesExponent
126     )
127         external
128     {
129         require(distributions.length == 0, "Contract can only be initialized once"); // Make sure the clone isn't initialized yet.
130         require(_destinations.length <= 8 && _destinations.length > 0, "There is a maximum of 8 destinations allowed");  // max of 8 destinations
131         // prevent integer overflow when math with _sharesExponent happens
132         // also ensures that low balances can be distributed because balance must always be >= 10**(sharesExponent + 2)
133         require(_sharesExponent <= 4, "The maximum allowed sharesExponent is 4");
134         // ensure that lengths of arrays match so array out of bounds can't happen
135         require(_destinations.length == _sharesMantissa.length, "Length of destinations does not match length of sharesMantissa");
136 
137         uint sum = 0;
138         for (uint i = 0; i < _destinations.length; i++) {
139             // Forbid contract as destination so that transfer can never fail
140             require(!isContract(_destinations[i]), "A contract may not be a destination address");
141             sum = sum.add(_sharesMantissa[i]);
142             distributions.push(Distribution(_destinations[i], _sharesMantissa[i]));
143         }
144          // taking into account 100% by adding 2 to the exponent.
145         require(sum == 10**(_sharesExponent.add(2)), "The sum of all sharesMantissa should equal 10 ** ( _sharesExponent + 2 ) but it does not.");
146         sharesExponent = _sharesExponent;
147         emit DistributionCreated(_destinations, _sharesMantissa, _sharesExponent);
148     }
149 
150     /**
151      * @dev Process the available balance through the distribution and send money over to destination addresses.
152      */
153     function distributeFunds() public {
154         uint balance = address(this).balance;
155         require(balance >= 10**(sharesExponent.add(2)), "You can not split up less wei than sum of all shares");
156         for (uint i = 0; i < distributions.length; i++) {
157             Distribution memory distribution = distributions[i];
158             uint amount = calculatePayout(balance, distribution.mantissa, sharesExponent);
159             distribution.destination.transfer(amount);
160             emit FundsOperation(distribution.destination, amount, FundsOperationType.Outgoing);
161         }
162     }
163 
164     /**
165      * @dev Returns length of distributions array
166      * @return Length of distributions array
167     */
168     function distributionsLength() public view returns (uint256) {
169         return distributions.length;
170     }
171 
172 
173     /**
174      * @dev Calculates a share of the full amount.
175      * @param _fullAmount Full amount.
176      * @param _shareMantissa Mantissa of the percentage floating-point number.
177      * @param _shareExponent Exponent of the percentage floating-point number.
178      * @return An uint of the payout.
179      */
180     function calculatePayout(uint _fullAmount, uint _shareMantissa, uint _shareExponent) private pure returns(uint) {
181         return (_fullAmount.div(10 ** (_shareExponent.add(2)))).mul(_shareMantissa);
182     }
183 
184     /**
185      * @dev Checks whether or not a given address contains a contract
186      * @param _addr The address to check
187      * @return A boolean indicating whether or not the address is a contract
188      */
189     function isContract(address _addr) private view returns (bool) {
190         uint32 size;
191         assembly {
192             size := extcodesize(_addr)
193         }
194         return (size > 0);
195     }
196 }
197 
198 contract DeconetPaymentsSplittingFactory is CloneFactory {
199 
200     // PaymentsSplitting master-contract address.
201     address public libraryAddress;
202 
203     // Logged when a new PaymentsSplitting clone is deployed to the chain.
204     event PaymentsSplittingCreated(address newCloneAddress);
205 
206     /**
207      * @dev Constructor for the contract.
208      * @param _libraryAddress PaymentsSplitting master-contract address.
209      */
210     constructor(address _libraryAddress) public {
211         libraryAddress = _libraryAddress;
212     }
213 
214     /**
215      * @dev Create PaymentsSplitting clone.
216      * @param _destinations Destination addresses of the new PaymentsSplitting contract clone.
217      * @param _sharesMantissa Mantissa values for destinations shares ordered respectively with `_destinations`.
218      * @param _sharesExponent Exponent of a power term that forms shares floating-point numbers, expected to
219      * be the same for all values in `_sharesMantissa`.
220      */
221     function createPaymentsSplitting(
222         address[] _destinations,
223         uint[] _sharesMantissa,
224         uint _sharesExponent
225     )
226         external
227         returns(address)
228     {
229         address clone = createClone(libraryAddress);
230         DeconetPaymentsSplitting(clone).setUpDistribution(_destinations, _sharesMantissa, _sharesExponent);
231         emit PaymentsSplittingCreated(clone);
232         return clone;
233     }
234 }