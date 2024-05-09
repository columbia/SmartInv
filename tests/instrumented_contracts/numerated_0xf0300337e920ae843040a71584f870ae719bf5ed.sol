1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal constant returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48   function transfer(address _to, uint256 _value) public returns (bool) {
49     require(_to != address(0));
50     require(_value <= balances[msg.sender]);
51 
52     // SafeMath.sub will throw if there is not enough balance.
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   function balanceOf(address _owner) public constant returns (uint256 balance) {
60     return balances[_owner];
61   }
62 
63 }
64 contract StandardToken is ERC20, BasicToken {
65 
66   mapping (address => mapping (address => uint256)) internal allowed;
67 
68 
69   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71     require(_value <= balances[_from]);
72     require(_value <= allowed[_from][msg.sender]);
73 
74     balances[_from] = balances[_from].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
77     Transfer(_from, _to, _value);
78     return true;
79   }
80 
81   function approve(address _spender, uint256 _value) public returns (bool) {
82     allowed[msg.sender][_spender] = _value;
83     Approval(msg.sender, _spender, _value);
84     return true;
85   }
86 
87   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
88     return allowed[_owner][_spender];
89   }
90 
91   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
92     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
93     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
94     return true;
95   }
96 
97   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
98     uint oldValue = allowed[msg.sender][_spender];
99     if (_subtractedValue > oldValue) {
100       allowed[msg.sender][_spender] = 0;
101     } else {
102       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
103     }
104     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105     return true;
106   }
107 
108 }
109 
110 contract Ownable {
111   address public owner;
112   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113   function Ownable() public{
114     owner = msg.sender;
115   }
116   modifier onlyOwner() {
117     require(msg.sender == owner);
118     _;
119   }
120   function transferOwnership(address newOwner) onlyOwner public {
121     require(newOwner != address(0));
122     OwnershipTransferred(owner, newOwner);
123     owner = newOwner;
124   }
125 
126 }
127 
128 contract MintableToken is StandardToken, Ownable {
129   event Mint(address indexed to, uint256 amount);
130   event MintFinished();
131 
132   bool public mintingFinished = false;
133 
134   modifier canMint() {
135     require(!mintingFinished);
136     _;
137   }
138 
139   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
140     totalSupply = totalSupply.add(_amount);
141     balances[_to] = balances[_to].add(_amount);
142     Mint(_to, _amount);
143     Transfer(address(0), _to, _amount);
144     return true;
145   }
146   function finishMinting() onlyOwner public returns (bool) {
147     mintingFinished = true;
148     MintFinished();
149     return true;
150   }
151 }
152 contract BurnableToken is StandardToken {
153 
154   function burn(uint _value) public {
155     require(_value > 0);
156     address burner = msg.sender;
157     balances[burner] = balances[burner].sub(_value);
158     totalSupply = totalSupply.sub(_value);
159     Burn(burner, _value);
160   }
161 
162   event Burn(address indexed burner, uint indexed value);
163 
164 }
165 
166 
167 contract WAEP is MintableToken, BurnableToken {
168     
169     string public constant name = "WeAre Pre-ICO Token";
170     
171     string public constant symbol = "WAEP";
172     
173     uint32 public constant decimals = 18;
174     
175     function WAEP() public{
176 		owner = msg.sender;
177     }
178     
179 }
180 
181 contract Crowdsale is Ownable {
182     
183     using SafeMath for uint;
184     WAEP public token ;
185     uint start; //15dec
186     uint end; //15feb
187     uint softcapUSD;
188     uint hardcapUSD;
189     uint public risedUSD;
190     uint hardcapTokens;
191     uint oneTokenInWei;
192     uint sale1 = 1000000*10**18;
193     uint sale2 = 2000000*10**18;
194     uint sale3 = 3000000*10**18;
195 
196     mapping (address => bool) refunded;
197     mapping (address => uint256) saleBalances ;  
198     function Crowdsale() public{
199         owner = msg.sender;
200         start = 1513339200; //15dec
201         end = 1518696000; //15feb
202         softcapUSD = 350000*10**18;
203         hardcapUSD = 3500000*10**18;
204         hardcapTokens = 1000000000*10**18;
205 		oneTokenInWei = 1532355690402860; // init price $652.59 usd per eth
206 		token = new WAEP();
207     }
208     
209     function setEthPrice(uint _new) onlyOwner {
210         oneTokenInWei = _new;
211     }
212     
213     function buyByBot(uint _usd, uint _tokens, address _to) onlyOwner {
214         require( risedUSD + _usd < hardcapUSD );
215         risedUSD += _usd*10**18;
216         token.mint(_to, _tokens*10**18);
217     }
218     
219     function() external payable {
220         require(now > start && now < end);
221         require( risedUSD + msg.value.mul(10**18).div(oneTokenInWei) < hardcapUSD );
222         uint discountPrice ;
223         
224         if ( risedUSD < sale1 ) {                
225             discountPrice = oneTokenInWei.div(100).mul(60);
226         } else if ( risedUSD < sale2 ) {                
227             discountPrice = oneTokenInWei.div(100).mul(70);
228         } else if ( risedUSD < sale3 ) {                
229             discountPrice = oneTokenInWei.div(100).mul(80);
230         } else {
231            discountPrice = oneTokenInWei ;
232         }
233 
234         uint256 tokenAdd = msg.value.mul(10**18).div(discountPrice);
235         require(token.totalSupply() + tokenAdd < hardcapTokens);
236         risedUSD += msg.value.mul(10**18).div(oneTokenInWei);
237         saleBalances[msg.sender] = saleBalances[msg.sender].add(msg.value);
238         token.mint(msg.sender, tokenAdd);
239     }
240     
241     function getEth() public onlyOwner {
242         owner.transfer(this.balance);
243     }
244     
245     function mint(address _to, uint _value) public onlyOwner {
246         require(_value > 0);
247         token.mint(_to, _value*10**18);
248     }
249 
250     function refund() public {
251         require (now > end  && risedUSD < softcapUSD );
252         require (!refunded[msg.sender]);
253         require (saleBalances[msg.sender] != 0) ;
254         uint refund = saleBalances[msg.sender];
255         require(msg.sender.send(refund));
256         refunded[msg.sender] = true;
257     }
258 }