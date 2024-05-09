1 pragma solidity ^0.4.11;
2 
3 // @title ICO Simple Contract
4 // @author Harsh Patel
5 
6 contract SafeMath {
7 
8     // @notice SafeMath multiply function
9     // @param a Variable 1
10     // @param b Variable 2
11     // @result { "" : "result of safe multiply"}
12     function mul(uint256 a, uint256 b) internal  returns (uint256) {
13         uint256 c = a * b;
14         assert(a == 0 || c / a == b);
15         return c;
16     }
17 
18     // @notice SafeMath divide function
19     // @param a Variable 1
20     // @param b Variable 2
21     // @result { "" : "result of safe multiply"}
22     function div(uint256 a, uint256 b) internal  returns (uint256) {
23         assert(b > 0);
24         uint256 c = a / b;
25         return c;
26     }
27 
28     // @notice SafeMath substract function
29     // @param a Variable 1
30     // @param b Variable 2
31     function sub(uint256 a, uint256 b) internal   returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     // @notice SafeMath addition function
37     // @param a Variable 1
38     // @param b Variable 2
39     function add(uint256 a, uint256 b) internal  returns (uint256) {
40         uint256 c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 
45     // @notice SafeMath Power function
46     // @param a Variable 1
47     // @param b Variable 2
48     function pow( uint256 a , uint8 b ) internal returns ( uint256 ){
49         uint256 c;
50         c = a ** b;
51         return c;
52     }
53 }
54 
55 contract owned {
56 
57     bool public OwnerDefined = false;
58     address public owner;
59     event OwnerEvents(address _addr, uint8 action);
60 
61     // @notice Initializes Owner Contract and set the first Owner
62     function owned()
63         internal
64     {
65         require(OwnerDefined == false);
66         owner = msg.sender;
67         OwnerDefined = true;
68         OwnerEvents(msg.sender,1);
69     }
70 
71 }
72 
73 contract ERC20Token is owned, SafeMath{
74 
75     // Token Definitions
76     bool public tokenState;
77     string public name = "DropDeck";
78     string public symbol = "DDD";
79     uint256 public decimals = 8;
80     uint256 public totalSupply = 380000000000000000;
81     address public ico;
82     bool public blockState = true;
83 
84     mapping(address => uint256) balances;
85     mapping(address => bool) public userBanned;
86     mapping (address => mapping (address => uint256)) allowed;
87 
88     event Transfer(address indexed from, address indexed to, uint256 value);
89     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90 
91     // @notice Initialize the Token Contract
92     // @param _name Name of Token
93     // @param _code Short Code of the Token
94     // @param _decimals Amount of Decimals for the Token
95     // @param _netSupply TotalSupply of Tokens
96     function init()
97         external
98     returns ( bool ){
99         require(tokenState == false);
100         owned;
101         tokenState = true;
102         balances[this] = totalSupply;
103         allowed[this][owner] = totalSupply;
104         return true;
105     }
106 
107     // @notice Transfers the token
108     // @param _to Address of reciver
109     // @param _value Value to be transfered
110     function transfer(address _to, uint256 _value)
111         public
112     returns ( bool ) {
113         require(tokenState == true);
114         require(_to != address(0));
115         require(_value <= balances[msg.sender]);
116         require(blockState == false);
117         require(userBanned[msg.sender] == false);
118         balances[msg.sender] = sub(balances[msg.sender],_value);
119         balances[_to] = add(balances[_to],_value);
120         Transfer(msg.sender, _to, _value);
121         return true;
122     }
123     // @notice Transfers the token on behalf of
124     // @param _from Address of sender
125     // @param _to Address of reciver
126     // @param _value Value to be transfered
127     function transferFrom(address _from, address _to, uint256 _value)
128         public
129     {
130         require(_to != address(0));
131         require(_value <= balances[_from]);
132         require(_value <= allowed[_from][msg.sender]);
133 
134         balances[_from] = sub(balances[_from],_value);
135         balances[_to] = add(balances[_to],_value);
136         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender],_value);
137         Transfer(_from, _to, _value);
138 
139     }
140 
141     // @notice Transfers the token from owner during the ICO
142     // @param _to Address of reciver
143     // @param _value Value to be transfered
144     function transferICO(address _to, uint256 _value)
145         public
146     returns ( bool ) {
147         require(tokenState == true);
148         require(_to != address(0));
149         require(_value <= balances[this]);
150         require(ico == msg.sender);
151         balances[this] = sub(balances[this],_value);
152         balances[_to] = add(balances[_to],_value);
153         Transfer(this, _to, _value);
154         return true;
155     }
156 
157     // @notice Checks balance of Address
158     // @param _to Address of token holder
159     function balanceOf(address _owner)
160         external
161         constant
162     returns (uint256) {
163         require(tokenState == true);
164         return balances[_owner];
165     }
166 
167     // @notice Approves allowance for token holder
168     // @param _spender Address of token holder
169     // @param _value Amount of Token Transfer to approve
170     function approve(address _spender, uint256 _value)
171         external
172     returns (bool success) {
173         require(tokenState == true);
174         require(_spender != address(0));
175         require(msg.sender == owner);
176         allowed[msg.sender][_spender] = mul(_value, 100000000);
177         Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     // @notice Fetched Allowance for owner
182     // @param _spender Address of token holder
183     // @param _owner Amount of token owner
184     function allowance(address _owner, address _spender)
185         external
186         constant
187     returns (uint256 remaining) {
188         require(tokenState == true);
189         return allowed[_owner][_spender];
190     }
191 
192     // @notice Allows enabling of blocking of transfer for all users
193     function blockTokens()
194         external
195     returns (bool) {
196         require(tokenState == true);
197         require(msg.sender == owner);
198         blockState = true;
199         return true;
200     }
201 
202     // @notice Allows enabling of unblocking of transfer for all users
203     function unblockTokens()
204         external
205     returns (bool) {
206         require(tokenState == true);
207         require(msg.sender == owner);
208         blockState = false;
209         return true;
210     }
211 
212     // @notice Bans an Address
213     function banAddress(address _addr)
214         external
215     returns (bool) {
216         require(tokenState == true);
217         require(msg.sender == owner);
218         userBanned[_addr] = true;
219         return true;
220     }
221 
222     // @notice Un-Bans an Address
223     function unbanAddress(address _addr)
224         external
225     returns (bool) {
226         require(tokenState == true);
227         require(msg.sender == owner);
228         userBanned[_addr] = false;
229         return true;
230     }
231 
232     function setICO(address _ico)
233         external
234     returns (bool) {
235         require(tokenState == true);
236         require(msg.sender == owner);
237         ico = _ico;
238         return true;
239     }
240 
241     // @notice Transfers the ownership of owner
242     // @param newOwner Address of the new owner
243     function transferOwnership( address newOwner )
244         external
245     {
246         require(msg.sender == owner);
247         require(newOwner != address(0));
248 
249         allowed[this][owner] =  0;
250         owner = newOwner;
251         allowed[this][owner] =  balances[this];
252         OwnerEvents(msg.sender,2);
253     }
254 
255 
256 }
257 contract tokenContract is ERC20Token{
258 
259 }
260 
261 contract DDDico is SafeMath {
262 
263     tokenContract token;
264 
265     bool public state;
266 
267     address public wallet;
268     address public tokenAddress;
269     address public owner;
270 
271     uint256 public weiRaised;
272     uint256 public hardCap;
273     uint256 public tokenSale;
274     uint256 public tokenLeft;
275     uint256 public applicableRate;
276     uint256 weiAmount;
277     uint256 tok;
278 
279     uint256 public block0 = 4594000;
280     uint256 public block1 = 4594240;
281     uint256 public block2 = 4600000;
282     uint256 public block3 = 4640320;
283     uint256 public block4 = 4680640;
284     uint256 public block5 = 4720960;
285     uint256 public block6 = 4761280;
286 
287     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
288 
289     // @notice Initializes a ICO Contract
290     // @param _hardCap Specifies hard cap for ICO in wei
291     // @param _wallet Address of the multiSig wallet
292     // @param _token Address of the Token Contract
293     function DDDico( address _wallet, address _token , uint256 _hardCap, uint256 _tokenSale ) {
294         require(_wallet != address(0));
295         state = true;
296         owner = msg.sender;
297         wallet = _wallet;
298         tokenAddress = _token;
299         token = tokenContract(tokenAddress);
300         hardCap = mul(_hardCap,pow(10,16));
301         tokenSale = mul(_tokenSale,pow(10,8));
302         tokenLeft = tokenSale;
303     }
304 
305     // @notice Fallback function to invest in ICO
306     function () payable {
307         buyTokens();
308     }
309 
310     // @notice Buy Token Function to purchase tokens in ICO
311     function buyTokens() public payable {
312         require(validPurchase());
313         weiAmount               = 0;
314         tok                     = 0;
315         weiAmount               = msg.value;
316         tok                     = div(mul(weiAmount,fetchRate()),pow(10,16));
317         weiRaised               = add(weiRaised,weiAmount);
318         tokenLeft               = sub(tokenLeft,tok);
319         token.transferICO(msg.sender,tok);
320         TokenPurchase(msg.sender, msg.sender, weiAmount, tok);
321         forwardFunds();
322     }
323 
324     // @notice Function to forward incomming funds to multi-sig wallet
325     function forwardFunds() internal {
326         wallet.transfer(msg.value);
327     }
328 
329     // @notice Validates the purchase
330     function validPurchase() internal constant returns (bool) {
331         bool withinPeriod = block.number >= block0 && block.number <= block6;
332         bool nonZeroPurchase = msg.value != 0;
333         bool cap = weiRaised <= hardCap;
334         return withinPeriod && nonZeroPurchase && cap;
335     }
336 
337     // @notice Calculates the rate based on slabs
338     function fetchRate() constant returns (uint256){
339         if( block0 <= block.number && block1 > block.number ){
340             applicableRate = 1500000000000;
341             return applicableRate;
342         }
343         if ( block1 <= block.number && block2 > block.number ){
344             applicableRate = 1400000000000;
345             return applicableRate;
346         }
347         if ( block2 <= block.number && block3 > block.number ){
348             applicableRate = 1300000000000;
349             return applicableRate;
350         }
351         if ( block3 <= block.number && block4 > block.number ){
352             applicableRate = 1200000000000;
353             return applicableRate;
354         }
355         if ( block4 <= block.number && block5 > block.number ){
356             applicableRate = 1100000000000;
357             return applicableRate;
358         }
359         if ( block5 <= block.number && block6 > block.number ){
360             applicableRate = 1000000000000;
361             return applicableRate;
362         }
363     }
364 
365     // @notice Checks weather ICO has ended or not
366     function hasEnded() public constant returns (bool)
367     {
368         return block.number > block6;
369     }
370 }