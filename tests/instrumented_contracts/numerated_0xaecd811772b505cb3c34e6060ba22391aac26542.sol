1 pragma solidity ^0.4.17;
2 
3 //SmartVows Marriage Smart Contract for Partner 1 and Partner 2
4 
5 contract Ownable {
6     address public owner;
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12     function Ownable() public {
13         owner = msg.sender;
14     }
15     /**
16      * @dev Throws if called by any account other than the owner.
17      */
18     modifier onlyOwner() {
19         require(msg.sender == owner);
20         _;
21     }
22     /**
23      * @dev Allows the current owner to transfer control of the contract to a newOwner.
24      * @param newOwner The address to transfer ownership to.
25      */
26     function transferOwnership(address newOwner) onlyOwner public {
27         require(newOwner != address(0));
28         OwnershipTransferred(owner, newOwner);
29         owner = newOwner;
30     }
31 }
32 
33 contract Util{
34 
35     function Util() public{}
36 
37     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
38         bytes memory _ba = bytes(_a);
39         bytes memory _bb = bytes(_b);
40         bytes memory _bc = bytes(_c);
41         bytes memory _bd = bytes(_d);
42         bytes memory _be = bytes(_e);
43         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
44         bytes memory babcde = bytes(abcde);
45         uint k = 0;
46         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
47         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
48         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
49         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
50         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
51         return string(babcde);
52     }
53 
54     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
55         return strConcat(_a, _b, _c, _d, "");
56     }
57 
58     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
59         return strConcat(_a, _b, _c, "", "");
60     }
61 
62     function strConcat(string _a, string _b) internal pure returns (string) {
63         return strConcat(_a, _b, "", "", "");
64     }
65 
66     function toString(address x) internal pure returns (string) {
67         bytes memory b = new bytes(20);
68         for (uint i = 0; i < 20; i++)
69         b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
70         return string(b);
71     }
72 }
73 
74 contract SmartVows is Ownable, Util {
75 
76     // Names of marriage partners
77     string public partner1_name;
78     string public partner2_name;
79     
80     // Partners' eth address
81     address public partner1_address;
82     address public partner2_address;
83     
84     // Partners Vows
85     string public partner1_vows;
86     string public partner2_vows;
87 
88     // Marriage Date
89     string public marriageDate;
90 
91     //Marital Status
92     string public maritalStatus;
93 
94     // Couple Image Hash
95     string public coupleImageIPFShash;
96 
97     // Marriage License Image Hash
98     string public marriageLicenceImageIPFShash;
99 
100     // prenup Text
101     string public prenupAgreement;
102     
103     //Last Will and Testaments
104     string public partner1_will;
105     string public partner2_will;
106 
107     // Partners Signed Marriage Contract
108     bool public partner1_signed;
109     bool public partner2_signed;
110     
111     // Partners Voted to update the prenup
112     bool public partner1_voted_update_prenup;
113     bool public partner2_voted_update_prenup;
114     
115     //Partners Voted to update the marriage status
116     bool public partner1_voted_update_marriage_status;
117     bool public partner2_voted_update_marriage_status;
118     
119     // Did both partners signed the contract
120      bool public is_signed;
121     
122     // Officiant
123     string public officiant;
124 
125     // Witnesses
126     string public witnesses;
127 
128     // Location of marriage
129     string public location;
130     
131     Event[] public lifeEvents;
132 
133     struct Event {
134         uint date;
135         string name;
136         string description;
137         string mesg;
138     }
139     
140     uint public eventcount; 
141 
142     // Declare Life event structure
143     event LifeEvent(string name, string description, string mesg);
144 
145     contractEvent[] public contractEvents;
146 
147     struct contractEvent {
148         uint ce_date;
149         string ce_description;
150         string ce_mesg;
151     }
152     
153     uint public contracteventcount; 
154 
155     // Declare Contract event structure
156     event ContractEvent(string ce_description, string ce_mesg);
157 
158     function SmartVows(string _partner1, address _partner1_address, string _partner2, address _partner2_address, string _marriageDate, string _maritalStatus, string _officiant, string _witnesses, string _location, string _coupleImageIPFShash, string _marriageLicenceImageIPFShash) public{        
159         partner1_name = _partner1;
160         partner2_name = _partner2;  
161         partner1_address=_partner1_address;
162         partner2_address=_partner2_address;
163         marriageDate =_marriageDate;
164         maritalStatus = _maritalStatus;
165         officiant=_officiant;
166         witnesses=_witnesses;
167         location=_location;
168         coupleImageIPFShash = _coupleImageIPFShash;
169         marriageLicenceImageIPFShash = _marriageLicenceImageIPFShash;
170 
171         //Record contract creation in events
172         saveContractEvent("Blockchain marriage smart contract created","Marriage smart contract added to the blockchain");
173         
174     }
175 
176     // Add Life event, either partner can update
177     function addLifeEvent(string name, string description, string mesg) public{
178         require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
179         saveLifeEvent(name, description, mesg);
180     }
181 
182     function saveLifeEvent(string name, string description, string mesg) private {
183         lifeEvents.push(Event(block.timestamp, name, description, mesg));
184         LifeEvent(name, description, mesg);
185         eventcount++;
186     }
187     
188     
189     function saveContractEvent(string description, string mesg) private {
190         contractEvents.push(contractEvent(block.timestamp, description, mesg));
191         ContractEvent(description, mesg);
192         contracteventcount++;
193     }
194 
195     
196     // Update partner 1 vows only once
197     function updatePartner1_vows(string _partner1_vows) public {
198         require((msg.sender == owner || msg.sender == partner1_address) && (bytes(partner1_vows).length == 0));
199         partner1_vows = _partner1_vows;
200     }
201 
202     // Update partner 2 vows only once
203     function updatePartner2_vows(string _partner2_vows) public {
204         require((msg.sender == owner || msg.sender == partner2_address) && (bytes(partner2_vows).length == 0));
205         partner2_vows = _partner2_vows;
206     }
207 
208     // Update Marriage status only if both partners have previously voted to update the prenup
209     function updateMaritalStatus(string _maritalStatus) public {
210         require((msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address) && (partner1_voted_update_marriage_status == true)&&(partner2_voted_update_marriage_status == true));
211         saveContractEvent("Marital status updated", strConcat("Marital status changed from ", maritalStatus , " to ", _maritalStatus));
212         maritalStatus = _maritalStatus;
213         partner1_voted_update_marriage_status = false;
214         partner2_voted_update_marriage_status = false;
215     }
216 
217     // Partners can sign the contract
218     function sign() public {
219         require(msg.sender == partner1_address || msg.sender == partner2_address);
220         if(msg.sender == partner1_address){
221             partner1_signed = true;
222             saveContractEvent("Marriage signed", "Smart Contract signed by Partner 1");
223         }else {
224             partner2_signed = true;
225             saveContractEvent("Marriage signed", "Smart Contract signed by Partner 2");
226         }
227         
228         if(partner1_signed && partner2_signed){// if both signed then make the contract as signed
229             is_signed = true;
230         }
231     }
232     
233     //Function to vote to allow for updating marital status, both partners must vote to allow update
234         function voteToUpdateMaritalStatus() public {
235         if(msg.sender == partner1_address){
236             partner1_voted_update_marriage_status = true;
237             saveContractEvent("Vote - Change Marital Status", "Partner 1 voted to updated Marital Status");
238         }
239         if(msg.sender == partner2_address){
240             partner2_voted_update_marriage_status = true;
241             saveContractEvent("Vote - Change Marital Status", "Partner 2 voted to updated Marital Status");
242         }
243     }
244     
245     //Function to vote to allow for updating prenup, both partners must vote true to allow update
246     function voteToUpdatePrenup() public {
247         if(msg.sender == partner1_address){
248             partner1_voted_update_prenup = true;
249             saveContractEvent("Vote - Update Prenup", "Partner 1 voted to updated Prenuptial Aggreement");
250         }
251         if(msg.sender == partner2_address){
252             partner2_voted_update_prenup = true;
253             saveContractEvent("Vote - Update Prenup", "Partner 2 voted to updated Prenuptial Aggreement");
254         }
255     }
256 
257     // Update coupleImage hash, either partner can update
258     function updateCoupleImageIPFShash(string _coupleImageIPFShash) public{
259         require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
260         coupleImageIPFShash = _coupleImageIPFShash;
261     }
262 
263     // Update marriage licence image hash, either partner can update
264     function updateMarriageLicenceImageIPFShash(string _marriageLicenceImageIPFShash) public{
265         require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
266         marriageLicenceImageIPFShash = _marriageLicenceImageIPFShash;
267     }
268 
269     // Update prenup text, but only if both partners have previously agreed to update the prenup
270     function updatePrenup(string _prenupAgreement) public{
271         require((msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address) && (partner1_voted_update_prenup == true)&&(partner2_voted_update_prenup == true));
272         prenupAgreement = _prenupAgreement;
273         saveContractEvent("Update - Prenup", "Prenuptial Agreement Updated");
274         partner1_voted_update_prenup = false;
275         partner2_voted_update_prenup = false;
276     }
277      
278     // Update partner 1 will, only partner 1 can update
279     function updatePartner1_will(string _partner1_will) public {
280         require(msg.sender == partner1_address);
281         partner1_will = _partner1_will;
282         saveContractEvent("Update - Will", "Partner 1 Will Updated");
283     }
284   
285     // Update partner 2 will, only partner 2 can update
286     function updatePartner2_will(string _partner2_will) public {
287         require(msg.sender == partner2_address);
288         partner2_will = _partner2_will;
289         saveContractEvent("Update - Will", "Partner 2 Will Updated");
290     }
291     
292 }