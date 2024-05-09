1 pragma solidity ^0.4.10;
2 
3 contract MarriageCertificates {
4 
5     struct CertificateStruct {
6         uint256 value;
7         string names;
8         string partnerDetails;
9         uint blockNumber;
10         string message;
11         bool exists;
12     }
13 
14     mapping (address => CertificateStruct) public CertificateStructs;
15 
16     address private owner;
17     uint256 private constant minimumCost = 1 finney;
18     uint256 private constant maxHoldings = 200 finney;
19     address[] private keys;
20 
21 
22     function MarriageCertificates() public {
23         owner = msg.sender;
24     }
25 
26     function getCertificateKeys() public constant returns (address[]) {
27         return keys;
28     }
29 
30     function createCertificate (
31         string names,
32         string partnerDetails,
33         string message
34     ) payable public {
35         require(msg.value >= 1 finney);
36         require(!CertificateStructs[msg.sender].exists);
37 
38         address key = msg.sender;
39 
40         CertificateStructs[key].value = msg.value;
41         CertificateStructs[key].names = names;
42         CertificateStructs[key].partnerDetails = partnerDetails;
43         CertificateStructs[key].message = message;
44         CertificateStructs[key].blockNumber = block.number;
45         CertificateStructs[key].exists = true;
46 
47         address contractAddress = this;
48         if (contractAddress.balance > maxHoldings) {
49             owner.transfer(maxHoldings);
50         }
51 
52     }
53 
54     function getCertificate (address key) public constant returns (uint256, string, string, string, uint) {
55         if (CertificateStructs[key].exists) {
56             return (
57                 CertificateStructs[key].value,
58                 CertificateStructs[key].names,
59                 CertificateStructs[key].partnerDetails,
60                 CertificateStructs[key].message,
61                 CertificateStructs[key].blockNumber
62             );
63         }
64     }
65 
66     function() public payable {}
67 }