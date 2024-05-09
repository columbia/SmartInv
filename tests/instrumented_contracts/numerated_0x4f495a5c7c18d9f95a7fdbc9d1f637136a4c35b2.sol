1 pragma solidity ^0.4.24;
2 
3 contract ERC20Interface 
4 {
5     function balanceOf(address tokenOwner) public view returns (uint balance);
6     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address froms, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13     mapping(address => mapping(address => uint)) allowed;
14 }
15 
16 contract classSend {
17     
18     address public owner=msg.sender;
19     uint amount;
20     address sbttokenaddress = 0x503f9794d6a6bb0df8fbb19a2b3e2aeab35339ad;//sbttoken
21     address lctokenaddress = 0x32d5a1b48168fdfff42d854d5eb256f914ae5b2d;//lctoken
22     address ttttokenaddress = 0x4e1bb58a40f34d8843f61030fe4257c11d09a2c5;//ttttoken
23     
24     event TransferToken(address);
25     
26     modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30     
31     function () external payable {}
32     
33     function sendairdrop(address[] student) onlyOwner public {
34         uint256 i = 0;
35         while (i < student.length) {
36         sendInternally(student[i]);
37         i++;
38          }
39     }
40     
41     function sendInternally(address student) onlyOwner internal {
42       ERC20Interface(sbttokenaddress).transfer(student, 100*1e18);//token1
43       ERC20Interface(lctokenaddress).transfer(student, 80*1e18);//token2
44       ERC20Interface(ttttokenaddress).transfer(student, 200*1e18);//token3
45       emit TransferToken(student);
46     }
47     
48     function changeowner(address newowner) onlyOwner public{
49         owner=newowner;
50     }
51     
52     function transferanyERC20token(address _tokenAddress,uint tokens)public onlyOwner{
53     require(msg.sender==owner);
54     ERC20Interface(_tokenAddress).transfer(owner, tokens*1e18);
55 }
56  
57     function destroy() onlyOwner {
58     selfdestruct(owner);
59   }
60 }