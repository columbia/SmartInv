1 pragma solidity^0.4.8;
2 
3 contract BlockApps_Certificate_of_Completion_112817 {
4     address public owner = msg.sender;
5     string certificate;
6     bool certIssued = false;
7     
8     function publishGraduatingClass(string cert) {
9         if (msg.sender != owner || certIssued)
10             throw;
11         certIssued = true;
12         certificate = cert;
13     }
14 
15     function showCertificate() constant returns (string) {
16         return certificate;
17     }
18 }