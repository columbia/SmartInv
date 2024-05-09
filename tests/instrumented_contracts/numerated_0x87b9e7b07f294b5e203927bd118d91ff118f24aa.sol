1 pragma solidity ^0.4.19;
2 
3 contract Readings {
4     
5     address private owner;
6     mapping (bytes32 => MeterInfo) private meters;
7     bool private enabled;
8     
9     struct MeterInfo {
10         uint32 meterId;
11         string serialNumber;
12         string meterType;
13         string latestReading;
14     }
15     
16     function Readings() public {
17         owner = msg.sender;
18         enabled = true;
19     }
20  
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25     
26     function transferOwnership(address newOwner) public onlyOwner {
27         owner = newOwner;
28     }
29     
30     function enable() public onlyOwner {
31         enabled = true;
32     }
33     
34     function disable() public onlyOwner {
35         enabled = false;
36     }
37     
38     function addMeter(uint32 meterId, string serialNumber, string meterType) public onlyOwner {
39         require(enabled && meterId > 0);
40         meters[keccak256(serialNumber)] = 
41             MeterInfo({meterId: meterId, serialNumber:serialNumber, meterType:meterType, latestReading:""});
42     }
43     
44     function getMeter(string serialNumber) public view onlyOwner returns(string, uint32, string, string, string, string) {
45         bytes32 serialK = keccak256(serialNumber);
46         require(enabled && meters[serialK].meterId > 0);
47         
48         return ("Id:", meters[serialK].meterId, "Серийный номер:", meters[serialK].serialNumber, "Тип счетчика:", meters[serialK].meterType);
49     }
50     
51     function saveReading(string serialNumber, string reading) public onlyOwner {
52         bytes32 serialK = keccak256(serialNumber);
53         require (enabled && meters[serialK].meterId > 0);
54         meters[serialK].latestReading = reading;
55     }
56     
57     function getLatestReading(string serialNumber) public view returns (string, string, string, string, string, string) {
58         bytes32 serialK = keccak256(serialNumber);
59         require(enabled && meters[serialK].meterId > 0);
60         
61         return (
62             "Тип счетчика:", meters[serialK].meterType,
63             "Серийный номер:", meters[serialK].serialNumber,
64             "Показания:", meters[serialK].latestReading
65         );
66     }
67 }