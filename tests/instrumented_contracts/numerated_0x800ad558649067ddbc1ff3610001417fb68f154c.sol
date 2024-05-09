1 pragma solidity ^0.4.21;
2 
3 contract Issuer {
4     
5     address internal issuer = 0x692202c797ca194be918114780db7796e9397c13;
6     
7     function changeIssuer(address _to) public {
8         
9         require(msg.sender == issuer); 
10         
11         issuer = _to;
12     }
13 }
14 
15 contract ERC20Interface {
16     
17     function totalSupply() public constant returns (uint);
18     function balanceOf(address tokenOwner) public constant returns (uint balance);
19     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
20     function transfer(address to, uint tokens) public returns (bool success);
21     function approve(address spender, uint tokens) public returns (bool success);
22     function transferFrom(address from, address to, uint tokens) public returns (bool success);
23 
24     event Transfer(address indexed from, address indexed to, uint tokens);
25     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
26 
27     
28 }
29 
30 library StringHelper {
31 
32     function stringToUint(string s) pure internal returns (uint result) {
33         bytes memory b = bytes(s);
34         uint i;
35         result = 0;
36         for (i = 0; i < b.length; i++) {
37             uint c = uint(b[i]);
38             if (c >= 48 && c <= 57) {
39                 result = result * 10 + (c - 48);
40             }
41         }
42     }
43     
44 }
45 
46 library SafeMath {
47     
48     function add(uint a, uint b) internal pure returns (uint c) {
49         c = a + b;
50         require(c >= a);
51     }
52     
53     function sub(uint a, uint b) internal pure returns (uint c) {
54         require(b <= a);
55         c = a - b;
56     }
57     
58 }
59 
60 contract ERC20 is Issuer, ERC20Interface {
61 
62     using SafeMath for uint;
63 
64     bool public locked = true;
65     
66     string public constant name = "Ethnamed";
67     string public constant symbol = "NAME";
68     uint8 public constant decimals = 18;
69     uint internal tokenPrice;
70     
71     event Transfer(address indexed from, address indexed to, uint tokens);
72     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
73     
74     struct Contributor {
75         mapping(address => uint) allowed;
76         uint balance;
77     }
78     
79     mapping(address => Contributor) contributors;
80     
81     function ERC20() public {
82         tokenPrice = 10**uint(decimals);
83         Contributor storage contributor = contributors[issuer];
84         contributor.balance = totalSupply();
85         emit Transfer(address(0), issuer, totalSupply());
86     }
87     
88     function unlock() public {
89         require(msg.sender == issuer);
90         locked = false;
91     }
92     
93     function totalSupply() public view returns (uint) {
94         return 1000000 * tokenPrice;
95     }
96     
97     function balanceOf(address _tokenOwner) public view returns (uint) {
98         Contributor storage contributor = contributors[_tokenOwner];
99         return contributor.balance;
100     }
101     
102     function transfer(address _to, uint _tokens) public returns (bool) {
103         require(!locked || msg.sender == issuer);
104         Contributor storage sender = contributors[msg.sender];
105         Contributor storage recepient = contributors[_to];
106         sender.balance = sender.balance.sub(_tokens);
107         recepient.balance = recepient.balance.add(_tokens);
108         emit Transfer(msg.sender, _to, _tokens);
109         return true;
110     }
111     
112     function allowance(address _tokenOwner, address _spender) public view returns (uint) {
113         Contributor storage owner = contributors[_tokenOwner];
114         return owner.allowed[_spender];
115     }
116     
117     function transferFrom(address _from, address _to, uint _tokens) public returns (bool) {
118         
119         Contributor storage owner = contributors[_from];
120         
121         require(owner.allowed[msg.sender] >= _tokens);
122         
123         Contributor storage receiver = contributors[_to];
124         
125         owner.balance = owner.balance.sub(_tokens);
126         owner.allowed[msg.sender] = owner.allowed[msg.sender].sub(_tokens);
127         
128         receiver.balance = receiver.balance.add(_tokens);
129         
130         emit Transfer(_from, _to, _tokens);
131         
132         return true;
133     }
134     
135     function approve(address _spender, uint _tokens) public returns (bool) {
136         
137         require(!locked);
138         
139         Contributor storage owner = contributors[msg.sender];
140         owner.allowed[_spender] = _tokens;
141         
142         emit Approval(msg.sender, _spender, _tokens);
143         return true;
144     }
145     
146 }
147 
148 contract DEXified is ERC20 {
149 
150     using SafeMath for uint;
151 
152     //use struct Contributor from ERC20
153     //use bool locked from ERC20
154     
155     struct Sales {
156         address[] items;
157         mapping(address => uint) lookup;
158     }
159     
160     struct Offer {
161         uint256 tokens;
162         uint256 price;
163     }
164     
165     mapping(address => Offer) exchange;
166     
167     uint256 public market = 0;
168     
169     //Credits to https://github.com/k06a
170     Sales internal sales;
171     
172     function sellers(uint index) public view returns (address) {
173         return sales.items[index];
174     }
175     
176     function getOffer(address _owner) public view returns (uint256[2]) {
177         Offer storage offer = exchange[_owner];
178         return ([offer.price , offer.tokens]);
179     }
180     
181     function addSeller(address item) private {
182         if (sales.lookup[item] > 0) {
183             return;
184         }
185         sales.lookup[item] = sales.items.push(item);
186     }
187 
188     function removeSeller(address item) private {
189         uint index = sales.lookup[item];
190         if (index == 0) {
191             return;
192         }
193         if (index < sales.items.length) {
194             address lastItem = sales.items[sales.items.length - 1];
195             sales.items[index - 1] = lastItem;
196             sales.lookup[lastItem] = index;
197         }
198         sales.items.length -= 1;
199         delete sales.lookup[item];
200     }
201     
202     
203     function setOffer(address _owner, uint256 _price, uint256 _value) internal {
204         exchange[_owner].price = _price;
205         market =  market.sub(exchange[_owner].tokens);
206         exchange[_owner].tokens = _value;
207         market =  market.add(_value);
208         if (_value == 0) {
209             removeSeller(_owner);
210         }
211         else {
212             addSeller(_owner);
213         }
214     }
215     
216 
217     function offerToSell(uint256 _price, uint256 _value) public {
218         require(!locked);
219         setOffer(msg.sender, _price, _value);
220     }
221     
222     function executeOffer(address _owner) public payable {
223         require(!locked);
224         Offer storage offer = exchange[_owner];
225         require(offer.tokens > 0);
226         require(msg.value == offer.price);
227         _owner.transfer(msg.value);
228         
229         Contributor storage owner_c  = contributors[_owner];
230         Contributor storage sender_c = contributors[msg.sender];
231         
232         require(owner_c.balance >= offer.tokens);
233         owner_c.balance = owner_c.balance.sub(offer.tokens);
234         sender_c.balance =  sender_c.balance.add(offer.tokens);
235         emit Transfer(_owner, msg.sender, offer.tokens);
236         setOffer(_owner, 0, 0);
237     }
238     
239 }
240 
241 contract Ethnamed is DEXified {
242 
243     using SafeMath for uint;
244     using StringHelper for string;
245     
246     struct Name {
247         string record;
248         address owner;
249         uint expires;
250         uint balance;
251     }
252     
253     function withdraw(address _to) public {
254 
255         require(msg.sender == issuer); 
256         
257         _to.transfer(address(this).balance);
258     }
259     
260     mapping (string => Name) internal registry;
261     
262     mapping (bytes32 => string) internal lookup;
263     
264     function resolve(string _name) public view returns (string) {
265         return registry[_name].record;
266     }
267     
268     function whois(bytes32 _hash) public view returns (string) {
269         return lookup[_hash];
270     }
271     
272     function transferOwnership(string _name, address _to) public {
273         
274         require(registry[_name].owner == msg.sender);
275         
276         registry[_name].owner = _to;
277     }
278 
279     function removeName(string _name) internal {
280         Name storage item = registry[_name];
281         
282         bytes32 hash = keccak256(item.record);
283         
284         delete registry[_name];
285         
286         delete lookup[hash];
287     }
288 
289     function removeExpiredName(string _name) public {
290         
291         require(registry[_name].expires < now);
292         
293         removeName(_name);
294     }
295     
296     function removeNameByOwner(string _name) public {
297         
298         Name storage item = registry[_name];
299         
300         require(item.owner == msg.sender);
301         
302         removeName(_name);
303     }
304     
305 
306     function sendTo(string _name) public payable {
307         
308         if (registry[_name].owner == address(0)) {
309             registry[_name].balance = registry[_name].balance.add(msg.value);
310         }
311         else {
312             registry[_name].owner.transfer(msg.value);
313         }
314     
315     }
316     
317     
318     
319     function setupCore(string _name, string _record, address _owner, uint _life) internal {
320         
321         Name storage item = registry[_name];
322         
323         require(item.owner == msg.sender || item.owner == 0x0);
324         item.record = _record;
325         item.owner = _owner;
326         if (item.balance > 0) {
327             item.owner.transfer(item.balance);
328             item.balance = 0;
329         }
330         item.expires = now + _life;
331         bytes32 hash = keccak256(_record);
332         lookup[hash] = _name;
333         
334     }
335 
336     function setupViaAuthority(
337         string _length,
338         string _name,
339         string _record,
340         string _blockExpiry,
341         address _owner,
342         uint8 _v, 
343         bytes32 _r, 
344         bytes32 _s,
345         uint _life
346     ) internal {
347         
348         require(_blockExpiry.stringToUint() >= block.number);
349         
350         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n", _length, _name, "r=", _record, "e=", _blockExpiry), _v, _r, _s) == issuer);
351         
352         setupCore(_name, _record, _owner, _life);
353         
354     }
355 
356     function setOrUpdateRecord2(
357         string _length,
358         string _name,
359         string _record,
360         string _blockExpiry,
361         address _owner,
362         uint8 _v, 
363         bytes32 _r, 
364         bytes32 _s
365     ) public {
366         
367         Contributor storage contributor = contributors[msg.sender];
368         
369         require(contributor.balance >= tokenPrice);
370         
371         contributor.balance = contributor.balance.sub(tokenPrice);
372         
373         uint life = 48 weeks;
374      
375         setupViaAuthority(_length, _name, _record, _blockExpiry, _owner, _v, _r, _s, life);   
376     }
377 
378     function setOrUpdateRecord(
379         string _length,
380         string _name,
381         string _record,
382         string _blockExpiry,
383         address _owner,
384         uint8 _v, 
385         bytes32 _r, 
386         bytes32 _s
387     ) public payable {
388         
389         uint life = msg.value == 0.01  ether ?  48 weeks : 
390                     msg.value == 0.008 ether ?  24 weeks :
391                     msg.value == 0.006 ether ?  12 weeks :
392                     msg.value == 0.002 ether ?  4  weeks :
393                     0;
394                        
395         require(life > 0);
396         
397         setupViaAuthority(_length, _name, _record, _blockExpiry, _owner, _v, _r, _s, life);
398     }
399 }