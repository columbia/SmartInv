1 pragma solidity ^0.4.18;
2 
3 contract DPOS {
4     uint256 public limit;
5     address public owner;
6     struct VoteItem {
7         string content;
8         uint agreeNum;
9         uint disagreeNum;
10     }
11     struct VoteRecord {
12         address voter;
13         bool choice;
14     }
15 
16     mapping (uint => VoteItem) public voteItems;
17     mapping (uint => VoteRecord[]) public voteRecords;
18 
19     event Create(uint indexed _id, string indexed _content);
20     event Vote(uint indexed _id, address indexed _voter, bool indexed _choice);
21 
22     function DPOS() public {
23         owner = msg.sender;
24     }
25 
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     function setLimit(uint256 _limit) public onlyOwner returns (bool) {
32         limit = _limit;
33         return true;
34     }
35 
36     function lengthOfRecord(uint256 _id) public view returns (uint length) {
37         return voteRecords[_id].length;
38     }
39 
40     function create(uint _id, string _content) public onlyOwner returns (bool) {
41         VoteItem memory item = VoteItem({content: _content, agreeNum: 0, disagreeNum: 0});
42         voteItems[_id] = item;
43         Create(_id, _content);
44         return true;
45     }
46 
47     function vote(uint _id, address _voter, bool _choice) public onlyOwner returns (bool) {
48         if (_choice) {
49             voteItems[_id].agreeNum += 1;
50         } else {
51             voteItems[_id].disagreeNum += 1;
52         }
53         VoteRecord memory record = VoteRecord({voter: _voter, choice: _choice});
54         voteRecords[_id].push(record);
55         Vote(_id, _voter, _choice);
56         return true;
57     }
58 }