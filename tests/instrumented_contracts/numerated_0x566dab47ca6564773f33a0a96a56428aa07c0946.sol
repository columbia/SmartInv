1 pragma solidity^0.4.8;
2 
3 contract BlockAppsCertificateManager {
4     address owner;
5     Certificate [] certificates;
6     
7     function BlockAppsCertificateManager() {
8         owner = msg.sender;
9     }
10     function issueCertificate(string _classDate, string _participants, string _location) returns(bool){
11         if (msg.sender != owner){
12             return false;
13         }
14         certificates.push(new Certificate(_classDate, _participants, _location)); 
15         return true;
16     }
17 }
18 
19 contract Certificate {
20     string classDate; 
21     string participants;
22     string location;
23     address certificateManager;
24     
25     function Certificate(string _classDate, string _participants, string _location) {
26         classDate = _classDate;
27         participants = _participants;
28         certificateManager = msg.sender;
29         location = _location;
30     }
31 }