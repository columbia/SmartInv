1 pragma solidity ^0.4.23;
2 
3 contract Hot {
4     event CreateEvent(uint id, uint bid, string name, string link);
5     
6     event SupportEvent(uint id, uint bid);
7     
8     struct Record {
9         uint index;
10         uint bid;
11         string name;
12         string link;
13     }
14 
15     address public owner;
16     
17     Record[] public records;
18 
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     function withdraw() external onlyOwner {
29         owner.transfer(address(this).balance);
30     }
31 
32     function updateRecordName(uint _id, string _name) external onlyOwner {
33         require(_utfStringLength(_name) <= 20);
34         require(_id < records.length);
35         records[_id].name = _name;
36     }
37 
38     function createRecord (string _name, string _link) external payable {
39         require(msg.value >= 0.001 ether);
40         require(_utfStringLength(_name) <= 20);
41         require(_utfStringLength(_link) <= 50);
42         records.push(Record(records.length,msg.value, _name, _link));
43         emit CreateEvent(records.length-1, msg.value, _name, _link);
44     }
45 
46     function supportRecord(uint _index) external payable {
47         require(msg.value >= 0.001 ether);
48         require(_index < records.length);
49         records[_index].bid += msg.value;
50         emit SupportEvent (_index, records[_index].bid);
51     }
52     
53     function getRecordCount() external view returns (uint) {
54         return records.length;
55     }
56 
57     function _utfStringLength(string str) private pure returns (uint) {
58         uint i = 0;
59         uint l = 0;
60         bytes memory string_rep = bytes(str);
61 
62         while (i<string_rep.length) {
63             if (string_rep[i]>>7==0)
64                 i += 1;
65             else if (string_rep[i]>>5==0x6)
66                 i += 2;
67             else if (string_rep[i]>>4==0xE)
68                 i += 3;
69             else if (string_rep[i]>>3==0x1E)
70                 i += 4;
71             else
72                 //For safety
73                 i += 1;
74 
75             l++;
76         }
77 
78         return l;
79     }
80 }