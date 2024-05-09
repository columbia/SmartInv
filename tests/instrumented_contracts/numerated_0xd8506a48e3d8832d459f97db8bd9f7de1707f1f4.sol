1 pragma solidity ^0.4.17;
2 
3 contract Ownable {
4   address public owner;
5   
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8 
9   function Ownable() internal {
10     owner = msg.sender;
11   }
12 
13   modifier onlyOwner() {
14     require(msg.sender == owner);
15     _;
16   }
17 
18   function transferOwnership(address newOwner) onlyOwner public {
19     require(newOwner != address(0));
20     OwnershipTransferred(owner, newOwner);
21     owner = newOwner;
22   }
23 }
24 
25 contract ERC20Basic {
26   function balanceOf(address who) public constant returns (uint256);
27   function transfer(address to, uint256 value) public returns (bool);
28 }
29 
30 library SafeERC20 {
31   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
32     assert(token.transfer(to, value));
33   }
34 }
35 
36 /**
37  * @title TokenTimelock
38  * @dev TokenTimelock is a token holder contract that will allow a
39  * beneficiary to extract the tokens after a given release time
40  */
41 contract TokenTimelock is Ownable{
42   using SafeERC20 for ERC20Basic;
43   ERC20Basic public token;   // ERC20 basic token contract being held
44   uint64 public releaseTime; // timestamp when token claim is enabled
45 
46   function TokenTimelock(ERC20Basic _token, uint64 _releaseTime) public {
47     require(_releaseTime > now);
48     token = _token;
49     owner = msg.sender;
50     releaseTime = _releaseTime;
51   }
52 
53   /**
54    * @notice Transfers tokens held by timelock to owner.
55    */
56   function claim() public onlyOwner {
57     require(now >= releaseTime);
58 
59     uint256 amount = token.balanceOf(this);
60     require(amount > 0);
61 
62     token.safeTransfer(owner, amount);
63   }
64 }