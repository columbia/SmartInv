1 pragma solidity 0.4.24;
2 
3 
4 interface iERC20 {
5     function totalSupply() external constant returns (uint256 supply);
6     function balanceOf(address owner) external constant returns (uint256 balance);    
7     function transfer(address to, uint tokens) external returns (bool success);
8 }
9 
10 /// @title buying tokens with eth.
11 /// @dev This contract must be created with the address of the token to sell.
12 /// This contract must also own some quantity of the token it's selling.
13 /// Note: This is not meant to be feature complete.
14 
15 contract MeerkatICO {
16     iERC20 token;
17     address owner;
18     address tokenCo;
19     uint rateMe;
20     
21     modifier ownerOnly() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26 
27     // @notice Initialises the contract.
28     // @param _main The address of an ERC20 compatible token to sell.
29    constructor(address _main) public {
30         token = iERC20(_main);
31         tokenCo = _main;
32         owner = msg.sender;
33         rateMe = 0;
34     }
35 
36     /// @notice Will transfer all ether in this account to the contract owner.
37     function withdraw() public ownerOnly {
38         owner.transfer(address(this).balance);
39     }
40 
41     /// @notice This function will set the conversion rate.
42     /// @dev To set a rate of 100 token / eth, you would make the rate 100 hopefully.
43     /// @param _rateMe The conversion rate in a hole
44     function setRate(uint _rateMe) public ownerOnly {
45         rateMe = _rateMe;
46     }
47     
48     function CurrentRate() public constant returns (uint rate) {
49         return rateMe;
50     }
51     
52     function TokenLinked() public constant returns (address _token, uint _amountLeft) {
53         return (tokenCo, (token.balanceOf(address(this)) / 10**18)) ;
54     }
55     
56     
57     // ------------------------------------------------------------------------
58     // Owner can transfer out any accidentally sent ERC20 tokens
59     // ------------------------------------------------------------------------
60     function transferAnyERC20Token(address tokenAddress, uint tokens) public ownerOnly returns (bool success) {
61         return iERC20(tokenAddress).transfer(owner, tokens);
62     }
63 
64     /// @notice Any funds sent to this contract will be converted to the linked contract's tokens
65     /// @dev This function receives funds, and transfers tokens based on the current conversion rate
66 	
67     function () public payable {
68         // minimum contribution is 0.1 ETH
69 	    // STOP selling if the rate is set to 0
70         require( (msg.value >= 100000000000000000) && (rateMe != 0) );
71         
72         uint value = msg.value * rateMe;
73         
74         // Overflow detection/protection:
75         require(value/msg.value == rateMe);
76         
77         token.transfer(msg.sender, value);
78         
79     }
80 }