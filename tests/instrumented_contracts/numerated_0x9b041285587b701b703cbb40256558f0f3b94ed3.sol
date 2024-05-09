1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b); 
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /** 
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() public{
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner. 
44    */
45   modifier onlyOwner() {
46     require(owner==msg.sender);
47     _;
48  }
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to. 
53    */
54   function transferOwnership(address newOwner) public onlyOwner {
55       owner = newOwner;
56   }
57  
58 }
59   
60 contract ERC20 {
61 
62     function totalSupply() public constant returns (uint256);
63     function balanceOf(address who) public constant returns (uint256);
64     function transfer(address to, uint256 value) public returns (bool success);
65     function transferFrom(address from, address to, uint256 value) public returns (bool success);
66     function approve(address spender, uint256 value) public returns (bool success);
67     function allowance(address owner, address spender) public constant returns (uint256);
68 
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 
72 }
73 
74 contract CBITToken is Ownable, ERC20 {
75 
76     using SafeMath for uint256;
77 
78     // Token properties
79     string public name = "CAMBITUS";
80     string public symbol = "CBIT";
81     uint256 public decimals = 18;
82 
83     uint256 public _totalSupply = 250000000e18;
84     uint256 public _icoSupply = 156250000e18;       //62.5%
85     uint256 public _preSaleSupply = 43750000e18;    //17.5%
86     uint256 public _phase1Supply = 50000000e18;     //20%
87     uint256 public _phase2Supply = 50000000e18;     //20%
88     uint256 public _finalSupply = 12500000e18;      //5%
89     uint256 public _teamSupply = 43750000e18;       //17.5%
90     uint256 public _communitySupply = 12500000e18;  //5%
91     uint256 public _bountySupply = 12500000e18;     //5%
92     uint256 public _ecosysSupply = 25000000e18;     //10%
93 
94     // Balances for each account
95     mapping (address => uint256) balances;
96 
97     // Owner of account approves the transfer of an amount to another account
98     mapping (address => mapping(address => uint256)) allowed;
99     
100     // start and end timestamps where investments are allowed (both inclusive)
101     uint256 public startTime; 
102 
103     // Wallet Address of Token
104     address public multisig;
105 
106     // how many token units a buyer gets per wei
107     uint256 public price;
108 
109     uint256 public minContribAmount = 1 ether;
110 
111     uint256 public maxCap = 81000 ether;
112     uint256 public minCap = 450 ether;
113     
114     //number of total tokens sold 
115     uint256 public totalNumberTokenSold=0;
116 
117     bool public tradable = false;
118 
119     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
120 
121     modifier canTradable() {
122         require(tradable || (now > startTime + 180 days));
123         _;
124     }
125 
126     // Constructor
127     // @notice CBITToken Contract
128     // @return the transaction address
129     function CBITToken() public{
130         multisig = 0xAfC252F597bd592276C6846cD44d1F82d87e63a2;
131 
132         balances[multisig] = _totalSupply;
133 
134         startTime = 1525150800;
135         owner = msg.sender;
136     }
137 
138     // Payable method
139     // @notice Anyone can buy the tokens on tokensale by paying ether
140     function () external payable {
141         
142         tokensale(msg.sender);
143     }
144 
145     // @notice tokensale
146     // @param recipient The address of the recipient
147     // @return the transaction address and send the event as Transfer
148     function tokensale(address recipient) public payable {
149         require(recipient != 0x0);
150         require(msg.value >= minContribAmount);
151         price = getPrice();
152         uint256 weiAmount = msg.value;
153         uint256 tokenToSend = weiAmount.mul(price);
154         
155         require(tokenToSend > 0);
156         require(_icoSupply >= tokenToSend);
157         
158         balances[multisig] = balances[multisig].sub(tokenToSend);
159         balances[recipient] = balances[recipient].add(tokenToSend);
160         
161         totalNumberTokenSold=totalNumberTokenSold.add(tokenToSend);
162         _icoSupply = _icoSupply.sub(tokenToSend);
163 
164 	    multisig.transfer(msg.value);
165         TokenPurchase(msg.sender, recipient, weiAmount, tokenToSend);
166     }
167     
168     // Token distribution to Team
169     function sendICOSupplyToken(address to, uint256 value) public onlyOwner {
170         require (
171             to != 0x0 && value > 0 && _icoSupply >= value
172         );
173 
174         balances[multisig] = balances[multisig].sub(value);
175         balances[to] = balances[to].add(value);
176         _icoSupply = _icoSupply.sub(value);
177         totalNumberTokenSold=totalNumberTokenSold.add(value);
178         Transfer(multisig, to, value);
179     }
180 
181     // Token distribution to Team
182     function sendTeamSupplyToken(address to, uint256 value) public onlyOwner {
183         require (
184             to != 0x0 && value > 0 && _teamSupply >= value
185         );
186 
187         balances[multisig] = balances[multisig].sub(value);
188         balances[to] = balances[to].add(value);
189         totalNumberTokenSold=totalNumberTokenSold.add(value);
190         _teamSupply = _teamSupply.sub(value);
191         Transfer(multisig, to, value);
192     }
193     
194     // Token distribution to Community
195     function sendCommunitySupplyToken(address to, uint256 value) public onlyOwner {
196         require (
197             to != 0x0 && value > 0 && _communitySupply >= value
198         );
199 
200         balances[multisig] = balances[multisig].sub(value);
201         balances[to] = balances[to].add(value);
202         totalNumberTokenSold=totalNumberTokenSold.add(value);
203         _communitySupply = _communitySupply.sub(value);
204         Transfer(multisig, to, value);
205     }
206     
207     // Token distribution to Bounty
208     function sendBountySupplyToken(address to, uint256 value) public onlyOwner {
209         require (
210             to != 0x0 && value > 0 && _bountySupply >= value
211         );
212 
213         balances[multisig] = balances[multisig].sub(value);
214         balances[to] = balances[to].add(value);
215         totalNumberTokenSold=totalNumberTokenSold.add(value);
216         _bountySupply = _bountySupply.sub(value);
217         Transfer(multisig, to, value);
218     }
219     
220     // Token distribution to Ecosystem
221     function sendEcosysSupplyToken(address to, uint256 value) public onlyOwner {
222         require (
223             to != 0x0 && value > 0 && _ecosysSupply >= value
224         );
225 
226         balances[multisig] = balances[multisig].sub(value);
227         balances[to] = balances[to].add(value);
228         totalNumberTokenSold=totalNumberTokenSold.add(value);
229         _ecosysSupply = _ecosysSupply.sub(value);
230         Transfer(multisig, to, value);
231     }
232     
233     // Start or pause tradable to Transfer token
234     function startTradable(bool _tradable) public onlyOwner {
235         tradable = _tradable;
236     }
237 
238     // @return total tokens supplied
239     function totalSupply() public constant returns (uint256) {
240         return _totalSupply;
241     }
242     
243     // @return total tokens supplied
244     function totalNumberTokenSold() public view returns (uint256) {
245         return totalNumberTokenSold;
246     }
247 
248     // What is the balance of a particular account?
249     // @param who The address of the particular account
250     // @return the balanace the particular account
251     function balanceOf(address who) public constant returns (uint256) {
252         return balances[who];
253     }
254 
255     // @notice send `value` token to `to` from `msg.sender`
256     // @param to The address of the recipient
257     // @param value The amount of token to be transferred
258     // @return the transaction address and send the event as Transfer
259     function transfer(address to, uint256 value) public canTradable returns (bool success)  {
260         require (
261             balances[msg.sender] >= value && value > 0
262         );
263         balances[msg.sender] = balances[msg.sender].sub(value);
264         balances[to] = balances[to].add(value);
265         Transfer(msg.sender, to, value);
266         return true;
267     }
268 
269     // @notice send `value` token to `to` from `from`
270     // @param from The address of the sender
271     // @param to The address of the recipient
272     // @param value The amount of token to be transferred
273     // @return the transaction address and send the event as Transfer
274     function transferFrom(address from, address to, uint256 value) public canTradable returns (bool success)  {
275         require (
276             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
277         );
278         balances[from] = balances[from].sub(value);
279         balances[to] = balances[to].add(value);
280         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
281         Transfer(from, to, value);
282         return true;
283     }
284 
285     // Allow spender to withdraw from your account, multiple times, up to the value amount.
286     // If this function is called again it overwrites the current allowance with value.
287     // @param spender The address of the sender
288     // @param value The amount to be approved
289     // @return the transaction address and send the event as Approval
290     function approve(address spender, uint256 value) public returns (bool success)  {
291         require (
292             balances[msg.sender] >= value && value > 0
293         );
294         allowed[msg.sender][spender] = value;
295         Approval(msg.sender, spender, value);
296         return true;
297     }
298 
299     // Check the allowed value for the spender to withdraw from owner
300     // @param owner The address of the owner
301     // @param spender The address of the spender
302     // @return the amount which spender is still allowed to withdraw from owner
303     function allowance(address _owner, address spender) public constant returns (uint256) {
304         return allowed[_owner][spender];
305     }
306     
307         // Get current price of a Token
308     // @return the price or token value for a ether
309     function getPrice() public view returns (uint result) {
310         if ( (now < startTime + 30 days) && (totalNumberTokenSold < _preSaleSupply)) {
311             return 7500;
312         } else if ( (now < startTime + 60 days) && (totalNumberTokenSold < _preSaleSupply + _phase1Supply) ) {
313             return 5000;
314         } else if ( (now < startTime + 90 days) && (totalNumberTokenSold < _preSaleSupply + _phase1Supply + _phase2Supply) ) {
315             return 3125;
316         } else if ( (now < startTime + 99 days) && (totalNumberTokenSold < _preSaleSupply + _phase1Supply + _phase2Supply + _finalSupply) ) {
317             return 1500;
318         } else {
319             return 0;
320         }
321     }
322     
323     function getTokenDetail() public view returns (string, string, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
324         return (name, symbol, _totalSupply, totalNumberTokenSold, _icoSupply, _teamSupply, _communitySupply, _bountySupply, _ecosysSupply);
325     }
326 
327 }