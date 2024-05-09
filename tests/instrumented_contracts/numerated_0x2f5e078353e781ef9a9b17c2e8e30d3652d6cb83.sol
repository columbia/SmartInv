1 /**
2  *   Golden Union - Blockchain platform for direct investment in gold mining
3  *   https://goldenunion.org
4  *   ----------------------------
5  *   telegram @golden_union
6  *   developed by Inout Corp
7  */
8 
9 pragma solidity ^0.4.23;
10 
11 contract ERC20Basic {
12     function totalSupply() public view returns (uint256);
13     function balanceOf(address who) public view returns (uint256);
14     function transfer(address to, uint256 value) public returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 contract ERC20 is ERC20Basic {
19     function allowance(address owner, address spender) 
20         public view returns (uint256);
21 
22     function transferFrom(address from, address to, uint256 value)
23         public returns (bool);
24 
25     function approve(address spender, uint256 value) public returns (bool);
26     event Approval(
27             address indexed owner,
28             address indexed spender,
29             uint256 value
30     );
31 }
32 
33 library SafeMath {
34 
35     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
36         if (a == 0) {
37             return 0;
38         }
39         c = a * b;
40         assert(c / a == b);
41         return c;
42     }
43 
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         return a / b;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         assert(b <= a);
50         return a - b;
51     }
52 
53     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
54         c = a + b;
55         assert(c >= a);
56         return c;
57     }
58 }
59 
60 contract BasicToken is ERC20Basic {
61     using SafeMath for uint256;
62 
63     mapping(address => uint256) balances;
64 
65     uint256 totalSupply_;
66 
67     function totalSupply() public view returns (uint256) {
68         return totalSupply_;
69     }
70 
71     function transfer(address _to, uint256 _value) public returns (bool) {
72         require(_to != address(0));
73         require(_value <= balances[msg.sender]);
74 
75         balances[msg.sender] = balances[msg.sender].sub(_value);
76         balances[_to] = balances[_to].add(_value);
77         emit Transfer(msg.sender, _to, _value);
78         return true;
79     }
80   
81     function transferWholeTokens(address _to, uint256 _value) public returns (bool) {
82         // the sum is entered in whole tokens (1 = 1 token)
83         uint256 value = _value;
84         value = value.mul(1 ether);
85         return transfer(_to, value);
86     }
87 
88 
89 
90     function balanceOf(address _owner) public view returns (uint256) {
91         return balances[_owner];
92     }
93 
94 }
95 
96 contract StandardToken is ERC20, BasicToken {
97 
98     mapping (address => mapping (address => uint256)) internal allowed;
99 
100 
101     function transferFrom(
102         address _from,
103         address _to,
104         uint256 _value
105     )
106       public
107       returns (bool)
108     {
109         require(_to != address(0));
110         require(_value <= balances[_from]);
111         require(_value <= allowed[_from][msg.sender]);
112 
113         balances[_from] = balances[_from].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116         emit Transfer(_from, _to, _value);
117         return true;
118     }
119 
120 
121     function approve(address _spender, uint256 _value) public returns (bool) {
122         allowed[msg.sender][_spender] = _value;
123         emit Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127 
128     function allowance(
129         address _owner,
130         address _spender
131     )
132       public
133       view
134         returns (uint256)
135     {
136         return allowed[_owner][_spender];
137     }
138 
139 
140     function increaseApproval(
141         address _spender,
142         uint _addedValue
143     )
144       public
145       returns (bool)
146     {
147         allowed[msg.sender][_spender] = (
148         allowed[msg.sender][_spender].add(_addedValue));
149         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150         return true;
151     }
152 
153 
154     function decreaseApproval(
155         address _spender,
156         uint _subtractedValue
157     )
158       public
159       returns (bool)
160     {
161         uint oldValue = allowed[msg.sender][_spender];
162         if (_subtractedValue > oldValue) {
163             allowed[msg.sender][_spender] = 0;
164         } else {
165             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166         }
167         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168         return true;
169     }
170 
171 }
172 
173 contract GoldenUnitToken is StandardToken {
174     string public constant name = "Golden Unite Token";
175     string public constant symbol = "GUT";
176     uint32 public constant decimals = 18;
177     uint256 public INITIAL_SUPPLY = 100000 * 1 ether;
178     address public CrowdsaleAddress;
179     
180     event Mint(address indexed to, uint256 amount);
181     
182     constructor(address _CrowdsaleAddress) public {
183       
184         CrowdsaleAddress = _CrowdsaleAddress;
185         totalSupply_ = INITIAL_SUPPLY;
186         balances[msg.sender] = INITIAL_SUPPLY;      
187     }
188   
189     modifier onlyOwner() {
190         require(msg.sender == CrowdsaleAddress);
191         _;
192     }
193 
194     function acceptTokens(address _from, uint256 _value) public onlyOwner returns (bool){
195         require (balances[_from] >= _value);
196         balances[_from] = balances[_from].sub(_value);
197         balances[CrowdsaleAddress] = balances[CrowdsaleAddress].add(_value);
198         emit Transfer(_from, CrowdsaleAddress, _value);
199         return true;
200     }
201   
202     function mint(uint256 _amount)  public onlyOwner returns (bool){
203         totalSupply_ = totalSupply_.add(_amount);
204         balances[CrowdsaleAddress] = balances[CrowdsaleAddress].add(_amount);
205         emit Mint(CrowdsaleAddress, _amount);
206         emit Transfer(address(0), CrowdsaleAddress, _amount);
207         return true;
208     }
209 
210 
211     function() external payable {
212         // The token contract don`t receive ether
213         revert();
214     }  
215 }
216 
217 contract Ownable {
218     address public owner;
219     address candidate;
220 
221     constructor() public {
222         owner = msg.sender;
223     }
224 
225     modifier onlyOwner() {
226         require(msg.sender == owner);
227         _;
228     }
229 
230 
231     function transferOwnership(address newOwner) public onlyOwner {
232         require(newOwner != address(0));
233         candidate = newOwner;
234     }
235 
236     function confirmOwnership() public {
237         require(candidate == msg.sender);
238         owner = candidate;
239         delete candidate;
240     }
241 
242 }
243 
244 contract GoldenUnionCrowdsale is Ownable {
245     using SafeMath for uint; 
246     address myAddress = this;
247     uint public  saleRate = 30;  //tokens for 1 ether
248     uint public  purchaseRate = 30;  //tokens for 1 ether
249     bool public purchaseTokens = false;
250 
251     event Mint(address indexed to, uint256 amount);
252     event SaleRates(uint256 indexed value);
253     event PurchaseRates(uint256 indexed value);
254     event Withdraw(address indexed from, address indexed to, uint256 amount);
255 
256     modifier purchaseAlloved() {
257         // The contract accept tokens
258         require(purchaseTokens);
259         _;
260     }
261 
262 
263     GoldenUnitToken public token = new GoldenUnitToken(myAddress);
264   
265 
266     function mintTokens(uint256 _amount) public onlyOwner returns (bool){
267         //_amount in tokens. 1 = 1 token
268         uint256 amount = _amount;
269         require (amount <= 1000000);
270         amount = amount.mul(1 ether);
271         token.mint(amount);
272         return true;
273     }
274 
275 
276     function giveTokens(address _newInvestor, uint256 _value) public onlyOwner {
277         // the function give tokens to new investors
278         // the sum is entered in whole tokens (1 = 1 token)
279         uint256 value = _value;
280         require (_newInvestor != address(0));
281         require (value >= 1);
282         value = value.mul(1 ether);
283         token.transfer(_newInvestor, value);
284     }  
285     
286     function takeTokens(address _Investor, uint256 _value) public onlyOwner {
287         // the function take tokens from users to contract
288         // the sum is entered in whole tokens (1 = 1 token)
289         uint256 value = _value;
290         require (_Investor != address(0));
291         require (value >= 1);
292         value = value.mul(1 ether);
293         token.acceptTokens(_Investor, value);    
294     }  
295 
296  
297  
298     function setSaleRate(uint256 newRate) public onlyOwner {
299         saleRate = newRate;
300         emit SaleRates(newRate);
301     }
302   
303     function setPurchaseRate(uint256 newRate) public onlyOwner {
304         purchaseRate = newRate;
305         emit PurchaseRates(newRate);
306     }  
307    
308     function startPurchaseTokens() public onlyOwner {
309         purchaseTokens = true;
310     }
311 
312     function stopPurchaseTokens() public onlyOwner {
313         purchaseTokens = false;
314     }
315   
316     function purchase (uint256 _valueTokens) public purchaseAlloved {
317         // function purchase tokens and send ether to sender
318         address profitOwner = msg.sender;
319         require(profitOwner != address(0));
320         require(_valueTokens > 0);
321         uint256 valueTokens = _valueTokens;
322         valueTokens = valueTokens.mul(1 ether);
323         // check client tokens balance
324         require (token.balanceOf(profitOwner) >= valueTokens);
325         // calc amount of ether
326         require (purchaseRate>0);
327         uint256 valueEther = valueTokens.div(purchaseRate);
328         // check balance contract
329         require (myAddress.balance >= valueEther);
330         // transfer tokens
331         if (token.acceptTokens(msg.sender, valueTokens)){
332         // transfer ether
333             profitOwner.transfer(valueEther);
334         }
335     }
336   
337     function withdrawProfit (address _to, uint256 _value) public onlyOwner {
338         // function withdraw prohit
339         require (myAddress.balance >= _value);
340         require(_to != address(0));
341         _to.transfer(_value);
342         emit Withdraw(msg.sender, _to, _value);
343     }
344  
345     function saleTokens() internal {
346         require (msg.value >= 1 ether);  //minimum 1 ether
347         uint tokens = saleRate.mul(msg.value);
348         token.transfer(msg.sender, tokens);
349     }
350  
351     function() external payable {
352         saleTokens();
353     }    
354 }