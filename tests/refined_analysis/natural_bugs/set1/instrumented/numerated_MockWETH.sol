1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 
7 import "./MockToken.sol";
8 
9 /**
10  * @author Publius
11  * @title Mock WETH
12 **/
13 contract MockWETH is MockToken {
14 
15     constructor() MockToken("Wrapped Ether", "WETH") { }
16 
17     event  Deposit(address indexed dst, uint wad);
18     event  Withdrawal(address indexed src, uint wad);
19 
20     receive() external payable {
21         deposit();
22     }
23     function deposit() public payable {
24         _mint(msg.sender, msg.value);
25         emit Deposit(msg.sender, msg.value);
26     }
27     function withdraw(uint wad) public {
28         require(balanceOf(msg.sender) >= wad);
29         _transfer(msg.sender, address(this), wad);
30         (bool success,) = msg.sender.call{ value: wad }("");
31         require(success, "MockWETH: Transfer failed.");
32         emit Withdrawal(msg.sender, wad);
33     }
34 
35 }
