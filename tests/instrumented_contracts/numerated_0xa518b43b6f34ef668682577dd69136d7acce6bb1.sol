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
67 //  MineBlocks, Shareholder's ERC20  //
68 //                                                          //
69 //////////////////////////////////////////////////////////////
70 
71 
72 contract MineBlocks is Ownable {
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
88     if(block.number>blockEndICO || msg.sender==owner){
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     holded[_to]=block.number;
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95     }
96   }
97 
98 
99   function balanceOf(address _owner) public view returns (uint256 balance) {
100     return balances[_owner];
101   }
102 
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[_from]);
110     require(_value <= allowed[_from][msg.sender]);
111 
112     balances[_from] = balances[_from].sub(_value);
113     holded[_to]=block.number;
114     balances[_to] = balances[_to].add(_value);
115 
116     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120 
121 
122 
123   function approve(address _spender, uint256 _value) public returns (bool) {
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129 
130   function allowance(address _owner, address _spender) public view returns (uint256) {
131     return allowed[_owner][_spender];
132   }
133 
134 
135   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
136     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
137     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138     return true;
139   }
140 
141 
142   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
143     uint oldValue = allowed[msg.sender][_spender];
144     if (_subtractedValue > oldValue) {
145       allowed[msg.sender][_spender] = 0;
146     } else {
147       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
148     }
149     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150     return true;
151   }
152 
153     string public constant standard = "ERC20 MineBlocks";
154 
155     /* Public variables for the ERC20 token, defined when calling the constructor */
156     string public name;
157     string public symbol;
158     uint8 public constant decimals = 8; // hardcoded to be a constant
159 
160     // Contract variables and constants
161     uint256 public constant minPrice = 1500000000000000;
162     uint256 public blockEndICO = block.number + uint256(259200);
163     uint256 public buyPrice = minPrice;
164 
165     uint256 constant initialSupply=1000000000000000;
166     string constant tokenName="MineBlocks Token";
167     string constant tokenSymbol="MBK";
168 
169     uint256 public tokenReward = 0;
170     // constant to simplify conversion of token amounts into integer form
171     uint256 private constant tokenUnit = uint256(10)**decimals;
172     
173     // Spread in parts per 100 millions, such that expressing percentages is 
174     // just to append the postfix 'e6'. For example, 4.53% is: spread = 4.53e6
175     address public MineBlocksAddr = 0x0d518b5724C6aee0c7F1B2eB1D89d62a2a7b1b58;
176 
177     //Declare logging events
178     event LogDeposit(address sender, uint amount);
179 
180     /* Initializes contract with initial supply tokens to the creator of the contract */
181     function MineBlocks() public {
182         balances[msg.sender] = initialSupply; // Give the creator all initial tokens
183         totalSupply = initialSupply;  // Update total supply
184         name = tokenName;             // Set the name for display purposes
185         symbol = tokenSymbol;         // Set the symbol for display purposes
186 
187     }
188 
189     function () public payable {
190         buy();   // Allow to buy tokens sending ether direcly to contract
191     }
192     
193 
194     modifier status() {
195         _;  // modified function code should go before prices update
196 
197     if(balances[this]>600000000000000){
198       buyPrice=1500000000000000;
199     }else if(balances[this]>500000000000000 && balances[this]<=600000000000000){
200 
201       buyPrice=2000000000000000;
202     }else if(balances[this]>400000000000000 && balances[this]<=500000000000000){
203 
204       buyPrice=2500000000000000;
205     }else if(balances[this]>300000000000000 && balances[this]<=400000000000000){
206 
207       buyPrice=3000000000000000;
208     }else{
209 
210       buyPrice=4000000000000000;
211     }
212         
213     }
214 
215     function deposit() public payable status returns(bool success) {
216         // Check for overflows;
217         assert (this.balance + msg.value >= this.balance); // Check for overflows
218       tokenReward=this.balance/totalSupply;
219         //executes event to reflect the changes
220         LogDeposit(msg.sender, msg.value);
221         
222         return true;
223     }
224 
225   function withdrawReward() public status{
226 
227     
228       if(block.number-holded[msg.sender]>172800){ //1 month
229      //// if(block.number-holded[msg.sender]>10){
230 
231       holded[msg.sender]=block.number;
232 
233       //send eth to owner address
234       msg.sender.transfer(tokenReward*balances[msg.sender]);
235       
236       //executes event ro register the changes
237       LogWithdrawal(msg.sender, tokenReward*balances[msg.sender]);
238 
239     }
240   }
241 
242 
243   event LogWithdrawal(address receiver, uint amount);
244   
245   function withdraw(uint value) public onlyOwner {
246     //send eth to owner address
247     msg.sender.transfer(value);
248     //executes event ro register the changes
249     LogWithdrawal(msg.sender, value);
250   }
251 
252 
253     function transferBuy(address _to, uint256 _value) internal returns (bool) {
254       require(_to != address(0));
255       require(_value <= balances[this]);
256 
257       // SafeMath.sub will throw if there is not enough balance.
258       balances[this] = balances[this].sub(_value);
259       holded[_to]=block.number;
260       balances[_to] = balances[_to].add(_value);
261       Transfer(this, _to, _value);
262       return true;
263       
264     }
265 
266 
267     function buy() public payable status{
268       require (msg.sender.balance >= msg.value);  // Check if the sender has enought eth to buy
269       assert (msg.sender.balance + msg.value >= msg.sender.balance); //check for overflows
270          
271       uint256 tokenAmount = (msg.value / buyPrice)*tokenUnit ;  // calculates the amount
272 
273       transferBuy(msg.sender, tokenAmount);
274       MineBlocksAddr.transfer(msg.value);
275     
276     }
277 
278 
279     /* Approve and then communicate the approved contract in a single tx */
280     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public onlyOwner returns (bool success) {    
281 
282         tokenRecipient spender = tokenRecipient(_spender);
283 
284         if (approve(_spender, _value)) {
285             spender.receiveApproval(msg.sender, _value, this, _extraData);
286             return true;
287         }
288     }
289 }
290 
291 
292 contract tokenRecipient {
293     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public ; 
294 }