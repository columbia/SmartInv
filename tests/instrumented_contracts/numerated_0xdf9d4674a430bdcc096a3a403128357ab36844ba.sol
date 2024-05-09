1 pragma solidity ^0.5.9;
2  
3 library SafeMath {
4  
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         return (a / b);
13     }
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b <= a);
16         return (a - b);
17     }
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         assert(c >= a);
21         return c;
22     }
23 }
24  
25 contract ERC20Interface {
26  
27     event Transfer(address indexed _from, address indexed _to, uint256 _value);
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29  
30     function totalSupply() public view returns (uint256);
31     function balanceOf(address _owner) public view returns (uint256);
32     function transfer(address _to, uint256 _value) public returns (bool);
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
34     function approve(address _spender, uint256 _value) public returns (bool);
35     function allowance(address _owner, address _spender) public view returns (uint256);
36 }
37  
38 contract WadzPayToken is ERC20Interface {
39    
40     string public constant name = "WadzPay";
41     string public constant symbol = "WTK";
42     uint8 public constant decimals = 2;  // 18 is the most common number of decimal places
43  
44  
45     using SafeMath for uint256;
46  
47     // Total amount of tokens issued
48     uint256 constant internal salesPool = 15000000000; // sales pool size
49     uint256 constant internal retainedPool = 10000000000; // retained pool size
50    
51     uint256 internal salesIssued = 0;
52     uint256 internal retainedIssued = 0;
53    
54     bool public isIcoRunning = false;
55     bool public isTransferAllowed = false;
56    
57     address public owner;
58    
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60     event AdminsAdded(address[] _addresses);
61     event Whitelisted(address[] _addresses);
62  
63     mapping(address => uint256) balances;
64     mapping(address => mapping (address => uint256)) internal allowed;
65     mapping(address => bool) admins;
66     mapping(address => bool) whitelist;
67    
68    
69     /**
70     * @dev The ERC20 constructor sets the original `owner` of the contract to the sender
71     * account and initializes the pools
72     */
73     constructor() public {
74         owner = msg.sender;
75         admins[msg.sender] = true;
76     }
77    
78     function startICO() public onlyOwner {
79         isIcoRunning = true;
80     }
81       
82     function startTransfers() public onlyOwner {
83         isTransferAllowed = true;
84     }
85    
86     /**
87     * @dev Throws if called by any account other than the owner.
88     */
89     modifier onlyOwner() {
90         require(msg.sender == owner);
91         _;
92     }
93    
94     modifier onlyAdmin() {
95         require(isAdmin(msg.sender));
96         _;
97     }
98    
99     /**
100     * @dev Allows the current owner to transfer control of the contract to a newOwner.
101     * @param newOwner The address to transfer ownership to.
102     */
103     function transferOwnership(address newOwner) public onlyOwner {
104         require(newOwner != address(0));
105         owner = newOwner;
106        
107         emit OwnershipTransferred(owner, newOwner);
108     }
109    
110     /**
111     * @dev Allows the current owner to insert administratiors
112     * @param _addresses An array of addresses to insert.
113     */
114     function setAdministrators(address[] memory _addresses) public onlyOwner {
115         for(uint i=0; i < _addresses.length; i++) {
116             admins[_addresses[i]] = true;
117         }
118        
119         emit AdminsAdded(_addresses);
120     }
121    
122     /**
123     * @dev Allows the current owner to remove administratiors
124     * @param _address Address of the administrator that needs to be disabled.
125     */
126     function unsetAdministrator(address _address) public onlyOwner {
127         admins[_address] = false;
128     }
129    
130     /**
131     * @dev Checks whether an address is administrator or not
132     * @param addr Address that we are checking.
133     */
134     function isAdmin(address addr) public view returns (bool) {
135  
136         return admins[addr];
137     }
138    
139     /**
140     * @dev Allows the current owner to whitelist addresses
141     * @param _addresses An array of addresses to whitelist.
142     */
143     function whitelistAddresses(address[] memory _addresses) public onlyAdmin {
144         for(uint i=0; i < _addresses.length; i++) {
145             whitelist[_addresses[i]] = true;
146         }
147        
148         emit Whitelisted(_addresses);
149     }
150    
151     /**
152     * @dev Allows the admins to remove existing whitelist permissions
153     * @param _address Address of the user that needs to be blacklisted.
154     */
155     function unsetWhitelist(address _address) public onlyAdmin {
156         whitelist[_address] = false;
157     }
158    
159     /**
160     * @dev Checks whether an address is whitelisted or not
161     * @param addr Address that we are checking.
162     */
163     function isWhitelisted(address addr) public view returns (bool) {
164  
165         return whitelist[addr];
166     }
167  
168     function totalSupply() public view returns (uint256) {
169         return salesPool + retainedPool;
170     }
171    
172     function getsalesSupply() public pure returns (uint256) {
173         return salesPool;
174     }
175    
176     function getRetainedSupply() public pure returns (uint256) {
177         return retainedPool;
178     }
179    
180     function getIssuedsalesSupply() public view returns (uint256) {
181         return salesIssued;
182     }
183    
184     function getIssuedRetainedSupply() public view returns (uint256) {
185         return retainedIssued;
186     }
187    
188  
189     /* Get the account balance for an address */
190     function balanceOf(address _owner) public view returns (uint256) {
191         return balances[_owner];
192     }
193  
194  
195  
196     /* Transfer the balance from owner's account to another account */
197     function transfer(address _to, uint256 _amount) public returns (bool) {
198  
199         require(_to != address(0x0));
200  
201  
202         // amount sent cannot exceed balance
203         require(balances[msg.sender] >= _amount);
204        
205         require(isTransferAllowed);
206         require(isIcoRunning);
207  
208        
209         // update balances
210         balances[msg.sender] = balances[msg.sender].sub(_amount);
211         balances[_to]        = balances[_to].add(_amount);
212  
213         // log event
214         emit Transfer(msg.sender, _to, _amount);
215        
216         return true;
217     }
218    
219     /* Sales transfer of balance from admin to investor */
220     /* Amount includes the 2 decimal places, so if you want to send 22,54 tokens the amount should be 2254 */
221     /* If you want to send 20 tokens, the amount should be 2000 */
222     function salesTransfer(address _to, uint256 _amount) public onlyAdmin returns (bool) {
223         require(isWhitelisted(_to));
224        
225         require(_to != address(0x0));
226        
227         require(salesPool >= salesIssued + _amount);
228        
229  
230         balances[_to] = balances[_to].add(_amount);
231         salesIssued = salesIssued.add(_amount);
232        
233         emit Transfer(address(0x0), _to, _amount);
234        
235         return true;
236        
237     }
238    
239     function retainedTransfer(address _to, uint256 _amount) public onlyOwner returns (bool) {
240         require(isWhitelisted(_to));
241        
242         require(_to != address(0x0));
243        
244         require(retainedPool >= retainedIssued + _amount);
245        
246        
247         balances[_to] = balances[_to].add(_amount);
248         retainedIssued = retainedIssued.add(_amount);
249        
250         emit Transfer(address(0x0), _to, _amount);
251        
252         return true;
253     }
254    
255     /* Allow _spender to withdraw from your account up to _amount */
256     function approve(address _spender, uint256 _amount) public returns (bool) {
257        
258         require(_spender != address(0x0));
259  
260         // update allowed amount
261         allowed[msg.sender][_spender] = _amount;
262  
263         // log event
264         emit Approval(msg.sender, _spender, _amount);
265        
266         return true;
267     }
268  
269     /* Spender of tokens transfers tokens from the owner's balance */
270     /* Must be pre-approved by owner */
271     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
272        
273         require(_to != address(0x0));
274        
275  
276         // balance checks
277         require(balances[_from] >= _amount);
278         require(allowed[_from][msg.sender] >= _amount);
279        
280         require(isTransferAllowed);
281         require(isIcoRunning);
282  
283         // update balances and allowed amount
284         balances[_from]            = balances[_from].sub(_amount);
285         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
286         balances[_to]              = balances[_to].add(_amount);
287  
288         // log event
289         emit Transfer(_from, _to, _amount);
290        
291         return true;
292     }
293  
294     /* Returns the amount of tokens approved by the owner */
295     /* that can be transferred by spender */
296     function allowance(address _owner, address _spender) public view returns (uint256) {
297         return allowed[_owner][_spender];
298     }
299    
300     function withdrawTo(address payable _to) public onlyOwner {
301         require(_to != address(0));
302         _to.transfer(address(this).balance);
303     }
304  
305     function withdrawToOwner() public onlyOwner {
306         withdrawTo(msg.sender);
307     }
308 }