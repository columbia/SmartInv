1 pragma solidity ^0.4.21;
2 // ----------------------------------------------------------------------------
3 // ERC Token Standard #20 Interface
4 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
5 // ----------------------------------------------------------------------------
6 contract ERC20Interface {
7     function totalSupply() public constant returns (uint);
8     function balanceOf(address tokenOwner) public constant returns (uint balance);
9     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
10     function transfer(address to, uint tokens) public returns (bool success);
11     function approve(address spender, uint tokens) public returns (bool success);
12     function transferFrom(address from, address to, uint tokens) public returns (bool success);
13 
14     event Transfer(address indexed from, address indexed to, uint tokens);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 
18 // ----------------------------------------------------------------------------
19 // Contract function to receive approval and execute function in one call
20 //
21 // Borrowed from MiniMeToken
22 // ----------------------------------------------------------------------------
23 contract ApproveAndCallFallBack {
24     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
25 }
26 
27 // ----------------------------------------------------------------------------
28 // Safe maths
29 // ----------------------------------------------------------------------------
30 library SafeMath {
31     function add(uint a, uint b) internal pure returns (uint c) {
32         c = a + b;
33         require(c >= a);
34     }
35     function sub(uint a, uint b) internal pure returns (uint c) {
36         require(b <= a);
37         c = a - b;
38     }
39     function mul(uint a, uint b) internal pure returns (uint c) {
40         c = a * b;
41         require(a == 0 || c / a == b);
42     }
43     function div(uint a, uint b) internal pure returns (uint c) {
44         require(b > 0);
45         c = a / b;
46     }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   function Ownable() public {
62     owner = msg.sender;
63   }
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) public onlyOwner {
76     require(newOwner != address(0));
77     emit OwnershipTransferred(owner, newOwner);
78     owner = newOwner;
79   }
80 }
81 
82 // ----------------------------------------------------------------------------
83 // ERC20 Token, with the addition of symbol, name and decimals and an
84 // initial fixed supply
85 // ----------------------------------------------------------------------------
86 contract SEPCToken is ERC20Interface, Ownable{
87     using SafeMath for uint;
88 
89     string public symbol;
90     string public name;
91     uint8 public decimals;
92     uint _totalSupply;
93 
94     // ERC20 token max reward amount
95     uint public angelMaxAmount;
96     uint public firstMaxAmount;
97     uint public secondMaxAmount;
98     uint public thirdMaxAmount;
99 
100     // ERC20 token current reward amount
101     uint public angelCurrentAmount = 0;
102     uint public firstCurrentAmount = 0;
103     uint public secondCurrentAmount = 0;
104     uint public thirdCurrentAmount = 0;
105 
106     // ERC20 token reward rate
107     uint public angelRate = 40000;
108     uint public firstRate = 13333;
109     uint public secondRate = 10000;
110     uint public thirdRate = 6153;
111 
112     //Team hold amount
113     uint public teamHoldAmount = 700000000;
114 
115     //every stage start time and end time
116     uint public angelStartTime = 1528905600;  // Bei jing time 2018/06/14 00:00:00
117     uint public firstStartTime = 1530201600;  // Beijing time 2018/06/29 00:00:00
118     uint public secondStartTime = 1531929600; // Beijing time 2018/07/19 00:00:00
119     uint public thirdStartTime = 1534521600;  // Beijing time 2018/08/18 00:00:00
120     uint public endTime = 1550419200; // Beijing time 2019/02/18 00:00:00
121 
122     mapping(address => uint) balances;
123     mapping(address => mapping(address => uint)) allowed;
124 
125     // ------------------------------------------------------------------------
126     // Constructor
127     // ------------------------------------------------------------------------
128     function SEPCToken() public {
129         symbol = "SEPC";
130         name = "SEPC";
131         decimals = 18;
132         angelMaxAmount = 54000000 * 10**uint(decimals);
133         firstMaxAmount = 56000000 * 10**uint(decimals);
134         secondMaxAmount= 90000000 * 10**uint(decimals);
135         thirdMaxAmount = 100000000 * 10**uint(decimals);
136         _totalSupply = 1000000000 * 10**uint(decimals);
137         balances[msg.sender] = teamHoldAmount * 10**uint(decimals);
138         emit Transfer(address(0), msg.sender, teamHoldAmount * 10**uint(decimals));
139     }
140 
141     // ------------------------------------------------------------------------
142     // Total supply
143     // ------------------------------------------------------------------------
144     function totalSupply() public constant returns (uint) {
145         return _totalSupply  - balances[address(0)];
146     }
147 
148     // ------------------------------------------------------------------------
149     // Get the token balance for account `tokenOwner`
150     // ------------------------------------------------------------------------
151     function balanceOf(address tokenOwner) public constant returns (uint balance) {
152         return balances[tokenOwner];
153     }
154 
155     // ------------------------------------------------------------------------
156     // Transfer the balance from token owner's account to `to` account
157     // - Owner's account must have sufficient balance to transfer
158     // - 0 value transfers are allowed
159     // ------------------------------------------------------------------------
160     function transfer(address to, uint tokens) public returns (bool success) {
161         balances[msg.sender] = balances[msg.sender].sub(tokens);
162         balances[to] = balances[to].add(tokens);
163         emit Transfer(msg.sender, to, tokens);
164         return true;
165     }
166 
167     // ------------------------------------------------------------------------
168     // Token owner can approve for `spender` to transferFrom(...) `tokens`
169     // from the token owner's account
170     //
171     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
172     // recommends that there are no checks for the approval double-spend attack
173     // as this should be implemented in user interfaces
174     // ------------------------------------------------------------------------
175     function approve(address spender, uint tokens) public returns (bool success) {
176         allowed[msg.sender][spender] = tokens;
177         emit Approval(msg.sender, spender, tokens);
178         return true;
179     }
180 
181     // ------------------------------------------------------------------------
182     // Transfer `tokens` from the `from` account to the `to` account
183     //
184     // The calling account must already have sufficient tokens approve(...)-d
185     // for spending from the `from` account and
186     // - From account must have sufficient balance to transfer
187     // - Spender must have sufficient allowance to transfer
188     // - 0 value transfers are allowed
189     // ------------------------------------------------------------------------
190     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
191         balances[from] = balances[from].sub(tokens);
192         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
193         balances[to] = balances[to].add(tokens);
194         emit Transfer(from, to, tokens);
195         return true;
196     }
197 
198     // ------------------------------------------------------------------------
199     // Returns the amount of tokens approved by the owner that can be
200     // transferred to the spender's account
201     // ------------------------------------------------------------------------
202     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
203         return allowed[tokenOwner][spender];
204     }
205 
206     // ------------------------------------------------------------------------
207     // Token owner can approve for `spender` to transferFrom(...) `tokens`
208     // from the token owner's account. The `spender` contract function
209     // `receiveApproval(...)` is then executed
210     // ------------------------------------------------------------------------
211     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
212         allowed[msg.sender][spender] = tokens;
213         emit Approval(msg.sender, spender, tokens);
214         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
215         return true;
216     }
217 
218     // ------------------------------------------------------------------------
219     // send ERC20 Token to multi address
220     // ------------------------------------------------------------------------
221     function multiTransfer(address[] _addresses, uint256[] amounts) public returns (bool success){
222         for (uint256 i = 0; i < _addresses.length; i++) {
223             transfer(_addresses[i], amounts[i]);
224         }
225         return true;
226     }
227 
228     // ------------------------------------------------------------------------
229     // send ERC20 Token to multi address with decimals
230     // ------------------------------------------------------------------------
231     function multiTransferDecimals(address[] _addresses, uint256[] amounts) public returns (bool success){
232         for (uint256 i = 0; i < _addresses.length; i++) {
233             transfer(_addresses[i], amounts[i] * 10**uint(decimals));
234         }
235         return true;
236     }
237 
238     // ------------------------------------------------------------------------
239     // Crowd-funding
240     // ------------------------------------------------------------------------
241     function () payable public {
242           require(now < endTime && now >= angelStartTime);
243           require(angelCurrentAmount <= angelMaxAmount && firstCurrentAmount <= firstMaxAmount && secondCurrentAmount <= secondMaxAmount && thirdCurrentAmount <= thirdMaxAmount);
244           uint weiAmount = msg.value;
245           uint rewardAmount;
246           if(now >= angelStartTime && now < firstStartTime){
247             rewardAmount = weiAmount.mul(angelRate);
248             balances[msg.sender] = balances[msg.sender].add(rewardAmount);
249             angelCurrentAmount = angelCurrentAmount.add(rewardAmount);
250             require(angelCurrentAmount <= angelMaxAmount);
251           }else if (now >= firstStartTime && now < secondStartTime){
252             rewardAmount = weiAmount.mul(firstRate);
253             balances[msg.sender] = balances[msg.sender].add(rewardAmount);
254             firstCurrentAmount = firstCurrentAmount.add(rewardAmount);
255             require(firstCurrentAmount <= firstMaxAmount);
256           }else if(now >= secondStartTime && now < thirdStartTime){
257             rewardAmount = weiAmount.mul(secondRate);
258             balances[msg.sender] = balances[msg.sender].add(rewardAmount);
259             secondCurrentAmount = secondCurrentAmount.add(rewardAmount);
260             require(secondCurrentAmount <= secondMaxAmount);
261           }else if(now >= thirdStartTime && now < endTime){
262             rewardAmount = weiAmount.mul(thirdRate);
263             balances[msg.sender] = balances[msg.sender].add(rewardAmount);
264             thirdCurrentAmount = thirdCurrentAmount.add(rewardAmount);
265             require(thirdCurrentAmount <= thirdMaxAmount);
266           }
267           owner.transfer(msg.value);
268     }
269 
270     // ------------------------------------------------------------------------
271     // After-Crowd-funding
272     // ------------------------------------------------------------------------
273     function collectToken()  public onlyOwner {
274         require( now > endTime);
275         balances[owner] = balances[owner].add(angelMaxAmount + firstMaxAmount + secondMaxAmount + thirdMaxAmount -angelCurrentAmount - firstCurrentAmount - secondCurrentAmount - thirdCurrentAmount);
276     }
277 }