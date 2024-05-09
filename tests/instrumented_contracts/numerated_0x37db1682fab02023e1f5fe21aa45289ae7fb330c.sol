1 pragma solidity ^0.4.20;
2 
3 contract ERC20 {
4     function totalSupply() public constant returns (uint);
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10     event Transfer(address indexed from, address indexed to, uint tokens);
11     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
12 }
13 
14 contract exForward{
15     address public owner;
16     event change_owner(string newOwner, address indexed toOwner);
17     event eth_deposit(address sender, uint amount);
18     event erc_deposit(address from, address ctr, address to, uint amount);
19     constructor() public {
20         owner = msg.sender;
21     }
22     modifier isOwner{
23         require(owner == msg.sender);
24         _;
25     }
26     function trToken(address tokenContract, uint tokens) public{
27         ERC20(tokenContract).transferFrom(msg.sender, owner, tokens);
28         emit erc_deposit(msg.sender, tokenContract, owner, tokens);
29     }
30     function changeOwner(address to_owner) public isOwner returns (bool success){
31         owner = to_owner;
32         emit change_owner("OwnerChanged",to_owner);
33         return true;
34     }
35     function() payable public {
36         owner.transfer(msg.value);
37         emit eth_deposit(msg.sender,msg.value);
38     }
39 }