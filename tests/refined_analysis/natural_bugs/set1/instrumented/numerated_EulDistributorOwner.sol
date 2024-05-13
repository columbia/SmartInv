1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 interface IEulDistributor {
6     function updateRoot(bytes32 newRoot) external;
7 }
8 
9 contract EulDistributorOwner {
10     string public constant name = "EUL Distributor Owner";
11 
12     address public immutable eulDistributor;
13     address public owner;
14     address public updater;
15 
16     constructor(address eulDistributor_, address owner_, address updater_) {
17         eulDistributor = eulDistributor_;
18         owner = owner_;
19         updater = updater_;
20     }
21 
22     // Owner-only functions
23 
24     modifier onlyOwner {
25         require(msg.sender == owner, "unauthorized");
26         _;
27     }
28 
29     function changeOwner(address newOwner) external onlyOwner {
30         owner = newOwner;
31     }
32 
33     function changeUpdater(address newUpdater) external onlyOwner {
34         updater = newUpdater;
35     }
36 
37     function execute(address destination, uint value, bytes calldata payload) external onlyOwner {
38         (bool success,) = destination.call{value: value}(payload);
39         require(success, "execute failure");
40     }
41 
42     // Updater-only functions
43 
44     function updateRoot(bytes32 newRoot) external {
45         require(msg.sender == updater, "unauthorized");
46         IEulDistributor(eulDistributor).updateRoot(newRoot);
47     }
48 }
