1 pragma solidity ^0.4.24;
2 
3 contract DMIBLog {
4     event MIBLog(bytes4 indexed sig, address indexed sender, uint _value) anonymous;
5 
6     modifier mlog {
7         emit MIBLog(msg.sig, msg.sender, msg.value);
8         _;
9     }
10 }
11 
12 contract Ownable {
13     address public owner;
14 
15     event OwnerLog(address indexed previousOwner, address indexed newOwner, bytes4 sig);
16 
17     constructor() public { 
18         owner = msg.sender; 
19     }
20 
21     modifier onlyOwner {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     function transferOwnership(address newOwner) onlyOwner  public {
27         require(newOwner != address(0));
28         emit OwnerLog(owner, newOwner, msg.sig);
29         owner = newOwner;
30     }
31 }
32 
33 contract MIBStop is Ownable, DMIBLog {
34 
35     bool public stopped;
36 
37     modifier stoppable {
38         require (!stopped);
39         _;
40     }
41     function stop() onlyOwner mlog public {
42         stopped = true;
43     }
44     function start() onlyOwner mlog public {
45         stopped = false;
46     }
47 }
48 
49 library SafeMath {
50     
51     /**
52      * @dev Multiplies two numbers, throws on overflow.
53     */
54     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
55         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
56         // benefit is lost if 'b' is also tested.
57         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58         if (a == 0) {
59           return 0;
60         }
61 
62         c = a * b;
63         assert(c / a == b);
64         return c;
65     }
66 
67     /**
68      * @dev Integer division of two numbers, truncating the quotient.
69     */
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         // assert(b > 0); // Solidity automatically throws when dividing by 0
72         // uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74         return a / b;
75     }
76 
77     /**
78      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79     */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         assert(b <= a);
82         return a - b;
83     }
84 
85     /**
86      * @dev Adds two numbers, throws on overflow.
87     */
88     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
89         c = a + b;
90         assert(c >= a);
91         return c;
92     }
93 }
94 
95 contract ERC20Basic {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 contract ERC20 is ERC20Basic {
103     function allowance(address owner, address spender) public view returns (uint256);
104     function approve(address spender, uint256 value) public returns (bool);
105     function transferFrom(address from, address to, uint256 value) public returns (bool);
106 
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 library SafeERC20 {
111     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
112         require(token.transfer(to, value));
113     }
114     
115     function safeTransferFrom(
116         ERC20 token,
117         address from,
118         address to,
119         uint256 value
120         )
121     internal
122     {
123         require(token.transferFrom(from, to, value));
124     }
125 }
126 
127 
128 contract MIBTokenSale is Ownable {
129     using SafeMath for uint256;
130     using SafeERC20 for ERC20;
131     
132     ERC20 mibtokenaddress;
133     
134     uint8 private nowvestingType = 0;
135     uint256 private minimum_wei = 1e18;         // 1eth
136     
137     uint256 private totalWeiEther;
138     
139     uint8 k;
140     
141     mapping(uint8 => uint) assignTokensperType ;
142     mapping(uint8 => uint) remainTokensperType ;
143     mapping(uint8 => uint) nowTokensperEth;
144     mapping(uint8 => uint) distributionTimes;
145 
146     uint8 public iDistribution;
147     uint8 public iICO;
148 
149     modifier canDistribute() {
150         require(iICO == 1);
151         require(iDistribution > 1);
152         _;
153     }
154     
155 
156     enum InvestTypes { Angels, Pre_sales, Ico, Offices, Teams, Advisors, Stocks, MAX_InvestTypes }
157     
158     event TokenPurchase(address indexed _sender, address indexed _to, uint256 _value1, uint _value2, uint _value3);  
159     event MibTokenSend(address indexed _sender, address indexed _to, uint256 _value1, uint _value2, uint _value3);  
160     event MibSetLog(address indexed _sender, uint256 _value1, uint _value2, uint _value3);  
161 
162     //vesting, sep, rate, start date, end date, start distribution date
163     constructor(
164             ERC20 _mibtokenaddress,
165             uint [] vesting,
166             uint8 [] sep,
167             uint [] rate
168         ) public {
169         
170             mibtokenaddress = ERC20(_mibtokenaddress);
171     
172             //proceed only ico
173             nowvestingType = uint8(InvestTypes.Ico);
174     
175             for(k=0; k<uint8(InvestTypes.MAX_InvestTypes); k++)
176             {
177                 remainTokensperType[k] = remainTokensperType[k].add(vesting[k] * 1e18);
178                 assignTokensperType[k] = assignTokensperType[k].add(vesting[k] * 1e18);
179                 nowTokensperEth[k] = rate[k];
180                 distributionTimes[k] = sep[k];
181             }     
182     
183             totalWeiEther = 0;
184         
185     }  
186     
187     function setVestingRate(uint256 _icorate) onlyOwner public {
188 
189         nowTokensperEth[uint8(InvestTypes.Ico)] = _icorate;
190         
191         emit MibSetLog(msg.sender, 0, 0, _icorate);
192     }
193 
194     function setVestingType(uint8 _type) onlyOwner public {
195         require(_type < uint8(InvestTypes.MAX_InvestTypes));
196         nowvestingType = _type;
197         //proceed only ico
198         nowvestingType = uint8(InvestTypes.Ico);
199         
200         emit MibSetLog(msg.sender, 0, 0, nowvestingType);
201         
202     }
203     
204     function startICO() onlyOwner public {
205         require(iDistribution < 1);
206         require(iICO < 1);
207         iICO = 2;
208     }
209 
210     function stopICO() onlyOwner public {
211         require(iDistribution <= 1);
212         iICO = 1;
213     }
214     
215     function distributionStart() onlyOwner public {
216         require(iICO == 1);
217         iDistribution = 2;
218     }
219 
220     function getDistributionStatus() onlyOwner public view returns(uint8) {
221         return iDistribution;
222     }
223     
224     function getNowVestingType() public view returns (uint8) {
225         return nowvestingType;
226     }
227     
228     function getassignTokensperType(uint8 _type) public view returns (uint) {
229         return assignTokensperType[_type];
230     }
231     
232     function getremainTokensperType(uint8 _type) public view returns (uint) {
233         return remainTokensperType[_type];
234     }
235 
236     function getTotalWEIEther() onlyOwner public view returns (uint256) { 
237         return totalWeiEther; 
238     }
239 
240     function () external payable {
241         
242         buyTokens(msg.sender, nowvestingType);
243     }
244     
245     function buyTokens(address _to, uint8 _type) public payable {
246         uint256 tokens;
247         
248         require(iICO > 1);
249 
250         require(_type < uint8(InvestTypes.MAX_InvestTypes));
251         
252         tokens = _preValidatePurchase(_to, _type, msg.value);
253 
254         processPurchase(_to, _type, tokens);
255         remainTokensperType[_type] = remainTokensperType[_type].sub(tokens);
256         
257         mibtokenaddress.safeTransfer(_to, tokens);
258         
259     }
260     
261     function _preValidatePurchase(
262         address _to,
263         uint8 _type,
264         uint256 _weiAmount
265         )
266     internal 
267     view
268     returns (uint256)
269     {
270         uint256 tokens;
271         uint256 tmpTokens;
272         
273         require(_to != address(0));
274         require(_weiAmount >= minimum_wei);
275 
276         tokens = nowTokensperEth[nowvestingType].mul(msg.value);
277         
278         tmpTokens = tokens.mul(20).div(100);
279         tokens = tokens.add(tmpTokens);
280         
281         require(tokens > 0);
282         
283         require(tokens <= remainTokensperType[_type]);
284         
285         return tokens;
286     }
287   
288     
289     function processPurchase(address _to, uint8 _type, uint256 _tokens) internal {
290 
291         _forwardFunds();
292         totalWeiEther += msg.value;
293 
294         emit TokenPurchase(owner, _to, _type, msg.value, _tokens);
295     }
296 
297     function ownerSendTokens(address _to, uint8 _type, uint256 _weitokens) 
298         public 
299         canDistribute
300         onlyOwner
301         payable
302         returns (uint256)
303     {
304         uint256 remaintokens;
305         
306         remaintokens = remainTokensperType[_type];
307         
308         require(remaintokens >= _weitokens);
309         require(_type < uint8(InvestTypes.MAX_InvestTypes));
310         
311         mibtokenaddress.safeTransfer(_to, _weitokens);
312         remainTokensperType[_type] = remainTokensperType[_type].sub(_weitokens);
313         
314         emit MibTokenSend(msg.sender, _to, _type, _weitokens, remainTokensperType[_type]);
315         return (remainTokensperType[_type]);
316         
317     }
318     
319     function _forwardFunds() internal  {
320         owner.transfer(msg.value);
321     }
322 
323 }