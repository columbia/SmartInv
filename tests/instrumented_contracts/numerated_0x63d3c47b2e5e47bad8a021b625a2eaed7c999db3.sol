1 pragma solidity 0.4.24;
2 
3 
4 contract ERC20 {
5 	function transfer(address _to, uint256 _value) public returns (bool success);
6 	function balanceOf(address _owner) public returns (uint256 balance);
7 }
8 
9 
10 contract AirDrop {
11 
12 	address public owner;
13 
14 	modifier onlyOwner {
15 		require(msg.sender == owner, 'Invoker must be msg.sender');
16 		_;
17 	}
18 
19 	constructor() public {
20 		owner = msg.sender;
21 	}
22 
23 	/**
24 	 * @notice Transfers ownership to new owner address
25 	 * @param _newOwner The address of the new owner
26 	 */
27 	function transferOwnership(address _newOwner) public onlyOwner {
28 		require(_newOwner != address(0), "newOwner cannot be zero address");
29 
30 		owner = _newOwner;
31 	}
32 
33 	/**
34 	 * @notice Generic withdraw function in the case of having leftover tokens to withdraw
35 	 * @param _token The address of the ERC20 token to withdraw tokens from
36 	 */
37 	function withdraw(address _token) public onlyOwner {
38 		require(_token != address(0), "Token address cannot be zero address");
39 
40 		uint256 balance = ERC20(_token).balanceOf(address(this));
41 
42 		require(balance > 0, "Cannot withdraw from a balance of zero");
43 
44 		ERC20(_token).transfer(owner, balance);
45 	}
46 
47     /**
48      * @notice MultiTransfer function for airdrop
49      * @param _token ERC20 token address that will get airdrop (this contract must have sufficient tokens to execute this function)
50 	 * @param _amount The amount of tokens to be transfered to each target
51      * @param _targets The target addresses that will receive the free tokens
52      */
53 	function airdrop(address _token, uint256 _amount, address[] memory _targets) public onlyOwner {
54 		require(_targets.length > 0, 'Target addresses must not be 0');
55 		require(_targets.length <= 64, 'Target array length is too big');
56 		require
57         (
58 			_amount * _targets.length <= ERC20(_token).balanceOf(address(this)), 
59 			'Airdrop contract does not have enough tokens to execute the airdrop'
60 		);
61 
62 		for (uint8 target = 0; target < _targets.length; target++) {
63 			ERC20(_token).transfer(_targets[target], _amount);
64 		}
65 	}
66 }