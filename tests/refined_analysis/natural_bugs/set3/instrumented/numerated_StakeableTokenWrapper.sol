1 // SPDX-License-Identifier: MIT
2 
3 // Generalized and adapted from https://github.com/k06a/Unipool 🙇
4 
5 pragma solidity 0.6.12;
6 
7 import "@openzeppelin/contracts/math/SafeMath.sol";
8 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
9 
10 /**
11  * @title StakeableTokenWrapper
12  * @notice A wrapper for an ERC-20 that can be staked and withdrawn.
13  * @dev In this contract, staked tokens don't do anything- instead other
14  * contracts can inherit from this one to add functionality.
15  */
16 contract StakeableTokenWrapper {
17     using SafeERC20 for IERC20;
18     using SafeMath for uint256;
19 
20     uint256 public totalSupply;
21     IERC20 public stakedToken;
22     mapping(address => uint256) private _balances;
23 
24     event Staked(address indexed user, uint256 amount);
25     event Withdrawn(address indexed user, uint256 amount);
26 
27     /**
28      * @notice Creates a new StakeableTokenWrapper with given `_stakedToken` address
29      * @param _stakedToken address of a token that will be used to stake
30      */
31     constructor(IERC20 _stakedToken) public {
32         stakedToken = _stakedToken;
33     }
34 
35     /**
36      * @notice Read how much `account` has staked in this contract
37      * @param account address of an account
38      * @return amount of total staked ERC20(this.stakedToken) by `account`
39      */
40     function balanceOf(address account) external view returns (uint256) {
41         return _balances[account];
42     }
43 
44     /**
45      * @notice Stakes given `amount` in this contract
46      * @param amount amount of ERC20(this.stakedToken) to stake
47      */
48     function stake(uint256 amount) external {
49         require(amount != 0, "amount == 0");
50         totalSupply = totalSupply.add(amount);
51         _balances[msg.sender] = _balances[msg.sender].add(amount);
52         stakedToken.safeTransferFrom(msg.sender, address(this), amount);
53         emit Staked(msg.sender, amount);
54     }
55 
56     /**
57      * @notice Withdraws given `amount` from this contract
58      * @param amount amount of ERC20(this.stakedToken) to withdraw
59      */
60     function withdraw(uint256 amount) external {
61         totalSupply = totalSupply.sub(amount);
62         _balances[msg.sender] = _balances[msg.sender].sub(amount);
63         stakedToken.safeTransfer(msg.sender, amount);
64         emit Withdrawn(msg.sender, amount);
65     }
66 }
