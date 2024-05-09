1 contract Big{
2     function Big(){
3         Creator=msg.sender;
4     }
5 
6     uint8 CategoriesLength=0;
7     mapping(uint8=>Category) Categories;//array representation
8     struct Category{
9         bytes4 Id;
10         uint Sum;//moneys sum for category
11 
12         address Owner;
13         uint8 ProjectsFee;
14         uint8 OwnerFee;
15 
16         uint24 VotesCount;
17         mapping(address=>uint24) Ranks;//small contract addr->rank
18         mapping(uint24=>Vote) Votes;//array representation
19     }
20     struct Vote{
21         address From;
22         address To;
23 		uint8 TransactionId;
24     }
25     uint24 SmallContractsLength=0; 
26     mapping(uint24=>address) SmallContracts;//array of small contracts
27     
28     address private Creator;//addres of god
29     uint16 constant defaultRank=1000;
30     uint8 constant koef=2/1;
31 	uint constant ThanksCost = 10 finney;
32 
33     function GetCategoryNumber(bytes4 categoryId) returns(uint8) {
34         for (uint8 i=0;i<CategoriesLength;i++){
35             if(Categories[i].Id==categoryId)
36                 return i;
37         }
38         return 255;
39     }
40     function GetCategoryValue(uint8 categoryNumber) returns (uint){ 
41         return Categories[categoryNumber].Sum;
42     }
43 	function CheckUserVote(uint8 categoryNumber,uint8 transactionId) returns (bool){
44 		for (uint24 i = Categories[categoryNumber].VotesCount-1;i >0;i--){
45             if(Categories[categoryNumber].Votes[i].TransactionId==transactionId) 
46                 return true;     
47         }
48 		if(Categories[categoryNumber].Votes[0].TransactionId==transactionId){
49                 return true;  
50         }
51 		return false;
52 	}
53     function GetUserRank(uint8 categoryNumber,address user) returns (uint24){ 
54         return Categories[categoryNumber].Ranks[user];
55     }
56     function GetSmallCotractIndex(address small) returns (uint24){
57         for (uint24 i=0;i<SmallContractsLength;i++){
58             if(SmallContracts[i]==small)
59                 return i;
60         }
61         return 16777215;
62     }
63     
64     function AddNewSmallContract(address small){
65         if(msg.sender == Creator && GetSmallCotractIndex(small)==16777215){
66                 SmallContracts[SmallContractsLength]=small;
67                 SmallContractsLength++;
68         }
69     }
70     function AddNewCategory(bytes4 categoryId,uint8 projectsFee,uint8 ownerFee, address owner){
71         if(msg.sender == Creator && GetCategoryNumber(categoryId)==255){
72             Categories[CategoriesLength].Id= categoryId;
73             Categories[CategoriesLength].ProjectsFee= projectsFee;
74             Categories[CategoriesLength].OwnerFee= ownerFee;
75             Categories[CategoriesLength].Owner= owner;
76             Categories[CategoriesLength].Sum = 0;
77             CategoriesLength++;
78         }
79     }
80 
81     
82 	struct Calculation{
83 		uint16 totalVotes;
84 		uint24 rank;
85 	}
86     function CalcAll(){
87         if(msg.sender==Creator){//only god can call this method
88             uint24 i;//iterator variable
89 			
90             for(uint8 prC=0; prC<CategoriesLength; prC++){
91                 Category category = Categories[prC];
92                 
93                 uint16 smallsCount = 0;//count of small contracts that got some rank
94                 mapping(address=>Calculation) temporary;//who->votesCount  (tootal voes from address)
95                 //calc users total votes          
96 				
97 				for (i = 0;i < category.VotesCount;i++){
98                     temporary[category.Votes[i].From].totalVotes = 0; 
99                 }	
100 				
101                 for (i = 0;i < category.VotesCount;i++){
102 					if(temporary[category.Votes[i].From].totalVotes == 0) {
103 						temporary[category.Votes[i].From].rank = category.Ranks[category.Votes[i].From];
104 					}
105                     temporary[category.Votes[i].From].totalVotes++; 
106 					
107                 }			
108 				
109                 // calculate new additional ranks
110                 for (i = 0;i < category.VotesCount;i++){ //iterate for each vote in category
111                     Vote vote=category.Votes[i];
112                     category.Ranks[vote.To] += temporary[vote.From].rank / (temporary[vote.From].totalVotes * koef);//add this vote weight
113 								// weight of vote measures in the (voters rank/( count of voters total thanks * 2)
114                 }                          
115             }
116         }
117     }
118     
119     function NormalizeMoney(){
120         if(msg.sender==Creator){
121             uint sumDifference=this.balance;
122             uint transactionCost = 5 finney;
123 			uint8 luckyCategoryIndex = 255;
124 			
125         	for (uint8 prC = 0;prC < CategoriesLength;prC++) {
126         	    sumDifference -= Categories[prC].Sum;
127         	    
128         	    uint ownerFee = (Categories[prC].Sum * Categories[prC].OwnerFee) / 100;
129         	    if (ownerFee >0) Categories[prC].Owner.send(ownerFee);
130         	    Categories[prC].Sum -= ownerFee;
131         	    
132             	if (luckyCategoryIndex == 255 && Categories[prC].Sum > transactionCost){
133             	    luckyCategoryIndex = prC;
134             	}
135         	}
136         	
137         	if (sumDifference > transactionCost){
138         	    Creator.send(sumDifference - transactionCost);
139         	}
140         	else{
141         	    if (luckyCategoryIndex != 255){
142         	        Categories[luckyCategoryIndex].Sum -= (transactionCost - sumDifference);
143         	    }
144         	}
145         }
146     }
147     
148 	function NormalizeRanks(){
149 		if(msg.sender==Creator){
150 			uint32 accuracyKoef = 100000; //magic number 100000 is for accuracy
151 		
152 			uint24 i=0;
153 			for(uint8 prC=0; prC<CategoriesLength; prC++){
154                 Category category = Categories[prC];
155 				uint additionalRanksSum = 0; //sum of all computed additional ranks (rank - default rank) in category
156 				uint16 activeSmallContractsInCategoryCount = 0;
157 
158 				for(i = 0;i<SmallContractsLength;i++){
159 					if (category.Ranks[SmallContracts[i]] != 0){
160 						additionalRanksSum += category.Ranks[SmallContracts[i]] - defaultRank;
161 						activeSmallContractsInCategoryCount++;
162 					}			
163 				}
164 
165 				if (additionalRanksSum > activeSmallContractsInCategoryCount * defaultRank)//normalize ranks if addition of ranks is more than all users can have
166                 {
167 					uint24 normKoef = uint24(additionalRanksSum / activeSmallContractsInCategoryCount);
168 					for (i = 0;i < SmallContractsLength;i++){
169 						if (category.Ranks[SmallContracts[i]] > defaultRank){
170 							category.Ranks[SmallContracts[i]] = defaultRank + uint24(((uint)(category.Ranks[SmallContracts[i]] - defaultRank) * defaultRank)/ normKoef);
171 						}
172 					}
173 					additionalRanksSum = activeSmallContractsInCategoryCount * defaultRank;
174                 }
175 				if (category.Sum > 0)
176 				{
177 					for (i = 0;i < SmallContractsLength;i++)
178 					{
179 						if (category.Ranks[SmallContracts[i]] > defaultRank)
180 						{
181 							//just split sum in deendence of what rank users have							
182 							smallContractsIncoming[i] += accuracyKoef*(category.Sum / (accuracyKoef*additionalRanksSum / (category.Ranks[SmallContracts[i]] - defaultRank)));
183 						}
184 					}
185 				}
186 			}	
187 		}
188 	}
189     mapping(uint24=> uint) smallContractsIncoming;//stores ether count per small contract
190     function SendAllMoney(){
191         if(msg.sender==Creator) { 
192             for (uint24 i = 0;i < SmallContractsLength;i++){
193                 if(smallContractsIncoming[i] > 0 ){//if more than 0.005 ether
194                     SmallContracts[i].send(smallContractsIncoming[i]);//send ether to wallet
195                     smallContractsIncoming[i]=0;
196                 }
197             }
198         }
199     }
200     function Reset(){
201         if(msg.sender==Creator) { 
202             for(uint8 prC=0; prC<CategoriesLength; prC++){//in each contract
203               Categories[prC].VotesCount=0; //reset votes
204               Categories[prC].Sum=0; //reset ether sum 
205             }
206         }
207     }
208 
209     function GetMoney(uint weiAmount,address to){
210         if(msg.sender==Creator) { 
211             to.send(weiAmount);
212         }
213     }
214     function SetRank(uint8 categoryNumber,address small,uint16 rank){
215         if(msg.sender == Creator){
216             Category category=Categories[categoryNumber];
217             category.Ranks[small]=rank;
218         }
219     }
220 	
221 	function SetNewBigContract(address newBigContractAddress){
222 		if(msg.sender == Creator){
223 			for(uint24 i = 0;i<SmallContractsLength;i++){
224 				Small s= Small(SmallContracts[i]);	
225 				s.SetBigContract(newBigContractAddress);
226 			}
227 		}
228 	}
229     
230 	function ThanksInternal (address from,address to, uint8 categoryNumber,uint8 transactionId) private {
231         if(categoryNumber==255||GetSmallCotractIndex(from)==16777215||GetSmallCotractIndex(to)==16777215) return;
232         
233         Category category=Categories[categoryNumber];
234 		
235 		Small s= Small(from);
236         s.GetMoney(ThanksCost,this);	
237         category.Sum+=ThanksCost;
238         
239         if(category.Ranks[from]==0){
240             category.Ranks[from]=defaultRank;
241         }      
242         if(category.Ranks[to]==0){
243             category.Ranks[to]=defaultRank;
244         }
245 
246 		category.Votes[category.VotesCount].From=from;
247         category.Votes[category.VotesCount].To=to;
248 		category.Votes[category.VotesCount].TransactionId=transactionId;
249         category.VotesCount++;
250     }	
251 	function Thanks (address from,address to,uint8 categoryNumber,uint8 transactionId){
252 		if(msg.sender != Creator) return;	
253 		ThanksInternal(from,to,categoryNumber,transactionId);
254 	}
255 	
256     function UniversalFunction(uint8 functionNumber,bytes32 p1,bytes32 p2,bytes32 p3,bytes32 p4,bytes32 p5){
257         if(GetSmallCotractIndex(msg.sender)==16777215) return;
258         
259         if(functionNumber == 1){
260             ThanksInternal(msg.sender,address(p1),uint8(p2),0);
261         }
262         if(functionNumber == 2){
263             Small s= Small(msg.sender);
264             s.GetMoney(uint(p1),address(p2));
265         }
266     }
267 }
268 
269 
270 contract Small {
271     Big b;
272   
273     address private owner;
274 
275     function Small(address bigAddress){
276         b=Big(bigAddress);
277         owner = msg.sender;
278     }
279     function GetOwner() returns (address){
280         return owner;
281     }
282     function SetOwner(address newOwner){
283         if(msg.sender == owner) {
284             owner = newOwner;
285         }
286     }
287 
288     function SetBigContract(address newAddress){
289         if(msg.sender==address(b)) { 
290             b=Big(newAddress);
291         }
292     }
293     function GetMoney(uint weiAmount,address toAddress){
294         if(msg.sender==address(b)) { 
295             toAddress.send(weiAmount);
296         }
297     }
298     function UniversalFunctionSecure(uint8 functionNumber,bytes32 p1,bytes32 p2,bytes32 p3,bytes32 p4,bytes32 p5){
299         if(msg.sender == owner) {
300             b.UniversalFunction(functionNumber,p1,p2,p3,p4,p5);
301         }
302     }
303 }