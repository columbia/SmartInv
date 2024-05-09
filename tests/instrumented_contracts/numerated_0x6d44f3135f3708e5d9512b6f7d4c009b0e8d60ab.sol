1 pragma solidity ^0.4.9; 
2 //v.1609rev17 Ezlab 2016 all-rights reseved support@ezlab.it
3 //special purpose contract for CantinaVolpone further info https://agrichain.it/d/0x160564d346f6e9fb3d93c034f207ecf9791b7739
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
39 
40 
41 
42 
43 
44 // production 
45 contract AgriChainContract   is BaseAgriChainContract    
46 {  
47     string  public  Organization;      //Production Organization
48     string  public  Product ;          //Product
49     string  public  Description ;      //Description
50     address public  AgriChainData;     //ProductionData
51     string  public  AgriChainSeal;     //SecuritySeal
52     string  public  Notes ;
53     
54     function   AgriChainProductionContract() public
55     { 
56        AgriChainData=address(this);
57     }
58     
59     function setOrganization(string _Organization)  onlyBy(creator)  onlyIfNotSealed()
60     {
61           Organization = _Organization;
62           EventChangedString(this,'Organization',_Organization);
63 
64     }
65     
66     function setProduct(string _Product)  onlyBy(creator) onlyIfNotSealed()
67     {
68           Product = _Product;
69           EventChangedString(this,'Product',_Product);
70         
71     }
72     
73     function setDescription(string _Description)  onlyBy(creator) onlyIfNotSealed()
74     {
75           Description = _Description;
76           EventChangedString(this,'Description',_Description);
77     }
78     function setAgriChainData(address _AgriChainData)  onlyBy(creator) onlyIfNotSealed()
79     {
80          AgriChainData = _AgriChainData;
81          EventChangedAddress(this,'AgriChainData',_AgriChainData);
82     }
83     
84     
85     function setAgriChainSeal(string _AgriChainSeal)  onlyBy(creator) onlyIfNotSealed()
86     {
87          AgriChainSeal = _AgriChainSeal;
88          EventChangedString(this,'AgriChainSeal',_AgriChainSeal);
89     }
90     
91     
92      
93     function setNotes(string _Notes)  onlyBy(creator)
94     {
95          Notes =  _Notes;
96          EventChanged(this,'Notes');
97     }
98 }
99 
100 
101 //InnerData
102 contract AgriChainDataContract   is BaseAgriChainContract    
103 {  
104     function   AgriChainDataContract() public
105     {
106         AgriChainNextData=address(this);
107         AgriChainPrevData=address(this);
108         AgriChainRootData=address(this);
109     }
110     
111       address public  AgriChainNextData;
112       address public  AgriChainPrevData;
113       address public  AgriChainRootData;
114       
115       string public AgriChainType;
116       string public AgriChainLabel;
117       string public AgriChainLabelInt;
118       string public AgriChainDescription;
119       string public AgriChainDescriptionInt;
120       
121     function setChain(address _Next,address _Prev, address _Root)  onlyBy(creator)  
122     {
123          AgriChainNextData=_Next;
124          AgriChainPrevData=_Prev;
125          AgriChainRootData=_Root;
126          EventChanged(this,'Chain');
127     }
128     
129     //main language data  
130     function setData(string _Type,string _Label,string _Description)  onlyBy(creator) onlyIfNotSealed()
131     {
132           AgriChainType=_Type;
133           AgriChainLabel=_Label;
134           AgriChainDescription=_Description;
135           EventChanged(this,'Data');
136     }
137    
138     //International language data
139     function setDataInt(string _LabelInt,string _DescriptionInt)  onlyBy(creator) onlyIfNotSealed()
140     {
141           
142           AgriChainLabelInt=_LabelInt;
143           AgriChainDescriptionInt=_DescriptionInt;
144           EventChanged(this,'DataInt');
145     }
146    
147       
148 }
149 
150 //DocumentData
151 contract AgriChainDocumentContract   is AgriChainDataContract    
152 {  
153      
154     string  public  Emitter;      //Organization
155     string  public  Name;         //Name
156     string  public  Description ; //Description
157     string  public  NameInt;         //Name International
158     string  public  DescriptionInt ; //Description International
159 
160     string  public  FileName;     //FileName
161     string  public  FileHash;     //FileHash
162     string  public  FileData;     //FileData
163    
164     string  public  FileNameInt;  //FileName International
165     string  public  FileHashInt;  //FileHash International
166     string  public  FileDataInt;  //FileData International
167 
168     string  public  Notes ;
169     address public  Revision; 
170     
171     function   AgriChainDocumentContract() public
172     {
173         Revision=address(this);
174     }
175     
176     function setData(string _Emitter,string _Name,string _Description, string _FileName,string _FileHash,string _FileData)  onlyBy(creator) onlyIfNotSealed()
177     {
178           Emitter=_Emitter;
179           Name=_Name;
180           Description=_Description;
181           FileName=_FileName;
182           FileHash=_FileHash;
183           FileData=_FileData;          
184           EventChanged(this,'Data');
185        
186     } 
187     
188      
189     
190     function setRevision(address _Revision)  onlyBy(creator) onlyIfNotSealed()
191     {
192           Revision = _Revision;
193         
194     } 
195      
196      
197     function setNotes(string _Notes)  onlyBy(creator)
198     {
199          Notes =  _Notes;
200          
201     }
202 }
203 
204 
205 //
206 contract AgriChainProductionLotContract   is AgriChainDataContract    
207 {  
208     
209      int32  public QuantityInitial;
210      int32  public QuantityAvailable;
211      string public QuantityUnit;
212     
213     function InitQuantity(int32 _Initial,string _Unit)  onlyBy(creator)  onlyIfNotSealed()
214     {
215           QuantityInitial = _Initial;
216           QuantityAvailable = _Initial;
217           QuantityUnit = _Unit;
218           EventChangedInt32(this,'QuantityInitial',_Initial);
219 
220     }
221   
222     function UseQuantity(int32 _Use)  onlyBy(creator)  
223     {
224           QuantityAvailable = QuantityAvailable-_Use;
225           EventChangedInt32(this,'QuantityAvailable',QuantityAvailable);
226 
227     }
228   
229 }