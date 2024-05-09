1 pragma solidity 0.4.24;
2 
3 contract SimpleVoting {
4 
5     string public constant description = "abc";
6 
7     struct Cert {
8         string memberId;
9         string program;
10         string subjects;
11         string dateStart;
12         string dateEnd;
13     }
14 
15     mapping  (string => Cert) certs;
16 
17     address owner;
18 
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     /// metadata
24     function setCertificate(string memory memberId, string memory program, string memory subjects, string memory dateStart, string memory dateEnd) public {
25         require(msg.sender == owner);
26         certs[memberId] = Cert(memberId, program, subjects, dateStart, dateEnd);
27     }
28 
29     /// Give certificate to memberId $(memberId).
30     function getCertificate(string memory memberId) public view returns (string memory) {
31         Cert memory cert = certs[memberId];
32         return string(abi.encodePacked(
33             "This is to certify that member ID in Sessia: ",
34             cert.memberId,
35             " between ",
36             cert.dateStart,
37             " and ",
38             cert.dateEnd,
39             " successfully finished the educational program ",
40             cert.program,
41             " that included the following subjects: ",
42             cert.subjects,
43             ". The President of the KICKVARD UNIVERSITY Narek Sirakanyan"
44         ));
45     }
46 }