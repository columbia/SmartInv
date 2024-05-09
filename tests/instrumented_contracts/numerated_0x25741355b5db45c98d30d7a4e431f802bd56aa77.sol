1 contract ERC20Basic {
2   uint256 public totalSupply;
3   function balanceOf(address who) constant returns (uint256);
4   function transfer(address to, uint256 value) returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 /**
9  * @title ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/20
11  */
12 contract ERC20 is ERC20Basic {
13   function allowance(address owner, address spender) constant returns (uint256);
14   function transferFrom(address from, address to, uint256 value) returns (bool);
15   function approve(address spender, uint256 value) returns (bool);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24     
25   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal constant returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal constant returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48   
49 }
50 
51 
52 /**
53  * @title Contract for object that have an owner
54  */
55 contract Owned {
56     /**
57      * Contract owner address
58      */
59     address public owner;
60 
61     /**
62      * @dev Delegate contract to another person
63      * @param _owner New owner address
64      */
65     function setOwner(address _owner) onlyOwner
66     { owner = _owner; }
67 
68     /**
69      * @dev Owner check modifier
70      */
71     modifier onlyOwner { if (msg.sender != owner) throw; _; }
72 }
73 
74 
75 contract TRMCrowdsale is Owned {
76     using SafeMath for uint;
77 
78     event Print(string _message, address _msgSender);
79 
80     uint public ETHUSD = 88459; //in cent
81     address manager = 0xf5c723B7Cc90eaA3bEec7B05D6bbeBCd9AFAA69a;
82     address ETHUSDdemon = 0xb42f06b2fc28decc022985a1a35c7b868f91bd17;
83     address public multisig = 0xc2CDcE18deEcC1d5274D882aEd0FB082B813FFE8;
84     address public addressOfERC20Token = 0x8BeF0141e8D078793456C4b74f7E60640f618594;
85     ERC20 public token;
86 
87     uint public startICO = now;
88     uint public endICO = 1519862400; // Thu, 01 Mar 2018 00:00:00 GMT
89     uint public endPostICO = 1522540800;  // Sun, 01 Apr 2018 00:00:00 GMT
90 
91     uint public tokenIcoUsdCentPrice = 550;
92     uint public tokenPostIcoUsdCentPrice = 650;
93 
94     uint public bonusWeiAmount = 30000000000000000000 ; //30 ETH
95     uint public smallBonusPercent = 1;
96     uint public bigBonusPercent = 35;
97     
98     bool public TRM1BonusActive = false;
99     uint public minTokenForSP = 1 * 100000000;
100     uint public tokenForSP = 500*100000000;
101     uint public tokenForSPSold = 0;
102     uint public tokenSPUsdCentPrice = 250;
103     address public addressOfERC20OldToken = 0x241684Ef15683ca57c42d8F4BB0e87D3427DdF1c;
104     ERC20 public oldToken;
105     
106     
107     
108 
109 
110     function TRMCrowdsale(){
111         owner = msg.sender;
112         token = ERC20(addressOfERC20Token);
113         oldToken = ERC20(addressOfERC20OldToken);
114         ETHUSDdemon = msg.sender;
115         
116         //удалить
117         //manager = msg.sender;
118         //multisig = msg.sender;
119 
120     }
121 
122     function oldTokenBalance(address _holderAdress) constant returns (uint256) {
123         return oldToken.balanceOf(_holderAdress);
124     }
125     
126     function tokenBalance() constant returns (uint256) {
127         return token.balanceOf(address(this));
128     }    
129 
130  
131     function setAddressOfERC20Token(address _addressOfERC20Token) onlyOwner {
132         addressOfERC20Token = _addressOfERC20Token;
133         token = ERC20(addressOfERC20Token);
134     }
135     
136     function setAddressOfERC20OldToken(address _addressOfERC20OldToken) onlyOwner {
137         addressOfERC20OldToken = _addressOfERC20OldToken;
138         oldToken = ERC20(addressOfERC20OldToken);
139     }    
140 
141     function transferToken(address _to, uint _value) returns (bool) {
142         require(msg.sender == manager);
143         return token.transfer(_to, _value);
144     }
145 
146     function() payable {
147         doPurchase();
148     }
149 
150     function doPurchase() payable {
151         require(now >= startICO && now < endPostICO);
152 
153         require(msg.value > 0);
154 
155         uint sum = msg.value;
156 
157         uint tokensAmount;
158         
159         if((TRM1BonusActive)&&(oldToken.balanceOf(msg.sender)>=minTokenForSP)&&(tokenForSPSold<tokenForSP)){
160             tokensAmount = sum.mul(ETHUSD).div(tokenSPUsdCentPrice).div(10000000000);
161             
162             tokenForSPSold=tokenForSPSold.add(tokensAmount);
163         } else {
164 
165             if(now < endICO){
166                 tokensAmount = sum.mul(ETHUSD).div(tokenIcoUsdCentPrice).div(10000000000);
167             } else {
168                 tokensAmount = sum.mul(ETHUSD).div(tokenPostIcoUsdCentPrice).div(10000000000);
169             }
170     
171     
172             //Bonus
173             if(sum < bonusWeiAmount){
174                tokensAmount = tokensAmount.mul(100+smallBonusPercent).div(100);
175             } else{
176                tokensAmount = tokensAmount.mul(100+bigBonusPercent).div(100);
177             }
178         }
179 
180         if(tokenBalance() > tokensAmount){
181             require(token.transfer(msg.sender, tokensAmount));
182             multisig.transfer(msg.value);
183         } else {
184             manager.transfer(msg.value);
185             Print("Tokens will be released manually", msg.sender);
186         }
187 
188 
189     }
190 
191     function setETHUSD( uint256 _newPrice ) {
192         require((msg.sender == ETHUSDdemon)||(msg.sender == manager));
193         ETHUSD = _newPrice;
194     }
195 
196     function setBonus( uint256 _bonusWeiAmount, uint256 _smallBonusPercent, uint256 _bigBonusPercent ) {
197         require(msg.sender == manager);
198 
199         bonusWeiAmount = _bonusWeiAmount;
200         smallBonusPercent = _smallBonusPercent;
201         bigBonusPercent = _bigBonusPercent;
202     }
203     
204     function setETHUSDdemon(address _ETHUSDdemon) 
205     { 
206         require(msg.sender == manager);
207         ETHUSDdemon = _ETHUSDdemon; 
208     }
209     
210     function setTokenSPUsdCentPrice(uint _tokenSPUsdCentPrice) 
211     { 
212         require(msg.sender == manager);
213         tokenSPUsdCentPrice = _tokenSPUsdCentPrice; 
214     }    
215 
216     function setMinTokenForSP(uint _minTokenForSP) 
217     { 
218         require(msg.sender == manager);
219         minTokenForSP = _minTokenForSP; 
220     }   
221     
222     function setTRM1BonusActive(bool _TRM1BonusActive) 
223     { 
224         require(msg.sender == manager);
225         TRM1BonusActive = _TRM1BonusActive; 
226     }  
227     
228     function setTokenForSP(uint _tokenForSP) 
229     { 
230         require(msg.sender == manager);
231         tokenForSP = _tokenForSP; 
232         tokenForSPSold = 0;
233     }       
234 }