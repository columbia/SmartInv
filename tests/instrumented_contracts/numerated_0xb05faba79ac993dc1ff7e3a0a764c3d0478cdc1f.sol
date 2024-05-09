1 pragma solidity ^0.4.17;
2 
3 /*
4 
5  * source       https://github.com/blockbitsio/
6 
7  * @name        General Funding Input Contract
8  * @package     BlockBitsIO
9  * @author      Micky Socaci <micky@nowlive.ro>
10 
11 */
12 
13 
14 
15 contract FundingInputGeneral {
16 
17     bool public initialized = false;
18     uint8 public typeId = 0;
19     address public FundingAssetAddress;
20     address public deployer;
21 
22     event EventInputPaymentReceived(address sender, uint amount, uint8 _type);
23 
24     function FundingInputGeneral() public {
25         deployer = msg.sender;
26     }
27 
28     function setFundingAssetAddress(address _addr) public {
29         require(initialized == false && msg.sender == deployer);
30         FundingAssetAddress = _addr;
31         initialized = true;
32     }
33 
34     function () public payable {
35         buy();
36     }
37 
38     function buy() public payable returns(bool) {
39         if(msg.value > 0) {
40             if(isContract(FundingAssetAddress)) {
41                 if(FundingAssetAddress.call.value(msg.value)(bytes4(bytes32(keccak256("receivePayment(address,uint8)"))), msg.sender, typeId)) {
42                     EventInputPaymentReceived(msg.sender, msg.value, typeId);
43                     return true;
44                 } else {
45                     revert();
46                 }
47             }
48             else {
49                 revert();
50             }
51         } else {
52             revert();
53         }
54     }
55 
56     // this call adds 704 gas, good enough to keep
57     function isContract(address addr) internal view returns (bool) {
58         uint size;
59         assembly { size := extcodesize(addr) }
60         return size > 0;
61     }
62 }
63 
64 /*
65 
66  * source       https://github.com/blockbitsio/
67 
68  * @name        Direct Funding Input Contract
69  * @package     BlockBitsIO
70  * @author      Micky Socaci <micky@nowlive.ro>
71 
72 */
73 
74 
75 
76 
77 
78 contract FundingInputDirect is FundingInputGeneral {
79     function FundingInputDirect() FundingInputGeneral() public {
80         typeId = 1;
81     }
82 }