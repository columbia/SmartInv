1 pragma solidity ^0.4.24;
2 
3 /*
4     Copyright 2018, Vicent Nos, Enrique Santos & Mireia Puig
5 
6     License:
7     https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode
8 
9  */
10 
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 
41 contract Ownable {
42     address public owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     constructor() internal {
47         owner = msg.sender;
48     }
49 
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     function transferOwnership(address newOwner) public onlyOwner {
56         require(newOwner != address(0));
57         emit OwnershipTransferred(owner, newOwner);
58         owner = newOwner;
59     }
60 }
61 
62 
63 //////////////////////////////////////////////////////////////
64 //                                                          //
65 //  Lescovex Equity ERC20                                   //
66 //                                                          //
67 //////////////////////////////////////////////////////////////
68 
69 contract LescovexERC20 is Ownable {
70     using SafeMath for uint256;
71 
72     mapping (address => uint256) public balances;
73 
74     mapping (address => mapping (address => uint256)) internal allowed;
75 
76     mapping (address => timeHold) holded;
77 
78     struct timeHold{
79         uint256[] amount;
80         uint256[] time;
81         uint256 length;
82     }
83 
84     /* Public variables for the ERC20 token */
85     string public constant standard = "ERC20 Lescovex ISC Income Smart Contract";
86     uint8 public constant decimals = 8; // hardcoded to be a constant
87     uint256 public holdMax = 100;
88     uint256 public totalSupply;
89     uint256 public holdTime;
90     string public name;
91     string public symbol;
92 
93     event Transfer(address indexed from, address indexed to, uint256 value);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 
96 
97     function balanceOf(address _owner) public view returns (uint256) {
98         return balances[_owner];
99     }
100 
101     function holdedOf(address _owner) public view returns (uint256) {
102         // Returns the valid holded amount of _owner (see function hold),
103         // where valid means that the amount is holded more than requiredTime
104         uint256 requiredTime = block.timestamp - holdTime;
105 
106         // Check of the initial values for the search loop.
107         uint256 iValid = 0;                         // low index in test range
108         uint256 iNotValid = holded[_owner].length;  // high index in test range
109         if (iNotValid == 0                          // empty array of holds
110         || holded[_owner].time[iValid] >= requiredTime) { // not any valid holds
111             return 0;
112         }
113 
114         // Binary search of the highest index with a valid hold time
115         uint256 i = iNotValid / 2;  // index of pivot element to test
116         while (i > iValid) {  // while there is a higher one valid
117             if (holded[_owner].time[i] < requiredTime) {
118                 iValid = i;   // valid hold
119             } else {
120                 iNotValid = i; // not valid hold
121             }
122             i = (iNotValid + iValid) / 2;
123         }
124         return holded[_owner].amount[iValid];
125     }
126 
127     function hold(address _to, uint256 _value) internal {
128         require(holded[_to].length < holdMax);
129         // holded[_owner].amount[] is the accumulated sum of holded amounts,
130         // sorted from oldest to newest.
131         uint256 len = holded[_to].length;
132         uint256 accumulatedValue = (len == 0 ) ?
133             _value :
134             _value + holded[_to].amount[len - 1];
135 
136         // records the accumulated holded amount
137         holded[_to].amount.push(accumulatedValue);
138         holded[_to].time.push(block.timestamp);
139         holded[_to].length++;
140     }
141 
142     function setHoldTime(uint256 _value) external onlyOwner{
143       holdTime = _value;
144     }
145 
146     function setHoldMax(uint256 _value) external onlyOwner{
147       holdMax = _value;
148     }
149 
150     function transfer(address _to, uint256 _value) public returns (bool) {
151         require(_to != address(0));
152         require(_value <= balances[msg.sender]);
153         // SafeMath.sub will throw if there is not enough balance.
154         balances[msg.sender] = balances[msg.sender].sub(_value);
155 
156         delete holded[msg.sender];
157         hold(msg.sender,balances[msg.sender]);
158         hold(_to,_value);
159 
160         balances[_to] = balances[_to].add(_value);
161 
162         emit Transfer(msg.sender, _to, _value);
163         return true;
164     }
165 
166     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167         require(_to != address(0));
168         require(_value <= balances[_from]);
169         require(_value <= allowed[_from][msg.sender]);
170 
171         balances[_from] = balances[_from].sub(_value);
172         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173 
174         delete holded[_from];
175         hold(_from,balances[_from]);
176         hold(_to,_value);
177 
178         balances[_to] = balances[_to].add(_value);
179 
180         emit Transfer(_from, _to, _value);
181         return true;
182     }
183 
184     function approve(address _spender, uint256 _value) public returns (bool) {
185         allowed[msg.sender][_spender] = _value;
186         emit Approval(msg.sender, _spender, _value);
187         return true;
188     }
189 
190     function allowance(address _owner, address _spender) public view returns (uint256) {
191         return allowed[_owner][_spender];
192     }
193 
194     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199 
200     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
201         uint oldValue = allowed[msg.sender][_spender];
202         if (_subtractedValue > oldValue) {
203             allowed[msg.sender][_spender] = 0;
204         } else {
205             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206         }
207         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208         return true;
209     }
210 
211     /* Approve and then communicate the approved contract in a single tx */
212     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
213         tokenRecipient spender = tokenRecipient(_spender);
214 
215         if (approve(_spender, _value)) {
216             spender.receiveApproval(msg.sender, _value, this, _extraData);
217             return true;
218         }
219     }
220 }
221 
222 
223 interface tokenRecipient {
224     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external ;
225 }
226 
227 
228 contract Lescovex_ISC is LescovexERC20 {
229 
230     uint256 public contractBalance = 0;
231 
232     //Declare logging events
233     event LogDeposit(address sender, uint amount);
234     event LogWithdrawal(address receiver, uint amount);
235 
236     address contractAddr = this;
237 
238     /* Initializes contract with initial supply tokens to the creator of the contract */
239     constructor (
240         uint256 initialSupply,
241         string contractName,
242         string tokenSymbol,
243         uint256 contractHoldTime,
244         address contractOwner
245 
246         ) public {
247         totalSupply = initialSupply;  // Update total supply
248         name = contractName;             // Set the name for display purposes
249         symbol = tokenSymbol;         // Set the symbol for display purposes
250         holdTime = contractHoldTime;
251         balances[contractOwner] = totalSupply;
252 
253     }
254 
255     function deposit() external payable onlyOwner returns(bool success) {
256         contractBalance = contractAddr.balance;
257         //executes event to reflect the changes
258         emit LogDeposit(msg.sender, msg.value);
259 
260         return true;
261     }
262 
263     function withdrawReward() external {
264         uint256 ethAmount = (holdedOf(msg.sender) * contractBalance) / totalSupply;
265 
266         require(ethAmount > 0);
267 
268         //executes event to register the changes
269         emit LogWithdrawal(msg.sender, ethAmount);
270 
271         delete holded[msg.sender];
272         hold(msg.sender,balances[msg.sender]);
273         //send eth to owner address
274         msg.sender.transfer(ethAmount);
275     }
276 
277     function withdraw(uint256 value) external onlyOwner {
278         //send eth to owner address
279         msg.sender.transfer(value);
280         //executes event to register the changes
281         emit LogWithdrawal(msg.sender, value);
282     }
283 }