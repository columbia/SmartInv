1 pragma solidity ^0.4.15;
2 
3 contract PaperTrading {
4 
5 rebalance[] public record;
6 
7 struct rebalance{
8         address creator;
9         bytes32 shasum;
10         uint256 time;
11         uint256 blocknum;
12         string remarks;
13 }
14 
15 function addRecord(bytes32 shasum,string remarks) public returns (uint256 recordID) {
16         recordID = record.length++;
17         rebalance storage Reb = record[recordID];
18         Reb.creator=msg.sender;
19         Reb.shasum=shasum;
20         Reb.time = block.timestamp;
21         Reb.blocknum = block.number;
22         Reb.remarks = remarks;
23         LogRebalance(Reb.creator,Reb.shasum,Reb.remarks,Reb.time,Reb.blocknum,recordID);
24 }
25 
26 event LogRebalance(address Creator, bytes32 sha256sum, string Remarks, uint256 time, uint256 blocknum, uint256 indexed RecordID );
27 
28 }