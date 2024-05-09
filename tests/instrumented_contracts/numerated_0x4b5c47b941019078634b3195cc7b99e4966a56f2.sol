1 pragma solidity ^0.4.18; 
2 //v.1609rev1801 Ezlab 2016-2018 all-rights reseved support@ezlab.it
3 //special purpose contract for  further info use case  https://agrichain.it/d/v1801
4 
5 //common base contract
6 contract BaseAgriChainContract {
7     address creator; 
8     bool public isSealed;
9     function BaseAgriChainContract() public    {  creator = msg.sender; EventCreated(this,creator); }
10     modifier onlyIfNotSealed() //semantic when sealed is not possible to change sensible data
11     {
12         if (isSealed)
13             throw;
14         _;
15     }
16 
17     modifier onlyBy(address _account) //semantic only _account can operate
18     {
19         if (msg.sender != _account)
20             throw;
21         _;
22     }
23     
24     function kill() onlyBy(creator)   { suicide(creator); }     
25     function setCreator(address _creator)  onlyBy(creator)  { creator = _creator;     }
26     function setSealed()  onlyBy(creator)  { isSealed = true;  EventSealed(this);   } //seal down contract not reversible
27 
28     event EventCreated(address self,address creator);
29     event EventSealed(address self); //invoked when contract is sealed
30     event EventChanged(address self,string property); // generic property change
31     event EventChangedInt32(address self,string property,int32 value); //Int32 property change
32     event EventChangedString(address self,string property,string value); //string property Change
33     event EventChangedAddress(address self,string property,address value); //address property Changed
34     
35   
36 }
37 
38 
39 //ChainedContract
40 contract AgriChainContract   is BaseAgriChainContract    
41 {     string public AgriChainType;
42       address public  AgriChainNextData;
43       address public  AgriChainPrevData;
44       address public  AgriChainRootData;
45     
46     function   AgriChainDataContract() public
47     {
48         AgriChainNextData=address(this);
49         AgriChainPrevData=address(this);
50         AgriChainRootData=address(this);
51     }
52     
53      
54       
55       
56       
57     function setChain(string _Type,address _Next,address _Prev, address _Root)  onlyBy(creator)  
58     {
59          AgriChainType=_Type;
60          AgriChainNextData=_Next;
61          AgriChainPrevData=_Prev;
62          AgriChainRootData=_Root;
63          EventChanged(this,'Chain');
64     }
65     
66      function setChainNext(address _Next)  onlyBy(creator)  
67     {
68          AgriChainNextData=_Next;
69          EventChangedAddress(this,'ChainNext',_Next);
70     }
71    
72 
73     function setChainPrev(address _Prev)  onlyBy(creator)  
74     {
75          AgriChainPrevData=_Prev;
76          EventChangedAddress(this,'ChainNext',_Prev);
77     }
78     
79    
80    function setChainRoot(address _Root)  onlyBy(creator)  
81     {
82          AgriChainRootData=_Root;
83          EventChangedAddress(this,'ChainRoot',_Root);
84     }
85     
86      function setChainType(string _Type)  onlyBy(creator)  
87     {
88          AgriChainType=_Type;
89          EventChangedString(this,'ChainType',_Type);
90     }
91       
92 }
93 
94 
95 // Master activities 
96 contract AgriChainMasterContract   is AgriChainContract    
97 {  
98     address public  AgriChainContext;  //Context Data Chain
99     address public  AgriChainCultivation;  //Cultivation Data Chain
100     address public  AgriChainProduction;   //Production Data Chain
101     address public  AgriChainDistribution; //Distribution Data Chain
102     address public  AgriChainDocuments; //Distribution Data Chain
103 
104     function   AgriChainMasterContract() public
105     { 
106        AgriChainContext=address(this);
107        AgriChainCultivation=address(this);
108        AgriChainProduction=address(this);
109        AgriChainDistribution=address(this);
110        
111     }
112     function setAgriChainProduction(address _AgriChain)  onlyBy(creator) onlyIfNotSealed()
113     {
114          AgriChainProduction = _AgriChain;
115          EventChangedAddress(this,'AgriChainProduction',_AgriChain);
116     }
117     function setAgriChainCultivation(address _AgriChain)  onlyBy(creator) onlyIfNotSealed()
118     {
119          AgriChainCultivation = _AgriChain;
120          EventChangedAddress(this,'AgriChainCultivation',_AgriChain);
121     }
122     function setAgriChainDistribution(address _AgriChain)  onlyBy(creator) onlyIfNotSealed()
123     {
124          AgriChainDistribution = _AgriChain;
125          EventChangedAddress(this,'AgriChainDistribution',_AgriChain);
126     }
127     
128     function setAgriChainDocuments(address _AgriChain)  onlyBy(creator) onlyIfNotSealed()
129     {
130          AgriChainDocuments = _AgriChain;
131          EventChangedAddress(this,'AgriChainDocuments',_AgriChain);
132     }
133     function setAgriChainContext(address _AgriChain)  onlyBy(creator) onlyIfNotSealed()
134     {
135          AgriChainContext = _AgriChain;
136          EventChangedAddress(this,'AgriChainContext',_AgriChain);
137     }
138     
139 }
140 
141 
142 
143 // legacy production contract 
144 contract AgriChainProductionContract   is BaseAgriChainContract    
145 {  
146     string  public  Organization;      //Production Organization
147     string  public  Product ;          //Product
148     string  public  Description ;      //Description
149     address public  AgriChainData;     //ProductionData
150     string  public  AgriChainSeal;     //SecuritySeal
151     string  public  Notes ;
152     
153     function   AgriChainProductionContract() public
154     { 
155        AgriChainData=address(this);
156     }
157     
158     function setOrganization(string _Organization)  onlyBy(creator)  onlyIfNotSealed()
159     {
160           Organization = _Organization;
161           EventChangedString(this,'Organization',_Organization);
162 
163     }
164     
165     function setProduct(string _Product)  onlyBy(creator) onlyIfNotSealed()
166     {
167           Product = _Product;
168           EventChangedString(this,'Product',_Product);
169         
170     }
171     
172     function setDescription(string _Description)  onlyBy(creator) onlyIfNotSealed()
173     {
174           Description = _Description;
175           EventChangedString(this,'Description',_Description);
176     }
177     function setAgriChainData(address _AgriChainData)  onlyBy(creator) onlyIfNotSealed()
178     {
179          AgriChainData = _AgriChainData;
180          EventChangedAddress(this,'AgriChainData',_AgriChainData);
181     }
182     
183     
184     function setAgriChainSeal(string _AgriChainSeal)  onlyBy(creator) onlyIfNotSealed()
185     {
186          AgriChainSeal = _AgriChainSeal;
187          EventChangedString(this,'AgriChainSeal',_AgriChainSeal);
188     }
189     
190     
191      
192     function setNotes(string _Notes)  onlyBy(creator)
193     {
194          Notes =  _Notes;
195          EventChanged(this,'Notes');
196     }
197 }
198 
199 
200 
201 //LoggedData
202 contract AgriChainDataContract   is AgriChainContract    
203 {  
204       string public AgriChainLabel;
205       string public AgriChainLabelInt;
206       string public AgriChainDescription;
207       string public AgriChainDescriptionInt;
208       
209     
210     //main language data  
211     function setData(string _Label,string _Description)  onlyBy(creator) onlyIfNotSealed()
212     {
213          
214           AgriChainLabel=_Label;
215           AgriChainDescription=_Description;
216           EventChanged(this,'Data');
217     }
218    
219     //International language data
220     function setDataInt(string _LabelInt,string _DescriptionInt)  onlyBy(creator) onlyIfNotSealed()
221     {
222           
223           AgriChainLabelInt=_LabelInt;
224           AgriChainDescriptionInt=_DescriptionInt;
225           EventChanged(this,'DataInt');
226     }
227    
228       
229 }
230 
231 //External DocumentData
232 //the extenal document is hashed  and chained as described by this contract
233 contract AgriChainDocumentContract   is AgriChainDataContract    
234 {  
235      
236     string  public  Emitter;      //Organization
237 
238     string  public  Name;         //Name
239     string  public  NameInt;         //Name International
240 
241     string  public  FileName;     //FileName
242     string  public  FileHash;     //FileHash
243     string  public  FileData;     //FileData
244    
245     string  public  FileNameInt;  //FileName International
246     string  public  FileHashInt;  //FileHash International
247     string  public  FileDataInt;  //FileData International
248 
249     string  public  Notes ;
250     address public  CurrentRevision; 
251     
252     function   AgriChainDocumentContract() public
253     {
254         CurrentRevision=address(this);
255     }
256     
257     function setDocumentData(string _Emitter,string _Name, string _FileName,string _FileHash,string _FileData)  onlyBy(creator) onlyIfNotSealed()
258     {
259           Emitter=_Emitter;
260           Name=_Name;
261           FileName=_FileName;
262           FileHash=_FileHash;
263           FileData=_FileData;          
264           EventChanged(this,'setDocumentData');
265        
266     } 
267     
268     function setCurrentRevision(address _Revision)  onlyBy(creator)  
269     {
270           CurrentRevision = _Revision;
271           EventChangedAddress(this,'CurrentRevision',_Revision);
272         
273     } 
274      
275      
276     function setNotes(string _Notes)  onlyBy(creator)
277     {
278          Notes =  _Notes;
279          
280     }
281 }
282 
283 
284 //Production Quntity counter contract
285 //the spedified production si accounted by this contract
286 contract AgriChainProductionLotContract   is AgriChainDataContract    
287 {  
288     
289      int32  public QuantityInitial;
290      int32  public QuantityAvailable;
291      string public QuantityUnit;
292     
293     function InitQuantity(int32 _Initial,string _Unit)  onlyBy(creator)  onlyIfNotSealed()
294     {
295           QuantityInitial = _Initial;
296           QuantityAvailable = _Initial;
297           QuantityUnit = _Unit;
298           EventChangedInt32(this,'QuantityInitial',_Initial);
299 
300     }
301   
302     function UseQuantity(int32 _Use)  onlyBy(creator)  
303     {
304           QuantityAvailable = QuantityAvailable-_Use;
305           EventChangedInt32(this,'QuantityAvailable',QuantityAvailable);
306 
307     }
308   
309 }