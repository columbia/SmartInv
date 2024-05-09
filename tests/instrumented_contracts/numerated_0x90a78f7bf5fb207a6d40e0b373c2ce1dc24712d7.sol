1 pragma solidity ^0.4.19;
2 /*standart library for uint
3 */
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0 || b == 0){
7         return 0;
8     }
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /*
34 contract to identify owner
35 */
36 contract Ownable {
37 
38   address public owner;
39 
40   address public newOwner;
41 
42   address public techSupport;
43 
44   address public newTechSupport;
45 
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   modifier onlyTechSupport() {
52     require(msg.sender == techSupport);
53     _;
54   }
55 
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   function transferOwnership(address _newOwner) public onlyOwner {
61     require(_newOwner != address(0));
62     newOwner = _newOwner;
63   }
64 
65   function acceptOwnership() public {
66     if (msg.sender == newOwner) {
67       owner = newOwner;
68     }
69   }
70 
71   function transferTechSupport (address _newSupport) public{
72     require (msg.sender == owner || msg.sender == techSupport);
73     newTechSupport = _newSupport;
74   }
75 
76   function acceptSupport() public{
77     if(msg.sender == newTechSupport){
78       techSupport = newTechSupport;
79     }
80   }
81 }
82 
83 /*
84 ERC - 20 token contract
85 */
86 contract VGCToken is Ownable {
87   using SafeMath for uint;
88   // Triggered when tokens are transferred.
89   event Transfer(address indexed _from, address indexed _to, uint256 _value);
90 
91   // Triggered whenever approve(address _spender, uint256 _value) is called.
92   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 
94   string public constant symbol = "VGC";
95   string public constant name = "VooGlueC";
96   uint8 public constant decimals = 2;
97   uint256 _totalSupply = 55000000*pow(10,decimals);
98 
99   // Owner of this contract
100   address public owner;
101 
102   // Balances for each account
103   mapping(address => uint256) balances;
104 
105   // Owner of account approves the transfer of an amount to another account
106   mapping(address => mapping (address => uint256)) allowed;
107 
108   // power function
109   function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function
110     return (a**b);
111   }
112 
113   /*
114   standart ERC-20 function
115   get total supply of ERC-20 Tokens
116   */
117   function totalSupply() public view returns (uint256) {
118     return _totalSupply;
119   }
120 
121   /*
122   standart ERC-20 function
123   get ERC-20 token balance from _address
124   */
125 
126   function balanceOf(address _address) public constant returns (uint256 balance) {
127     return balances[_address];
128   }
129 
130   /*
131   //standart ERC-20 function
132   transfer token from message sender to _to
133   */
134   function transfer(address _to, uint256 _amount) public returns (bool success) {
135     //you can't transfer token back to token contract
136     require(this != _to);
137     balances[msg.sender] = balances[msg.sender].sub(_amount);
138     balances[_to] = balances[_to].add(_amount);
139     Transfer(msg.sender,_to,_amount);
140     return true;
141   }
142 
143   address public crowdsaleContract;
144   bool flag = false;
145   //connect to crowdsaleContract, can be use once
146   function setCrowdsaleContract (address _address) public {
147     require (!flag);
148     crowdsaleContract = _address;
149     reserveBalanceMap[_address] = true;
150     flag = true;
151   }
152 
153   /*
154   standart ERC-20 function
155   */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _amount
160     )public returns (bool success) {
161       require(this != _to);
162 
163       if (balances[_from] >= _amount
164        && allowed[_from][msg.sender] >= _amount
165        && _amount > 0
166        && balances[_to] + _amount > balances[_to]) {
167        balances[_from] -= _amount;
168        allowed[_from][msg.sender] -= _amount;
169        balances[_to] += _amount;
170        Transfer(_from, _to, _amount);
171     return true;
172     } else {
173     return false;
174     }
175   }
176 
177   /*
178   standart ERC-20 function
179   approve your token balance to another address
180   */
181   function approve(address _spender, uint256 _amount)public returns (bool success) {
182     allowed[msg.sender][_spender] = _amount;
183     Approval(msg.sender, _spender, _amount);
184     return true;
185   }
186 
187   //standart ERC-20 function
188   function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
189     return allowed[_owner][_spender];
190   }
191 
192   //Constructor
193   function VGCToken(address _addressOwner) public {
194     owner = _addressOwner;
195     techSupport = msg.sender;
196     balances[this] = _totalSupply;
197     teamBalanceMap[_addressOwner] = true;
198     bountyBalanceMap[_addressOwner] = true;
199     advisorsBalanceMap[_addressOwner] = true;
200     referalFundBalanceMap[_addressOwner] = true;
201     reserveBalanceMap[_addressOwner] = true;
202   }
203   //make investor balance = 0
204   function burnTokens(address _address) public{
205     require(msg.sender == crowdsaleContract);
206     balances[_address] = 0;
207   }
208   // Tokens reserve (last screen in documentation)
209   mapping (address => bool) public teamBalanceMap;
210   mapping (address => bool) public bountyBalanceMap;
211   mapping (address => bool) public advisorsBalanceMap;
212   mapping (address => bool) public referalFundBalanceMap;
213   mapping (address => bool) public reserveBalanceMap;
214 
215 
216   uint private crowdsaleBalance = 36000000*pow(10,decimals);
217 
218   function getCrowdsaleBalance() public view returns(uint) {
219     return crowdsaleBalance;
220   }
221 
222 
223   uint public teamBalance = 1000000*pow(10,decimals);
224   uint public bountyBalance = 3000000*pow(10,decimals);
225   uint public ownerBalance = 1000000*pow(10,decimals);
226   uint public advisorsBalance = 1000000*pow(10,decimals);
227   uint public referalFundBalance = 3000000*pow(10,decimals);
228   uint public reserveBalance = 10000000*pow(10,decimals);
229 
230   function addTRA (address _address) public onlyOwner {
231     teamBalanceMap[_address] = true;
232   }
233 
234   function removeTRA (address _address) public onlyOwner {
235     teamBalanceMap[_address] = false;
236   }
237 
238   function addBRA (address _address) public onlyOwner {
239     bountyBalanceMap[_address] = true;
240   }
241 
242   function removeBRA (address _address) public onlyOwner {
243     bountyBalanceMap[_address] = false;
244   }
245 
246   function addARA (address _address) public onlyOwner {
247     advisorsBalanceMap[_address] = true;
248   }
249 
250   function removeARA (address _address) public onlyOwner {
251     advisorsBalanceMap[_address] = false;
252   }
253 
254   function addFRA (address _address) public onlyOwner {
255     referalFundBalanceMap[_address] = true;
256   }
257 
258   function removeFRA (address _address) public onlyOwner {
259     referalFundBalanceMap[_address] = false;
260   }
261 
262   function addRRA (address _address) public onlyOwner {
263     reserveBalanceMap[_address] = true;
264   }
265 
266   function removeRRA (address _address) public onlyOwner {
267     reserveBalanceMap[_address] = false;
268   }
269 
270   function sendTeamBalance (address _address, uint _value) public{
271     require(teamBalanceMap[msg.sender]);
272     teamBalance = teamBalance.sub(_value);
273     balances[this] = balances[this].sub(_value);
274     balances[_address] = balances[_address].add(_value);
275     Transfer(this,_address, _value);
276   }
277 
278   function sendBountyBalance (address _address, uint _value) public{
279     require(bountyBalanceMap[msg.sender]);
280     bountyBalance = bountyBalance.sub(_value);
281     balances[this] = balances[this].sub(_value);
282     balances[_address] = balances[_address].add(_value);
283     Transfer(this,_address, _value);
284   }
285 
286   function sendAdvisorsBalance (address _address, uint _value) public{
287     require(advisorsBalanceMap[msg.sender]);
288     advisorsBalance = advisorsBalance.sub(_value);
289     balances[this] = balances[this].sub(_value);
290     balances[_address] = balances[_address].add(_value);
291     Transfer(this,_address, _value);
292   }
293 
294   function sendReferallFundBalance (address _address, uint _value) public{
295     require(referalFundBalanceMap[msg.sender]);
296     referalFundBalance = referalFundBalance.sub(_value);
297     balances[this] = balances[this].sub(_value);
298     balances[_address] = balances[_address].add(_value);
299     Transfer(this,_address, _value);
300   }
301 
302   function sendReserveBalance (address _address, uint _value) public{
303     require(reserveBalanceMap[msg.sender]);
304     reserveBalance = reserveBalance.sub(_value);
305     balances[this] = balances[this].sub(_value);
306     balances[_address] = balances[_address].add(_value);
307     Transfer(this,_address, _value);
308   }
309 
310   function sendOwnersBalance (address _address, uint _value) public onlyOwner{
311     ownerBalance = ownerBalance.sub(_value);
312     balances[this] = balances[this].sub(_value);
313     balances[_address] = balances[_address].add(_value);
314     Transfer(this,_address, _value);
315   }
316 
317   function sendCrowdsaleBalance (address _address, uint _value) public {
318     require (msg.sender == crowdsaleContract);
319     crowdsaleBalance = crowdsaleBalance.sub(_value);
320     balances[this] = balances[this].sub(_value);
321     balances[_address] = balances[_address].add(_value);
322     Transfer(this,_address, _value);
323   }
324 
325   bool private isReferralBalancesSended = false;
326 
327   function getRefBalSended () public view returns(bool){
328       return isReferralBalancesSended;
329   }
330 
331 
332   // Dashboard function
333   function referralProgram (address[] _addresses, uint[] _values, uint _summary) public onlyTechSupport {
334     require (_summary <= getCrowdsaleBalance());
335     require(_addresses.length == _values.length);
336     balances[this] = balances[this].sub(_summary);
337     for (uint i = 0; i < _addresses.length; i++){
338       balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
339       Transfer(this,_addresses[i],_values[i]);
340     }
341     isReferralBalancesSended = true;
342   }
343 
344   // at the end of ico burn unsold tokens
345   function finishIco() public{
346       require(msg.sender == crowdsaleContract);
347       balances[this] = balances[this].sub(crowdsaleBalance);
348       Transfer(this,0,crowdsaleBalance);
349       _totalSupply = _totalSupply.sub(crowdsaleBalance);
350       crowdsaleBalance = 0;
351   }
352 }