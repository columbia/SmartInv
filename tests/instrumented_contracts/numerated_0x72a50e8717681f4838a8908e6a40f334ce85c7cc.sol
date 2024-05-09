1 pragma solidity 0.4.25;
2 
3 contract HighwayAcademyCertificates {
4     
5     event NewCertificate(uint256 indexed certificate_number, string info, string course_name, string student_name, string linkedin, string released_project, string mentor_name, string graduation_date_place);
6     
7     struct Certificate {
8         
9         string info;
10         string course_name;
11         string student_name;
12         string student_linkedin;
13         string released_project;
14         string mentor_name;
15         string graduation_date_place;
16     }
17     
18     address public owner;
19     uint256 public count = 0;
20     mapping(uint256 => Certificate) public certificates;
21     
22     modifier onlyOwner {
23         require(msg.sender == owner, "Only owner can use this function");
24         _;
25     }
26     
27     constructor() public {
28         owner = msg.sender;
29     }
30     
31     function addCertificate(uint256 certificate_number, string info, string course_name, string student_name, string student_linkedin, string released_project, string mentor_name, string graduation_date_place) public onlyOwner {
32         count++;
33         require(count == certificate_number, "Wrong certificate number");
34         certificates[count] = Certificate(info, course_name, student_name, student_linkedin, released_project, mentor_name, graduation_date_place);
35         emit NewCertificate(certificate_number, info, course_name, student_name, student_linkedin, released_project, mentor_name, graduation_date_place);
36     }
37 }