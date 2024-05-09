1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     if (msg.sender != owner) {
12       revert();
13     }
14     _;
15   }
16 }
17 
18 contract RBInformationStore is Ownable {
19     address public profitContainerAddress;
20     address public companyWalletAddress;
21     uint public etherRatioForOwner;
22     address public multiSigAddress;
23     address public accountAddressForSponsee;
24     bool public isPayableEnabledForAll = true;
25 
26     modifier onlyMultiSig() {
27         require(multiSigAddress == msg.sender);
28         _;
29     }
30 
31     function RBInformationStore
32     (
33         address _profitContainerAddress,
34         address _companyWalletAddress,
35         uint _etherRatioForOwner,
36         address _multiSigAddress,
37         address _accountAddressForSponsee
38     ) {
39         profitContainerAddress = _profitContainerAddress;
40         companyWalletAddress = _companyWalletAddress;
41         etherRatioForOwner = _etherRatioForOwner;
42         multiSigAddress = _multiSigAddress;
43         accountAddressForSponsee = _accountAddressForSponsee;
44     }
45 
46     function changeProfitContainerAddress(address _address) onlyMultiSig {
47         profitContainerAddress = _address;
48     }
49 
50     function changeCompanyWalletAddress(address _address) onlyMultiSig {
51         companyWalletAddress = _address;
52     }
53 
54     function changeEtherRatioForOwner(uint _value) onlyMultiSig {
55         etherRatioForOwner = _value;
56     }
57 
58     function changeMultiSigAddress(address _address) onlyMultiSig {
59         multiSigAddress = _address;
60     }
61 
62     function changeOwner(address _address) onlyMultiSig {
63         owner = _address;
64     }
65 
66     function changeAccountAddressForSponsee(address _address) onlyMultiSig {
67         accountAddressForSponsee = _address;
68     }
69 
70     function changeIsPayableEnabledForAll() onlyMultiSig {
71         isPayableEnabledForAll = !isPayableEnabledForAll;
72     }
73 }
74 
75 contract Rate {
76     uint public ETH_USD_rate;
77     RBInformationStore public rbInformationStore;
78 
79     modifier onlyOwner() {
80         require(msg.sender == rbInformationStore.owner());
81         _;
82     }
83 
84     function Rate(uint _rate, address _address) {
85         ETH_USD_rate = _rate;
86         rbInformationStore = RBInformationStore(_address);
87     }
88 
89     function setRate(uint _rate) onlyOwner {
90         ETH_USD_rate = _rate;
91     }
92 }