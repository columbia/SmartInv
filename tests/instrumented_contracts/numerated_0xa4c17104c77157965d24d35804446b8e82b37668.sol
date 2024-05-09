1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
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
22   function safeTransferFrom(
23     ERC20 token,
24     address from,
25     address to,
26     uint256 value
27   )
28     internal
29   {
30     assert(token.transferFrom(from, to, value));
31   }
32 
33   function safeApprove(ERC20 token, address spender, uint256 value) internal {
34     assert(token.approve(spender, value));
35   }
36 }
37 
38 contract TokenTimelock {
39   using SafeERC20 for ERC20Basic;
40 
41   // ERC20 basic token contract being held
42   ERC20Basic public token;
43 
44   // beneficiary of tokens after they are released
45   address public beneficiary;
46 
47   // timestamp when token release is enabled
48   uint256 public releaseTime;
49 
50   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
51     // solium-disable-next-line security/no-block-members
52     require(_releaseTime > block.timestamp);
53     token = _token;
54     beneficiary = _beneficiary;
55     releaseTime = _releaseTime;
56   }
57 
58   /**
59    * @notice Transfers tokens held by timelock to beneficiary.
60    */
61   function release() public {
62     // solium-disable-next-line security/no-block-members
63     require(block.timestamp >= releaseTime);
64 
65     uint256 amount = token.balanceOf(this);
66     require(amount > 0);
67 
68     token.safeTransfer(beneficiary, amount);
69   }
70 }