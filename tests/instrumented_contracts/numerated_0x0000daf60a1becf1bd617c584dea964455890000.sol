1 // File: contracts/StorageContract.sol
2 
3 
4 
5 pragma solidity ^0.8.6;
6 
7 contract StorageContract {
8     address public nativeCryptoReceiver;
9     address[] public owners;
10 
11     constructor(address defaultNativeCryptoReceiver, address firstOwner) {
12         nativeCryptoReceiver = defaultNativeCryptoReceiver;
13         owners.push(firstOwner);
14     }
15 
16     modifier onlyOwner() {
17         bool isOwner = false;
18         for (uint256 i = 0; i < owners.length; i++) {
19             if (msg.sender == owners[i]) {
20                 isOwner = true;
21                 break;
22             }
23         }
24         require(isOwner, "Caller is not an owner");
25         _;
26     }
27 
28     function addOwner(address newOwner) public onlyOwner {
29         owners.push(newOwner);
30     }
31 
32     function getOwners() public view returns (address[] memory) {
33         return owners;
34     }
35 
36     function changeNativeCryptoReceiver(address newNativeCryptoReceiver)
37         public
38         onlyOwner
39     {
40         nativeCryptoReceiver = newNativeCryptoReceiver;
41     }
42 }
43 
44 // File: contracts/Receiver.sol
45 
46 
47 pragma solidity ^0.8.4;
48 
49 
50 contract Receiver {
51     StorageContract storageContract;
52 
53     mapping(address => uint256) private balances;
54 
55     constructor(address storageContractAddress) {
56         storageContract = StorageContract(storageContractAddress);
57     }
58 
59     modifier onlyOwner() {
60         bool isOwner = false;
61         for (uint256 i = 0; i < storageContract.getOwners().length; i++) {
62             if (msg.sender == storageContract.owners(i)) {
63                 isOwner = true;
64                 break;
65             }
66         }
67         require(isOwner, "Caller is not an owner");
68         _;
69     }
70 
71     receive() external payable {}
72 
73     fallback() external payable {}
74 
75     function withdraw(uint256 amount, address recipient) public onlyOwner {
76         require(
77             amount <= address(this).balance,
78             "Not enough balance in the contract"
79         );
80 
81         (bool sent, ) = payable(recipient).call{value: amount}("");
82         require(sent, "Fail");
83     }
84 
85     function bulkWithdraw(uint256[] memory amounts, address[] memory recipients)
86         public
87         onlyOwner
88     {
89         require(
90             amounts.length == recipients.length,
91             "The amounts and recipients length mismatch"
92         );
93 
94         for (uint256 i = 0; i < recipients.length; i++) {
95             uint256 amount = amounts[i];
96             address recipient = recipients[i];
97 
98             require(
99                 amount <= address(this).balance,
100                 "Not enough balance in the contract"
101             );
102 
103             (bool sent, ) = payable(recipient).call{value: amount}("");
104             require(sent, "Fail");
105         }
106     }
107 }