1 pragma solidity ^0.4.21;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
4         if(a == 0) { return 0; }
5         uint256 c = a * b;
6         assert(c / a == b);
7         return c;
8     }
9     function div(uint256 a, uint256 b) internal pure returns(uint256) {
10         uint256 c = a / b;
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17     function add(uint256 a, uint256 b) internal pure returns(uint256) {
18         uint256 c = a + b;
19         assert(c >= a);
20         return c;
21     }
22 }
23 contract Ownable {
24     address public owner;
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26     modifier onlyOwner() { require(msg.sender == owner); _; }
27     function Ownable() public { 
28 	    owner = msg.sender; 
29 		}
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(this));
32         owner = newOwner;
33         emit OwnershipTransferred(owner, newOwner);
34     }
35 }
36 contract ERC20 {
37     uint256 public totalSupply;
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40     function balanceOf(address who) public view returns(uint256);
41     function transfer(address to, uint256 value) public returns(bool);
42     function transferFrom(address from, address to, uint256 value) public returns(bool);
43     function allowance(address owner, address spender) public view returns(uint256);
44     function approve(address spender, uint256 value) public returns(bool);
45 }
46 contract StandardToken is ERC20{
47     using SafeMath for uint256;
48     string public name;
49     string public symbol;
50     uint8 public decimals;
51     mapping(address => uint256) public balances;
52     mapping (address => mapping (address => uint256)) internal allowed;
53 
54     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
55         name = _name;
56         symbol = _symbol;
57         decimals = _decimals;
58     }
59     function balanceOf(address _owner) public view returns(uint256 balance) {
60         return balances[_owner];
61     }
62 
63 function transfer(address _to, uint256 _value) public returns(bool) {
64         require(_to != address(this));
65         require(_value <= balances[msg.sender]);
66         balances[msg.sender] = balances[msg.sender].sub(_value);
67         balances[_to] = balances[_to].add(_value);
68 		emit Transfer(msg.sender, _to, _value);
69 		return true;
70 }
71 function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
72         require(_to.length == _value.length);
73         for(uint i = 0; i < _to.length; i++) {
74             transfer(_to[i], _value[i]);
75         }
76         return true;
77 }
78 function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
79         require(_to != address(this));
80         require(_value <= balances[_from]);
81         require(_value <= allowed[_from][msg.sender]);
82         balances[_from] = balances[_from].sub(_value);
83         balances[_to] = balances[_to].add(_value);
84 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
85         emit Transfer(_from, _to, _value);
86         return true;
87     }
88     function allowance(address _owner, address _spender) public view returns(uint256) {
89         return allowed[_owner][_spender];
90     }
91     function approve(address _spender, uint256 _value) public returns(bool) {
92         allowed[msg.sender][_spender] = _value;
93         emit Approval(msg.sender, _spender, _value);
94         return true;
95     }
96     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
97         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
98         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
99         return true;
100     }
101     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
102         uint oldValue = allowed[msg.sender][_spender];
103         if(_subtractedValue > oldValue) {
104             allowed[msg.sender][_spender] = 0;
105         } else {
106             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
107         }
108         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109         return true;
110     }
111 }
112 contract MintableToken is StandardToken, Ownable{
113     event Mint(address indexed to, uint256 amount);
114     event MintFinished();
115     bool public mintingFinished = false;
116     modifier canMint(){require(!mintingFinished); _;}
117     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
118         totalSupply = totalSupply.add(_amount);
119         balances[_to] = balances[_to].add(_amount);
120 		emit Mint(_to, _amount);
121         emit Transfer(address(this), _to, _amount);
122         return true;
123     }
124     function finishMinting() onlyOwner canMint public returns(bool) {
125         mintingFinished = true;
126         emit MintFinished();
127         return true;
128     }
129 }
130 contract CappedToken is MintableToken {
131     uint256 public cap;
132     function CappedToken(uint256 _cap) public {
133         require(_cap > 0);
134         cap = _cap;
135     }
136     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
137         require(totalSupply.add(_amount) <= cap);
138         return super.mint(_to, _amount);
139     }
140 }
141 contract BurnableToken is StandardToken {
142     event Burn(address indexed burner, uint256 value);
143 
144     function burn(uint256 _value) public {
145         require(_value <= balances[msg.sender]);
146         address burner = msg.sender;
147         balances[burner] = balances[burner].sub(_value);
148         totalSupply = totalSupply.sub(_value);
149         emit Burn(burner, _value);
150     }
151 }
152 contract RewardToken is StandardToken, Ownable {
153     struct Payment {
154         uint time;
155         uint amount;
156     }
157     Payment[] public repayments;
158     mapping(address => Payment[]) public rewards;
159 
160     event Reward(address indexed to, uint256 amount);
161 
162     function repayment() onlyOwner payable public {
163         require(msg.value >= 0.000085 * 1 ether);
164         repayments.push(Payment({time : now, amount : msg.value}));
165     }
166     function _reward(address _to) private returns(bool) {
167         if(rewards[_to].length < repayments.length) {
168             uint sum = 0;
169             for(uint i = rewards[_to].length; i < repayments.length; i++) {
170                 uint amount = balances[_to] > 0 ? (repayments[i].amount * balances[_to] / totalSupply) : 0;
171                 rewards[_to].push(Payment({time : now, amount : amount}));
172                 sum += amount;
173             }
174             if(sum > 0) {
175                 _to.transfer(sum);
176                 emit Reward(_to, sum);
177             }
178             return true;
179         }
180         return false;
181     }
182     function reward() public returns(bool) {
183         return _reward(msg.sender);
184     }
185     function transfer(address _to, uint256 _value) public returns(bool) {
186         _reward(msg.sender);
187         _reward(_to);
188         return super.transfer(_to, _value);
189     }
190     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
191         _reward(msg.sender);
192         for(uint i = 0; i < _to.length; i++) {
193             _reward(_to[i]);
194         }
195         return super.multiTransfer(_to, _value);
196     }
197     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
198         _reward(_from);
199         _reward(_to);
200         return super.transferFrom(_from, _to, _value);
201     }
202 }
203 contract Token is CappedToken, BurnableToken, RewardToken {
204     function Token() CappedToken(1000000000 * 1 ether) StandardToken("JULLAR", "JUL", 18) public {
205         
206     }
207 }
208 contract JullarCrowdsale is Ownable{
209     using SafeMath for uint;
210     Token public token;
211     address private BeneficiaryA = 0x87CC179C88B593Ff7DBDD1B6e9A9F7437Df1880E; 
212     address private BenefB = 0x8ae64056f409BbC00ed03eDC6B350eaB7d842A15; 
213     address private JullarBountyAdr = 0xA2Df1e14632Ed83B1e7A35848dAe7c8623e1D030; // BountyAddress	
214     address private JullarPartnersAdr = 0x3d6D84c26a11Ed1123dB68791c80aa7F7ce767C8; // Partner
215     uint public collectedWei;
216 	address[] public JullarTeamAdr;
217 	string public ActiveSalesPhase = "Super PreICO"; // Stage Name
218 	
219     string public TokenPriceETH = "0.000085";  
220 	uint public tokensSold = 0; 
221 	uint private tokensForSale = 20000000 * 1 ether; 
222 	uint public priceTokenWei = 85000000000000;  // 0.000085 ETH = 1 JUL superPreICO
223 	
224 	uint private Sb = 1 ether;
225     uint private oSbA = Sb * 10000000; // BeneficiaryA 10m JUL
226     uint private oSbB = Sb * 10000000; // BeneficiaryB 10m JUL
227 	
228     uint private JULLARbounty = Sb * 20000000; // BountyAmout 20m JUL
229     uint private JULLARpartner = Sb * 10000000; // Partners 10m JUL
230     bool public crowdsaleClosed = false;
231     event Rurchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
232     event CrowdsaleClose();
233 	bool public paused = false;
234 	uint public pausestatus = 1;
235     event Pause();
236     event StartNextIcoStage();
237 	
238 	function pause() onlyOwner public  {
239         pausestatus = 0;
240 		paused = true;
241         emit Pause();
242     }	
243 	function JullarCrowdsale() public {
244      token = new Token();	
245 	 emit Rurchase(BeneficiaryA, oSbA, 0);
246 	 emit Rurchase(BenefB, oSbB, 0);
247 	 emit Rurchase(JullarBountyAdr, JULLARbounty, 0);
248 	 emit Rurchase(JullarPartnersAdr, JULLARpartner, 0);
249 	 token.mint(BeneficiaryA, oSbA);
250 	 token.mint(BenefB, oSbB);
251 	 token.mint(JullarBountyAdr, JULLARbounty);
252 	 token.mint(JullarPartnersAdr, JULLARpartner);
253 	}
254     function() payable public {
255 		if(crowdsaleClosed == false){
256 		       purchase();
257 		}
258     }	
259 	function purchase() payable public {		
260 		require(pausestatus != 0);
261         require(!crowdsaleClosed);
262         require(tokensSold < tokensForSale);
263         require(msg.value >= 0.000085 * 1 ether); 
264         uint sum = msg.value;         
265         uint amount = sum.mul(1 ether).div(priceTokenWei);
266         uint retSum = 0;
267         if(tokensSold.add(amount) > tokensForSale) {
268             uint retAmount = tokensSold.add(amount).sub(tokensForSale);
269             retSum = retAmount.mul(priceTokenWei).div(1 ether);
270             amount = amount.sub(retAmount);
271             sum = sum.sub(retSum);
272         }
273 		tokensSold = tokensSold.add(amount);
274         collectedWei = collectedWei.add(sum);
275         token.mint(msg.sender, amount);
276         if(retSum > 0) {
277             msg.sender.transfer(retSum);
278         }
279         emit Rurchase(msg.sender, amount, sum);		
280     }
281 
282 	function StartNextStage() onlyOwner public {
283         require(!crowdsaleClosed);
284         require(pausestatus != 1);
285 		pausestatus = 1;
286         paused = false;
287         emit StartNextIcoStage();
288     }
289 
290 	function NewStage(uint _newpricewei, string _stagename, string _TokenPriceETH, uint _TokenForSale) onlyOwner public  {
291 		require(!crowdsaleClosed);
292         require(pausestatus != 1);
293 		tokensForSale = _TokenForSale * 1 ether;
294 		ActiveSalesPhase = _stagename;
295 		priceTokenWei = _newpricewei; 
296 		TokenPriceETH = _TokenPriceETH;
297 	}
298 	
299 	function AddAdrJullarTeam(address _address) onlyOwner public{
300 		require(JullarTeamAdr.length < 6);
301 		JullarTeamAdr.push(_address);
302 	}
303 	
304 	function WithdrawalofFunds(uint _arraynum) onlyOwner public {
305 		require(_arraynum / 1 ether < 6);
306         JullarTeamAdr[_arraynum].transfer(address(this).balance);
307 	}
308 
309     function closeCrowdsale() onlyOwner public {
310         require(!crowdsaleClosed);
311 		uint bensum = address(this).balance / 2;		
312         BeneficiaryA.transfer(bensum);
313         BenefB.transfer(bensum);
314         token.mint(BeneficiaryA, token.cap().sub(token.totalSupply()));
315         token.transferOwnership(BeneficiaryA);
316         crowdsaleClosed = true;
317         emit CrowdsaleClose();
318     }
319 }