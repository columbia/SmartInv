1 pragma solidity ^0.4.23;
2 
3 contract Control {
4     address public owner;
5     bool public pause;
6 
7     event PAUSED();
8     event STARTED();
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     modifier whenPaused {
16         require(pause);
17         _;
18     }
19 
20     modifier whenNotPaused {
21         require(!pause);
22         _;
23     }
24 
25     function setOwner(address _owner) onlyOwner public {
26         owner = _owner;
27     }
28 
29     function setState(bool _pause) onlyOwner public {
30         pause = _pause;
31         if (pause) {
32             emit PAUSED();
33         } else {
34             emit STARTED();
35         }
36     }
37     
38     constructor() public {
39         owner = msg.sender;
40     }
41 }
42 
43 contract ERC20Token {
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     function symbol() public constant returns (string);
52     function decimals() public constant returns (uint256);
53     
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56 }
57 
58 contract Share {
59     function onIncome() public payable;
60 }
61 
62 library SafeMath {
63 
64   /**
65   * @dev Multiplies two numbers, throws on overflow.
66   */
67   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
68     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
69     // benefit is lost if 'b' is also tested.
70     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
71     if (a == 0) {
72       return 0;
73     }
74 
75     c = a * b;
76     assert(c / a == b);
77     return c;
78   }
79 
80   /**
81   * @dev Integer division of two numbers, truncating the quotient.
82   */
83   function div(uint256 a, uint256 b) internal pure returns (uint256) {
84     // assert(b > 0); // Solidity automatically throws when dividing by 0
85     // uint256 c = a / b;
86     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87     return a / b;
88   }
89 
90   /**
91   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
92   */
93   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94     assert(b <= a);
95     return a - b;
96   }
97 
98   /**
99   * @dev Adds two numbers, throws on overflow.
100   */
101   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
102     c = a + b;
103     assert(c >= a);
104     return c;
105   }
106 }
107 
108 contract Crowdsale is Control {
109     using SafeMath for uint256;
110 
111     // The token being sold
112     ERC20Token public token;
113 
114     address public tokenFrom;
115     function setTokenFrom(address _from) onlyOwner public {
116         tokenFrom = _from;
117     }
118 
119     // Address where funds are collected
120     Share public wallet;
121     function setWallet(Share _wallet) onlyOwner public {
122         wallet = _wallet;
123     }
124 
125     // How many token units a buyer gets per wei.
126     // The rate is the conversion between wei and the smallest and indivisible token unit.
127     // So, if you are using a rate of 1 with a DetailedShare token with 3 decimals called TOK
128     // 1 wei will give you 1 unit, or 0.001 TOK.
129     uint256 public rate;
130     function adjustRate(uint256 _rate) onlyOwner public {
131         rate = _rate;
132     }
133 
134     uint256 public weiRaiseLimit;
135     
136     function setWeiRaiseLimit(uint256 _limit) onlyOwner public {
137         weiRaiseLimit = _limit;
138     }
139     
140     // Amount of wei raised
141     uint256 public weiRaised;
142   
143     /**
144       * Event for token purchase logging
145       * @param purchaser who paid for the tokens
146       * @param beneficiary who got the tokens
147       * @param value weis paid for purchase
148       * @param amount amount of tokens purchased
149       */
150     event TokenPurchase (
151         address indexed purchaser,
152         address indexed beneficiary,
153         uint256 value,
154         uint256 amount
155     );
156 
157     modifier onlyAllowed {
158         require(weiRaised < weiRaiseLimit);
159         _;
160     }
161   /**
162    * @param _rate Number of token units a buyer gets per wei
163    * @param _wallet Address where collected funds will be forwarded to
164    * @param _token Address of the token being sold
165    */
166   constructor(uint256 _rate, Share _wallet, ERC20Token _token, address _tokenFrom, uint256 _ethRaiseLimit) 
167   public 
168   {
169     require(_rate > 0);
170     require(_wallet != address(0));
171     require(_token != address(0));
172 
173     owner = msg.sender;
174     rate = _rate;
175     wallet = _wallet;
176     token = _token;
177     tokenFrom  = _tokenFrom;
178     weiRaiseLimit = _ethRaiseLimit * (10 ** 18);
179   }
180 
181   // -----------------------------------------
182   // Crowdsale external interface
183   // -----------------------------------------
184 
185   /**
186    * @dev fallback function ***DO NOT OVERRIDE***
187    */
188   function () external payable {
189     buyTokens(msg.sender);
190   }
191 
192   /**
193    * @dev low level token purchase ***DO NOT OVERRIDE***
194    * @param _beneficiary Address performing the token purchase
195    */
196   function buyTokens(address _beneficiary) public payable onlyAllowed whenNotPaused {
197 
198     uint256 weiAmount = msg.value;
199     if (weiAmount > weiRaiseLimit.sub(weiRaised)) {
200         weiAmount = weiRaiseLimit.sub(weiRaised);
201     }
202     
203     // calculate token amount to be created
204     uint256 tokens = _getTokenAmount(weiAmount);
205     
206     if (address(wallet) != address(0)) {
207         wallet.onIncome.value(weiAmount)();
208     }
209     
210     // update state
211     weiRaised = weiRaised.add(weiAmount);
212 
213     _processPurchase(_beneficiary, tokens);
214     
215     emit TokenPurchase(
216       msg.sender,
217       _beneficiary,
218       weiAmount,
219       tokens
220     );
221     
222     if(msg.value.sub(weiAmount) > 0) {
223         msg.sender.transfer(msg.value.sub(weiAmount));
224     }
225   }
226 
227   // -----------------------------------------
228   // Internal interface (extensible)
229   // -----------------------------------------
230 
231   /**
232    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
233    * @param _beneficiary Address performing the token purchase
234    * @param _tokenAmount Number of tokens to be emitted
235    */
236   function _deliverTokens(
237     address _beneficiary,
238     uint256 _tokenAmount
239   )
240     internal
241   {
242     token.transferFrom(tokenFrom, _beneficiary, _tokenAmount);
243   }
244 
245   /**
246    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
247    * @param _beneficiary Address receiving the tokens
248    * @param _tokenAmount Number of tokens to be purchased
249    */
250   function _processPurchase(
251     address _beneficiary,
252     uint256 _tokenAmount
253   )
254     internal
255   {
256     _deliverTokens(_beneficiary, _tokenAmount);
257   }
258 
259 
260 
261   /**
262    * @dev Override to extend the way in which ether is converted to tokens.
263    * @param _weiAmount Value in wei to be converted into tokens
264    * @return Number of tokens that can be purchased with the specified _weiAmount
265    */
266   function _getTokenAmount(uint256 _weiAmount)
267     internal view returns (uint256)
268   {
269     return _weiAmount / rate;
270   }
271   
272   function withdrawl() public {
273       owner.transfer(address(this).balance);
274   }
275 }