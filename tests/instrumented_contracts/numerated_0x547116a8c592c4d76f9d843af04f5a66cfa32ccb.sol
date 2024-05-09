1 pragma solidity ^0.4.21;
2 
3 contract ERC20 {
4   function balanceOf(address _owner) public constant returns (uint balance);
5   function transfer(address _to, uint _value) public returns (bool success);
6 }
7 
8 contract TokenSale {
9 	address public owner;
10 	address public token = 0xCD8aAC9972dc4Ddc48d700bc0710C0f5223fBCfa;
11 	uint256 price = 24570000000000;
12 	event TokenSold(address indexed _buyer, uint256 _tokens);
13 	modifier onlyOwner() {
14       if (msg.sender!=owner) revert();
15       _;
16     }
17     
18     function TokenSale() public {
19         owner = msg.sender;
20     }
21     
22     function transferOwnership(address newOwner) public onlyOwner {
23         owner = newOwner;
24     }
25     
26     function setPrice(uint256 newPrice) public onlyOwner {
27         if (newPrice<=0) revert();
28         price = newPrice;
29     }
30     
31     function withdrawTokens(address tadr, uint256 tkn) public onlyOwner  {
32         if (tkn<=0 || ERC20(tadr).balanceOf(address(this))<tkn) revert();
33         ERC20(tadr).transfer(owner, tkn);
34     }
35     
36     function () payable public {
37         if (msg.value<=0) revert();
38         uint256 tokens = msg.value/price;
39         uint256 max = ERC20(token).balanceOf(address(this));
40         if (tokens>max) {
41             tokens = max;
42             msg.sender.transfer(msg.value-max*price);
43         }
44         ERC20(token).transfer(msg.sender, tokens);
45         emit TokenSold(msg.sender,tokens);
46         owner.transfer(address(this).balance);
47     }
48 }