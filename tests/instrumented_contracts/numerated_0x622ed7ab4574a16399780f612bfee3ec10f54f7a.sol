1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 
90 
91 /**
92  * @title Pausable
93  * @dev Base contract which allows children to implement an emergency stop mechanism.
94  */
95 contract Pausable is Ownable {
96   event Pause();
97   event Unpause();
98 
99   bool public paused = false;
100 
101 
102   /**
103    * @dev Modifier to make a function callable only when the contract is not paused.
104    */
105   modifier whenNotPaused() {
106     require(!paused);
107     _;
108   }
109 
110   /**
111    * @dev Modifier to make a function callable only when the contract is paused.
112    */
113   modifier whenPaused() {
114     require(paused);
115     _;
116   }
117 
118   /**
119    * @dev called by the owner to pause, triggers stopped state
120    */
121   function pause() onlyOwner whenNotPaused public {
122     paused = true;
123     Pause();
124   }
125 
126   /**
127    * @dev called by the owner to unpause, returns to normal state
128    */
129   function unpause() onlyOwner whenPaused public {
130     paused = false;
131     Unpause();
132   }
133 }
134 
135 
136 contract PrivateSaleTimToken is Pausable {
137     using SafeMath for uint;
138 
139     string public constant name = "Private Sale Tim Token";
140     uint public fiatValueMultiplier = 10 ** 6;
141     uint public tokenDecimals = 10 ** 18;
142     uint public ethUsdRate;
143 
144     mapping(address => uint) investors;
145     mapping(address => uint) public tokenHolders;
146 
147     address beneficiary;
148 
149     modifier allowedToPay(){
150         require(investors[msg.sender] > 0);
151         _;
152     }
153 
154     function setRate(uint rate) external onlyOwner {
155         require(rate > 0);
156         ethUsdRate = rate;
157     }
158 
159     function setInvestorStatus(address investor, uint bonus) external onlyOwner {
160         require(investor != 0x0);
161         investors[investor] = bonus;
162     }
163 
164     function setBeneficiary(address investor) external onlyOwner {
165         beneficiary = investor;
166     }
167 
168     function() payable public whenNotPaused allowedToPay{
169         uint tokens = msg.value.mul(ethUsdRate).div(fiatValueMultiplier);
170         uint bonus = tokens.div(100).mul(investors[msg.sender]);
171         tokenHolders[msg.sender] = tokens.add(bonus);
172         beneficiary.transfer(msg.value);
173     }
174 }