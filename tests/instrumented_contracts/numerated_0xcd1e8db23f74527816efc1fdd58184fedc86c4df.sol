1 pragma solidity ^0.5.1;
2 
3 contract Token {
4   function transfer(address to, uint256 value) public returns (bool success);
5   function transferFrom(address from, address to, uint256 value) public returns (bool success);
6      function balanceOf(address account) external view returns(uint256);
7      function allowance(address _owner, address _spender)external view returns(uint256);
8 }
9 
10 
11 contract KryptoniexDEX {
12 
13     
14     address admin;
15 
16     constructor(address _admin) public{
17     admin = _admin;
18     }
19 
20 
21 
22 
23     function deposit() public payable returns(bool) {
24         require(msg.value > 0);
25         return true;
26     }
27 
28      function withdraw(address payable to,uint256 amount) public payable returns(bool) {
29         require(admin==msg.sender);
30         require(address(this).balance > 0);
31         to.transfer(amount);
32         return true;
33     }
34 
35 
36     function tokenDeposit(address tokenaddr,address fromaddr,uint256 tokenAmount) public returns(bool)
37     {
38         require(tokenAmount > 0);
39         require(tokenallowance(tokenaddr,fromaddr) > 0);
40               Token(tokenaddr).transferFrom(fromaddr,address(this), tokenAmount);
41               return true;
42         
43     }
44   
45 
46     function tokenWithdraw(address tokenAddr,address withdrawaddr, uint256 tokenAmount) public returns(bool)
47     {
48          require(admin==msg.sender);
49          Token(tokenAddr).transfer(withdrawaddr, tokenAmount);
50          return true;
51 
52     }
53     
54      function viewTokenBalance(address tokenAddr,address baladdr)public view returns(uint256){
55         return Token(tokenAddr).balanceOf(baladdr);
56     }
57     
58     function tokenallowance(address tokenAddr,address owner) public view returns(uint256){
59         return Token(tokenAddr).allowance(owner,address(this));
60     }
61     
62 
63 
64 
65 }