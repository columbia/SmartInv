1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../fei/IIncentive.sol";
5 import "../refs/CoreRef.sol";
6 
7 contract MockIncentive is IIncentive, CoreRef {
8     constructor(address core) CoreRef(core) {}
9 
10     uint256 private constant INCENTIVE = 100;
11     bool public isMint = true;
12     bool public incentivizeRecipient;
13 
14     function incentivize(
15         address sender,
16         address recipient,
17         address,
18         uint256
19     ) public virtual override {
20         if (isMint) {
21             address target = incentivizeRecipient ? recipient : sender;
22             fei().mint(target, INCENTIVE);
23         } else {
24             fei().burnFrom(recipient, INCENTIVE);
25         }
26     }
27 
28     function setIsMint(bool _isMint) public {
29         isMint = _isMint;
30     }
31 
32     function setIncentivizeRecipient(bool _incentivizeRecipient) public {
33         incentivizeRecipient = _incentivizeRecipient;
34     }
35 }
