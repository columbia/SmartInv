1 pragma solidity ^0.4.17;
2 
3 contract WayneAndMichelle {
4     string constant public congratulationFromNoel = "祝 Wayne 跟 Michelle 幸福健康快樂";
5     
6     function WayneAndMichelle () payable public {}
7     
8     function OpenRedEnvelope (string input) public {
9         require(keccak256(input) == 0x5fd066216edd28dc49b0ee93e344e346a36b44b00bdf44713b98b566758f9758);
10         msg.sender.transfer(this.balance);
11     }
12     
13     function hashTest(string input) pure returns (bytes32) {
14         return keccak256(input);
15     }
16 }