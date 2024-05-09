1 pragma solidity >=0.5.0 <0.6.0;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9     function transfer(address to, uint256 value) external returns (bool);
10 
11     function approve(address spender, uint256 value) external returns (bool);
12 
13     function transferFrom(address from, address to, uint256 value) external returns (bool);
14 
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address who) external view returns (uint256);
18 
19     function allowance(address owner, address spender) external view returns (uint256);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract Ownable {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     /**
32      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33      * account.
34      */
35     constructor () internal {
36         _owner = msg.sender;
37         emit OwnershipTransferred(address(0), _owner);
38     }
39 
40     /**
41      * @return the address of the owner.
42      */
43     function owner() public view returns (address) {
44         return _owner;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(isOwner());
52         _;
53     }
54 
55     /**
56      * @return true if `msg.sender` is the owner of the contract.
57      */
58     function isOwner() public view returns (bool) {
59         return msg.sender == _owner;
60     }
61 
62     /**
63      * @dev Allows the current owner to relinquish control of the contract.
64      * @notice Renouncing to ownership will leave the contract without an owner.
65      * It will not be possible to call the functions with the `onlyOwner`
66      * modifier anymore.
67      */
68     function renounceOwnership() public onlyOwner {
69         emit OwnershipTransferred(_owner, address(0));
70         _owner = address(0);
71     }
72 
73     /**
74      * @dev Allows the current owner to transfer control of the contract to a newOwner.
75      * @param newOwner The address to transfer ownership to.
76      */
77     function transferOwnership(address newOwner) public onlyOwner {
78         _transferOwnership(newOwner);
79     }
80 
81     /**
82      * @dev Transfers control of the contract to a newOwner.
83      * @param newOwner The address to transfer ownership to.
84      */
85     function _transferOwnership(address newOwner) internal {
86         require(newOwner != address(0));
87         emit OwnershipTransferred(_owner, newOwner);
88         _owner = newOwner;
89     }
90 }
91 
92 
93 
94 contract Distribution is Ownable {
95   IERC20 public token;
96 
97   constructor(
98     IERC20 _token
99   ) public {
100     token = _token;
101   }
102 
103   function distribute(
104     address[] memory addresses,
105     uint256[] memory amounts
106   ) public {
107     require(addresses.length == amounts.length, "Addresses and amounts do not have the same length");
108     for (uint256 i = 0; i < addresses.length; i++) {
109       token.transferFrom(msg.sender, addresses[i], amounts[i]);
110     }
111   }
112 
113   function destroy() public onlyOwner {
114     selfdestruct(msg.sender);
115   }
116 }