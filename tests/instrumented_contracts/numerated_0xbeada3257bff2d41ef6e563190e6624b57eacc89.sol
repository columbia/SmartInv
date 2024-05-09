1 pragma solidity ^0.4.15;
2 
3 //import "./AuthAdmin.sol";
4 //import "./SingleTokenCoin.sol";
5 //import "./SafeMath.sol";
6 
7 contract IcoManagement {
8     
9     using SafeMath for uint256;
10     
11     uint256 price = 1E17; // wei per 1 token
12     uint256 fract_price = 1E11;  // wei per 0.000001 token
13     //uint256 public icoStartTime = now;
14     uint256 public icoStartTime = 1512864000; //10 dec 2017 00:00
15     uint256 public icoEndTime = 1518220800; // 10 feb 2018 00:00
16     //uint256 public icoEndTime = now + 60 days; // for testing
17     // uint256 public icoEndTime = 1517270400; 
18     uint256 public min_inv = 1E17;
19     uint256 public minCap = 3000E18;
20     uint256 public funded;
21     // uint256 public tokenHolders;
22     
23     bool public icoPhase = true;
24     bool public ico_rejected = false;
25     // bool token_valid = false;
26 
27     mapping(address => uint256) public contributors;
28     
29 
30     SingleTokenCoin public token;
31     AuthAdmin authAdmin ;
32 
33     event Icoend();
34     event Ico_rejected(string details);
35     
36     modifier onlyDuringIco {
37         require (icoPhase);
38         require(now < icoEndTime && now > icoStartTime);
39         _;
40     }
41 
42     modifier adminOnly {
43         require (authAdmin.isCurrentAdmin(msg.sender));
44         _;
45     }
46     
47     /*modifier usersOnly {
48         require(authAdmin.isCurrentUser(msg.sender));
49         _;
50     }*/
51     
52     function () onlyDuringIco public payable {
53         invest(msg.sender);
54     }
55     
56     function invest(address _to) public onlyDuringIco payable {
57         uint256 purchase = msg.value;
58         contributors[_to] = contributors[_to].add(purchase);
59         require (purchase >= min_inv);
60         uint256 change = purchase.mod(fract_price);
61         uint256 clean_purchase = purchase.sub(change);
62 	    funded = funded.add(clean_purchase);
63         uint256 token_amount = clean_purchase.div(fract_price);
64         require (_to.send(change));
65         token.mint(_to, token_amount);
66     }
67     
68     function IcoManagement(address admin_address) public {
69         require (icoStartTime <= icoEndTime);
70         authAdmin = AuthAdmin(admin_address);
71     }
72 
73     function set_token(address _addr) public adminOnly {
74         token = SingleTokenCoin(_addr);
75     }
76 
77     function end() public adminOnly {
78         require (now >= icoEndTime);
79         icoPhase = false;
80         Icoend();
81     }
82     
83     
84     function withdraw_funds (uint256 amount) public adminOnly {
85         require (this.balance >= amount);
86         msg.sender.transfer(amount);
87     }
88 
89     function withdraw_all_funds () public adminOnly {
90         msg.sender.transfer(this.balance);
91     }
92     
93     function withdraw_if_failed() public {
94         require(now > icoEndTime);
95 	    require(funded<minCap);
96         require(!icoPhase);
97         require (contributors[msg.sender] != 0);
98         require (this.balance >= contributors[msg.sender]);
99         uint256 amount = contributors[msg.sender];
100         contributors[msg.sender] = 0;
101         msg.sender.transfer(amount);
102     }
103     // function reject (string details) adminOnly {
104     //     // require (now > icoEndTime);
105     //     // require (!ico_rejected);
106     //     strlog("gone");
107     //     uint256 dividend_per_token = this.balance / token.totalSupply();
108     //     log(dividend_per_token);
109     //     log(this.balance);
110     //     log(token.totalSupply());
111     //     uint numberTokenHolders = token.count_token_holders();
112     //     log(numberTokenHolders);
113     //     uint256 total_rejected = 0;
114     //     for (uint256 i = 0; i < numberTokenHolders; i++) {
115     //         address addr = token.tokenHolder(i);
116     //         adlog(addr);
117     //         uint256 etherToSend = dividend_per_token * token.balanceOf(addr);
118     //         log(etherToSend);
119     //         // require (etherToSend < 1E18);
120     //         rejectedIcoBalances[addr] = rejectedIcoBalances[addr].add(etherToSend);
121     //         log(rejectedIcoBalances[addr]);
122     //         total_rejected = total_rejected.add(etherToSend);
123     //         log(total_rejected);
124     //     }
125     //     ico_rejected = true;
126     //     Ico_rejected(details);
127     //     uint256 remainder = this.balance.sub(total_rejected);
128     //     log(remainder);
129     //     require (remainder > 0);
130     //     require (msg.sender.send(remainder));
131     //     strlog("gone");
132     //     rejectedIcoBalances[msg.sender] = rejectedIcoBalances[msg.sender].add(remainder);
133     // }
134 
135     // function rejectedFundWithdrawal() {
136     //     
137     // }
138 }
139 
140 contract AuthAdmin {
141     
142     address[] admins_array;
143     address[] users_array;
144     
145     mapping (address => bool) admin_addresses;
146     mapping (address => bool) user_addresses;
147 
148     event NewAdmin(address addedBy, address admin);
149     event RemoveAdmin(address removedBy, address admin);
150     event NewUserAdded(address addedBy, address account);
151     event RemoveUser(address removedBy, address account);
152 
153     function AuthAdmin() public {
154         admin_addresses[msg.sender] = true;
155         NewAdmin(0, msg.sender);
156         admins_array.push(msg.sender);
157     }
158 
159     function addAdmin(address _address) public {
160         require (isCurrentAdmin(msg.sender));
161         require (!admin_addresses[_address]);
162         admin_addresses[_address] = true;
163         NewAdmin(msg.sender, _address);
164         admins_array.push(_address);
165     }
166 
167     function removeAdmin(address _address) public {
168         require(isCurrentAdmin(msg.sender));
169         require (_address != msg.sender);
170         require (admin_addresses[_address]);
171         admin_addresses[_address] = false;
172         RemoveAdmin(msg.sender, _address);
173     }
174 
175     function add_user(address _address) public {
176         require (isCurrentAdmin(msg.sender));
177         require (!user_addresses[_address]);
178         user_addresses[_address] = true;
179         NewUserAdded(msg.sender, _address);
180         users_array.push(_address);
181     }
182 
183     function remove_user(address _address) public {
184         require (isCurrentAdmin(msg.sender));
185         require (user_addresses[_address]);
186         user_addresses[_address] = false;
187         RemoveUser(msg.sender, _address);
188     }
189                     /*----------------------------
190                                 Getters
191                     ----------------------------*/
192     
193     function isCurrentAdmin(address _address) public constant returns (bool) {
194         return admin_addresses[_address];
195     }
196 
197     function isCurrentOrPastAdmin(address _address) public constant returns (bool) {
198         for (uint256 i = 0; i < admins_array.length; i++)
199             require (admins_array[i] == _address);
200                 return true;
201         return false;
202     }
203 
204     function isCurrentUser(address _address) public constant returns (bool) {
205         return user_addresses[_address];
206     }
207 
208     function isCurrentOrPastUser(address _address) public constant returns (bool) {
209         for (uint256 i = 0; i < users_array.length; i++)
210             require (users_array[i] == _address);
211                 return true;
212         return false;
213     }
214 }
215 contract ERC20Basic {
216   uint256 public totalSupply;
217   function balanceOf(address who) public constant returns (uint256);
218   function transfer(address to, uint256 value) public returns (bool);
219   event Transfer(address indexed from, address indexed to, uint256 value);
220 }
221 
222 contract ERC20 is ERC20Basic {
223   function allowance(address owner, address spender) public constant returns (uint256);
224   function transferFrom(address from, address to, uint256 value) public returns (bool);
225   function approve(address spender, uint256 value) public returns (bool);
226   event Approval(address indexed owner, address indexed spender, uint256 value);
227 }
228 
229 library SafeMath {
230   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
231     uint256 c = a * b;
232     assert(a == 0 || c / a == b);
233     return c;
234   }
235   function div(uint256 a, uint256 b) internal constant returns (uint256) {
236     // assert(b > 0); // Solidity automatically throws when dividing by 0
237     uint256 c = a / b;
238     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239     return c;
240   }
241   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
242     assert(b <= a);
243     return a - b;
244   }
245   function add(uint256 a, uint256 b) internal constant returns (uint256) {
246     uint256 c = a + b;
247     assert(c >= a);
248     return c;
249   }
250   function mod(uint256 a, uint256 b) internal constant returns (uint256) {
251     // assert(b > 0); // Solidity automatically throws when dividing by 0
252     uint256 c = a % b;
253     //uint256 z = a / b;
254     assert(a == (a / b) * b + c); // There is no case in which this doesn't hold
255     return c;
256   }
257 }
258 
259 contract BasicToken is ERC20Basic {
260     using SafeMath for uint256;
261     mapping(address => uint256) public balances;
262     mapping(address => bool) public holders;
263     address[] public token_holders_array;
264     
265     function transfer(address _to, uint256 _value) public returns (bool) {
266         require(_to != address(0));
267         require(_value <= balances[msg.sender]);
268 
269         if (!holders[_to]) {
270             holders[_to] = true;
271             token_holders_array.push(_to);
272         }
273 
274         balances[_to] = balances[_to].add(_value);
275         balances[msg.sender] = balances[msg.sender].sub(_value);
276 
277 
278         /*if (balances[msg.sender] == 0) {
279             uint id = get_index(msg.sender);
280             delete token_holders_array[id];
281             token_holders_array[id] = token_holders_array[token_holders_array.length - 1];
282             delete token_holders_array[token_holders_array.length-1];
283             token_holders_array.length--;
284         }*/
285 
286         Transfer(msg.sender, _to, _value);
287         return true;
288     }
289     
290     function get_index (address _whom) constant internal returns (uint256) {
291         for (uint256 i = 0; i<token_holders_array.length; i++) {
292             if (token_holders_array[i] == _whom) {
293                 return i;
294             }
295             //require (token_holders_array[i] == _whom);
296         }
297     }
298     
299     function balanceOf(address _owner) public constant returns (uint256 balance) {
300         return balances[_owner];
301     }
302     
303     function count_token_holders () public constant returns (uint256) {
304         return token_holders_array.length;
305     }
306     
307     function tokenHolder(uint256 _index) public constant returns (address) {
308         return token_holders_array[_index];
309     }
310       
311 }
312 
313 contract StandardToken is ERC20, BasicToken {
314   mapping (address => mapping (address => uint256)) internal allowed;
315 
316   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
317     require(_to != address(0));
318     require(_value <= balances[_from]);
319     require(_value <= allowed[_from][msg.sender]);
320     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
321     // require (_value <= _allowance);
322     balances[_from] = balances[_from].sub(_value);
323     balances[_to] = balances[_to].add(_value);
324     if (!holders[_to]) {
325         holders[_to] = true;
326         token_holders_array.push(_to);
327     }
328     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
329     Transfer(_from, _to, _value);
330     return true;
331   }
332   
333   function approve(address _spender, uint256 _value) public returns (bool) {
334     // To change the approve amount you first have to reduce the addresses`
335     //  allowance to zero by calling `approve(_spender, 0)` if it is not
336     //  already 0 to mitigate the race condition described here:
337     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
338     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
339     allowed[msg.sender][_spender] = _value;
340     Approval(msg.sender, _spender, _value);
341     return true;
342   }
343 
344   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
345     return allowed[_owner][_spender];
346   }
347 
348   function increaseApproval (address _spender, uint256 _addedValue) public returns (bool success) {
349     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
350     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
351     return true;
352   }
353   function decreaseApproval (address _spender, uint256 _subtractedValue) public returns (bool success) {
354     uint256 oldValue = allowed[msg.sender][_spender];
355     if (_subtractedValue > oldValue) {
356       allowed[msg.sender][_spender] = 0;
357     } else {
358       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
359     }
360     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361     return true;
362   }
363 }
364 
365 contract Ownable {
366   address public owner;
367   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
368 
369   function Ownable() public {
370     owner = msg.sender;
371   }
372  
373   modifier onlyOwner() {
374     require(msg.sender == owner);
375     _;
376   }
377 
378   function transferOwnership(address newOwner) onlyOwner public {
379     require(newOwner != address(0));
380     OwnershipTransferred(owner, newOwner);
381     owner = newOwner;
382   }
383 }
384 
385 contract MintableToken is StandardToken, Ownable {
386   event Mint(address indexed to, uint256 amount);
387   event MintFinished();
388   bool public mintingFinished = false;
389   modifier canMint() {
390     require(!mintingFinished);
391     _;
392   }
393 
394   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
395     totalSupply = totalSupply.add(_amount);
396     if (!holders[_to]) {
397         holders[_to] = true;
398         token_holders_array.push(_to);
399     } 
400     balances[_to] = balances[_to].add(_amount);
401     Mint(_to, _amount);
402     Transfer(0x0, _to, _amount);
403     return true;
404   }
405 
406   function finishMinting() onlyOwner public returns (bool) {
407     mintingFinished = true;
408     MintFinished();
409     return true;
410   }
411 }
412 
413 contract SingleTokenCoin is MintableToken {
414   string public constant name = "Symmetry Fund Token";
415   string public constant symbol = "SYMM";
416   uint256 public constant decimals = 6;
417  }