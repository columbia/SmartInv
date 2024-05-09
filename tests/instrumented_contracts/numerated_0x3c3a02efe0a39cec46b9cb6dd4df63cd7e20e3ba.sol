1 pragma solidity ^0.4.24;
2 
3 
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   uint256 public totalSupply;
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 
19 
20 
21 
22 /**
23  * @title ERC20 interface
24  * @dev see https://github.com/ethereum/EIPs/issues/20
25  */
26 contract ERC20 is ERC20Basic {
27   function allowance(address owner, address spender) public view returns (uint256);
28   function transferFrom(address from, address to, uint256 value) public returns (bool);
29   function approve(address spender, uint256 value) public returns (bool);
30   event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 
34 
35 
36 contract MultiTransfer {
37 
38     function MultiTransfer() public {
39 
40     }
41 
42     function transfer(address token, address owner,address[] to, uint[] value) public {
43         require(to.length == value.length);
44         require(token != address(0));
45 
46         ERC20 t = ERC20(token);
47         for (uint i = 0; i < to.length; i++) {
48             t.transferFrom(owner, to[i], value[i]);
49         }
50     }
51 }