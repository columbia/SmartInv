1 pragma solidity 0.4.15;
2 
3 interface STQToken {
4     function mint(address _to, uint256 _amount) external;
5 }
6 
7 /**
8  * @title Helps contracts guard agains rentrancy attacks.
9  * @author Remco Bloemen <remco@2π.com>
10  * @notice If you mark a function `nonReentrant`, you should also
11  * mark it `external`.
12  */
13 contract ReentrancyGuard {
14 
15   /**
16    * @dev We use a single lock for the whole contract.
17    */
18   bool private rentrancy_lock = false;
19 
20   /**
21    * @dev Prevents a contract from calling itself, directly or indirectly.
22    * @notice If you mark a function `nonReentrant`, you should also
23    * mark it `external`. Calling one nonReentrant function from
24    * another is not supported. Instead, you can implement a
25    * `private` function doing the actual work, and a `external`
26    * wrapper marked as `nonReentrant`.
27    */
28   modifier nonReentrant() {
29     require(!rentrancy_lock);
30     rentrancy_lock = true;
31     _;
32     rentrancy_lock = false;
33   }
34 
35 }
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that throw on error
40  */
41 library SafeMath {
42   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
43     uint256 c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function div(uint256 a, uint256 b) internal constant returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint256 a, uint256 b) internal constant returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address public owner;
74 
75 
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   function Ownable() {
81     owner = msg.sender;
82   }
83 
84 
85   /**
86    * @dev Throws if called by any account other than the owner.
87    */
88   modifier onlyOwner() {
89     require(msg.sender == owner);
90     _;
91   }
92 
93 
94   /**
95    * @dev Allows the current owner to transfer control of the contract to a newOwner.
96    * @param newOwner The address to transfer ownership to.
97    */
98   function transferOwnership(address newOwner) onlyOwner {
99     if (newOwner != address(0)) {
100       owner = newOwner;
101     }
102   }
103 
104 }
105 
106 
107 /// @title Storiqa pre-sale contract
108 contract STQPreSale is Ownable, ReentrancyGuard {
109     using SafeMath for uint256;
110 
111     event FundTransfer(address backer, uint amount, bool isContribution);
112 
113     function STQPreSale(address token, address funds) {
114         require(address(0) != address(token) && address(0) != address(funds));
115 
116         m_token = STQToken(token);
117         m_funds = funds;
118     }
119 
120 
121     // PUBLIC interface: payments
122 
123     // fallback function as a shortcut
124     function() payable {
125         require(0 == msg.data.length);
126         buy();  // only internal call here!
127     }
128 
129     /// @notice ICO participation
130     /// @return number of STQ tokens bought (with all decimal symbols)
131     function buy()
132         public
133         payable
134         nonReentrant
135         returns (uint)
136     {
137         address investor = msg.sender;
138         uint256 payment = msg.value;
139         require(payment >= c_MinInvestment);
140         require(now < 1507766400);
141 
142         // issue tokens
143         uint stq = payment.mul(c_STQperETH);
144         m_token.mint(investor, stq);
145 
146         // record payment
147         m_funds.transfer(payment);
148         FundTransfer(investor, payment, true);
149 
150         return stq;
151     }
152 
153     /// @notice Tests ownership of the current caller.
154     /// @return true if it's an owner
155     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
156     // addOwner/changeOwner and to isOwner.
157     function amIOwner() external constant onlyOwner returns (bool) {
158         return true;
159     }
160 
161 
162     // FIELDS
163 
164     /// @notice starting exchange rate of STQ
165     uint public constant c_STQperETH = 150000;
166 
167     /// @notice minimum investment
168     uint public constant c_MinInvestment = 10 finney;
169 
170     /// @dev contract responsible for token accounting
171     STQToken public m_token;
172 
173     /// @dev address responsible for investments accounting
174     address public m_funds;
175 }