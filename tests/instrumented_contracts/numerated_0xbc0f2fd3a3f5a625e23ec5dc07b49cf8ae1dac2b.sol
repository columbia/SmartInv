1 pragma solidity ^0.4.0;
2 contract BlockmaticsGraduationCertificate_081817 {
3     address public owner = msg.sender;
4     string certificate;
5     bool certIssued = false;
6 
7     function publishGraduatingClass(string cert) {
8         if (msg.sender != owner || certIssued)
9             revert();
10         certIssued = true;
11         certificate = cert;
12     }
13 
14     function showBlockmaticsCertificate() constant returns (string) {
15         return certificate;
16     }
17 }