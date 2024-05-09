1 pragma solidity ^0.5.3;
2 
3 /*
4 
5 "It does not matter how slowly you go as long as you do not stop". 
6 – Confucius
7 
8 */
9 
10 contract EthJackpot
11 {
12      
13     using SafeMath for uint256;
14 
15     event onTransfer(
16         address indexed from,
17         address indexed to,
18         uint256 tokens
19     );
20 
21     event onBuyEvent(
22         address from,
23         uint256 tokens
24     );
25    
26      event onSellEvent(
27         address from,
28         uint256 tokens
29     );
30 
31      event onJackpotwon(
32         address winner,
33         uint256 tokens
34     );
35     
36     modifier onlyTokenHolders() 
37     {
38         require(myTokens() > 0);
39         _;
40     }
41     
42     modifier onlyEthBankHolders()
43     {
44         require(myEthBank() > 0);
45         _;
46     }
47 
48     string public name = "SKY token";
49     string public symbol = "SKY";
50     uint256 constant public decimals = 18;
51     uint256 constant internal buyInFee = 10;        
52     uint256 constant internal sellOutFee = 10; 
53     mapping(address => uint256) public balanceOf;
54     mapping(address => uint256) public ethBank;
55     uint256 public totalSupply = 0;  
56     uint256 public coinMC = 0;
57     uint256 public tokenPrice = .001 ether;
58     uint256 public ethJackpot = 0;
59     address public leader;
60     uint256 public jpTimer = now + 1 weeks;
61     uint256 public jpRound = 0;
62 
63     function()
64         external
65         payable        
66 
67     {
68         buy();
69     }
70     
71   
72     function buy()
73         public
74         payable
75     {
76         address _customerAddress = msg.sender;
77         uint256 _eth = msg.value;
78         if(now>=jpTimer){
79             uint256 jpwinnings = ethJackpot/2;
80             ethJackpot = 0;
81             ethBank[leader] = ethBank[leader].add(jpwinnings);    
82             jpRound += 1;
83         }
84         uint256 _tokens = _eth.mul(1e18)/buyingPrice();
85         uint256 fee = _eth/buyInFee;
86         uint256 splitFee = fee/2;
87         balanceOf[_customerAddress] =  balanceOf[_customerAddress].add(_tokens);
88         totalSupply = totalSupply.add(_tokens);
89         emit onBuyEvent(_customerAddress, _tokens);
90         ethJackpot = ethJackpot.add(splitFee);
91         coinMC = coinMC.add(_eth.sub(splitFee));
92         if(msg.value >= buyingPrice()){
93             jpTimer = now + 1 days;
94             leader = _customerAddress;
95         }
96         tokenPrice = coinMC / (totalSupply / 1e18);
97     }
98     
99         
100     function reinvest()
101         public
102         onlyEthBankHolders
103     {
104         address _customerAddress = msg.sender;
105         uint256 _eth = ethBank[_customerAddress];
106         ethBank[_customerAddress] = 0;
107         require(_eth >= buyingPrice());
108         if(now>=jpTimer){
109             uint256 jpwinnings = ((ethJackpot/2)/buyingPrice());
110             ethJackpot = 0;
111             ethBank[leader] = ethBank[leader].add(jpwinnings);    
112         }
113         uint256 _tokens = _eth.mul(1e18)/buyingPrice();
114         uint256 fee = _eth/buyInFee;
115         uint256 splitFee = fee/2;
116         balanceOf[_customerAddress] =  balanceOf[_customerAddress].add(_tokens);
117         totalSupply = totalSupply.add(_tokens);
118         emit onBuyEvent(_customerAddress, _tokens);
119         ethJackpot = ethJackpot.add(splitFee);
120         coinMC = coinMC.add(_eth.sub(splitFee));
121         tokenPrice = coinMC / (totalSupply / 1e18);
122         jpTimer = now + 1 days;
123         leader = _customerAddress;
124     }
125 
126 
127     function sell(uint256 _amount)
128         public
129         onlyTokenHolders
130     {
131         address _customerAddress = msg.sender;
132         require(_amount <= balanceOf[_customerAddress]);
133         uint256 _eth = _amount.mul(tokenPrice);
134         _eth = _eth/(1e18);
135         uint256 _fee = _eth/buyInFee;
136         _eth = _eth.sub(_fee);
137         totalSupply = totalSupply.sub(_amount);
138         balanceOf[_customerAddress] = balanceOf[_customerAddress].sub(_amount);
139         uint256 splitFee = _fee/2;
140         ethJackpot = ethJackpot.add(splitFee);
141         ethBank[leader] = ethBank[leader].add(splitFee/2);
142         emit onSellEvent(_customerAddress, _amount);
143         coinMC = coinMC.sub(_eth + splitFee + (splitFee/2));
144         if(totalSupply > 0){
145             tokenPrice = coinMC.mul(1e18)/totalSupply;
146             }else{(tokenPrice = buyingPrice().add(coinMC));}
147         ethBank[_customerAddress] = ethBank[_customerAddress].add(_eth);
148     }
149     
150     
151     function sellAll() 
152         public
153         onlyTokenHolders
154     {
155         sell(balanceOf[msg.sender]);
156     }
157    
158     
159     function withdraw()
160         public
161         payable
162         onlyEthBankHolders
163     {
164         address payable _customerAddress = msg.sender;
165         uint256 eth = ethBank[_customerAddress];        
166         ethBank[_customerAddress] = 0;
167         _customerAddress.transfer(eth);
168     }
169     
170     
171     function panic()
172         public
173         payable
174     {
175         if (myTokens() > 0){
176             sellAll();
177         }
178         withdraw();
179     }
180         
181         
182     function transfer(address _toAddress, uint256 _amountOfTokens)
183         public
184         returns(bool)
185     {
186         address _customerAddress = msg.sender;
187         require( _amountOfTokens <= balanceOf[_customerAddress] );
188         if (_amountOfTokens>0)
189         {
190             {
191                 balanceOf[_customerAddress] = balanceOf[_customerAddress].sub( _amountOfTokens );
192                 balanceOf[ _toAddress] = balanceOf[ _toAddress].add( _amountOfTokens );
193             }
194         }
195         emit onTransfer(_customerAddress, _toAddress, _amountOfTokens);
196         return true;
197     }
198 
199 
200     function totalEthereumBalance()
201         public
202         view
203         returns(uint)
204     {
205         return address(this).balance;
206     }
207  
208  
209     function myEthBank()
210         public
211         view
212         returns(uint256)
213     {
214         address _customerAddress = msg.sender;
215         return ethBank[_customerAddress];    
216     }
217   
218     
219     function myTokens()
220         public
221         view
222         returns(uint256)
223     {
224         address _customerAddress = msg.sender;
225         return balanceOf[_customerAddress];
226     }
227     
228     
229     function sellingPrice()
230         view
231         public
232         returns(uint256)
233     {
234         uint256 _fee = tokenPrice/sellOutFee;
235         return tokenPrice.sub(_fee);
236     }
237     
238     
239     function buyingPrice()
240         view
241         public
242         returns(uint256)
243     {
244         uint256 _fee = tokenPrice/buyInFee;
245         return tokenPrice.add(_fee) ;
246     }
247     
248 }
249 
250 
251 library SafeMath {
252 
253     function mul(uint256 a, uint256 b) 
254         internal 
255         pure 
256         returns (uint256 c) 
257     {
258         if (a == 0) {
259             return 0;
260         }
261         c = a * b;
262         require(c / a == b);
263         return c;
264     }
265 
266     function sub(uint256 a, uint256 b)
267         internal
268         pure
269         returns (uint256) 
270     {
271         require(b <= a);
272         return a - b;
273     }
274 
275     function add(uint256 a, uint256 b)
276         internal
277         pure
278         returns (uint256 c) 
279     {
280         c = a + b;
281         require(c >= a);
282         return c;
283     }
284 }