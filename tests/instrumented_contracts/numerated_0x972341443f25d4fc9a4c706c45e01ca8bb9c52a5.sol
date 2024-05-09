1 pragma solidity ^0.4.25;
2 
3 interface ReportEmitter {
4     event Report(address indexed sender,
5                  uint256 indexed tag,
6                  uint256 indexed target,
7                  uint256 value);
8 }
9 
10 contract Crier is ReportEmitter {
11     function report(uint256 o, bytes32 t) public payable {emit Report(msg.sender,uint256(t),o,msg.value);}
12     function report(uint256 o, bytes t) public payable {report(o,keccak256(abi.encodePacked(t)));}
13     function report(uint256 o, string t) public payable {report(o,keccak256(abi.encodePacked(t)));}
14     
15     function report(address o, bytes32 t) public payable {report(uint256(o),t);}
16     function report(address o, bytes t) public payable {report(o,keccak256(abi.encodePacked(t)));}
17     function report(address o, string t) public payable {report(o,keccak256(abi.encodePacked(t)));}
18 
19     function report(bytes o, bytes32 t) public payable {report(uint256(keccak256(abi.encodePacked(o))),t);}
20     function report(bytes o, bytes t) public payable {report(uint256(keccak256(abi.encodePacked(o))),t);}
21     function report(bytes o, string t) public payable {report(uint256(keccak256(abi.encodePacked(o))),t);}
22 }