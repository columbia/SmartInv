1 //SPDX-License-Identifier: Unlicense
2 pragma solidity 0.7.3;
3 import "@openzeppelin/contracts/math/SafeMath.sol";
4 import "../vault/IVault.sol";
5 import "./IUniswapRouter.sol";
6 import "@openzeppelin/contracts/access/Ownable.sol";
7 
8 contract UniswapHarvester is Ownable {
9     using SafeMath for uint256;
10     IUniswapRouter public router;
11     mapping (IVault => uint) public ratePerToken;
12 
13     constructor(IUniswapRouter router_) {
14         router = router_;
15     }
16 
17     function harvestVault(IVault vault, uint amount, uint outMin, address[] calldata path, uint deadline) public onlyOwner {
18         uint afterFee = vault.harvest(amount);
19         uint durationSinceLastHarvest = block.timestamp.sub(vault.lastDistribution());
20         IERC20Detailed from = vault.underlying();
21         ratePerToken[vault] = afterFee.mul(10**(36-from.decimals())).div(vault.totalSupply()).div(durationSinceLastHarvest);
22         IERC20 to = vault.target();
23         from.approve(address(router), afterFee);
24         uint received = router.swapExactTokensForTokens(afterFee, outMin, path, address(this), deadline)[path.length-1];
25         to.approve(address(vault), received);
26         vault.distribute(received);
27     }
28 
29     // no tokens should ever be stored on this contract. Any tokens that are sent here by mistake are recoverable by the owner
30     function sweep(address _token) external onlyOwner {
31         IERC20(_token).transfer(owner(), IERC20(_token).balanceOf(address(this)));
32     }
33 
34 }