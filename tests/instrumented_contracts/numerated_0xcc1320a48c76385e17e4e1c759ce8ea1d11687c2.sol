1 pragma solidity >=0.5.0 <0.6.0;
2 
3 // we need only a single method of Maker's Medianizer contract
4 interface IMakerPriceFeed {
5     // https://github.com/makerdao/medianizer/blob/master/src/medianizer.sol#L87
6     function read() external view returns (bytes32);
7 }
8 
9 interface IERC20 {
10     function transfer(address _to, uint256 _value) external returns (bool success);
11     function balanceOf(address _owner) external view returns (uint256 balance);
12 }
13 
14 /**
15  * Simple swap contract which allows anybody to swap ETH for a specific ERC-20 token (chosen on deploy) for an USD denominated price.
16  * The price in ETH is calculated using the Maker Feeds of the DAI Stablecoin System.
17  */
18 contract EthToErc20Swap {
19     address public owner;
20 
21     // price of 1 erc20 token in milli-USD
22     uint256 public erc20mUSDPrice;
23     IMakerPriceFeed ethPriceFeedContract;
24     IERC20 erc20TokenContract;
25 
26     event Swapped(address account, uint256 ethAmount, uint256 erc20Amount);
27 
28     modifier onlyOwner() {
29         require(msg.sender == owner, "no permission");
30         _;
31     }
32 
33     // "0x729D19f657BD0614b4985Cf1D82531c67569197B" for the feed on Ethereum
34     // "0xe41dd6e41f8f9962c5103d95d95f5d9b82d90fdf" for ATS20 on Ethereum
35     constructor(address ethPriceFeedAddr, address erc20TokenAddr, uint256 initialErc20mUSDPrice) public {
36         owner = msg.sender;
37         ethPriceFeedContract = IMakerPriceFeed(ethPriceFeedAddr);
38         erc20TokenContract = IERC20(erc20TokenAddr);
39         setPriceInmUSD(initialErc20mUSDPrice);
40     }
41 
42     // Sending ETH to the contract triggers the swap. If it fails for some reason, the sender won't lose anything (except the tx fee).
43     function () external payable {
44         // returns the price with 18 digits as bytes32 which can safely be casted to uint256. Will throw if the system has no reliable price.
45         // 15 digits are cut off in order to get mUSD
46         uint256 ethmUSDPrice = uint256(ethPriceFeedContract.read()) / 1E15;
47         uint256 erc20Amount = msg.value * ethmUSDPrice / erc20mUSDPrice;
48 
49         // will throw if the sender (our) balance is insufficient
50         erc20TokenContract.transfer(msg.sender, erc20Amount);
51 
52         emit Swapped(msg.sender, msg.value, erc20Amount);
53     }
54 
55     function setOwner(address newOwner) public onlyOwner {
56         owner = newOwner;
57     }
58 
59     function setPriceInmUSD(uint256 newPrice) public onlyOwner {
60         require(newPrice > 0);
61         erc20mUSDPrice = newPrice;
62     }
63 
64     // withdraw all tokens owned by the contract to the given receiver
65     function withdrawErc20To(address receiver) external onlyOwner  {
66         uint256 amount = erc20TokenContract.balanceOf(address(this));
67         erc20TokenContract.transfer(receiver, amount);
68     }
69 
70     function withdrawEthTo(address payable receiver) external onlyOwner {
71         receiver.transfer(address(this).balance);
72     }
73 }