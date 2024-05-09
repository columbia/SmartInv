1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7   constructor() public {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);  _;
13   }
14 
15   function transferOwnership(address newOwner) public onlyOwner {
16     require(newOwner != address(0));
17     emit OwnershipTransferred(owner, newOwner);
18     owner = newOwner;
19   }
20 }
21 
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a / b;
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract ERC20Basic {
50   uint256 public totalSupply;
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender) public view returns (uint256);
58   function transferFrom(address from, address to, uint256 value) public returns (bool);
59   function approve(address spender, uint256 value) public returns (bool);
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 library SafeERC20 {
64   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
65     assert(token.transfer(to, value));
66   }
67 
68   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
69     assert(token.transferFrom(from, to, value));
70   }
71 
72   function safeApprove(ERC20 token, address spender, uint256 value) internal {
73     assert(token.approve(spender, value));
74   }
75 }
76 
77 contract StandardToken is ERC20 {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81   mapping (address => mapping (address => uint256)) internal allowed;
82 
83  function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85     require(_value <= balances[msg.sender]);
86 
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     emit Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   function balanceOf(address _owner) public view returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[_from]);
100     require(_value <= allowed[_from][msg.sender]);
101 
102     balances[_from] = balances[_from].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
105     emit Transfer(_from, _to, _value);
106     return true;
107   }
108 
109   function approve(address _spender, uint256 _value) public returns (bool) {
110     allowed[msg.sender][_spender] = _value;
111     emit Approval(msg.sender, _spender, _value);
112     return true;
113   }
114 
115   function allowance(address _owner, address _spender) public view returns (uint256) {
116     return allowed[_owner][_spender];
117   }
118 
119   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
120     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
121     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122     return true;
123   }
124 
125 
126   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
127     uint oldValue = allowed[msg.sender][_spender];
128     if (_subtractedValue > oldValue) {
129       allowed[msg.sender][_spender] = 0;
130     } else {
131       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
132     }
133     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
134     return true;
135   }
136 }
137 
138 contract TokenTimelock {
139   using SafeERC20 for ERC20Basic;
140   ERC20Basic public token;
141   address public beneficiary;
142   uint256 public releaseTime;
143 
144   constructor(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
145     require(_releaseTime > now);
146     token = _token;
147     beneficiary = _beneficiary;
148     releaseTime = _releaseTime;
149   }
150 
151   function release() public {
152     require(now >= releaseTime);
153 
154     uint256 amount = token.balanceOf(this);
155     require(amount > 0);
156 
157     token.safeTransfer(beneficiary, amount);
158   }
159 }
160 
161 contract MintableToken is StandardToken, Ownable {
162   event Mint(address indexed to, uint256 amount);
163   event MintFinished();
164   bool public mintingFinished = false;
165 
166   modifier canMint() {
167     require(!mintingFinished);
168     _;
169   }
170 
171   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
172     totalSupply = totalSupply.add(_amount);
173     balances[_to] = balances[_to].add(_amount);
174     emit Mint(_to, _amount);
175     emit Transfer(address(0), _to, _amount);
176     return true;
177   }
178 
179   function finishMinting() onlyOwner canMint public returns (bool) {
180     mintingFinished = true;
181     emit MintFinished();
182     return true;
183   }
184 }
185 
186 contract YiqiniuToken is MintableToken {
187     string public constant name		= 'YiqiniuToken';
188     string public constant symbol	= 'YQN';
189     uint256 public constant decimals	= 18;
190     event Burned(address indexed burner, uint256 value);
191     
192     function burn(uint256 _value) public onlyOwner {
193         require(_value > 0);
194 
195         address burner = msg.sender;
196         balances[burner] = balances[burner].sub(_value);
197         totalSupply = totalSupply.sub(_value);
198         emit Burned(burner, _value);
199     }
200 }
201 
202 contract CrowdsaleConfig {
203     uint256 public constant TOKEN_DECIMALS	    = 18;
204     uint256 public constant MIN_TOKEN_UNIT	    = 10 ** uint256(TOKEN_DECIMALS);
205     uint256 public constant TOTAL_SUPPLY_CAP        = 100000000 * MIN_TOKEN_UNIT;
206     uint256 public constant PUBLIC_SALE_TOKEN_CAP   = TOTAL_SUPPLY_CAP / 100 * 30;
207     uint256 public constant AGENCY_TOKEN_CAP        = TOTAL_SUPPLY_CAP / 100 * 20;
208     uint256 public constant TEAM_TOKEN_CAP          = TOTAL_SUPPLY_CAP / 100 * 50;
209     address public constant TEAM_ADDR		    = 0xfB39831DE614384887b775299af811275D08A9b6;
210     address public constant AGENCY_ADDR	            = 0xc849e7225fF088e187136A670662e36adE5A89FC;
211     address public constant WALLET_ADDR	            = 0x1c4139797D88eb0F86126aC5EE21eB9F2b9eE417;
212 }
213 
214 contract YiqiniuCrowdsale is Ownable, CrowdsaleConfig{
215     using SafeMath for uint256;
216     using SafeERC20 for YiqiniuToken;
217 
218     // Token contract
219     YiqiniuToken public token;
220 
221     uint64 public startTime;
222     uint64 public endTime;
223     uint256 public rate = 100000;
224     uint256 public goalSale;
225     uint256 public totalPurchased = 0;
226     bool public CrowdsaleEnabled = false;
227     mapping(address => bool) public isVerified;
228     mapping(address => uint256) public tokensPurchased;
229     uint256 public maxTokenPurchase = 100000 * MIN_TOKEN_UNIT;
230     uint256 public minTokenPurchase = 1 * MIN_TOKEN_UNIT;
231     TokenTimelock public AgencyLock1;
232     TokenTimelock public AgencyLock2;
233     
234     event NewYiqiniuToken(address _add);
235 
236     constructor() public {
237         startTime = uint64(now);
238         endTime = uint64(now + 3600*24*4);
239         goalSale = PUBLIC_SALE_TOKEN_CAP / 100 * 50;
240         
241         token = new YiqiniuToken();
242         emit NewYiqiniuToken(address(token));
243         
244         token.mint(address(this), TOTAL_SUPPLY_CAP);
245         token.finishMinting();
246 
247         uint64 TimeLock1 = uint64(now + 3600*24*5);
248         uint64 TimeLock2 = uint64(now + 3600*24*6);
249 
250         AgencyLock1 = new TokenTimelock(token, AGENCY_ADDR, TimeLock1);
251         AgencyLock2 = new TokenTimelock(token, AGENCY_ADDR, TimeLock2);
252 
253         token.safeTransfer(AgencyLock1, AGENCY_TOKEN_CAP/2);
254         token.safeTransfer(AgencyLock2, AGENCY_TOKEN_CAP/2);
255 
256         token.safeTransfer(TEAM_ADDR,TEAM_TOKEN_CAP);
257     }
258 
259     function releaseLockAgencyLock1() public {
260         AgencyLock1.release();
261     }
262     function releaseLockAgencyLock2() public {
263         AgencyLock2.release();
264     }
265 
266     function () external payable {   
267         buyTokens(msg.sender);
268     }
269     
270     modifier canCrowdsale() {
271         require(CrowdsaleEnabled);
272         _;
273     }
274     
275     function enableCrowdsale() public onlyOwner {
276         CrowdsaleEnabled = true;
277     }
278     
279     function closeCrowdsale() public onlyOwner {
280         CrowdsaleEnabled = false;
281     }
282     
283     function buyTokens(address participant) internal canCrowdsale {
284         require(now >= startTime);
285         require(now < endTime);
286         require(msg.value != 0);
287         require(isVerified[participant]);
288         uint256 weiAmount = msg.value;
289         uint256 tokens = weiAmount.mul(rate);
290         
291         tokensPurchased[participant] = tokensPurchased[participant].add(tokens);
292         require(tokensPurchased[participant] >= minTokenPurchase);
293         require(tokensPurchased[participant] <= maxTokenPurchase);
294         
295         totalPurchased = totalPurchased.add(tokens);
296         token.safeTransfer(participant, tokens);
297     }
298     
299     function setTokenPrice(uint256 _tokenRate) public onlyOwner {
300         require(now > startTime);
301         require(_tokenRate > 0);
302         rate = _tokenRate;
303     }
304     
305     function setLimitTokenPurchase(uint256 _minToken, uint256 _maxToken) public onlyOwner {
306         require(goalSale >= maxTokenPurchase);
307         minTokenPurchase = _minToken;
308         maxTokenPurchase = _maxToken;
309     }
310 
311     function addVerified (address[] _ads) public onlyOwner {
312         for(uint i = 0; i < _ads.length; i++){
313             isVerified[_ads[i]] = true;
314         }
315     }
316 
317     function removeVerified (address _address) public onlyOwner {
318         isVerified[_address] = false;
319     }
320     
321     function close() onlyOwner public {
322         require(now >= endTime || totalPurchased >= goalSale);
323         token.burn(token.balanceOf(this));
324         WALLET_ADDR.transfer(address(this).balance);
325    }
326 }