1 // Roman Storm ERC20 Sender
2 pragma solidity ^0.4.18;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender) public view returns (uint256);
19   function transferFrom(address from, address to, uint256 value) public returns (bool);
20   function approve(address spender, uint256 value) public returns (bool);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 
25 contract ERC20Sender {
26     function multisend(address token, address[] _contributors, uint256[] _balances) public {
27         ERC20 erc20token = ERC20(token);
28         uint8 i =0;
29         require(erc20token.allowance(msg.sender, this) > 0);
30         for(i; i<_contributors.length;i++){
31             erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
32         }
33     }
34 }