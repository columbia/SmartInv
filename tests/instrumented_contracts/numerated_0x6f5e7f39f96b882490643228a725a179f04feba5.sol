1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4   uint public totalSupply;
5   function balanceOf(address who) constant returns (uint);
6   function allowance(address owner, address spender) constant returns (uint);
7   function transfer(address to, uint value) returns (bool ok);
8   function transferFrom(address from, address to, uint value) returns (bool ok);
9   function approve(address spender, uint value) returns (bool ok);
10   function mintToken(address to, uint256 value) returns (uint256);
11   function setAllowTransfer(bool allowed);
12 }
13 
14 contract PreSale {
15 
16     uint256 public maxMintable;
17     uint256 public totalMinted;
18     uint256 public exchangeRate;
19     bool public isFunding;
20     ERC20 public Token;
21     address public ETHWallet;
22 
23     bool private configSet;
24     address public creator;
25 
26     function PreSale(address _wallet) {
27         maxMintable = 30000000000000000000000000;
28         ETHWallet = _wallet;
29         creator = msg.sender;
30         isFunding = false;
31         exchangeRate = 3125;
32     }
33 
34     function setup(address token_address) {
35         require(!configSet);
36         Token = ERC20(token_address);
37         isFunding = true;
38         configSet = true;
39     }
40 
41     function closeSale() external {
42       require(msg.sender==creator);
43       isFunding = false;
44     }
45 
46     function () payable {
47         require(msg.value>0);
48         require(isFunding);
49         uint256 amount = msg.value * exchangeRate;
50         uint256 total = totalMinted + amount;
51         require(total<=maxMintable);
52         totalMinted += amount;
53         ETHWallet.transfer(msg.value);
54         Token.mintToken(msg.sender, amount);
55     }
56 
57     function contribute() external payable {
58         require(msg.value>0);
59         require(isFunding);
60         uint256 amount = msg.value * exchangeRate;
61         uint256 total = totalMinted + amount;
62         require(total<=maxMintable);
63         totalMinted += amount;
64         ETHWallet.transfer(msg.value);
65         Token.mintToken(msg.sender, amount);
66     }
67 
68     function updateRate(uint256 rate) external {
69         require(msg.sender==creator);
70         require(isFunding);
71         exchangeRate = rate;
72     }
73 }