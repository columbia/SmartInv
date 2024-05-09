1 pragma solidity ^0.4.2;
2 
3 contract Geocache {
4   struct VisitorLog {
5     address visitor;
6     string name;
7     string dateTime; // Time in UTC, Format: "1993-10-13T03:24:00"
8     string location; // "[lat,lon]"
9     string note;
10     string imageUrl;
11   }
12 
13   VisitorLog[] public visitorLogs;
14 
15   // because no optional params, interface has to send all fields. if field is empty, send empty string.
16   function createLog(string _name, string _dateTime, string _location, string _note, string _imageUrl) public {
17     visitorLogs.push(VisitorLog(msg.sender, _name, _dateTime, _location, _note, _imageUrl));
18   }
19 
20   // because can't return an array, need to return length of array and then up to front end to get entries at each index of visitorLogs array
21   function getNumberOfLogEntries() public view returns (uint) {
22     return visitorLogs.length;
23   }
24 
25   // set magic 0th position - the first log entry
26   function setFirstLogEntry() public {
27     require(msg.sender == 0x8d3e809Fbd258083a5Ba004a527159Da535c8abA);
28     visitorLogs.push(VisitorLog(0x0, "Mythical Geocache Creator", "2018-08-31T12:00:00", "[50.0902822,14.426874199999997]", "I was here first", " " ));
29   }
30 }