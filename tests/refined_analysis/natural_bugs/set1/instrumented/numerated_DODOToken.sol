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
11 import {SafeMath} from "../lib/SafeMath.sol";
12 
13 
14 /**
15  * @title DODO Token
16  * @author DODO Breeder
17  */
18 contract DODOToken {
19     using SafeMath for uint256;
20 
21     string public symbol = "DODO";
22     string public name = "DODO bird";
23 
24     uint256 public decimals = 18;
25     uint256 public totalSupply = 1000000000 * 10**18; // 1 Billion
26 
27     mapping(address => uint256) internal balances;
28     mapping(address => mapping(address => uint256)) internal allowed;
29 
30     // ============ Events ============
31 
32     event Transfer(address indexed from, address indexed to, uint256 amount);
33 
34     event Approval(address indexed owner, address indexed spender, uint256 amount);
35 
36     // ============ Functions ============
37 
38     constructor() public {
39         balances[msg.sender] = totalSupply;
40     }
41 
42     /**
43      * @dev transfer token for a specified address
44      * @param to The address to transfer to.
45      * @param amount The amount to be transferred.
46      */
47     function transfer(address to, uint256 amount) public returns (bool) {
48         require(amount <= balances[msg.sender], "BALANCE_NOT_ENOUGH");
49 
50         balances[msg.sender] = balances[msg.sender].sub(amount);
51         balances[to] = balances[to].add(amount);
52         emit Transfer(msg.sender, to, amount);
53         return true;
54     }
55 
56     /**
57      * @dev Gets the balance of the specified address.
58      * @param owner The address to query the the balance of.
59      * @return balance An uint256 representing the amount owned by the passed address.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance) {
62         return balances[owner];
63     }
64 
65     /**
66      * @dev Transfer tokens from one address to another
67      * @param from address The address which you want to send tokens from
68      * @param to address The address which you want to transfer to
69      * @param amount uint256 the amount of tokens to be transferred
70      */
71     function transferFrom(
72         address from,
73         address to,
74         uint256 amount
75     ) public returns (bool) {
76         require(amount <= balances[from], "BALANCE_NOT_ENOUGH");
77         require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
78 
79         balances[from] = balances[from].sub(amount);
80         balances[to] = balances[to].add(amount);
81         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
82         emit Transfer(from, to, amount);
83         return true;
84     }
85 
86     /**
87      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
88      * @param spender The address which will spend the funds.
89      * @param amount The amount of tokens to be spent.
90      */
91     function approve(address spender, uint256 amount) public returns (bool) {
92         allowed[msg.sender][spender] = amount;
93         emit Approval(msg.sender, spender, amount);
94         return true;
95     }
96 
97     /**
98      * @dev Function to check the amount of tokens that an owner allowed to a spender.
99      * @param owner address The address which owns the funds.
100      * @param spender address The address which will spend the funds.
101      * @return A uint256 specifying the amount of tokens still available for the spender.
102      */
103     function allowance(address owner, address spender) public view returns (uint256) {
104         return allowed[owner][spender];
105     }
106 }
