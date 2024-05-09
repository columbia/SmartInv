1 pragma solidity >=0.4.22 <0.7.0;
2 
3 
4 contract Spinosa {
5     struct MP {
6         string id;
7         string data;
8     }
9 
10     struct PF {
11         string id;
12         string data;
13     }
14 
15     address private owner;
16     mapping(string => bool) private exist_MP;
17     mapping(string => MP) private list_MP;
18     mapping(string => bool) private exist_PF;
19     mapping(string => PF) private list_PF;
20 
21     // event for EVM logging
22     event MPSet(string, string);
23     event PFSet(string, string);
24 
25     // modifier to check if caller is owner
26     modifier isOwner() {
27         require(msg.sender == owner, "Caller is not owner");
28         _;
29     }
30 
31     constructor() public {
32         owner = msg.sender;
33     }
34 
35     function setMP(string calldata _id, string calldata _data)
36         external
37         isOwner
38     {
39         require(bytes(_id).length > 0, "ID is empty");
40         require(exist_MP[_id] == false, "MP already exist");
41         require(bytes(_data).length > 0, "DATA is empty");
42 
43         MP memory tmp;
44         tmp.id = _id;
45         tmp.data = _data;
46 
47         list_MP[_id] = tmp;
48         exist_MP[_id] = true;
49 
50         emit MPSet("New MP was added with ID: ", _id);
51     }
52 
53     function setPF(string calldata _id, string calldata _data)
54         external
55         isOwner
56     {
57         require(bytes(_id).length > 0, "ID is empty");
58         require(exist_PF[_id] == false, "PF already exist");
59         require(bytes(_data).length > 0, "DATA is empty");
60 
61         PF memory tmp;
62         tmp.id = _id;
63         tmp.data = _data;
64 
65         list_PF[_id] = tmp;
66         exist_PF[_id] = true;
67 
68         emit MPSet("New PF was added with ID: ", _id);
69     }
70 
71     function getMP(string memory _id) public view returns (string memory) {
72         require(bytes(_id).length > 0, "ID is empty");
73         require(exist_MP[_id] == true, "MP does not exist");
74 
75         return list_MP[_id].data;
76     }
77 
78     function getPF(string memory _id) public view returns (string memory) {
79         require(bytes(_id).length > 0, "ID is empty");
80         require(exist_PF[_id] == true, "PF does not exist");
81 
82         return list_PF[_id].data;
83     }
84 }