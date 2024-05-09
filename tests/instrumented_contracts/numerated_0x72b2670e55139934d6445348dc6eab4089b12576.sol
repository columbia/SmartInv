1 pragma solidity ^0.4.24;
2 
3 interface HourglassInterface {
4     function buy(address _referredBy) payable external returns(uint256);
5     function balanceOf(address _playerAddress) external view returns(uint256);
6     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
7     function sell(uint256 _amountOfTokens) external;
8     function withdraw() external;
9 }
10 
11 contract TakeoutController {
12     address owner;
13     address takeoutWallet;
14     HourglassInterface private Hourglass;
15     
16     constructor() public {
17         Hourglass = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
18         takeoutWallet = 0xf783A81F046448c38f3c863885D9e99D10209779;
19         owner = msg.sender;
20     }
21     
22     modifier onlyOwner {
23         require(owner == msg.sender, "Access Denied!");
24         _;
25     }
26     
27     function buyTokens() external payable{
28         Hourglass.buy.value(msg.value)(takeoutWallet);
29     }
30     
31     function () external payable {
32     }
33     
34     function transferTokens() external onlyOwner {
35         uint256 _amountOfTokens = getBalance();
36         Hourglass.transfer(takeoutWallet, _amountOfTokens);
37     }
38     
39     function getBalance() public view returns (uint256 amountOfTokens) {
40         amountOfTokens = Hourglass.balanceOf(address(this));
41     }
42     
43     function withdrawDividends() external onlyOwner {
44         Hourglass.withdraw();
45     }
46     
47     function sellTokens() external onlyOwner {
48         uint256 _amountOfTokens = getBalance();
49         Hourglass.sell(_amountOfTokens);
50     }
51     
52     function extractFund(uint256 _amount) external onlyOwner {
53         if (_amount == 0) {
54             takeoutWallet.transfer(address(this).balance);
55         } else {
56             require(_amount <= address(this).balance);
57             takeoutWallet.transfer(_amount);
58         }
59     }
60     
61     function changeTakeoutWallet(address _newTakeoutWallet) external onlyOwner {
62         takeoutWallet = _newTakeoutWallet;
63     }
64 }