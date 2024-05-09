1 pragma solidity 0.4.8;
2 
3 contract DdosMitigation {
4     struct Report {
5         address reporter;
6         bytes32 ipAddress;
7     }
8 
9     address public owner;
10     Report[] public reports;
11 
12     function DdosMitigation() {
13         owner = msg.sender;
14     }
15 
16     function report(bytes32 ipAddress) {
17         reports.push(Report({
18             reporter: msg.sender,
19             ipAddress: ipAddress
20         }));
21     }
22 }