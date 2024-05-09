1 pragma solidity 0.5.15;
2 
3 // https://github.com/makerdao/sai/blob/master/src/tap.sol
4 contract SaiTapInterface {
5     function sai() public view returns (address);
6     function cash(uint256) public;
7 }
8 
9 contract TokenInterface {
10     function approve(address, uint256) public;
11     function transferFrom(address, address, uint256) public returns (bool);
12     function withdraw(uint256) public;
13     function balanceOf(address) public view returns (uint256);
14 }
15 
16 // User must approve() this contract on Sai prior to calling.
17 contract CageFree {
18 
19     address public tap;
20     address public sai;
21     address public weth;
22 
23     event FreeCash(address sender, uint256 amount);
24 
25     constructor(address _tap, address _weth) public {
26         tap  = _tap;
27         sai  = SaiTapInterface(tap).sai();
28         weth = _weth;
29         TokenInterface(sai).approve(tap, uint256(-1));
30     }
31 
32     function freeCash(uint256 wad) public returns (uint256 cashoutBalance) {
33         TokenInterface(sai).transferFrom(msg.sender, address(this), wad);
34         SaiTapInterface(tap).cash(wad);
35         cashoutBalance = TokenInterface(weth).balanceOf(address(this));
36         require(cashoutBalance > 0, "Zero ETH value");
37         TokenInterface(weth).withdraw(cashoutBalance);
38         msg.sender.transfer(cashoutBalance);
39         emit FreeCash(msg.sender, cashoutBalance);
40     }
41 
42     function() external payable {
43         require(msg.sender == weth, "Only WETH can send ETH");
44     }
45 }