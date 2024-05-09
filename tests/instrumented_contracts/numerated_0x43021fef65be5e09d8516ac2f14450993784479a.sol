1 // Note: 0.4.19 is a pre-release compiler, warning suggests use 0.4.18
2 // pragma solidity ^0.4.18;
3 contract Osler_SmartContracts_Demo_Certificate_of_Attendance {
4   address public owner = msg.sender;
5   string certificate;
6   bool certIssued = false;
7 
8   function publishLawyersInAttendance(string cert) {
9 
10     if (msg.sender !=owner || certIssued){
11       // return remainin gas back to  the caller
12       revert();
13     }
14     certIssued = true;
15     certificate = cert;
16   }
17   function showCertificate() constant returns (string) {
18     return certificate;
19   }
20 }