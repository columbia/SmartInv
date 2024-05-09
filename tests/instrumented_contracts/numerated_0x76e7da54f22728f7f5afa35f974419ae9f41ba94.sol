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
71     // @notice Transfers the ownership of owner
72     // @param newOwner Address of the new owner
73     function transferOwnership( address newOwner )
74         external
75     {
76         require(msg.sender == owner);
77         require(newOwner != address(0));
78         owner = newOwner;
79         OwnerEvents(msg.sender,2);
80     }
81 }
82 
83 contract ERC20Token is owned, SafeMath{
84 
85     // Token Definitions
86     bool public tokenState;
87     string public name = "DropDeck";
88     string public symbol = "DDD";
89     uint256 public decimals = 8;
90     uint256 public totalSupply = 380000000000000000;
91     uint256 public blocktime;
92     address public ico;
93 
94     mapping(address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96 
97     event Transfer(address indexed from, address indexed to, uint256 value);
98     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
99 
100     // @notice Initialize the Token Contract
101     // @param _name Name of Token
102     // @param _code Short Code of the Token
103     // @param _decimals Amount of Decimals for the Token
104     // @param _netSupply TotalSupply of Tokens
105     function init( uint256 _blocktime,address _ico)
106         external
107     returns ( bool ){
108         require(tokenState == false);
109         owned;
110         tokenState = true;
111         balances[msg.sender] = totalSupply;
112         blocktime = _blocktime;
113         ico = _ico;
114         return true;
115     }
116 
117     // @notice Transfers the token
118     // @param _to Address of reciver
119     // @param _value Value to be transfered
120     function transfer(address _to, uint256 _value)
121         public
122     returns ( bool ) {
123         require(tokenState == true);
124         require(_to != address(0));
125         require(_value <= balances[msg.sender]);
126         require(block.number >= blocktime);
127         balances[msg.sender] = sub(balances[msg.sender],_value);
128         balances[_to] = add(balances[_to],_value);
129         Transfer(msg.sender, _to, _value);
130         return true;
131     }
132     // @notice Transfers the token on behalf of
133     // @param _from Address of sender
134     // @param _to Address of reciver
135     // @param _value Value to be transfered
136     function transferFrom(address _from, address _to, uint256 _value)
137         public
138     {
139         require(_to != address(0));
140         require(_value <= balances[_from]);
141         require(_value <= allowed[_from][msg.sender]);
142 
143         balances[_from] = sub(balances[_from],_value);
144         balances[_to] = add(balances[_to],_value);
145         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender],_value);
146         Transfer(_from, _to, _value);
147 
148     }
149 
150     // @notice Transfers the token from owner during the ICO
151     // @param _to Address of reciver
152     // @param _value Value to be transfered
153     function transferICO(address _to, uint256 _value)
154         public
155     returns ( bool ) {
156         require(tokenState == true);
157         require(_to != address(0));
158         require(_value <= balances[owner]);
159         require(ico == msg.sender);
160         balances[owner] = sub(balances[owner],_value);
161         balances[_to] = add(balances[_to],_value);
162         Transfer(msg.sender, _to, _value);
163         return true;
164     }
165 
166     // @notice Checks balance of Address
167     // @param _to Address of token holder
168     function balanceOf(address _owner)
169         external
170         constant
171     returns (uint256) {
172         require(tokenState == true);
173         return balances[_owner];
174     }
175 
176     // @notice Approves allowance for token holder
177     // @param _spender Address of token holder
178     // @param _value Amount of Token Transfer to approve
179     function approve(address _spender, uint256 _value)
180         external
181     returns (bool success) {
182         require(tokenState == true);
183         require(_spender != address(0));
184         require(msg.sender == owner);
185         allowed[msg.sender][_spender] = mul(_value, 100000000);
186         Approval(msg.sender, _spender, _value);
187         return true;
188     }
189 
190     // @notice Fetched Allowance for owner
191     // @param _spender Address of token holder
192     // @param _owner Amount of token owner
193     function allowance(address _owner, address _spender)
194         external
195         constant
196     returns (uint256 remaining) {
197         require(tokenState == true);
198         return allowed[_owner][_spender];
199     }
200 }
201 contract tokenContract is ERC20Token{
202 
203 }
204 
205 contract DDDico is SafeMath {
206 
207     tokenContract token;
208 
209     bool public state;
210 
211     address public wallet;
212     address public tokenAddress;
213     address public owner;
214 
215     uint256 public weiRaised;
216     uint256 public hardCap;
217     uint256 public tokenSale;
218     uint256 public tokenLeft;
219     uint256 public applicableRate;
220     uint256 weiAmount;
221     uint256 tok;
222 
223     uint256 public block0 = 4644650;
224     uint256 public block1 = 4644890;
225     uint256 public block2 = 4650650;
226     uint256 public block3 = 4690970;
227     uint256 public block4 = 4731290;
228     uint256 public block5 = 4771610;
229     uint256 public block6 = 4811930;
230 
231     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
232 
233     // @notice Initializes a ICO Contract
234     // @param _hardCap Specifies hard cap for ICO in wei
235     // @param _wallet Address of the multiSig wallet
236     // @param _token Address of the Token Contract
237     function DDDico( address _wallet, address _token , uint256 _hardCap, uint256 _tokenSale ) {
238         require(_wallet != address(0));
239         state = true;
240         owner = msg.sender;
241         wallet = _wallet;
242         tokenAddress = _token;
243         token = tokenContract(tokenAddress);
244         hardCap = mul(_hardCap,pow(10,16));
245         tokenSale = mul(_tokenSale,pow(10,8));
246         tokenLeft = tokenSale;
247     }
248 
249     // @notice Fallback function to invest in ICO
250     function () payable {
251         buyTokens();
252     }
253 
254     // @notice Buy Token Function to purchase tokens in ICO
255     function buyTokens() public payable {
256         require(validPurchase());
257         weiAmount               = 0;
258         tok                     = 0;
259         weiAmount               = msg.value;
260         tok                     = div(mul(weiAmount,fetchRate()),pow(10,16));
261         weiRaised               = add(weiRaised,weiAmount);
262         tokenLeft               = sub(tokenLeft,tok);
263         token.transferICO(msg.sender,tok);
264         TokenPurchase(msg.sender, msg.sender, weiAmount, tok);
265         forwardFunds();
266     }
267 
268     // @notice Function to forward incomming funds to multi-sig wallet
269     function forwardFunds() internal {
270         wallet.transfer(msg.value);
271     }
272 
273     // @notice Validates the purchase
274     function validPurchase() internal constant returns (bool) {
275         bool withinPeriod = block.number >= block0 && block.number <= block6;
276         bool nonZeroPurchase = msg.value != 0;
277         bool cap = weiRaised <= hardCap;
278         return withinPeriod && nonZeroPurchase && cap;
279     }
280 
281     // @notice Calculates the rate based on slabs
282     function fetchRate() constant returns (uint256){
283         if( block0 <= block.number && block1 > block.number ){
284             applicableRate = 18700000000;
285             return applicableRate;
286         }
287         if ( block1 <= block.number && block2 > block.number ){
288             applicableRate = 16700000000;
289             return applicableRate;
290         }
291         if ( block2 <= block.number && block3 > block.number ){
292             applicableRate = 15000000000;
293             return applicableRate;
294         }
295         if ( block3 <= block.number && block4 > block.number ){
296             applicableRate = 13600000000;
297             return applicableRate;
298         }
299         if ( block4 <= block.number && block5 > block.number ){
300             applicableRate = 12500000000;
301             return applicableRate;
302         }
303         if ( block5 <= block.number && block6 > block.number ){
304             applicableRate = 11500000000;
305             return applicableRate;
306         }
307     }
308 
309     // @notice Checks weather ICO has ended or not
310     function hasEnded() public constant returns (bool)
311     {
312         return block.number > block6;
313     }
314 }