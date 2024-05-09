1 pragma solidity 0.4.24;
2 
3 contract KickvardUniversity {
4 
5     address owner;
6 
7     mapping (address => Certificate[]) certificates;
8 
9     mapping (string => address) member2address;
10 
11     struct Certificate {
12         string memberId;
13         string program;
14         string subjects;
15         string dateStart;
16         string dateEnd;
17     }
18 
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     function setCertificate(address toAddress, string memory memberId, string memory program, string memory subjects, string memory dateStart, string memory dateEnd) public {
24         require(msg.sender == owner);
25         certificates[toAddress].push(Certificate(memberId, program, subjects, dateStart, dateEnd));
26         member2address[memberId] = toAddress;
27     }
28 
29     function getCertificateByAddress(address toAddress) public view returns (string memory) {
30         return renderCertificate(certificates[toAddress]);
31     }
32 
33     function getCertificateByMember(string memory memberId) public view returns (string memory) {
34         return renderCertificate(certificates[member2address[memberId]]);
35     }
36 
37     function renderCertificate(Certificate[] memory memberCertificates) private pure returns (string memory) {
38         if (memberCertificates.length < 1) {
39             return "Certificate not found";
40         }
41         string memory result;
42         string memory delimiter;
43         for (uint i = 0; i < memberCertificates.length; i++) {
44             result = string(abi.encodePacked(
45                 result,
46                 delimiter,
47                 "[ This is to certify that member ID in Sessia: ",
48                 memberCertificates[i].memberId,
49                 " between ",
50                 memberCertificates[i].dateStart,
51                 " and ",
52                 memberCertificates[i].dateEnd,
53                 " successfully finished the educational program ",
54                 memberCertificates[i].program,
55                 " that included the following subjects: ",
56                 memberCertificates[i].subjects,
57                 ". The President of the KICKVARD UNIVERSITY Narek Sirakanyan ]"
58             ));
59             delimiter = ", ";
60         }
61         return result;
62     }
63 }