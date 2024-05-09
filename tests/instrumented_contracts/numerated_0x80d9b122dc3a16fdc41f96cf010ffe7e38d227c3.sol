1 pragma solidity ^0.4.16;
2 
3 contract Pub {
4     struct Publication {
5         address source;
6         string title;
7         string body;
8     }
9 
10     mapping (address => uint256[]) public allByAuthor;
11     // anonymous by default
12     mapping (address => string) public authors;
13     Publication[] public all;
14 
15     function Pub() public { }
16 
17     function publish(string _title, string _body)
18     external
19     returns (uint256) {
20         uint256 index = all.length;
21         all.push(Publication(
22             msg.sender,
23             _title,
24             _body
25         ));
26         allByAuthor[msg.sender].push(index);
27         return index;
28     }
29 
30     function sign(string _name)
31     external {
32         authors[msg.sender] = _name;
33     }
34 
35     function publicationCount(address _author)
36     external view
37     returns (uint256) {
38         return allByAuthor[_author].length;
39     }
40 
41     function size()
42     external view
43     returns (uint256) {
44         return all.length;
45     }
46 }