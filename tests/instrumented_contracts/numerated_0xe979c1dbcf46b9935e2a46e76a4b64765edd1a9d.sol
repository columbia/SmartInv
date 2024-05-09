1 pragma solidity ^0.4.11;
2 
3 contract Bills
4 {
5     string public name          = "Bills";
6     string public symbol        = "BLS";
7     uint public totalSupply     = 3000000;
8     uint public decimals        = 0;
9     uint public tokenPrice;
10     
11     address private Owner;
12     
13     uint ICOTill   = 1523145601;
14 	uint ICOStart  = 1520467201;
15     
16     mapping (address => uint) public balanceOf;
17     
18     event Transfer(address indexed from, address indexed to, uint value);
19     
20     modifier onlyModerator()
21     {
22         require(msg.sender == moderators[msg.sender].Address || msg.sender == Owner);
23         _;
24     }
25     
26     modifier onlyOwner()
27     {
28         require(msg.sender == Owner);
29         _;
30     }
31     
32     modifier isICOend()
33     {
34         require(now >= ICOTill);
35         _;
36     }
37     
38     function Bills() public
39     {
40         name                    = name;
41         symbol                  = symbol;
42         totalSupply             = totalSupply;
43         decimals                = decimals;
44         
45         balanceOf[this]         = 2800000;
46 		balanceOf[msg.sender]   = 200000;
47         Owner                   = msg.sender;
48     }
49     
50     struct Advert
51     {
52         uint BoardId;
53         uint PricePerDay;
54         uint MaxDays;
55         address Advertiser;
56         string AdvertSrc;
57         uint Till;
58         uint AddTime;
59         uint SpentTokens;
60         string Status;
61         bool AllowLeasing;
62     }
63     
64     struct Moderator
65     {
66         address Address;
67     }
68     
69     mapping (uint => Advert) info;
70     
71     mapping (address => Moderator) moderators;
72     
73     uint[] Adverts;
74     address[] Moderators;
75     
76     function() public payable
77     {
78         require(now >= ICOStart || now >= ICOTill);
79         
80         if(now >= ICOStart && now <= ICOTill)
81         {
82             require(
83                 msg.value == 100000000000000000 || msg.value == 300000000000000000 || msg.value == 500000000000000000 || msg.value == 800000000000000000 || 
84                 msg.value == 1000000000000000000 || msg.value == 3000000000000000000 || msg.value == 5000000000000000000
85             );
86             
87             if(msg.value == 100000000000000000)
88             {
89                 require(balanceOf[this] >= 31);
90                 balanceOf[msg.sender] += 31;
91                 balanceOf[this] -= 31;
92                 Transfer(this, msg.sender, 31);
93             }
94             if(msg.value == 300000000000000000)
95             {
96                 require(balanceOf[this] >= 95);
97                 balanceOf[msg.sender] += 95;
98                 balanceOf[this] -= 95;
99                 Transfer(this, msg.sender, 95);
100             }
101             if(msg.value == 500000000000000000)
102             {
103                 require(balanceOf[this] >= 160);
104                 balanceOf[msg.sender] += 160;
105                 balanceOf[this] -= 160;
106                 Transfer(this, msg.sender, 160);
107             }
108             if(msg.value == 800000000000000000)
109             {
110                 require(balanceOf[this] >= 254);
111                 balanceOf[msg.sender] += 254;
112                 balanceOf[this] -= 254;
113                 Transfer(this, msg.sender, 254);
114             }
115             if(msg.value == 1000000000000000000)
116             {
117                 require(balanceOf[this] >= 317);
118                 balanceOf[msg.sender] += 317;
119                 balanceOf[this] -= 317;
120                 Transfer(this, msg.sender, 317);
121             }
122             if(msg.value == 3000000000000000000)
123             {
124                 require(balanceOf[this] >= 938);
125                 balanceOf[msg.sender] += 938;
126                 balanceOf[this] -= 938;
127                 Transfer(this, msg.sender, 938);
128             }
129             if(msg.value == 5000000000000000000)
130             {
131                 require(balanceOf[this] >= 1560);
132                 balanceOf[msg.sender] += 1560;
133                 balanceOf[this] -= 1560;
134                 Transfer(this, msg.sender, 1560);
135             }
136         }
137         
138         if(now >= ICOTill)
139         {
140             require(msg.sender.balance >= msg.value);
141             
142             uint _Amount = msg.value / tokenPrice;
143             
144             require(balanceOf[this] >= _Amount);
145             
146             balanceOf[msg.sender] += _Amount;
147             balanceOf[this] -= _Amount;
148             
149             Transfer(this, msg.sender, _Amount);
150         }
151     }
152     
153     function ContractBalance() public view returns (uint)
154     {
155         return balanceOf[this];
156     }
157     
158     function LeaseBill(uint BoardId, uint Days, string AdvertSrc) isICOend public 
159     {
160         var Advr = info[BoardId];
161         
162         uint Price = Days * Advr.PricePerDay;
163         
164         require(Advr.BoardId == BoardId && BoardId > 0);
165         require(bytes(AdvertSrc).length > 0);
166         require(Days <= Advr.MaxDays && Days > 0);
167         require(balanceOf[msg.sender] >= Price);
168         require(Advr.Till <= now);
169         require(Advr.AllowLeasing == true);
170         require(keccak256(Advr.Status) == keccak256("Free") || keccak256(Advr.Status) == keccak256("Published"));
171         
172         require(balanceOf[this] + Price >= balanceOf[this]);
173         balanceOf[msg.sender] -= Price;
174         balanceOf[this] += Price;
175         Transfer(msg.sender, this, Price);
176         
177         Advr.Advertiser         = msg.sender;
178         Advr.AdvertSrc          = AdvertSrc;
179         Advr.Till               = now + 86399 * Days;
180         Advr.AddTime            = now;
181         Advr.SpentTokens        = Price;
182         Advr.Status             = "Moderate";
183     }
184     
185     function ModerateBill(uint BoardIdToModerate, bool Published) onlyModerator isICOend public
186     {
187         var Advr = info[BoardIdToModerate];
188         
189         require(Advr.BoardId == BoardIdToModerate && BoardIdToModerate > 0);
190         
191         if(Published == true)
192         {
193             require(keccak256(Advr.Status) == keccak256("Moderate"));
194         
195             uint CompensateTime   = now - Advr.AddTime;
196             
197             Advr.Till             = Advr.Till + CompensateTime;
198             Advr.Status           = "Published";
199         }
200         
201         if(Published == false)
202         {
203             require(keccak256(Advr.Status) == keccak256("Moderate"));
204             
205 			require(balanceOf[this] >= Advr.SpentTokens);
206 			
207             balanceOf[Advr.Advertiser] += Advr.SpentTokens;
208             balanceOf[this] -= Advr.SpentTokens;
209             Transfer(this, Advr.Advertiser, Advr.SpentTokens);
210             
211             delete Advr.Advertiser;
212             delete Advr.AdvertSrc;
213             delete Advr.Till;
214             delete Advr.AddTime;
215             delete Advr.SpentTokens;
216             
217             Advr.Status = "Free";
218         }
219     }
220     
221     function ChangeBillLeasingInfo(uint _BillToEdit, uint _NewPricePerDay, uint _NewMaxDays, bool _AllowLeasing) onlyOwner isICOend public
222     {
223         var Advr = info[_BillToEdit];
224         
225         require(Advr.BoardId == _BillToEdit && _BillToEdit > 0 && _NewPricePerDay > 0 && _NewMaxDays > 0);
226         
227         Advr.BoardId          = _BillToEdit;
228         Advr.PricePerDay      = _NewPricePerDay;
229         Advr.MaxDays          = _NewMaxDays;
230         Advr.AllowLeasing     = _AllowLeasing;
231     }
232     
233     function AddBill(uint NewBoardId, uint PricePerDay, uint MaxDays, bool _AllowLeasing) onlyOwner isICOend public
234     {
235         var Advr              = info[NewBoardId];
236         
237         require(Advr.BoardId  != NewBoardId && NewBoardId > 0 && PricePerDay > 0 && MaxDays > 0);
238         
239         Advr.BoardId          = NewBoardId;
240         Advr.PricePerDay      = PricePerDay;
241         Advr.MaxDays          = MaxDays;
242         Advr.Status           = "Free";
243         Advr.AllowLeasing     = _AllowLeasing;
244         
245         Adverts.push(NewBoardId);
246     }
247     
248     function AddBillModerator(address Address) onlyOwner isICOend public
249     {
250         var Modr = moderators[Address];
251         
252         require(Modr.Address != Address);
253         
254         Modr.Address = Address;
255         
256         Moderators.push(Address);
257     }
258     
259     function DeleteBillModerator(address _Address) onlyOwner isICOend public
260     {
261         delete moderators[_Address];
262     }
263     
264     function AboutBill(uint _BoardId) public view returns (uint BoardId, uint PricePerDay, uint MaxDays, string AdvertSource, uint AddTime, uint Till, string Status, bool AllowLeasing)
265     {
266         var Advr = info[_BoardId];
267         
268         return (Advr.BoardId, Advr.PricePerDay, Advr.MaxDays, Advr.AdvertSrc, Advr.AddTime, Advr.Till, Advr.Status, Advr.AllowLeasing);
269     }
270     
271     function SetTokenPrice(uint _Price) onlyOwner isICOend public
272     {
273         tokenPrice = _Price;
274     }
275 	
276 	function transfer(address _to, uint _value) public
277 	{
278         require(balanceOf[msg.sender] >= _value);
279         require(balanceOf[_to] + _value >= balanceOf[_to]);
280         
281         balanceOf[msg.sender] -= _value;
282         balanceOf[_to] += _value;
283         Transfer(msg.sender, _to, _value);
284     }
285     
286     function WithdrawEther() onlyOwner public
287     {
288         Owner.transfer(this.balance);
289     }
290     
291     function ChangeOwner(address _Address) onlyOwner public
292     {
293         Owner = _Address;
294     }
295 }