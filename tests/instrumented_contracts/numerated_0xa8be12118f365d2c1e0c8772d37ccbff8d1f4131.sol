1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 //"1","Francisco","18028348","SC001","Smart Contract","Asistencia"
5 
6 contract lccCertificados {
7 
8     address constant public myAddressLcc = 0xdc32EFF737bd1B94a7814eC269Ef4808C887850D;
9     event LogsCourse(string name);
10     
11     struct Course {
12       string nameStudent;
13       string idStudent;
14       string idCourse;
15       string nameCourse;
16       string note;
17       uint timestamp;
18     }
19     
20     mapping (uint => Course) Courses;
21     
22     
23     // SET EXPEDIENTE
24     function setCourse(uint id, string memory nameStudent, string memory idStudent, string memory idCourse, string memory nameCourse, string memory note) public payable returns  (uint success)  {
25 
26        //uint id = now;
27        
28        if(msg.sender == myAddressLcc) {
29 
30          Courses[id].nameStudent = nameStudent;
31          Courses[id].idStudent = idStudent;        
32          Courses[id].idCourse = idCourse;
33          Courses[id].nameCourse = nameCourse;
34          Courses[id].note = note;
35          Courses[id].timestamp = now;
36          return id;
37         
38        }
39    
40     }
41     
42 
43     // GET
44     function getCourse(uint id) public view returns  (Course memory success)  {
45         return Courses[id];
46         
47     }
48     function getSender() public view returns  (address success)  {
49         return msg.sender;
50         
51     }
52     function getNameCourse(uint id) public view returns  (string memory success)  {
53         return Courses[id].nameCourse;
54     }
55 
56 
57     
58 }