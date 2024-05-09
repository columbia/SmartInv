1 pragma solidity ^0.5.2;
2 
3 interface BurnableERC20 {
4     function balanceOf(address who) external view returns (uint);
5     function burn(uint256 amount) external;
6 }
7 
8 contract Burner {
9     BurnableERC20 public token;
10 
11     constructor(BurnableERC20 _token) public {
12         token = _token;
13     }
14 
15     function burn() external {
16         uint balance = token.balanceOf(address(this));
17         token.burn(balance);
18     }
19 }