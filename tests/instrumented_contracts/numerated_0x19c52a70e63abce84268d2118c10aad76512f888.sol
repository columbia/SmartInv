1 pragma solidity ^0.4.18;
2 
3 interface ERC20 {
4     function totalSupply() external view returns (uint supply);
5     function balanceOf(address _owner) external view returns (uint balance);
6     function transfer(address _to, uint _value) external; // Some ERC20 doesn't have return
7     function transferFrom(address _from, address _to, uint _value) external; // Some ERC20 doesn't have return
8     function approve(address _spender, uint _value) external; // Some ERC20 doesn't have return
9     function allowance(address _owner, address _spender) external view returns (uint remaining);
10     function decimals() external view returns(uint digits);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 interface BancorContract {
15     /**
16         @dev converts the token to any other token in the bancor network by following a predefined conversion path
17         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
18 
19         @param _path        conversion path, see conversion path format in the BancorQuickConverter contract
20         @param _amount      amount to convert from (in the initial source token)
21         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
22 
23         @return tokens issued in return
24     */
25     function quickConvert(address[] _path, uint256 _amount, uint256 _minReturn)
26         external
27         payable
28         returns (uint256);
29 }
30 
31 
32 contract TestBancorTrade {
33     event Trade(uint256 srcAmount, uint256 destAmount);
34     
35     // BancorContract public bancorTradingContract = BancorContract(0x8FFF721412503C85CFfef6982F2b39339481Bca9);
36     
37     function trade(ERC20 src, BancorContract bancorTradingContract, address[] _path, uint256 _amount, uint256 _minReturn) {
38         // ERC20 src = ERC20(0xB8c77482e45F1F44dE1745F52C74426C631bDD52);
39         src.approve(bancorTradingContract, _amount);
40         
41         uint256 destAmount = bancorTradingContract.quickConvert(_path, _amount, _minReturn);
42         
43         Trade(_amount, destAmount);
44     }
45     
46     function getBack() {
47         msg.sender.transfer(this.balance);
48     }
49     
50     function getBackBNB() {
51         ERC20 src = ERC20(0xB8c77482e45F1F44dE1745F52C74426C631bDD52);
52         src.transfer(msg.sender, src.balanceOf(this));
53     }
54     
55     function getBackToken(ERC20 token) {
56         token.transfer(msg.sender, token.balanceOf(this));
57     }
58     
59     // Receive ETH in case of trade Token -> ETH, will get ETH back from trading proxy
60     function () public payable {
61 
62     }
63 }