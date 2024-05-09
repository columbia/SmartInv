1 pragma solidity ^0.4.18;
2 contract BlockmaticsGraduationCertificate_030518 {
3     address public owner = msg.sender;
4     string public certificate;
5     bool public certIssued = false;
6 
7     function publishGraduatingClass (string cert) public {
8         assert (msg.sender == owner && !certIssued);
9 
10         certIssued = true;
11         certificate = cert;
12     }
13 }