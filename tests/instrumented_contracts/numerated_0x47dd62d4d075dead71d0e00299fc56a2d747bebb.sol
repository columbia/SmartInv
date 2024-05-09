1 pragma solidity ^0.4.18;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply);
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance);
11     /// @notice send `_value` token to `_to` from `msg.sender`
12     /// @param _to The address of the recipient
13     /// @param _value The amount of token to be transferred
14     /// @return Whether the transfer was successful or not
15     function transfer(address _to, uint256 _value) returns (bool success);
16 
17     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
18     /// @param _from The address of the sender
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
23 
24 
25 
26     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of wei to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) returns (bool success);
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39     event Burn(address indexed from, uint256 value);
40     event UpdateToken(address _newtoken);
41     
42     // Function to set balances from new Token
43     function setBalance(address _to,uint256 _value) external ;
44     
45     // Function to set allowed from new Token
46     function setAllowed(address _spender,address _to,uint256 _value) external;
47     
48     // Function to set total supply from new Token.
49     function setTotalSupply(uint256 _value) external;
50     
51     function getDecimals() constant returns (uint256 decimals);
52     
53     function eventTransfer(address _from, address  _to, uint256 _value) external;
54     function eventApproval(address _owner, address  _spender, uint256 _value) external;
55     function eventBurn(address from, uint256 value) external;
56 }
57 
58 contract NewToken{
59     
60     function transfer(address _sender,address _to,uint256 value) returns (bool);
61     function transferFrom(address _sender,address from,address _to,uint256 value) returns (bool);
62     function approve(address _sender,address _spender, uint256 _value) returns (bool success);
63 }
64 
65 library SafeMath {
66   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
67     uint256 c = a * b;
68     assert(a == 0 || c / a == b);
69     return c;
70   }
71 
72   function div(uint256 a, uint256 b) internal constant returns (uint256) {
73     // assert(b > 0); // Solidity automatically throws when dividing by 0
74     uint256 c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76     return c;
77   }
78 
79   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
80     assert(b <= a);
81     return a - b;
82   }
83 
84   function add(uint256 a, uint256 b) internal constant returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 
90   function onePercent(uint256 a) internal constant returns (uint256){
91       return div(a,uint256(100));
92   }
93   
94   function power(uint256 a,uint256 b) internal constant returns (uint256){
95       return mul(a,10**b);
96   }
97 }
98 
99 contract StandardToken is Token {
100     using SafeMath for uint256;
101     address newToken=0x0;
102     
103     mapping (address => uint256) balances;
104     mapping (address => mapping (address => uint256)) allowed;
105     uint256 public _totalSupply=0;
106     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
107     // there is 3 level. 1 - inbound tx, 2 - outbount tx, 3 - all tx;
108     mapping(uint8 =>mapping(address=>bool)) internal whitelist;
109     mapping(address=>uint8) internal whitelistModerator;
110     
111     uint256 public maxFee;
112     uint256 public feePercantage;
113     address public _owner;
114     
115     modifier onlyOwner {
116         require(msg.sender == _owner);
117         _;
118     }
119 
120     modifier canModifyWhitelistIn {
121         require(whitelistModerator[msg.sender]==1 || whitelistModerator[msg.sender]==3);
122         _;
123     }
124     
125     modifier canModifyWhitelistOut {
126         require(whitelistModerator[msg.sender]==2 || whitelistModerator[msg.sender]==3);
127         _;
128     }
129     
130     modifier canModifyWhitelist {
131         require(whitelistModerator[msg.sender]==3);
132         _;
133     }
134     
135     modifier onlyNewToken {
136         require(msg.sender==newToken);
137         _;
138     }
139     
140     function transfer(address _to, uint256 _value) returns (bool success) {
141         if(newToken!=0x0){
142             return NewToken(newToken).transfer(msg.sender,_to,_value);
143         }
144         uint256 fee=getFee(_value);
145         uint256 valueWithFee=_value;
146          if(withFee(msg.sender,_to)){
147             valueWithFee=valueWithFee.add(fee);
148         }
149         if (balances[msg.sender] >= valueWithFee && _value > 0) {
150             //Do Transfer
151             doTransfer(msg.sender,_to,_value,fee);
152             return true;
153         }  else { return false; }
154     }
155     
156     function withFee(address _from,address _to) private returns(bool){
157         return !whitelist[2][_from] && !whitelist[1][_to] && !whitelist[3][_to] && !whitelist[3][_from];
158     }
159     
160     function getFee(uint256 _value) private returns (uint256){
161         uint256 feeOfValue=_value.onePercent().mul(feePercantage);
162         uint256 fee=uint256(maxFee).power(decimals);
163          // Check if 1% burn fee exceeds maxfee
164         // If so then hard cap for burn fee is maxfee
165         if (feeOfValue>= fee) {
166             return fee;
167         // If 1% burn fee is less than maxfee
168         // then use 1% burn fee
169         } 
170         if (feeOfValue < fee) {
171             return feeOfValue;
172         }
173     }
174     function doTransfer(address _from,address _to,uint256 _value,uint256 fee) internal {
175             balances[_from] =balances[_from].sub(_value);
176             balances[_to] = balances[_to].add(_value);
177             Transfer(_from, _to, _value);
178             if(withFee(_from,_to)) {
179                 doBurn(_from,fee);
180             }
181     }
182     
183     function doBurn(address _from,uint256 _value) private returns (bool success){
184         require(balanceOf(_from) >= _value);   // Check if the sender has enough
185         balances[_from] =balances[_from].sub(_value);            // Subtract from the sender
186         _totalSupply =_totalSupply.sub(_value);                      // Updates totalSupply
187         Burn(_from, _value);
188         return true;
189     }
190     
191     function burn(address _from,uint256 _value) onlyOwner public returns (bool success) {
192         return doBurn(_from,_value);
193     }
194 
195     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
196         //same as above. Replace this line with the following if you want to protect against wrapping uints.
197         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
198         if(newToken!=0x0){
199             return NewToken(newToken).transferFrom(msg.sender,_from,_to,_value);
200         }
201         uint256 fee=getFee(_value);
202         uint256 valueWithFee=_value;
203         if(withFee(_from,_to)){
204             valueWithFee=valueWithFee.add(fee);
205         }
206         if (balances[_from] >= valueWithFee && 
207             (allowed[_from][msg.sender] >= valueWithFee || allowed[_from][msg.sender] == _value) &&
208             _value > 0 ) {
209             doTransfer(_from,_to,_value,fee);
210             if(allowed[_from][msg.sender] == _value){
211                 allowed[_from][msg.sender] =allowed[_from][msg.sender].sub(_value);
212             }
213             else{
214                 allowed[_from][msg.sender] =allowed[_from][msg.sender].sub(valueWithFee);
215             }
216             return true;
217         } else { return false; }
218     }
219 
220     function balanceOf(address _owner) constant returns (uint256 balance) {
221         return balances[_owner];
222     }
223 
224     function approve(address _spender, uint256 _value) returns (bool success) {
225         if(newToken!=0x0){
226             return NewToken(newToken).approve(msg.sender,_spender,_value);
227         }
228         uint256 valueWithFee=_value;
229         if(withFee(_spender,0x0)){
230             uint256 fee=getFee(_value);  
231             valueWithFee=valueWithFee.add(fee);
232         }
233         allowed[msg.sender][_spender] = valueWithFee;
234         Approval(msg.sender, _spender, valueWithFee);
235         return true;
236     }
237 
238     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
239       return allowed[_owner][_spender];
240     }
241     
242     function totalSupply() constant returns (uint totalSupply){
243         return _totalSupply;
244     }
245     
246     function setTotalSupply(uint256 _value) onlyNewToken external {
247         _totalSupply=_value;
248     }
249     
250     function setBalance(address _to,uint256 _value) onlyNewToken external {
251         balances[_to]=_value;
252     }
253     
254     function setAllowed(address _spender,address _to,uint256 _value) onlyNewToken external {
255         allowed[_to][_spender]=_value;
256     }
257     function getDecimals() constant returns (uint256 decimals){
258         return decimals;
259     }
260     
261     function eventTransfer(address _from, address  _to, uint256 _value) onlyNewToken external{
262         Transfer(_from,_to,_value);
263     }
264     
265     function eventApproval(address _owner, address  _spender, uint256 _value)onlyNewToken external{
266         Approval(_owner,_spender,_value);
267     }
268     function eventBurn(address from, uint256 value)onlyNewToken external{
269         Burn(from,value);
270     }
271 }
272 
273 
274 contract EqualToken is StandardToken {
275 
276     function () {
277         //if ether is sent to this address, send it back.
278         revert();
279     }
280 
281     /* Public variables of the token */
282     
283     /*
284     NOTE:
285     The following variables are OPTIONAL vanities. One does not have to include them.
286     They allow one to customise the token contract & in no way influences the core functionality.
287     Some wallets/interfaces might not even bother to look at this information.
288     */
289     string public name;                   //fancy name: eg Simon Bucks
290     string public symbol;                 //An identifier: eg SBX
291     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
292     address public oldToken=0x0;    
293     // Fee info
294     string public feeInfo = "Each operation costs 1% of the transaction amount, but not more than 250 tokens.";
295 
296     function EqualToken() {
297         _owner=msg.sender;
298         whitelistModerator[msg.sender]=3;
299         whitelist[3][msg.sender]=true;
300         
301         
302         maxFee=250; // max fee for transfer
303         feePercantage=1; // fee in percents
304         
305         name = "EQUAL";                      // Set the name for display purposes
306         decimals = 18;                            // Amount of decimals for display purposes
307         symbol = "EQL";                          // Set the symbol for display purposes
308     }
309 
310     function setOldToken(address _oldToken) onlyOwner public{
311         require(oldToken==0x0);
312         oldToken=_oldToken;
313         Token token=Token(_oldToken);
314         _totalSupply=token.totalSupply();
315         balances[msg.sender] =_totalSupply;
316         Transfer(0x0,msg.sender,_totalSupply);
317     }
318     
319     // Redistibute new token with same balances;
320     function redistribute(address[] holders) onlyOwner public{
321         require(oldToken!=0x0);
322         Token token=Token(oldToken);
323         for(uint256 i=0;i<holders.length;++i){
324             address _to=holders[i];
325             if(balances[_to]==0){
326                 uint256 balance=token.balanceOf(_to);
327                 balances[_to]=balance;
328                 balances[msg.sender]=balances[msg.sender].sub(balance);
329                 Transfer(msg.sender,_to,balance);
330             }
331         }
332     }
333     
334     function allocate(address _address,uint256 percent) private{
335         uint256 bal=_totalSupply.onePercent().mul(percent);
336         //balances[_address]=bal;
337         whitelist[3][_address]=true;
338         doTransfer(msg.sender,_address,bal,0);
339     }
340    
341     // Set address access to inbound whitelist. 
342     function setWhitelistIn(address _address,bool _value) canModifyWhitelistIn public{
343         setWhitelistValue(_address,_value,1);
344     }
345     
346     // Set address access to outbound whitelist. 
347     function setWhitelistOut(address _address,bool _value) canModifyWhitelistOut public{
348         setWhitelistValue(_address,_value,2);
349     }
350     
351     // Set address access to inbound and outbound whitelist. 
352     function setWhitelist(address _address,bool _value) canModifyWhitelist public{
353         setWhitelistValue(_address,_value,3);
354     }
355     
356     function setWhitelistValue(address _address,bool _withoutFee,uint8 _type) internal {
357         whitelist[_type][_address]=_withoutFee;
358     }
359     
360     // Set address of moderator whitelist
361     // _level can be: 0 -not moderator, 1 -inbound,2 - outbound, 3 -all
362     function setWhitelistModerator(address _address,uint8 _level) onlyOwner public {
363         whitelistModerator[_address]=_level;
364     }
365     
366     //Set max fee value
367     function setMaxFee(uint256 newFee) onlyOwner public {
368         maxFee=newFee;
369     }
370     
371     //Set fee percent value
372     function setFeePercent(uint256 newFee) onlyOwner public {
373         feePercantage=newFee;
374     }
375     
376     //Set fee info
377     function setFeeInfo(string newFeeInfo) onlyOwner public {
378        feeInfo=newFeeInfo;
379     }
380     
381     function setNewToken(address _newtoken) onlyOwner public{
382         newToken=_newtoken;
383         UpdateToken(_newtoken);
384     }
385     
386     /* Approves and then calls the receiving contract */
387     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
388         if(!approve(_spender,_value)){
389             return false;
390         }
391         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
392         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
393         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
394         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
395         return true;
396     }
397 }