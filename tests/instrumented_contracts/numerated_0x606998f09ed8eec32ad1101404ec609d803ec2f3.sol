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
32   /** 
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   function Ownable() public{
37     owner = msg.sender;
38   }
39 
40   /**
41    * @dev Throws if called by any account other than the owner. 
42    */
43   modifier onlyOwner() {
44     require(owner==msg.sender);
45     _;
46  }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to. 
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53       owner = newOwner;
54   }
55 }
56   
57 contract ERC20 {
58     function totalSupply() public constant returns (uint256);
59     function balanceOf(address who) public constant returns (uint256);
60     function transfer(address to, uint256 value) public returns (bool success);
61     function transferFrom(address from, address to, uint256 value) public returns (bool success);
62     function approve(address spender, uint256 value) public returns (bool success);
63     function allowance(address owner, address spender) public constant returns (uint256);
64 
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 contract BetleyToken is Ownable, ERC20 {
70 
71     using SafeMath for uint256;
72 
73     // Token properties
74     string public name = "BetleyToken";               //Token name
75     string public symbol = "BETS";                     //Token symbol
76     uint256 public decimals = 18;
77 
78     uint256 public _totalSupply = 1000000000e18;       //100% Total Supply
79 	
80     uint256 public _mainsaleSupply = 350000000e18;     //35% Main Sale
81     uint256 public _presaleSupply = 650000000e18;      //65% Pre Sale
82 	
83     uint256 public _saleSupply = 390000000e18;         //60% Sale
84     uint256 public _teamSupply = 65000000e18;          //10% Team
85     uint256 public _advisorsSupply = 55250000e18;      //8.5% Advisors
86     uint256 public _platformSupply = 130000000e18;     //20% Platform
87     uint256 public _bountySupply = 9750000e18;         //1.5% Bounty
88 
89     // Address of owners who will get distribution tokens
90     address private _teamAddress = 0x5cFDe81cF1ACa91Ff8b7fEa63cFBF81B713BBf00;
91     address private _advisorsAddress = 0xC9F2DE0826235767c95254E1887e607d9Af7aA81;
92     address private _platformAddress = 0x572eE1910DD287FCbB109320098B7EcC33CB7e51;
93     address private _bountyAddress = 0xb496FB1F0660CccA92D1B4B199eDcC4Eb8992bfA;
94     uint256 public isDistributionTransferred = 0;
95 
96     // Balances for each account
97     mapping (address => uint256) balances;
98 
99     // Owner of account approves the transfer of an amount to another account
100     mapping (address => mapping(address => uint256)) allowed;
101     
102     // start and end timestamps where investments are allowed (both inclusive)
103     uint256 public preSaleStartTime; 
104     uint256 public mainSaleStartTime;
105 
106     // Wallet Address of Token
107     address public multisig;
108 
109     // Wallet Adddress of Secured User
110     address public sec_addr;
111 
112     // how many token units a buyer gets per wei
113     uint256 public price;
114 
115     uint256 public minContribAmount = 0.1 ether;
116     uint256 public maxContribAmount = 100 ether;
117 
118     uint256 public hardCap = 30000 ether;
119     uint256 public softCap = 1200 ether;
120     
121     //number of total tokens sold 
122     uint256 public presaleTotalNumberTokenSold=0;
123     uint256 public mainsaleTotalNumberTokenSold=0;
124 
125     bool public tradable = false;
126 
127     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
128 
129     modifier canTradable() {
130         require(tradable || ((now < mainSaleStartTime + 30 days) && (now > preSaleStartTime)));
131         _;
132     }
133 
134     // Constructor
135     // @notice BetleyToken Contract
136     // @return the transaction address
137     function BetleyToken() public{
138         // Initial Owner Wallet Address
139         multisig = 0x7BAD2a7C2c2E83f0a6E9Afbd3cC0029391F3B013;
140 
141         balances[multisig] = _totalSupply;
142 
143         preSaleStartTime = 1527811200; // June 1st 10:00 AEST
144         mainSaleStartTime = 1533081600; // August 1st 10:00 AEST
145 
146         owner = msg.sender;
147 
148         sendTeamSupplyToken(_teamAddress);
149         sendAdvisorsSupplyToken(_advisorsAddress);
150         sendPlatformSupplyToken(_platformAddress);
151         sendBountySupplyToken(_bountyAddress);
152         isDistributionTransferred = 1;
153     }
154 
155     // Payable method
156     // @notice Anyone can buy the tokens on tokensale by paying ether
157     function () external payable {
158         tokensale(msg.sender);
159     }
160 
161     // @notice tokensale
162     // @param recipient The address of the recipient
163     // @return the transaction address and send the event as Transfer
164     function tokensale(address recipient) public payable {
165         require(recipient != 0x0);
166         require(msg.value >= minContribAmount && msg.value <= maxContribAmount);
167         price = getPrice();
168         uint256 weiAmount = msg.value;
169         uint256 tokenToSend = weiAmount.mul(price);
170         
171         require(tokenToSend > 0);
172         if ((now > preSaleStartTime) && (now < preSaleStartTime + 60 days)) {
173 		
174 			require(_presaleSupply >= tokenToSend);
175 		
176         } else if ((now > mainSaleStartTime) && (now < mainSaleStartTime + 30 days)) {
177             	
178             require(_mainsaleSupply >= tokenToSend);
179         
180 		}
181         
182         balances[multisig] = balances[multisig].sub(tokenToSend);
183         balances[recipient] = balances[recipient].add(tokenToSend);
184         
185         if ((now > preSaleStartTime) && (now < preSaleStartTime + 60 days)) {
186             
187 			presaleTotalNumberTokenSold = presaleTotalNumberTokenSold.add(tokenToSend);
188             _presaleSupply = _presaleSupply.sub(tokenToSend);
189         
190 		} else if ((now > mainSaleStartTime) && (now < mainSaleStartTime + 30 days)) {
191             
192 			mainsaleTotalNumberTokenSold = mainsaleTotalNumberTokenSold.add(tokenToSend);
193             _mainsaleSupply = _mainsaleSupply.sub(tokenToSend);
194         
195 		}
196 
197         address tar_addr = multisig;
198         if (presaleTotalNumberTokenSold + mainsaleTotalNumberTokenSold > 10000000) { // Transfers ETHER to wallet after softcap is hit
199             tar_addr = sec_addr;
200         }
201         tar_addr.transfer(msg.value);
202         TokenPurchase(msg.sender, recipient, weiAmount, tokenToSend);
203     }
204 
205     // Security Wallet address setting
206     function setSecurityWalletAddr(address addr) public onlyOwner {
207         sec_addr = addr;
208     }
209 
210     // Token distribution to Team
211     function sendTeamSupplyToken(address to) public onlyOwner {
212         require ((to != 0x0) && (isDistributionTransferred == 0));
213 
214         balances[multisig] = balances[multisig].sub(_teamSupply);
215         balances[to] = balances[to].add(_teamSupply);
216         Transfer(multisig, to, _teamSupply);
217     }
218 
219     // Token distribution to Advisors
220     function sendAdvisorsSupplyToken(address to) public onlyOwner {
221         require ((to != 0x0) && (isDistributionTransferred == 0));
222 
223         balances[multisig] = balances[multisig].sub(_advisorsSupply);
224         balances[to] = balances[to].add(_advisorsSupply);
225         Transfer(multisig, to, _advisorsSupply);
226     }
227     
228     // Token distribution to Platform
229     function sendPlatformSupplyToken(address to) public onlyOwner {
230         require ((to != 0x0) && (isDistributionTransferred == 0));
231 
232         balances[multisig] = balances[multisig].sub(_platformSupply);
233         balances[to] = balances[to].add(_platformSupply);
234         Transfer(multisig, to, _platformSupply);
235     }
236     
237     // Token distribution to Bounty
238     function sendBountySupplyToken(address to) public onlyOwner {
239         require ((to != 0x0) && (isDistributionTransferred == 0));
240 
241         balances[multisig] = balances[multisig].sub(_bountySupply);
242         balances[to] = balances[to].add(_bountySupply);
243         Transfer(multisig, to, _bountySupply);
244     }
245     
246     // Start or pause tradable to Transfer token
247     function startTradable(bool _tradable) public onlyOwner {
248         tradable = _tradable;
249     }
250 
251     // @return total tokens supplied
252     function totalSupply() public constant returns (uint256) {
253         return _totalSupply;
254     }
255     
256     // @return total tokens supplied
257     function presaleTotalNumberTokenSold() public view returns (uint256) {
258         return presaleTotalNumberTokenSold;
259     }
260 
261     // What is the balance of a particular account?
262     // @param who The address of the particular account
263     // @return the balanace the particular account
264     function balanceOf(address who) public constant returns (uint256) {
265         return balances[who];
266     }
267 
268     // @notice send `value` token to `to` from `msg.sender`
269     // @param to The address of the recipient
270     // @param value The amount of token to be transferred
271     // @return the transaction address and send the event as Transfer
272     function transfer(address to, uint256 value) public canTradable returns (bool success)  {
273         require (
274             balances[msg.sender] >= value && value > 0
275         );
276         balances[msg.sender] = balances[msg.sender].sub(value);
277         balances[to] = balances[to].add(value);
278         Transfer(msg.sender, to, value);
279         return true;
280     }
281 
282     // @notice send `value` token to `to` from `from`
283     // @param from The address of the sender
284     // @param to The address of the recipient
285     // @param value The amount of token to be transferred
286     // @return the transaction address and send the event as Transfer
287     function transferFrom(address from, address to, uint256 value) public canTradable returns (bool success)  {
288         require (
289             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
290         );
291         balances[from] = balances[from].sub(value);
292         balances[to] = balances[to].add(value);
293         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
294         Transfer(from, to, value);
295         return true;
296     }
297 
298     // Allow spender to withdraw from your account, multiple times, up to the value amount.
299     // If this function is called again it overwrites the current allowance with value.
300     // @param spender The address of the sender
301     // @param value The amount to be approved
302     // @return the transaction address and send the event as Approval
303     function approve(address spender, uint256 value) public returns (bool success)  {
304         require (
305             balances[msg.sender] >= value && value > 0
306         );
307         allowed[msg.sender][spender] = value;
308         Approval(msg.sender, spender, value);
309         return true;
310     }
311 
312     // Check the allowed value for the spender to withdraw from owner
313     // @param owner The address of the owner
314     // @param spender The address of the spender
315     // @return the amount which spender is still allowed to withdraw from owner
316     function allowance(address _owner, address spender) public constant returns (uint256) {
317         return allowed[_owner][spender];
318     }
319     
320     // Get current price of a Token
321     // @return the price or token value for a ether
322     function getPrice() public view returns (uint256 result) {
323         if ((now > preSaleStartTime) && (now < preSaleStartTime + 60 days) && (presaleTotalNumberTokenSold < _saleSupply)) {
324             
325 			if ((now > preSaleStartTime) && (now < preSaleStartTime + 14 days)) {
326                 return 15000;
327             } else if ((now >= preSaleStartTime + 14 days) && (now < preSaleStartTime + 28 days)) {
328                 return 13000;
329             } else if ((now >= preSaleStartTime + 28 days) && (now < preSaleStartTime + 42 days)) {
330                 return 11000;
331             } else if ((now >= preSaleStartTime + 42 days)) {
332                 return 10500;
333             }
334 			
335         } else if ((now > mainSaleStartTime) && (now < mainSaleStartTime + 30 days) && (mainsaleTotalNumberTokenSold < _mainsaleSupply)) {
336             if ((now > mainSaleStartTime) && (now < mainSaleStartTime + 30 days)) {
337                 return 10000;
338             }
339         } else {
340             return 0;
341         }
342     }
343 }