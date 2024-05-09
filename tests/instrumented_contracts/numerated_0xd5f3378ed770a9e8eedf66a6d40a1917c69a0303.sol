1 pragma solidity ^0.4.25;
2 
3 contract ERC20Interface {
4     function totalSupply() public view returns (uint);
5     function balanceOf(address tokenOwner) public view returns (uint balance);
6     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract Distribute {
16     function multisend(address _tokenAddr, address[] memory _to, uint256[] memory _value) public
17     returns (bool _success) {
18         assert(_to.length == _value.length);
19         assert(_to.length <= 150);
20                 // loop through to addresses and send value
21         for (uint8 i = 0; i < _to.length; i++) {
22             assert((ERC20Interface(_tokenAddr).transferFrom(msg.sender, _to[i], _value[i])) == true);
23         }
24         return true;
25     }
26 }