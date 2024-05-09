1 pragma solidity ^0.4.17;
2 
3 contract I {
4     function transfer(address to, uint256 val) public returns (bool);
5     function balanceOf(address who) constant public returns (uint256);
6 }
7 
8 contract GenTokenAddress {
9     function GenTokenAddress(address token, address to) {
10         I(token).transfer(to, I(token).balanceOf(address(this)));
11     }
12 }
13 
14 contract GenTokens {
15     address public owner = msg.sender;
16     modifier onlyOwner { require(msg.sender == owner); _; }
17     uint public tip = 0.00077 ether;
18     
19     function create(address token, uint numberOfNewAddresses) payable {
20         require(msg.value >= tip); 
21         for (uint i = 0; i < numberOfNewAddresses; i++)
22             address t = new GenTokenAddress(token, msg.sender);
23     }
24     
25     function() payable { }
26     
27     function withdraw() onlyOwner { owner.transfer(this.balance); }
28     
29     function withdrawToken(address token) onlyOwner {
30         uint bal = I(token).balanceOf(address(this));
31         if (bal > 0) I(token).transfer(owner, bal);
32     }
33     
34     function setTip(uint val) onlyOwner { tip = val; }
35     function transferOwner(address to) onlyOwner { owner = to; }
36 }