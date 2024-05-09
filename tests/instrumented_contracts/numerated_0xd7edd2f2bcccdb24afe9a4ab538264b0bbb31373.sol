1 pragma solidity ^0.4.11;
2 
3 contract Owned {
4     address public owner;
5 
6     modifier onlyOwner() { if (isOwner(msg.sender)) _; }
7     modifier ifOwner(address sender) { if (isOwner(sender)) _; }
8 
9     function Owned() {
10         owner = msg.sender;
11     }
12 
13     function isOwner(address addr) public returns(bool) {
14         return addr == owner;
15     }
16 }
17 
18 contract DataDump is Owned {
19 	event DataDumped(address indexed _recipient, string indexed _topic, bytes32 _dataHash);
20 
21 	function DataDump() {}
22 	function postData(address recipient, string topic, bytes32 data) onlyOwner() {
23 		DataDumped(recipient, topic, data);
24 	}
25 }