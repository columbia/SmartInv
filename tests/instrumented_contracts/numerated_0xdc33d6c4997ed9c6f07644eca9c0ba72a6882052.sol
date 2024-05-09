1 pragma solidity ^0.4.24;
2 
3 /*
4     Copyright 2018, Vicent Nos, Enrique Santos & Mireia Puig
5 
6     This program is free software: you can redistribute it and/or modify
7     it under the terms of the GNU General Public License as published by
8     the Free Software Foundation, either version 3 of the License, or
9     (at your option) any later version.
10 
11     This program is distributed in the hope that it will be useful,
12     but WITHOUT ANY WARRANTY; without even the implied warranty of
13     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14     GNU General Public License for more details.
15 
16     You should have received a copy of the GNU General Public License
17     along with this program.  If not, see <http://www.gnu.org/licenses/>.
18 
19  */
20 
21 library SafeMath {
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26         uint256 c = a * b;
27         assert(c / a == b);
28         return c;
29     }
30 
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 contract Ownable {
52     address public owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     constructor() internal {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function transferOwnership(address newOwner) public onlyOwner {
66         require(newOwner != address(0));
67         emit OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69     }
70 }
71 
72 
73 //////////////////////////////////////////////////////////////
74 //                                                          //
75 //  Lescovex Equity ERC20                                   //
76 //                                                          //
77 //////////////////////////////////////////////////////////////
78 
79 contract LescovexERC20 is Ownable {
80     using SafeMath for uint256;
81 
82     mapping (address => uint256) public balances;
83 
84     mapping (address => mapping (address => uint256)) internal allowed;
85 
86     mapping (address => timeHold) holded;
87 
88     struct timeHold{
89         uint256[] amount;
90         uint256[] time;
91         uint256 length;
92     }
93 
94     /* Public variables for the ERC20 token */
95     string public constant standard = "ERC20 Lescovex ISC Income Smart Contract";
96     uint8 public constant decimals = 8; // hardcoded to be a constant
97     uint256 public holdMax = 100;
98     uint256 public totalSupply;
99     uint256 public holdTime;
100     string public name;
101     string public symbol;
102 
103     event Transfer(address indexed from, address indexed to, uint256 value);
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 
106 
107     function balanceOf(address _owner) public view returns (uint256) {
108         return balances[_owner];
109     }
110 
111     function holdedOf(address _owner) public view returns (uint256) {
112         // Returns the valid holded amount of _owner (see function hold),
113         // where valid means that the amount is holded more than requiredTime
114         uint256 requiredTime = block.timestamp - holdTime;
115 
116         // Check of the initial values for the search loop.
117         uint256 iValid = 0;                         // low index in test range
118         uint256 iNotValid = holded[_owner].length;  // high index in test range
119         if (iNotValid == 0                          // empty array of holds
120         || holded[_owner].time[iValid] >= requiredTime) { // not any valid holds
121             return 0;
122         }
123 
124         // Binary search of the highest index with a valid hold time
125         uint256 i = iNotValid / 2;  // index of pivot element to test
126         while (i > iValid) {  // while there is a higher one valid
127             if (holded[_owner].time[i] < requiredTime) {
128                 iValid = i;   // valid hold
129             } else {
130                 iNotValid = i; // not valid hold
131             }
132             i = (iNotValid + iValid) / 2;
133         }
134         return holded[_owner].amount[iValid];
135     }
136 
137     function hold(address _to, uint256 _value) internal {
138         assert(holded[_to].length < holdMax);
139         // holded[_owner].amount[] is the accumulated sum of holded amounts,
140         // sorted from oldest to newest.
141         uint256 len = holded[_to].length;
142         uint256 accumulatedValue = (len == 0 ) ?
143             _value :
144             _value + holded[_to].amount[len - 1];
145 
146         // records the accumulated holded amount
147         holded[_to].amount.push(accumulatedValue);
148         holded[_to].time.push(block.timestamp);
149         holded[_to].length++;
150     }
151 
152     function setHoldTime(uint256 _value) external onlyOwner{
153       holdTime = _value;
154     }
155 
156     function setHoldMax(uint256 _value) external onlyOwner{
157       holdMax = _value;
158     }
159 
160     function transfer(address _to, uint256 _value) public returns (bool) {
161         require(_to != address(0));
162         require(_value <= balances[msg.sender]);
163         // SafeMath.sub will throw if there is not enough balance.
164         balances[msg.sender] = balances[msg.sender].sub(_value);
165 
166         delete holded[msg.sender];
167         hold(msg.sender,balances[msg.sender]);
168         hold(_to,_value);
169 
170         balances[_to] = balances[_to].add(_value);
171 
172         emit Transfer(msg.sender, _to, _value);
173         return true;
174     }
175 
176     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177         require(_to != address(0));
178         require(_value <= balances[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180 
181         balances[_from] = balances[_from].sub(_value);
182         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183 
184         delete holded[_from];
185         hold(_from,balances[_from]);
186         hold(_to,_value);
187 
188         balances[_to] = balances[_to].add(_value);
189 
190         emit Transfer(_from, _to, _value);
191         return true;
192     }
193 
194     function approve(address _spender, uint256 _value) public returns (bool) {
195         allowed[msg.sender][_spender] = _value;
196         emit Approval(msg.sender, _spender, _value);
197         return true;
198     }
199 
200     function allowance(address _owner, address _spender) public view returns (uint256) {
201         return allowed[_owner][_spender];
202     }
203 
204     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
205         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207         return true;
208     }
209 
210     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211         uint oldValue = allowed[msg.sender][_spender];
212         if (_subtractedValue > oldValue) {
213             allowed[msg.sender][_spender] = 0;
214         } else {
215             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216         }
217         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218         return true;
219     }
220 
221     /* Approve and then communicate the approved contract in a single tx */
222     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
223         tokenRecipient spender = tokenRecipient(_spender);
224 
225         if (approve(_spender, _value)) {
226             spender.receiveApproval(msg.sender, _value, this, _extraData);
227             return true;
228         }
229     }
230 }
231 
232 
233 interface tokenRecipient {
234     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external ;
235 }
236 
237 
238 contract Lescovex_ISC is LescovexERC20 {
239 
240     uint256 public contractBalance = 0;
241 
242     //Declare logging events
243     event LogDeposit(address sender, uint amount);
244     event LogWithdrawal(address receiver, uint amount);
245 
246     address contractAddr = this;
247 
248     /* Initializes contract with initial supply tokens to the creator of the contract */
249     constructor (
250         uint256 initialSupply,
251         string contractName,
252         string tokenSymbol,
253         uint256 contractHoldTime,
254         address contractOwner
255 
256         ) public {
257         totalSupply = initialSupply;  // Update total supply
258         name = contractName;             // Set the name for display purposes
259         symbol = tokenSymbol;         // Set the symbol for display purposes
260         holdTime = contractHoldTime;
261         balances[contractOwner] = totalSupply;
262 
263     }
264 
265     function deposit() external payable onlyOwner returns(bool success) {
266         contractBalance = contractAddr.balance;
267         //executes event to reflect the changes
268         emit LogDeposit(msg.sender, msg.value);
269 
270         return true;
271     }
272 
273     function withdrawReward() external {
274         uint256 ethAmount = (holdedOf(msg.sender) * contractBalance) / totalSupply;
275 
276         require(ethAmount > 0);
277 
278         //executes event to register the changes
279         emit LogWithdrawal(msg.sender, ethAmount);
280 
281         delete holded[msg.sender];
282         hold(msg.sender,balances[msg.sender]);
283         //send eth to owner address
284         msg.sender.transfer(ethAmount);
285     }
286 
287     function withdraw(uint256 value) external onlyOwner {
288         //send eth to owner address
289         msg.sender.transfer(value);
290         //executes event to register the changes
291         emit LogWithdrawal(msg.sender, value);
292     }
293 }