1 pragma solidity ^0.5.2;
2 
3 // File: @daostack/arc/contracts/schemes/PriceOracleInterface.sol
4 
5 interface PriceOracleInterface {
6 
7     function getPrice(address token) external view returns (uint, uint);
8 
9 }
10 
11 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
12 
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     /**
24      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25      * account.
26      */
27     constructor () internal {
28         _owner = msg.sender;
29         emit OwnershipTransferred(address(0), _owner);
30     }
31 
32     /**
33      * @return the address of the owner.
34      */
35     function owner() public view returns (address) {
36         return _owner;
37     }
38 
39     /**
40      * @dev Throws if called by any account other than the owner.
41      */
42     modifier onlyOwner() {
43         require(isOwner());
44         _;
45     }
46 
47     /**
48      * @return true if `msg.sender` is the owner of the contract.
49      */
50     function isOwner() public view returns (bool) {
51         return msg.sender == _owner;
52     }
53 
54     /**
55      * @dev Allows the current owner to relinquish control of the contract.
56      * @notice Renouncing to ownership will leave the contract without an owner.
57      * It will not be possible to call the functions with the `onlyOwner`
58      * modifier anymore.
59      */
60     function renounceOwnership() public onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner) public onlyOwner {
70         _transferOwnership(newOwner);
71     }
72 
73     /**
74      * @dev Transfers control of the contract to a newOwner.
75      * @param newOwner The address to transfer ownership to.
76      */
77     function _transferOwnership(address newOwner) internal {
78         require(newOwner != address(0));
79         emit OwnershipTransferred(_owner, newOwner);
80         _owner = newOwner;
81     }
82 }
83 
84 // File:@daostack/arc/contracts/test/PriceOracleMock.sol
85 
86 contract PriceOracleMock is PriceOracleInterface, Ownable {
87 
88     struct Price {
89         uint256 numerator;
90         uint256 denominator;
91     }
92 
93     // user => amount
94     mapping (address => Price) public tokenPrices;
95 
96     function getPrice(address token) public view returns (uint, uint) {
97         Price memory price = tokenPrices[token];
98         return (price.numerator, price.denominator);
99     }
100 
101     function setTokenPrice(address token, uint256 numerator, uint256 denominator) public onlyOwner {
102         tokenPrices[token] = Price(numerator, denominator);
103     }
104 }