1 pragma solidity 0.5.4;
2 
3 
4 contract Ownable {
5     address public owner;
6     address public pendingOwner;
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10     /**
11     * @dev Throws if called by any account other than the owner.
12     */
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     /**
19      * @dev Modifier throws if called by any account other than the pendingOwner.
20      */
21     modifier onlyPendingOwner() {
22         require(msg.sender == pendingOwner);
23         _;
24     }
25 
26     constructor() public {
27         owner = msg.sender;
28     }
29 
30     /**
31      * @dev Allows the current owner to set the pendingOwner address.
32      * @param newOwner The address to transfer ownership to.
33      */
34     function transferOwnership(address newOwner) onlyOwner public {
35         pendingOwner = newOwner;
36     }
37 
38     /**
39      * @dev Allows the pendingOwner address to finalize the transfer.
40      */
41     function claimOwnership() onlyPendingOwner public {
42         emit OwnershipTransferred(owner, pendingOwner);
43         owner = pendingOwner;
44         pendingOwner = address(0);
45     }
46 }
47 
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 interface IERC20 {
54     function balanceOf(address who) external view returns (uint256);
55     function transfer(address to, uint256 value) external returns (bool);
56     function transferFrom(address from, address to, uint256 value) external returns (bool);
57 }
58 
59 contract TokenReceiver is Ownable {
60     IERC20 public token;
61 
62     event Receive(address from, uint invoiceID, uint amount);
63 
64     constructor (address _token) public {
65         require(_token != address(0));
66 
67         token = IERC20(_token);
68     }
69 
70     function receiveTokenWithInvoiceID(uint _invoiceID, uint _amount) public {
71         require(token.transferFrom(msg.sender, address(this), _amount), "");
72         
73         emit Receive(msg.sender, _invoiceID, _amount);
74     }
75 
76     function changeToken(address _token) public onlyOwner {
77         token = IERC20(_token);
78     }
79     
80     function reclaimToken(IERC20 _token, uint _amount) external onlyOwner {
81         _token.transfer(owner, _amount);
82     }
83 }