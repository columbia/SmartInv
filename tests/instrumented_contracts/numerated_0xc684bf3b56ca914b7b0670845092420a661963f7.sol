1 pragma solidity ^0.4.18;
2 
3 
4 contract Ownable {
5     address public owner;
6 
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10 
11     /**
12      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13      * account.
14      */
15     function Ownable() public {
16         owner = msg.sender;
17     }
18 
19     /**
20      * @dev Throws if called by any account other than the owner.
21      */
22     modifier onlyOwner() {
23         require(msg.sender == owner);
24         _;
25     }
26 
27     /**
28      * @dev Allows the current owner to transfer control of the contract to a newOwner.
29      * @param newOwner The address to transfer ownership to.
30      */
31     function transferOwnership(address newOwner) public onlyOwner {
32         require(newOwner != address(0));
33         emit OwnershipTransferred(owner, newOwner);
34         owner = newOwner;
35     }
36 
37 }
38 
39 contract XRRtoken {
40     function balanceOf(address _owner) public view returns (uint256 balance);
41 
42     function transfer(address _to, uint256 _value) public returns (bool);
43 }
44 
45 contract XRRfrozen is Ownable {
46 
47     XRRtoken token;
48 
49     struct Vault {
50         address wallet;
51         uint256 amount;
52         uint unfrozen;
53     }
54 
55     Vault[] public vaults;
56 
57 
58     function XRRfrozen() public {
59         // Bounty May 16, 2018 12:00:00 AM
60         vaults.push(Vault(0x3398BdC73b3e245187aAe7b231e453c0089AA04e, 1500000 ether, 1526428800));
61         // Airdrop May 16, 2018 12:00:00 AM
62         vaults.push(Vault(0x0B65Ce79206468fdA9E12eC77f2CEE87Ff63F81C, 1500000 ether, 1526428800));
63         // Stakeholders February 9, 2019 12:00:00 AM
64         vaults.push(Vault(0x3398BdC73b3e245187aAe7b231e453c0089AA04e, 15000000 ether, 1549670400));
65     }
66 
67     function setToken(XRRtoken _token) public onlyOwner {
68         token = _token;
69     }
70 
71     function unfrozen() public {
72         require(notEmpty());
73         uint8 i = 0;
74         while (i++ < vaults.length) {
75             if (now > vaults[i].unfrozen && vaults[i].amount > 0) {
76                 token.transfer(vaults[i].wallet, vaults[i].amount);
77                 vaults[i].amount = 0;
78             }
79         }
80     }
81 
82     function notEmpty() public view returns (bool){
83         uint8 i = 0;
84         while (i++ < vaults.length) {
85             if (now > vaults[i].unfrozen && vaults[i].amount > 0) {
86                 return true;
87             }
88         }
89         return false;
90     }
91 
92     function tokenTosale() public view returns (uint256){
93         return token.balanceOf(this);
94     }
95 }