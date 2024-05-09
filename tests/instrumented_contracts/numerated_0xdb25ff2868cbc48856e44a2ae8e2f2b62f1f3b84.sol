1 pragma solidity 0.6.4;
2 /**
3  * @title Manage the owner for the BulkSender contract.
4  */
5 contract Ownable {
6     address private _owner;
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8     constructor() public {
9         _owner = msg.sender;
10         emit OwnershipTransferred(address(this), _owner);
11     }
12     /**
13      * Returns the address of the current owner.
14      */
15     function owner() public view returns (address) {
16         return _owner;
17     }
18     /**
19      * Throws if called by any account other than the owner.
20      */
21     modifier onlyOwner() {
22         require(msg.sender == _owner, "Ownable: the caller is not the owner");
23         _;
24     }
25     /**
26      * Sets the new address as the owner.
27      */
28     function transferOwnership(address newOwner) onlyOwner public {
29         require(newOwner != address(0), "Ownable: the new owner is the zero address");
30         emit OwnershipTransferred(_owner, newOwner);
31         _owner = newOwner;
32     }
33 }
34 /**
35  * @title Sending bulk transactions from the whitelisted wallets.
36  */
37 contract BulkSender is Ownable {
38     mapping(address => bool) whitelist;
39     /**
40      * Throws if called by any account other than the whitelisted address.
41      */
42     modifier onlyWhiteListed() {
43         require(whitelist[msg.sender], "Whitelist: the caller is not whitelisted");
44         _;
45     }
46     /**
47      * Approves the address as the whitelisted address.
48      */
49     function approve(address addr) onlyOwner external {
50         whitelist[addr] = true;
51     }
52     /**
53      * Removes the whitelisted address from the whitelist.
54      */
55     function remove(address addr) onlyOwner external {
56         whitelist[addr] = false;
57     }
58     /**
59      * Returns true if the address is the whitelisted address.
60      */
61     function isWhiteListed(address addr) public view returns (bool) {
62         return whitelist[addr];
63     }
64     /**
65      * @dev Gets the list of addresses and the list of amounts to make bulk transactions.
66      * @param addresses - address[]
67      * @param amounts - uint256[]
68      */
69     function distribute(address[] calldata addresses, uint256[] calldata amounts) onlyWhiteListed external payable  {
70         require(addresses.length > 0, "BulkSender: the length of addresses should be greater than zero");
71         require(amounts.length == addresses.length, "BulkSender: the length of addresses is not equal the length of amounts");
72         for (uint256 i; i < addresses.length; i++) {
73             uint256 value = amounts[i];
74             require(value > 0, "BulkSender: the value should be greater then zero");
75             address payable _to = address(uint160(addresses[i]));
76             _to.transfer(value);
77         }
78         require(address(this).balance == 0, "All received funds must be transfered");
79     }
80     /**
81      * @dev This contract shouldn't accept payments.
82      */
83     receive() external payable {
84         revert("This contract shouldn't accept payments.");
85     }
86 }