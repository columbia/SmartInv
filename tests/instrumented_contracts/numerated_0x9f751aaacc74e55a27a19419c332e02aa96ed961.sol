1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4 
5   address public owner;
6 
7   function Ownable() public {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function transferOwnership(address newOwner) public onlyOwner {
17     require(newOwner != address(0));
18     owner = newOwner;
19   }
20 }
21 
22 contract ERC20Basic {
23   function transfer(address _to, uint256 _value)external returns (bool);
24   function balanceOf(address _owner)external constant returns (uint256 balance);
25 }
26 
27 contract AirDrop is Ownable {
28 
29   ERC20Basic token;
30 
31   event TransferredToken(address indexed to, uint256 value);
32 
33   function AirDrop (address _tokenAddr) public {
34       token = ERC20Basic(_tokenAddr);
35   }
36 
37   // Function given below is used when you want to send same number of tokens to all the recipients
38   function sendTokens(address[] recipient, uint256 value) onlyOwner external {
39     for (uint256 i = 0; i < recipient.length; i++) {
40         token.transfer(recipient[i],value * 10**8);
41         emit TransferredToken(recipient[i], value);
42     }
43   }
44 
45 
46   function tokensAvailable()public constant returns (uint256) {
47     return token.balanceOf(this);
48   }
49 
50 
51   function destroy() public onlyOwner {
52     uint256 balance = tokensAvailable();
53     token.transfer(owner, balance);
54     selfdestruct(owner);
55   }
56 }