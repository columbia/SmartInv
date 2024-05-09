1 pragma solidity ^0.4.18;
2 
3 
4 contract StandardToken  {
5   function balanceOf(address who) constant public returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract owned {
11     address public owner;
12 
13     function owned() public{
14         owner = msg.sender;
15     }
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20     function transferOwnership(address newOwner) public onlyOwner {
21         owner = newOwner;
22     }
23 }
24 
25 contract JPPreICO is owned{
26     
27     StandardToken token;
28     address walletAddress;
29     uint256 tokenPerEth;
30     uint256 startBlock;
31     uint256 endBlock;
32     uint256 minInvestmentInWei;
33     
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Buy(address indexed buyer, uint256 eth, uint256 JPT);
36     
37     function JPPreICO() public{
38         token = StandardToken(0xce4d20b74fAf8C1Ab15e2B0Fd3F1CCCfe6f6d419); // Token address
39         walletAddress=0x18aB7d43e9062d8656AE42EE9E473E05dE0DD3B9; //Wallet address
40         tokenPerEth=0; //Number of tokens for 1 eth
41         startBlock=5362919; //start block of pre ico
42         endBlock=5483879; //end block of pre ico
43         minInvestmentInWei=22121283624351108; //min investment in wei value
44     }
45 
46     function () public payable {
47         require(msg.value>=minInvestmentInWei);
48         require(msg.data.length==0);
49         require((msg.value*tokenPerEth)/(10**16)<=token.balanceOf(this));//Check if pre ICO has enough tokens to transfer
50         require(isICOUp());//Check for temporal limits
51         uint256 coins = (msg.value * tokenPerEth)/(10**16);
52         walletAddress.transfer(msg.value);
53         token.transfer(msg.sender, coins);
54         //events
55         Transfer(this,msg.sender,coins);
56         Buy(msg.sender, msg.value, coins);
57     }
58     
59     
60     function getMaxEtherToInvest() public view returns (uint256){
61         return (token.balanceOf(this)/tokenPerEth);
62     }
63     
64     function setMinInvestmentInWei(uint256 _minInvestmentInWei) public onlyOwner {
65         minInvestmentInWei=_minInvestmentInWei;
66     }
67     
68     function isICOUp() public view returns(bool){
69         return (block.number>=startBlock && block.number<=endBlock);
70     }
71     
72     function setTokenPerEth (uint256 _change) public onlyOwner{
73     	tokenPerEth = _change;
74     }
75     
76     
77     //Funzioni debug
78     function getWalletAddress() public view returns(address){
79         return walletAddress;
80     }
81     
82     function getTokenPerEth() public view returns(uint256){
83         return tokenPerEth;
84     }
85     
86     function getTokenBalance() public view returns(uint256){
87         return token.balanceOf(this);
88     }
89     
90     function setEndBlock(uint256 _endBlock) public onlyOwner{
91         endBlock=_endBlock;
92     }
93     
94     function setStartBlock(uint256 _startBlock) public onlyOwner{
95         startBlock=_startBlock;
96     }
97     
98     function sendBackTokens() public onlyOwner{
99         require(!isICOUp());
100         token.transfer(walletAddress,token.balanceOf(this));
101     }
102  
103 }