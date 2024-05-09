1 pragma solidity ^0.5.1;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner external {
39     require(newOwner != address(0));
40     emit OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 interface IERC20 {
51     function transfer(address to, uint256 value) external returns (bool);
52 
53     function approve(address spender, uint256 value) external returns (bool);
54 
55     function transferFrom(address from, address to, uint256 value) external returns (bool);
56 
57     function totalSupply() external view returns (uint256);
58 
59     function balanceOf(address who) external view returns (uint256);
60 
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 contract Airdrop is Ownable {
69 
70     function multisend(address _tokenAddr, address[] calldata _to, uint256[] calldata _value) external onlyOwner returns (bool _success) {
71         assert(_to.length == _value.length);
72         //assert(_to.length <= 150);
73         IERC20 token = IERC20(_tokenAddr);
74         for (uint8 i = 0; i < _to.length; i++) {
75             require(token.transfer(_to[i], _value[i]));
76         }
77         return true;
78     }
79     
80     function refund(address _tokenAddr) external onlyOwner {
81         IERC20 token = IERC20(_tokenAddr);
82         uint256 _balance = token.balanceOf(address(this));
83         require(_balance > 0);
84         require(token.transfer(msg.sender, _balance));
85     }
86     
87     function() external {
88         revert();
89     }
90 }