1 /**
2  *  Liven crowdsale contract.
3  *
4  *  There is no ETH hard cap in this contract due to the fact that Liven are
5  *  collecting funds in more than one currency. This contract is a single
6  *  component of a wider sale. The hard cap for the entire sale is USD $28m.
7  *
8  *  This sale has a six week time limit which can be extended by the owner. It
9  *  can be stopped at any time by the owner.
10  *
11  *  More information is available on https://livenpay.io.
12  *
13  *  Minimum contribution: 0.1 ETH
14  *  Maximum contribution: 1000 ETH
15  *  Minimum duration: 6 weeks from deployment
16  *
17  */
18 
19 pragma solidity 0.4.24;
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27     address private owner_;
28     event OwnershipRenounced(address indexed previousOwner);
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     /**
32     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33     * account.
34     */
35     constructor() public {
36         owner_ = msg.sender;
37     }
38 
39     /**
40     * @return the address of the owner.
41     */
42     function owner() public view returns(address) {
43         return owner_;
44     }
45 
46     /**
47     * @dev Throws if called by any account other than the owner.
48     */
49     modifier onlyOwner() {
50         require(msg.sender == owner_, "Only the owner can call this function.");
51         _;
52     }
53 
54     /**
55     * @dev Allows the current owner to relinquish control of the contract.
56     * @notice Renouncing to ownership will leave the contract without an owner.
57     * It will not be possible to call the functions with the `onlyOwner`
58     * modifier anymore.
59     */
60     function renounceOwnership() public onlyOwner {
61         emit OwnershipRenounced(owner_);
62         owner_ = address(0);
63     }
64 
65     /**
66     * @dev Allows the current owner to transfer control of the contract to a newOwner.
67     * @param _newOwner The address to transfer ownership to.
68     */
69     function transferOwnership(address _newOwner) public onlyOwner {
70         _transferOwnership(_newOwner);
71     }
72 
73     /**
74     * @dev Transfers control of the contract to a newOwner.
75     * @param _newOwner The address to transfer ownership to.
76     */
77     function _transferOwnership(address _newOwner) internal {
78         require(_newOwner != address(0), "Cannot transfer ownership to zero address.");
79         emit OwnershipTransferred(owner_, _newOwner);
80         owner_ = _newOwner;
81     }
82 }
83 
84 /**
85  * @title SafeMath
86  * @dev Math operations with safety checks that throw on error
87  */
88 library SafeMath {
89 
90     /**
91     * @dev Multiplies two numbers, throws on overflow.
92     */
93     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
94         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
95         // benefit is lost if 'b' is also tested.
96         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
97         if (_a == 0) {
98             return 0;
99         }
100 
101         c = _a * _b;
102         assert(c / _a == _b);
103         return c;
104     }
105 
106     /**
107     * @dev Integer division of two numbers, truncating the quotient.
108     */
109     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
110         // assert(_b > 0); // Solidity automatically throws when dividing by 0
111         // uint256 c = _a / _b;
112         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
113         return _a / _b;
114     }
115 
116     /**
117     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118     */
119     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
120         assert(_b <= _a);
121         return _a - _b;
122     }
123 
124     /**
125     * @dev Adds two numbers, throws on overflow.
126     */
127     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
128         c = _a + _b;
129         assert(c >= _a);
130         return c;
131     }
132 }
133 
134 contract LivenSale is Ownable {
135 
136     using SafeMath for uint256;
137 
138     uint256 public maximumContribution = 1000 ether;
139     uint256 public minimumContribution = 100 finney;
140     uint256 public totalWeiRaised;
141     uint256 public endTimestamp;
142     uint256 public constant SIX_WEEKS_IN_SECONDS = 86400 * 7 * 6;
143 
144     bool public saleEnded = false;
145     address public proceedsAddress;
146 
147     mapping (address => uint256) public weiContributed;
148 
149     constructor (address _proceedsAddress) public {
150         proceedsAddress = _proceedsAddress;
151         endTimestamp = block.timestamp + SIX_WEEKS_IN_SECONDS;
152     }
153 
154     function () public payable {
155         buyTokens();
156     }
157 
158     function buyTokens () public payable {
159         require(!saleEnded && block.timestamp < endTimestamp, "Campaign has ended. No more contributions possible.");
160         require(msg.value >= minimumContribution, "No contributions below 0.1 ETH.");
161         require(weiContributed[msg.sender] < maximumContribution, "Contribution cap already reached.");
162 
163         uint purchaseAmount = msg.value;
164         uint weiToReturn;
165         
166         // Check max contribution
167         uint remainingContributorAllowance = maximumContribution.sub(weiContributed[msg.sender]);
168         if (remainingContributorAllowance < purchaseAmount) {
169             purchaseAmount = remainingContributorAllowance;
170             weiToReturn = msg.value.sub(purchaseAmount);
171         }
172 
173         // Store allocation
174         weiContributed[msg.sender] = weiContributed[msg.sender].add(purchaseAmount);
175         totalWeiRaised = totalWeiRaised.add(purchaseAmount);
176 
177         // Forward ETH immediately to the multisig
178         proceedsAddress.transfer(purchaseAmount);
179 
180         // Return excess ETH
181         if (weiToReturn > 0) {
182             address(msg.sender).transfer(weiToReturn);
183         }
184     }
185 
186     function extendSale (uint256 _seconds) public onlyOwner {
187         endTimestamp += _seconds;
188     }
189 
190     function endSale () public onlyOwner {
191         saleEnded = true;
192     }
193 }