1 pragma solidity 0.4.21;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20     function allowance(address owner, address spender) public view returns (uint256);
21     function transferFrom(address from, address to, uint256 value) public returns (bool);
22     function approve(address spender, uint256 value) public returns (bool);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title TokenTimelock
28  * @dev TokenTimelock is a token holder contract that will allow a
29  * beneficiary to extract the tokens after a given release time
30  */
31 contract TokenTimelock {
32   
33   // ERC20 basic token contract being held
34   ERC20 public token;
35 
36   // beneficiary of tokens after they are released
37   address public beneficiary;
38 
39   // timestamp when token release is enabled
40   uint256 public releaseTime;
41 
42   function TokenTimelock(ERC20 _token, address _beneficiary, uint256 _releaseTime) public {
43     require(_releaseTime > now);
44     token = _token;
45     beneficiary = _beneficiary;
46     releaseTime = _releaseTime;
47   }
48 
49   /**
50    * @notice Transfers tokens held by timelock to beneficiary.
51    */
52   function release() public {
53     require(now >= releaseTime);
54     uint256 amount = token.balanceOf(this);
55     require(amount > 0);
56     token.transfer(beneficiary, amount);
57   }
58 }