1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     /**
5      * @dev Multiplies two unsigned integers, reverts on overflow.
6      */
7 
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12 
13         if (a == 0) {
14             return 0;
15 
16         }
17 
18         uint256 c = a * b;
19         require(c / a == b);
20 
21         return c;
22     }
23 
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40      
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44         
45         return c;
46     }
47 
48     /**
49      * @dev Adds two unsigned integers, reverts on overflow.
50      */
51 
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55         return c;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62 
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 
70 interface IERC20 {
71 
72     function transfer(address to, uint256 value) external returns (bool);
73     //function approve(address spender, uint256 value) external returns (bool);
74     function transferFrom(address from, address to, uint256 value) external returns (bool);
75     function totalSupply() external view returns (uint256);
76     function balanceOf(address who) external view returns (uint256);
77     //function allowance(address owner, address spender) external view returns (uint256);
78 
79     event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 
85 contract VCNToken is IERC20 {
86 
87     using SafeMath for uint256;
88     mapping (address => uint256) private _balances;
89     mapping (address => TimeLock[]) private _timeLocks;
90     uint256 private _totalSupply;
91     address private _owner;
92     
93     
94     
95     string public constant name = "VoltChainNetwork";
96     
97     string public constant symbol = "VCN";
98     uint8 public constant decimals = 18; 
99     
100     
101     struct TimeLock{
102         uint256 blockTime;
103         uint256 blockAmount;
104     }
105     
106     constructor(uint256 totalSupply) public{
107         _totalSupply = totalSupply;
108         _owner = msg.sender;
109         _balances[_owner] = _totalSupply;
110     }
111     
112     function getTimeStamp() public view returns(uint256) {
113         return block.timestamp;
114     }
115     
116     
117     function timeLock(address addr, uint256 amount , uint16 lockMonth) public returns(bool){
118         require(msg.sender == _owner);
119         require(lockMonth > 0);
120         require(amount <= getFreeAmount(addr));
121     
122         TimeLock memory timeLockTemp;
123         timeLockTemp.blockTime = block.timestamp + 86400 * 30 * lockMonth;
124         //timeLockTemp.blockTime = block.timestamp + 60 * lockMonth;
125         timeLockTemp.blockAmount = amount;
126         _timeLocks[addr].push(timeLockTemp);
127         
128         return true;
129     }
130     
131     function crowdSale(address to, uint256 amount,  uint16 lockMonth) public returns(bool){
132         require(msg.sender == _owner);
133         
134         _transfer(_owner, to, amount);
135         
136         if(lockMonth > 0){
137             timeLock(to, amount, lockMonth);
138         }
139         
140         return true;
141     }
142     
143     function releaseLock(address owner, uint256 amount) public returns(bool){
144         require(msg.sender == _owner);    
145         
146         uint minIdx = 0;
147         uint256 minTime = 0;
148         uint arrayLength = _timeLocks[owner].length;
149         for (uint i=0; i<arrayLength; i++) {
150             if(block.timestamp < _timeLocks[owner][i].blockTime && _timeLocks[owner][i].blockAmount > 0){
151                 if(minTime == 0 || minTime > _timeLocks[owner][i].blockTime){
152                     minIdx = i;
153                     minTime = _timeLocks[owner][i].blockTime;
154                 }
155             }
156         }
157         
158         if(minTime >= 0){
159             if(amount > _timeLocks[owner][minIdx].blockAmount){
160                 uint256 remain = amount - _timeLocks[owner][minIdx].blockAmount;
161                 _timeLocks[owner][minIdx].blockAmount = 0;
162                 releaseLock(owner, remain);
163             }else{
164                 _timeLocks[owner][minIdx].blockAmount -= amount;
165             }
166             
167         }
168         
169         return true;
170     }
171     
172     
173     function getFreeAmount(address owner) public view returns(uint256){
174         return(balanceOf(owner) - getLockAmount(owner));
175     }
176     
177     function getLockAmount(address owner) public view returns(uint256){
178         uint256 result = 0;
179         uint arrayLength = _timeLocks[owner].length;
180         for (uint i=0; i<arrayLength; i++) {
181             if(block.timestamp < _timeLocks[owner][i].blockTime){
182                 result += _timeLocks[owner][i].blockAmount;
183             }
184         }
185             
186         return(result);
187     }
188     
189 
190     /**
191      * @dev Total number of tokens in existence
192      */
193 
194     function totalSupply() public view returns (uint256) {
195         return _totalSupply;
196     }
197 
198     /**
199      * @dev Gets the balance of the specified address.
200      * @param owner The address to query the balance of.
201      * @return A uint256 representing the amount owned by the passed address.
202      */
203 
204     function balanceOf(address owner) public view returns (uint256) {
205         return _balances[owner];
206     }
207 
208     /**
209      * @dev Transfer token to a specified address
210      * @param to The address to transfer to.
211      * @param value The amount to be transferred.
212      */
213 
214     function transfer(address to, uint256 value) public returns (bool) {
215         _transfer(msg.sender, to, value);
216         return true;
217     }
218 
219 
220     /**
221      * @dev Transfer tokens from one address to another.
222      * Note that while this function emits an Approval event, this is not required as per the specification,
223      * and other compliant implementations may not emit the event.
224      * @param from address The address which you want to send tokens from
225      * @param to address The address which you want to transfer to
226      * @param value uint256 the amount of tokens to be transferred
227      */
228 
229     function transferFrom(address from, address to, uint256 value) public returns (bool) {
230         _transfer(from, to, value);
231         return true;
232     }
233 
234 
235     /**
236      * @dev Transfer token for a specified addresses
237      * @param from The address to transfer from.
238      * @param to The address to transfer to.
239      * @param value The amount to be transferred.
240      */
241     function _transfer(address from, address to, uint256 value) internal {
242         require(to != address(0));
243         require(from == msg.sender);
244         
245         uint256 available = balanceOf(from) - getLockAmount(from);
246         require(available >= value, "not enough token");
247         
248         _balances[from] = _balances[from].sub(value);
249         _balances[to] = _balances[to].add(value);
250         emit Transfer(from, to, value);
251     }
252 
253 
254 
255 
256     /**
257      * @dev Internal function that burns an amount of the token of a given
258      * account.
259      * @param account The account whose tokens will be burnt.
260      * @param value The amount that will be burnt.
261      */
262 
263     function _burn(address account, uint256 value) internal {
264         require(account != address(0));
265         require(account == msg.sender);
266         
267         _totalSupply = _totalSupply.sub(value);
268         _balances[account] = _balances[account].sub(value);
269         emit Transfer(account, address(0), value);
270     }
271 
272 
273 
274     /**
275      * @dev Internal function that burns an amount of the token of a given
276      * account, deducting from the sender's allowance for said account. Uses the
277      * internal burn function.
278      * Emits an Approval event (reflecting the reduced allowance).
279      * @param account The account whose tokens will be burnt.
280      * @param value The amount that will be burnt.
281      */
282 
283     function _burnFrom(address account, uint256 value) internal {
284         _burn(account, value);
285     }
286     
287     
288 }