1 pragma solidity 0.4.24;
2 
3 interface Token {
4     function mint(address to, uint256 value) external returns (bool);
5 }
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that revert on error
10  */
11 library SafeMath {
12     /**
13     * @dev Multiplies two numbers, reverts on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0);
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52     * @dev Adds two numbers, reverts on overflow.
53     */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57 
58         return c;
59     }
60 
61     /**
62     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
63     * reverts when dividing by zero.
64     */
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77     address public owner;
78 
79 
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82 
83     /**
84      * @dev The Ownable constructor sets the original owner of the contract to the sender
85      * account.
86      */
87     constructor() public {
88         owner = msg.sender;
89     }
90 
91 
92     /**
93      * @dev Throws if called by any account other than the owner.
94      */
95     modifier onlyOwner() {
96         require(msg.sender == owner);
97         _;
98     }
99 
100 
101     /**
102      * @dev Allows the current owner to transfer control of the contract to a newOwner.
103      * @param newOwner The address to transfer ownership to.
104      */
105     function transferOwnership(address newOwner) public onlyOwner {
106         require(newOwner != address(0));
107         emit OwnershipTransferred(owner, newOwner);
108         owner = newOwner;
109     }
110 
111 }
112 
113 contract Investing is Ownable {
114     using SafeMath for uint;
115     Token public token;
116     address public trust;
117     address[] public investors;
118 
119     struct Investor {
120         address investor;
121         string currency;
122         uint rate;
123         uint amount;
124         bool redeemed;
125         uint timestamp;
126 		uint tokens;
127     }
128 
129     mapping(address => Investor[]) public investments;
130     mapping(address => uint) public investmentsCount;
131 
132     constructor () public {
133         owner = msg.sender;
134     }
135 
136     modifier onlyTrust() {
137         require(msg.sender == trust);
138         _;
139     }
140 
141     function makeInvestment(address _investor, string _currency, uint _rate, uint _amount) onlyTrust public returns (bool){
142         uint numberOfTokens;
143         numberOfTokens = _amount.div(_rate);
144         uint _counter = investments[_investor].push(Investor(_investor, _currency, _rate, _amount, false, now, numberOfTokens));
145         investmentsCount[_investor] = _counter;
146         require(token.mint(_investor, numberOfTokens));
147         investors.push(_investor);
148         return true;
149     }
150 
151     function redeem(address _investor, uint _index) public onlyTrust returns (bool) {
152         require(investments[_investor][_index].redeemed == false);
153         investments[_investor][_index].redeemed = true;
154         return true;
155     }
156 
157     function setTokenContractsAddress(address _tokenContract) public onlyOwner {
158         require(_tokenContract != address(0));
159         token = Token(_tokenContract);
160     }
161 
162     function setTrustAddress(address _trust) public onlyOwner {
163         require(_trust != address(0));
164         trust = _trust;
165     }
166 
167     function returnInvestors() public view returns (address[]) {
168         return investors;
169     }
170     
171     function getInvestmentsCounter(address _investor) public view returns(uint) {
172         return investmentsCount[_investor];
173     }
174     
175     function getInvestor(address _investor, uint _index) public view returns(string, uint, uint, bool, uint, uint) {
176         return (
177             investments[_investor][_index].currency,
178             investments[_investor][_index].rate,
179             investments[_investor][_index].amount,
180             investments[_investor][_index].redeemed,
181             investments[_investor][_index].timestamp,
182             investments[_investor][_index].tokens
183         );
184     }
185     
186 
187     function isRedeemed(address _investor, uint _index) public view returns(bool) {
188         return investments[_investor][_index].redeemed;
189     }
190 }