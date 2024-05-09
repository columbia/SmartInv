1 pragma solidity ^0.5.3;
2 
3 // counter.market smart contracts:
4 //  1) Proxy - delegatecalls into current exchange code, maintains storage of exchange state
5 //  2) Registry (this one) - stores information on the latest exchange contract version and user approvals
6 //  3) Treasury - takes custody of funds, moves them between token accounts, authorizing exchange code via
7 
8 // Counter contracts are deployed at predefined addresses which can be hardcoded.
9 contract FixedAddress {
10     address constant ProxyAddress = 0x1234567896326230a28ee368825D11fE6571Be4a;
11     address constant TreasuryAddress = 0x12345678979f29eBc99E00bdc5693ddEa564cA80;
12     address constant RegistryAddress = 0x12345678982cB986Dd291B50239295E3Cb10Cdf6;
13 }
14 
15 // External contracts access Registry via one of these methods
16 interface RegistryInterface {
17     function getOwner() external view returns (address);
18     function getExchangeContract() external view returns (address);
19     function contractApproved(address traderAddr) external view returns (bool);
20     function contractApprovedBoth(address traderAddr1, address traderAddr2) external view returns (bool);
21     function acceptNextExchangeContract() external;
22 }
23 
24 // Standard ownership semantics
25 contract Ownable {
26     address public owner;
27     address private nextOwner;
28 
29     event OwnershipTransfer(address newOwner, address previousOwner);
30 
31     modifier onlyOwner {
32         require (msg.sender == owner, "onlyOwner methods called by non-owner.");
33         _;
34     }
35 
36     function approveNextOwner(address _nextOwner) external onlyOwner {
37         require (_nextOwner != owner, "Cannot approve current owner.");
38         nextOwner = _nextOwner;
39     }
40 
41     function acceptNextOwner() external {
42         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
43         emit OwnershipTransfer(nextOwner, owner);
44         owner = nextOwner;
45     }
46 }
47 
48 contract Registry is FixedAddress, RegistryInterface, Ownable {
49 
50     // *** Variables
51 
52     // Current exchange contract and its version.
53     // Version 0 means uninitialized Registry, first ever Exchange contract is
54     // version 1 and the number increments from there.
55     address public exchangeContract;
56     uint private exchangeContractVersion;
57 
58     // Contract upgrades are preapproved by the Registry owner, and the new version
59     // should accept the ownership transfer from its address. This means that Exchange
60     // contracts should use deterministic addresses which can be determined beforehand.
61     address private nextExchangeContract;
62 
63     // Previously used Exchange contracts cannot be used again - this prevents some
64     // scenarios where Counter operator may use old digital signatures of traders
65     // maliciously.
66     mapping (address => bool) private prevExchangeContracts;
67 
68     // The very first Exchange contract (version 1) is unconditionally trusted, because
69     // users can study it before depositing funds. Exchange contract upgrades, however, may
70     // invalidate many assumptions, so we require that each trader explicitly approves the upgrade.
71     // These approvals are checked by the (immutable) Treasury contract before moving funds, so
72     // that it's impossible to compromise user funds by substituting Exchange contract with malicious
73     // code.
74     mapping (address => uint) private traderApprovals;
75 
76     // *** Events
77 
78     event UpgradeExchangeContract(address exchangeContract, uint exchangeContractVersion);
79     event TraderApproveContract(address traderAddr, uint exchangeContractVersion);
80 
81     // *** Constructor
82 
83     constructor () public {
84         owner = msg.sender;
85         // exchangeContract, exchangeContractVersion are zero upon initialization
86     }
87 
88     // *** Public getters
89 
90     function getOwner() external view returns (address) {
91         return owner;
92     }
93 
94     function getExchangeContract() external view returns (address) {
95         return exchangeContract;
96     }
97 
98     // *** Exchange contract upgrade (approve/accept pattern)
99 
100     function approveNextExchangeContract(address _nextExchangeContract) external onlyOwner {
101         require (_nextExchangeContract != exchangeContract, "Cannot approve current exchange contract.");
102         require (!prevExchangeContracts[_nextExchangeContract], "Cannot approve previously used contract.");
103         nextExchangeContract = _nextExchangeContract;
104     }
105 
106     function acceptNextExchangeContract() external {
107         require (msg.sender == nextExchangeContract, "Can only accept preapproved exchange contract.");
108         exchangeContract = nextExchangeContract;
109         prevExchangeContracts[nextExchangeContract] = true;
110         exchangeContractVersion++;
111 
112         emit UpgradeExchangeContract(exchangeContract, exchangeContractVersion);
113     }
114 
115     // *** Trader approval for the new contract version.
116 
117     function traderApproveCurrentExchangeContract(uint _exchangeContractVersion) external {
118         require (_exchangeContractVersion > 1, "First version doesn't need approval.");
119         require (_exchangeContractVersion == exchangeContractVersion, "Can only approve the latest version.");
120         traderApprovals[msg.sender] = _exchangeContractVersion;
121 
122         emit TraderApproveContract(msg.sender, _exchangeContractVersion);
123     }
124 
125     // *** Methods to check approval of the contract upgrade (invoked by the Treasury)
126 
127     function contractApproved(address traderAddr) external view returns (bool) {
128         if (exchangeContractVersion > 1) {
129             return exchangeContractVersion == traderApprovals[traderAddr];
130 
131         } else {
132             return exchangeContractVersion == 1;
133         }
134     }
135 
136     function contractApprovedBoth(address traderAddr1, address traderAddr2) external view returns (bool) {
137         // This method is an optimization - it checks approval of two traders simultaneously to
138         // save gas on an extra cross-contract method call.
139         if (exchangeContractVersion > 1) {
140             return
141               exchangeContractVersion == traderApprovals[traderAddr1] &&
142               exchangeContractVersion == traderApprovals[traderAddr2];
143 
144         } else {
145             return exchangeContractVersion == 1;
146         }
147     }
148 
149 }