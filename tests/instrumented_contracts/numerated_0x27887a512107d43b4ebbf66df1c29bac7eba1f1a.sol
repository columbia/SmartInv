1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function add(uint a, uint b) internal pure returns (uint c) {
5     c = a + b;
6     require(c >= a);
7   }
8   function sub(uint a, uint b) internal pure returns (uint c) {
9     require(b <= a);
10     c = a - b;
11   }
12   function mul(uint a, uint b) internal pure returns (uint c) {
13     c = a * b;
14     require(a == 0 || c / a == b);
15   }
16   function div(uint a, uint b) internal pure returns (uint c) {
17     require(b > 0);
18     c = a / b;
19   }
20 }
21 
22 contract ERC20Interface {
23   function totalSupply()
24     public
25     constant
26     returns(uint);
27   function balanceOf(
28     address tokenOwner)
29     public
30     constant
31     returns(uint balance);
32   function allowance(
33     address tokenOwner,
34     address spender)
35     public
36     constant
37     returns(uint approve);
38   function transfer(
39     address to,
40     uint tokens)
41     public
42     returns(bool success);
43   function approve(
44     address spender,
45     uint tokens)
46     public
47     returns(bool success);
48   function transferFrom(
49     address from,
50     address to,
51     uint tokens)
52     public
53     returns(bool success);
54 
55   event Transfer(
56     address indexed from,
57     address indexed to,
58     uint tokens);
59   event Approval(
60     address indexed tokenOwner,
61     address indexed spender,
62     uint tokens);
63 }
64 
65 contract Owned {
66   address public owner;
67   address public newOwner;
68 
69   event OwnershipTransferred(address indexed _from, address indexed _to);
70 
71   function Owned() public {
72     owner = msg.sender;
73   }
74 
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   function transferOwnership(address _newOwner) public onlyOwner {
81     newOwner = _newOwner;
82   }
83 
84   function acceptOwnership() public {
85     require(msg.sender == newOwner);
86     OwnershipTransferred(owner, newOwner);
87     owner = newOwner;
88     newOwner = address(0);
89   }
90 }
91 
92 contract ApproveAndCallFallBack {
93   function receiveApproval(
94     address from,
95     uint256 tokens,
96     address token,
97     bytes data) public;
98 }
99 
100 contract CryptopusToken is ERC20Interface, Owned {
101   using SafeMath for uint;
102 
103   address public preSaleContract;
104 
105   string public symbol;
106   string public name;
107   uint8 public decimals;
108   uint public _totalSupply;
109   uint public saleLimit;
110   uint public alreadySold;
111 
112   uint public firstWavePrice;
113   uint public secondWavePrice;
114   uint public thirdWavePrice;
115 
116   bool public saleOngoing;
117 
118   mapping(address => uint8) approved;
119   mapping(address => uint) balances;
120   mapping(address => mapping(address => uint)) allowed;
121 
122   function CryptopusToken() public {
123     symbol = "CPP";
124     name = "Cryptopus Token";
125     decimals = 18;
126     _totalSupply = 100000000 * 10**uint(decimals);
127     saleLimit = 40000000 * 10**uint(decimals);
128     alreadySold = 0;
129     balances[owner] = _totalSupply;
130     Transfer(address(0), owner, _totalSupply);
131     firstWavePrice = 0.0008 ether;
132     secondWavePrice = 0.0009 ether;
133     thirdWavePrice = 0.001 ether;
134     saleOngoing = false;
135   }
136 
137   modifier onlyIfOngoing() {
138     require(saleOngoing);
139     _;
140   }
141 
142   modifier onlyApproved(address _owner) {
143     require(approved[_owner] != 0);
144     _;
145   }
146 
147   function setPrices(
148     uint _newPriceFirst,
149     uint _newPriceSecond,
150     uint _newPriceThird)
151     public
152     onlyOwner
153     returns(bool) {
154     firstWavePrice = _newPriceFirst;
155     secondWavePrice = _newPriceSecond;
156     thirdWavePrice = _newPriceThird;
157     return true;
158   }
159 
160   function setPreSaleContract(
161     address _owner)
162     public
163     onlyOwner
164     returns(bool) {
165     preSaleContract = _owner;
166     return true;
167   }
168 
169   function updateSaleStatus()
170     public
171     onlyOwner
172     returns(bool) {
173     saleOngoing = !saleOngoing;
174     return true;
175   }
176 
177   function pushToApproved(
178     address _contributor,
179     uint8 waveNumber)
180     public
181     onlyOwner
182     returns(bool) {
183     approved[_contributor] = waveNumber;
184     return true;
185   }
186 
187   function totalSupply()
188     public
189     constant
190     returns(uint) {
191     return _totalSupply - balances[address(0)];
192   }
193 
194   function balanceOf(
195     address tokenOwner)
196     public
197     constant
198     returns(uint) {
199     return balances[tokenOwner];
200   }
201 
202   function transfer(
203     address to,
204     uint tokens)
205     public
206     returns(bool) {
207     balances[msg.sender] = balances[msg.sender].sub(tokens);
208     balances[to] = balances[to].add(tokens);
209     Transfer(msg.sender, to, tokens);
210     return true;
211   }
212 
213   function approve(
214     address spender,
215     uint tokens)
216     public
217     returns(bool) {
218     allowed[msg.sender][spender] = tokens;
219     Approval(msg.sender, spender, tokens);
220     return true;
221   }
222 
223   function transferFrom(
224     address from,
225     address to,
226     uint tokens)
227     public
228     returns(bool) {
229     balances[from] = balances[from].sub(tokens);
230     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
231     balances[to] = balances[to].add(tokens);
232     Transfer(from, to, tokens);
233     return true;
234   }
235 
236   function allowance(
237     address tokenOwner,
238     address spender)
239     public
240     constant
241     returns(uint) {
242     return allowed[tokenOwner][spender];
243   }
244 
245   function approveAndCall(
246     address spender,
247     uint tokens,
248     bytes data)
249     public
250     returns(bool) {
251     allowed[msg.sender][spender] = tokens;
252     Approval(msg.sender, spender, tokens);
253     ApproveAndCallFallBack(spender)
254       .receiveApproval(
255         msg.sender,
256         tokens,
257         this,
258         data);
259     return true;
260   }
261 
262   function burnTokens(
263     uint tokens)
264     public
265     returns(bool) {
266     balances[msg.sender] = balances[msg.sender].sub(tokens);
267     balances[address(0)] = balances[address(0)].add(tokens);
268     Transfer(msg.sender, address(0), tokens);
269     return true;
270   }
271 
272   function exchangeTokens()
273     public
274     returns(bool) {
275     uint tokens = uint(
276       ERC20Interface(preSaleContract)
277         .allowance(msg.sender, this));
278     require(tokens > 0 &&
279             ERC20Interface(preSaleContract)
280               .balanceOf(msg.sender) == tokens);
281     ERC20Interface(preSaleContract)
282       .transferFrom(msg.sender, address(0), tokens);
283     balances[owner] = balances[owner].sub(tokens);
284     balances[msg.sender] = balances[msg.sender].add(tokens);
285     Transfer(owner, msg.sender, tokens);
286     return true;
287   }
288 
289   function()
290     public
291     onlyIfOngoing
292     onlyApproved(msg.sender)
293     payable {
294     uint tokenPrice;
295     if(approved[msg.sender] == 1) {
296       tokenPrice = firstWavePrice;
297     } else if(approved[msg.sender] == 2) {
298       tokenPrice = secondWavePrice;
299     } else if(approved[msg.sender] == 3) {
300       tokenPrice = thirdWavePrice;
301     } else {
302       revert();
303     }
304     require(msg.value >= tokenPrice);
305     uint tokenAmount = msg.value / tokenPrice;
306     require(saleOngoing && alreadySold.add(tokenAmount) <= saleLimit);
307     balances[owner] = balances[owner].sub(tokenAmount);
308     balances[msg.sender] = balances[msg.sender].add(tokenAmount);
309     alreadySold = alreadySold.add(tokenAmount);
310     Transfer(owner, msg.sender, tokenAmount);
311   }
312 }