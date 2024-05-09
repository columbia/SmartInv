1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7 */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipRenounced(address indexed previousOwner);
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     constructor() public {
15         owner = 0xfd52FA412913096A6B2E84374baBF84b6FF2baf6;
16     }
17 
18     modifier onlyOwner() {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     function transferOwnership(address newOwner) public onlyOwner {
24         require(newOwner != address(0));
25         emit OwnershipTransferred(owner, newOwner);
26         owner = newOwner;
27     }
28 
29     function renounceOwnership() public onlyOwner {
30         emit OwnershipRenounced(owner);
31         owner = address(0);
32     }
33 }
34 
35 contract FranklinFarmer is Ownable {
36 
37     // The tokens can never be stolen
38     modifier secCheck(address aContract) {
39         require(aContract != address(contractCall));
40         _;
41     }
42 
43     /**
44     * Data
45     */
46 
47     _Contract contractCall;  // a reference to the contract
48 
49     //
50     uint256 public KNOWLEDGE_TO_GET_1FRANKLIN=86400; //for final version should be seconds in a day
51     uint256 PSN=10000;
52     uint256 PSNH=5000;
53     bool public initialized=false;
54     mapping (address => uint256) public hatcheryFranklin;
55     mapping (address => uint256) public claimedKnowledge;
56     mapping (address => uint256) public lastUse;
57     mapping (address => address) public referrals;
58     uint256 public marketKnowledge;
59 
60     constructor() public {
61         contractCall = _Contract(0x05215FCE25902366480696F38C3093e31DBCE69A);
62     }
63 
64     // If you send money directly to the contract it gets treated like a donation
65     function() payable public {
66     }
67 
68     // External is cheaper to use because it uses the calldata opcode 
69     // while public needs to copy all the arguments to memory, as described here.
70     function useKnowledge(address ref) external {
71         require(initialized);
72         if(referrals[msg.sender] == 0 && referrals[msg.sender]!=msg.sender){
73             referrals[msg.sender] = ref;
74         }
75         uint256 knowledgeUsed = getMyKnowledge();
76         uint256 newFranklin = SafeMath.div(knowledgeUsed,KNOWLEDGE_TO_GET_1FRANKLIN);
77         hatcheryFranklin[msg.sender] = SafeMath.add(hatcheryFranklin[msg.sender],newFranklin);
78         claimedKnowledge[msg.sender] = 0;
79         lastUse[msg.sender] = now;
80         
81         //send referral
82         claimedKnowledge[referrals[msg.sender]] = SafeMath.add(claimedKnowledge[referrals[msg.sender]],SafeMath.div(knowledgeUsed,5));
83         
84         //boost market to nerf hoarding
85         marketKnowledge = SafeMath.add(marketKnowledge,SafeMath.div(knowledgeUsed,10));
86     }
87 
88     function sellKnowledge() external {
89         require(initialized);
90         address customerAddress = msg.sender;
91         uint256 hasKnowledge = getMyKnowledge();
92         uint256 knowledgeValue = calculateKnowledgeSell(hasKnowledge);
93         uint256 fee = devFee(knowledgeValue);
94         claimedKnowledge[customerAddress] = 0;
95         lastUse[customerAddress] = now;
96         marketKnowledge = SafeMath.add(marketKnowledge,hasKnowledge);
97         owner.transfer(fee);
98         //
99         uint256 amountLeft = SafeMath.sub(knowledgeValue,fee);
100         //customerAddress.transfer(amountLeft);
101         contractCall.buy.value(amountLeft)(customerAddress);
102         contractCall.transfer(customerAddress, myTokens()); // 50000000000000000 = 0.05 Rev1 tokens
103     }
104     function buyKnowledge() external payable{
105         require(initialized);
106         uint256 knowledgeBought = calculateKnowledgeBuy(msg.value,SafeMath.sub(this.balance,msg.value));
107         claimedKnowledge[msg.sender] = SafeMath.add(claimedKnowledge[msg.sender],knowledgeBought);
108     }
109     //magic trade balancing algorithm
110     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
111         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
112         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
113     }
114     function calculateKnowledgeSell(uint256 knowledge) public view returns(uint256){
115         return calculateTrade(knowledge,marketKnowledge,this.balance);
116     }
117     function calculateKnowledgeBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
118         return calculateTrade(eth,contractBalance,marketKnowledge);
119     }
120     function calculateKnowledgeBuySimple(uint256 eth) public view returns(uint256){
121         return calculateKnowledgeBuy(eth,this.balance);
122     }
123     function devFee(uint256 amount) public view returns(uint256){
124         return SafeMath.div(SafeMath.mul(amount,50),100); // 50%
125     }
126     function seedMarket(uint256 knowledge) external payable {
127         require(marketKnowledge==0);
128         initialized = true;
129         marketKnowledge = knowledge;
130     }
131 
132     function getBalance() public view returns(uint256){
133         return this.balance;
134     }
135     function getMyFranklin() public view returns(uint256){
136         return hatcheryFranklin[msg.sender];
137     }
138     function getMyKnowledge() public view returns(uint256){
139         return SafeMath.add(claimedKnowledge[msg.sender],getKnowledgeSinceLastUse(msg.sender));
140     }
141     function getKnowledgeSinceLastUse(address adr) public view returns(uint256){
142         uint256 secondsPassed = min(KNOWLEDGE_TO_GET_1FRANKLIN,SafeMath.sub(now,lastUse[adr]));
143         return SafeMath.mul(secondsPassed,hatcheryFranklin[adr]);
144     }
145     function min(uint256 a, uint256 b) private pure returns (uint256) {
146         return a < b ? a : b;
147     }
148 
149     // Rev1 related information functions
150     function myTokens() public view returns(uint256) {
151         return contractCall.myTokens();
152     }
153 
154     function myDividends() public view returns(uint256) {
155         return contractCall.myDividends(true);
156     }
157 
158 
159      /* A trap door for when someone sends tokens other than the intended ones so the overseers
160       can decide where to send them. (credit: Doublr Contract) */
161     function returnAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) public onlyOwner() secCheck(tokenAddress) returns (bool success) {
162         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
163     }
164 
165 
166 }
167 
168 
169 //Need to ensure this contract can send tokens to people
170 contract ERC20Interface
171 {
172     function transfer(address to, uint256 tokens) public returns (bool success);
173 }
174 
175 // Interface to actually call contract functions of e.g. REV1
176 contract _Contract
177 {
178     function buy(address) public payable returns(uint256);
179     function exit() public;
180     function myTokens() public view returns(uint256);
181     function myDividends(bool) public view returns(uint256);
182     function withdraw() public;
183     function transfer(address, uint256) public returns(bool);
184 }
185 
186 library SafeMath {
187 
188      /**
189       * @dev Multiplies two numbers, throws on overflow.
190      */
191     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192         if (a == 0) {
193             return 0;
194         }
195         uint256 c = a * b;
196         assert(c / a == b);
197         return c;
198     }
199 
200       /**
201       * @dev Integer division of two numbers, truncating the quotient.
202       */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         // assert(b > 0); // Solidity automatically throws when dividing by 0
205         uint256 c = a / b;
206         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
207         return c;
208     }
209 
210     /**
211     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
212     */
213     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214         assert(b <= a);
215         return a - b;
216     }
217 
218     /**
219     * @dev Adds two numbers, throws on overflow.
220     */
221     function add(uint256 a, uint256 b) internal pure returns (uint256) {
222         uint256 c = a + b;
223         assert(c >= a);
224         return c;
225     }
226 }