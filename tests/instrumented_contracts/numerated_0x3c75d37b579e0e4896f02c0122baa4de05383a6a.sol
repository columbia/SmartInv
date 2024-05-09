1 // hevm: flattened sources of contracts/Alchemist.sol
2 pragma solidity ^0.4.24;
3 
4 ////// contracts/openzeppelin/IERC20.sol
5 /* pragma solidity ^0.4.24; */
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/20
10  */
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address who) external view returns (uint256);
15 
16     function allowance(address owner, address spender) external view returns (uint256);
17 
18     function transfer(address to, uint256 value) external returns (bool);
19 
20     function approve(address spender, uint256 value) external returns (bool);
21 
22     function transferFrom(address from, address to, uint256 value) external returns (bool);
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 ////// contracts/Alchemist.sol
30 /* pragma solidity ^0.4.24; */
31 
32 /* import "./openzeppelin/IERC20.sol"; */
33 
34 contract Alchemist {
35     address public LEAD;
36     address public GOLD;
37 
38     constructor(address _lead, address _gold) public {
39         LEAD = _lead;
40         GOLD = _gold;
41     }
42 
43     function transmute(uint _mass) external {
44         require(
45             IERC20(LEAD).transferFrom(msg.sender, address(this), _mass),
46             "LEAD transfer failed"
47         );
48         require(
49             IERC20(GOLD).transfer(msg.sender, _mass),
50             "GOLD transfer failed"
51         );
52     }
53 }