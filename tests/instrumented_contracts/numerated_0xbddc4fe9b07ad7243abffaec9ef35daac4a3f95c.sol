1 pragma solidity 0.4.24;
2 
3 // File: contracts/commons/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a / b;
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 // File: contracts/flavours/Ownable.sol
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44 
45     address public owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51      * account.
52      */
53     constructor() public {
54         owner = msg.sender;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner) public onlyOwner {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73     }
74 }
75 
76 // File: contracts/flavours/Lockable.sol
77 
78 /**
79  * @title Lockable
80  * @dev Base contract which allows children to
81  *      implement main operations locking mechanism.
82  */
83 contract Lockable is Ownable {
84     event Lock();
85     event Unlock();
86 
87     bool public locked = false;
88 
89     /**
90      * @dev Modifier to make a function callable
91     *       only when the contract is not locked.
92      */
93     modifier whenNotLocked() {
94         require(!locked);
95         _;
96     }
97 
98     /**
99      * @dev Modifier to make a function callable
100      *      only when the contract is locked.
101      */
102     modifier whenLocked() {
103         require(locked);
104         _;
105     }
106 
107     /**
108      * @dev called by the owner to locke, triggers locked state
109      */
110     function lock() public onlyOwner whenNotLocked {
111         locked = true;
112         emit Lock();
113     }
114 
115     /**
116      * @dev called by the owner
117      *      to unlock, returns to unlocked state
118      */
119     function unlock() public onlyOwner whenLocked {
120         locked = false;
121         emit Unlock();
122     }
123 }
124 
125 // File: contracts/base/BaseFixedERC20Token.sol
126 
127 contract BaseFixedERC20Token is Lockable {
128     using SafeMath for uint;
129 
130     /// @dev ERC20 Total supply
131     uint public totalSupply;
132 
133     mapping(address => uint) public balances;
134 
135     mapping(address => mapping(address => uint)) private allowed;
136 
137     /// @dev Fired if token is transferred according to ERC20 spec
138     event Transfer(address indexed from, address indexed to, uint value);
139 
140     /// @dev Fired if token withdrawal is approved according to ERC20 spec
141     event Approval(address indexed owner, address indexed spender, uint value);
142 
143     /**
144      * @dev Gets the balance of the specified address
145      * @param owner_ The address to query the the balance of
146      * @return An uint representing the amount owned by the passed address
147      */
148     function balanceOf(address owner_) public view returns (uint balance) {
149         return balances[owner_];
150     }
151 
152     /**
153      * @dev Transfer token for a specified address
154      * @param to_ The address to transfer to.
155      * @param value_ The amount to be transferred.
156      */
157     function transfer(address to_, uint value_) public whenNotLocked returns (bool) {
158         require(to_ != address(0) && value_ <= balances[msg.sender]);
159         // SafeMath.sub will throw an exception if there is not enough balance
160         balances[msg.sender] = balances[msg.sender].sub(value_);
161         balances[to_] = balances[to_].add(value_);
162         emit Transfer(msg.sender, to_, value_);
163         return true;
164     }
165 
166     /**
167      * @dev Transfer tokens from one address to another
168      * @param from_ address The address which you want to send tokens from
169      * @param to_ address The address which you want to transfer to
170      * @param value_ uint the amount of tokens to be transferred
171      */
172     function transferFrom(address from_, address to_, uint value_) public whenNotLocked returns (bool) {
173         require(to_ != address(0) && value_ <= balances[from_] && value_ <= allowed[from_][msg.sender]);
174         balances[from_] = balances[from_].sub(value_);
175         balances[to_] = balances[to_].add(value_);
176         allowed[from_][msg.sender] = allowed[from_][msg.sender].sub(value_);
177         emit Transfer(from_, to_, value_);
178         return true;
179     }
180 
181     /**
182      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
183      *
184      * Beware that changing an allowance with this method brings the risk that someone may use both the old
185      * and the new allowance by unfortunate transaction ordering
186      *
187      * To change the approve amount you first have to reduce the addresses
188      * allowance to zero by calling `approve(spender_, 0)` if it is not
189      * already 0 to mitigate the race condition described in:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      *
192      * @param spender_ The address which will spend the funds.
193      * @param value_ The amount of tokens to be spent.
194      */
195     function approve(address spender_, uint value_) public whenNotLocked returns (bool) {
196         if (value_ != 0 && allowed[msg.sender][spender_] != 0) {
197             revert();
198         }
199         allowed[msg.sender][spender_] = value_;
200         emit Approval(msg.sender, spender_, value_);
201         return true;
202     }
203 
204     /**
205      * @dev Function to check the amount of tokens that an owner allowed to a spender
206      * @param owner_ address The address which owns the funds
207      * @param spender_ address The address which will spend the funds
208      * @return A uint specifying the amount of tokens still available for the spender
209      */
210     function allowance(address owner_, address spender_) public view returns (uint) {
211         return allowed[owner_][spender_];
212     }
213 }
214 
215 // File: contracts/IonChain.sol
216 
217 /**
218  * @title IONC token contract.
219  */
220 contract IonChain is BaseFixedERC20Token {
221     using SafeMath for uint;
222 
223     string public constant name = "IonChain";
224 
225     string public constant symbol = "IONC";
226 
227     uint8 public constant decimals = 6;
228 
229     uint internal constant ONE_TOKEN = 1e6;
230 
231     constructor(uint totalSupplyTokens_) public {
232         locked = false;
233         totalSupply = totalSupplyTokens_ * ONE_TOKEN;
234         address creator = msg.sender;
235         balances[creator] = totalSupply;
236 
237         emit Transfer(0, this, totalSupply);
238         emit Transfer(this, creator, balances[creator]);
239     }
240 
241     // Disable direct payments
242     function() external payable {
243         revert();
244     }
245 
246 }