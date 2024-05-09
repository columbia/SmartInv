1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() public {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     require(msg.sender == owner);
12     _;
13   }
14 
15 }
16 
17 contract ERC20Basic {
18   uint256 public totalSupply;
19   function balanceOf(address who) public view returns (uint256);
20   function transfer(address to, uint256 value) public returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22 }
23 
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) public view returns (uint256);
26   function transferFrom(address from, address to, uint256 value) public returns (bool);
27   function approve(address spender, uint256 value) public returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeERC20 {
32   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
33     assert(token.transfer(to, value));
34   }
35 
36   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
37     assert(token.transferFrom(from, to, value));
38   }
39 
40   function safeApprove(ERC20 token, address spender, uint256 value) internal {
41     assert(token.approve(spender, value));
42   }
43 }
44 
45 contract BS is Ownable {
46     using SafeERC20 for ERC20Basic;
47 
48     function bulkTransfer(ERC20Basic token, address[] toAddresses, uint256[] values) public onlyOwner returns (bool) {
49         require((toAddresses.length > 0) && (toAddresses.length == values.length));
50         for (uint i = 0; i < toAddresses.length; i++) {
51             token.safeTransfer(toAddresses[i], values[i]);
52         }
53         return true;
54     }
55 }