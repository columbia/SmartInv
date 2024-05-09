1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     event Approval(address indexed owner, address indexed spender, uint256 value);
11 
12     function totalSupply() public view returns (uint256);
13     function balanceOf(address who) public view returns (uint256);
14     function transfer(address to, uint256 value) public returns (bool);
15     function allowance(address owner, address spender) public view returns (uint256);
16     function transferFrom(address from, address to, uint256 value) public returns (bool);
17     function approve(address spender, uint256 value) public returns (bool);
18 }
19 
20 
21 /**
22  * @title Photochain token vesting period contract
23  *
24  * @dev PhotochainVesting is a token holder contract that will allow a
25  * beneficiary to extract the tokens after a given release time
26  * @dev Based on https://github.com/OpenZeppelin/zeppelin-solidity
27  */
28 contract PhotochainVesting {
29     // ERC20 token contract being held
30     ERC20 public token;
31 
32     // beneficiary of tokens after they are released
33     address public beneficiary;
34 
35     // timestamp when token release is enabled
36     uint256 public releaseTime;
37 
38     constructor(ERC20 _token, address _beneficiary, uint256 _releaseTime) public {
39         // solium-disable-next-line security/no-block-members
40         require(_releaseTime > block.timestamp, "Release time must be in future");
41 
42         // solium-disable-next-line security/no-block-members
43         require(_releaseTime < block.timestamp + 3 * 365 days, "Release time must not exceed 3 years");
44 
45         token = _token;
46         beneficiary = _beneficiary;
47         releaseTime = _releaseTime;
48     }
49 
50     /**
51      * @notice Transfers tokens held by timelock to beneficiary.
52      */
53     function release() public {
54         // solium-disable-next-line security/no-block-members
55         require(block.timestamp >= releaseTime, "Release time must pass");
56 
57         uint256 amount = token.balanceOf(address(this));
58         require(amount > 0, "Contract must hold any tokens");
59 
60         require(token.transfer(beneficiary, amount), "Transfer must succeed");
61     }
62 }