1 pragma solidity 0.4.24;
2 
3 // Basic ICO for ERC20 tokens
4 
5 interface iERC20 {
6     function totalSupply() external constant returns (uint256 supply);
7     function balanceOf(address owner) external constant returns (uint256 balance);    
8     function transfer(address to, uint tokens) external returns (bool success);
9 }
10 
11 contract MeerkatICO {
12     iERC20 token;
13     address owner;
14     address tokenCo;
15     uint rateMe;
16     
17     modifier ownerOnly() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22    constructor(address mainToken) public {
23         token = iERC20(mainToken);
24         tokenCo = mainToken;
25         owner = msg.sender;
26         rateMe = 0;
27     }
28 
29     function withdrawETH() public ownerOnly {
30         owner.transfer(address(this).balance);
31     }
32 
33     function setRate(uint _rateMe) public ownerOnly {
34         rateMe = _rateMe;
35     }
36     
37     function CurrentRate() public constant returns (uint rate) {
38         return rateMe;
39     }
40     
41     function TokenLinked() public constant returns (address _token, uint _amountLeft) {
42         return (tokenCo, (token.balanceOf(address(this)) / 10**18)) ;
43     }
44     
45     function transferAnyERC20Token(address tokenAddress, uint tokens) public ownerOnly returns (bool success) {
46         return iERC20(tokenAddress).transfer(owner, tokens);
47     }
48 
49     function () public payable {
50         require( (msg.value >= 100000000000000000) && (rateMe != 0) );
51         
52         uint value = msg.value * rateMe;
53 
54         require(value/msg.value == rateMe);
55         
56         token.transfer(msg.sender, value);
57         
58     }
59 }