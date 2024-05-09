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
66 }
67 
68 contract SmartVows is Ownable, Util {
69 
70     // Names of marriage partners
71     string public partner1_name;
72     string public partner2_name;
73     
74     // Partners' eth address
75     address public partner1_address;
76     address public partner2_address;
77     
78     // Partners Vows
79     string public partner1_vows;
80     string public partner2_vows;
81 
82     // Marriage Date
83     string public marriageDate;
84 
85     //Marital Status
86     string public maritalStatus;
87 
88     // Couple Image Hash
89     bytes public coupleImageIPFShash;
90 
91     // Marriage License Image Hash
92     bytes public marriageLicenceImageIPFShash;
93 
94     // prenup Text
95     string public prenupAgreement;
96     
97     //Last Will and Testaments
98     string public partner1_will;
99     string public partner2_will;
100 
101     // Partners Signed Marriage Contract
102     bool public partner1_signed;
103     bool public partner2_signed;
104     
105     // Partners Voted to update the prenup
106     bool public partner1_voted_update_prenup;
107     bool public partner2_voted_update_prenup;
108     
109     //Partners Voted to update the marriage status
110     bool public partner1_voted_update_marriage_status;
111     bool public partner2_voted_update_marriage_status;
112     
113     // Did both partners signed the contract
114      bool public is_signed;
115     
116     // Officiant
117     string public officiant;
118 
119     // Witnesses
120     string public witnesses;
121 
122     // Location of marriage
123     string public location;
124     
125     Event[] public lifeEvents;
126 
127     struct Event {
128         uint date;
129         string name;
130         string description;
131         string mesg;
132     }
133     
134     uint public eventcount; 
135 
136     // Declare Life event structure
137     event LifeEvent(string name, string description, string mesg);
138 
139     contractEvent[] public contractEvents;
140 
141     struct contractEvent {
142         uint ce_date;
143         string ce_description;
144         string ce_mesg;
145     }
146     
147     uint public contracteventcount; 
148 
149     // Declare Contract event structure
150     event ContractEvent(string ce_description, string ce_mesg);
151 
152     function SmartVows(string _partner1, address _partner1_address, string _partner2, address _partner2_address, string _marriageDate, string _maritalStatus, string _officiant, string _witnesses, string _location, bytes _coupleImageIPFShash, bytes _marriageLicenceImageIPFShash) public{        
153         partner1_name = _partner1;
154         partner2_name = _partner2;  
155         partner1_address=_partner1_address;
156         partner2_address=_partner2_address;
157         marriageDate =_marriageDate;
158         maritalStatus = _maritalStatus;
159         officiant=_officiant;
160         witnesses=_witnesses;
161         location=_location;
162         coupleImageIPFShash=_coupleImageIPFShash;
163         marriageLicenceImageIPFShash=_marriageLicenceImageIPFShash;
164 
165         //Record contract creation in events
166         saveContractEvent("Blockchain marriage smart contract created","Marriage smart contract added to the blockchain");
167         
168     }
169 
170     // Add Life event, either partner can update
171     function addLifeEvent(string name, string description, string mesg) public{
172         require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
173         saveLifeEvent(name, description, mesg);
174     }
175 
176     function saveLifeEvent(string name, string description, string mesg) private {
177         lifeEvents.push(Event(block.timestamp, name, description, mesg));
178         LifeEvent(name, description, mesg);
179         eventcount++;
180     }
181     
182     
183     function saveContractEvent(string description, string mesg) private {
184         contractEvents.push(contractEvent(block.timestamp, description, mesg));
185         ContractEvent(description, mesg);
186         contracteventcount++;
187     }
188 
189     
190     // Update partner 1 vows only once
191     function updatePartner1_vows(string _partner1_vows) public {
192         require((msg.sender == owner || msg.sender == partner1_address) && (bytes(partner1_vows).length == 0));
193         partner1_vows = _partner1_vows;
194     }
195 
196     // Update partner 2 vows only once
197     function updatePartner2_vows(string _partner2_vows) public {
198         require((msg.sender == owner || msg.sender == partner2_address) && (bytes(partner2_vows).length == 0));
199         partner2_vows = _partner2_vows;
200     }
201 
202     // Update Marriage status only if both partners have previously voted to update the prenup
203     function updateMaritalStatus(string _maritalStatus) public {
204         require((msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address) && (partner1_voted_update_marriage_status == true)&&(partner2_voted_update_marriage_status == true));
205         saveContractEvent("Marital status updated", strConcat("Marital status changed from ", maritalStatus , " to ", _maritalStatus));
206         maritalStatus = _maritalStatus;
207         partner1_voted_update_marriage_status = false;
208         partner2_voted_update_marriage_status = false;
209     }
210 
211     // Partners can sign the contract
212     function sign() public {
213         require(msg.sender == partner1_address || msg.sender == partner2_address);
214         if(msg.sender == partner1_address){
215             partner1_signed = true;
216             saveContractEvent("Marriage signed", "Smart Contract signed by Partner 1");
217         }else {
218             partner2_signed = true;
219             saveContractEvent("Marriage signed", "Smart Contract signed by Partner 2");
220         }
221         
222         if(partner1_signed && partner2_signed){// if both signed then make the contract as signed
223             is_signed = true;
224         }
225     }
226     
227     //Function to vote to allow for updating marital status, both partners must vote to allow update
228         function voteToUpdateMaritalStatus() public {
229         if(msg.sender == partner1_address){
230             partner1_voted_update_marriage_status = true;
231             saveContractEvent("Vote - Change Marital Status", "Partner 1 voted to updated Marital Status");
232         }
233         if(msg.sender == partner2_address){
234             partner2_voted_update_marriage_status = true;
235             saveContractEvent("Vote - Change Marital Status", "Partner 2 voted to updated Marital Status");
236         }
237     }
238     
239     //Function to vote to allow for updating prenup, both partners must vote true to allow update
240     function voteToUpdatePrenup() public {
241         if(msg.sender == partner1_address){
242             partner1_voted_update_prenup = true;
243             saveContractEvent("Vote - Update Prenup", "Partner 1 voted to updated Prenuptial Aggreement");
244         }
245         if(msg.sender == partner2_address){
246             partner2_voted_update_prenup = true;
247             saveContractEvent("Vote - Update Prenup", "Partner 2 voted to updated Prenuptial Aggreement");
248         }
249     }
250 
251     // Update coupleImage hash, either partner can update
252     function updateCoupleImageIPFShash(bytes _coupleImageIPFShash) public{
253         require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
254         coupleImageIPFShash = _coupleImageIPFShash;
255     }
256 
257     // Update marriage licence image hash, either partner can update
258     function updateMarriageLicenceImageIPFShash(bytes _marriageLicenceImageIPFShash) public{
259         require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
260         marriageLicenceImageIPFShash = _marriageLicenceImageIPFShash;
261     }
262 
263     // Update prenup text, but only if both partners have previously agreed to update the prenup
264     function updatePrenup(string _prenupAgreement) public{
265         require((msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address) && (partner1_voted_update_prenup == true)&&(partner2_voted_update_prenup == true));
266         prenupAgreement = _prenupAgreement;
267         saveContractEvent("Update - Prenup", "Prenuptial Agreement Updated");
268         partner1_voted_update_prenup = false;
269         partner2_voted_update_prenup = false;
270     }
271      
272     // Update partner 1 will, only partner 1 can update
273     function updatePartner1_will(string _partner1_will) public {
274         require(msg.sender == partner1_address);
275         partner1_will = _partner1_will;
276         saveContractEvent("Update - Will", "Partner 1 Will Updated");
277     }
278   
279     // Update partner 2 will, only partner 2 can update
280     function updatePartner2_will(string _partner2_will) public {
281         require(msg.sender == partner2_address);
282         partner2_will = _partner2_will;
283         saveContractEvent("Update - Will", "Partner 2 Will Updated");
284     }
285     
286 }