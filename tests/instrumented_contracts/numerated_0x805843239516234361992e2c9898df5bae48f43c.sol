1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /home/zoom/prg/melon-token/contracts/Alchemist.sol
6 // flattened :  Friday, 18-Jan-19 18:31:02 UTC
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 contract Alchemist {
26     address public LEAD;
27     address public GOLD;
28 
29     constructor(address _lead, address _gold) {
30         LEAD = _lead;
31         GOLD = _gold;
32     }
33 
34     function transmute(uint _mass) {
35         require(
36             IERC20(LEAD).transferFrom(msg.sender, address(this), _mass),
37             "LEAD transfer failed"
38         );
39         require(
40             IERC20(GOLD).transfer(msg.sender, _mass),
41             "GOLD transfer failed"
42         );
43     }
44 }