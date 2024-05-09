1 // our mirrors:
2 // ftec.io
3 // ftec.ai 
4 // our official Telegram group:
5 // t.me/FTECofficial
6 
7 pragma solidity ^0.4.18;
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a * b;
17         assert(a == 0 || c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 contract MultiOwnable {
41 
42     mapping (address => bool) public isOwner;
43     address[] public ownerHistory;
44 
45     event OwnerAddedEvent(address indexed _newOwner);
46     event OwnerRemovedEvent(address indexed _oldOwner);
47 
48     function MultiOwnable() public {
49         // Add default owner
50         address owner = msg.sender;
51         ownerHistory.push(owner);
52         isOwner[owner] = true;
53     }
54 
55     modifier onlyOwner() {
56         require(isOwner[msg.sender]);
57         _;
58     }
59     
60     function ownerHistoryCount() public view returns (uint) {
61         return ownerHistory.length;
62     }
63 
64     /** Add extra owner. */
65     function addOwner(address owner) onlyOwner public {
66         require(owner != address(0));
67         require(!isOwner[owner]);
68         ownerHistory.push(owner);
69         isOwner[owner] = true;
70         OwnerAddedEvent(owner);
71     }
72 
73     /** Remove extra owner. */
74     function removeOwner(address owner) onlyOwner public {
75         require(isOwner[owner]);
76         isOwner[owner] = false;
77         OwnerRemovedEvent(owner);
78     }
79 }
80 
81 contract ERC20 {
82 
83     uint256 public totalSupply;
84 
85     function balanceOf(address _owner) public view returns (uint256 balance);
86 
87     function transfer(address _to, uint256 _value) public returns (bool success);
88 
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
90 
91     function approve(address _spender, uint256 _value) public returns (bool success);
92 
93     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     
97     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
98 }
99 
100 contract StandardToken is ERC20 {
101     
102     using SafeMath for uint;
103 
104     mapping(address => uint256) balances;
105     
106     mapping(address => mapping(address => uint256)) allowed;
107 
108     function balanceOf(address _owner) public view returns (uint256 balance) {
109         return balances[_owner];
110     }
111 
112     function transfer(address _to, uint256 _value) public returns (bool) {
113         require(_to != address(0));
114         
115         balances[msg.sender] = balances[msg.sender].sub(_value);
116         balances[_to] = balances[_to].add(_value);
117         Transfer(msg.sender, _to, _value);
118         return true;
119     }
120 
121     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
122     /// @param _from Address from where tokens are withdrawn.
123     /// @param _to Address to where tokens are sent.
124     /// @param _value Number of tokens to transfer.
125     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126         require(_to != address(0));
127         
128         balances[_from] = balances[_from].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131         Transfer(_from, _to, _value);
132         return true;
133     }
134 
135     /// @dev Sets approved amount of tokens for spender. Returns success.
136     /// @param _spender Address of allowed account.
137     /// @param _value Number of approved tokens.
138     function approve(address _spender, uint256 _value) public returns (bool) {
139         allowed[msg.sender][_spender] = _value;
140         Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     /// @dev Returns number of allowed tokens for given address.
145     /// @param _owner Address of token owner.
146     /// @param _spender Address of token spender.
147     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
148         return allowed[_owner][_spender];
149     }
150 }
151 
152 contract CommonToken is StandardToken, MultiOwnable {
153     
154     string public constant name   = 'FTEC';
155     string public constant symbol = 'FTEC';
156     uint8 public constant decimals = 18;
157     
158     uint256 public saleLimit;   // 85% of tokens for sale.
159     uint256 public teamTokens;  // 7% of tokens goes to the team and will be locked for 1 year.
160     // 8% of the rest tokens will be used for bounty, advisors, and airdrops.
161     
162     // 7% of team tokens will be locked at this address for 1 year.
163     address public teamWallet; // Team address.
164     
165     uint public unlockTeamTokensTime = now + 1 years;
166 
167     // The main account that holds all tokens at the beginning and during tokensale.
168     address public seller; // Seller address (main holder of tokens)
169 
170     uint256 public tokensSold; // (e18) Number of tokens sold through all tiers or tokensales.
171     uint256 public totalSales; // Total number of sales (including external sales) made through all tiers or tokensales.
172 
173     // Lock the transfer functions during tokensales to prevent price speculations.
174     bool public locked = true;
175     
176     event SellEvent(address indexed _seller, address indexed _buyer, uint256 _value);
177     event ChangeSellerEvent(address indexed _oldSeller, address indexed _newSeller);
178     event Burn(address indexed _burner, uint256 _value);
179     event Unlock();
180 
181     function CommonToken(
182         address _seller,
183         address _teamWallet
184     ) MultiOwnable() public {
185         
186         totalSupply = 998400000 ether;
187         saleLimit   = 848640000 ether;
188         teamTokens  =  69888000 ether;
189 
190         seller = _seller;
191         teamWallet = _teamWallet;
192 
193         uint sellerTokens = totalSupply - teamTokens;
194         balances[seller] = sellerTokens;
195         Transfer(0x0, seller, sellerTokens);
196         
197         balances[teamWallet] = teamTokens;
198         Transfer(0x0, teamWallet, teamTokens);
199     }
200     
201     modifier ifUnlocked(address _from) {
202         require(!locked);
203         
204         // If requested a transfer from the team wallet:
205         if (_from == teamWallet) {
206             require(now >= unlockTeamTokensTime);
207         }
208         
209         _;
210     }
211     
212     /** Can be called once by super owner. */
213     function unlock() onlyOwner public {
214         require(locked);
215         locked = false;
216         Unlock();
217     }
218 
219     /**
220      * An address can become a new seller only in case it has no tokens.
221      * This is required to prevent stealing of tokens  from newSeller via 
222      * 2 calls of this function.
223      */
224     function changeSeller(address newSeller) onlyOwner public returns (bool) {
225         require(newSeller != address(0));
226         require(seller != newSeller);
227         
228         // To prevent stealing of tokens from newSeller via 2 calls of changeSeller:
229         require(balances[newSeller] == 0);
230 
231         address oldSeller = seller;
232         uint256 unsoldTokens = balances[oldSeller];
233         balances[oldSeller] = 0;
234         balances[newSeller] = unsoldTokens;
235         Transfer(oldSeller, newSeller, unsoldTokens);
236 
237         seller = newSeller;
238         ChangeSellerEvent(oldSeller, newSeller);
239         return true;
240     }
241 
242     /**
243      * User-friendly alternative to sell() function.
244      */
245     function sellNoDecimals(address _to, uint256 _value) public returns (bool) {
246         return sell(_to, _value * 1e18);
247     }
248 
249     function sell(address _to, uint256 _value) onlyOwner public returns (bool) {
250 
251         // Check that we are not out of limit and still can sell tokens:
252         require(tokensSold.add(_value) <= saleLimit);
253 
254         require(_to != address(0));
255         require(_value > 0);
256         require(_value <= balances[seller]);
257 
258         balances[seller] = balances[seller].sub(_value);
259         balances[_to] = balances[_to].add(_value);
260         Transfer(seller, _to, _value);
261 
262         totalSales++;
263         tokensSold = tokensSold.add(_value);
264         SellEvent(seller, _to, _value);
265         return true;
266     }
267     
268     /**
269      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
270      */
271     function transfer(address _to, uint256 _value) ifUnlocked(msg.sender) public returns (bool) {
272         return super.transfer(_to, _value);
273     }
274 
275     /**
276      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
277      */
278     function transferFrom(address _from, address _to, uint256 _value) ifUnlocked(_from) public returns (bool) {
279         return super.transferFrom(_from, _to, _value);
280     }
281 
282     function burn(uint256 _value) public returns (bool) {
283         require(_value > 0);
284 
285         balances[msg.sender] = balances[msg.sender].sub(_value);
286         totalSupply = totalSupply.sub(_value);
287         Transfer(msg.sender, 0x0, _value);
288         Burn(msg.sender, _value);
289         return true;
290     }
291 }
292 
293 contract ProdToken is CommonToken {
294     function ProdToken() CommonToken(
295         0x292FDFdD7E2967fc0251e35A2eF6CBA3F312dAd7, 
296         0x5f448809De9e2bBe3120005D94e4D7C0D84d3710  
297     ) public {}
298 }