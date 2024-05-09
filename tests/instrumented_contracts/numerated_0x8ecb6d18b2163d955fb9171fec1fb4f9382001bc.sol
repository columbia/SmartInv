1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-10
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @title - SalePO8
9  * ███████╗ █████╗ ██╗     ███████╗     ██████╗  ██████╗  █████╗
10  * ██╔════╝██╔══██╗██║     ██╔════╝     ██╔══██╗██╔═══██╗██╔══██╗
11  * ███████╗███████║██║     █████╗       ██████╔╝██║   ██║╚█████╔╝
12  * ╚════██║██╔══██║██║     ██╔══╝       ██╔═══╝ ██║   ██║██╔══██╗
13  * ███████║██║  ██║███████╗███████╗     ██║     ╚██████╔╝╚█████╔╝
14  * ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝     ╚═╝      ╚═════╝  ╚════╝
15  * ---
16  *
17  * POWERED BY
18  *  __    ___   _     ___  _____  ___     _     ___
19  * / /`  | |_) \ \_/ | |_)  | |  / / \   | |\ |  ) )
20  * \_\_, |_| \  |_|  |_|    |_|  \_\_/   |_| \| _)_)
21  *
22  * Game at https://skullys.co/
23  **/
24  
25  library SafeMath {
26     /**
27     * @dev Multiplies two unsigned integers, reverts on overflow.
28     */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b);
39 
40         return c;
41     }
42 
43     /**
44     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
45     */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Solidity only automatically asserts when dividing by 0
48         require(b > 0);
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51 
52         return c;
53     }
54 
55     /**
56     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
57     */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b <= a);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66     * @dev Adds two unsigned integers, reverts on overflow.
67     */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a);
71 
72         return c;
73     }
74 
75     /**
76     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
77     * reverts when dividing by zero.
78     */
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b != 0);
81         return a % b;
82     }
83 }
84 
85 contract Ownable {
86     address payable public owner;
87     address payable public updater;
88     address payable public captain;
89 
90     event UpdaterTransferred(address indexed previousUpdater, address indexed newUpdater);
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     /**
94     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
95     * account.
96     */
97     constructor () internal {
98         owner = msg.sender;
99         emit OwnershipTransferred(address(0), owner);
100     }
101 
102     /**
103      * @dev Throws if called by any account other than the owner.
104      */
105     modifier onlyOwner() {
106         require(msg.sender == owner);
107         _;
108     }
109 
110     /**
111      * @dev Allows the current owner to transfer control of the contract to a newOwner.
112      * @param newOwner The address to transfer ownership to.
113      */
114     function transferOwnership(address payable newOwner) public onlyOwner {
115         require(newOwner != address(0));
116         emit OwnershipTransferred(owner, newOwner);
117         owner = newOwner;
118     }
119     
120      /**
121      * @dev Throws if called by any account other than the owner.
122      */
123     modifier onlyUpdater() {
124         require(msg.sender == updater);
125         _;
126     }
127 
128     /**
129      * @dev Allows the current owner to transfer control of the contract to a newOwner.
130      * @param newUpdater The address to transfer ownership to.
131      */
132     function transferUpdater(address payable newUpdater) public onlyOwner {
133         require(newUpdater != address(0));
134         emit UpdaterTransferred(updater, newUpdater);
135         updater = newUpdater;
136     }
137     
138     /// @dev Assigns a new address to act as the captain.
139     /// @param _newCaptain The address of the new Captain
140     function setCaptain(address payable _newCaptain) external onlyOwner {
141         require(_newCaptain != address(0));
142 
143         captain = _newCaptain;
144     }
145 }
146 
147 contract Pausable is Ownable {
148     event Pause();
149     event Unpause();
150 
151     bool private _paused;
152 
153     constructor () internal {
154         _paused = false;
155     }
156 
157     /**
158      * @return true if the contract is paused, false otherwise.
159      */
160     function paused() public view returns (bool) {
161         return _paused;
162     }
163 
164     /**
165      * @dev modifier to allow actions only when the contract IS paused
166      */
167     modifier whenNotPaused() {
168         require(!_paused);
169         _;
170     }
171 
172     /**
173      * @dev modifier to allow actions only when the contract IS NOT paused
174      */
175     modifier whenPaused {
176         require(_paused);
177         _;
178     }
179 
180     /**
181      * @dev called by the owner to pause, triggers stopped state
182      */
183     function pause() public onlyOwner whenNotPaused returns (bool) {
184         _paused = true;
185         emit Pause();
186         return true;
187     }
188 
189     /**
190      * @dev called by the owner to unpause, returns to normal state
191      */
192     function unpause() public onlyOwner whenPaused returns (bool) {
193         _paused = false;
194         emit Unpause();
195         return true;
196     }
197 }
198 
199 contract ERC20 {
200     function totalSupply() public view returns (uint256);
201     function balanceOf(address who) public view returns (uint256);
202     function transfer(address to, uint256 value) public;
203     function allowance(address owner, address spender) public view returns (uint256);
204     function transferFrom(address from, address to, uint256 value) public returns (bool);
205     function approve(address spender, uint256 value) public returns (bool);
206 
207     event Approval(address indexed owner, address indexed spender, uint256 value);
208     event Transfer(address indexed from, address indexed to, uint256 value);
209 }
210 
211 contract SalePO8 is Pausable {
212     using SafeMath for uint256;
213     ERC20 public po8Token;
214 
215     uint256 public exchangeRate; // 1 ether == 20000 PO8 for example
216     uint256 public cut;
217     
218     event ExchangeRateUpdated(uint256 newExchangeRate);
219     event PO8Bought(address indexed buyer, uint256 ethValue, uint256 po8Receive);
220     
221     // Delegate constructor
222     constructor(uint256 _exchangeRate, uint256 _cut, address po8Address, address payable captainAddress) public {
223         exchangeRate = _exchangeRate;
224         ERC20 po8 = ERC20(po8Address);
225         po8Token = po8;
226         cut = _cut;
227         captain = captainAddress;
228     }
229     
230     function setPO8TokenContractAdress(address po8Address) external onlyOwner returns (bool) {
231         ERC20 po8 = ERC20(po8Address);
232         po8Token = po8;
233         return true;
234     }
235     
236     // @dev The Owner can set the new exchange rate between ETH and PO8 token.
237     function setExchangeRate(uint256 _newExchangeRate) external onlyUpdater returns (uint256) {
238         exchangeRate = _newExchangeRate;
239 
240         emit ExchangeRateUpdated(_newExchangeRate);
241 
242         return _newExchangeRate;
243     }
244     
245     function buyPO8() external payable whenNotPaused {
246         require(msg.value >= 1e4 wei);
247         
248         uint256 totalTokenTransfer = msg.value.mul(exchangeRate);
249         
250         po8Token.transferFrom(owner, msg.sender, totalTokenTransfer);
251         captain.transfer(msg.value*cut/1e4); // cut by captain
252         
253         emit PO8Bought(msg.sender, msg.value, totalTokenTransfer);
254     }
255     
256     // @dev Allows the owner to capture the balance available to the contract.
257     function withdrawBalance() external onlyOwner {
258         uint256 balance = address(this).balance;
259 
260         owner.transfer(balance);
261     }
262     
263     //@dev contract prevent transfer accident ether from user.
264     function () external {
265         revert();
266     }
267     
268     function getBackERC20Token(address tokenAddress) external onlyOwner {
269         ERC20 token = ERC20(tokenAddress);
270         token.transfer(owner, token.balanceOf(address(this)));
271     }
272     
273 }