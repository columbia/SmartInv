1 pragma solidity ^0.4.6;
2 
3 contract Blockmatics_Certificate_12142017 {
4     address public owner = msg.sender;
5     string certificate;
6     bool certIssued = false;
7 
8     function publishGraduatingClass(string cert) public {
9         if (msg.sender != owner || certIssued)
10             revert();
11         certIssued = true;
12         certificate = cert;
13     }
14 
15     function showCertificate() constant public returns (string)  {
16         return certificate;
17     }
18 }