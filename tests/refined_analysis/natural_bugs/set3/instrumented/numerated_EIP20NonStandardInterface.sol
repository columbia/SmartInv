1 pragma solidity ^0.5.16;
2 
3 /**
4  * @title EIP20NonStandardInterface
5  * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
6  *  See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
7  */
8 interface EIP20NonStandardInterface {
9     /**
10      * @notice Get the total number of tokens in circulation
11      * @return The supply of tokens
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @notice Gets the balance of the specified address
17      * @param owner The address from which the balance will be retrieved
18      * @return The balance
19      */
20     function balanceOf(address owner) external view returns (uint256 balance);
21 
22     ///
23     /// !!!!!!!!!!!!!!
24     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
25     /// !!!!!!!!!!!!!!
26     ///
27 
28     /**
29      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
30      * @param dst The address of the destination account
31      * @param amount The number of tokens to transfer
32      */
33     function transfer(address dst, uint256 amount) external;
34 
35     ///
36     /// !!!!!!!!!!!!!!
37     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
38     /// !!!!!!!!!!!!!!
39     ///
40 
41     /**
42      * @notice Transfer `amount` tokens from `src` to `dst`
43      * @param src The address of the source account
44      * @param dst The address of the destination account
45      * @param amount The number of tokens to transfer
46      */
47     function transferFrom(
48         address src,
49         address dst,
50         uint256 amount
51     ) external;
52 
53     /**
54      * @notice Approve `spender` to transfer up to `amount` from `src`
55      * @dev This will overwrite the approval amount for `spender`
56      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
57      * @param spender The address of the account which may transfer tokens
58      * @param amount The number of tokens that are approved
59      * @return Whether or not the approval succeeded
60      */
61     function approve(address spender, uint256 amount) external returns (bool success);
62 
63     /**
64      * @notice Get the current allowance from `owner` for `spender`
65      * @param owner The address of the account which owns the tokens to be spent
66      * @param spender The address of the account which may transfer tokens
67      * @return The number of tokens allowed to be spent
68      */
69     function allowance(address owner, address spender) external view returns (uint256 remaining);
70 
71     event Transfer(address indexed from, address indexed to, uint256 amount);
72     event Approval(address indexed owner, address indexed spender, uint256 amount);
73 }
