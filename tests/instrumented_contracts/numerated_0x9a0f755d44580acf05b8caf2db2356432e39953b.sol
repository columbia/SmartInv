1 pragma solidity ^0.4.24;
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
13 contract BurnContract {
14 
15     address public owner;
16     ERC20 Paytoken;
17     // admin function
18     modifier onlyAdmin() {
19         require (msg.sender == owner);
20         _;
21     }
22 
23     function setPayanyToken(address _PayToken) onlyAdmin public {
24         Paytoken = ERC20(_PayToken);
25     }
26     
27     
28     function getTokenBalanceOf(address h0dler) constant public returns(uint balance){
29         return Paytoken.balanceOf(h0dler);
30     }
31     
32     function swapToEth(address _to) payable public  returns(bool){
33         _to.transfer(msg.value);
34     }
35     
36 }