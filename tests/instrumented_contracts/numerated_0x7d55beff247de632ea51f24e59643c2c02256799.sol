1 pragma solidity ^0.4.11;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract StandardCertificate is owned{
21     
22     string public name;
23     string public description;
24     string public language;
25     string public place;
26     uint public hoursCount;
27     
28     mapping (address => uint) certificates;
29     
30     function StandardCertificate (string _name, string _description, string _language, string _place, uint _hoursCount) {
31         name = _name;
32         description = _description;
33         language = _language;
34         place = _place;
35         hoursCount = _hoursCount;
36     }
37     
38     // выдача сертификата
39     function issue (address student) onlyOwner {
40         certificates[student] = now;
41     }
42     
43     function issued (address student)  constant returns (uint) {
44         return certificates[student];
45     }
46     
47     function annul (address student) onlyOwner {
48         certificates[student] = 0;
49     }
50     
51 }
52 
53 contract EWCertificationCenter is owned {
54     
55     string public name;
56     string public description;
57     string public place;
58     
59     mapping (address => bool) public validCertificators;
60     
61     mapping (address => bool) public validCourses;
62     
63     modifier onlyValidCertificator {
64         require(validCertificators[msg.sender]);
65         _;
66     }
67 
68     
69     function EWCertificationCenter (string _name, string _description, string _place) {
70     
71         name = _name;
72         description = _description;
73         place = _place;
74         validCertificators[msg.sender]=true;
75         
76     }
77     
78     // add and delete certificator 
79     function addCertificator(address newCertificator) onlyOwner {
80         validCertificators[newCertificator] = true;
81     }
82     
83     function deleteCertificator(address certificator) onlyOwner {
84         validCertificators[certificator] = false;
85     }
86     
87     // add and delete cource certificate
88     function addCourse(address courseAddess) onlyOwner {
89         StandardCertificate s = StandardCertificate(courseAddess);
90         validCourses[courseAddess] = true;
91     }
92 
93     function deleteCourse(address courseAddess) onlyOwner {
94         validCourses[courseAddess] = false;
95     }
96     
97     function issueSertificate(address courseAddess, address student) onlyValidCertificator {
98         require (student != 0x0);
99         require (validCourses[courseAddess]);
100         
101         StandardCertificate s = StandardCertificate(courseAddess);
102         s.issue(student);
103     }
104     
105     function checkSertificate(address courseAddess, address student) constant returns (uint) {
106         require (student != 0x0);
107         require (validCourses[courseAddess]);
108         
109         StandardCertificate s = StandardCertificate(courseAddess);
110         return s.issued(student);        
111     }
112     
113     function annulCertificate(address courseAddess, address student) onlyValidCertificator {
114         require (student != 0x0);
115         require (validCourses[courseAddess]);
116 
117         StandardCertificate s = StandardCertificate(courseAddess);
118         s.annul(student);
119     }
120     
121     function changeOwnership(address certificateAddress, address newOwner) onlyOwner {
122         StandardCertificate s = StandardCertificate(certificateAddress);
123         s.transferOwnership(newOwner);
124     }
125     
126 }