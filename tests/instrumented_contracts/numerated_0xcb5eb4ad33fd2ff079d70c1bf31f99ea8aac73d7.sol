1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.2;
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
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      * @notice Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61         assert(block.timestamp < expiryTime);
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         _transferOwnership(newOwner);
65     }
66 
67     /**
68      * @dev Transfers control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function _transferOwnership(address newOwner) internal {
72         require(newOwner != address(0));
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
79 
80 pragma solidity ^0.5.2;
81 
82 /**
83  * @title SafeMath
84  * @dev Unsigned math operations with safety checks that revert on error
85  */
86 library SafeMath {
87     /**
88      * @dev Multiplies two unsigned integers, reverts on overflow.
89      */
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92         // benefit is lost if 'b' is also tested.
93         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94         if (a == 0) {
95             return 0;
96         }
97 
98         uint256 c = a * b;
99         require(c / a == b);
100 
101         return c;
102     }
103 
104     /**
105      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Solidity only automatically asserts when dividing by 0
109         require(b > 0);
110         uint256 c = a / b;
111         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
112 
113         return c;
114     }
115 
116     /**
117      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         require(b <= a);
121         uint256 c = a - b;
122 
123         return c;
124     }
125 
126     /**
127      * @dev Adds two unsigned integers, reverts on overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a);
132 
133         return c;
134     }
135 
136     /**
137      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
138      * reverts when dividing by zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b != 0);
142         return a % b;
143     }
144 }
145 
146 // File: contracts/DollarAuction.sol
147 
148 pragma solidity ^0.5.2;
149 
150 
151 
152 contract DollarAuction is Ownable {
153     using SafeMath for uint256;
154 
155     uint256 constant bidFee = 1e15;
156     uint256 constant minimumBidDelta = 1e15;
157     uint256 constant sixHours = 6 * 60 * 60;
158     uint256 constant twentyFourHours = sixHours * 4;
159     uint256 constant tenthEth = 1e17;
160     uint256 public expiryTime;
161     uint256 public prize;
162     address payable public lastDonor;
163     address payable public winningBidder;
164     address payable public losingBidder;
165     uint256 public winningBid;
166     uint256 public losingBid;
167 
168     constructor() public payable {
169         reset();
170     }
171 
172     modifier onlyActiveAuction() {
173         require(isActiveAuction(), "Auction not active");
174         _;
175     }
176 
177     modifier onlyInactiveAuction() {
178         require(!isActiveAuction(), "Auction not expired");
179         _;
180     }
181 
182     function increasePrize() public payable onlyActiveAuction {
183         require(msg.value >= tenthEth, "Must increase by at least 0.1ETH");
184 
185         prize = prize.add(msg.value);
186         lastDonor = msg.sender;
187     }
188 
189     function bid() public payable onlyActiveAuction {
190         uint bidAmount = msg.value.sub(bidFee);
191 
192         require(bidAmount > winningBid.add(minimumBidDelta), "Bid too small");
193 
194         repayThirdPlace();
195         updateLosingBidder();
196         updateWinningBidder(bidAmount, msg.sender);
197 
198         if(expiryTime < block.timestamp + sixHours){
199             expiryTime = block.timestamp + sixHours;
200         }
201     }
202 
203     function withdrawPrize() public onlyInactiveAuction {
204         require(msg.sender == winningBidder || isOwner(), "not authorized");
205 
206         winningBidder.transfer(prize);
207         address payable o = address(uint160(owner()));
208         uint256 bids = winningBid.add(losingBid);
209         lastDonor.transfer(bids);
210         o.transfer(address(this).balance);
211 
212         prize = 0;
213     }
214 
215     function restart() public payable onlyOwner onlyInactiveAuction {
216         reset();
217     }
218 
219     function collectedFees() public view onlyOwner returns (uint) {
220         return address(this).balance.sub(prize).sub(winningBid).sub(losingBid);
221     }
222 
223     function reset() internal onlyOwner {
224         expiryTime = block.timestamp + 2*twentyFourHours;
225         prize = msg.value;
226         lastDonor = msg.sender;
227         winningBidder = msg.sender;
228         losingBidder = msg.sender;
229         winningBid = 0;
230         losingBid = 0;
231     }
232 
233     function updateWinningBidder(uint256 _bid, address payable _bidder) internal {
234         winningBid = _bid;
235         winningBidder = _bidder;
236     }
237 
238     function updateLosingBidder() internal {
239         losingBidder = winningBidder;
240         losingBid = winningBid;
241     }
242 
243     function repayThirdPlace() internal {
244         losingBidder.transfer(losingBid);
245     }
246 
247     function isActiveAuction() public view returns(bool) {
248         return block.timestamp < expiryTime;
249     }
250 
251     // what happens if donate fails? Money returned to sender?
252     function() external payable {
253         bid();
254     }
255 }