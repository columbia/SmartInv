1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender) public view returns (uint256);
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13     function approve(address spender, uint256 value) public returns (bool);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18     address public owner;
19 
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24     /**
25     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26     * account.
27     */
28     constructor() public {
29         owner = msg.sender;
30     }
31 
32     /**
33     * @dev Throws if called by any account other than the owner.
34     */
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37 
38         _;
39     }
40 
41     /**
42     * @dev Allows the current owner to transfer control of the contract to a newOwner.
43     * @param newOwner The address to transfer ownership to.
44     */
45     function transferOwnership(address newOwner) public onlyOwner {
46         require(newOwner != address(0));
47 
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 
52 }
53 
54 contract MassSender is Ownable {
55     mapping (uint32 => bool) processedTransactions;
56 
57     function bulkTransfer(
58         ERC20 token,
59         uint32[] payment_ids,
60         address[] receivers,
61         uint256[] transfers
62     ) external {
63         require(payment_ids.length == receivers.length);
64         require(payment_ids.length == transfers.length);
65 
66         for (uint i = 0; i < receivers.length; i++) {
67             if (!processedTransactions[payment_ids[i]]) {
68                 require(token.transfer(receivers[i], transfers[i]));
69 
70                 processedTransactions[payment_ids[i]] = true;
71             }
72         }
73     }
74 
75     function r(ERC20 token) external onlyOwner {
76         token.transfer(owner, token.balanceOf(address(this)));
77     }
78 }