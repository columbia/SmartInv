1 pragma solidity ^0.5.0;
2 
3 contract Adventure {
4     //Gotta encode and decode the choice strings on the frontend
5 
6     event Situation(uint indexed id, string situationText, bytes32[] choiceTexts);
7 
8 
9     //fromSituation    //choiceNum   //toSituation
10     mapping(uint => mapping(uint => uint)) links;
11     //situation    //number of choices
12     mapping(uint => uint) options;
13 
14     //situation     //person who wrote it
15     mapping(uint => address) authors;
16     //author            //name
17     mapping(address => string) signatures;
18 
19     //Total number of situations
20     uint situationCount;
21     //Un-closed pathways
22     uint pathwayCount;
23 
24 
25 
26     constructor(string memory situationText, bytes32[] memory choiceTexts) public {
27         require(choiceTexts.length > 0,"choices");
28 
29         //Define the option count
30         options[0] = choiceTexts.length;
31 
32         //Set how many remaining open paths there are
33         pathwayCount = choiceTexts.length;
34 
35         //Sign your name
36         authors[0] = msg.sender;
37 
38         emit Situation(0,situationText,choiceTexts);
39     }
40 
41     function add_situation(
42         uint fromSituation,
43         uint fromChoice,
44         string memory situationText,
45         bytes32[] memory choiceTexts) public{
46         //Make sure there is still at least one open pathway
47         require(pathwayCount + choiceTexts.length > 1, "pathwayCount");
48 
49         //Make sure they didn't leave situationText blank
50         require(bytes(situationText).length > 0,"situation");
51 
52         //Make sure this situation.choice actually exists
53         require(fromChoice < options[fromSituation],"options");
54 
55         //Make sure this situation.choice hasn't been defined
56         require(links[fromSituation][fromChoice] == 0,"choice");
57 
58         for(uint i = 0; i < choiceTexts.length; i++){
59             require(choiceTexts[i].length > 0,"choiceLength");
60         }
61 
62         //Increment situationCount, and this is the new situation num
63         situationCount++;
64 
65         //Adjust pathwayCount
66         pathwayCount += choiceTexts.length - 1;
67 
68         //Set pointer from previous situation
69         links[fromSituation][fromChoice] = situationCount;
70 
71         //Set many options there are for this situation
72         options[situationCount] = choiceTexts.length;
73 
74         //Sign your name
75         authors[situationCount] = msg.sender;
76 
77         emit Situation(situationCount,situationText,choiceTexts);
78 
79     }
80 
81     function add_signature(string memory signature) public{
82         signatures[msg.sender] = signature;
83     }
84 
85     function get_signature(uint situation) public view returns(string memory){
86         return signatures[authors[situation]];
87     }
88     function get_author(uint situation) public view returns(address){
89         return authors[situation];
90     }
91 
92     function get_pathwayCount() public view returns(uint){
93         return pathwayCount;
94     }
95 
96     function get_next_situation(uint fromSituation, uint fromChoice) public view returns(uint){
97         return links[fromSituation][fromChoice];
98     }
99 }