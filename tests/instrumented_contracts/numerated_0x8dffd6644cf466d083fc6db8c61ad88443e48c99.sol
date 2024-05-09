1 pragma solidity ^0.4.11;
2 
3 contract CertiMe {
4     // Defines a new type with two fields.
5     struct Certificate {
6         string certHash;
7         address issuer_addr;
8         address recepient_addr;
9         string version;
10         string content;
11         bool isRevoked;
12         uint256 issuance_time;
13     }
14 
15     uint numCerts;
16     mapping (uint => Certificate) public certificates;
17     mapping (string => Certificate) certHashKey;
18 
19     function newCertificate(address beneficiary, string certHash, string version, string content ) public returns (uint certID) {
20         certID = ++numCerts; // campaignID is return variable
21         // Creates new struct and saves in storage. We leave out the mapping type.
22         certificates[certID] = Certificate(certHash,msg.sender,beneficiary, version,content,false,block.timestamp);
23         certHashKey[certHash]=certificates[certID];
24     }
25     
26     function arraySum(uint[] arr) internal pure returns (uint){
27         uint len= 0;
28         for(uint i=0;i<arr.length;i++){
29             len+=arr[i];
30         }
31         return len;
32     }
33     function getCharacterCount(string str) pure internal returns (uint length)    {
34         uint i=0;
35         bytes memory string_rep = bytes(str);
36     
37         while (i<string_rep.length)
38         {
39             if (string_rep[i]>>7==0)
40                 i+=1;
41             else if (string_rep[i]>>5==0x6)
42                 i+=2;
43             else if (string_rep[i]>>4==0xE)
44                 i+=3;
45             else if (string_rep[i]>>3==0x1E)
46                 i+=4;
47             else
48                 //For safety
49                 i+=1;
50     
51             length++;
52         }
53     }    
54     function batchNewCertificate(address[] beneficiaries, string certHash, string version, string content,uint[] certHashChar, uint[] versionChar,uint[] contentChar) public returns (uint[]) {
55         //require(beneficiaries.length==certHashChar.length);
56         //require(versionChar.length==certHashChar.length);    
57         //require(versionChar.length==contentChar.length);        
58         //uint log=getCharacterCount(version);
59         //require(arraySum(versionChar)==getCharacterCount(version));             
60         //require(arraySum(certHashChar)==getCharacterCount(certHash));        
61         //require(arraySum(contentChar)==getCharacterCount(content));        
62 
63         
64         uint certHashCharSteps=0;
65         uint versionCharSteps=0;
66         uint contentCharSteps=0;
67         
68         uint[] memory certID = new uint[](beneficiaries.length);
69         for (uint i=0;i<beneficiaries.length;i++){
70             certID[i]=newCertificate(
71                 beneficiaries[i],
72                 substring(certHash,certHashCharSteps,(certHashCharSteps+certHashChar[i])),
73                 substring(version,versionCharSteps,(versionCharSteps+versionChar[i])),
74                 substring(content,contentCharSteps,(contentCharSteps+contentChar[i]))
75             );
76             
77             certHashCharSteps+=certHashChar[i];
78             versionCharSteps+=versionChar[i];
79             contentCharSteps+=contentChar[i];
80             
81         }
82         return certID;
83     }
84         
85     function revokeCertificate(uint targetCertID) public returns (bool){
86         if(msg.sender==certificates[targetCertID].issuer_addr){
87             certificates[targetCertID].isRevoked=true;
88             return true;
89         }else{
90             return false;
91         }
92     }
93 /*
94     function contribute(uint campaignID) public payable {
95         Campaign storage c = campaigns[campaignID];
96         // Creates a new temporary memory struct, initialised with the given values
97         // and copies it over to storage.
98         // Note that you can also use Funder(msg.sender, msg.value) to initialise.
99         c.funders[c.numFunders++] = CertIssuer({addr: msg.sender, amount: msg.value});
100         c.amount += msg.value;
101     }
102 */
103   /*  
104     function certHashExist(string value) constant returns (uint) {
105         for (uint i=1; i<numCerts+1; i++) {
106               if(stringsEqual(certificates[i].certHash,value)){
107                 return i;
108               }
109         }
110         
111         return 0;
112     }*/
113     function getMatchCountAddress(uint addr_type,address value) public constant returns (uint){
114         uint counter = 0;
115         for (uint i=1; i<numCerts+1; i++) {
116               if((addr_type==0&&certificates[i].issuer_addr==value)||(addr_type==1&&certificates[i].recepient_addr==value)){
117                 counter++;
118               }
119         }        
120         return counter;
121     }
122     function getCertsByIssuer(address value) public constant returns (uint[]) {
123         uint256[] memory matches=new uint[](getMatchCountAddress(0,value));
124         uint matchCount=0;
125         for (uint i=1; i<numCerts+1; i++) {
126               if(certificates[i].issuer_addr==value){
127                 matches[matchCount++]=i;
128               }
129         }
130         
131         return matches;
132     }
133     function getCertsByRecepient(address value) public constant returns (uint[]) {
134         uint256[] memory matches=new uint[](getMatchCountAddress(1,value));
135         uint matchCount=0;
136         for (uint i=1; i<numCerts+1; i++) {
137               if(certificates[i].recepient_addr==value){
138                 matches[matchCount++]=i;
139               }
140         }
141         
142         return matches;
143     }   
144 
145     function getMatchCountString(uint string_type,string value) public constant returns (uint){
146         uint counter = 0;
147         for (uint i=1; i<numCerts+1; i++) {
148               if(string_type==0){
149                 if(stringsEqual(certificates[i].certHash,value)){
150                     counter++;
151                 }
152               }
153               if(string_type==1){
154                 if(stringsEqual(certificates[i].version,value)){
155                     counter++;
156                 }
157               }
158               if(string_type==2){
159                 if(stringsEqual(certificates[i].content,value)){
160                     counter++;
161                 }
162               }
163         }        
164         return counter;
165     }
166     
167     function getCertsByProof(string value) public constant returns (uint[]) {
168         uint256[] memory matches=new uint[](getMatchCountString(0,value));
169         uint matchCount=0;
170         for (uint i=1; i<numCerts+1; i++) {
171               if(stringsEqual(certificates[i].certHash,value)){
172                 matches[matchCount++]=i;
173               }
174         }
175         
176         return matches;
177     }    
178     function getCertsByVersion(string value) public constant returns (uint[]) {
179         uint256[] memory matches=new uint[](getMatchCountString(1,value));
180         uint matchCount=0;
181         for (uint i=1; i<numCerts+1; i++) {
182               if(stringsEqual(certificates[i].version,value)){
183                 matches[matchCount++]=i;
184               }
185         }
186         
187         return matches;
188     }
189     function getCertsByContent(string value) public constant returns (uint[]) {
190         uint256[] memory matches=new uint[](getMatchCountString(2,value));
191         uint matchCount=0;
192         for (uint i=1; i<numCerts+1; i++) {
193               if(stringsEqual(certificates[i].content,value)){
194                 matches[matchCount++]=i;
195               }
196         }
197         
198         return matches;
199     }
200     
201 /*    function getCertIssuer(string key) constant returns (address,address,string,string) {
202          return (certHashKey[key].issuer_addr,certHashKey[key].recepient_addr,certHashKey[key].version,certHashKey[key].content);
203     }
204 */
205     
206 	function stringsEqual(string storage _a, string memory _b) internal constant returns (bool) {
207 		bytes storage a = bytes(_a);
208 		bytes memory b = bytes(_b);
209 		if (a.length != b.length)
210 			return false;
211 		// @todo unroll this loop
212 		for (uint i = 0; i < a.length; i ++)
213 			if (a[i] != b[i])
214 				return false;
215 		return true;
216 	} 
217 	
218 	function substring(string str, uint startIndex, uint endIndex) internal pure returns (string) {
219         bytes memory strBytes = bytes(str);
220         bytes memory result = new bytes(endIndex-startIndex);
221         for(uint i = startIndex; i < endIndex; i++) {
222             result[i-startIndex] = strBytes[i];
223         }
224         return string(result);
225     }
226     
227 }