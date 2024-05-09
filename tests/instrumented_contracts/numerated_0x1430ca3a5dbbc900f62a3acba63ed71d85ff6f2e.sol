1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeERC20 {
18   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
19     assert(token.transfer(to, value));
20   }
21 
22   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
23     assert(token.transferFrom(from, to, value));
24   }
25 
26   function safeApprove(ERC20 token, address spender, uint256 value) internal {
27     assert(token.approve(spender, value));
28   }
29 }
30 
31 contract TokenTimelock {
32   using SafeERC20 for ERC20Basic;
33 
34   // ERC20 basic token contract being held
35   ERC20Basic public token;
36 
37   // beneficiary of tokens after they are released
38   address public beneficiary;
39 
40   // timestamp when token release is enabled
41   uint64 public releaseTime;
42 
43   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
44     require(_releaseTime > now);
45     token = _token;
46     beneficiary = _beneficiary;
47     releaseTime = _releaseTime;
48   }
49 
50   /**
51    * @notice Transfers tokens held by timelock to beneficiary.
52    */
53   function release() public {
54     require(now >= releaseTime);
55 
56     uint256 amount = token.balanceOf(this);
57     require(amount > 0);
58 
59     token.safeTransfer(beneficiary, amount);
60   }
61 }