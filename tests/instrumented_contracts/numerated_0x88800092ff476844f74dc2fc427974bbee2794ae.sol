1 // SPDX-License-Identifier: agpl-3.0
2 pragma solidity 0.8.7;
3 
4 // https://github.com/AmbireTech/wallet/blob/main/contracts/WALLET.sol
5 contract WALLETToken {
6 	// Constants
7 	string public constant name = "Ambire Wallet";
8 	string public constant symbol = "WALLET";
9 	uint8 public constant decimals = 18;
10 	uint public constant MAX_SUPPLY = 1_000_000_000 * 1e18;
11 
12 	// Mutable variables
13 	uint public totalSupply;
14 	mapping(address => uint) balances;
15 	mapping(address => mapping(address => uint)) allowed;
16 
17 	event Approval(address indexed owner, address indexed spender, uint amount);
18 	event Transfer(address indexed from, address indexed to, uint amount);
19 
20 	event SupplyControllerChanged(address indexed prev, address indexed current);
21 
22 	address public supplyController;
23 	constructor(address _supplyController) {
24 		supplyController = _supplyController;
25 		emit SupplyControllerChanged(address(0), _supplyController);
26 	}
27 
28 	function balanceOf(address owner) external view returns (uint balance) {
29 		return balances[owner];
30 	}
31 
32 	function transfer(address to, uint amount) external returns (bool success) {
33 		balances[msg.sender] = balances[msg.sender] - amount;
34 		balances[to] = balances[to] + amount;
35 		emit Transfer(msg.sender, to, amount);
36 		return true;
37 	}
38 
39 	function transferFrom(address from, address to, uint amount) external returns (bool success) {
40 		balances[from] = balances[from] - amount;
41 		allowed[from][msg.sender] = allowed[from][msg.sender] - amount;
42 		balances[to] = balances[to] + amount;
43 		emit Transfer(from, to, amount);
44 		return true;
45 	}
46 
47 	function approve(address spender, uint amount) external returns (bool success) {
48 		allowed[msg.sender][spender] = amount;
49 		emit Approval(msg.sender, spender, amount);
50 		return true;
51 	}
52 
53 	function allowance(address owner, address spender) external view returns (uint remaining) {
54 		return allowed[owner][spender];
55 	}
56 
57 	// Supply control
58 	function innerMint(address owner, uint amount) internal {
59 		totalSupply = totalSupply + amount;
60 		require(totalSupply < MAX_SUPPLY, 'MAX_SUPPLY');
61 		balances[owner] = balances[owner] + amount;
62 		// Because of https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1
63 		emit Transfer(address(0), owner, amount);
64 	}
65 
66 	function mint(address owner, uint amount) external {
67 		require(msg.sender == supplyController, 'NOT_SUPPLYCONTROLLER');
68 		innerMint(owner, amount);
69 	}
70 
71 	function changeSupplyController(address newSupplyController) external {
72 		require(msg.sender == supplyController, 'NOT_SUPPLYCONTROLLER');
73 		// Emitting here does not follow checks-effects-interactions-logs, but it's safe anyway cause there are no external calls
74 		emit SupplyControllerChanged(supplyController, newSupplyController);
75 		supplyController = newSupplyController;
76 	}
77 }