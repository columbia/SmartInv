1 pragma solidity ^0.4.11;
2 //"0x64C222d300d5f978D9867fA20C5C59b6B2c849aF","9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08","1","0"
3 contract CertiMe {
4     // Defines a new type with two fields.
5     struct Certificate {
6         string certHash;
7         address issuer_addr;
8         address recepient_addr;
9         string version;
10         string content;
11     }
12 
13     uint numCerts;
14     mapping (uint => Certificate) public certificates;
15     mapping (string => Certificate) certHashKey;
16 
17     function newCertificate(address beneficiary, string certHash, string version, string content ) public returns (uint certID) {
18         certID = ++numCerts; // campaignID is return variable
19         // Creates new struct and saves in storage. We leave out the mapping type.
20         certificates[certID] = Certificate(certHash,msg.sender,beneficiary, version,content);
21         certHashKey[certHash]=certificates[certID];
22     }
23 /*
24     function contribute(uint campaignID) public payable {
25         Campaign storage c = campaigns[campaignID];
26         // Creates a new temporary memory struct, initialised with the given values
27         // and copies it over to storage.
28         // Note that you can also use Funder(msg.sender, msg.value) to initialise.
29         c.funders[c.numFunders++] = CertIssuer({addr: msg.sender, amount: msg.value});
30         c.amount += msg.value;
31     }
32 */
33   /*  
34     function certHashExist(string value) constant returns (uint) {
35         for (uint i=1; i<numCerts+1; i++) {
36               if(stringsEqual(certificates[i].certHash,value)){
37                 return i;
38               }
39         }
40         
41         return 0;
42     }*/
43     function getMatchCountAddress(uint addr_type,address value) public constant returns (uint){
44         uint counter = 0;
45         for (uint i=1; i<numCerts+1; i++) {
46               if((addr_type==0&&certificates[i].issuer_addr==value)||(addr_type==1&&certificates[i].recepient_addr==value)){
47                 counter++;
48               }
49         }        
50         return counter;
51     }
52     function getCertsByIssuer(address value) public constant returns (uint[]) {
53         uint256[] memory matches=new uint[](getMatchCountAddress(0,value));
54         uint matchCount=0;
55         for (uint i=1; i<numCerts+1; i++) {
56               if(certificates[i].issuer_addr==value){
57                 matches[matchCount++]=i;
58               }
59         }
60         
61         return matches;
62     }
63     function getCertsByRecepient(address value) public constant returns (uint[]) {
64         uint256[] memory matches=new uint[](getMatchCountAddress(1,value));
65         uint matchCount=0;
66         for (uint i=1; i<numCerts+1; i++) {
67               if(certificates[i].recepient_addr==value){
68                 matches[matchCount++]=i;
69               }
70         }
71         
72         return matches;
73     }   
74 
75     function getMatchCountString(uint string_type,string value) public constant returns (uint){
76         uint counter = 0;
77         for (uint i=1; i<numCerts+1; i++) {
78               if(string_type==0){
79                 if(stringsEqual(certificates[i].certHash,value)){
80                     counter++;
81                 }
82               }
83               if(string_type==1){
84                 if(stringsEqual(certificates[i].version,value)){
85                     counter++;
86                 }
87               }
88               if(string_type==2){
89                 if(stringsEqual(certificates[i].content,value)){
90                     counter++;
91                 }
92               }
93         }        
94         return counter;
95     }
96     
97     function getCertsByProof(string value) public constant returns (uint[]) {
98         uint256[] memory matches=new uint[](getMatchCountString(0,value));
99         uint matchCount=0;
100         for (uint i=1; i<numCerts+1; i++) {
101               if(stringsEqual(certificates[i].certHash,value)){
102                 matches[matchCount++]=i;
103               }
104         }
105         
106         return matches;
107     }    
108     function getCertsByVersion(string value) public constant returns (uint[]) {
109         uint256[] memory matches=new uint[](getMatchCountString(1,value));
110         uint matchCount=0;
111         for (uint i=1; i<numCerts+1; i++) {
112               if(stringsEqual(certificates[i].version,value)){
113                 matches[matchCount++]=i;
114               }
115         }
116         
117         return matches;
118     }
119     function getCertsByContent(string value) public constant returns (uint[]) {
120         uint256[] memory matches=new uint[](getMatchCountString(2,value));
121         uint matchCount=0;
122         for (uint i=1; i<numCerts+1; i++) {
123               if(stringsEqual(certificates[i].content,value)){
124                 matches[matchCount++]=i;
125               }
126         }
127         
128         return matches;
129     }
130     
131 /*    function getCertIssuer(string key) constant returns (address,address,string,string) {
132          return (certHashKey[key].issuer_addr,certHashKey[key].recepient_addr,certHashKey[key].version,certHashKey[key].content);
133     }
134 */
135     
136 	function stringsEqual(string storage _a, string memory _b) internal constant returns (bool) {
137 		bytes storage a = bytes(_a);
138 		bytes memory b = bytes(_b);
139 		if (a.length != b.length)
140 			return false;
141 		// @todo unroll this loop
142 		for (uint i = 0; i < a.length; i ++)
143 			if (a[i] != b[i])
144 				return false;
145 		return true;
146 	}    
147     
148 }