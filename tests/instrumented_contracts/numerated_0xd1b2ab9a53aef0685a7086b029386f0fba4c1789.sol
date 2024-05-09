1 pragma solidity ^0.4.25;
2 
3 // Author: Securypto Team | Iceman
4 // Telegram: ice_man0
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25 
26   /**
27   * @dev Adds two numbers, throws on overflow.
28   */
29   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
30     c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42 
43   address public owner;
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49    constructor() public {
50     owner = msg.sender;
51   }
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner)public onlyOwner {
66     require(newOwner != address(0));
67     owner = newOwner;
68   }
69 }
70 
71 /**
72  * @title Token
73  * @dev API interface for interacting with the DSGT contract 
74  */
75 interface Token {
76   function transfer(address _to, uint256 _value)external returns (bool);
77   function balanceOf(address _owner)external view returns (uint256 balance);
78 }
79 
80 contract Crowdsale is Ownable {
81 
82   using SafeMath for uint256;
83 
84   Token public token;
85 
86   uint256 public raisedETH; // ETH raised
87   uint256 public soldTokens; // Tokens Sold
88   uint256 public saleMinimum = 0.1 * 1 ether;
89   uint256 public price;
90 
91   address public beneficiary;
92 
93   // They'll be represented by their index numbers i.e 
94   // if the state is Dormant, then the value should be 0 
95   // Dormant:0, Active:1, , Successful:2
96   enum State {Dormant, Active,  Successful }
97 
98   State public state;
99  
100   event ActiveState();
101   event DormantState();
102   event SuccessfulState();
103 
104   event BoughtTokens(
105       address indexed who, 
106       uint256 tokensBought, 
107       uint256 investedETH
108       );
109   
110   constructor() 
111               public 
112               {
113                 token = Token(0x2Ed92cae08B7E24d7C01A11049750498ebCAe8E0);
114                 beneficiary = msg.sender;
115     }
116 
117     /**
118      * Fallback function
119      *
120      * @dev This function will be called whenever anyone sends funds to a contract,
121      * throws if the sale isn't Active or the sale minimum isn't met
122      */
123     function () public payable {
124         require(msg.value >= saleMinimum);
125         require(state == State.Active);
126         require(token.balanceOf(this) > 0);
127         
128         buyTokens();
129       }
130 
131   /**
132   * @dev Function that sells available tokens
133   */
134   function buyTokens() public payable  {
135     
136     uint256 invested = msg.value;
137     
138     uint256 numberOfTokens = invested.mul(price);
139     
140     beneficiary.transfer(msg.value);
141     
142     token.transfer(msg.sender, numberOfTokens);
143     
144     raisedETH = raisedETH.add(msg.value);
145     
146     soldTokens = soldTokens.add(numberOfTokens);
147 
148     emit BoughtTokens(msg.sender, numberOfTokens, invested);
149     
150     }
151 
152 
153   /**
154    * @dev Change the price during the different rounds
155    */
156   function changeRate(uint256 _newPrice) public onlyOwner {
157       price = _newPrice;
158   }    
159 
160   /**
161    *  @dev Change the sale minimum
162    */
163   function changeSaleMinimum(uint256 _newAmount) public onlyOwner {
164       saleMinimum = _newAmount;
165   }
166 
167   /**
168    * @dev Ends the sale
169    */
170   function endSale() public onlyOwner {
171     require(state == State.Active || state == State.Dormant);
172     
173     state = State.Successful;
174     emit SuccessfulState();
175 
176     selfdestruct(owner);
177 
178   }
179   
180    /**
181    * @dev Makes the sale dormant, no deposits are allowed
182    */
183   function pauseSale() public onlyOwner {
184       require(state == State.Active);
185       
186       state = State.Dormant;
187       emit DormantState();
188   }
189   
190   /**
191    * @dev Makes the sale active, thus funds can be received
192    */
193   function openSale() public onlyOwner {
194       require(state == State.Dormant);
195       
196       state = State.Active;
197       emit ActiveState();
198   }
199   
200   /**
201    *  @dev Returns the number of tokens in contract
202    */
203   function tokensAvailable() public view returns(uint256) {
204       return token.balanceOf(this);
205   }
206 
207 }