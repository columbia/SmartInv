1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 contract Ownable {
49   address public owner;
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) public onlyOwner {
76     require(newOwner != address(0));
77     emit OwnershipTransferred(owner, newOwner);
78     owner = newOwner;
79   }
80 
81 }
82 contract CryptoPokerBase is Ownable
83 {
84     using SafeMath for uint256;
85     enum CardStatus
86     {
87         Frozen,
88         Tradable
89     }
90     
91     struct Card
92     {
93         uint256 id;
94         uint256 sellPrice;
95         //card status 
96         CardStatus status;
97         //card update
98         uint256 upTime;
99     }
100     
101     mapping(uint256=>address) cardToOwer;
102     mapping(address=>uint256) ownerCardCount;
103     mapping(uint256=>uint256) idToCardIndex;
104     mapping(address=>bool) workers;
105     
106     Card[] allCards;
107     address[] workerArr;
108     
109     uint256 upIndex = 0;
110    
111     bool saleStatus = true;
112     uint256 salePrice = 90000000000000000;
113     
114     
115     modifier isWorker()
116     {
117         require(msg.sender == owner || workers[msg.sender]);
118         _;
119     }
120     
121     modifier canSale()
122     {
123         require(saleStatus);
124         _;
125     }
126     
127     
128     function setWorkerAdress(address _adress) external onlyOwner
129     {
130         require(_adress!=address(0));
131         workers[_adress] = true;
132         workerArr.push(_adress);
133     }
134     
135     function deleteWorkerAdress(address _adress) external onlyOwner
136     {
137         require(_adress!=address(0));
138         workers[_adress] = false;
139     }
140     
141     function getAllWorkers() external view isWorker returns(address[],bool[])
142     {
143         address[] memory addressArr = new address[](workerArr.length);
144         bool[] memory statusArr = new bool[](workerArr.length);
145         for(uint256 i=0;i<workerArr.length;i++)
146         {
147             addressArr[i] = workerArr[i];
148             statusArr[i] = workers[workerArr[i]];
149         }
150         return (addressArr,statusArr);
151     }
152     
153 
154     function setSaleStatus(bool value) external isWorker
155     {
156         saleStatus = value;
157     }
158     
159     function getSaleStatus() external view returns(bool)
160     {
161         return saleStatus;
162     }
163     
164     function setSalePrice(uint256 value) external isWorker
165     {
166         salePrice = value;
167     }
168     
169     function getSalePrice() external view returns(uint256)
170     {
171         return salePrice;
172     }
173     
174    
175     function withdraw() external isWorker
176     {
177         owner.transfer(this.balance);
178     }
179     
180     function getBalance() external view returns(uint256)
181     {
182         return this.balance;
183     }
184 
185     
186 }
187 contract CryptoPokerMarket is CryptoPokerBase
188 {
189     
190     event fallbackTrigged(bytes data);
191     event saleCardEvent(address _address,uint256 price);
192     event createSaleCardEvent(address _address);
193 
194     function() public payable
195     {
196         emit fallbackTrigged(msg.data);
197     }
198     
199     function buySaleCardFromSys() external canSale payable
200     {
201         require(msg.value>=salePrice);
202         emit saleCardEvent(msg.sender,msg.value);
203     }
204     
205     function createSaleCardToPlayer(uint256[] ids,address _address) external isWorker
206     {
207         require(_address != address(0));
208         for(uint256 i=0;i<ids.length;i++)
209         {
210             if(cardToOwer[ids[i]] == address(0))
211             {
212                 allCards.push(Card(ids[i],0,CardStatus.Tradable,upIndex));
213                 idToCardIndex[ids[i]] = allCards.length - 1;
214                 cardToOwer[ids[i]] = _address;
215                 ownerCardCount[_address] = ownerCardCount[_address].add(1);    
216             }
217             
218         }
219         emit createSaleCardEvent(_address);
220     }
221 
222     
223     function balanceOf(address _owner) public view returns (uint256 _balance)
224     {
225         return ownerCardCount[_owner];
226     }
227       
228     function ownerOf(uint256 _tokenId) public view returns (address _owner)
229     {
230         return cardToOwer[_tokenId];    
231     }
232 }
233 contract CryptoPokerHelper is CryptoPokerMarket
234 {
235     
236     function getAllCardByAddress(address _address) external isWorker view returns(uint256[],uint256[])
237     {
238         require(_address!=address(0));
239         uint256[] memory result = new uint256[](ownerCardCount[_address]);
240         uint256[] memory cardStatus = new uint256[](ownerCardCount[_address]);
241         uint counter = 0;
242         for (uint i = 0; i < allCards.length; i++)
243         {
244             uint256 cardId = allCards[i].id;
245             if (cardToOwer[cardId] == _address) {
246                 result[counter] = cardId;
247                 cardStatus[counter] = allCards[i].sellPrice;
248                 counter++;
249             }
250          }
251          return (result,cardStatus);
252     }
253     
254     function getSelfCardDatas() external view returns(uint256[],uint256[])
255     {
256         uint256 count = ownerCardCount[msg.sender];
257         uint256[] memory result = new uint256[](count);
258         uint256[] memory resultPrice = new uint256[](count);
259         if(count > 0)
260         {
261             uint256 counter = 0;
262             for (uint256 i = 0; i < allCards.length; i++)
263             {
264                 uint256 cardId = allCards[i].id;
265                 if (cardToOwer[cardId] == msg.sender) {
266                     result[counter] = cardId;
267                     resultPrice[counter] = allCards[i].sellPrice;
268                     counter++;
269                 }
270             }
271         }
272         return (result,resultPrice);
273     }
274     
275     
276     function getSelfBalance() external view returns(uint256)
277     {
278         return(address(msg.sender).balance);
279     }
280     
281     
282     function getAllCardDatas() external view isWorker returns(uint256[],uint256[],address[])
283     {
284         uint256 len = allCards.length;
285         uint256[] memory resultIdArr = new uint256[](len);
286         uint256[] memory resultPriceArr = new uint256[](len);
287         address[] memory addressArr = new address[](len);
288         
289         for(uint256 i=0;i<len;i++)
290         {
291             resultIdArr[i] = allCards[i].id;
292             resultPriceArr[i] = allCards[i].sellPrice;
293             addressArr[i] = cardToOwer[allCards[i].id];
294         }
295         return(resultIdArr,resultPriceArr,addressArr);
296     }
297 }