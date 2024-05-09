1 pragma solidity ^0.4.8;
2 
3 ///address -> uint256 mapping.
4 library IterableMapping
5 {
6     struct IndexValue { uint keyIndex; uint value; }
7     struct KeyFlag { address key; bool deleted; }
8     struct itmap
9     {
10         mapping(address => IndexValue) data;
11         KeyFlag[] keys;
12         uint size;
13     }
14 
15     function insert(itmap storage self, address key, uint value) internal returns (bool replaced)
16     {
17         uint keyIndex = self.data[key].keyIndex;
18         self.data[key].value = value;
19         if (keyIndex > 0)
20             return true;
21         else
22         {
23             keyIndex = self.keys.length++;
24             self.data[key].keyIndex = keyIndex + 1;
25             self.keys[keyIndex].key = key;
26             self.size++;
27             return false;
28         }
29     }
30     function remove(itmap storage self, address key) internal returns (bool success)
31     {
32         uint keyIndex = self.data[key].keyIndex;
33         if (keyIndex == 0)
34             return false;
35         delete self.data[key];
36         self.keys[keyIndex - 1].deleted = true;
37         self.size --;
38     }
39     function contains(itmap storage self, address key) internal returns (bool)
40     {
41         return self.data[key].keyIndex > 0;
42     }
43     function iterate_start(itmap storage self) internal returns (uint keyIndex)
44     {
45         return iterate_next(self, uint(-1));
46     }
47     function iterate_valid(itmap storage self, uint keyIndex) internal returns (bool)
48     {
49         return keyIndex < self.keys.length;
50     }
51     function iterate_next(itmap storage self, uint keyIndex) internal returns (uint r_keyIndex)
52     {
53         keyIndex++;
54         while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
55             keyIndex++;
56         return keyIndex;
57     }
58     function iterate_get(itmap storage self, uint keyIndex) internal returns (address key, uint value)
59     {
60         key = self.keys[keyIndex].key;
61         value = self.data[key].value;
62     }
63 }
64 
65 /**
66  *Math operations with safety checks
67  */
68 library SafeMath {
69     function mul(uint a, uint b) internal returns (uint){
70         uint c = a * b;
71         assert(a == 0 || c / a ==b);
72         return c;
73     }
74 
75     function div(uint a, uint b) internal returns (uint) {
76         //assert(b > 0); //Solidity automatically throws when dividing by 0
77         uint c = a/b;
78         // assert(a == b * c + a% b); //There is no case in which this doesn't hold
79         return c;
80     }
81 
82     function sub(uint a, uint b) internal returns (uint) {
83         assert(b<=a);
84         return a-b;
85     }
86 
87     function add(uint a, uint b) internal returns (uint) {
88         uint c = a + b;
89         assert(c >= a);
90         return c;
91     }
92 
93     function max64(uint64 a, uint64 b) internal returns (uint64) {
94         return a >= b ? a : b;
95     }
96 
97     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
98         return a < b ? a : b;
99     }
100 
101     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
102         return a >= b ? a : b;
103     }
104 
105     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
106         return a < b ? a : b;
107     }
108 
109     function assert(bool assertion) internal {
110         if(!assertion){
111             throw;
112         }
113     }
114 }
115 
116 
117 /**
118  * title ERC20 Basic
119  * dev Simpler version of ERC20 interface
120  * dev see https://github.com/ethereum/EIPs/issues/20
121  *
122  */
123 contract ERC20Basic{
124     function balanceOf(address who) constant returns (uint);
125     function transfer(address to, uint value);
126     event Transfer(address indexed from, address indexed to, uint value);
127 }
128 
129 
130 /**
131  * title Basic token
132  * dev Basic version of StandardToken, eith no allowances.
133  */
134 contract BasicToken is ERC20Basic {
135     using SafeMath for uint;
136     /**
137     * dev Fix for eht ERC20 short address attack.
138     */
139     modifier onlyPayloadSize(uint size) {
140         if(msg.data.length < size + 4){
141             throw;
142         }
143         _;
144     }
145 }
146 
147 
148 /**
149 * title ERC20 interface
150 * dev see https://github.com/ethereum/EIPs/issues/20
151 */
152 contract ERC20 is ERC20Basic {
153     function allowance(address owner, address spender) constant returns (uint);
154     function transferFrom(address from, address to, uint value);
155     function approve(address spender, uint value);
156     event Approval(address indexed owner, address indexed spender, uint value);
157 }
158 
159 
160 /**
161 * title Standard ERC20 token
162 *
163 * dev Implemantation of the basic standart token.
164 * dev https://github.com/ethereum/EIPs/issues/20
165 * dev Based on code by FirstBlood:http://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
166 **/
167 contract StandardToken is BasicToken, ERC20{
168     mapping (address => mapping (address => uint)) allowed;
169     event Burn(address from, address to, uint value);
170     event TransferFrom(address from, uint value);
171     event Dividends(address from, address to, uint value);
172 
173     /**
174     * dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
175     * param _spender The address which will spend the funds.
176     * param _value The amount of tokens to be spent.
177     */
178     function approve(address _spender, uint _value) {
179         //To change the approve amount you first have to reduce the addresses
180         // allowance to zero by calling approve(_spender, 0) if if it not
181         // already 0 to mitigate the race condition described here:
182         // https://github.com/ethereum/EIPs/issues/20#issuscomment-263524729
183         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
184 
185         allowed[msg.sender][_spender] = _value;
186         Approval(msg.sender, _spender, _value);
187     }
188 
189     /**
190     * dev Function to check the amount of token rhan an owner allowed to a spender.
191     * param _owner address Thr address whivh owns the funds.
192     * param _spender address The address which will spend the funds.
193     * return A uint specifing the amount of tokrns still avaible for the spender.
194     **/
195     function allowance(address _owner, address _spender) constant returns (uint remaining) {
196         return allowed[_owner][_spender];
197     }
198 }
199 
200 contract Ownable {
201     address public owner;
202 
203     function Ownable(){
204         owner = msg.sender;
205     }
206 
207     modifier onlyOwner(){
208         if(msg.sender != owner){
209             throw;
210         }
211         _;
212     }
213 
214 //    function transferOwnership(address newOwner) onlyOwner{
215 //        if (newOwner != address(0)){
216 //            owner = newOwner;
217 //        }
218 //    }
219 }
220 
221 contract GlobalCoin is Ownable, StandardToken{
222     uint256 public decimals = 8;
223     uint public totalSupply = 1000000000000000;//1后面15个0 ,发行1000，0000 ，后面是00000000,对应小数点后8个0
224     address public dividendAddress = 0x1D33776a090a2F321FF596C0C011F2f414f3A527;//分红地址
225     address public burnAddress = 0x0000000000000000000000000000000000000000; //销毁GBC地址
226     uint256 private globalShares = 0;
227     mapping (address => uint256) private balances;
228     mapping (address => uint256) private vips;
229     using IterableMapping for IterableMapping.itmap;
230     IterableMapping.itmap public data;
231     using SafeMath for uint256;
232 
233     modifier noEth() {
234         if (msg.value < 0) {
235             throw;
236         }
237         _;
238     }
239     function() {
240         // 当有人发送eth或者Token，会触发这个事件
241         if (msg.value > 0)
242             TransferFrom(msg.sender, msg.value);
243     }
244 
245     function insert(address k, uint v) internal returns (uint size)
246     {
247         IterableMapping.insert(data, k, v);
248         return data.size;
249     }
250         //预计分多少红
251     function expectedDividends(address user) constant returns (uint Dividends){
252         return balances[dividendAddress] / globalShares * vips[user];
253     }
254 
255 //    //显示有多少GBC
256     function balanceOf(address addr) constant returns (uint balance) {
257         return balances[addr];
258     }
259     //显示有多少股
260     function yourShares(address addr) constant returns (uint shares) {
261         return vips[addr];
262     }
263 
264     function transfer(address to, uint256 amount) onlyPayloadSize(2 * 32)
265     {
266         if (to == burnAddress) {
267             return burn(amount);
268         }
269         balances[msg.sender] = balances[msg.sender].sub(amount);
270         balances[to] = balances[to].add(amount);
271         Transfer(msg.sender, to, amount);
272     }
273     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
274         var _allowance = allowed[_from][msg.sender];
275 
276     //Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
277     // if (_value > _allowance) throw;
278 
279         balances[_to] = balances[_to].add(_value);
280         balances[_from] = balances[_from].sub(_value);
281         allowed[_from][msg.sender] = _allowance.sub(_value);
282         Transfer(_from, _to, _value);
283     }
284     function burn (uint256 amount) //获得分红
285     {
286         if (amount >= 100000000000) {
287             vips[msg.sender] += amount / 100000000000;
288             globalShares += amount / 100000000000;
289             insert(msg.sender, vips[msg.sender]);
290             balances[msg.sender] = balances[msg.sender].sub(amount);
291             balances[burnAddress] = balances[burnAddress].add(amount);
292             Burn(msg.sender, burnAddress, amount);
293         }
294     }
295 
296 
297     //查看全球一共多少股
298     function totalShares() constant returns (uint shares){
299         return globalShares;
300     }
301 
302 
303     //为每个股民发送分红
304     function distributeDividends() onlyOwner public noEth(){
305         for (var i = IterableMapping.iterate_start(data); IterableMapping.iterate_valid(data, i); i = IterableMapping.iterate_next(data, i))
306         {
307             var (key, value) = IterableMapping.iterate_get(data, i);
308             uint tmp = balances[dividendAddress] / globalShares * value;
309             balances[key] = balances[key].add(tmp);
310             Dividends(dividendAddress, key, tmp);
311         }
312         balances[dividendAddress] = balances[dividendAddress].sub(balances[dividendAddress] / globalShares * globalShares);
313     }
314 
315     function GlobalCoin() onlyOwner {
316         balances[owner] = totalSupply;
317     }
318 
319 }