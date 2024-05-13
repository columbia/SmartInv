1 pragma solidity ^0.5.16;
2 
3 /**
4  * @title ERC 20 Token Standard Interface
5  *  https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface EIP20Interface {
8     function name() external view returns (string memory);
9 
10     function symbol() external view returns (string memory);
11 
12     function decimals() external view returns (uint8);
13 
14     /**
15      * @notice Get the total number of tokens in circulation
16      * @return The supply of tokens
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @notice Gets the balance of the specified address
22      * @param owner The address from which the balance will be retrieved
23      * @return The balance
24      */
25     function balanceOf(address owner) external view returns (uint256 balance);
26 
27     /**
28      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
29      * @param dst The address of the destination account
30      * @param amount The number of tokens to transfer
31      * @return Whether or not the transfer succeeded
32      */
33     function transfer(address dst, uint256 amount) external returns (bool success);
34 
35     /**
36      * @notice Transfer `amount` tokens from `src` to `dst`
37      * @param src The address of the source account
38      * @param dst The address of the destination account
39      * @param amount The number of tokens to transfer
40      * @return Whether or not the transfer succeeded
41      */
42     function transferFrom(
43         address src,
44         address dst,
45         uint256 amount
46     ) external returns (bool success);
47 
48     /**
49      * @notice Approve `spender` to transfer up to `amount` from `src`
50      * @dev This will overwrite the approval amount for `spender`
51      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
52      * @param spender The address of the account which may transfer tokens
53      * @param amount The number of tokens that are approved (-1 means infinite)
54      * @return Whether or not the approval succeeded
55      */
56     function approve(address spender, uint256 amount) external returns (bool success);
57 
58     /**
59      * @notice Get the current allowance from `owner` for `spender`
60      * @param owner The address of the account which owns the tokens to be spent
61      * @param spender The address of the account which may transfer tokens
62      * @return The number of tokens allowed to be spent (-1 means infinite)
63      */
64     function allowance(address owner, address spender) external view returns (uint256 remaining);
65 
66     event Transfer(address indexed from, address indexed to, uint256 amount);
67     event Approval(address indexed owner, address indexed spender, uint256 amount);
68 }
