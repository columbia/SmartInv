1 pragma solidity^0.4.8;
2 contract BlockApps_Certificate_of_Completion {
3     address public owner = msg.sender;
4     string certificate;
5     bool certIssued = false;
6     function publishGraduatingClass(string cert) {
7         if (msg.sender != owner || certIssued)
8             throw;
9         certIssued = true;
10         certificate = cert;
11     }
12     function showCertificate() constant returns (string) {
13         return certificate;
14     }
15 }