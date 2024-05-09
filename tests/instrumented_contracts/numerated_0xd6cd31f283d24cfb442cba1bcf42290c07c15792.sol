1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ContributorApprover {
30     KyberContributorWhitelist public list;
31     mapping(address=>uint)    public participated;
32 
33     uint                      public cappedSaleStartTime;
34     uint                      public openSaleStartTime;
35     uint                      public openSaleEndTime;
36 
37     using SafeMath for uint;
38 
39 
40     function ContributorApprover( KyberContributorWhitelist _whitelistContract,
41                                   uint                      _cappedSaleStartTime,
42                                   uint                      _openSaleStartTime,
43                                   uint                      _openSaleEndTime ) {
44         list = _whitelistContract;
45         cappedSaleStartTime = _cappedSaleStartTime;
46         openSaleStartTime = _openSaleStartTime;
47         openSaleEndTime = _openSaleEndTime;
48 
49         require( list != KyberContributorWhitelist(0x0) );
50         require( cappedSaleStartTime < openSaleStartTime );
51         require(  openSaleStartTime < openSaleEndTime );
52     }
53 
54     // this is a seperate function so user could query it before crowdsale starts
55     function contributorCap( address contributor ) constant returns(uint) {
56         return list.getCap( contributor );
57     }
58 
59     function eligible( address contributor, uint amountInWei ) constant returns(uint) {
60         if( now < cappedSaleStartTime ) return 0;
61         if( now >= openSaleEndTime ) return 0;
62 
63         uint cap = contributorCap( contributor );
64 
65         if( cap == 0 ) return 0;
66         if( now < openSaleStartTime ) {
67             uint remainedCap = cap.sub( participated[ contributor ] );
68 
69             if( remainedCap > amountInWei ) return amountInWei;
70             else return remainedCap;
71         }
72         else {
73             return amountInWei;
74         }
75     }
76 
77     function eligibleTestAndIncrement( address contributor, uint amountInWei ) internal returns(uint) {
78         uint result = eligible( contributor, amountInWei );
79         participated[contributor] = participated[contributor].add( result );
80 
81         return result;
82     }
83 
84     function saleEnded() constant returns(bool) {
85         return now > openSaleEndTime;
86     }
87 
88     function saleStarted() constant returns(bool) {
89         return now >= cappedSaleStartTime;
90     }
91 }
92 
93 contract KyberNetworkTokenSale is ContributorApprover {
94     address             public admin;
95     address             public kyberMultiSigWallet;
96     KyberNetworkCrystal public token;
97     uint                public raisedWei;
98     bool                public haltSale;
99 
100     mapping(bytes32=>uint) public proxyPurchases;
101 
102     function KyberNetworkTokenSale( address _admin,
103                                     address _kyberMultiSigWallet,
104                                     KyberContributorWhitelist _whilteListContract,
105                                     uint _totalTokenSupply,
106                                     uint _premintedTokenSupply,
107                                     uint _cappedSaleStartTime,
108                                     uint _publicSaleStartTime,
109                                     uint _publicSaleEndTime )
110 
111         ContributorApprover( _whilteListContract,
112                              _cappedSaleStartTime,
113                              _publicSaleStartTime,
114                              _publicSaleEndTime )
115     {
116         admin = _admin;
117         kyberMultiSigWallet = _kyberMultiSigWallet;
118 
119         token = new KyberNetworkCrystal( _totalTokenSupply,
120                                          _cappedSaleStartTime,
121                                          _publicSaleEndTime + 7 days,
122                                          _admin );
123 
124         // transfer preminted tokens to company wallet
125         token.transfer( kyberMultiSigWallet, _premintedTokenSupply );
126     }
127 
128     function setHaltSale( bool halt ) {
129         require( msg.sender == admin );
130         haltSale = halt;
131     }
132 
133     function() payable {
134         buy( msg.sender );
135     }
136 
137     event ProxyBuy( bytes32 indexed _proxy, address _recipient, uint _amountInWei );
138     function proxyBuy( bytes32 proxy, address recipient ) payable returns(uint){
139         uint amount = buy( recipient );
140         proxyPurchases[proxy] = proxyPurchases[proxy].add(amount);
141         ProxyBuy( proxy, recipient, amount );
142 
143         return amount;
144     }
145 
146     event Buy( address _buyer, uint _tokens, uint _payedWei );
147     function buy( address recipient ) payable returns(uint){
148         require( tx.gasprice <= 50000000000 wei );
149 
150         require( ! haltSale );
151         require( saleStarted() );
152         require( ! saleEnded() );
153 
154         uint weiPayment = eligibleTestAndIncrement( recipient, msg.value );
155 
156         require( weiPayment > 0 );
157 
158         // send to msg.sender, not to recipient
159         if( msg.value > weiPayment ) {
160             msg.sender.transfer( msg.value.sub( weiPayment ) );
161         }
162 
163         // send payment to wallet
164         sendETHToMultiSig( weiPayment );
165         raisedWei = raisedWei.add( weiPayment );
166         uint recievedTokens = weiPayment.mul( 600 );
167 
168         assert( token.transfer( recipient, recievedTokens ) );
169 
170 
171         Buy( recipient, recievedTokens, weiPayment );
172 
173         return weiPayment;
174     }
175 
176     function sendETHToMultiSig( uint value ) internal {
177         kyberMultiSigWallet.transfer( value );
178     }
179 
180     event FinalizeSale();
181     // function is callable by everyone
182     function finalizeSale() {
183         require( saleEnded() );
184         require( msg.sender == admin );
185 
186         // burn remaining tokens
187         token.burn(token.balanceOf(this));
188 
189         FinalizeSale();
190     }
191 
192     // ETH balance is always expected to be 0.
193     // but in case something went wrong, we use this function to extract the eth.
194     function emergencyDrain(ERC20 anyToken) returns(bool){
195         require( msg.sender == admin );
196         require( saleEnded() );
197 
198         if( this.balance > 0 ) {
199             sendETHToMultiSig( this.balance );
200         }
201 
202         if( anyToken != address(0x0) ) {
203             assert( anyToken.transfer(kyberMultiSigWallet, anyToken.balanceOf(this)) );
204         }
205 
206         return true;
207     }
208 
209     // just to check that funds goes to the right place
210     // tokens are not given in return
211     function debugBuy() payable {
212         require( msg.value == 123 );
213         sendETHToMultiSig( msg.value );
214     }
215 }
216 
217 contract Ownable {
218   address public owner;
219 
220 
221   /**
222    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
223    * account.
224    */
225   function Ownable() {
226     owner = msg.sender;
227   }
228 
229 
230   /**
231    * @dev Throws if called by any account other than the owner.
232    */
233   modifier onlyOwner() {
234     require(msg.sender == owner);
235     _;
236   }
237 
238 
239   /**
240    * @dev Allows the current owner to transfer control of the contract to a newOwner.
241    * @param newOwner The address to transfer ownership to.
242    */
243   function transferOwnership(address newOwner) onlyOwner {
244     if (newOwner != address(0)) {
245       owner = newOwner;
246     }
247   }
248 
249 }
250 
251 contract KyberContributorWhitelist is Ownable {
252     // cap is in wei. The value of 7 is just a stub.
253     // after kyc registration ends, we change it to the actual value with setSlackUsersCap
254     uint public slackUsersCap = 7;
255     mapping(address=>uint) public addressCap;
256 
257     function KyberContributorWhitelist() {}
258 
259     event ListAddress( address _user, uint _cap, uint _time );
260 
261     // Owner can delist by setting cap = 0.
262     // Onwer can also change it at any time
263     function listAddress( address _user, uint _cap ) onlyOwner {
264         addressCap[_user] = _cap;
265         ListAddress( _user, _cap, now );
266     }
267 
268     // an optimization in case of network congestion
269     function listAddresses( address[] _users, uint[] _cap ) onlyOwner {
270         require(_users.length == _cap.length );
271         for( uint i = 0 ; i < _users.length ; i++ ) {
272             listAddress( _users[i], _cap[i] );
273         }
274     }
275 
276     function setSlackUsersCap( uint _cap ) onlyOwner {
277         slackUsersCap = _cap;
278     }
279 
280     function getCap( address _user ) constant returns(uint) {
281         uint cap = addressCap[_user];
282 
283         if( cap == 1 ) return slackUsersCap;
284         else return cap;
285     }
286 
287     function destroy() onlyOwner {
288         selfdestruct(owner);
289     }
290 }
291 
292 contract ERC20Basic {
293   uint256 public totalSupply;
294   function balanceOf(address who) constant returns (uint256);
295   function transfer(address to, uint256 value) returns (bool);
296   
297   // KYBER-NOTE! code changed to comply with ERC20 standard
298   event Transfer(address indexed _from, address indexed _to, uint _value);
299   //event Transfer(address indexed from, address indexed to, uint256 value);
300 }
301 
302 contract BasicToken is ERC20Basic {
303   using SafeMath for uint256;
304 
305   mapping(address => uint256) balances;
306 
307   /**
308   * @dev transfer token for a specified address
309   * @param _to The address to transfer to.
310   * @param _value The amount to be transferred.
311   */
312   function transfer(address _to, uint256 _value) returns (bool) {
313     balances[msg.sender] = balances[msg.sender].sub(_value);
314     balances[_to] = balances[_to].add(_value);
315     Transfer(msg.sender, _to, _value);
316     return true;
317   }
318 
319   /**
320   * @dev Gets the balance of the specified address.
321   * @param _owner The address to query the the balance of. 
322   * @return An uint256 representing the amount owned by the passed address.
323   */
324   function balanceOf(address _owner) constant returns (uint256 balance) {
325     return balances[_owner];
326   }
327 
328 }
329 
330 contract ERC20 is ERC20Basic {
331   function allowance(address owner, address spender) constant returns (uint256);
332   function transferFrom(address from, address to, uint256 value) returns (bool);
333   function approve(address spender, uint256 value) returns (bool);
334   
335   // KYBER-NOTE! code changed to comply with ERC20 standard
336   event Approval(address indexed _owner, address indexed _spender, uint _value);
337   //event Approval(address indexed owner, address indexed spender, uint256 value);
338 }
339 
340 contract StandardToken is ERC20, BasicToken {
341 
342   mapping (address => mapping (address => uint256)) allowed;
343 
344 
345   /**
346    * @dev Transfer tokens from one address to another
347    * @param _from address The address which you want to send tokens from
348    * @param _to address The address which you want to transfer to
349    * @param _value uint256 the amout of tokens to be transfered
350    */
351   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
352     var _allowance = allowed[_from][msg.sender];
353 
354     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
355     // require (_value <= _allowance);
356 
357     // KYBER-NOTE! code changed to comply with ERC20 standard
358     balances[_from] = balances[_from].sub(_value);
359     balances[_to] = balances[_to].add(_value);
360     //balances[_from] = balances[_from].sub(_value); // this was removed
361     allowed[_from][msg.sender] = _allowance.sub(_value);
362     Transfer(_from, _to, _value);
363     return true;
364   }
365 
366   /**
367    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
368    * @param _spender The address which will spend the funds.
369    * @param _value The amount of tokens to be spent.
370    */
371   function approve(address _spender, uint256 _value) returns (bool) {
372 
373     // To change the approve amount you first have to reduce the addresses`
374     //  allowance to zero by calling `approve(_spender, 0)` if it is not
375     //  already 0 to mitigate the race condition described here:
376     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
377     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
378 
379     allowed[msg.sender][_spender] = _value;
380     Approval(msg.sender, _spender, _value);
381     return true;
382   }
383 
384   /**
385    * @dev Function to check the amount of tokens that an owner allowed to a spender.
386    * @param _owner address The address which owns the funds.
387    * @param _spender address The address which will spend the funds.
388    * @return A uint256 specifing the amount of tokens still avaible for the spender.
389    */
390   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
391     return allowed[_owner][_spender];
392   }
393 
394 }
395 
396 contract KyberNetworkCrystal is StandardToken, Ownable {
397     string  public  constant name = "Kyber Network Crystal";
398     string  public  constant symbol = "KNC";
399     uint    public  constant decimals = 18;
400 
401     uint    public  saleStartTime;
402     uint    public  saleEndTime;
403 
404     address public  tokenSaleContract;
405 
406     modifier onlyWhenTransferEnabled() {
407         if( now <= saleEndTime && now >= saleStartTime ) {
408             require( msg.sender == tokenSaleContract );
409         }
410         _;
411     }
412 
413     modifier validDestination( address to ) {
414         require(to != address(0x0));
415         require(to != address(this) );
416         _;
417     }
418 
419     function KyberNetworkCrystal( uint tokenTotalAmount, uint startTime, uint endTime, address admin ) {
420         // Mint all tokens. Then disable minting forever.
421         balances[msg.sender] = tokenTotalAmount;
422         totalSupply = tokenTotalAmount;
423         Transfer(address(0x0), msg.sender, tokenTotalAmount);
424 
425         saleStartTime = startTime;
426         saleEndTime = endTime;
427 
428         tokenSaleContract = msg.sender;
429         transferOwnership(admin); // admin could drain tokens that were sent here by mistake
430     }
431 
432     function transfer(address _to, uint _value)
433         onlyWhenTransferEnabled
434         validDestination(_to)
435         returns (bool) {
436         return super.transfer(_to, _value);
437     }
438 
439     function transferFrom(address _from, address _to, uint _value)
440         onlyWhenTransferEnabled
441         validDestination(_to)
442         returns (bool) {
443         return super.transferFrom(_from, _to, _value);
444     }
445 
446     event Burn(address indexed _burner, uint _value);
447 
448     function burn(uint _value) onlyWhenTransferEnabled
449         returns (bool){
450         balances[msg.sender] = balances[msg.sender].sub(_value);
451         totalSupply = totalSupply.sub(_value);
452         Burn(msg.sender, _value);
453         Transfer(msg.sender, address(0x0), _value);
454         return true;
455     }
456 
457     // save some gas by making only one contract call
458     function burnFrom(address _from, uint256 _value) onlyWhenTransferEnabled
459         returns (bool) {
460         assert( transferFrom( _from, msg.sender, _value ) );
461         return burn(_value);
462     }
463 
464     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
465         token.transfer( owner, amount );
466     }
467 }