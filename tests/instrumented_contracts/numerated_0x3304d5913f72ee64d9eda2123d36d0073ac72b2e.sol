1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public ;
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 
29 contract MultiTransfer {
30 
31     function MultiTransfer() public {
32 
33     }
34 
35     function transfer(address token, address[] to, uint[] value) public {
36         require(to.length == value.length);
37         require(token != address(0));
38 
39         ERC20 t = ERC20(token);
40         for (uint i = 0; i < to.length; i++) {
41             t.transferFrom(msg.sender, to[i], value[i]);
42         }
43     }
44 }