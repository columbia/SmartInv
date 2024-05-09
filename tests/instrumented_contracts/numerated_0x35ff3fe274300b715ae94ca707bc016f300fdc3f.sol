1 pragma solidity ^0.4.19;
2 
3 contract Ranking {
4     event CreateEvent(uint id, uint bid, string name, string link);
5     event SupportEvent(uint id, uint bid);
6     
7     struct Record {
8         uint bid;
9         string name;
10         string link;
11     }
12 
13     address public owner;
14     Record[] public records;
15 
16     function Ranking() public {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner() {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     function withdraw() external onlyOwner {
26         owner.transfer(address(this).balance);
27     }
28 
29     function updateRecordName(uint _id, string _name) external onlyOwner {
30         require(_utfStringLength(_name) <= 20);
31         require(_id < records.length);
32         records[_id].name = _name;
33     }
34 
35     function createRecord (string _name, string _link) external payable {
36         require(msg.value >= 0.001 ether);
37         require(_utfStringLength(_name) <= 20);
38         require(_utfStringLength(_link) <= 50);
39         uint id = records.push(Record(msg.value, _name, _link)) - 1;
40         CreateEvent(id, msg.value, _name, _link);
41     }
42 
43     function supportRecord(uint _id) external payable {
44         require(msg.value >= 0.001 ether);
45         require(_id < records.length);
46         records[_id].bid += msg.value;
47         SupportEvent (_id, records[_id].bid);
48     }
49 
50     function listRecords () external view returns (uint[2][]) {
51         uint[2][] memory result = new uint[2][](records.length);
52         for (uint i = 0; i < records.length; i++) {
53             result[i][0] = i;
54             result[i][1] = records[i].bid;
55         }
56         return result;
57     }
58     
59     function getRecordCount() external view returns (uint) {
60         return records.length;
61     }
62 
63     function _utfStringLength(string str) private pure returns (uint) {
64         uint i = 0;
65         uint l = 0;
66         bytes memory string_rep = bytes(str);
67 
68         while (i<string_rep.length) {
69             if (string_rep[i]>>7==0)
70                 i += 1;
71             else if (string_rep[i]>>5==0x6)
72                 i += 2;
73             else if (string_rep[i]>>4==0xE)
74                 i += 3;
75             else if (string_rep[i]>>3==0x1E)
76                 i += 4;
77             else
78                 //For safety
79                 i += 1;
80 
81             l++;
82         }
83 
84         return l;
85     }
86 }