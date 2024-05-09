1 pragma solidity ^0.4.18;
2 
3 contract Pub {
4     struct Publication {
5         address source;
6         uint256 timestamp;
7         string title;
8         // must be bytes in order to support files
9         bytes body;
10     }
11 
12     mapping (address => uint256[]) public allByAuthor;
13     // anonymous by default
14     mapping (address => string) public authors;
15     Publication[] public all;
16 
17     function Pub() public { }
18 
19     function publishBytes(string _title, bytes _body)
20     external
21     returns (uint256) {
22         uint256 index = all.length;
23         all.push(Publication(
24             msg.sender,
25             now,
26             _title,
27             _body
28         ));
29         allByAuthor[msg.sender].push(index);
30         return index;
31     }
32 
33     function publish(string _title, string _body)
34     external
35     returns (uint256) {
36         uint256 index = all.length;
37         all.push(Publication(
38             msg.sender,
39             now,
40             _title,
41             bytes(_body)
42         ));
43         allByAuthor[msg.sender].push(index);
44         return index;
45     }
46 
47     function sign(string _name)
48     external {
49         authors[msg.sender] = _name;
50     }
51 
52     function publicationCount(address _author)
53     external view
54     returns (uint256) {
55         return allByAuthor[_author].length;
56     }
57 
58     function size()
59     external view
60     returns (uint256) {
61         return all.length;
62     }
63 }