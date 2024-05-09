1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 contract Developed {
68     using SafeMath for uint256;
69     
70     struct Developer {
71         address account;
72         uint256 comission;
73         bool isCollab;
74     }
75     
76     // Public variables of the token
77     string public name;
78     string public symbol;
79     uint8 public decimals = 0;
80     // 18 decimals is the strongly suggested default, avoid changing it
81     uint64 public totalSupply;
82 
83 
84     // State variables for the payout
85     uint public payoutBalance = 0;
86     uint public payoutIndex = 0;
87     bool public paused = false;
88     uint public lastPayout;
89 
90 
91     constructor() public payable {        
92         Developer memory dev = Developer(msg.sender, 1 szabo, true);
93         developers[msg.sender] = dev;
94         developerAccounts.push(msg.sender);
95         name = "MyHealthData Divident Token";
96         symbol = "MHDDEV";
97         totalSupply = 1 szabo;
98     }
99     
100     // This generates a public event on the blockchain that will notify clients
101     event Transfer(address indexed from, address indexed to, uint256 value);
102     
103     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
104     
105     mapping(address => Developer) internal developers;
106     address[] public developerAccounts;
107     
108     mapping (address => mapping (address => uint256)) private _allowed;
109     
110     modifier comissionLimit (uint256 value) {
111         require(value < 1 szabo, "Invalid value");
112         _;
113     }
114 
115     modifier whenNotPaused () {
116         require(paused == false, "Transfers paused, to re-enable transfers finish the payout round.");
117         _;
118     }
119 
120     function () external payable {}
121 
122     function newDeveloper(address _devAccount, uint64 _comission, bool _isCollab) public comissionLimit(_comission) returns(address) {
123         require(_devAccount != address(0), "Invalid developer account");
124         
125         bool isCollab = _isCollab;
126         Developer storage devRequester = developers[msg.sender];
127         //"Developer have to be a collaborator in order to invite others to be a Developer
128         if (!devRequester.isCollab) {
129             isCollab = false;
130         }
131         
132         require(devRequester.comission>=_comission, "The developer requester must have comission balance in order to sell her commission");
133         devRequester.comission = devRequester.comission.sub(_comission);
134         
135         Developer memory dev = Developer(_devAccount, _comission, isCollab);
136         developers[_devAccount] = dev;
137 
138         developerAccounts.push(_devAccount);
139         return _devAccount;
140     }
141 
142     function totalDevelopers() public view returns (uint256) {
143         return developerAccounts.length;
144     }
145 
146     function getSingleDeveloper(address _devID) public view returns (address devAccount, uint256 comission, bool isCollaborator) {
147         require(_devID != address(0), "Dev ID must be greater than zero");
148         //require(devID <= numDevelopers, "Dev ID must be valid. It is greather than total developers available");
149         Developer memory dev = developers[_devID];
150         devAccount = dev.account;
151         comission = dev.comission;
152         isCollaborator = dev.isCollab;
153         return;
154     }
155     
156     function payComission() public returns (bool success) {
157         require (lastPayout < now - 14 days, "Only one payout every two weeks allowed");
158         paused = true;
159         if (payoutIndex == 0)
160             payoutBalance = address(this).balance;
161         for (uint i = payoutIndex; i < developerAccounts.length; i++) {
162             Developer memory dev = developers[developerAccounts[i]];
163             if (dev.comission > 0) {
164                 uint valueToSendToDev = (payoutBalance.mul(dev.comission)).div(1 szabo);
165 
166                 // Developers should ensure these TXs will not revert
167                 // otherwise they'll lose the payout (payout remains in 
168                 // balance and will split with everyone in the next round)
169                 dev.account.send(valueToSendToDev);
170 
171                 if (gasleft() < 100000) {
172                     payoutIndex = i + 1;
173                     return;
174                 }
175             }            
176         }
177         success = true;
178         payoutIndex = 0;
179         payoutBalance = 0;
180         paused = false;
181         lastPayout = now;
182         return;
183     }   
184     
185     /**
186     * @dev Gets the balance of the specified address.
187     * @param owner The address to query the balance of.
188     * @return An uint64 representing the amount owned by the passed address.
189     */
190     function balanceOf(address owner) public view returns (uint256) {
191         Developer memory dev = developers[owner];
192         return dev.comission;
193     }
194     
195     
196     /**
197     * @dev Transfer tokens from one address to another
198     * @param from address The address which you want to send tokens from
199     * @param to address The address which you want to transfer to
200     * @param value uint256 the amount of tokens to be transferred
201     */
202     function transferFrom(address from, address to, uint64 value) public comissionLimit(value) whenNotPaused returns (bool)    {
203                 
204         Developer storage devRequester = developers[from];
205         require(devRequester.comission > 0, "The developer receiver must exist");
206         
207         require(value <= balanceOf(from), "There is no enough balance to perform this operation");
208         require(value <= _allowed[from][msg.sender], "Trader is not allowed to transact to this limit");
209 
210         Developer storage devReciever = developers[to];
211         if (devReciever.account == address(0)) {
212             Developer memory dev = Developer(to, 0, false);
213             developers[to] = dev;
214             developerAccounts.push(to);
215         }
216         
217         devRequester.comission = devRequester.comission.sub(value);
218         devReciever.comission = devReciever.comission.add(value);
219 
220         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
221         
222         emit Transfer(from, to, value);
223         return true;
224     }
225 
226     /**
227     * @dev Transfer token for a specified address
228     * @param to The address to transfer to.
229     * @param value The amount to be transferred.
230     */
231     function transfer(address to, uint64 value) public comissionLimit(value) whenNotPaused returns (bool) {
232         require(value <= balanceOf(msg.sender), "Spender does not have enough balance");
233         require(to != address(0), "Invalid new owner address");
234              
235         Developer storage devRequester = developers[msg.sender];
236         
237         require(devRequester.comission >= value, "The developer requester must have comission balance in order to sell her commission");
238         
239         Developer storage devReciever = developers[to];
240         if (devReciever.account == address(0)) {
241             Developer memory dev = Developer(to, 0, false);
242             developers[to] = dev;
243             developerAccounts.push(to);
244         }
245         
246         devRequester.comission = devRequester.comission.sub(value);
247         devReciever.comission = devReciever.comission.add(value);
248         
249         emit Transfer(msg.sender, to, value);
250         return true;
251     }
252     
253     /**
254     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
255     * Beware that changing an allowance with this method brings the risk that someone may use both the old
256     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
257     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
258     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259     * @param spender The address which will spend the funds.
260     * @param value The amount of tokens to be spent.
261     */
262     function approve(address spender, uint64 value) public comissionLimit(value) returns (bool) {
263         require(spender != address(0), "Invalid spender");
264     
265         _allowed[msg.sender][spender] = value;
266         emit Approval(msg.sender, spender, value);
267         return true;
268     }
269 
270     /**
271     * @dev Function to check the amount of tokens that an owner allowed to a spender.
272     * @param owner address The address which owns the funds.
273     * @param spender address The address which will spend the funds.
274     * @return A uint64 specifying the amount of tokens still available for the spender.
275     */
276     function allowance(address owner, address spender) public view returns (uint256)    {
277         return _allowed[owner][spender];
278     }
279 
280 
281     /**
282     * @dev Increase the amount of tokens that an owner allowed to a spender.
283     * approve should be called when allowed_[_spender] == 0. To increment
284     * allowed value is better to use this function to avoid 2 calls (and wait until
285     * the first transaction is mined)
286     * @param spender The address which will spend the funds.
287     * @param addedValue The amount of tokens to increase the allowance by.
288     */
289     function increaseAllowance(address spender, uint64 addedValue) public comissionLimit(addedValue) returns (bool)    {
290         require(spender != address(0), "Invalid spender");
291         
292         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
293         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
294         return true;
295     }
296     
297 
298     /**
299     * @dev Decrease the amount of tokens that an owner allowed to a spender.
300     * approve should be called when allowed_[_spender] == 0. To decrement
301     * allowed value is better to use this function to avoid 2 calls (and wait until
302     * the first transaction is mined)
303     * @param spender The address which will spend the funds.
304     * @param subtractedValue The amount of tokens to decrease the allowance by.
305     */
306     function decreaseAllowance(address spender, uint256 subtractedValue) public comissionLimit(subtractedValue) returns (bool)    {
307         require(spender != address(0), "Invalid spender");
308         
309         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
310         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
311         return true;
312     }
313 
314 }