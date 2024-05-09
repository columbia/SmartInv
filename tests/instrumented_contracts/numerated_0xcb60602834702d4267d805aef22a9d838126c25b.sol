1 pragma solidity ^0.4.23;
2 
3 contract PresageFlower {
4     
5     // Unerasable diary
6     struct Diary {
7         address author;
8         string body;
9         uint256 time;
10     }
11     
12     Diary[] diaries;
13     mapping(address => bool) authors;
14     
15     constructor() public {
16         authors[msg.sender] = true;
17     }
18     
19     modifier onlyAuthor() {
20         require(authors[msg.sender] == true);
21         _;
22     }
23     
24     function addAuthor(address _newAuthor) public onlyAuthor {
25         authors[_newAuthor] = true;
26     }
27     
28     function removeAuthor(address _otherAuthor) public onlyAuthor {
29         require(msg.sender != _otherAuthor);
30         authors[_otherAuthor] = false;
31     }
32     
33     function addDiary(string body) public onlyAuthor {
34         diaries.push(Diary(msg.sender, body, now));
35     }
36     
37     function getDiary(uint256 idx) public view onlyAuthor returns(address, string, uint256) {
38         if(diaries.length > idx) {
39             return (diaries[idx].author, diaries[idx].body, diaries[idx].time);
40         } else {
41             return (0x0, "No Entry.", 0);
42         }
43     }
44     
45     function getRecentDiary() public view onlyAuthor returns(address, string, uint256) {
46         return getDiary(diaries.length - 1);
47     }
48     
49     function getDiaryLength() public view onlyAuthor returns(uint256) {
50         return diaries.length;
51     }
52 }