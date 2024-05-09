1 // Note: 0.4.19 is a pre-release compiler, warning suggests use 0.4.18
2 // pragma solidity ^0.4.18;
3 contract Osler_SmartContracts_Demo_Certificate_of_Attendance {
4   address public owner = msg.sender;
5   string certificate;
6 
7   function publishLawyersInAttendance(string cert) {
8 
9     if (msg.sender !=owner){
10       // return remainin gas back to  the caller
11       revert();
12     }
13     certificate = cert;
14   }
15   function showCertificate() constant returns (string) {
16     return certificate;
17   }
18 }