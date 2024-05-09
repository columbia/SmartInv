1 pragma solidity ^0.4.0;
2 contract BlockmaticsGraduationCertificate {
3     address public owner = msg.sender;
4     string certificate;
5 
6 
7     function publishGraduatingClass(string cert) {
8         if (msg.sender != owner)
9             throw;
10         certificate = cert;
11     }
12 
13 
14     function showBlockmaticsCertificate() constant returns (string) {
15         return certificate;
16     }
17 }