1 pragma solidity 0.5.8;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 }
20 
21 /**
22  * @title ERC20 Airdrop dapp smart contract
23  */
24 contract Airdrop {
25   IERC20 private _token = IERC20(0x00FbE7398D9F0D53fBaef6E2F4C6Ab0e7c31f5D7);
26 
27   /**
28    * @dev doAirdrop is the main method for distribution
29    * by default, the contract gonna send 100 tokens per address
30    * @param addresses array of addresses to airdrop
31    */
32   function doAirdrop(address[] calldata addresses) external returns (uint256) {
33     uint256 i = 0;
34 
35     while (i < addresses.length) {
36       _token.transferFrom(msg.sender, addresses[i], 100 * 1 ether);
37       i += 1;
38     }
39 
40     return i;
41   }
42 }