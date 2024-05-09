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
114         require(_value > 0);
115         require(_value <= balances[msg.sender]);
116         
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         Transfer(msg.sender, _to, _value);
120         return true;
121     }
122 
123     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
124     /// @param _from Address from where tokens are withdrawn.
125     /// @param _to Address to where tokens are sent.
126     /// @param _value Number of tokens to transfer.
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
128         require(_to != address(0));
129         require(_value > 0);
130         require(_value <= balances[_from]);
131         require(_value <= allowed[_from][msg.sender]);
132         
133         balances[_to] = balances[_to].add(_value);
134         balances[_from] = balances[_from].sub(_value);
135         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136         Transfer(_from, _to, _value);
137         return true;
138     }
139 
140     /// @dev Sets approved amount of tokens for spender. Returns success.
141     /// @param _spender Address of allowed account.
142     /// @param _value Number of approved tokens.
143     function approve(address _spender, uint256 _value) public returns (bool) {
144         allowed[msg.sender][_spender] = _value;
145         Approval(msg.sender, _spender, _value);
146         return true;
147     }
148 
149     /// @dev Returns number of allowed tokens for given address.
150     /// @param _owner Address of token owner.
151     /// @param _spender Address of token spender.
152     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
153         return allowed[_owner][_spender];
154     }
155 }
156 
157 contract CommonToken is StandardToken, MultiOwnable {
158     
159     string public name   = 'FTEC';
160     string public symbol = 'FTEC';
161     uint8 public decimals = 18;
162     
163     uint256 public saleLimit;   // 85% of tokens for sale.
164     uint256 public teamTokens;  // 7% of tokens goes to the team and will be locked for 1 year.
165     
166     // 7% of team tokens will be locked at this address for 1 year.
167     address public teamWallet; // Team address.
168     
169     uint public unlockTeamTokensTime = now + 1 years;
170 
171     // The main account that holds all tokens at the beginning and during tokensale.
172     address public seller; // Seller address (main holder of tokens)
173 
174     uint256 public tokensSold; // (e18) Number of tokens sold through all tiers or tokensales.
175     uint256 public totalSales; // Total number of sales (including external sales) made through all tiers or tokensales.
176 
177     // Lock the transfer functions during tokensales to prevent price speculations.
178     bool public locked = true;
179     
180     event SellEvent(address indexed _seller, address indexed _buyer, uint256 _value);
181     event ChangeSellerEvent(address indexed _oldSeller, address indexed _newSeller);
182     event Burn(address indexed _burner, uint256 _value);
183     event Unlock();
184 
185     function CommonToken(
186         address _seller,
187         address _teamWallet
188     ) MultiOwnable() public {
189         
190         totalSupply = 998400000 ether;
191         saleLimit   = 848640000 ether;
192         teamTokens  =  69888000 ether;
193 
194         seller = _seller;
195         teamWallet = _teamWallet;
196 
197         uint sellerTokens = totalSupply.sub(teamTokens);
198         balances[seller] = sellerTokens;
199         Transfer(0x0, seller, sellerTokens);
200         
201         balances[teamWallet] = teamTokens;
202         Transfer(0x0, teamWallet, teamTokens);
203     }
204     
205     modifier ifUnlocked(address _from) {
206         require(!locked);
207         
208         // If requested a transfer from the team wallet:
209         if (_from == teamWallet) {
210             require(now >= unlockTeamTokensTime);
211         }
212         
213         _;
214     }
215     
216     /** Can be called once by super owner. */
217     function unlock() onlyOwner public {
218         require(locked);
219         locked = false;
220         Unlock();
221     }
222 
223     function changeSeller(address newSeller) onlyOwner public returns (bool) {
224         require(newSeller != address(0));
225         require(seller != newSeller);
226 
227         address oldSeller = seller;
228         uint256 unsoldTokens = balances[oldSeller];
229         balances[oldSeller] = 0;
230         balances[newSeller] = balances[newSeller].add(unsoldTokens);
231         Transfer(oldSeller, newSeller, unsoldTokens);
232 
233         seller = newSeller;
234         ChangeSellerEvent(oldSeller, newSeller);
235         
236         return true;
237     }
238 
239     function sellNoDecimals(address _to, uint256 _value) public returns (bool) {
240         return sell(_to, _value * 1e18);
241     }
242 
243     function sell(address _to, uint256 _value) onlyOwner public returns (bool) {
244 
245         // Check that we are not out of limit and still can sell tokens:
246         require(tokensSold.add(_value) <= saleLimit);
247 
248         require(_to != address(0));
249         require(_value > 0);
250         require(_value <= balances[seller]);
251 
252         balances[seller] = balances[seller].sub(_value);
253         balances[_to] = balances[_to].add(_value);
254         Transfer(seller, _to, _value);
255 
256         totalSales++;
257         tokensSold = tokensSold.add(_value);
258         SellEvent(seller, _to, _value);
259 
260         return true;
261     }
262     
263     /**
264      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
265      */
266     function transfer(address _to, uint256 _value) ifUnlocked(msg.sender) public returns (bool) {
267         return super.transfer(_to, _value);
268     }
269 
270     /**
271      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
272      */
273     function transferFrom(address _from, address _to, uint256 _value) ifUnlocked(_from) public returns (bool) {
274         return super.transferFrom(_from, _to, _value);
275     }
276 
277     function burn(uint256 _value) public returns (bool) {
278         require(_value > 0);
279         require(_value <= balances[msg.sender]);
280 
281         balances[msg.sender] = balances[msg.sender].sub(_value) ;
282         totalSupply = totalSupply.sub(_value);
283         Transfer(msg.sender, 0x0, _value);
284         Burn(msg.sender, _value);
285 
286         return true;
287     }
288 }
289 
290 contract ProdToken is CommonToken {
291     function ProdToken() CommonToken(
292         0x2c21095Ef1E885eB398C802E70DE839311D0B889, 
293         0xB66aDcdba22BDb8597399DbC23d5bE123F239A7E  
294     ) public {}
295 }