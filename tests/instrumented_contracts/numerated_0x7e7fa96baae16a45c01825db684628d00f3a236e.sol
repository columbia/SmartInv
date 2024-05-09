1 pragma solidity ^0.5.4;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 contract SplitPayment is Ownable {
74     
75     address payable[] public beneficiaries;
76     
77     event AddedBeneficiary(address beneficiary);
78     
79     event RemovedBeneficiary(uint256 indexOfBeneficiary, address beneficiary);
80     
81     event LogPayout(address beneficiary, uint256 amount);
82     
83     function addBeneficiary(address payable _beneficiary) public onlyOwner {
84         beneficiaries.push(_beneficiary);
85         emit AddedBeneficiary(_beneficiary);
86     }
87     
88     function bulkAddBeneficiaries(address payable[] memory _beneficiaries) public onlyOwner {
89         uint256 len = beneficiaries.length;
90         
91         for (uint256 b = 0; b < len; b++) {
92             addBeneficiary(_beneficiaries[b]);
93         }
94     }
95     
96     function removeBeneficiary(uint256 indexOfBeneficiary) public onlyOwner {
97         emit RemovedBeneficiary(indexOfBeneficiary, beneficiaries[indexOfBeneficiary]);
98 
99         // unless the to be deleted index is not last -> move last one here
100         if (indexOfBeneficiary < beneficiaries.length - 1) {
101             beneficiaries[indexOfBeneficiary] = beneficiaries[beneficiaries.length - 1];
102         }
103 
104         // if to be deleted index is in range -> decrease length by one
105         if(indexOfBeneficiary < beneficiaries.length) {
106             beneficiaries.length--;
107         }
108     }
109     
110     function() external payable {
111         uint256 len = beneficiaries.length;
112         uint256 amount = msg.value / len;
113         
114         for (uint256 b = 0; b < len; b++) {
115             beneficiaries[b].transfer(amount);
116             emit LogPayout(beneficiaries[b], amount);
117         }
118     }
119     
120     function payOnce(address payable[] memory _beneficiaries) public payable {
121         uint256 len = _beneficiaries.length;
122         uint256 amount = msg.value / len;
123         
124         for (uint256 b = 0; b < len; b++) {
125             _beneficiaries[b].transfer(amount);
126             emit LogPayout(_beneficiaries[b], amount);
127         }
128     }
129     
130     function getNumberOfBeneficiaries() public view returns (uint256 length) {
131         return beneficiaries.length;
132     }
133 }