1 pragma solidity 0.4.20;
2 
3 contract ERC20 {
4   uint public totalSupply;
5   
6   function balanceOf(address who) public constant returns (uint);
7   function allowance(address owner, address spender) public constant returns (uint);
8 
9   function transfer(address to, uint value) public returns (bool ok);
10   function transferFrom(address from, address to, uint value) public returns (bool ok);
11   function approve(address spender, uint value) public returns (bool ok);
12   
13   event Transfer(address indexed from, address indexed to, uint value);
14   event Approval(address indexed owner, address indexed spender, uint value);
15 }
16 
17 
18 contract CanSend {
19 
20   uint8 MAX_RECIPIENTS = 255;
21 
22   event TokensSent (address indexed token, uint256 total);
23 
24   function multisend (address _token, address[] _recipients, uint256[] _amounts) public {
25     require(_token != address(0));
26     require(_recipients.length != 0);
27     require(_recipients.length <= MAX_RECIPIENTS);
28     require(_recipients.length == _amounts.length);
29     ERC20 tokenToSend = ERC20(_token);
30     uint256 totalSent = 0;
31     for (uint8 i = 0; i < _recipients.length; i++) {
32       require(tokenToSend.transferFrom(msg.sender, _recipients[i], _amounts[i]));
33       totalSent += _amounts[i];
34     }
35     TokensSent(_token, totalSent);
36   }
37 
38 }