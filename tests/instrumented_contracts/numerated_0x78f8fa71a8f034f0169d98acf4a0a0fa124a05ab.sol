1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipRenounced(address indexed previousOwner);
13     event OwnershipTransferred(
14         address indexed previousOwner,
15         address indexed newOwner
16     );
17 
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28      * @dev Throws if called by any account other than the owner.
29      */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36      * @dev Allows the current owner to relinquish control of the contract.
37      * @notice Renouncing to ownership will leave the contract without an owner.
38      * It will not be possible to call the functions with the `onlyOwner`
39      * modifier anymore.
40      */
41     function renounceOwnership() public onlyOwner {
42         emit OwnershipRenounced(owner);
43         owner = address(0);
44     }
45 
46     /**
47      * @dev Allows the current owner to transfer control of the contract to a newOwner.
48      * @param _newOwner The address to transfer ownership to.
49      */
50     function transferOwnership(address _newOwner) public onlyOwner {
51         _transferOwnership(_newOwner);
52     }
53 
54     /**
55      * @dev Transfers control of the contract to a newOwner.
56      * @param _newOwner The address to transfer ownership to.
57      */
58     function _transferOwnership(address _newOwner) internal {
59         require(_newOwner != address(0));
60         emit OwnershipTransferred(owner, _newOwner);
61         owner = _newOwner;
62     }
63 }
64 
65 
66 contract BanyanIncomeLockPosition is Ownable {
67 
68     // unlock block height 
69     uint64 public unlockBlock = 6269625;
70     // BBN token address   
71     address public tokenAddress = 0x35a69642857083BA2F30bfaB735dacC7F0bac969;
72 
73     bytes4 public transferMethodId = bytes4(keccak256("transfer(address,uint256)"));
74 
75     function takeToken(address targetAddress, uint256 amount)
76     public
77     unlocked
78     onlyOwner
79     returns (bool)
80     {
81         return tokenAddress.call(transferMethodId, targetAddress, amount);
82     }
83 
84     modifier unlocked() {
85         require(block.number >= unlockBlock, "Not unlock yet.");
86         _;
87     }
88 }