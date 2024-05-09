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
41 contract Hub is Ownable{
42     address public tokenAddress;
43     address public profileAddress;
44     address public holdingAddress;
45     address public readingAddress;
46     address public approvalAddress;
47 
48     address public profileStorageAddress;
49     address public holdingStorageAddress;
50     address public readingStorageAddress;
51 
52     event ContractsChanged();
53 
54     function setTokenAddress(address newTokenAddress)
55     public onlyOwner {
56         tokenAddress = newTokenAddress;
57         emit ContractsChanged();
58     }
59 
60     function setProfileAddress(address newProfileAddress)
61     public onlyOwner {
62         profileAddress = newProfileAddress;
63         emit ContractsChanged();
64     }
65 
66     function setHoldingAddress(address newHoldingAddress)
67     public onlyOwner {
68         holdingAddress = newHoldingAddress;
69         emit ContractsChanged();
70     }
71 
72     function setReadingAddress(address newReadingAddress)
73     public onlyOwner {
74         readingAddress = newReadingAddress;
75         emit ContractsChanged();
76     }
77 
78     function setApprovalAddress(address newApprovalAddress)
79     public onlyOwner {
80         approvalAddress = newApprovalAddress;
81         emit ContractsChanged();
82     }
83 
84 
85     function setProfileStorageAddress(address newpPofileStorageAddress)
86     public onlyOwner {
87         profileStorageAddress = newpPofileStorageAddress;
88         emit ContractsChanged();
89     }
90 
91     function setHoldingStorageAddress(address newHoldingStorageAddress)
92     public onlyOwner {
93         holdingStorageAddress = newHoldingStorageAddress;
94         emit ContractsChanged();
95     }
96     
97     function setReadingStorageAddress(address newReadingStorageAddress)
98     public onlyOwner {
99         readingStorageAddress = newReadingStorageAddress;
100         emit ContractsChanged();
101     }
102 
103     function isContract(address sender) 
104     public view returns (bool) {
105         if(sender == owner ||
106            sender == tokenAddress ||
107            sender == profileAddress ||
108            sender == holdingAddress ||
109            sender == readingAddress ||
110            sender == approvalAddress ||
111            sender == profileStorageAddress ||
112            sender == holdingStorageAddress ||
113            sender == readingStorageAddress) {
114             return true;
115         }
116         return false;
117     }
118 }