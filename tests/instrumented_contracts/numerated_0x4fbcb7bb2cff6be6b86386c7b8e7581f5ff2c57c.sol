1 pragma solidity ^0.4.19;
2 
3 interface token {
4     function transferFrom(address from, address receiver, uint amount) public;
5 }
6 
7 contract Owned {
8     address public owner;
9 
10     function Owned() public{
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public{
20         owner = newOwner;
21     }
22 }
23 
24 
25 contract Airdrop is Owned {
26   /**
27    * @dev daAirdrop to address
28    * @param _tokenAddr address the erc20 token address
29    * @param dests address[] addresses to airdrop
30    * @param values uint256[] value(in ether) to airdrop
31    */
32   function doAirdrop(address _tokenAddr, address[] dests, uint256[] values) onlyOwner public returns (uint256) {
33     uint256 i = 0;
34     while (i < dests.length) {
35       token(_tokenAddr).transferFrom(msg.sender, dests[i], values[i] * (10 ** 18));
36       i += 1;
37     }
38     return(i);
39   }
40 }