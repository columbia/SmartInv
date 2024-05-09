1 pragma solidity ^0.4.5;
2 contract BlockmaticsGraduationCertificate_022218 {
3     address public owner = msg.sender;
4     string public certificate;
5     bool public certIssued = false;
6 
7     function publishGraduatingClass(string cert) public {
8         require (msg.sender == owner && !certIssued);
9         certIssued = true;
10         certificate = cert;
11     }
12 }