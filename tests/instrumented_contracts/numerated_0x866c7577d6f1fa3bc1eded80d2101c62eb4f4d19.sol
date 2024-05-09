1 pragma solidity ^0.4.24;
2 
3 
4 /// @title Version
5 contract Version {
6     string public semanticVersion;
7 
8     /// @notice Constructor saves a public version of the deployed Contract.
9     /// @param _version Semantic version of the contract.
10     constructor(string _version) internal {
11         semanticVersion = _version;
12     }
13 }
14 
15 
16 /**
17  * @title Ownable
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract Ownable {
22     address public owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     /**
27      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28      * account.
29      */
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     /**
43      * @dev Allows the current owner to transfer control of the contract to a newOwner.
44      * @param newOwner The address to transfer ownership to.
45      */
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0));
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 }
52 
53 
54 /**
55  * @title ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  */
58 interface ERC20 {
59     function transfer(address to, uint256 value) external returns (bool);
60     function transferFrom(address from, address to, uint256 value) external returns (bool);
61     function approve(address spender, uint256 value) external returns (bool);
62     function totalSupply() external view returns (uint256);
63     function balanceOf(address who) external view returns (uint256);
64     function allowance(address owner, address spender) external view returns (uint256);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 
70 contract SpendableWallet is Ownable {
71     ERC20 public token;
72 
73     event ClaimedTokens(
74         address indexed _token,
75         address indexed _controller,
76         uint256 _amount
77     );
78 
79     constructor(address _token, address _owner) public {
80         token = ERC20(_token);
81         owner = _owner;
82     }
83 
84     function spend(address _to, uint256 _amount) public onlyOwner {
85         require(
86             token.transfer(_to, _amount),
87             "Token transfer could not be executed."
88         );
89     }
90 
91     /// @notice This method can be used by the controller to extract mistakenly
92     ///  sent tokens to this contract.
93     /// @param _token The address of the token contract that you want to recover
94     ///  set to 0 in case you want to extract ether.
95     function claimTokens(address _token) public onlyOwner {
96         if (_token == 0x0) {
97             owner.transfer(address(this).balance);
98             return;
99         }
100 
101         ERC20 erc20token = ERC20(_token);
102         uint256 balance = erc20token.balanceOf(address(this));
103         require(
104             erc20token.transfer(owner, balance),
105             "Token transfer could not be executed."
106         );
107         emit ClaimedTokens(_token, owner, balance);
108     }
109 }