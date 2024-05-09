1 pragma solidity ^0.4.24;
2 /**
3  * Marriage
4  * Copyright (c) 2018 MING-CHIEN LEE
5  */
6 contract owned {
7     address public owner;
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address newOwner) onlyOwner public {
19         owner = newOwner;
20     }
21 }
22 contract Marriage is owned {
23     // Marriage data variables
24     bytes32 public partner1;
25     bytes32 public partner2;
26     uint256 public marriageDate;
27     bytes32 public marriageStatus;
28     bytes public imageHash;
29     bytes public marriageProofDoc;
30     
31     constructor() public {
32         createMarriage();
33     }
34 
35     // Create initial marriage contract
36     function createMarriage() onlyOwner public {
37         partner1 = "Edison Lee";
38         partner2 = "Chino Kafuu";
39         marriageDate = 1527169003;
40         setStatus("Married");
41         bytes32 name = "Marriage Contract Creation";
42         
43         majorEventFunc(marriageDate, name, "We got married!");
44     }
45     
46     // Set the marriage status if it changes
47     function setStatus(bytes32 status) onlyOwner public {
48         marriageStatus = status;
49         majorEventFunc(block.timestamp, "Changed Status", status);
50     }
51     
52     // Set the IPFS hash of the image of the couple
53     function setImage(bytes IPFSImageHash) onlyOwner public {
54         imageHash = IPFSImageHash;
55         majorEventFunc(block.timestamp, "Entered Marriage Image", "Image is in IPFS");
56     }
57     
58     // Upload documentation for proof of marrage like a marriage certificate
59     function marriageProof(bytes IPFSProofHash) onlyOwner public {
60         marriageProofDoc = IPFSProofHash;
61         majorEventFunc(block.timestamp, "Entered Marriage Proof", "Marriage proof in IPFS");
62     }
63 
64     // Log major life events
65     function majorEventFunc(uint256 eventTimeStamp, bytes32 name, bytes32 description) public {
66         emit MajorEvent(block.timestamp, eventTimeStamp, name, description);
67     }
68 
69     // Declare event structure
70     event MajorEvent(uint256 logTimeStamp, uint256 eventTimeStamp, bytes32 indexed name, bytes32 indexed description);
71     
72     // This function gets executed if a transaction with invalid data is sent to
73     // the contract or just ether without data. We revert the send so that no-one
74     // accidentally loses money when using the contract.
75     function () public {
76         revert();
77     }
78 }