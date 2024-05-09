1 pragma solidity ^0.4.23;
2 
3 interface ERC20 {
4     function decimals() external view returns(uint);
5 }
6 
7 contract GetDecimals {
8     function getDecimals(ERC20 token) external view returns (uint){
9         bytes memory data = abi.encodeWithSignature("decimals()");
10         if(!address(token).call(data)) {
11             // call failed
12             return 18;
13         }
14         else {
15             return token.decimals();
16         }
17     }
18     
19     function testRevert() public pure returns(string) {
20         revert("ilan is the king");
21         return "hello world";
22     }
23     
24     function testRevertTx() public returns(string) {
25         return testRevert();
26     }    
27 }