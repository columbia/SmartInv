1 pragma solidity ^0.4.24;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender)
68     public view returns (uint256);
69 
70   function transferFrom(address from, address to, uint256 value)
71     public returns (bool);
72 
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(
75     address indexed owner,
76     address indexed spender,
77     uint256 value
78   );
79 }
80 
81 /**
82  * @title Ownable
83  * @dev The Ownable contract has an owner address, and provides basic authorization control
84  * functions, this simplifies the implementation of "user permissions".
85  */
86 contract Ownable {
87   address public owner;
88 
89 
90   event OwnershipRenounced(address indexed previousOwner);
91   event OwnershipTransferred(
92     address indexed previousOwner,
93     address indexed newOwner
94   );
95 
96 
97   /**
98    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99    * account.
100    */
101   constructor() public {
102     owner = msg.sender;
103   }
104 
105   /**
106    * @dev Throws if called by any account other than the owner.
107    */
108   modifier onlyOwner() {
109     require(msg.sender == owner);
110     _;
111   }
112 
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address newOwner) public onlyOwner {
118     require(newOwner != address(0));
119     emit OwnershipTransferred(owner, newOwner);
120     owner = newOwner;
121   }
122 
123 }
124 
125 /**
126  * @title Pausable
127  * @dev Base contract which allows children to implement an emergency stop mechanism.
128  */
129 contract Pausable is Ownable {
130   event Pause();
131   event Unpause();
132 
133   bool public paused = false;
134 
135 
136   /**
137    * @dev Modifier to make a function callable only when the contract is not paused.
138    */
139   modifier whenNotPaused() {
140     require(!paused);
141     _;
142   }
143 
144   /**
145    * @dev Modifier to make a function callable only when the contract is paused.
146    */
147   modifier whenPaused() {
148     require(paused);
149     _;
150   }
151 
152   /**
153    * @dev called by the owner to pause, triggers stopped state
154    */
155   function pause() onlyOwner whenNotPaused public {
156     paused = true;
157     emit Pause();
158   }
159 
160   /**
161    * @dev called by the owner to unpause, returns to normal state
162    */
163   function unpause() onlyOwner whenPaused public {
164     paused = false;
165     emit Unpause();
166   }
167 }
168 
169 /**
170  * @title ERC20 Private Token Generation Program
171  */
172 contract ChainBowPrivateSale is Pausable {
173 
174     using SafeMath for uint256;
175 
176     ERC20 public tokenContract;
177     address public teamWallet;
178     string public leader;
179     uint256 public rate = 5000;
180 
181     uint256 public totalSupply = 0;
182 
183     event Buy(address indexed sender, address indexed recipient, uint256 value, uint256 tokens);
184 
185     mapping(address => uint256) public records;
186 
187     constructor(address _tokenContract, address _teamWallet, string _leader, uint _rate) public {
188         require(_tokenContract != address(0));
189         require(_teamWallet != address(0));
190         tokenContract = ERC20(_tokenContract);
191         teamWallet = _teamWallet;
192         leader = _leader;
193         rate = _rate;
194     }
195 
196 
197     function () payable public {
198         buy(msg.sender);
199     }
200 
201     function buy(address recipient) payable public whenNotPaused {
202         require(msg.value >= 0.1 ether);
203 
204         uint256 tokens =  rate.mul(msg.value);
205 
206         tokenContract.transferFrom(teamWallet, msg.sender, tokens);
207 
208         records[recipient] = records[recipient].add(tokens);
209         totalSupply = totalSupply.add(tokens);
210 
211         emit Buy(msg.sender, recipient, msg.value, tokens);
212 
213     }
214 
215 
216     /**
217      * change rate
218      */
219     function changeRate(uint256 _rate) public onlyOwner {
220         rate = _rate;
221     }
222 
223     /**
224      * change team wallet
225      */
226     function changeTeamWallet(address _teamWallet) public onlyOwner {
227         teamWallet = _teamWallet;
228     }
229 
230     /**
231      * withdraw ether
232      */
233     function withdrawEth() public onlyOwner {
234         teamWallet.transfer(address(this).balance);
235     }
236 
237 
238     /**
239      * withdraw foreign tokens
240      */
241     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
242         ERC20Basic token = ERC20Basic(_tokenContract);
243         uint256 amount = token.balanceOf(address(this));
244         return token.transfer(owner, amount);
245     }
246 
247 }