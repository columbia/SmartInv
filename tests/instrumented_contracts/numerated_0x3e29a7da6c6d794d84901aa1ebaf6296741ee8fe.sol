1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59 
60   address public owner;
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66    constructor() public {
67     owner = 0xdE6F3798B6364eAF3FCCD73c84d10871c9e6fa8C;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner)public onlyOwner {
83     require(newOwner != address(0));
84     owner = newOwner;
85   }
86 }
87 
88 
89 /**
90  * @title Token
91  * @dev API interface for interacting with the DSGT contract 
92  */
93 interface Token {
94   function transfer(address _to, uint256 _value)external returns (bool);
95   function balanceOf(address _owner)external view returns (uint256 balance);
96 }
97 
98 contract CLTSaleContract is Ownable {
99 
100   using SafeMath for uint256;
101 
102   Token public token;
103 
104   uint256 public raisedETH; // ETH raised
105   uint256 public soldTokens; // Tokens Sold
106   uint256 public saleMinimum;
107   uint256 public price;
108 
109   address public beneficiary;
110 
111   // They'll be represented by their index numbers i.e 
112   // if the state is Dormant, then the value should be 0 
113   // Dormant:0, Active:1, , Successful:2
114   enum State {Dormant, Active,  Successful }
115 
116   State public state;
117  
118   event ActiveState();
119   event DormantState();
120   event SuccessfulState();
121 
122   event BoughtTokens(
123       address indexed who, 
124       uint256 tokensBought, 
125       uint256 investedETH
126       );
127   
128   constructor() public {
129 
130       token =Token(0x848c71FfE323898B03f58c66C9d14766EA4C1DA3); 
131       beneficiary = 0xdE6F3798B6364eAF3FCCD73c84d10871c9e6fa8C;
132       
133       saleMinimum = 5 * 1 ether;
134       state = State.Active;
135       price = 1330;
136 }
137 
138     /**
139      * Fallback function
140      *
141      * @dev This function will be called whenever anyone sends funds to a contract,
142      * throws if the sale isn't Active or the sale minimum isn't met
143      */
144     function () public payable {
145         require(msg.value >= saleMinimum);
146         require(state == State.Active);
147         require(token.balanceOf(this) > 0);
148         
149         buyTokens(msg.value);
150       }
151 
152 
153 
154   /**
155   * @dev Function that sells available tokens
156   */
157   function buyTokens(uint256 _invested) internal   {
158 
159     uint256 invested = _invested;
160     uint256 numberOfTokens;
161     
162     numberOfTokens = invested.mul(price);
163 
164     
165     beneficiary.transfer(msg.value);
166     token.transfer(msg.sender, numberOfTokens);
167     
168     raisedETH = raisedETH.add(msg.value);
169     soldTokens = soldTokens.add(numberOfTokens);
170 
171     emit BoughtTokens(msg.sender, numberOfTokens, invested);
172     
173     }
174     
175 
176   /**
177    * @dev Change the price during the different rounds
178    */
179   function changeRate(uint256 _newPrice) public onlyOwner {
180       price = _newPrice;
181   }    
182 
183   /**
184    *  @dev Change the sale minimum
185    */
186   function changeSaleMinimum(uint256 _newAmount) public onlyOwner {
187       saleMinimum = _newAmount;
188   }
189 
190   /**
191    * @dev Ends the sale, once ended can't be reopened again
192    */
193   function endSale() public onlyOwner {
194     require(state == State.Active || state == State.Dormant);
195     
196     state = State.Successful;
197     emit SuccessfulState();
198   }
199   
200 
201    /**
202    * @dev Makes the sale dormant, no deposits are allowed
203    */
204   function pauseSale() public onlyOwner {
205       require(state == State.Active);
206       
207       state = State.Dormant;
208       emit DormantState();
209   }
210   
211   /**
212    * @dev Makes the sale active, thus funds can be received
213    */
214   function openSale() public onlyOwner {
215       require(state == State.Dormant);
216       
217       state = State.Active;
218       emit ActiveState();
219   }
220   
221   /**
222    * @dev [!!ALERT!!] USE THIS ONLY IN EMERGENCY 
223    */
224   function emergencyFlush() public onlyOwner {
225       token.transfer(owner, token.balanceOf(this));
226   }
227   
228 
229   /**
230    * @notice Terminate contract and send any ETH left in contract to owner
231    */
232   function destroyContract() public onlyOwner {
233 
234     // There should be no ether in the contract but just in case
235     selfdestruct(owner);
236   }
237 
238 }