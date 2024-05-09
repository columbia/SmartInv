1 pragma solidity ^0.4.19;
2 
3 //vicent nos & enrique santos
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 
35 contract Ownable {
36   address public owner;
37 
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41 
42 
43   function Ownable() internal {
44     owner = msg.sender;
45   }
46 
47 
48 
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54 
55 
56   function transferOwnership(address newOwner) public onlyOwner {
57     require(newOwner != address(0));
58     OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60   }
61 
62 }
63 
64 
65 //////////////////////////////////////////////////////////////
66 //                                                          //
67 //  Lescovex, Shareholder's ERC20  //
68 //                                                          //
69 //////////////////////////////////////////////////////////////
70 
71 
72 contract Lescovex is Ownable {
73   uint256 public totalSupply;
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   mapping(address => uint256) holded;
79 
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 
82  event Approval(address indexed owner, address indexed spender, uint256 value);
83 
84 
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88     require(block.timestamp>blockEndICO || msg.sender==owner);
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     holded[_to]=block.number;
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95 
96     
97   }
98 
99 
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104   function holdedOf(address _owner) public view returns (uint256 balance) {
105     return holded[_owner];
106   }
107 
108   mapping (address => mapping (address => uint256)) internal allowed;
109 
110 
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     holded[_to]=block.number;
118     balances[_to] = balances[_to].add(_value);
119 
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125 
126   function burn(address addr) public onlyOwner{
127     balances[addr]=0;
128   }
129 
130   function approve(address _spender, uint256 _value) public onlyOwner returns (bool) {
131     allowed[msg.sender][_spender] = _value;
132     Approval(msg.sender, _spender, _value);
133     return true;
134   }
135 
136 
137   function allowance(address _owner, address _spender) public view returns (uint256) {
138     return allowed[_owner][_spender];
139   }
140 
141 
142   function increaseApproval(address _spender, uint _addedValue) public onlyOwner returns (bool) {
143     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
144     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145     return true;
146   }
147 
148 
149   function decreaseApproval(address _spender, uint _subtractedValue) public onlyOwner returns (bool) {
150     uint oldValue = allowed[msg.sender][_spender];
151     if (_subtractedValue > oldValue) {
152       allowed[msg.sender][_spender] = 0;
153     } else {
154       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
155     }
156     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160     string public constant standard = "ERC20 Lescovex";
161 
162     /* Public variables for the ERC20 token, defined when calling the constructor */
163     string public name;
164     string public symbol;
165     uint8 public constant decimals = 8; // hardcoded to be a constant
166 
167     // Contract variables and constants
168     uint256 public constant minPrice = 7500000000000000;
169     uint256 public constant blockEndICO = 1524182460;
170     uint256 public buyPrice = minPrice;
171 
172     uint256 constant initialSupply=0;
173     string constant tokenName="Lescovex Shareholder's";
174     string constant tokenSymbol="LCX";
175 
176     uint256 public tokenReward = 0;
177     // constant to simplify conversion of token amounts into integer form
178     uint256 public tokenUnit = uint256(10)**decimals;
179     
180     // Spread in parts per 100 millions, such that expressing percentages is 
181     // just to append the postfix 'e6'. For example, 4.53% is: spread = 4.53e6
182     address public LescovexAddr = 0xD26286eb9E6E623dba88Ed504b628F648ADF7a0E;
183 
184     //Declare logging events
185     event LogDeposit(address sender, uint amount);
186 
187     /* Initializes contract with initial supply tokens to the creator of the contract */
188     function Lescovex() public {
189        
190         totalSupply = initialSupply;  // Update total supply
191         name = tokenName;             // Set the name for display purposes
192         symbol = tokenSymbol;         // Set the symbol for display purposes
193     }
194 
195     function () public payable {
196         buy();   // Allow to buy tokens sending ether direcly to contract
197     }
198     
199 
200     modifier status() {
201         _;  // modified function code should go before prices update
202 
203     if(block.timestamp<1519862460){ //until 1 march 2018
204       if(totalSupply<50000000000000){
205         buyPrice=7500000000000000;
206       }else{
207         buyPrice=8000000000000000;
208       }
209   
210     }else if(block.timestamp<1520640060){ // until 10 march 2018
211 
212       buyPrice=8000000000000000;
213     }else if(block.timestamp<1521504060){ //until 20 march 2018
214 
215       buyPrice=8500000000000000;
216     }else if(block.timestamp<1522368060){ //until 30 march 2018
217 
218       buyPrice=9000000000000000;
219 
220     }else if(block.timestamp<1523232060){ //until 9 april 2018
221       buyPrice=9500000000000000;
222 
223     }else{
224 
225       buyPrice=10000000000000000;
226     }
227 
228         
229     }
230 
231     function deposit() public payable status returns(bool success) {
232         // Check for overflows;
233         assert (this.balance + msg.value >= this.balance); // Check for overflows
234       tokenReward=this.balance/totalSupply;
235         //executes event to reflect the changes
236         LogDeposit(msg.sender, msg.value);
237         
238         return true;
239     }
240 
241   function withdrawReward() public status {
242     require (block.number - holded[msg.sender] > 172800); //1 month
243     
244     holded[msg.sender] = block.number;
245     uint256 ethAmount = tokenReward * balances[msg.sender];
246 
247     //send eth to owner address
248     msg.sender.transfer(ethAmount);
249       
250     //executes event ro register the changes
251     LogWithdrawal(msg.sender, ethAmount);
252   }
253 
254 
255   event LogWithdrawal(address receiver, uint amount);
256   
257   function withdraw(uint value) public onlyOwner {
258     //send eth to owner address
259     msg.sender.transfer(value);
260     //executes event ro register the changes
261     LogWithdrawal(msg.sender, value);
262   }
263 
264 
265     function transferBuy(address _to, uint256 _value) internal returns (bool) {
266       require(_to != address(0));
267       
268 
269       // SafeMath.sub will throw if there is not enough balance.
270 
271       totalSupply=totalSupply.add(_value*2);
272       holded[_to]=block.number;
273       balances[LescovexAddr] = balances[LescovexAddr].add(_value);
274       balances[_to] = balances[_to].add(_value);
275 
276       Transfer(this, _to, _value);
277       return true;
278       
279     }
280 
281   
282            
283     function buy() public payable status{
284      
285       require (totalSupply<=1000000000000000);
286       require(block.timestamp<blockEndICO);
287 
288       uint256 tokenAmount = (msg.value / buyPrice)*tokenUnit ;  // calculates the amount
289 
290       transferBuy(msg.sender, tokenAmount);
291       LescovexAddr.transfer(msg.value);
292     
293     }
294 
295 
296     /* Approve and then communicate the approved contract in a single tx */
297     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public onlyOwner returns (bool success) {    
298 
299         tokenRecipient spender = tokenRecipient(_spender);
300 
301         if (approve(_spender, _value)) {
302             spender.receiveApproval(msg.sender, _value, this, _extraData);
303             return true;
304         }
305     }
306 }
307 
308 
309 interface tokenRecipient {
310     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public ; 
311 }