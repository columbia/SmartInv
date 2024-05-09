1 pragma solidity ^0.4.2;
2 contract BlockmaticsGraduationCertificate {
3     address public owner = msg.sender;
4     string certificate;
5     bool certIssued = false;
6 
7 
8     function publishGraduatingClass(string cert) {
9         if (msg.sender != owner || certIssued)
10             throw;
11         certIssued = true;
12         certificate = cert;
13     }
14 
15 
16     function showBlockmaticsCertificate() constant returns (string) {
17         return certificate;
18     }
19 }