1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 
30 contract Ownable {
31     address public owner;
32 
33 
34     /**
35      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36      * account.
37      */
38     function Ownable() {
39         owner = msg.sender;
40     }
41 
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50 
51 
52     /**
53      * @dev Allows the current owner to transfer control of the contract to a newOwner.
54      * @param newOwner The address to transfer ownership to.
55      */
56     function transferOwnership(address newOwner) onlyOwner {
57         if (newOwner != address(0)) {
58             owner = newOwner;
59         }
60     }
61 
62 }
63 
64 contract ERC20Basic {
65     uint256 public totalSupply;
66     function balanceOf(address who) constant returns (uint256);
67     function transfer(address to, uint256 value) returns (bool);
68 
69     // KYBER-NOTE! code changed to comply with ERC20 standard
70     event Transfer(address indexed _from, address indexed _to, uint _value);
71     //event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 contract BasicToken is ERC20Basic {
75     using SafeMath for uint256;
76 
77     mapping(address => uint256) balances;
78 
79     /**
80     * @dev transfer token for a specified address
81     * @param _to The address to transfer to.
82     * @param _value The amount to be transferred.
83     */
84     function transfer(address _to, uint256 _value) returns (bool) {
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         Transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     /**
92     * @dev Gets the balance of the specified address.
93     * @param _owner The address to query the the balance of.
94     * @return An uint256 representing the amount owned by the passed address.
95     */
96     function balanceOf(address _owner) constant returns (uint256 balance) {
97         return balances[_owner];
98     }
99 
100 }
101 
102 contract ERC20 is ERC20Basic {
103     function allowance(address owner, address spender) constant returns (uint256);
104     function transferFrom(address from, address to, uint256 value) returns (bool);
105     function approve(address spender, uint256 value) returns (bool);
106 
107     // KYBER-NOTE! code changed to comply with ERC20 standard
108     event Approval(address indexed _owner, address indexed _spender, uint _value);
109     //event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 
113 
114 contract StandardToken is ERC20, BasicToken {
115 
116     mapping (address => mapping (address => uint256)) allowed;
117 
118 
119     /**
120      * @dev Transfer tokens from one address to another
121      * @param _from address The address which you want to send tokens from
122      * @param _to address The address which you want to transfer to
123      * @param _value uint256 the amout of tokens to be transfered
124      */
125     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
126         uint256 _allowance = allowed[_from][msg.sender];
127 
128         balances[_from] = balances[_from].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         allowed[_from][msg.sender] = _allowance.sub(_value);
131         Transfer(_from, _to, _value);
132         return true;
133     }
134 
135     /**
136      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
137      * @param _spender The address which will spend the funds.
138      * @param _value The amount of tokens to be spent.
139      */
140     function approve(address _spender, uint256 _value) returns (bool) {
141 
142         // To change the approve amount you first have to reduce the addresses`
143         //  allowance to zero by calling `approve(_spender, 0)` if it is not
144         //  already 0 to mitigate the race condition described here:
145         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
147 
148         allowed[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150         return true;
151     }
152 
153     /**
154      * @dev Function to check the amount of tokens that an owner allowed to a spender.
155      * @param _owner address The address which owns the funds.
156      * @param _spender address The address which will spend the funds.
157      * @return A uint256 specifing the amount of tokens still avaible for the spender.
158      */
159     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
160         return allowed[_owner][_spender];
161     }
162 
163 }
164 
165 contract Lock is StandardToken, Ownable{
166 
167     mapping(address => uint256) public lockedBalance;
168 
169     mapping(address => uint256) public lockStartTime;
170 
171     mapping(address => uint256) public usedBalance;
172 
173     function availablePercent(address _to) internal constant returns (uint256) {
174         uint256 percent = 25;
175         percent += ((now - lockStartTime[_to]) / 90 days ) * 25;
176         if(percent > 100) {
177             percent = 100;
178         }
179         return percent;
180     }
181 
182     function issueToken(address _to,uint256 _value) public onlyOwner {
183         require(super.transfer(_to,_value) ==  true);
184         require(lockStartTime[_to] == 0);
185         lockedBalance[_to] = lockedBalance[_to].add(_value);
186         lockStartTime[_to] = block.timestamp;
187     }
188 
189     function available(address _to) public constant returns (uint256) {
190         uint256 percent = availablePercent(_to);
191         uint256 avail = lockedBalance[_to];
192         avail = avail.mul(percent);
193         avail = avail.div(100);
194         avail = avail.sub(usedBalance[_to]);
195         return avail ;
196     }
197 
198     function totalAvailable(address _to) public constant returns (uint256){
199         uint256 avail1 = available(_to);
200         uint256 avail2 = balances[_to].add(usedBalance[_to]).sub(lockedBalance[_to]);
201         uint256 totalAvail = avail1.add(avail2);
202         return totalAvail;
203     }
204 
205     function lockTransfer(address _to, uint256 _value) internal returns (bool) {
206         uint256 avail1 = available(msg.sender);
207         uint256 avail2 = balances[msg.sender].add(usedBalance[msg.sender]).sub(lockedBalance[msg.sender]);
208         uint256 totalAvail = avail1.add(avail2);
209         require(_value <= totalAvail);
210         bool ret = super.transfer(_to,_value);
211         if(ret == true) {
212             if(_value > avail2){
213                 usedBalance[msg.sender] = usedBalance[msg.sender].add(_value).sub(avail2);
214             }
215             if(usedBalance[msg.sender] >= lockedBalance[msg.sender]) {
216                 delete lockStartTime[msg.sender];
217             }
218         }
219         return ret;
220     }
221 
222     function lockTransferFrom(address _from,address _to, uint256 _value) internal returns (bool) {
223         uint256 avail1 = available(_from);
224         uint256 avail2 = balances[_from].add(usedBalance[_from]).sub(lockedBalance[_from]);
225         uint256 totalAvail = avail1.add(avail2);
226         require(_value <= totalAvail);
227         bool ret = super.transferFrom(_from,_to,_value);
228         if(ret == true) {
229             if(_value > avail2){
230                 usedBalance[_from] = usedBalance[_from].add(_value).sub(avail2);
231             }
232             if(usedBalance[_from] >= lockedBalance[_from]) {
233                 delete lockStartTime[_from];
234             }
235         }
236         return ret;
237     }
238 }
239 
240 contract PrototypeNetworkToken is Lock{
241     string  public  constant name = "Prototype Network";
242     string  public  constant symbol = "PROT";
243     uint    public  constant decimals = 18;
244 
245     bool public transferEnabled = true;
246 
247 
248     modifier validDestination( address to ) {
249         require(to != address(0x0));
250         require(to != address(this) );
251         _;
252     }
253 
254     function PrototypeNetworkToken() {
255         // Mint all tokens. Then disable minting forever.
256         totalSupply = 2100000000 * (10 ** decimals);
257         balances[msg.sender] = totalSupply;
258         Transfer(address(0x0), msg.sender, totalSupply);
259         transferOwnership(msg.sender); // admin could drain tokens that were sent here by mistake
260     }
261 
262     function transfer(address _to, uint _value) validDestination(_to) returns (bool) {
263         require(transferEnabled == true);
264 
265         // The sender is in locked address list
266         if(lockStartTime[msg.sender] > 0) {
267             return super.lockTransfer(_to,_value);
268         }else {
269             return super.transfer(_to, _value);
270         }
271     }
272 
273     function transferFrom(address _from, address _to, uint _value) validDestination(_to) returns (bool) {
274         require(transferEnabled == true);
275         // The sender is in locked address list
276         if(lockStartTime[_from] > 0) {
277             return super.lockTransferFrom(_from,_to,_value);
278         }else {
279             return super.transferFrom(_from, _to, _value);
280         }
281     }
282 
283 
284     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
285         token.transfer( owner, amount );
286     }
287 
288     function setTransferEnable(bool enable) onlyOwner {
289         transferEnabled = enable;
290     }
291 }