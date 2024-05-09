1 pragma solidity ^0.4.21;
2 contract ERC20Token  {
3   function transfer(address to, uint256 value) public returns (bool);
4 }
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14   
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a * b;
50     assert(a == 0 || c / a == b);
51     return c;
52   }
53 
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b > 0); // Solidity automatically throws when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return c;
59   }
60 
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 
74 /**
75  * @title Pausable
76  * @dev Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79   event Pause();
80   event Unpause();
81 
82   bool public paused = false;
83 
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is not paused.
87    */
88   modifier whenNotPaused() {
89     require(!paused);
90     _;
91   }
92 
93   /**
94    * @dev Modifier to make a function callable only when the contract is paused.
95    */
96   modifier whenPaused() {
97     require(paused);
98     _;
99   }
100 
101   /**
102    * @dev called by the owner to pause, triggers stopped state
103    */
104   function pause() onlyOwner whenNotPaused public {
105     paused = true;
106    emit Pause();
107   }
108 
109   /**
110    * @dev called by the owner to unpause, returns to normal state
111    */
112   function unpause() onlyOwner whenPaused public {
113     paused = false;
114    emit Unpause();
115   }
116 }
117 /**
118  * @title Destructible
119  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
120  */
121 contract Destructible is Pausable {
122 
123   function Destructible() public payable { }
124 
125   /**
126    * @dev Transfers the current balance to the owner and terminates the contract.
127    */
128   function destroy() onlyOwner public {
129     selfdestruct(owner);
130   }
131 
132   function destroyAndSend(address _recipient) onlyOwner public {
133     selfdestruct(_recipient);
134   }
135 }
136 
137 
138 
139 
140 contract PTMCrowdFund is Destructible {
141     event PurchaseToken (address indexed from,uint256 weiAmount,uint256 _tokens);
142      uint public priceOfToken=250000000000000;//1 eth = 4000 PTM
143     ERC20Token erc20Token;
144     using SafeMath for uint256;
145     uint256 etherRaised;
146     uint public constant decimals = 18;
147     function PTMCrowdFund () public {
148         owner = msg.sender;
149         erc20Token = ERC20Token(0x7c32DB0645A259FaE61353c1f891151A2e7f8c1e);
150     }
151     function updatePriceOfToken(uint256 priceInWei) external onlyOwner {
152         priceOfToken = priceInWei;
153     }
154     
155     function updateTokenAddress ( address _tokenAddress) external onlyOwner {
156         erc20Token = ERC20Token(_tokenAddress);
157     }
158     
159       function()  public whenNotPaused payable {
160           require(msg.value>0);
161           uint256 tokens = (msg.value * (10 ** decimals)) / priceOfToken;
162           erc20Token.transfer(msg.sender,tokens);
163           etherRaised += msg.value;
164           
165       }
166       
167         /**
168     * Transfer entire balance to any account (by owner and admin only)
169     **/
170     function transferFundToAccount(address _accountByOwner) public onlyOwner {
171         require(etherRaised > 0);
172         _accountByOwner.transfer(etherRaised);
173         etherRaised = 0;
174     }
175 
176     
177     /**
178     * Transfer part of balance to any account (by owner and admin only)
179     **/
180     function transferLimitedFundToAccount(address _accountByOwner, uint256 balanceToTransfer) public onlyOwner   {
181         require(etherRaised > balanceToTransfer);
182         _accountByOwner.transfer(balanceToTransfer);
183         etherRaised = etherRaised.sub(balanceToTransfer);
184     }
185     
186 }