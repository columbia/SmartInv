1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 import {IERC20} from "../intf/IERC20.sol";
12 import {SafeMath} from "../lib/SafeMath.sol";
13 import {Ownable} from "../lib/Ownable.sol";
14 
15 /**
16  * @title DODOLpToken
17  * @author DODO Breeder
18  *
19  * @notice Tokenize liquidity pool assets. An ordinary ERC20 contract with mint and burn functions
20  */
21 contract DODOLpToken is Ownable {
22     using SafeMath for uint256;
23 
24     string public symbol = "DLP";
25     address public originToken;
26 
27     uint256 public totalSupply;
28     mapping(address => uint256) internal balances;
29     mapping(address => mapping(address => uint256)) internal allowed;
30 
31     // ============ Events ============
32 
33     event Transfer(address indexed from, address indexed to, uint256 amount);
34 
35     event Approval(address indexed owner, address indexed spender, uint256 amount);
36 
37     event Mint(address indexed user, uint256 value);
38 
39     event Burn(address indexed user, uint256 value);
40 
41     // ============ Functions ============
42 
43     constructor(address _originToken) public {
44         originToken = _originToken;
45     }
46 
47     function name() public view returns (string memory) {
48         string memory lpTokenSuffix = "_DODO_LP_TOKEN_";
49         return string(abi.encodePacked(IERC20(originToken).name(), lpTokenSuffix));
50     }
51 
52     function decimals() public view returns (uint8) {
53         return IERC20(originToken).decimals();
54     }
55 
56     /**
57      * @dev transfer token for a specified address
58      * @param to The address to transfer to.
59      * @param amount The amount to be transferred.
60      */
61     function transfer(address to, uint256 amount) public returns (bool) {
62         require(amount <= balances[msg.sender], "BALANCE_NOT_ENOUGH");
63 
64         balances[msg.sender] = balances[msg.sender].sub(amount);
65         balances[to] = balances[to].add(amount);
66         emit Transfer(msg.sender, to, amount);
67         return true;
68     }
69 
70     /**
71      * @dev Gets the balance of the specified address.
72      * @param owner The address to query the the balance of.
73      * @return balance An uint256 representing the amount owned by the passed address.
74      */
75     function balanceOf(address owner) external view returns (uint256 balance) {
76         return balances[owner];
77     }
78 
79     /**
80      * @dev Transfer tokens from one address to another
81      * @param from address The address which you want to send tokens from
82      * @param to address The address which you want to transfer to
83      * @param amount uint256 the amount of tokens to be transferred
84      */
85     function transferFrom(
86         address from,
87         address to,
88         uint256 amount
89     ) public returns (bool) {
90         require(amount <= balances[from], "BALANCE_NOT_ENOUGH");
91         require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
92 
93         balances[from] = balances[from].sub(amount);
94         balances[to] = balances[to].add(amount);
95         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
96         emit Transfer(from, to, amount);
97         return true;
98     }
99 
100     /**
101      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
102      * @param spender The address which will spend the funds.
103      * @param amount The amount of tokens to be spent.
104      */
105     function approve(address spender, uint256 amount) public returns (bool) {
106         allowed[msg.sender][spender] = amount;
107         emit Approval(msg.sender, spender, amount);
108         return true;
109     }
110 
111     /**
112      * @dev Function to check the amount of tokens that an owner allowed to a spender.
113      * @param owner address The address which owns the funds.
114      * @param spender address The address which will spend the funds.
115      * @return A uint256 specifying the amount of tokens still available for the spender.
116      */
117     function allowance(address owner, address spender) public view returns (uint256) {
118         return allowed[owner][spender];
119     }
120 
121     function mint(address user, uint256 value) external onlyOwner {
122         balances[user] = balances[user].add(value);
123         totalSupply = totalSupply.add(value);
124         emit Mint(user, value);
125         emit Transfer(address(0), user, value);
126     }
127 
128     function burn(address user, uint256 value) external onlyOwner {
129         balances[user] = balances[user].sub(value);
130         totalSupply = totalSupply.sub(value);
131         emit Burn(user, value);
132         emit Transfer(user, address(0), value);
133     }
134 }
