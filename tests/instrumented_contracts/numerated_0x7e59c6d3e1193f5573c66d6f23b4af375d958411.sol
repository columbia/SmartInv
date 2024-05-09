1 pragma solidity ^0.4.23;
2 
3 /**
4 * @title Ownable
5 * @dev The Ownable contract has an owner address, and provides basic authorization control
6 * functions, this simplifies the implementation of "user permissions".
7 */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15     * account.
16     */
17     constructor () public {
18         owner = msg.sender;
19     }
20 
21     /**
22     * @dev Throws if called by any account other than the owner.
23     */
24     modifier onlyOwner() {
25         require(msg.sender == owner, "Only contract owner can call this function");
26         _;
27     }
28 
29     /**
30     * @dev Allows the current owner to transfer control of the contract to a newOwner.
31     * @param newOwner The address to transfer ownership to.
32     */
33     function transferOwnership(address newOwner) public onlyOwner {
34         require(newOwner != address(0));
35         emit OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37     }
38 
39 }
40 
41 contract Certificates is Ownable{
42     
43     struct Certificate {
44         string WorkshopName;
45         string Date;
46         string Location;
47     }
48 
49     event CertificateCreated(bytes32 certId, string WorkshopName, string Date, string Location);
50     
51     mapping (bytes32 => Certificate) public issuedCertificates;
52 
53     function getCert(string Name, string Surname, string DateOfIssue) public view returns (string WorkshopName, string Date, string Location) {
54         return (issuedCertificates[keccak256(abi.encodePacked(Name, Surname, DateOfIssue))].WorkshopName,
55                 issuedCertificates[keccak256(abi.encodePacked(Name, Surname, DateOfIssue))].Date,
56                 issuedCertificates[keccak256(abi.encodePacked(Name, Surname, DateOfIssue))].Location);
57     }
58 
59     function getCertById(bytes32 certId) public view returns (string WorkshopName, string Date, string Location) {
60         return (issuedCertificates[certId].WorkshopName,
61                 issuedCertificates[certId].Date,
62                 issuedCertificates[certId].Location);
63     }
64     
65     function setCertById(bytes32 certId, string WorkshopName, string Date, string Location) public onlyOwner{
66         issuedCertificates[certId] = Certificate(WorkshopName, Date, Location);
67         emit CertificateCreated(certId, WorkshopName, Date, Location);
68     }
69 }