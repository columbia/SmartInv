1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Owned contract
5 // ----------------------------------------------------------------------------
6 contract Owned {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17 }
18 
19 // ----------------------------------------------------------------------------
20 // Safe maths
21 // ----------------------------------------------------------------------------
22 library SafeMath {
23     function add(uint a, uint b) internal pure returns (uint c) {
24         c = a + b;
25         require(c >= a);
26     }
27     function sub(uint a, uint b) internal pure returns (uint c) {
28         require(b <= a);
29         c = a - b;
30     }
31     function mul(uint a, uint b) internal pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35     function div(uint a, uint b) internal pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 contract VenaCoin is ERC20Interface, Owned{
57     using SafeMath for uint;
58     
59     string public symbol;
60     string public name;
61     uint8 public decimals;
62     uint _totalSupply;
63     mapping(address => uint) balances;
64     mapping(address => mapping(address => uint)) allowed;
65     mapping(address => uint256) investments;
66     address[] contributors;
67     address[] contestContributors = new address[](50);
68     uint256 public rate; // How many token units a buyer gets per wei
69     uint256 public weiRaised;  // Amount of wei raised
70     uint value;
71     uint _ICOTokensLimit;
72     uint _ownerTokensLimit;
73     uint bonusPercentage;
74     uint256 public openingTime;
75     uint256 public closingTime;
76     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
77     /**
78     * Reverts if not in crowdsale time range. 
79     */
80     modifier onlyWhileOpen {
81        require(now >= openingTime && now <= closingTime, "Sale open");
82         _;
83     }
84     
85     modifier icoClose{
86        require(now > closingTime);
87         _;
88     }
89     // ------------------------------------------------------------------------
90     // Constructor
91     // ------------------------------------------------------------------------
92     constructor(address _owner) public{
93         openingTime = 1528644600; // 10 june, 2018 3:30pm GMT
94         closingTime = 1539185400; // 10 Oct, 2018 3:30 pm GMT
95         symbol = "VENA";
96         name = "VenaCoin";
97         decimals = 18;
98         rate = 1961; //tokens per wei ... 0.3$/vena on rate of 1eth = $589
99         owner = _owner;
100         _totalSupply = totalSupply();
101         _ICOTokensLimit = _icoTokens();
102         _ownerTokensLimit = _ownersTokens();
103         balances[owner] = _ownerTokensLimit;
104         balances[this] = _ICOTokensLimit;
105         emit Transfer(address(0),owner,_ownerTokensLimit);
106         emit Transfer(address(0),this,_ICOTokensLimit);
107     }
108     
109     function _icoTokens() internal constant returns(uint){
110         return 1700000000 * 10**uint(decimals); //1.7 billion
111     }
112     
113     function _ownersTokens() internal constant returns(uint){
114         return 300000000 * 10**uint(decimals); //300 million
115     }
116     
117     function totalSupply() public constant returns (uint){
118        return 2000000000 * 10**uint(decimals); //2 billion
119     }
120     
121     // ------------------------------------------------------------------------
122     // Get the token balance for account `tokenOwner`
123     // ------------------------------------------------------------------------
124     function balanceOf(address tokenOwner) public constant returns (uint balance) {
125         return balances[tokenOwner];
126     }
127 
128     // ------------------------------------------------------------------------
129     // Transfer the balance from token owner's account to `to` account
130     // - Owner's account must have sufficient balance to transfer
131     // - 0 value transfers are allowed
132     // ------------------------------------------------------------------------
133     function transfer(address to, uint tokens) public returns (bool success) {
134         // prevent transfer to 0x0, use burn instead
135         require(to != 0x0);
136         require(balances[msg.sender] >= tokens );
137         require(balances[to] + tokens >= balances[to]);
138         balances[msg.sender] = balances[msg.sender].sub(tokens);
139         balances[to] = balances[to].add(tokens);
140         emit Transfer(msg.sender,to,tokens);
141         return true;
142     }
143     
144     function _transfer(address _to, uint _tokens) internal returns (bool success){
145         // prevent transfer to 0x0, use burn instead
146         require(_to != 0x0);
147         require(balances[this] >= _tokens );
148         require(balances[_to] + _tokens >= balances[_to]);
149         balances[this] = balances[this].sub(_tokens);
150         balances[_to] = balances[_to].add(_tokens);
151         emit Transfer(this,_to,_tokens);
152         return true;
153     }
154     
155     // ------------------------------------------------------------------------
156     // Token owner can approve for `spender` to transferFrom(...) `tokens`
157     // from the token owner's account
158     // ------------------------------------------------------------------------
159     function approve(address spender, uint tokens) public returns (bool success){
160         allowed[msg.sender][spender] = tokens;
161         emit Approval(msg.sender,spender,tokens);
162         return true;
163     }
164 
165     // ------------------------------------------------------------------------
166     // Transfer `tokens` from the `from` account to the `to` account
167     // 
168     // The calling account must already have sufficient tokens approve(...)-d
169     // for spending from the `from` account and
170     // - From account must have sufficient balance to transfer
171     // - Spender must have sufficient allowance to transfer
172     // - 0 value transfers are allowed
173     // ------------------------------------------------------------------------
174     function transferFrom(address from, address to, uint tokens) public returns (bool success){
175         require(tokens <= allowed[from][msg.sender]); //check allowance
176         require(balances[from] >= tokens);
177         balances[from] = balances[from].sub(tokens);
178         balances[to] = balances[to].add(tokens);
179         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
180         emit Transfer(from,to,tokens);
181         return true;
182     }
183     // ------------------------------------------------------------------------
184     // Returns the amount of tokens approved by the owner that can be
185     // transferred to the spender's account
186     // ------------------------------------------------------------------------
187     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
188         return allowed[tokenOwner][spender];
189     }
190     
191     function () external payable{
192         buyTokens(msg.sender);
193     }
194     
195     function buyTokens(address _beneficiary) public payable onlyWhileOpen{
196         
197         uint256 weiAmount = msg.value;
198         uint investmentAmount;
199         _preValidatePurchase(_beneficiary, weiAmount);
200 
201         // calculate token amount to be created
202         uint256 tokens = _getTokenAmount(weiAmount);
203         
204         contributors.push(msg.sender);
205         if(investments[msg.sender] != 0 ){
206             investmentAmount = investments[msg.sender] + weiAmount;
207             investments[msg.sender] = investmentAmount;
208         }else{
209             investmentAmount = weiAmount;
210             investments[msg.sender] = weiAmount;
211         }
212         _registerContributors(investmentAmount,msg.sender);
213         if(contributors.length <=5000){
214             bonusPercentage = 100;
215         }
216         else if(contributors.length >5000 && contributors.length <=10000){
217             bonusPercentage = 50;
218         }
219         else if(contributors.length >10000 && contributors.length <=15000){
220             bonusPercentage = 30;
221         }
222         else {
223             bonusPercentage = 15;
224         }
225         
226         uint p = tokens.mul(bonusPercentage.mul(100));
227         p = p.div(10000);
228         tokens = tokens.add(p);
229         
230         // update state
231         weiRaised = weiRaised.add(weiAmount);
232 
233         _processPurchase(_beneficiary, tokens);
234         TokenPurchase(this, _beneficiary, weiAmount, tokens);
235 
236         _forwardFunds();
237     }
238   
239     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
240         require(_beneficiary != address(0x0));
241         require(_weiAmount != 0);
242     }
243   
244     function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {
245         return _weiAmount.mul(rate);
246     }
247   
248     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
249         _transfer(_beneficiary,_tokenAmount);
250     }
251 
252     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
253         _deliverTokens(_beneficiary, _tokenAmount);
254     }
255   
256     function _forwardFunds() internal {
257         owner.transfer(msg.value);
258     }
259     
260     function _registerContributors(uint256 _weiamount, address _sender) internal {
261         
262         for (uint index = 0; index<50; index++){
263             if(_weiamount > investments[contestContributors[index]]){
264                 _lowerDown(index + 1,_sender);
265                 contestContributors[index] = _sender;
266                 index = 50;
267             }
268         }
269     }
270     
271     function distributeContest() public onlyOwner icoClose{
272         uint index =0;
273         while(index!=50){
274             address _beneficiary = contestContributors[index];
275             if(_beneficiary != 0x0){
276               
277                 if(index == 0 ){ //1st top contributor
278                     _transfer(_beneficiary, 300000);
279                 }
280                 else if(index == 1){ //2nd contributor
281                     _transfer(_beneficiary, 200000);
282                 }
283                 else if(index == 2){ //3rd contributor
284                     _transfer(_beneficiary, 100000);
285                 }
286                 else if(index == 3){ //4th contributor
287                     _transfer(_beneficiary, 50000);
288                 }
289                 else if(index == 4){ //5th contributor
290                     _transfer(_beneficiary, 30000);
291                 }
292                 else if(index >= 5 && index <=49){ //6th to 50th contributor
293                     _transfer(_beneficiary, 7000);
294                 }
295             }
296             index++;
297         }
298         
299     }
300     
301     function _lowerDown(uint index,address sender) internal{
302         address newContributor = contestContributors[index-1];
303         address previousContributor;
304         for(uint i=index; i<=49; i++){
305             if(newContributor != sender){
306                 previousContributor = newContributor;
307                 newContributor = contestContributors[i];
308                 contestContributors[i] = previousContributor;
309             }
310             else{
311                 i = 50;
312             }
313         }
314     }
315     
316     function isItOpen() public view returns(string status){
317         if(now > openingTime && now < closingTime){
318             return "SALE OPEN";
319         }
320         else{
321             return "SALE CLOSE";
322         }
323     }
324 }