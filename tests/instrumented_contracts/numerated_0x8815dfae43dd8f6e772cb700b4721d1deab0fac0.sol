1 pragma solidity ^0.4.19;
2 
3 // Vicent Nos & Enrique Santos
4 
5 
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 
36 contract Ownable {
37     address public owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     function Ownable() internal {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address newOwner) public onlyOwner {
51         require(newOwner != address(0));
52         OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54     }
55 }
56 
57 
58 //////////////////////////////////////////////////////////////
59 //                                                          //
60 //  Lescovex, Shareholder's ERC20                           //
61 //                                                          //
62 //////////////////////////////////////////////////////////////
63 
64 contract LescovexERC20 is Ownable {
65     using SafeMath for uint256;
66 
67     mapping (address => uint256) holded;
68     mapping (address => uint256) balances;
69     mapping (address => mapping (address => uint256)) internal allowed;
70 
71     uint256 public constant blockEndICO = 1524182460;
72 
73     /* Public variables for the ERC20 token */
74     string public constant standard = "ERC20 Lescovex";
75     uint8 public constant decimals = 8; // hardcoded to be a constant
76     uint256 public totalSupply;
77     string public name;
78     string public symbol;
79 
80     event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 
83     function holdedOf(address _owner) public view returns (uint256 balance) {
84         return holded[_owner];
85     }
86 
87     function balanceOf(address _owner) public view returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     function transfer(address _to, uint256 _value) public returns (bool) {
92         require(block.timestamp > blockEndICO || msg.sender == owner);
93         require(_to != address(0));
94         require(_value <= balances[msg.sender]);
95 
96         // SafeMath.sub will throw if there is not enough balance.
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         holded[_to] = block.number;
99         balances[_to] = balances[_to].add(_value);
100 
101         Transfer(msg.sender, _to, _value);
102         return true;
103     }
104 
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
106         require(_to != address(0));
107         require(_value <= balances[_from]);
108         require(_value <= allowed[_from][msg.sender]);
109         balances[_from] = balances[_from].sub(_value);
110         holded[_to] = block.number;
111         balances[_to] = balances[_to].add(_value);
112         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113 
114         Transfer(_from, _to, _value);
115         return true;
116     }
117 
118 
119     function approve(address _spender, uint256 _value) public onlyOwner returns (bool) {
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122         return true;
123     }
124 
125     function allowance(address _owner, address _spender) public view returns (uint256) {
126         return allowed[_owner][_spender];
127     }
128 
129     function increaseApproval(address _spender, uint _addedValue) public onlyOwner returns (bool) {
130         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
131         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132         return true;
133     }
134 
135     function decreaseApproval(address _spender, uint _subtractedValue) public onlyOwner returns (bool) {
136         uint oldValue = allowed[msg.sender][_spender];
137         if (_subtractedValue > oldValue) {
138             allowed[msg.sender][_spender] = 0;
139         } else {
140             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
141         }
142         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143         return true;
144     }
145 
146     /* Approve and then communicate the approved contract in a single tx */
147     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public onlyOwner returns (bool success) {    
148         tokenRecipient spender = tokenRecipient(_spender);
149 
150         if (approve(_spender, _value)) {
151             spender.receiveApproval(msg.sender, _value, this, _extraData);
152             return true;
153         }
154     }
155 }
156 
157 
158 interface tokenRecipient {
159     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public ; 
160 }
161 
162     
163 contract Lescovex is LescovexERC20 {
164 
165     // Contract variables and constants
166     uint256 constant initialSupply = 0;
167     string constant tokenName = "Lescovex Shareholder's";
168     string constant tokenSymbol = "LCX";
169 
170     address public LescovexAddr = 0xD26286eb9E6E623dba88Ed504b628F648ADF7a0E;
171     uint256 public constant minPrice = 7500000000000000;
172     uint256 public buyPrice = minPrice;
173     uint256 public tokenReward = 0;
174     // constant to simplify conversion of token amounts into integer form
175     uint256 public tokenUnit = uint256(10)**decimals;
176 
177     //Declare logging events
178     event LogDeposit(address sender, uint amount);
179     event LogWithdrawal(address receiver, uint amount);
180   
181     /* Initializes contract with initial supply tokens to the creator of the contract */
182     function Lescovex() public {
183         totalSupply = initialSupply;  // Update total supply
184         name = tokenName;             // Set the name for display purposes
185         symbol = tokenSymbol;         // Set the symbol for display purposes
186     }
187 
188     function () public payable {
189         buy();   // Allow to buy tokens sending ether directly to contract
190     }
191 
192     modifier status() {
193         _;  // modified function code should go before prices update
194 
195         if (block.timestamp < 1519862460){          //until 1 march 2018
196             if (totalSupply < 50000000000000){
197                 buyPrice = 7500000000000000;
198 
199             } else {
200                 buyPrice = 8000000000000000;
201             }
202         } else if (block.timestamp < 1520640060){   // until 10 march 2018
203           buyPrice = 8000000000000000;
204 
205         } else if (block.timestamp<1521504060){     //until 20 march 2018
206           buyPrice = 8500000000000000;
207 
208         } else if (block.timestamp < 1522368060){   //until 30 march 2018
209 
210           buyPrice = 9000000000000000;
211 
212         } else if (block.timestamp < 1523232060){   //until 9 april 2018
213           buyPrice = 9500000000000000;
214 
215         } else {
216 
217           buyPrice = 10000000000000000;
218         }
219     }
220 
221     function deposit() public payable onlyOwner returns(bool success) {
222         // Check for overflows;
223 
224         assert (this.balance + msg.value >= this.balance); // Check for overflows
225         tokenReward = this.balance / totalSupply;
226 
227         //executes event to reflect the changes
228         LogDeposit(msg.sender, msg.value);
229         
230         return true;
231     }
232 
233     function withdrawReward() public status {
234         require (block.number - holded[msg.sender] > 172800); //1 month
235 
236         holded[msg.sender] = block.number;
237         uint256 ethAmount = tokenReward * balances[msg.sender];
238 
239         //send eth to owner address
240         msg.sender.transfer(ethAmount);
241           
242         //executes event to register the changes
243         LogWithdrawal(msg.sender, ethAmount);
244     }
245 
246     function withdraw(uint value) public onlyOwner {
247         //send eth to owner address
248         msg.sender.transfer(value);
249 
250         //executes event to register the changes
251         LogWithdrawal(msg.sender, value);
252     }
253 
254     function buy() public payable status {
255         require (totalSupply <= 1000000000000000);
256         require(block.timestamp < blockEndICO);
257 
258         uint256 tokenAmount = (msg.value / buyPrice)*tokenUnit ;  // calculates the amount
259 
260         transferBuy(msg.sender, tokenAmount);
261         LescovexAddr.transfer(msg.value);
262     }
263 
264     function transferBuy(address _to, uint256 _value) internal returns (bool) {
265         require(_to != address(0));
266 
267         // SafeMath.add will throw if there is not enough balance.
268         totalSupply = totalSupply.add(_value*2);
269         holded[_to] = block.number;
270         balances[LescovexAddr] = balances[LescovexAddr].add(_value);
271         balances[_to] = balances[_to].add(_value);
272 
273         Transfer(this, _to, _value);
274         Transfer(this, LescovexAddr, _value);
275         return true;
276     }
277 
278   function burn(address addr) public onlyOwner{
279     totalSupply=totalSupply.sub(balances[addr]);
280     balances[addr]=0;
281 
282   }
283 
284 }