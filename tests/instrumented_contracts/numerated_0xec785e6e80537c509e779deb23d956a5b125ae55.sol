1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title - SalePO8
5  * ███████╗ █████╗ ██╗     ███████╗     ██████╗  ██████╗  █████╗
6  * ██╔════╝██╔══██╗██║     ██╔════╝     ██╔══██╗██╔═══██╗██╔══██╗
7  * ███████╗███████║██║     █████╗       ██████╔╝██║   ██║╚█████╔╝
8  * ╚════██║██╔══██║██║     ██╔══╝       ██╔═══╝ ██║   ██║██╔══██╗
9  * ███████║██║  ██║███████╗███████╗     ██║     ╚██████╔╝╚█████╔╝
10  * ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝     ╚═╝      ╚═════╝  ╚════╝
11  * ---
12  *
13  * POWERED BY
14  *  __    ___   _     ___  _____  ___     _     ___
15  * / /`  | |_) \ \_/ | |_)  | |  / / \   | |\ |  ) )
16  * \_\_, |_| \  |_|  |_|    |_|  \_\_/   |_| \| _)_)
17  *
18  * Game at https://skullys.co/
19  **/
20  
21  library SafeMath {
22     /**
23     * @dev Multiplies two unsigned integers, reverts on overflow.
24     */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27         // benefit is lost if 'b' is also tested.
28         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b);
35 
36         return c;
37     }
38 
39     /**
40     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
41     */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Solidity only automatically asserts when dividing by 0
44         require(b > 0);
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50 
51     /**
52     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
53     */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         require(b <= a);
56         uint256 c = a - b;
57 
58         return c;
59     }
60 
61     /**
62     * @dev Adds two unsigned integers, reverts on overflow.
63     */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a);
67 
68         return c;
69     }
70 
71     /**
72     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
73     * reverts when dividing by zero.
74     */
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b != 0);
77         return a % b;
78     }
79 }
80 
81 contract Ownable {
82     address payable public owner;
83     address payable public updater;
84     address payable public captain;
85 
86     event UpdaterTransferred(address indexed previousUpdater, address indexed newUpdater);
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     /**
90     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
91     * account.
92     */
93     constructor () internal {
94         owner = msg.sender;
95         emit OwnershipTransferred(address(0), owner);
96     }
97 
98     /**
99      * @dev Throws if called by any account other than the owner.
100      */
101     modifier onlyOwner() {
102         require(msg.sender == owner);
103         _;
104     }
105 
106     /**
107      * @dev Allows the current owner to transfer control of the contract to a newOwner.
108      * @param newOwner The address to transfer ownership to.
109      */
110     function transferOwnership(address payable newOwner) public onlyOwner {
111         require(newOwner != address(0));
112         emit OwnershipTransferred(owner, newOwner);
113         owner = newOwner;
114     }
115     
116      /**
117      * @dev Throws if called by any account other than the owner.
118      */
119     modifier onlyUpdater() {
120         require(msg.sender == updater);
121         _;
122     }
123 
124     /**
125      * @dev Allows the current owner to transfer control of the contract to a newOwner.
126      * @param newUpdater The address to transfer ownership to.
127      */
128     function transferUpdater(address payable newUpdater) public onlyOwner {
129         require(newUpdater != address(0));
130         emit UpdaterTransferred(updater, newUpdater);
131         updater = newUpdater;
132     }
133     
134     /// @dev Assigns a new address to act as the captain.
135     /// @param _newCaptain The address of the new Captain
136     function setCaptain(address payable _newCaptain) external onlyOwner {
137         require(_newCaptain != address(0));
138 
139         captain = _newCaptain;
140     }
141 }
142 
143 contract Pausable is Ownable {
144     event Pause();
145     event Unpause();
146 
147     bool private _paused;
148 
149     constructor () internal {
150         _paused = false;
151     }
152 
153     /**
154      * @return true if the contract is paused, false otherwise.
155      */
156     function paused() public view returns (bool) {
157         return _paused;
158     }
159 
160     /**
161      * @dev modifier to allow actions only when the contract IS paused
162      */
163     modifier whenNotPaused() {
164         require(!_paused);
165         _;
166     }
167 
168     /**
169      * @dev modifier to allow actions only when the contract IS NOT paused
170      */
171     modifier whenPaused {
172         require(_paused);
173         _;
174     }
175 
176     /**
177      * @dev called by the owner to pause, triggers stopped state
178      */
179     function pause() public onlyOwner whenNotPaused returns (bool) {
180         _paused = true;
181         emit Pause();
182         return true;
183     }
184 
185     /**
186      * @dev called by the owner to unpause, returns to normal state
187      */
188     function unpause() public onlyOwner whenPaused returns (bool) {
189         _paused = false;
190         emit Unpause();
191         return true;
192     }
193 }
194 
195 contract ERC20 {
196     function totalSupply() public view returns (uint256);
197     function balanceOf(address who) public view returns (uint256);
198     function transfer(address to, uint256 value) public;
199     function allowance(address owner, address spender) public view returns (uint256);
200     function transferFrom(address from, address to, uint256 value) public returns (bool);
201     function approve(address spender, uint256 value) public returns (bool);
202 
203     event Approval(address indexed owner, address indexed spender, uint256 value);
204     event Transfer(address indexed from, address indexed to, uint256 value);
205 }
206 
207 contract SalePO8 is Pausable {
208     using SafeMath for uint256;
209     ERC20 public po8Token;
210 
211     uint256 public exchangeRate; // 1 ether == 20000 PO8 for example
212     uint256 public cut;
213     
214     event ExchangeRateUpdated(uint256 newExchangeRate);
215     event PO8Bought(address indexed buyer, uint256 ethValue, uint256 po8Receive);
216     
217     // Delegate constructor
218     constructor(uint256 _exchangeRate, uint256 _cut, address po8Address, address payable captainAddress) public {
219         exchangeRate = _exchangeRate;
220         ERC20 po8 = ERC20(po8Address);
221         po8Token = po8;
222         cut = _cut;
223         captain = captainAddress;
224     }
225     
226     function setPO8TokenContractAdress(address po8Address) external onlyOwner returns (bool) {
227         ERC20 po8 = ERC20(po8Address);
228         po8Token = po8;
229         return true;
230     }
231     
232     // @dev The Owner can set the new exchange rate between ETH and PO8 token.
233     function setExchangeRate(uint256 _newExchangeRate) external onlyUpdater returns (uint256) {
234         exchangeRate = _newExchangeRate;
235 
236         emit ExchangeRateUpdated(_newExchangeRate);
237 
238         return _newExchangeRate;
239     }
240     
241     function buyPO8() external payable whenNotPaused {
242         require(msg.value >= 1e4 wei);
243         
244         uint256 totalTokenTransfer = msg.value.mul(exchangeRate);
245         
246         po8Token.transferFrom(owner, msg.sender, totalTokenTransfer);
247         captain.transfer(msg.value*cut/1e4); // cut by captain
248         
249         emit PO8Bought(msg.sender, msg.value, totalTokenTransfer);
250     }
251     
252     // @dev Allows the owner to capture the balance available to the contract.
253     function withdrawBalance() external onlyOwner {
254         uint256 balance = address(this).balance;
255 
256         owner.transfer(balance);
257     }
258     
259     //@dev contract prevent transfer accident ether from user.
260     function () external {
261         revert();
262     }
263     
264     function getBackERC20Token(address tokenAddress) external onlyOwner {
265         ERC20 token = ERC20(tokenAddress);
266         token.transfer(owner, token.balanceOf(address(this)));
267     }
268     
269 }