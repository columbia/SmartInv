1 //SPDX-License-Identifier: Unlicense
2 pragma solidity 0.7.3;
3 
4 import "../vault/IVault.sol";
5 import "./IUniswapRouter.sol";
6 import "@openzeppelin/contracts/access/Ownable.sol";
7 
8 interface IPair {
9     function sync() external;
10 }
11 
12 contract LpUniswapHarvester is Ownable {
13 
14     IUniswapRouter public router;
15     IPair public pair;
16 
17     constructor(IUniswapRouter router_, IPair _pair) {
18         router = router_;
19         pair = _pair;
20     }
21 
22     function harvestVault(IVault vault, uint amount, uint outMin, address[] calldata path, uint deadline) public onlyOwner {
23         uint afterFee = vault.harvest(amount);
24         IERC20Detailed from = vault.underlying();
25         IERC20 to = vault.target();
26         from.approve(address(router), afterFee);
27         uint received = router.swapExactTokensForTokens(afterFee, outMin, path, address(this), deadline)[1];
28         to.approve(address(vault), received);
29         vault.distribute(received);
30         vault.claimOnBehalf(address(pair));
31         pair.sync();
32     }
33 
34     // no tokens should ever be stored on this contract. Any tokens that are sent here by mistake are recoverable by the owner
35     function sweep(address _token) external onlyOwner {
36         IERC20(_token).transfer(owner(), IERC20(_token).balanceOf(address(this)));
37     }
38 
39 }