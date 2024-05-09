1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address private _owner;
11     
12     event OwnershipRenounced(address indexed previousOwner);
13     event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16     );
17     
18     /**
19     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20     * account.
21     */
22     constructor() public {
23         _owner = msg.sender;
24     }
25     
26     /**
27     * @return the address of the owner.
28     */
29     function owner() public view returns(address) {
30         return _owner;
31     }
32     
33     /**
34     * @dev Throws if called by any account other than the owner.
35     */
36     modifier contract_onlyOwner() {
37     require(isOwner());
38     _;
39     }
40     
41     /**
42     * @return true if `msg.sender` is the owner of the contract.
43     */
44     function isOwner() public view returns(bool) {
45         return msg.sender == _owner;
46     }
47     
48     /**
49     * @dev Allows the current owner to relinquish control of the contract.
50     * @notice Renouncing to ownership will leave the contract without an owner.
51     * It will not be possible to call the functions with the `onlyOwner`
52     * modifier anymore.
53     */
54     function renounceOwnership() public contract_onlyOwner {
55         emit OwnershipRenounced(_owner);
56         _owner = address(0);
57     }
58     
59     /**
60     * @dev Allows the current owner to transfer control of the contract to a newOwner.
61     * @param newOwner The address to transfer ownership to.
62     */
63     function transferOwnership(address newOwner) public contract_onlyOwner {
64         _transferOwnership(newOwner);
65     }
66     
67     /**
68     * @dev Transfers control of the contract to a newOwner.
69     * @param newOwner The address to transfer ownership to.
70     */
71     function _transferOwnership(address newOwner) internal {
72         require(newOwner != address(0));
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 
79 
80 /**
81 * @title SafeMath
82 * @dev Math operations with safety checks that revert on error
83 */
84 library SafeMath {
85 
86     /**
87     * @dev Multiplies two numbers, reverts on overflow.
88     */
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
91         // benefit is lost if 'b' is also tested.
92         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
93         if (a == 0) {
94         return 0;
95         }
96 
97         uint256 c = a * b;
98         require(c / a == b);
99 
100         return c;
101     }
102 
103     /**
104     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
105     */
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         require(b > 0); // Solidity only automatically asserts when dividing by 0
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
116     */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a);
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125     * @dev Adds two numbers, reverts on overflow.
126     */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a);
130 
131         return c;
132     }
133 
134     /**
135     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
136     * reverts when dividing by zero.
137     */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         require(b != 0);
140         return a % b;
141     }
142 }
143 
144 
145 
146 contract Auction is Ownable {
147     
148     using SafeMath for uint256;
149     
150     event bidPlaced(uint bid, address _address);
151     event etherTransfered(uint amount, address _address);
152     
153     string _itemName;
154     
155     address _highestBidder;
156     uint _highestBid;
157     uint _minStep;
158     uint _end;
159     uint _start;
160     
161     constructor() public {
162         
163         _itemName = 'Pumpkinhead 2';
164         _highestBid = 0;
165         _highestBidder = address(this);
166         
167     				// 					    end
168         // 23.10. 23:59pm UTC Pumpkinhead 1	1540339140
169         // 27.10. 23:59pm UTC Pumpkinhead 2	1540684740
170         // 31.10. 23:30pm UTC Pumpkinhead 3	1541028600
171         // 31.10. 23:59pm UTC Frankie  		1541030340
172         
173         _end = 1540684740;
174         _start = _end - 3 days;
175 
176         _minStep = 10000000000000000;
177 
178     }
179     
180     function queryBid() public view returns (string, uint, uint, address, uint, uint) {
181         return (_itemName, _start, _highestBid, _highestBidder, _end, _highestBid+_minStep);
182     }
183     
184     function placeBid() payable public returns (bool) {
185         require(block.timestamp > _start, 'Auction not started');
186         require(block.timestamp < _end, 'Auction ended');
187         require(msg.value >= _highestBid.add(_minStep), 'Amount too low');
188 
189         uint _payout = _highestBid;
190         _highestBid = msg.value;
191         
192         address _oldHighestBidder = _highestBidder;
193         _highestBidder = msg.sender;
194         
195         if(_oldHighestBidder.send(_payout) == true) {
196             emit etherTransfered(_payout, _oldHighestBidder);
197         }
198         
199         emit bidPlaced(_highestBid, _highestBidder);
200         
201         return true;
202     }
203     
204     function queryBalance() public view returns (uint) {
205         return address(this).balance;
206     }
207     
208     function weiToOwner(address _address) public contract_onlyOwner returns (bool success) {
209         require(block.timestamp > _end, 'Auction not ended');
210 
211         _address.transfer(address(this).balance);
212         
213         return true;
214     }
215 }