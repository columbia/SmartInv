1 pragma solidity 0.4.24;
2 
3 interface ERC20Token {
4     function transfer(address _to, uint256 _value) external returns (bool success);
5     function balanceOf(address _owner) external view returns (uint256 balance);
6 }
7 
8 contract Timelock {
9     ERC20Token public token;
10     address public beneficiary;
11     uint256 public releaseTime;
12 
13     event TokenReleased(address beneficiary, uint256 amount);
14 
15     constructor(
16         address _token,
17         address _beneficiary,
18         uint256 _releaseTime
19     ) public {
20         require(_releaseTime > now);
21         require(_beneficiary != 0x0);
22         token = ERC20Token(_token);
23         beneficiary = _beneficiary;
24         releaseTime = _releaseTime;
25     }
26 
27     function release() public returns(bool success) {
28         require(now >= releaseTime);
29         uint256 amount = token.balanceOf(this);
30         require(amount > 0);
31         token.transfer(beneficiary, amount);
32         emit TokenReleased(beneficiary, amount);
33         return true;
34     }
35 }