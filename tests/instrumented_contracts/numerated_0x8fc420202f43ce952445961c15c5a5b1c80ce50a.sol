1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     function totalSupply() public view returns (uint256);
11     function balanceOf(address _who) public view returns (uint256);
12     function transfer(address _to, uint256 _value) public returns (bool);
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14 }
15 
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23     address public owner;
24 
25 
26     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
27 
28 
29     /**
30      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31      * account.
32      */
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     /**
46      * @dev Allows the current owner to transfer control of the contract to a newOwner.
47      * @param _newOwner The address to transfer ownership to.
48      */
49     function transferOwnership(address _newOwner) public onlyOwner {
50         require(_newOwner != address(0));
51         emit OwnershipTransferred(owner, _newOwner);
52         owner = _newOwner;
53     }
54 }
55 
56 
57 /**
58  * @title Business Fund Contract
59  */
60 contract BusinessFund is Ownable {
61     ERC20Basic public vnetToken;
62 
63     event Donate(address indexed _from, uint256 _amount);
64 
65 
66     /**
67      * @dev Constructor
68      */
69     constructor(ERC20Basic _token) public {
70         vnetToken = _token;
71     }
72 
73     /**
74      * @dev Sending eth to this contract will be considered as a donation
75      */
76     function () public payable {
77         emit Donate(msg.sender, msg.value);
78     }
79 
80     /**
81      * @dev Send VNET Token
82      */
83     function sendVNET(address _to, uint256 _amount) external onlyOwner {
84         assert(vnetToken.transfer(_to, _amount));
85     }
86 
87     /**
88      * @dev Rescue compatible ERC20Basic Token
89      *
90      * @param _token ERC20Basic The address of the token contract
91      */
92     function rescueTokens(ERC20Basic _token) external onlyOwner {
93         uint256 balance = _token.balanceOf(this);
94         assert(_token.transfer(owner, balance));
95     }
96 
97     /**
98      * @dev Withdraw Ether
99      */
100     function withdrawEther() external onlyOwner {
101         owner.transfer(address(this).balance);
102     }
103 }