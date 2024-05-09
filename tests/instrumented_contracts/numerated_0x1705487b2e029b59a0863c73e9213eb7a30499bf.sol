1 pragma solidity ^0.4.21;
2 // import './bonbon.sol';
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     return a / b;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23     c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34   constructor() public {
35     owner = msg.sender;
36   }
37 
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     emit OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 }
49 
50 interface AirdropToken {
51   function transfer(address _to, uint256 _value) external returns (bool);
52   function balanceOf(address _owner) constant external returns (uint256);
53   function decimals() constant external returns (uint256);
54 }
55 
56 contract ICOAirCenter is Ownable {
57   using SafeMath for uint256;
58 
59   address public airdroptoken;
60   uint256 public decimals;
61   uint256 public rate;
62   uint256 public weiRaised;
63   AirdropToken internal token;
64   AirdropToken internal tmptoken;
65   AirdropToken internal icotoken;
66 
67   event TransferredToken(address indexed to, uint256 value);
68   event FailedTransfer(address indexed to, uint256 value);
69   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
70 
71   modifier whenDropIsActive() {
72     assert(isActive());
73     _;
74   }
75 
76   constructor() public {
77     // initial token
78     airdroptoken = 0x6EA3bA628a73D22E924924dF3661843e53e5c3AA;
79     token = AirdropToken(airdroptoken);
80     tmptoken = AirdropToken(airdroptoken);
81     icotoken = AirdropToken(airdroptoken);
82     decimals = getDecimals();
83     rate = 10000; // 1 eth for 10000 bbt
84   }
85 
86   function () external payable{
87     getTokens(msg.sender);
88   }
89 
90   function getTokens(address _beneficiary) public payable{
91     uint256 weiAmount = msg.value;
92     _preValidatePurchase(_beneficiary, weiAmount);
93     uint256 tokens = _getTokenAmount(weiAmount);
94     uint256 tokenbalance = icotoken.balanceOf(this);
95     require(tokenbalance >= tokens);
96     weiRaised = weiRaised.add(weiAmount);
97     _processPurchase(_beneficiary, tokens);
98     emit TokenPurchase(msg.sender,_beneficiary,weiAmount,tokens);
99     _updatePurchasingState(_beneficiary, weiAmount);
100     _postValidatePurchase(_beneficiary, weiAmount);
101   }
102 
103   // begin buy token related functions 
104   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal pure {
105     require(_beneficiary != address(0));
106     require(_weiAmount != 0);
107   }
108 
109   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal pure {
110     // optional override
111   }
112 
113   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
114     icotoken.transfer(_beneficiary, _tokenAmount);
115   }
116 
117   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
118     _deliverTokens(_beneficiary, _tokenAmount);
119   }
120 
121   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal pure{
122     // optional override
123   }
124 
125   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
126     return _weiAmount.mul(rate);
127   }
128 
129   // end
130 
131   function isActive() public constant returns (bool) {
132     return (
133       tokensAvailable() > 0 // Tokens must be available to send
134       );
135   }
136 
137   function getDecimals() public constant returns (uint256){
138     return token.decimals();
139   }
140 
141 
142   function setToken(address tokenaddress) onlyOwner external{
143     require(tokenaddress != address(0));
144     token = AirdropToken(tokenaddress);
145     airdroptoken = tokenaddress;
146     decimals = getDecimals();
147   }
148 
149   //below function can be used when you want to send every recipeint with different number of tokens
150   function sendTokens(address tokenaddress,address[] dests, uint256[] values) whenDropIsActive onlyOwner external {
151     require(dests.length == values.length);
152     require(tokenaddress == airdroptoken);
153     uint256 i = 0;
154     while (i < dests.length) {
155       uint256 toSend = values[i].mul(10**decimals);
156       sendInternally(dests[i] , toSend, values[i]);
157       i++;
158     }
159   }
160 
161   // this function can be used when you want to send same number of tokens to all the recipients
162   function sendTokensSingleValue(address tokenaddress,address[] dests, uint256 value) whenDropIsActive onlyOwner external {
163     require(tokenaddress == airdroptoken);
164     
165     uint256 i = 0;
166     uint256 toSend = value.mul(10**decimals);
167     while (i < dests.length) {
168       sendInternally(dests[i] , toSend, value);
169       i++;
170     }
171   }  
172 
173   function sendInternally(address recipient, uint256 tokensToSend, uint256 valueToPresent) internal {
174     if(recipient == address(0)) return;
175 
176     if(tokensAvailable() >= tokensToSend) {
177       token.transfer(recipient, tokensToSend);
178       emit TransferredToken(recipient, valueToPresent);
179     }else {
180         emit FailedTransfer(recipient, valueToPresent);
181     }
182   }
183 
184   function tokensAvailable() public constant returns (uint256) {
185     return token.balanceOf(this);
186   }
187 
188   // fund retrieval related functions
189   function retrieveToken(address tokenaddress) public onlyOwner{
190     tmptoken = AirdropToken(tokenaddress);
191     uint256 balance = tmptoken.balanceOf(this);
192     require (balance > 0);
193     tmptoken.transfer(owner,balance);
194   }
195 
196   function retrieveEth(uint256 value) public onlyOwner{
197     uint256 ethamount = value.mul(10**18);
198     uint256 balance = address(this).balance;
199     require (balance > 0 && ethamount<= balance);
200     owner.transfer(ethamount);
201   }
202 
203   function destroy() public onlyOwner {
204     uint256 balance = tokensAvailable();
205     require (balance > 0);
206     token.transfer(owner, balance);
207     selfdestruct(owner);
208   }
209 }